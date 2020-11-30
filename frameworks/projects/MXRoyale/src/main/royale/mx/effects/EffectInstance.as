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

package mx.effects
{

/* import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer; 

*/

import mx.effects.effectClasses.PropertyChanges;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.EffectEvent;
import mx.events.FlexEvent;

import org.apache.royale.core.IEffectTimer;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.events.ValueEvent;
import org.apache.royale.utils.Timer;

/* import mx.utils.NameUtil;
 */
use namespace mx_internal;

/**
 *  The EffectInstance class represents an instance of an effect
 *  playing on a target.
 *  Each target has a separate effect instance associated with it.
 *  An effect instance's lifetime is transitory.
 *  An instance is created when the effect is played on a target
 *  and is destroyed when the effect has finished playing. 
 *  If there are multiple effects playing on a target at the same time 
 *  (for example, a Parallel effect), there is a separate effect instance
 *  for each effect.
 * 
 *  <p>Effect developers must create an instance class
 *  for their custom effects.</p>
 *
 *  @see mx.effects.Effect
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class EffectInstance extends EventDispatcher implements IEffectInstance
{
/*     include "../core/Version.as";
 */
 
 /**
     *  @private
     *  Internal flag remembering whether the user
     *  explicitly specified a duration or not.
     */
    mx_internal var durationExplicitlySet:Boolean = false;

    /**
     *  @private
     *  If this is a "hide" effect, the EffectManager sets this flag
     *  as a reminder to hide the object when the effect finishes.
     */
    mx_internal var hideOnEffectEnd:Boolean = false;
    
    /**
     *  @private
     *  Pointer back to the CompositeEffect that created this instance.
     *  Value is null if we are not the child of a CompositeEffect
     */
    mx_internal var parentCompositeEffectInstance:EffectInstance;
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param target UIComponent object to animate with this effect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function EffectInstance(target:Object)
    {
        super();

        this.target = target;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
	    
    //----------------------------------
    //  duration
    //----------------------------------

    /**
     *  @private
     *  Storage for the duration property.
     */
    private var _duration:Number = 500;
    
    [Inspectable(category="General", defaultValue="500")]
    
    /** 
     *  @copy mx.effects.IEffectInstance#duration
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get duration():Number
    {
/*         if (!durationExplicitlySet &&
            parentCompositeEffectInstance)
        {
            return parentCompositeEffectInstance.duration;
        }
        else
        { */
            return _duration;
       /*  } */
    }
    
    /**
     *  @private
     */
    public function set duration(value:Number):void
    {
	/*   durationExplicitlySet = true;
	*/
        _duration = value;
    }

   
    /**
     *  @private
     *  Storage for the effect property.
     */
    private var _effect:IEffect;

    /**
     *  @copy mx.effects.IEffectInstance#effect
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get effect():IEffect
    {
        return _effect;
    }
    
    /**
     *  @private
     */
    public function set effect(value:IEffect):void
    {
        _effect = value;
    }
    
    //----------------------------------
    //  target
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the target property. 
     */
    private var _target:Object;

    /**
     *  @copy mx.effects.IEffectInstance#target
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get target():Object
    {
        return _target;
    }

    /**
     *  @private
     */
    public function set target(value:Object):void
    {
        _target = value;
    }
    
   
            
    /**
     *  @copy mx.effects.IEffectInstance#play()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function play():void
    {
        //playCount++;
        
        dispatchEvent(new EffectEvent(EffectEvent.EFFECT_START, false, false, this));
        
        if (target && (target is IEventDispatcher))
		{
            target.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_START, false, false, this));
		}
    }
    
    /**
     *  @copy mx.effects.IEffectInstance#end()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function end():void
    {
        //if (delayTimer)
        //    delayTimer.reset();
        //stopRepeat = true;
        finishEffect();
    }
    
    /**
     *  @copy mx.effects.IEffectInstance#finishEffect()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function finishEffect():void
    {
        //playCount = 0;
        
        dispatchEvent(new EffectEvent(EffectEvent.EFFECT_END,
            false, false, this));
        
        if (target && (target is IEventDispatcher))
        {
            target.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_END,
                false, false, this));
        }
        
        //if (target is UIComponent)
        //{
        //    UIComponent(target).effectFinished(this);
        //}
        
        //EffectManager.effectFinished(this);
    }
    
    //----------------------------------
    //  triggerEvent
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the triggerEvent property. 
     */
    private var _triggerEvent:Event;

    /**
     *  @copy mx.effects.IEffectInstance#triggerEvent
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get triggerEvent():Event
    {
        return _triggerEvent;
    }

    /**
     *  @private
     */
    public function set triggerEvent(value:Event):void
    {
        _triggerEvent = value;
    }
	
	public function initEffect(event:Event):void
    {
        triggerEvent = event;
        
        switch (event.type)
        {
            case "resizeStart":
            case "resizeEnd":
            {
                if (!durationExplicitlySet)
                    duration = 250;
                break;
            }
            
            case FlexEvent.HIDE:
            {
                target.setVisible(true, true);
                hideOnEffectEnd = true;     
                // If somebody else shows us, then cancel the hide when the effect ends
                target.addEventListener(FlexEvent.SHOW, eventHandler);      
                break;
            }
        }
    }
	
	mx_internal function eventHandler(event:Event):void
    {
        if (event.type == FlexEvent.SHOW && hideOnEffectEnd == true)
        {
            hideOnEffectEnd = false;
            event.target.removeEventListener(FlexEvent.SHOW, eventHandler);
        }
    }

    /**
     *  Current time position of the effect.
     *  This property has a value between 0 and the total duration, 
     *  which includes the Effect's <code>startDelay</code>, 
     *  <code>repeatCount</code>, and <code>repeatDelay</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get playheadTime():Number 
    {
        //return Math.max(playCount - 1, 0) * (duration + repeatDelay) +
               //(playReversed ? 0 : startDelay);
	return NaN;
    }

    /**
     * @private
     */
    public function set playheadTime(value:Number):void
    {
        //if (delayTimer && delayTimer.running)
        //{
            //delayTimer.reset();
            //if (value < startDelay)
            //{
                //delayTimer = new Timer(startDelay - value, 1);
                //delayStartTime = getTimer();
                //delayTimer.addEventListener(TimerEvent.TIMER, delayTimerHandler);
                //delayTimer.start();
            //}
            //else
            //{
                //playCount = 0;
                //play();
            //}
        //}
    }

    /**
     *  @copy mx.effects.IEffectInstance#pause()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function pause():void
    {   
        //if (delayTimer && delayTimer.running && !isNaN(delayStartTime))
        //{
            //delayTimer.stop(); // Pause the timer
            //delayElapsedTime = getTimer() - delayStartTime;
        //}
    }

    /**
     *  @copy mx.effects.IEffectInstance#stop()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function stop():void
    {   
        //if (delayTimer)
            //delayTimer.reset();
        //stopRepeat = true;
        //// Dispatch STOP event in case listeners need to handle this situation
        //// The Effect class may hinge setting final state values on whether
        //// the effect was stopped or ended.
        //dispatchEvent(new EffectEvent(EffectEvent.EFFECT_STOP,
                                     //false, false, this));        
        //if (target && (target is IEventDispatcher))
            //target.dispatchEvent(new EffectEvent(EffectEvent.EFFECT_STOP,
                                                 //false, false, this));
        //finishEffect();
    }

    /**
     *  @copy mx.effects.IEffectInstance#resume()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function resume():void
    {
        //if (delayTimer && !delayTimer.running && !isNaN(delayElapsedTime))
        //{
            //delayTimer.delay = !playReversed ? delayTimer.delay - delayElapsedTime : delayElapsedTime;
            //delayStartTime = getTimer();
            //delayTimer.start();
        //}
    }

    /**
     *  @copy mx.effects.IEffectInstance#reverse()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function reverse():void
    {
        //if (repeatCount > 0)
            //playCount = repeatCount - playCount + 1;
    }

    /**
     *  @copy mx.effects.IEffectInstance#startEffect()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function startEffect():void
    {   
        //EffectManager.effectStarted(this);
//
        //if (target is UIComponent)
        //{
            //UIComponent(target).effectStarted(this);
        //}
        //
        //if (startDelay > 0 && !playReversed)
        //{
            //delayTimer = new Timer(startDelay, 1);
            //delayStartTime = getTimer();
            //delayTimer.addEventListener(TimerEvent.TIMER, delayTimerHandler);
            //delayTimer.start();
        //}
        //else
        //{
            //play();
        //}
    }

    //----------------------------------
    //  playReversed
    //----------------------------------

    /**
     *  @private
     *  Storage for the playReversed property. 
     */
    private var _playReversed:Boolean;
    
    /**
     *  @private
     *  Used internally to specify whether or not this effect
     *  should be played in reverse.
     *  Set this value before you play the effect. 
     */
    mx_internal function get playReversed():Boolean
    {
        return _playReversed;
    }

    //----------------------------------
    //  propertyChanges
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the propertyChanges property. 
     */
    private var _propertyChanges:PropertyChanges;

    /**
     *  @copy mx.effects.IEffectInstance#propertyChanges
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get propertyChanges():PropertyChanges
    {
        return _propertyChanges;
    }

    /**
     *  @private
     */
    public function set propertyChanges(value:PropertyChanges):void
    {
        _propertyChanges = value;
    }

    
    //----------------------------------
    //  repeatCount
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the repeatCount property. 
     */
    private var _repeatCount:int = 0;

    /**
     *  @copy mx.effects.IEffectInstance#repeatCount
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get repeatCount():int
    {
        return _repeatCount;
    }
    
    /**
     *  @private
     */
    public function set repeatCount(value:int):void
    {
        _repeatCount = value;
    }
    
    //----------------------------------
    //  repeatDelay
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the repeatDelay property. 
     */
    private var _repeatDelay:int = 0;

    /**
     *  @copy mx.effects.IEffectInstance#repeatDelay
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get repeatDelay():int
    {
        return _repeatDelay;
    }
    
    /**
     *  @private
     */
    public function set repeatDelay(value:int):void
    {
        _repeatDelay = value;
    }
    
    //----------------------------------
    //  startDelay
    //----------------------------------

    /**
     *  @private
     *  Storage for the startDelay property. 
     */
    private var _startDelay:int = 0;

    /**
     *  @copy mx.effects.IEffectInstance#startDelay
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get startDelay():int
    {
        return _startDelay;
    }

    /**
     *  @private
     */
    public function set startDelay(value:int):void
    {
        _startDelay = value;
    }
}

}
