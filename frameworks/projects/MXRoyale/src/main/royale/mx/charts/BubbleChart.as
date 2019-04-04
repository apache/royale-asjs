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
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.Series;
import mx.charts.series.BubbleSeries;
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

/**
 *  The maximum radius of the largest chart element, in pixels
 *  Flex assigns this radius to the data point with the largest value;
 *  all other data points are assigned a smaller radius
 *  based on their value relative to the smallest and largest value.
 *  The default value is 50 pixels.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="maxRadius", type="Number", format="Length", inherit="no")]

/**
 *  The minimum radius of the smallest chart element, in pixels
 *  Flex assigns this radius to the data point with the smallest value;
 *  all other data points are assigned a larger radius
 *  based on their value relative to the smallest and largest value.
 *  The default value is 0 pixels.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="minRadius", type="Number", format="Length", inherit="no")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultBindingProperty(destination="dataProvider")]

[DefaultTriggerEvent("itemClick")]

//[IconFile("BubbleChart.png")]

/**
 *  The BubbleChart control represents data with three values
 *  for each data point.
 *  Each data point is defined by a value determining its position
 *  along the horizontal axis, a value determining its position
 *  along the vertical axis, and a value determining the size
 *  of the chart element, relative to the other data points on the chart.
 *  
 *  <p>The BubbleChart control expects its <code>series</code> property
 *  to contain an array of BubbleSeries objects.</p>
 *  
 *  @mxml
 *  
 *  The <code>&lt;mx:BubbleChart&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:BubbleChart
 *    <strong>Properties</strong>
 *    radiusAxis="<i>LinearAxis</i>"
 * 
 *    <strong>Styles</strong>
 *    maxRadius="50"
 *    minRadius="0"
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/BubbleChartExample.mxml
 *  
 *  @see mx.charts.series.BubbleSeries
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class BubbleChart extends CartesianChart
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
    public function BubbleChart()
    {
        super();

        var zAxis:LinearAxis = new LinearAxis();
        zAxis.autoAdjust = false;
        zAxis.minimum = 0;
        zAxis.interval = 1;
        radiusAxis = zAxis;
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
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  radiusAxis
    //----------------------------------

    /**
     *  @private
     *  Storage for the radiusAxis property.
     */
    private var _radiusAxis:IAxis;
    
    [Inspectable(category="Data")]

    /**
     *  The axis the bubble radius is mapped against
     *  Bubble charts treat the size of the individual bubbles
     *  as a third dimension of data which is transformed
     *  in a similar manner to how x and y position is transformed.  
     *  By default, the <code>radiusAxis</code> is a LinearAxis
     *  with the <code>autoAdjust</code> property set to <code>false</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get radiusAxis():IAxis
    {
        return _transforms[0].getAxis(BubbleSeries.RADIUS_AXIS);
    }

    /**
     *  @private
     */
    public function set radiusAxis(value:IAxis):void
    {
        _radiusAxis = value;
        _transforms[0].setAxis(BubbleSeries.RADIUS_AXIS, value);
        
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
		
		var bubbleChartStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.BubbleChart");
		if (bubbleChartStyle)
		{
			bubbleChartStyle.setStyle("chartSeriesStyles", HaloDefaults.chartBaseChartSeriesStyles);
			bubbleChartStyle.setStyle("dataTipCalloutStroke", new SolidColorStroke(2,0));
			bubbleChartStyle.setStyle("fill", new SolidColor(0xFFFFFF, 0));
			bubbleChartStyle.setStyle("calloutStroke", new SolidColorStroke(0x888888,2));
			bubbleChartStyle.setStyle("horizontalAxisStyleNames", ["blockNumericAxis"]);
			bubbleChartStyle.setStyle("verticalAxisStyleNames", ["blockNumericAxis"]);
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
        var series:Array /* of Series */;
        var n:int;
        var i:int;
        
        if (styleProp == null || styleProp == "maxRadius")
        {
            var maxRadius:Number = getStyle("maxRadius");
            
            series = this.series;
            n = series.length;
            for (i = 0; i < n; i++)
            {
                if (series[i] is BubbleSeries)
                {
                    series[i].maxRadius = maxRadius;
                    series[i].invalidateDisplayList();
                }
            }                       
        }
        if (styleProp == null || styleProp == "minRadius")
        {
            var minRadius:Number = getStyle("minRadius");
            
            series = this.series;
            n = series.length;
            for (i = 0; i < n; i++)
            {
                if (series[i] is BubbleSeries)
                {
                    series[i].minRadius = minRadius;
                    series[i].invalidateDisplayList();
                }
            }                   
        }
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
        var maxRadius:Number = getStyle("maxRadius");
        var minRadius:Number = getStyle("minRadius");

        if ((seriesGlyph is BubbleSeries) && !isNaN(maxRadius))
            BubbleSeries(seriesGlyph).maxRadius = maxRadius;
        if ((seriesGlyph is BubbleSeries) && !isNaN(minRadius))
            BubbleSeries(seriesGlyph).minRadius = minRadius;
    }
}

}
