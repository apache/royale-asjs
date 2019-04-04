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

[DefaultBindingProperty(destination="dataProvider")]

[DefaultTriggerEvent("itemClick")]

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
 *  @productversion Flex 3
 */
public class AreaChart extends CartesianChart
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
    public function AreaChart()
    {
        super();

        LinearAxis(horizontalAxis).autoAdjust = false;
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

    [Inspectable(category="General", enumeration="overlaid,stacked,100%", defaultValue="overlaid")]

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
     *  @productversion Flex 3
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
        invalidateSeries();
        invalidateData();
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
        
      	var areaChartSeriesStyles:Array /* of Object */ = [];
        
        var n:int = HaloDefaults.defaultFills.length;
        for (var i:int = 0; i < n; i++)
        {
            var styleName:String = "haloAreaSeries" + i;
            areaChartSeriesStyles[i] = styleName;
            
            var o:CSSStyleDeclaration =
                HaloDefaults.createSelector("." + styleName, styleManager);
            
            var f:Function = function(o:CSSStyleDeclaration, stroke:Stroke,
                                      fill:IFill):void
            {
                o.defaultFactory = function():void
                {
                    this.areaFill = fill;
                    this.fill = fill;
                }
            }
            
            f(o, null, HaloDefaults.defaultFills[i]);
        }
		
		var areaChartStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.AreaChart");
		if (areaChartStyle)
		{
			areaChartStyle.setStyle("chartSeriesStyles", areaChartSeriesStyles);
			areaChartStyle.setStyle("fill", new SolidColor(0xFFFFFF, 0));
			areaChartStyle.setStyle("calloutStroke", new SolidColorStroke(0x888888,2));
			areaChartStyle.setStyle("horizontalAxisStyleNames", ["hangingCategoryAxis"]);
			areaChartStyle.setStyle("verticalAxisStyleNames", ["blockNumericAxis"]);
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
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: ChartBase
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function customizeSeries(seriesGlyph:Series,
                                                i:uint):void
    {
        var aSeries:AreaSeries = seriesGlyph as AreaSeries;

        if (aSeries)
        {
            aSeries.stacker = null;
            aSeries.stackTotals = null;
        }
    }

    /**
     *  @private
     */
    override protected function applySeriesSet(seriesSet:Array /* of Series */,
                                               transform:DataTransform):Array /* of Series */
    {
        switch (_type)
        {
            case "stacked":
            case "100%":
            {
                var newSeriesGlyph:AreaSet = new AreaSet();
                newSeriesGlyph.series = seriesSet;
                newSeriesGlyph.type = _type;
                return [ newSeriesGlyph ];
            }               

            case "overlaid":
            default:
            {
                return super.applySeriesSet(seriesSet, transform);
            }
        }
    }
}

}
