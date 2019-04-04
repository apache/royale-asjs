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

import mx.charts.effects.effectClasses.SeriesZoomInstance;
import mx.effects.IEffectInstance;

/**
 *  The SeriesZoom effect implodes and explodes chart data
 *  into and out of the focal point that you specify.
 *  As with the SeriesSlide effect, whether the effect is zooming
 *  to or from this point depends on whether it is assigned to the
 *  <code>showDataEffect</code> or <code>hideDataEffect</code> effect trigger.
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:SeriesZoom&gt;</code> tag
 *  inherits all the properties of its parent classes,
 *  and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:SeriesZoom
 *    <strong>Properties</strong>
 *    horizontalFocus="center|left|right|null"
 *    relativeTo="series|chart"
 *    verticalFocus="top|center|bottom|null"
 *  /&gt;
 *  </pre>
 *
 *  @includeExample examples/SeriesZoomExample.mxml
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class SeriesZoom extends SeriesEffect
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
    public function SeriesZoom(target:Object = null)
    {
        super(target);

        instanceClass = SeriesZoomInstance;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  horizontalFocus
    //----------------------------------
    
    private var _horizontalFocus:String;

    [Inspectable(category="General", enumeration="left,center,right")]

    /**
     *  Defines the location of the focul point of the zoom.
     *
     *  <p>Valid values of the <code>horizontalFocus</code> property are <code>"left"</code>,
     *  <code>"center"</code>, <code>"right"</code>,
     *  and <code>null</code>.</p>
     *  
     *  <p>You combine the <code>horizontalFocus</code> and
     *  <code>verticalFocus</code> properties to define
     *  where the data series zooms in and out from.
     *  For example, set the <code>horizontalFocus</code> property to <code>"left"</code>
     *  and the <code>verticalFocus</code> property to <code>"top"</code> to zoom
     *  the series data to and from the top left corner of either
     *  the element or the chart (depending on the setting of the
     *  <code>relativeTo</code> property).</p>
     *  
     *  <p>If you specify only one of these two properties,
     *  then the focus is a horizontal or vertical line rather than a point.
     *  For example, when you set <code>horizontalFocus</code>
     *  to <code>"left"</code> but <code>verticalFocus</code>
     *  to <code>null</code>, the element zooms to and from
     *  a vertical line along the left edge of its bounding box.
     *  Set the <code>verticalFocus</code> property to <code>"center"</code>
     *  to zoom chart elements to and from a horizontal line
     *  along the middle of the chart's bounding box.</p>
     *  
     *  @default "center"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get horizontalFocus():String
    {
        return _horizontalFocus;
    }
    public function set horizontalFocus(value:String):void
    {
        _horizontalFocus = value;
    }
    
    //----------------------------------
    //  relativeTo
    //----------------------------------
    
    private var _relativeTo:String = "series";

    [Inspectable(category="General", enumeration="series,chart", defaultValue="series")]

    /**
     *  Controls the bounding box that Flex uses to calculate
     *  the focal point of the zooms.
     *
     *  <p>Valid values for the <code>relativeTo</code> property are
     *  <code>"series"</code> and <code>"chart"</code>.</p>
     *
     *  <p>Set to <code>"series"</code> to zoom each element
     *  relative to itself.
     *  For example, each column of a ColumnChart zooms from the top left
     *  of the column, the center of the column, and so on.</p>
     *
     *  <p>Set to <code>"chart"</code> to zoom each element
     *  relative to the chart area.
     *  For example, each column zooms from the top left of the axes,
     *  the center of the axes, and so on.</p>
     *  
     *  @default "series"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get relativeTo():String
    {
        return _relativeTo;
    }
    public function set relativeTo(value:String):void
    {
        _relativeTo = value;
    }

    //----------------------------------
    //  verticalFocus
    //----------------------------------

    private var _verticalFocus:String;
    
    [Inspectable(category="General", enumeration="top,center,bottom")]

    /**
     *  Defines the location of the focal point of the zoom.
     *  For more information, see the description of the
     *  <code>horizontalFocus</code> property.
     *  
     *  <p>Valid values of <code>verticalFocus</code> are
     *  <code>"top"</code>, <code>"center"</code>, <code>"bottom"</code>,
     *  and <code>null</code>.</p>
     *  
     *  @default "center"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get verticalFocus():String
    {
        return _verticalFocus;
    }
    public function set verticalFocus(value:String):void
    {
        _verticalFocus = value;
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

        var seriesZoomInstance:SeriesZoomInstance =
            SeriesZoomInstance(instance);
        seriesZoomInstance.horizontalFocus = horizontalFocus;
        seriesZoomInstance.verticalFocus = verticalFocus;
        seriesZoomInstance.relativeTo = relativeTo;
    }
}

}
