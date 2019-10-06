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

package mx.charts.effects
{

import mx.charts.effects.effectClasses.SeriesEffectInstance;
import mx.effects.IEffectInstance;
import mx.effects.TweenEffect;

/**
 *  The base class for chart effects.
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:SeriesEffect&gt;</code> tag
 *  inherits the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:<i>tagname</i>
 *    <strong>Properties</strong>
 *    elementOffset="20"
 *    minimumElementDuration="0"
 *    offset="0"
 *    type="show|hide <i>(Default value is set by chart)</i>"
 *  &gt;
 *  </pre>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SeriesEffect extends TweenEffect
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
     *  @param target The target of the effect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function SeriesEffect(target:Object)
    {
        super(target);

        instanceClass = SeriesEffectInstance;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  elementOffset
    //----------------------------------

    private var _elementOffset:Number = 20;
    
    [Inspectable(category="General", defaultValue="20")]

    /**
     *  Specifies the amount of time, in milliseconds, that Flex delays
     *  the start of the effect on each element in the series.
     *
     *  <p>Set <code>elementOffset</code> to <code>0</code>
     *  to affect all elements of the series at the same time.
     *  They start the effect at the same time and end it at the same time.</p>
     *
     *  <p>Set <code>elementOffset</code> to a positive integer
     *  (such as <code>30</code>) to stagger the effect on each element
     *  by that amount of time.
     *  For example, with a slide effect, the first element slides in
     *  immediately, then the next element begins 30 milliseconds later,
     *  and so on.
     *  The amount of time for the effect to execute is the same
     *  for each element, but the overall duration of the effect is longer.</p>
     *
     *  <p>Set <code>elementOffset</code> to a negative value
     *  to have the effect begin from the last element
     *  and move backwards through the list.</p>
     *
     *  <p>The default is <code>20</code>.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get elementOffset():Number
    {
        return _elementOffset;
    }
    public function set elementOffset(value:Number):void
    {
        _elementOffset = value;
    }

    //----------------------------------
    //  minimumElementDuration
    //----------------------------------

    private var _minimumElementDuration:Number = 0;
    
    [Inspectable(category="General", defaultValue="0")]

    /**
     *  Specifies the amount of time, in milliseconds,
     *  that an individual element should take to complete the effect.
     *
     *  <p>Charts with a variable number of data points in the series
     *  cannot reliably create smooth effects
     *  with only the <code>duration</code> property.
     *  For example, an effect with a <code>duration</code>
     *  of <code>1000</code> and an <code>elementOffset</code>
     *  of <code>100</code> takes 900 milliseconds per element
     *  to complete an effect if you have two elements in the series.
     *  This is because the start of each effect is offset by 100
     *  and each effect finishes in 1000 milliseconds.</p>
     * 
     *  <p>If there are four elements in the series,
     *  each element takes 700 milliseconds to complete
     *  (the last effect starts 300 milliseconds after the first
     *  and must be completed within 1000 milliseconds).
     *  With 10 elements, each element has only 100 milliseconds</p>
     *  to complete the effect.
     *
     *  <p>The <code>minimumElementDuration</code> value
     *  sets a minimal duration for each element.
     *  No element of the series takes less than this amount of time
     *  (in milliseconds) to execute the effect,
     *  regardless of the number of elements in the series
     *  and the value of the <code>duration</code> property.
     *  As a result, it is possible for an effect to take longer
     *  than a specified <code>duration</code>
     *  if at least two of the following three properties are specified:
     *  <code>duration</code>, <code>offset</code>,
     *  and <code>minimumElementDuration</code>.</p>
     *  
     *  <p>The default is <code>0</code>.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minimumElementDuration():Number
    {
        return _minimumElementDuration;
    }
    public function set minimumElementDuration(value:Number):void
    {
        _minimumElementDuration = value;
    }

    //----------------------------------
    //  offset
    //----------------------------------

    private var _offset:Number = 0;
    
    [Inspectable(category="General", defaultValue="0")]

    /**
     *  Specifies the amount of time, in milliseconds,
     *  that Flex delays the effect.
     *
     *  <p>Use this property to stagger effects on multiple series.</p>
     *
     *  <p>The default is <code>0</code>.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get offset():Number
    {
        return _offset;
    }
    public function set offset(value:Number):void
    {
        _offset = value;
    }

    //----------------------------------
    //  type
    //----------------------------------

    private var _type:String = "show";

    [Inspectable(environment="none")]

    /**
     *  The type of transition this effect is being used for. Some series effects define different behavior based on whether they are being used during the show or hide portion of 
     *  a chart transition. The SeriesSlide effect, for example, slides elements from their position off screen when this property is set to <code>hide</code>, and on screen when this property is set to <code>show</code>. This property
     *  is set by the chart, based on whether the effect as assigned to the ShowDataEffect or HideDataEffect style.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get type():String
    {
        return _type;
    }
    public function set type(value:String):void
    {
        _type = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function initInstance(instance:IEffectInstance):void
    {
        super.initInstance(instance);

        var seriesEffectInstance:SeriesEffectInstance =
            SeriesEffectInstance(instance);
        seriesEffectInstance.offset = offset;
        seriesEffectInstance.elementOffset = elementOffset;
        seriesEffectInstance.minimumElementDuration = minimumElementDuration;
        seriesEffectInstance.type = type;
    }
}

}
