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
 *  The Power class defines the easing functionality using a polynomial expression.
 *  Easing consists of two phases: the acceleration, or ease in phase,
 *  followed by the deceleration, or ease out phase.
 *  The rate of acceleration and deceleration is based on
 *  the <code>exponent</code> property.
 *  The higher the value of the <code>exponent</code> property,
 *  the greater the acceleration and deceleration.
 *  Use the <code>easeInFraction</code> property to specify the percentage
 *  of an animation accelerating.
 *
 *  @mxml
 *
 *  <p>The <code>&lt;s:Power&gt;</code> tag
 *  inherits all of the tag attributes of its of its superclass,
 *  and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:Power
 *    id="ID"
 *    exponent="2"
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
public class Power extends EaseInOutBase
{
    /**
     * Storage for the exponent property
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private var _exponent:Number;
    
    [Inspectable(minValue="1.0")]
    
    /**
     *  The exponent used in the easing calculation.
     *  The higher the value of the <code>exponent</code> property,
     *  the greater the acceleration and deceleration.
     *  For example, to get quadratic behavior, set <code>exponent</code> to 2.
     *  To get cubic behavior, set <code>exponent</code> to 3.
     *
     *  @default 2
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get exponent():Number
    {
        return _exponent;
    }
    public function set exponent(value:Number):void
    {
        _exponent = value;
    }

    /**
     * Constructor.
     *
     *  @param easeInFraction The fraction of the overall duration
     *  in the acceleration phase, between 0.0 and 1.0.
     *
     *  @param exponent The exponent used in the easing calculation.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function Power(easeInFraction:Number = 0.5, exponent:Number = 2)
    {
        super(easeInFraction);
        this.exponent = exponent;
    }

    /**
     *  @private
     *  Returns a value that represents the eased fraction during the
     *  ease in phase of the animation.
     *  The easing calculation for Power is equal to
     *  <code>fraction^^exponent</code>.
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
        return Math.pow(fraction, _exponent);
    }

    /**
     *  @private
     *  Returns a value that represents the eased fraction during the
     *  ease out phase of the animation.
     *  The easing calculation for Power is equal to
     *  <code>1 - ((1-fraction)^^exponent)</code>.
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
        return 1 - Math.pow((1 - fraction), _exponent);
    }
}
}
