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

//import flash.filters.DropShadowFilter;

import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.DataTip;
import mx.charts.chartClasses.IAxis;
import mx.charts.renderers.LineRenderer;
import mx.charts.styles.HaloDefaults;
import mx.core.ClassFactory;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;

use namespace mx_internal;

[DefaultBindingProperty(destination="dataProvider")]

[DefaultTriggerEvent("itemClick")]

//[IconFile("LineChart.png")]

/**
 *  The LineChart control represents a data series
 *  as points connected by a continuous line.
 *  You can use an icon or symbol to represent each data point
 *  along the line, or show a simple line with no icons. 
 *  
 *  <p>The LineChart control expects its <code>series</code> property
 *  to contain an Array of LineSeries objects.</p>
 * 
 *  @mxml
 *  
 *  The <code>&lt;mx:LineChart&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:LineChart
 *  /&gt;
 *  </pre> 
 *  
 *  @includeExample examples/Line_AreaChartExample.mxml
 *  
 *  @see mx.charts.series.LineSeries
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class LineChart extends CartesianChart
{
//    include "../core/Version.as";

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
     *  @productversion Flex 3
     */
    public function LineChart()
    {
        super();

        LinearAxis(horizontalAxis).autoAdjust = false;

        seriesFilters = [ /*new DropShadowFilter()*/ ];
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
//    private static var _moduleFactoryInitialized:Dictionary = new Dictionary(true);
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  horizontalAxis
    //----------------------------------

    [Inspectable(category="Data")]

    /**
     *  @private
     */
    override public function set horizontalAxis(value:IAxis):void
    {
        if (value is CategoryAxis)
            CategoryAxis(value).padding = 0;
            
        super.horizontalAxis = value;
    }   

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private function initStyles():Boolean
    {
        HaloDefaults.init(styleManager);
        
        var lineChartSeriesStyles:Array /* of Object */ = [];
		
		var lineChartStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.LineChart");
		if (lineChartStyle)
		{
			lineChartStyle.setStyle("chartSeriesStyles", lineChartSeriesStyles);
			lineChartStyle.setStyle("fill", new SolidColor(0xFFFFFF, 0));
			lineChartStyle.setStyle("calloutStroke", new SolidColorStroke(0x888888,2));
			lineChartStyle.setStyle("horizontalAxisStyleNames", ["hangingCategoryAxis"]);
			lineChartStyle.setStyle("verticalAxisStyleNames", ["blockNumericAxis"]);
	        
	        var n:int = HaloDefaults.defaultColors.length;
	        for (var i:int = 0; i < n; i++)
	        {
	            var styleName:String = "haloLineSeries" + i;
	            lineChartSeriesStyles[i] = styleName;
	            
	            var o:CSSStyleDeclaration =
	                HaloDefaults.createSelector("." + styleName, styleManager);
	            
	            var f:Function = function(o:CSSStyleDeclaration, stroke:Stroke):void
	            {
	                o.defaultFactory = function():void
	                {
	                    this.lineStroke = stroke;
	                    this.stroke = stroke;
	                    this.lineSegmentRenderer = new ClassFactory(LineRenderer);
	                }
	            }
	            
	            f(o, new Stroke(HaloDefaults.defaultColors[i], 3, 1));
	        }
		}        
        return true;
    }
    
    /**
     *   A module factory is used as context for using embedded fonts and for finding the style manager that controls the styles for this component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function set moduleFactory(factory:IFlexModuleFactory):void
    {
        super.moduleFactory = factory;
        
        /*
        if (_moduleFactoryInitialized[factory])
            return;
        
        _moduleFactoryInitialized[factory] = true;
        */
        
        // our style settings
        initStyles();
    }
}

}
