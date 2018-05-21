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

package mx.charts.series
{
/* 
import flash.display.DisplayObject;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

import mx.charts.DateTimeAxis;
import mx.charts.HitData;
import mx.charts.chartClasses.BoundedValue;
import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.CartesianTransform;
import mx.charts.chartClasses.DataDescription;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.IStackable;
import mx.charts.chartClasses.IStackable2;
import mx.charts.chartClasses.InstanceCache;
import mx.charts.chartClasses.LegendData;
import mx.charts.chartClasses.NumericAxis;
import mx.charts.chartClasses.Series;
import mx.charts.chartClasses.StackedSeries;
import mx.charts.renderers.AreaRenderer;
import mx.charts.series.items.AreaSeriesItem;
import mx.charts.series.renderData.AreaSeriesRenderData;
import mx.charts.styles.HaloDefaults;
import mx.collections.CursorBookmark;
import mx.core.ClassFactory;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;

include "../styles/metadata/FillStrokeStyles.as"
include "../styles/metadata/ItemRendererStyles.as" */


/**
 *  Defines a data series for an AreaChart control. By default, this class uses the AreaRenderer itemRenderer.
 *  Optionally, you can define a different itemRenderer for the 
 *  data series. The itemRenderer must implement the IDataRenderer interface. 
 *  
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:AreaSeries&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:AreaSeries
 *    <strong>Properties</strong>
 *    fillFunction="<i>Internal fill function</i>"
 *    horizontalAxis="<i>No default</i>"
 *    minField="null"
 *    sortOnXField="<i>true</i>"
 *    stacker="<i>No default</i>"
 *    stackTotals="<i>No default</i>"
 *    xField="null"
 *    verticalAxis="<i>No default</i>"
 *    yField="null"
 * 
 *    <strong>Styles</strong>
 *    adjustedRadius="2"
 *    areaFill="<i>IFill</i>"
 *    areaRenderer="<i>areaRenderer</i>"
 *    areaStroke="<i>Stroke</i>"
 *    fill="<i>IFill; no default</i>"
 *    fills="<i>IFill; no default</i>"
 *    form="<i>segment|curve|horizontal|reverseStep|step|vertical</i>"
 *    itemRenderer="<i>itemRenderer</i>"
 *    legendMarkerRenderer="<i>Defaults to series's itemRenderer</i>"
 *    radius="4"
 *    stroke="<i>IStroke; no default</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.charts.AreaChart
 *  
 *  @includeExample ../examples/Line_AreaChartExample.mxml
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AreaSeries 
{
//extends Series implements IStackable2
   // include "../../core/Version.as";

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
    public function AreaSeries()
    {
        super();

      /*   _instanceCache = new InstanceCache(null, this, 1);
        _instanceCache.creationCallback = applyItemRendererProperties;
        
        dataTransform = new CartesianTransform();

		// our style settings
		initStyles(); */
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

	

    //----------------------------------
    //  yField
    //----------------------------------

    /**
     *  @private
     *  Storage for the yField property.
     */
    private var _yField:String = "";

    [Inspectable(category="General")]
    
    /**
     *  Specifies the field of the data provider that determines the position of the data point on the vertical axis. 
     *  If <code>null</code>, the AreaSeries assumes the dataProvider 
     *  is an Array of numbers, and uses the numbers as values for the data points. 
     *  
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get yField():String
    {
        return _yField;
    }

    /**
     *  @private
     */
    public function set yField(value:String):void
    {
        _yField = value;

        //dataChanged();
    }
    
}

}

