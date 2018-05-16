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

package mx.charts
{
import mx.charts.chartClasses.IAxis;
import mx.graphics.IFill;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.charts.chartClasses.ChartBase;
COMPILE::JS
{
    import goog.DEBUG;
}
/*
import flash.utils.Dictionary;

import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.DataTip;
import mx.charts.chartClasses.DataTransform;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.Series;
import mx.charts.series.AreaSeries;
import mx.charts.series.AreaSet;
import mx.charts.styles.HaloDefaults;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.graphics.IFill;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;

use namespace mx_internal;
*/
[DefaultBindingProperty(destination="dataProvider")]

//[DefaultTriggerEvent("itemClick")]

//[IconFile("AreaChart.png")]

/**
 *  The AreaChart control represents data as an area
 *  bounded by a line connecting the values in the data.
 *  The AreaChart control can be used to represent different variations,
 *  including simple areas, stacked, 100% stacked, and high/low.
 *  
 *  <p>The AreaChart control expects its <code>series</code> property
 *  to contain an Array of AreaSeries objects.</p>
 *  
 *  <p>Stacked and 100% area charts override the <code>minField</code>
 *  property of their AreaSeries objects.</p>
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:AreaChart&gt;</code> tag inherits all the properties
 *  of its parent classes, and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:AreaChart
 *    <strong>Properties</strong>
 *    type="<i>overlaid|stacked|100%</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/Line_AreaChartExample.mxml
 *  
 *  @see mx.charts.series.AreaSeries
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class AreaChart extends ChartBase
//extends CartesianChart
{
    //include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class initialization
    //
    //--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function AreaChart()
    {
        super();

        //LinearAxis(horizontalAxis).autoAdjust = false;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    //private static var _moduleFactoryInitialized:Dictionary = new Dictionary(true);

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  horizontalAxis
    //----------------------------------

    //[Inspectable(category="Data")]

    /**
     *  @private
     */
    /*override*/ public function set horizontalAxis(value:IAxis):void
    {
        //if (value is CategoryAxis)
        //    CategoryAxis(value).padding = 0;

        //super.horizontalAxis = value;
    }   

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  type
    //----------------------------------

    /**
     *  @private
     *  Storage for the type property.
     */
    private var _type:String = "overlaid";

    //[Inspectable(category="General", enumeration="overlaid,stacked,100%", defaultValue="overlaid")]

    /**
     *  Type of area chart to render.
     *
     *  <p>Possible values are:</p>
     *  <ul>
     *    <li><code>"overlaid"</code>:
     *    Multiple areas are rendered on top of each other,
     *    with the last series specified on top.
     *    This is the default value.</li>
     *    <li><code>"stacked"</code>:
     *    Areas are stacked on top of each other and grouped by category.
     *    Each area represents the cumulative value
     *    of the areas beneath it.</li>
     *    <li><code>"100%"</code>:
     *    Areas are stacked on top of each other, adding up to 100%.
     *    Each area represents the percent that series contributes
     *    to the sum of the whole.</li>
     *  </ul>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get type():String
    {
        return _type;
    }

    /**
     *  @private
     */
    public function set type(value:String):void
    {
        _type = value;
        //invalidateSeries();
        //invalidateData();
    }

    /**
     *  Sets a style property on this component instance.
     *
     *  <p>This can override a style that was set globally.</p>
     *
     *  <p>Calling the <code>setStyle()</code> method can result in decreased performance.
     *  Use it only when necessary.</p>
     *
     *  @param styleProp Name of the style property.
     *
     *  @param newValue New value for the style.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function setStyle(styleProp:String, newValue:*):void
    {
        if (GOOG::DEBUG)
            trace("setStyle not implemented");
    }

}

}
