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
 *  The EaseInOutBase class is the base class that provide easing capability.
 *  The EaseInOutBase class  defines easing as consisting of two phases:
 *  the acceleration, or ease in phase, followed by the deceleration, or ease out phase.
 *  The default behavior of this class returns a linear
 *  interpolation for both easing phases. You can create a subclass
 *  of EaseInOutBase to get more interesting behavior.
 *
 *  @mxml
 *
 *  <p>The <code>&lt;s:EaseInOutBase&gt;</code> tag
 *  inherits all of the tag attributes of its of its superclass,
 *  and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:EaseInOutBase
 *    id="ID"
 *    easeInFraction="0.5"
 *   /&gt;
 *  </pre>
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class EaseInOutBase implements IEaser
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
    public function EaseInOutBase(easeInFraction:Number = EasingFraction.IN_OUT)
    {
        this.easeInFraction = easeInFraction;
    }

    /**
     * Storage for the _easeInFraction property
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private var _easeInFraction:Number = .5;

    [Inspectable(minValue="0.0", maxValue="1.0")]

    /**
     *  The percentage of an animation that should be spent accelerating.
     *  This factor sets an implicit
     *  "easeOut" parameter, equal to (1 - <code>easeIn</code>), so that any time not
     *  spent easing in is spent easing out. For example, to have an easing
     *  equation that spends half the time easing in and half easing out,
     *  set <code>easeIn</code> to .5.
     *
     *  <p>Valid values are between 0.0 and 1.0.</p>
     *
     *  @default .5
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get easeInFraction():Number
    {
        return _easeInFraction;
    }
    public function set easeInFraction(value:Number):void
    {
        _easeInFraction = value;
    }

    /**
     *  Takes the fraction representing the elapsed duration of an animation
     *  (a value between 0.0 to 1.0) and returns a new elapsed value.
     *  This  value is used to calculate animated property values.
     *  By changing the value of the elapsed fraction, you effectively change
     *  the animation of the property.
     *
     *  For EaseInOutBase, this method calculates the eased fraction
     *  value based on the <code>easeInFraction</code> property. If
     *  <code>fraction</code> is less than <code>easeInFraction</code>,
     *  this method calls the <code>easeIn()</code> method. Otherwise it
     *  calls the <code>easeOut()</code> method.
     *  It is expected
     *  that these functions are overridden in a subclass.
     *
     *  @param fraction The elapsed fraction of the animation.
     *
     *  @return The eased fraction of the animation.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function ease(fraction:Number):Number
    {
        var easeOutFraction:Number = 1 - easeInFraction;

        if (fraction <= easeInFraction && easeInFraction > 0)
            return easeInFraction * easeIn(fraction/easeInFraction);
        else
            return easeInFraction + easeOutFraction *
                easeOut((fraction - easeInFraction)/easeOutFraction);
    }

    /**
     *  Returns a value that represents the eased fraction during the
     *  ease in phase of the animation. The value returned by this class
     *  is simply the fraction itself, which represents a linear
     *  interpolation of the fraction. More interesting behavior is
     *  implemented by subclasses of EaseInOutBase.
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
    protected function easeIn(fraction:Number):Number
    {
        return fraction;
    }

    /**
     *  Returns a value that represents the eased fraction during the
     *  ease out phase of the animation. The value returned by this class
     *  is simply the fraction itself, which represents a linear
     *  interpolation of the fraction. More interesting behavior is
     *  implemented by subclasses of EaseInOutBase.
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
    protected function easeOut(fraction:Number):Number
    {
        return fraction;
    }

}
}
