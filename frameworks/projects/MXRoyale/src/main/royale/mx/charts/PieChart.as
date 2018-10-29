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

import mx.charts.chartClasses.DataTip;
import mx.charts.chartClasses.DataTransform;
import mx.charts.chartClasses.PolarChart;
import mx.charts.chartClasses.Series;
import mx.charts.series.PieSeries;
import mx.charts.styles.HaloDefaults;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;

use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------
include "styles/metadata/TextStyles.as"

/**
 *  Determines the size of the hole in the center of the pie chart.
 *  This property is a percentage value of the center circle's radius
 *  compared to the entire pie's radius.
 *  The default value is 0 percent.
 *  Use this property to create a doughnut-shaped chart.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="innerRadius", type="Number", inherit="no")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultBindingProperty(destination="dataProvider")]

[DefaultTriggerEvent("itemClick")]

//[IconFile("PieChart.png")]

/**
 *  The PieChart control represents a data series as a standard pie chart.
 *  The data for the data provider determines the size of each wedge
 *  in the pie chart relative to the other wedges.
 *  You can use the PieSeries class to create
 *  standard pie charts, doughnut charts, or stacked pie charts.
 *  
 *  <p>The PieChart control expects its <code>series</code> property
 *  to contain an Array of PieSeries objects.</p>
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:PieChart&gt;</code> tag inherits all the properties
 *  of its parent classes, and adds the following properties:
 *  
 *  <pre>
 *  &lt;mx:PieChart
 *    <strong>Styles</strong>
 *    innerRadius="0"
 *    textAlign="left"
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/PieChartExample.mxml
 *  
 *  @see mx.charts.series.PieSeries
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class PieChart extends PolarChart
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
    public function PieChart()
    {
        super();

        dataTipMode = "single";
        
        var aa:LinearAxis = new LinearAxis();
        aa.minimum = 0;
        aa.maximum = 100;
        angularAxis = aa;
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

    
    /**
     *  @private
     */
    private var _seriesWidth:Number;
    
    /**
     *  @private
     */
    private var _innerRadius:Number;

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  legendData
    //----------------------------------

    /**
     *  @private
     */
    override public function get legendData():Array /* of LegendData */
    {
        var keyItems:Array /* of LegendData */ = [];

        if (series.length > 0)
            keyItems = [ series[0].legendData ];

        return keyItems;
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
		
		var pieChartStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.PieChart");
		if (pieChartStyle)
		{
			pieChartStyle.setStyle("fill", new SolidColor(0xFFFFFF, 0));
			pieChartStyle.setStyle("calloutStroke", new SolidColorStroke(0x888888,2));
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
    
    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        if (styleProp == null || styleProp == "innerRadius")
            invalidateSeries();

        super.styleChanged(styleProp);
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: ChartBase
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function customizeSeries(seriesGlyph:Series, i:uint):void
    {
        if (seriesGlyph is PieSeries)
        {
            PieSeries(seriesGlyph).setStyle("innerRadius",
                                            _innerRadius + i * _seriesWidth);

            PieSeries(seriesGlyph).outerRadius =
                _innerRadius + (i + 1) *_seriesWidth;
        }
    }

    /**
     *  @private
     */
    override protected function applySeriesSet(seriesSet:Array /* of Series */,
                                               transform:DataTransform):Array /* of Series */
    {
        _innerRadius = getStyle("innerRadius");
        _innerRadius = isNaN(_innerRadius) ? 0 : _innerRadius;
        _seriesWidth = (1 - _innerRadius) / seriesSet.length;

        return super.applySeriesSet(seriesSet, transform);
    }
}

}
