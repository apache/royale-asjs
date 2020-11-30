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
package spark.effects.easing
{
/**
 *  The Sine class defines easing functionality using a Sine function.
 *  Easing consists of two phases: the acceleration, or ease in phase,
 *  followed by the deceleration, or ease out phase.
 *  Use the <code>easeInFraction</code> property to specify
 *  the percentage of an animation accelerating.
 *
 *  @mxml
 *
 *  <p>The <code>&lt;s:Sine&gt;</code> tag
 *  inherits all of the tag attributes of its of its superclass,
 *  and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:Sine
 *    id="ID"
 *   /&gt;
 *  </pre>
 *
 *  @includeExample examples/SinePowerEffectExample.mxml
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class Sine extends EaseInOutBase
{
    /**
     *  Constructor.
     *
     *  @param easeInFraction Sets the value of
     *  the <code>easeInFraction</code> property. The default value is
     *  <code>EasingFraction.IN_OUT</code>, which eases in for the first half
     *  of the time and eases out for the remainder.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function Sine(easeInFraction:Number = 0.5)
    {
        super(easeInFraction);
    }

    /**
     *  @private
     *  Returns a value that represents the eased fraction during the
     *  ease in phase of the animation.
     *  The easing calculation for Sine is equal to
     *  <code>1 - cos(fraction*PI/2)</code>.
     *
     *  @param fraction The fraction elapsed of the easing in phase
     *  of the animation, between 0.0 and 1.0.
     *
     *  @return A value that represents the eased value for this
     *  phase of the animation.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override protected function easeIn(fraction:Number):Number
    {
        return 1 - Math.cos(fraction * Math.PI/2);
    }

    /**
     *  @private
     *  Returns a value that represents the eased fraction during the
     *  ease out phase of the animation.
     *  The easing calculation for Sine is equal to
     *  <code>sin(fraction*PI/2)</code>.
     *
     *  @param fraction The fraction elapsed of the easing out phase
     *  of the animation, between 0.0 and 1.0.
     *
     *  @return A value that represents the eased value for this
     *  phase of the animation.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    override protected function easeOut(fraction:Number):Number
    {
        return Math.sin(fraction * Math.PI/2);
    }
}
}
