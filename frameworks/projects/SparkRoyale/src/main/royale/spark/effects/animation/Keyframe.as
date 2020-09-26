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
import mx.core.mx_internal;

import spark.effects.easing.IEaser;
import spark.effects.easing.Linear;

use namespace mx_internal;

/**
 *  The Keyframe class defines the value of a property at a specific time during an effect. 
 *  For example, you can create three keyframes that define the value of a property at 
 *  the beginning of the effect, at the midpoint of the effect, and at the end of the effect. 
 *  The effect animates the property change on the target from keyframe to keyframe 
 *  over the effect duration.
 *
 *  <p>The collection of keyframes for an effect is called the effect's motion path. 
 *  A motion path can define any number of keyframes. 
 *  The effect then calculates the value of the property by interpolating between 
 *  the values specified by two key frames. </p>
 * 
 *  <p>Use the MotionPath class to hold the collection of Keyframe objects that 
 *  represent the motion path of the effect.
 *  The MotionPath class specifies the name of the property on the target, 
 *  and the collection of Keyframes objects specify the values of the property at different
 *  times during the effect.</p>
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;s:Keyframe&gt;</code> tag
 *  inherits the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;s:Keyframe 
 *    id="ID"
 *    easier="Linear"
 *    time="val"
 *    value="val"
 *    valueBy="val"
 *  /&gt;
 *  </pre>
 * 
 *  @see MotionPath
 *
 *  @includeExample examples/KeyFrameEffectExample.mxml
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class Keyframe
{
    //include "../../core/Version.as";

    /**
     *  Constructor.
     * 
     *  @param time The time, in milliseconds, at which the effect target
     *  of this keyframe should have the value
     *  specified by the <code>value</code> parameter.
     *
     *  @param value The value that the effect target should have
     *  at the given <code>time</code>.
     *
     *  @param valueBy Optional parameter which, if provided, 
     *  causes <code>value</code> to be calculated dynamically by
     *  adding <code>valueBy</code> to the <code>value</code> of
     *  the previous keyframe in the set of keyframes in a MotionPath
     *  object. This value is ignored if this is the first
     *  Keyframe in a sequence.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function Keyframe(time:Number = NaN, 
        value:Object = null, valueBy:Object = null)
    {
        this.value = value;
        this.time = time;
        this.valueBy = valueBy;
    }
    
    /**
     *  Returns a copy of this Keyframe object.
     *
     *  @return A copy of this Keyframe object.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function clone():Keyframe
    {
        var kf:Keyframe = new Keyframe(time, value, valueBy);
        kf.easer = easer;
        kf.timeFraction = timeFraction;
        return kf;
    }
    
    /**
     *  The value that the property of the effect target should have
     *  at the time specified by the <code>time</code> property.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var value:Object;
    
    [Inspectable(minValue="0.0")]
    
    /**
     *  The time, in milliseconds, at which the effect target
     *  for this keyframe should have the value
     *  specified by the <code>value</code> property. This time
     *  is relative to the starting time of the effect defined
     *  with this keyframe.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var time:Number;
    
    /**
     *  @private
     * 
     *  The time, represented as a fraction of an animation's
     *  total duration. This value should be a value between 0
     *  and 1. This value is calculated automatically prior to 
     *  playing the animation. It simplifies the API for users (who
     *  are able to use absolute time values) and the implementation
     *  (because we can work on fractional values directly) and is not
     *  to be used externally.
     */
    mx_internal var timeFraction:Number;
    
    /**
     * @private
     * Default easer for keyframes
     */
    private static var linearEaser:IEaser = new Linear();
    /**
     *  The easing behavior applied to the motion between the previous
     *  Keyframe object in motion path and this Keyframe object. 
     *  By default, the easing is linear, or no easing at all. 
     *
     *  <p>Note that the parent effect
     *  might have easing applied already over the entire
     *  animation. Therefore, if easing per keyframe interval is desired
     *  instead, it is necessary to set the overall effect  
     *  easer to linear easing (spark.effects.easing.Linear) and then
     *  set the <code>easer</code> on each Keyframe as appropriate.</p>
     * 
     *  <p>Because this property acts on the interval between the previous
     *  Keyframe object in a sequence and this Keyframe object, the <code>easer</code> 
     *  property is ignored on the first Keyframe object in a sequence.</p>
     *  
     *  @default Linear
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var easer:IEaser = linearEaser;

    /**
     *  Optional parameter which, if specified, is used to
     *  calculate <code>value</code> in this keyframe or
     *  the previous one. If <code>value</code> is not set in
     *  the previous keyframe, but this keyframe defines both
     *  <code>value</code> and <code>valueBy</code>, then <code>value</code>
     *  in the previous keyframe is calculated as <code>value</code>
     *  in this keyframe minus <code>valueBy</code> in this keyframe.
     *
     *  <p>Similarly, if <code>value</code> in this keyframe is not
     *  defined, but <code>valueBy</code> in this keyframe and
     *  <code>value</code> in the previous keyframe are both set,
     *  then <code>value</code> in this keyframe is calculated as
     *  <code>value</code> in the previous keyframe plus
     *  <code>valueBy</code> in this keyframe.</p>
     *  
     *  <p><code>valueBy</code> is ignored for the first
     *  keyframe in a sequence, since it applies only to the interval
     *  preceding a keyframe, and there is no preceding interval for the
     *  first keyframe.</p>
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public var valueBy:Object;

}
}
