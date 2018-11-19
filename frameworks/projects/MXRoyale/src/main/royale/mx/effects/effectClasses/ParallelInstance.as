////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package mx.effects.effectClasses
{
import org.apache.royale.events.Event;
import org.apache.royale.reflection.getDefinitionByName;
import org.apache.royale.utils.Timer;

import mx.core.FlexVersion;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.effects.EffectInstance;
import mx.effects.IEffectInstance;
import mx.effects.Parallel;

use namespace mx_internal;

/**
 *  The ParallelInstance class implements the instance class
 *  for the Parallel effect.
 *  Flex creates an instance of this class when it plays a Parallel effect;
 *  you do not create one yourself.
 *
 *  @see mx.effects.Parallel
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */  
public class ParallelInstance extends CompositeEffectInstance
{
//    include "../../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param target This argument is ignored for Parallel effects.
	 *  It is included only for consistency with other types of effects.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function ParallelInstance(target:Object)
	{
		super(target);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 *  Holds the child effect instances that have already completed.
	 */
	private var doneEffectQueue:Array /* of EffectInstance */;
	
	/**
	 *  @private
	 *  Holds the child effect instances that are waiting to be replayed.
	 */
	private var replayEffectQueue:Array /* of EffectInstance */;

	/**
	 *  @private
	 */	
	private var isReversed:Boolean = false;	
			
	/**
	 *  @private
	 */	
	private var timer:Timer;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  durationWithoutRepeat
	//----------------------------------

	/**
	 *  @private
	 */
    override mx_internal function get durationWithoutRepeat():Number
    {
        var _duration:Number = 0;
        
        // Get the largest actualDuration of all of our children
        var n:int = childSets.length;
        for (var i:int = 0; i < n; i++)
        {
            var instances:Array = childSets[i];
            _duration = Math.max(instances[0].actualDuration, _duration);
        }
        
        return _duration;
    }
	

    //----------------------------------
    //  playheadTime
    //----------------------------------

    /**
     * @inheritDoc
     * 
     * In a Parallel effect, setting <code>playheadTime</code> 
     * will cause all child effects to go to that same
     * <code>playheadTime</code>. This may cause child effects to 
     * lessen their <code>startDelay</code> (if they are currently 
     * waiting to be played), start playing (if the 
     * <code>playheadTime</code> is greater than their 
     * <code>startDelay</code>), or end (if the <code>playheadTime</code> 
     * is greater than their <code>startDelay</code> plus
     * their <code>duration</code>).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function set playheadTime(value:Number):void
    {        
        // This will seek in the Parallel's instance
        super.playheadTime = value;

        var compositeDur:Number = Parallel(effect).compositeDuration;
        var firstCycleDur:Number = compositeDur + startDelay + repeatDelay;
        var laterCycleDur:Number = compositeDur + repeatDelay;
        // totalDur is only sensible/used when repeatCount != 0
        var totalDur:Number = firstCycleDur + laterCycleDur * (repeatCount - 1);
        var childPlayheadTime:Number;
        if (value <= firstCycleDur) {
            childPlayheadTime = Math.min(value - startDelay, compositeDur);
            playCount = 1;
        }
        else
        {
            if (value >= totalDur && repeatCount != 0)
            {
                childPlayheadTime = compositeDur;
                playCount = repeatCount;
            }
            else
            {
                var valueAfterFirstCycle:Number = value - firstCycleDur;
                childPlayheadTime = Math.min(childPlayheadTime, compositeDur);
                childPlayheadTime = valueAfterFirstCycle % laterCycleDur;
                playCount = 1 + valueAfterFirstCycle / laterCycleDur;
            }
        }

        // Tell all of our children to set their playheadTime
        for (var i:int = 0; i < childSets.length; i++)
        {
            var instances:Array = childSets[i];            
            var m:int = instances.length;
            for (var j:int = 0; j < m; j++)
                instances[j].playheadTime = playReversed ?
                    Math.max(0, (childPlayheadTime - 
                                 (durationWithoutRepeat - instances[j].actualDuration))) :
                    childPlayheadTime;
        }

        // Add any effects waiting on the replayQueue, which holds the
        // effects waiting to be played at the right time when reversing
        if (playReversed && replayEffectQueue != null && replayEffectQueue.length > 0)
        {
            var position:Number = durationWithoutRepeat - playheadTime;
            var numDone:int = replayEffectQueue.length;	        
            for (i = numDone - 1; i >= 0; i--)
            {
                var childEffect:EffectInstance = replayEffectQueue[i];
                
                // If the position is less than the child duration, then
                // we must be either in or past the child effect, so we 
                // should start that effect
                if (position <= childEffect.actualDuration)
                {
                    // Move the effect from the done queue back onto the active one
                    if (activeEffectQueue == null)
                        activeEffectQueue = [];
                    activeEffectQueue.push(childEffect);
                    replayEffectQueue.splice(i,1);
                    
                    childEffect.playReversed = playReversed;
                    childEffect.startEffect();
                    // Note that we've already set the playheadTime on these
                    // queued effects in the previous loop on childSets
                }
            }
        }
        
    }

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

    private static var resizeEffectType:Class;
    private static var resizeEffectLoaded:Boolean = false;
	/**
	 *  @private
	 */
	override public function addChildSet(childSet:Array):void
	{
		super.addChildSet(childSet);
		
		// Make sure that spark Resize and mx Rotate are in the beginning of the 
        // array because they need to be before any Move effects
        // TODO: There is logic at the Animation level to handle processing 
        // width/height values before any others for any animation frame. We
        // maybe be able to remove this Resize-reordering logic altogether.
		if (childSets.length > 1 && childSet.length > 0)
		{
			var compChild:CompositeEffectInstance = childSet[0] as CompositeEffectInstance;
			
            // Resize effects must run before Move effects for autoCenterTransform to 
            // work correctly
            if (!resizeEffectLoaded)
            {
                resizeEffectLoaded = true;
                try {
                    resizeEffectType = Class(getDefinitionByName("spark.effects.supportClasses.ResizeInstance"));
                } catch (e:Error)
                {
                    
                }
            }
            if (resizeEffectType && (childSet[0] is resizeEffectType ||
                (compChild != null && compChild.hasResizeInstance())))
            {
                // Remove item we just added to the end and place it at the beginning,
                // but after any other Resize effects
                
                var resizeChildSet:Array = childSets.pop();
                var insertionIndex:int = 0;
                for (var i:int = 0; i < childSets.length; ++i)
                {
                    var currentChildSet:Array = childSets[i];
                    var currentChildSetComposite:CompositeEffectInstance = 
                        currentChildSet[0] as CompositeEffectInstance;
                    if (!(currentChildSet[0] is resizeEffectType) &&
                        (!currentChildSetComposite || !currentChildSetComposite.hasResizeInstance()))
                    {
                        break;
                    }
                    ++insertionIndex;
                }
                childSets.splice(insertionIndex, 0, resizeChildSet);
            }
			// Check if the child is a Rotate and also check if it is a composite effect that has a Rotate
            else if (childSet[0] is RotateInstance || (compChild != null && compChild.hasRotateInstance()))
			{
                // Remove item we just added to the end and place it at the beginning
                childSets.unshift(childSets.pop());
			}
		}
	}
	
	/**
	 *  @private
	 */
	override public function play():void
	{
		doneEffectQueue = [];
		activeEffectQueue = [];
		replayEffectQueue = [];
		
		// Create a timer tween used to keep track of the playheadTime
		
		var checkQueueLength:Boolean = false;
		
		// Dispatch an effectStart event from the target.
		super.play();

		var n:int;
		var i:int;
		
		n = childSets.length;
		for (i = 0; i < n; i++)
		{
			var instances:Array = childSets[i];
			
			var m:int = instances.length;
			for (var j:int = 0; j < m && activeEffectQueue != null; j++)
			{
				var childEffect:EffectInstance = instances[j];
				
				// Check if the effect should play right away
				// or should be put in the replay queue.
				if (playReversed &&
					childEffect.actualDuration < durationWithoutRepeat)
				{
					replayEffectQueue.push(childEffect);
					startTimer();
				}
				else
				{
					childEffect.playReversed = playReversed;
					activeEffectQueue.push(childEffect);
				}
				
				// Block all layout, responses from web services,
				// and other background processing until the effect
				// finishes executing.
				if (childEffect.suspendBackgroundProcessing)
					UIComponent.suspendBackgroundProcessing();		

			}		
		}
		
		if (activeEffectQueue.length > 0)
		{
			// Start all of the effects in the active queue.
			// Need to make a copy of the queue first since some effects
			// (like Action effects) are immediate and will be removed
			// from the activeEffectQueue before returning from startEffect().
			var queueCopy:Array = activeEffectQueue.slice(0);
			
			for (i = 0; i < queueCopy.length; i++)
			{
				queueCopy[i].startEffect();
			}
		}
	}
	
	/**
	 *  @private
	 */
	override public function pause():void
	{	
		super.pause();
		
		// Pause every currently playing effect instance.
        if (activeEffectQueue)
        {
    		var n:int = activeEffectQueue.length;
    		for (var i:int = 0; i < n; i++)
    		{
    			activeEffectQueue[i].pause();
    		}
        }
	}

	/**
	 *  @private
	 */
	override public function stop():void
	{
		stopTimer();
		
		if (activeEffectQueue)
		{
			var queueCopy:Array = activeEffectQueue.concat();
			activeEffectQueue = null;
			var n:int = queueCopy.length;
			for (var i:int = 0; i < n; i++)
			{
				if (queueCopy[i])
					queueCopy[i].stop();
			}
		}
		
		super.stop();
	}

	/**
	 *  @private
	 */
	override public function resume():void
	{
		super.resume();
	
		// Resume every currently playing effect instance.
        if (activeEffectQueue)
        {
    		var n:int = activeEffectQueue.length;
    		for (var i:int = 0; i < n; i++)
    		{
    			activeEffectQueue[i].resume();
    		}
        }
	}
		
	/**
	 *  @private
	 */
	override public function reverse():void
	{
		super.reverse();
		
		var n:int;
		var i:int;
		
		if (isReversed)
		{
			// We don't care about anything in the done queue.
			// Just reverse all the active ones.
			
			n = activeEffectQueue.length;
			for (i = 0; i < n; i++)
			{
				activeEffectQueue[i].reverse();
			} 
			
			stopTimer();
		}
		else
		{
			replayEffectQueue = doneEffectQueue.splice(0);
		
			// Reverse all of the active ones.
			// Plus, setup a timer to check if we reach any done ones.
			n = activeEffectQueue.length;
			for (i = 0; i < n; i++)
			{
				activeEffectQueue[i].reverse();
			} 
			
			startTimer();
		}
		
		isReversed = !isReversed;
	}
	
	/**
	 *  Interrupts any effects that are currently playing, skips over
	 *  any effects that haven't started playing, and jumps immediately
	 *  to the end of the composite effect.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override public function end():void
	{
		endEffectCalled = true;
		stopTimer();
		
		if (activeEffectQueue)
		{
			var queueCopy:Array = activeEffectQueue.concat();
			activeEffectQueue = null;
			var n:int = queueCopy.length;
			for (var i:int = 0; i < n; i++)
			{
				if (queueCopy[i])
					queueCopy[i].end();
			}
		}
		
		super.end();
	}
	
	/**
	 *  Each time a child effect of SequenceInstance or ParallelInstance
	 *  finishes, Flex calls the <code>onEffectEnd()</code> method.
	 *  For SequenceInstance, it plays the next effect.
	 *  In ParallelInstance, it keeps track of all the 
	 *  effects until all of them have finished playing. 
	 *  If you create a subclass of CompositeEffect, you must implement this method.
         *
         * @param childEffect A child effect that has finished. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	override protected function onEffectEnd(childEffect:IEffectInstance):void
	{
		// Each child effect notifies us when it is finished.  Remove
		// the notifying child from childSets, so that the end()
		// method doesn't call it.  When the last child notifies
		// us that it's finished, notify our listener that we're finished.

		// Resume the background processing that was suspended earlier
		if (Object(childEffect).suspendBackgroundProcessing)
			UIComponent.resumeBackgroundProcessing();

		// See endEffect, above.
		
		if (endEffectCalled || activeEffectQueue == null)
			return;
			
		var n:int = activeEffectQueue.length;	
		for (var i:int = 0; i < n; i++)
		{
			if (childEffect == activeEffectQueue[i])
			{
				doneEffectQueue.push(childEffect);
				activeEffectQueue.splice(i, 1);
				break;
			}
		}	
		
		if (n == 1)
		{
			// Note: This event must be dispatched *before* checking for
			// actualCachePolicy below so that the listener has a chance to set
			// it to "on".
			finishRepeat();
		}
	}
		
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  @private
	 */	
	private function startTimer():void
	{
		if (!timer)
		{
			timer = new Timer(10);
			timer.addEventListener(Timer.TIMER, timerHandler);
		}
		timer.start();
	}
	
	/**
	 *  @private
	 */	
	private function stopTimer():void
	{
		if (timer)
			timer.reset();
	}
	
	/**
	 *  @private
	 *  Used internally to figure out if we should be playing an effect
	 *  from the replay queue.
	 */	
	private function timerHandler(event:Event):void
	{
		// Assume we are playing in reverse
		// invert the playheadTime
		var position:Number = durationWithoutRepeat - playheadTime;
		var numDone:int = replayEffectQueue.length;	
		
		if (numDone == 0)
		{
			stopTimer();
			return;
		}
		
		for (var i:int = numDone - 1; i >= 0; i--)
		{
			var childEffect:EffectInstance = replayEffectQueue[i];
			
			if (position <= childEffect.actualDuration)
			{
				// Move the effect from the done queue back onto the active one
                if (activeEffectQueue == null)
                    activeEffectQueue = [];
				activeEffectQueue.push(childEffect);
				replayEffectQueue.splice(i,1);
				
				childEffect.playReversed =playReversed;
				childEffect.startEffect();
				 
			}
		}
		
	}

}

}
