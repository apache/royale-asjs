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
package spark.effects
{
import mx.core.mx_internal;
import mx.effects.Effect;
import mx.effects.IEffectInstance;
import mx.events.EffectEvent;

import spark.effects.animation.Animation;
import spark.effects.animation.MotionPath;
import spark.effects.animation.RepeatBehavior;
import spark.effects.easing.IEaser;
import spark.effects.easing.Sine;
import spark.effects.interpolation.IInterpolator;
import spark.effects.supportClasses.AnimateInstance;

use namespace mx_internal;

//--------------------------------------
//  Excluded APIs
//--------------------------------------

// Exclude suspendBackgroundProcessing for now because the Flex 4
// effects depend on the layout validation work that the flag suppresses
[Exclude(name="suspendBackgroundProcessing", kind="property")]


[DefaultProperty("motionPaths")]

/**
 * Dispatched every time the effect updates the target.
 *
 * @eventType mx.events.EffectEvent.EFFECT_UPDATE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Event(name="effectUpdate", type="mx.events.EffectEvent")]

/**
 * Dispatched when the effect begins a new repetition, for
 * any effect that is repeated more than once.
 * Flex also dispatches an <code>effectUpdate</code> event 
 * for the effect at the same time.
 *
 * @eventType mx.events.EffectEvent.EFFECT_REPEAT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
[Event(name="effectRepeat", type="mx.events.EffectEvent")]
//not implemented
[Event(name="effectEnd", type="mx.events.EffectEvent")]


/**
 * This Animate effect animates an arbitrary set of properties between values. 
 * Specify the properties and values to animate by setting the <code>motionPaths</code> property. 
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;s:Animate&gt;</code> tag
 *  inherits all of the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:Animate
 *    <b>Properties</b>
 *    id="ID"
 *    disableLayout="false"
 *    easer="{spark.effects.easing.Sine(.5)}"
 *    interpolator="NumberInterpolator"
 *    motionPaths="no default"
 *    repeatBehavior="loop"
 *  /&gt;
 *  </pre>
 *
 *  @see spark.effects.supportClasses.AnimateInstance
 *
 *  @includeExample examples/AnimateEffectExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class Animate extends Effect
{
    //include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

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
    public function Animate(target:Object = null)
    {
        super(target);
          
        instanceClass = AnimateInstance;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    // Cached version of the affected properties. By default, we simply return
    // the list of properties specified in the motionPaths Vector.
    // Subclasses should override getAffectedProperties() if they wish to 
    // specify a different set.
    private var affectedProperties:Array = null;

    // Cached version of the relevant styles. By default, we simply return
    // the list of properties specified in the motionPaths Vector.
    // Subclasses should override relevantStyles() if they wish to 
    // specify a different set.
    private var _relevantStyles:Array = null;

    // Cached default easer. We only need one of these, so we cache this static
    // object to be reused by any Animate instances that do not specify
    // a custom easer.
    private static var defaultEaser:IEaser = new Sine(.5); 

    // Used to optimize event dispatching: only send out updated events if
    // there is someone listening
    private var numUpdateListeners:int = 0;
    

    //--------------------------------------------------------------------------
    //
    // Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  motionPaths
    //----------------------------------
    /**
     * @private
     * Storage for the motionPaths property. 
     */
    private var _motionPaths:Vector.<MotionPath>;
    /**
     * A Vector of MotionPath objects, each of which holds the
     * name of a property being animated and the values that the property
     * takes during the animation. 
     * This Vector takes precedence over
     * any properties declared in subclasses of Animate.
     * For example, if this Array is set directly on a Move effect, 
     * then any properties of the Move effect, such as <code>xFrom</code>, are ignored. 
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
    /**
     * @private
     */
    public function set motionPaths(value:Vector.<MotionPath>):void
    {
        _motionPaths = value;
    }
    
    //----------------------------------
    //  easer
    //----------------------------------
    /**
     * @private
     * Storage for the easer property. 
     */
    private var _easer:IEaser = defaultEaser;
    /**
     * The easing behavior for this effect. 
     * This IEaser object is used to convert the elapsed fraction of 
     * the animation into an eased fraction, which is then used to
     * calculate the value at that eased elapsed fraction.
     * 
     * <p>Note that it is possible to have easing at both the effect
     * level and the Keyframe level (where Keyframes hold the values/times
     * used in the MotionPath structures).
     * These easing behaviors build on each other. 
     * The <code>easer</code> controls the easing of the overall effect.
     * The Keyframe controls the easing in any particular interval of the animation.
     * By default, the easing for Animate is non-linear (Sine(.5)).
     * The easing for Keyframes is linear. If you desire an effect with easing
     * at the keyframe level instead, you can set the easing of the
     * effect to linear, and then set the easing specifically on the Keyframes.</p>
     * 
     * @default spark.effects.easing.Sine(.5)
     *
     * @see spark.effects.easing.Sine
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get easer():IEaser
    {
        return _easer;
    }
    /**
     * @private
     */
    public function set easer(value:IEaser):void
    {
        _easer = value;
    }
    
    //----------------------------------
    //  interpolator
    //----------------------------------
    /**
     * @private
     * Storage for the interpolator property. 
     */
    private var _interpolator:IInterpolator = null;
    /**
     * The interpolator used by this effect to calculate values between
     * the start and end values of a property. 
     * By default, the NumberInterpolator class handles interpolation 
     * or, in the case of the start
     * and end values being Arrays or Vectors, by the 
     * MultiValueInterpolator class.
     * Interpolation of other types, or of Numbers that should be interpolated
     * differently, such as <code>uint</code> values that hold color
     * channel information, can be handled by supplying a different
     * interpolator.
     *
     *  @see spark.effects.interpolation.NumberInterpolator
     *  @see spark.effects.interpolation.MultiValueInterpolator
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get interpolator():IInterpolator
    {
        return _interpolator;
    }
    /**
     * @private
     */
    public function set interpolator(value:IInterpolator):void
    {
        _interpolator = value;
    }

    //----------------------------------
    //  repeatBehavior
    //----------------------------------
    /**
     * @private
     * Storage for the repeatBehavior property. 
     */
    private var _repeatBehavior:String = RepeatBehavior.LOOP;
    
    [Inspectable(category="General", enumeration="loop,reverse", defaultValue="loop" )]
    
    /**
     * The behavior of a repeating effect, which means an effect
     * with <code>repeatCount</code> equal to either 0 or &gt; 1. This
     * value should be either <code>RepeatBehavior.LOOP</code>, which means the animation
     * repeats in the same order each time, or <code>RepeatBehavior.REVERSE</code>,
     * which means the animation reverses direction on each iteration.
     * 
     * @default RepeatBehavior.LOOP
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get repeatBehavior():String
    {
        return _repeatBehavior;
    }
    /**
     * @private
     */
    public function set repeatBehavior(value:String):void
    {
        _repeatBehavior = value;
    }
    
    //----------------------------------
    //  disableLayout
    //----------------------------------
    /**
     * @private
     * Storage for the disableLayout property. 
     */
    private var _disableLayout:Boolean = false;
    /**
     * If <code>true</code>, the effect disables layout on its
     * targets' parent containers, setting the containers <code>autoLayout</code>
     * property to false, and also disables any layout constraints on the 
     * target objects. These properties are restored when the effect
     * finishes.
     * 
     * @default false
     *  
     * @langversion 3.0
     * @playerversion Flash 10
     * @playerversion AIR 1.5
     * @productversion Flex 4
     */
    public function get disableLayout():Boolean
    {
        return _disableLayout;
    }
    /**
     * @private
     */
    public function set disableLayout(value:Boolean):void
    {
        _disableLayout = value;
    }
    
    //--------------------------------------------------------------------------
    //
    // Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private 
     */
    override public function getAffectedProperties():Array /* of String */
    {
        if (!affectedProperties)
        {
            if (motionPaths)
            {
                var horizontalMove:Boolean;
                var verticalMove:Boolean;
                affectedProperties = new Array();
                for (var i:int = 0; i < motionPaths.length; ++i)
                {
                    var effectHolder:MotionPath = MotionPath(motionPaths[i]);
                    affectedProperties.push(effectHolder.property);
                    // Some properties side-affect others: add them to the list
                    switch (effectHolder.property)
                    {
                        // left/right/top/bottom side-effect x/y/width/height
                        case "left":
                        case "right":
                        case "horizontalCenter":
                            horizontalMove = true;
                            break;
                        case "top":
                        case "bottom":
                        case "verticalCenter":
                            verticalMove = true;
                            break;
                        // The next two let us capture the explicit values, so that we
                        // can restore them if necessary when the effect ends
                        case "width":
                            if (affectedProperties.indexOf("explicitWidth") < 0)
                                affectedProperties.push("explicitWidth");
                            if (affectedProperties.indexOf("percentWidth") < 0)
                                affectedProperties.push("percentWidth");
                            break;
                        case "height":
                            if (affectedProperties.indexOf("explicitHeight") < 0)
                                affectedProperties.push("explicitHeight");
                            if (affectedProperties.indexOf("percentHeight") < 0)
                                affectedProperties.push("percentHeight");
                            break;
                    }
                }
                if (horizontalMove)
                {
                    if (affectedProperties.indexOf("x") < 0)
                        affectedProperties.push("x");
                    if (affectedProperties.indexOf("width") < 0)
                        affectedProperties.push("width");
                    if (affectedProperties.indexOf("explicitWidth") < 0)
                        affectedProperties.push("explicitWidth");
                }
                if (verticalMove)
                {
                    if (affectedProperties.indexOf("y") < 0)
                        affectedProperties.push("y");
                    if (affectedProperties.indexOf("height") < 0)
                        affectedProperties.push("height");
                    if (affectedProperties.indexOf("explicitHeight") < 0)
                        affectedProperties.push("explicitHeight");
                }
            }
            else
            {
                affectedProperties = [];
            }
        }
        return affectedProperties;
    }
    
    /**
     *  @private 
     */
    override public function get relevantStyles():Array /* of String */
    {
        if (!_relevantStyles)
        {
            if (motionPaths)
            {
                _relevantStyles = new Array(motionPaths.length);
                for (var i:int = 0; i < motionPaths.length; ++i)
                {
                    var effectHolder:MotionPath = MotionPath(motionPaths[i]);
                    _relevantStyles[i] = effectHolder.property;
                }
            }
            else
            {
                _relevantStyles = [];
            }
        }
        return _relevantStyles;
    }
    
    /**
     * @private
     */
    override protected function initInstance(instance:IEffectInstance):void
    {
        super.initInstance(instance);
        
        var animateInstance:AnimateInstance = AnimateInstance(instance);

        animateInstance.addEventListener(EffectEvent.EFFECT_REPEAT, animationEventHandler);
        // Optimization: don't bother listening for update events if we don't have
        // any listeners for that event
        if (numUpdateListeners > 0)
            animateInstance.addEventListener(EffectEvent.EFFECT_UPDATE, animationEventHandler);

        if (easer)
            animateInstance.easer = easer;
            
        if (interpolator)
            animateInstance.interpolator = interpolator;
//@todo restore repeatCount (missing in ancestry)
/*        if (isNaN(repeatCount))
            animateInstance.repeatCount = repeatCount;*/
            
        animateInstance.repeatBehavior = repeatBehavior;
        animateInstance.disableLayout = disableLayout;
        
        if (motionPaths)
        {
            animateInstance.motionPaths = new Vector.<MotionPath>();
            for (var i:int = 0; i < motionPaths.length; ++i)
                animateInstance.motionPaths[i] = motionPaths[i].clone();
        }
    }
    

    /**
     * @private
     */
    override protected function applyValueToTarget(target:Object, property:String, 
                                          value:*, props:Object):void
    {
        if (property in target)
        {
            // The "property in target" test only tells if the property exists
            // in the target, but does not distinguish between read-only and
            // read-write properties. Put a try/catch around the setter and 
            // ignore any errors.
            try
            {
                target[property] = value;
            }
            catch(e:Error)
            {
                // Ignore errors
            }
        }
    }

    /**
     * @private
     * Track number of listeners to update event for optimization purposes
     */
    COMPILE::JS
    override public function addEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
    {
        super.addEventListener(type, handler, opt_capture, opt_handlerScope);
        if (type == EffectEvent.EFFECT_UPDATE)
            ++numUpdateListeners;
    }

    /**
     * @private
     * Track number of listeners to update event for optimization purposes
     */
    COMPILE::SWF
    override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
    {
        super.addEventListener(type, listener, useCapture, priority,
                useWeakReference);
        if (type == EffectEvent.EFFECT_UPDATE)
            ++numUpdateListeners;
    }
    
    /**
     * @private
     * Track number of listeners to update event for optimization purposes
     */
    COMPILE::JS
    override public function removeEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
    {
        super.removeEventListener(type, handler, opt_capture, opt_handlerScope);
        if (type == EffectEvent.EFFECT_UPDATE)
            --numUpdateListeners;
    }

    COMPILE::SWF
    override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
    {
        super.removeEventListener(type, listener, useCapture);
        if (type == EffectEvent.EFFECT_UPDATE)
            --numUpdateListeners;
    }
    
    /**
     * @private
     * Called when the AnimateInstance object dispatches an EffectEvent.
     *
     * @param event An event object of type EffectEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private function animationEventHandler(event:EffectEvent):void
    {
        dispatchEvent(event);
    }
    
    /**
     * @private
     * Tell the propertyChanges array to keep all values, unchanged or not.
     * This enables us to check later, when the effect is finished, whether
     * we need to restore explicit height/width values.
     */
    override mx_internal function captureValues(propChanges:Array,
                                                setStartValues:Boolean, 
                                                targetsToCapture:Array = null):Array
    {
        var propertyChanges:Array = 
            super.captureValues(propChanges, setStartValues, targetsToCapture);

        // If we're capturing explicitWidth/Height values, don't strip unchanging
        // values from propertyChanges; we want to know whether these values should
        // be restored when the effect ends
        var explicitValuesCaptured:Boolean = 
            getAffectedProperties().indexOf("explicitWidth") >= 0 ||
            getAffectedProperties().indexOf("explicitHeight") >= 0;
        if (explicitValuesCaptured && setStartValues)
        {
            var n:int = propertyChanges.length;
            for (var i:int = 0; i < n; i++)
            {
                if (targetsToCapture == null || targetsToCapture.length == 0 ||
                    targetsToCapture.indexOf(propertyChanges[i].target) >= 0)
                {
                    propertyChanges[i].stripUnchangedValues = false;
                }
            }
        }
        return propertyChanges;
    }

    /**
     *  @private
     *  After applying start values, check to see whether the values
     *  contain percentWidth/percentHeight, which should be applied
     *  after any width/height/explicitWidth/explicitHeight values.
     */
    override mx_internal function applyStartValues(propChanges:Array,
                                                   targets:Array):void
    {
        super.applyStartValues(propChanges, targets);
        // Special case for percentWidth/Height properties. If we are watching
        // width/explicitWidth or height/explicitHeight values and also
        // percentWidth/Height values, we have to make sure to apply the 
        // percent values last to avoid having them get clobbered by
        // applying the width/height values. We could either sort the
        // propChanges array or just make sure the re-apply the percent
        // values here, after we're done with the rest.
        if (propChanges)
        {
            var n:int = propChanges.length;
            for (var i:int = 0; i < n; i++)
            {
                var target:Object = propChanges[i].target;
                if (propChanges[i].start["percentWidth"] !== undefined && 
                    "percentWidth" in target)
                {
                    target.percentWidth = propChanges[i].start["percentWidth"];
                }
                if (propChanges[i].start["percentHeight"] !== undefined && 
                    "percentHeight" in target)
                {
                    target.percentHeight = propChanges[i].start["percentHeight"];
                }
            }
        }
    }
        
    /**
     * @private
     * When we're done, check to see whether explicitWidth/Height values
     * for the target are NaN in the end state. If so, we should restore
     * them to that value. This ensures that the target will be sized by
     * its layout manager instead of by the width/height set during
     * the effect.
     */
    override mx_internal function applyEndValues(propChanges:Array,
                                                 targets:Array):void
    {
        super.applyEndValues(propChanges, targets);
        // Special case for animating width/height during a transition, because
        // we may have clobbered the explicitWidth/Height values which otherwise 
        // would not have been set. We need to restore these values plus any
        // associated layout constraint values (percentWidth/Height)
        if (propChanges)
        {
            var n:int = propChanges.length;
            for (var i:int = 0; i < n; i++)
            {
                var target:Object = propChanges[i].target;
                if (propChanges[i].end["explicitWidth"] !== undefined)
                {
                    if (isNaN(propChanges[i].end["explicitWidth"]) && 
                        "explicitWidth" in target)
                    {
                        target.explicitWidth = NaN;
                        if (propChanges[i].end["percentWidth"] !== undefined && 
                            "percentWidth" in target)
                        {
                            target.percentWidth = propChanges[i].end["percentWidth"];
                        }
                    }
                }
                if (propChanges[i].end["explicitHeight"] !== undefined)
                {
                    if (isNaN(propChanges[i].end["explicitHeight"]) && 
                        "explicitHeight" in target)
                    {
                        target.explicitHeight = NaN;
                        if (propChanges[i].end["percentHeight"] !== undefined && 
                            "percentHeight" in target)
                        {
                            target.percentHeight = propChanges[i].end["percentHeight"];
                        }
                    }
                }
            }
        }
    }
}
}
