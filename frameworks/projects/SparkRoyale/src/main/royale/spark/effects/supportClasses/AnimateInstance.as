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

package spark.effects.supportClasses
{
import org.apache.royale.utils.Timer;

import mx.core.IVisualElement;
import mx.core.IVisualElementContainer;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.effects.Effect;
import mx.effects.EffectInstance;
import mx.events.EffectEvent;
import mx.managers.SystemManager;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.styles.IStyleClient;

import spark.effects.animation.Animation;
import spark.effects.animation.IAnimationTarget;
import spark.effects.animation.Keyframe;
import spark.effects.animation.MotionPath;
import spark.effects.animation.SimpleMotionPath;
import spark.effects.easing.IEaser;
import spark.effects.interpolation.IInterpolator;
//import spark.primitives.supportClasses.GraphicElement;

import org.apache.royale.events.Event;

use namespace mx_internal;

//--------------------------------------
//  Other metadata
//--------------------------------------

[ResourceBundle("sparkEffects")]

/**
 *  The AnimateInstance class implements the instance class for the
 *  Animate effect. Flex creates an instance of this class when
 *  it plays a Animate effect; you do not create one yourself.
 *
 *  @see spark.effects.Animate
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class AnimateInstance extends EffectInstance implements IAnimationTarget
{
    /**
     *  @private
     */
    public var animation:Animation;
    
    /**
     *  Constructor.
     *
     *  @param target The Object to animate with this effect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function AnimateInstance(target:Object)
    {
        super(target);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    /**
     *  Tracks whether each property of the target is an actual 
     *  property or a style. We determine this dynamically by
     *  simply checking whether the property is 'in' the target.
     *  If not, we check whether it is a valid style, and otherwise
     *  throw an error.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private var isStyleMap:Object = {};
    
    /**
     *  @private.
     *  Used internally to hold the value of the new playhead position
     *  if the animation doesn't currently exist.
     */
    private var _seekTime:Number = 0;

    private var reverseAnimation:Boolean;
    
    private var needsRemoval:Boolean;

    /**
     * @private
     * Track number of update listeners for optimization purposes
     */
    private var numUpdateListeners:int = 0;
    
    
    /**
     *  @private
     *  Used for accessing localized Error messages.
     */
    private var resourceManager:IResourceManager =
                                    ResourceManager.getInstance();
    
    /**
     * @private
     * Cache these values when disabling constraints, to correctly reset
     * width/height values when we finish
     */
    private var oldWidth:Number;
    private var oldHeight:Number;

    /**
     * @private
     * Used to selectively disable constraints that are being animated by
     * their underlying values because the constraint values are not
     * valid in both states of a transition. For example, if left is set
     * in only one state, then we disable left and animate x instead,
     * re-enabling left when the effect is finished.
     */
    private var disabledConstraintsMap:Object;

    //--------------------------------------------------------------------------
    //
    // Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    //override public function set suspendBackgroundProcessing(value:Boolean):void
    //{
        //// Noop: this flag causes Flex 4 effects to break because they
        //// depend on the layout validation process that the flag suppresses
    //}

    private var _motionPaths:Vector.<MotionPath>;
    /**
     *  @copy spark.effects.Animate#motionPaths
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get motionPaths():Vector.<MotionPath>
    {
        return _motionPaths;
    }
    public function set motionPaths(value:Vector.<MotionPath>):void
    {
        // Only set the list to the given value if we have a 
        // null list to begin with. Otherwise, we've already
        // set up the list once and don't need to do it again
        // (for example, in a repeating effect).
        if (!_motionPaths)
            _motionPaths = value;
    }
    
    /**
     *  If <code>true</code>, the effect retains its target 
     *  during a transition and removes it when finished. 
     *  This capability applies specifically to effects like
     *  Fade which act on targets that go away at the end of the
     *  transition and removes the need to supply a RemoveAction or similar
     *  effect to manually keep the item around and remove it when the
     *  transition completes. 
     * 
     *  <p>To use this capability, subclasses
     *  should set this variable to <code>true</code> and also expose the <code>parent</code>
     *  property in their <code>affectedProperties</code> Array so 
     *  that the effect instance has enough information about the target
     *  and container to do the job.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected var autoRemoveTarget:Boolean = false;
        
    /**
     * @copy spark.effects.Animate#disableLayout
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var disableLayout:Boolean;
    
    private var _easer:IEaser;    
    /**
     * @copy spark.effects.Animate#easer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function set easer(value:IEaser):void
    {
        _easer = value;
    }
    /**
     *  @private
     */
    public function get easer():IEaser
    {
        return _easer;
    }
    
    private var _interpolator:IInterpolator;
    /**
     * @copy spark.effects.Animate#interpolator
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function set interpolator(value:IInterpolator):void
    {
        _interpolator = value;
        
    }
    /**
     *  @private
     */
    public function get interpolator():IInterpolator
    {
        return _interpolator;
    }
    
    private var _repeatBehavior:String;
    /**
     * @copy spark.effects.Animate#repeatBehavior
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function set repeatBehavior(value:String):void
    {
        _repeatBehavior = value;
    }
    /**
     *  @private
     */
    public function get repeatBehavior():String
    {
        return _repeatBehavior;
    }
            
    //----------------------------------
    //  playReversed
    //----------------------------------

    /**
     *  @private
     */
    //override mx_internal function set playReversed(value:Boolean):void
    //{
        //super.playReversed = value;
        //
        //if (value && animation)
            //animation.reverse();
        //
        //reverseAnimation = value;
    //}

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  playheadTime
    //----------------------------------
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function get playheadTime():Number 
    {
        return animation ? animation.playheadTime : _seekTime;
    }
    /**
     * @private
     */
    override public function set playheadTime(value:Number):void
    {
        if (animation)
            animation.playheadTime = value;
        _seekTime = value;
    } 
    

    /**
     *  @private
     */
    override public function pause():void
    {
        super.pause();
        
        if (animation)
            animation.pause();
    }

    /**
     *  @private
     */
    override public function stop():void
    {
        super.stop();
        
        if (animation)
            animation.stop();
    }   
    
    /**
     *  @private
     */
    override public function resume():void
    {
        super.resume();
    
        if (animation)
            animation.resume();
    }
        
    /**
     *  @private
     */
    override public function reverse():void
    {
        super.reverse();
    
        if (animation)
            animation.reverse();
        
        reverseAnimation = !reverseAnimation;
    }
    
    /**
     *  @private
     *  Interrupts an effect that is currently playing,
     *  and immediately jumps to the end of the effect.
     *  Calls the <code>Tween.endTween()</code> method
     *  on the <code>tween</code> property. 
     *  This method implements the method of the superclass. 
     *
     *  <p>If you create a subclass of TweenEffectInstance,
     *  you can optionally override this method.</p>
     *
     *  <p>The effect dispatches the <code>effectEnd</code> event.</p>
     *
     *  @see mx.effects.EffectInstance#end()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function end():void
    {
        // Jump to the end of the animation.
        if (animation)
        {
            animation.end();
            animation = null;
        }

        super.end();
    }
        
    //--------------------------------------------------------------------------
    //
    // Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function startEffect():void
    {  
        // This override removes EffectManager.effectStarted() to avoid use of
        // mx_internal. New effects are not currently triggerable, so
        // this should not matter
                 
        if (target is UIComponent)
        {
            //UIComponent(target).effectStarted(this);
        }

        if (autoRemoveTarget)
            addDisappearingTarget();

        play();
    }
    
    /**
     * Starts this effect. Performs any final setup for each property
     * from/to values and starts an Animation that will update that property.
     * 
     * @private
     */
    override public function play():void
    {
        super.play();

        if (!motionPaths || motionPaths.length == 0)
        {
            // nothing to do; at least schedule the effect to end after
            // the specified duration
            var timer:Timer = new Timer(duration, 1);
            timer.addEventListener("timer", noopAnimationHandler);
            timer.start();
            return;
        }
            
        isStyleMap = new Array(motionPaths.length);        
    
        // TODO (chaase): avoid setting up animations on properties whose
        // from/to values are the same. Not worth the cycles, but also want
        // to avoid triggering any side effects when we're not actually changing
        // values
        var addWidthMP:Boolean;
        var addHeightMP:Boolean;
        var i:int;
        var j:int;
        for (i = 0; i < motionPaths.length; ++i)
        {
            var mp:MotionPath = MotionPath(motionPaths[i]);
            var keyframes:Vector.<Keyframe> = mp.keyframes;
            if (!keyframes)
                continue;
            // Account for animating constraints where one or both state values
            // are invalid; use underlying properties of x, y, width, height
            // instead, or in addition
            if (propertyChanges != null &&
                (mp.property == "left" || mp.property == "right" ||
                 mp.property == "top" || mp.property == "bottom" ||
                 mp.property == "percentWidth" || mp.property == "percentHeight" ||
                 mp.property == "horizontalCenter" || mp.property == "verticalCenter"))
            {
                // We need to substitute an underlying property if the animation is
                // trying to automatically use and animate between the constraint
                // values in the states, but one or both values are invalid
                if (!isValidValue(propertyChanges.start[mp.property]) ||
                    !isValidValue(propertyChanges.end[mp.property]) &&
                    keyframes.length == 2 && !isValidValue(keyframes[0].value) &&
                    !isValidValue(keyframes[1].value))
                {
                    if (mp.property == "percentWidth")
                        mp.property = "width";
                    else if (mp.property == "percentHeight")
                        mp.property = "height";
                    else if (mp.property == "left" || mp.property == "right" || 
                        mp.property == "horizontalCenter")
                    {
                        if (!disabledConstraintsMap)
                            disabledConstraintsMap = new Object();
                        disabledConstraintsMap[mp.property] = true;
                        mp.property = "x";
                        if (isValidValue(propertyChanges.start["width"]) &&
                            isValidValue(propertyChanges.end["width"]) &&
                            propertyChanges.start["width"] != propertyChanges.end["width"])
                        {
                            // add motionPath to account for width changing between states
                            addWidthMP = true;
                        }
                    }
                    else
                    {
                        if (!disabledConstraintsMap)
                            disabledConstraintsMap = new Object();
                        disabledConstraintsMap[mp.property] = true;
                        mp.property = "y";
                        if (isValidValue(propertyChanges.start["height"]) &&
                            isValidValue(propertyChanges.end["height"]) &&
                            propertyChanges.start["height"] != propertyChanges.end["height"])
                        {
                            // add motionPath to account for height changing between states
                            addHeightMP = true;
                        }
                    }
                }
            }
            if (interpolator)
                mp.interpolator = interpolator;
            // adjust effect duration to be the max of all MotionPath keyframe times
            // duration==0 is special-case, because the user (or an internal request)
            // specifically asked the effect to be of zero duration
            // TODO (chaase): Currently we do not adjust *down* for smaller duration
            // MotionPaths. This is because we do not distinguish between
            // SimpleMotionPath objects (which are created with fake durations of 1,
            // knowing that they will derive their duration from their effects) and
            // actual keyframe-based MotionPaths.
            if (duration > 0)
                for (j = 0; j < keyframes.length; ++j)
                    if (!isNaN(keyframes[j].time))
                        duration = Math.max(duration, keyframes[j].time);

        }
        if (addWidthMP)
            motionPaths.push(new SimpleMotionPath("width"));
        if (addHeightMP)
            motionPaths.push(new SimpleMotionPath("height"));

        animation = new Animation(duration);
        animation.animationTarget = this;
        animation.motionPaths = motionPaths;
        
        if (reverseAnimation)
            animation.playReversed = true;
        animation.interpolator = interpolator;
        animation.repeatCount = repeatCount;
        animation.repeatDelay = repeatDelay;
        animation.repeatBehavior = repeatBehavior;
        animation.easer = easer;
        animation.startDelay = startDelay;
        
        animation.play();
        if (_seekTime > 0)
            animation.playheadTime = _seekTime;
    }

    /**
     *  @private
     *  Set the values in the given animation on the properties held in
     *  motionPaths. This is called by the update and end 
     *  functions, which are called by the Animation during the animation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function applyValues(anim:Animation):void
    {
        for (var i:int = 0; i < motionPaths.length; ++i)
        {
            var prop:String = motionPaths[i].property;
            setValue(prop, anim.currentValue[prop]);
        }
    }
    
    // TODO (chaase): This function appears in multiple places. Maybe
    // put it in some util class instead?
    /**
     * @private
     * 
     * Utility function to determine whether a given value is 'valid',
     * which means it's either a Number and it's not NaN, or it's not
     * a Number and it's not null
     */
    private function isValidValue(value:Object):Boolean
    {
        return ((value is Number && !isNaN(Number(value))) ||
            (!(value is Number) && value !== null));
    }
    
    /**
     * Walk the motionPaths looking for null values. A null indicates
     * that the value should be replaced by the current value or one that
     * is calculated from the other value and a supplied delta value.
     * 
     * @return Boolean whether this call changed any values in the list
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private function finalizeValues():Boolean
    {
        var changedValues:Boolean = false;
        var j:int;
        var prevValue:Object;
        for (var i:int = 0; i < motionPaths.length; ++i)
        {
            var motionPath:MotionPath = 
                MotionPath(motionPaths[i]);
            // set the first value (if invalid) to the current value
            // in the target
            var keyframes:Vector.<Keyframe> = motionPath.keyframes;
            if (!keyframes || keyframes.length == 0)
                continue;
            if (!isValidValue(keyframes[0].value))
            {
                if (keyframes.length > 0 &&
                    isValidValue(keyframes[1].valueBy) &&
                    isValidValue(keyframes[1].value))
                {
                    keyframes[0].value = motionPath.interpolator.decrement(
                        keyframes[1].value, keyframes[1].valueBy);
                }
                else
                {
                    // An interrupting transition effect should grab its start
                    // values from the propertyChanges array, which has been populated
                    // in UIComponent.commitCurrentState() with the values of target
                    // objects when the previous transition was interrupted. The
                    // current values of the objects, from getCurrentValue(), may be
                    // set to the end values of that previous transition, so we do not
                    // want those values for the animation
                    //if ((playReversed || Effect(effect).transitionInterruption) && 
                    if ((playReversed) && 
                        propertyChanges &&
                        propertyChanges.start[motionPath.property] !== undefined)
                    {
                        keyframes[0].value = propertyChanges.start[motionPath.property];
                    }
                    else
                    {
                        keyframes[0].value = getCurrentValue(motionPath.property);
                    }
                }
            }
            // set any other invalid values based on information in surrounding
            // keyframes
            prevValue = keyframes[0].value;
            for (j = 1; j < keyframes.length; ++j)
            {
                var kf:Keyframe = Keyframe(keyframes[j]);
                if (!isValidValue(kf.value))
                {
                    if (isValidValue(kf.valueBy))
                        kf.value = motionPath.interpolator.increment(prevValue, kf.valueBy);
                    else
                    {
                        // if next keyframe has value and valueBy, use them
                        if (j <= (keyframes.length - 2) &&
                            isValidValue(keyframes[j+1].value) &&
                            isValidValue(keyframes[j+1].valueBy))
                        {
                            kf.value = motionPath.interpolator.decrement(
                                keyframes[j+1].value, keyframes[j+1].valueBy);
                        }
                        else if (j == (keyframes.length - 1) &&
                            propertyChanges &&
                            propertyChanges.end[motionPath.property] !== undefined)
                        {
                            // special case for final keyframe - use state value if it exists
                            kf.value = propertyChanges.end[motionPath.property];
                        }
                        else
                        {
                            // otherwise, just use previous keyframe value
                            kf.value = prevValue;
                        }
                    }
                }
                prevValue = kf.value;
            }
        }
        return changedValues;
        
    }

    /**
     *  @private
     *  This function is called by subclasses during the play() function
     *  to add an animation to the current set of <code>motionPaths</code>.
     *  The animation will be set up on the named constraint if the constraint
     *  is in the <code>propertyChanges</code> array (which is only true during
     *  transitions for properties/styles exposed by the effect) and the
     *  value of that constraint is different between the start and end states.
     */ 
    protected function setupConstraintAnimation(constraintName:String):void
    {
        var startVal:* = propertyChanges.start[constraintName];
        var endVal:* = propertyChanges.end[constraintName];
        if (startVal !== undefined && endVal !== undefined &&
            startVal !== null && endVal !== null &&
            !isNaN(startVal) && !isNaN(endVal) &&
            startVal != endVal)
        {
            motionPaths.push(new SimpleMotionPath(constraintName, startVal, endVal));
        }
    }

    /**
     *  @private
     *  Called internally to handle start events for the animation.
     *  If you override this method, ensure that you call the super method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function animationStart(animation:Animation):void
    {
        // Wait until the underlying Animation actually starts (after
        // any startDelay) to cache constraints and disable layout. This
        // avoids problems with doing this too early and affecting other
        // effects that are running before this one.
        if (disableLayout)
        {
            setupParentLayout(false);
            cacheConstraints();
        }
        else if (disabledConstraintsMap)
        {
            for (var constraint:String in disabledConstraintsMap)
                cacheConstraint(constraint);
            disabledConstraintsMap = null;
        }

        finalizeValues();
    }
    
    /**
     *  @private
     *  Called internally to handle update events for the animation.
     *  If you override this method, ensure that you call the super method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function animationUpdate(animation:Animation):void
    {
        applyValues(animation);
        if (numUpdateListeners > 0)
        {
            // Only bother dispatching this event if there are listeners. This avoids
            // unnecessary overhead for the common case of no listeners on this frequent
            // event
            //var event:EffectEvent = new EffectEvent(EffectEvent.EFFECT_UPDATE);
            //event.effectInstance = this;
            //dispatchEvent(event);
        }
    }
    
    /**
     *  @private
     *  Called internally to handle repeat events for the animation.
     *  If you override this method, ensure that you call the super method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function animationRepeat(animation:Animation):void
    {
        //var event:EffectEvent = new EffectEvent(EffectEvent.EFFECT_REPEAT);
        //event.effectInstance = this;
        //dispatchEvent(event);
    }    

    private function animationCleanup():void
    {
        if (disableLayout)
        {
            reenableConstraints();
            if (disableLayout)
                setupParentLayout(true);
        }
    }
    
    /**
     *  @private
     *  Called internally to handle end events for the animation. 
     *  If you override this method, ensure that you call the super method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function animationEnd(animation:Animation):void
    {
        animationCleanup();
        finishEffect();
    }

    /**
     *  @private
     *  Called internally to handle stop events for the animation. 
     *  If you override this method, ensure that you call the super method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function animationStop(animation:Animation):void
    {
        animationCleanup();
    }

    private function noopAnimationHandler(event:Event):void
    {
        finishEffect();
    }

    /**
     * @private
     * Track number of listeners to update event for optimization purposes
     */
    //override public function addEventListener(type:String, listener:Function, 
        //useCapture:Boolean=false, priority:int=0, 
        //useWeakReference:Boolean=false):void
    //{
        //super.addEventListener(type, listener, useCapture, priority, 
            //useWeakReference);
        //if (type == EffectEvent.EFFECT_UPDATE)
            //++numUpdateListeners;
    //}
    //
    ///**
     //* @private
     //* Track number of listeners to update event for optimization purposes
     //*/
    //override public function removeEventListener(type:String, listener:Function, 
        //useCapture:Boolean=false):void
    //{
        //super.removeEventListener(type, listener, useCapture);
        //if (type == EffectEvent.EFFECT_UPDATE)
            //--numUpdateListeners;
    //}
    
    /**
     *  @private
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override public function finishEffect():void
    {
        if (autoRemoveTarget)
            removeDisappearingTarget();
        super.finishEffect();
    }

    /**
     * Adds a target which is not in the state we are transitioning
     * to. This is the partner of removeDisappearingTarget(), which removes
     * the target when this effect is finished if necessary.
     * Note that if a RemoveAction effect is playing in a CompositeEffect,
     * then the adding/removing is already happening and this function
     * will noop the add.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private function addDisappearingTarget():void
    {
        needsRemoval = false;
        if (propertyChanges)
        {
            // Check for non-null parent ensures that we won't double-remove
            // items, such as if there is a RemoveAction effect working on
            // the same target
            if ("parent" in target && !target.parent)
            {
                var parentStart:* = propertyChanges.start["parent"];
                var parentEnd:* = propertyChanges.end["parent"];
                if (playReversed)
                {
                    var tmp:* = parentStart;
                    parentStart = parentEnd;
                    parentEnd = tmp;
                }
                if (parentStart && !parentEnd && 
                    (parentStart is IVisualElementContainer || parentStart is SystemManager))
                {
                    var startIndex:* = !playReversed ? 
                        propertyChanges.start["index"] :
                        propertyChanges.end["index"];
                    if (parentStart is IVisualElementContainer)
                    {
                        var startContainer:IVisualElementContainer = 
                            IVisualElementContainer(parentStart);
                        if (startIndex !== undefined && startIndex <= (startContainer as UIComponent).numElements)
                            (startContainer as UIComponent).addElementAt(
                                target as UIComponent, int(startIndex));
                        else
                            (startContainer as UIComponent).addElement(target as UIComponent);
                    }
                    else
                    {
                        var startMgr:SystemManager = parentStart as SystemManager;
                        if (startIndex !== undefined && startIndex <= startMgr.numChildren)
                            startMgr.addChildAt(target as UIComponent, int(startIndex));
                        else
                            startMgr.addChild(target as UIComponent);
                    }
                    // GraphicElements may delay parenting their underlying displayObject until
                    // a layout pass, so let's force it to make sure we're ready to go
                    // TODO (chaase): this should probably happen as a part of applyStartValues()
                    // instead, then we already force the layout to happen. Also, this might
                    // enable this auto-add functionality to work for Sequence instead of just
                    // Parallel effects, since applyStartValues() is called at the outer effect
                    // start time, not just at the inner instance start time.
                    //if (target is GraphicElement)
                        //GraphicElement(target).validateNow();
                    needsRemoval = true;
                }
            }
        }
    }

    /**
     * Removes a target which is not in the state we are transitioning
     * to. This is the partner of addDisappearingTarget(), which re-adds
     * the target when this effect is played if necessary.
     * Note that if a RemoveAction effect is playing in a CompositeEffect,
     * then the adding/removing is already happening and this function
     * will noop the removal.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private function removeDisappearingTarget():void
    {
        if (needsRemoval && propertyChanges)
        {
            // Check for non-null parent ensures that we won't double-remove
            // items, such as if there is a RemoveAction effect working on
            // the same target
            if ("parent" in target && target.parent)
            {
                var parentStart:* = propertyChanges.start["parent"];
                var parentEnd:* = propertyChanges.end["parent"];
                if (playReversed)
                {
                    var tmp:* = parentStart;
                    parentStart = parentEnd;
                    parentEnd = tmp;
                }
                if (parentStart && !parentEnd)
                {
                    if (parentStart is UIComponent)
                        UIComponent(parentStart).removeElement(target as UIComponent);
                    else
                        parentStart.removeChild(target);
                }
            }
        }
    }

    private var constraintsHolder:Object;
    
    // TODO (chaase): Use IConstraintClient for this
    private function reenableConstraint(name:String):void
    {
        var value:* = constraintsHolder[name];
        if (value !== undefined)
        {
            if (name in target)
                target[name] = value;
            else
                target.setStyle(name, value);
            delete constraintsHolder[name];
        }
    }
    
    private function reenableConstraints():void
    {
        // Only bother if constraintsHolder is non-null; otherwise
        // there must have been no constraints to worry about
        if (constraintsHolder)
        {
            var left:* = reenableConstraint("left");
            var right:* = reenableConstraint("right");
            var top:* = reenableConstraint("top");
            var bottom:* = reenableConstraint("bottom");
            reenableConstraint("horizontalCenter");
            reenableConstraint("verticalCenter");
            reenableConstraint("baseline");
            constraintsHolder = null;
            if (left != undefined && right != undefined && "explicitWidth" in target)
                target.explicitWidth = oldWidth;            
            if (top != undefined && bottom != undefined && "explicitHeight" in target)
                target.explicitHeight = oldHeight;
        }
    }
    
    // TODO (chaase): Use IConstraintClient for this
    private function cacheConstraint(name:String):*
    {
        var isProperty:Boolean = (name in target);
        var value:*;
        if (isProperty)
            value = target[name];
        else
            value = target.getStyle(name);
        if (!isNaN(value) && value != null)
        {
            if (!constraintsHolder)
                constraintsHolder = new Object();
            constraintsHolder[name] = value;
            // Now disable it - it will be re-enabled when effect finishes
            if (isProperty)
                target[name] = NaN;
            else if (target is IStyleClient)
                target.setStyle(name, undefined);
        }
        return value;
    }
    
    private function cacheConstraints():void
    {
        var left:* = cacheConstraint("left");
        var right:* = cacheConstraint("right");
        var top:* = cacheConstraint("top");
        var bottom:* = cacheConstraint("bottom");
        cacheConstraint("verticalCenter");
        cacheConstraint("horizontalCenter");
        cacheConstraint("baseline");
        if (left != undefined && right != undefined && "explicitWidth" in target)
        {
            var w:Number = target.width;    
            oldWidth = target.explicitWidth;
            target.width = w;
        }
        if (top != undefined && bottom != undefined && "explicitHeight" in target)
        {
            var h:Number = target.height;
            oldHeight = target.explicitHeight;
            target.height = h;
        }
    }

    /**
     *  @private
     *  Utility function to handle situation where values may be queried or
     *  set on the target prior to completely setting up the effect's
     *  motionPaths data values (from which the styleMap is created)
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function setupStyleMapEntry(property:String):void
    {
        // TODO (chaase): Find a better way to set this up just once
        if (isStyleMap[property] == undefined)
        {
            if (property in target)
            {
                isStyleMap[property] = false;
            }
            else
            {
                try {
                    target.getStyle(property);
                    isStyleMap[property] = true;
                }
                catch (err:Error)
                {
                    throw new Error(resourceManager.getString("sparkEffects", 
                        "propNotPropOrStyle", [property, target, err])); 
                }
            }            
        }
    }
    
    /**
     *  Utility function that sets the named property on the target to
     *  the given value. Handles setting the property as either a true
     *  property or a style.
     *  @private
     */
    protected function setValue(property:String, value:Object):void
    {
        // TODO (chaase): Find a better way to set this up just once
        setupStyleMapEntry(property);
        if (!isStyleMap[property])
            target[property] = value;
        else
            target.setStyle(property, value);
    }

    /**
     *  Utility function that gets the value of the named property on 
     *  the target. Handles getting the value of the property as either a true
     *  property or a style.
     *  @private
     */
    protected function getCurrentValue(property:String):*
    {
        // TODO (chaase): Find a better way to set this up just once
        setupStyleMapEntry(property);
        if (!isStyleMap[property])
            return target[property];
        else
            return target.getStyle(property);
    }

    /**
     * Enables or disables autoLayout in the target's container.
     * This is used to disable layout during the course of an animation,
     * and to re-enable it when the animation finishes.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private function setupParentLayout(enable:Boolean):void
    {
        var parent:* = null;
        if ("parent" in target && target.parent)
        {
            parent = target.parent;
        }
        
        if (parent && ("autoLayout" in parent))
            parent.autoLayout = enable;
    }
}
}
