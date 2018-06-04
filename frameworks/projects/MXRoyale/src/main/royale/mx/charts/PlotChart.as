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
	import mx.charts.chartClasses.ChartBase;
/*
import flash.utils.Dictionary;

import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.DataTip;
import mx.charts.renderers.BoxItemRenderer;
import mx.charts.renderers.CircleItemRenderer;
import mx.charts.renderers.DiamondItemRenderer;
import mx.charts.styles.HaloDefaults;
import mx.core.ClassFactory;
import mx.core.IFactory;
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

//[IconFile("PlotChart.png")]

/**
 *  The PlotChart control represents data with two values for each data point.
 *  One value determines the position of the data point along the horizontal
 *  axis, and one value determines its position along the vertical axis.
 *  
 *  <p>The PlotChart control expects its <code>series</code> property
 *  to contain an Array of PlotSeries objects.</p>
 * 
 *  @mxml
 *  
 *  The <code>&lt;mx:PlotChart&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:PlotChart
 *  /&gt;
 *  </pre> 
 *  
 *  
 *  @includeExample examples/PlotChartExample.mxml
 *  
 *  @see mx.charts.series.PlotSeries
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class PlotChart extends ChartBase//extends CartesianChart
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
    public function PlotChart()
    {
        super();
    }

    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  horizontalAxis
    //----------------------------------

    /**
     *  @private
     *  Storage for the horizontalAxis property.
     */
    private var _horizontalAxis:IAxis;
    
    /**
     *  Defines the labels, tick marks, and data position
     *  for items on the x-axis.
     *  Use either the LinearAxis class or the CategoryAxis class
     *  to set the properties of the horizontalAxis as a child tag in MXML
     *  or create a LinearAxis or CategoryAxis object in ActionScript.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	
    public function get horizontalAxis():IAxis
    {
        return _horizontalAxis;
    }
    
    /**
     *  @private
     */
	
    public function set horizontalAxis(value:IAxis):void
    {
        _horizontalAxis = value;
    }
	
}

}
