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

package spark.effects.animation  
{
import __AS3__.vec.Vector;

import mx.core.mx_internal;

import spark.effects.easing.IEaser;
import spark.effects.easing.Sine;
import spark.effects.interpolation.IInterpolator;
import spark.effects.interpolation.NumberInterpolator;

use namespace mx_internal;

[DefaultProperty("keyframes")]

/**
 *  The MotionPath class defines the collection of Keyframes objects for an effect,
 *  and the name of the property on the target to animate. 
 *  Each Keyframe object defines the value of the property at a specific time during an effect. 
 *  The effect then calculates the value of the target property 
 *  by interpolating between the values specified by two key frames.
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;s:MotionPath&gt;</code> tag
 *  inherits the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;s:MotionPath 
 *    id="ID"
 *    interpolator="NumberInterpolator"
 *    keyframes="val"
 *    property="val"
 *  /&gt;
 *  </pre>
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 *
 *  @includeExample examples/KeyFrameEffectExample.mxml
 * 
 *  @see Keyframe
 *  @see spark.effects.interpolation.NumberInterpolator
 */
public class MotionPath
{
    //include "../../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor. 
     *
     *  @param property The name of the property on the target to animate.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function MotionPath(property:String = null)
    {
        this.property = property;
    }

    //--------------------------------------------------------------------------
    //
    // Properties
    //
    //--------------------------------------------------------------------------

    /**
     *  The name of the property on the effect target to be animated.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var property:String;
     
    /**
     *  The interpolator determines how in-between values in an animation
     *  are calculated. By default, the MotionPath class assumes that the values are
     *  of type Number and can calculate in-between Number values automatically.
     *  If the MotionPath class is given keyframes with non-Number values, or if the
     *  desired behavior should use a different approach to interpolation
     *  (such as per-channel color interpolation), then an interpolator
     *  should be supplied.
     *
     *  <p>Flex supplies predefined interpolators in the spark.effects.interpolation package.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var interpolator:IInterpolator = NumberInterpolator.getInstance();
    
    /**
     *  A sequence of Keyframe objects that represent the time/value pairs
     *  that the property takes during the animation. Each successive
     *  pair of keyframes controls the animation during the time interval
     *  between them.
     *  The optional <code>easer</code> and <code>valueBy</code>
     *  properties of the later keyframe are used to determine the behavior
     *  during that interval. The sequence of keyframes must be sorted in 
     *  order of increasing time values.
     * 
     *  <p>Animations always start at time=0 and lasts for a duration
     *  equal to the <code>time</code> value in the final keyframe. 
     *  If no keyframe is defined at time=0, 
     *  that keyframe is implicit, using the value of the
     *  target property at the time the animation begins. </p>
     *
     *  <p>Because keyframes explicitly define the times involved in an animation, 
     *  the duration for an effect using keyframes is set according to the maximum time
     *  of the final keyframe of all MotionPaths in the effect.
     *  For example, if an effect has keyframes
     *  at times 0, 500, 1000, and 2000, then the effective duration of that
     *  effect is 2000 ms, regardless of any <code>duration</code> property set on the
     *  effect itself. 
     *  Because the final keyframe determines the duration, there
     *  must always be a final keyframe in any MotionPath. That is, 
     *  it is implicit that the time in the final keyframe is the 
     *  duration of the MotionPath.</p>
     * 
     *  <p>Any keyframe may leave its <code>value</code> undefined (either unset, set to 
     *  <code>null</code>, or set to <code>NaN</code>).
     *  In that case, the value is determined dynamically when the animation starts.
     *  Any undefined value is determined as follows: </p>
     *  <ol>
     *    <li>If it is the first keyframe, it is calculated from the next keyframe
     *      if that keyframe has both a <code>value</code> and <code>valueBy</code> property set,
     *      as the difference of those values. Otherwise it gets the
     *      current value of the property from the target.</li>
     *    <li>If it is the final keyframe and the animation is running in a transition, it 
     *      uses the value in the destination view state of the transition.</li>
     *    <li>Otherwise, any keyframe calculates its <code>value</code> by using the previous
     *      keyframe's <code>value</code> and adding the current keyframe's <code>valueBy</code>
     *      to it, if <code>valueBy</code> is set.</li>
     *  </ol>
     *  
     *  @see Keyframe
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var keyframes:Vector.<Keyframe>;
    

    /**
     *  Returns a copy of this MotionPath object, including copies
     *  of each keyframe.
     *
     *  @return A copy of this MotionPath object, including copies
     *  of each keyframe.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function clone():MotionPath
    {
        var mp:MotionPath = new MotionPath(property);
        mp.interpolator = interpolator;
        if (keyframes !== null)
        {
            mp.keyframes = new Vector.<Keyframe>();
            for (var i:int = 0; i < keyframes.length; ++i)
                mp.keyframes[i] = keyframes[i].clone();
        }
        return mp;
    }

    /**
     *  @private
     * 
     *  Calculates the <code>timeFraction</code> values for
     *  each Keyframe in a MotionPath Keyframe sequence.
     *  To calculate these values, the time on each Keyframe
     *  is divided by the supplied <code>duration</code> parameter.
     *  
     *  @param duration the duration of the animation that the
     *  keyframes should be scaled against.
     */
    mx_internal function scaleKeyframes(duration:Number):void
    {
        var n:int = keyframes.length;
        for (var i:int; i < n; ++i)
        {
            var kf:Keyframe = keyframes[i];
            // TODO (chaase): Must be some way to allow callers
            // to supply timeFraction, but currently we clobber it
            // with this operation. But if we choose to clobber it
            // only if it's not set already, then it only works the
            // first time through, since an Effect will retain its
            // MotionPath, which retains its Keyframes, etc.
            kf.timeFraction = kf.time / duration;
        }
    }
    
    /**
     *  Calculates and returns an interpolated value, given the elapsed
     *  time fraction. The function determines the keyframe interval
     *  that the fraction falls within and then interpolates within
     *  that interval between the values of the bounding keyframes on that
     *  interval.
     *
     *  @param fraction The fraction of the overall duration of the effect,
     *  (a value from 0.0 to 1.0).
     *
     *  @return The interpolated value.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function getValue(fraction:Number):Object
    {
        if (!keyframes)
            return null;
        var n:int = keyframes.length;
        if (n == 2 && keyframes[1].timeFraction == 1)
        {
            // The common case where we are just animating from/to, as in the
            // case of an SimpleMotionPath
            var easedF:Number = (keyframes[1].easer) ? 
                keyframes[1].easer.ease(fraction) : 
                fraction;
            return interpolator.interpolate(easedF, keyframes[0].value,
                keyframes[1].value);
        }
        // if timeFraction on first keyframe is not set, call scaleKeyframes
        // should not generally happen, but if getValue() is called before
        // an owning effect is played, then timeFractions were not set
        if (isNaN(keyframes[0].timeFraction))
            scaleKeyframes(keyframes[keyframes.length-1].time);
        var prevT:Number = 0;
        var prevValue:Object = keyframes[0].value;
        for (var i:int = 1; i < n; ++i)
        {
            var kf:Keyframe = keyframes[i];
            if (fraction >= prevT && fraction < kf.timeFraction)
            {
                var t:Number = (fraction - prevT) / (kf.timeFraction - prevT);
                var easedT:Number = (kf.easer) ? kf.easer.ease(t) : t;
                return interpolator.interpolate(easedT, prevValue, kf.value);
            }
            prevT = kf.timeFraction;
            prevValue = kf.value;
        }
        // Must be at the end of the animation
        return keyframes[n-1].value;
    }

}
}
