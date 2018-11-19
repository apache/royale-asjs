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

import mx.display.Graphics;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;

import mx.charts.DateTimeAxis;
import mx.charts.HitData;
import mx.charts.chartClasses.BoundedValue;
import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.CartesianTransform;
import mx.charts.chartClasses.DataDescription;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.InstanceCache;
import mx.charts.chartClasses.LegendData;
import mx.charts.chartClasses.NumericAxis;
import mx.charts.chartClasses.Series;
import mx.charts.renderers.LineRenderer;
import mx.charts.series.items.LineSeriesItem;
import mx.charts.series.items.LineSeriesSegment;
import mx.charts.series.renderData.LineSeriesRenderData;
import mx.charts.styles.HaloDefaults;
import mx.collections.CursorBookmark;
import mx.core.ClassFactory;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.core.UIComponent;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.LinearGradientStroke;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;

include "../styles/metadata/FillStrokeStyles.as"
include "../styles/metadata/ItemRendererStyles.as"

/**
 *  Specifies the number of pixels by which radius of the chart item is to be 
 *  increased when highlighted or selected.
 * 
 *  @default 2
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="adjustedRadius", type="Number", format="Length", inherit="yes")]

/**
 *  Specifies an Array of fill objects that define the fill for
 *  each item in the series. This takes precedence over the <code>fill</code> style property.
 *  If a custom method is specified by the <code>fillFunction</code> property, that takes precedence over this Array.
 *  If you do not provide enough Array elements for every item,
 *  Flex repeats the fill from the beginning of the Array.
 *  
 *  <p>To set the value of this property using CSS:
 *   <pre>
 *    LineSeries {
 *      fills:#CC66FF, #9966CC, #9999CC;
 *    }
 *   </pre>
 *  </p>
 *  
 *  <p>To set the value of this property using MXML:
 *   <pre>
 *    &lt;mx:LineSeries ... &gt;
 *     &lt;mx:fills&gt;
 *      &lt;mx:SolidColor color="0xCC66FF"/&gt;
 *      &lt;mx:SolidColor color="0x9966CC"/&gt;
 *      &lt;mx:SolidColor color="0x9999CC"/&gt;
 *     &lt;/mx:fills&gt;
 *    &lt;/mx:LineSeries&gt;
 *   </pre>
 *  </p>
 *  
 *  <p>
 *  If you specify the <code>fills</code> property and you
 *  want to have a Legend control, you must manually create a Legend control and 
 *  add LegendItems to it.
 *  </p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fills", type="Array", arrayType="mx.graphics.IFill", inherit="no")]

/**
 *  Specifies the line type for the chart.
 *  Possible values are:
 *  <ul>
 *    <li><code>"curve"</code>:
 *    Draws curves between data points.</li>
 *    
 *    <li><code>"horizontal"</code>:
 *    Draws only the vertical line from the x-coordinate
 *    of the first point to the x-coordinate of the second point
 *    at the y-coordinate of the second point.
 *    Repeats this for each data point.</li>
 *    
 *    <li><code>"vertical"</code>:
 *    Draws only the vertical line from the y-coordinate
 *    of the first point to the y-coordinate of the second point
 *    at the x-coordinate of the second point.
 *    Repeats this for each data point.</li>
 *    
 *    <li><code>"segment"</code>:
 *    Draws lines as connected segments that are angled
 *    to connect at each data point in the series.</li>
 *    
 *    <li><code>"step"</code>:
 *    Draws lines as horizontal segments.
 *    At the first data point, draws a horizontal line
 *    and then a vertical line to the second point,
 *    and repeats for each data point.</li>
 *    
 *    <li><code>"reverseStep"</code>:
 *    Draws lines as horizontal segments.
 *    At the first data point, draws a vertical line
 *    and then a horizontal line to the second point,
 *    and repeats for each data point.</li>
 *  </ul>
 *  The default is <code>"segment"</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="form", type="String", enumeration="segment,step,reverseStep,vertical,horizontal,curve", inherit="no")]

/**
 *  A factory that represents the class the series uses
 *  to represent the individual line segments in the series.
 *  This class is instantiated once
 *  for each distinct segment of the series.
 *  Classes used as lineSegmentRenderers should implement
 *  the IFlexDisplayObject, ISimpleStyleClient, and IDataRenderer interfaces.
 *  The <code>data</code> property is assigned an instance of
 *  mx.charts.series.items.LineSeriesSegment
 *  that describes the segment to render.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="lineSegmentRenderer", type="mx.core.IFactory", inherit="no")]

/** 
 *  Specifies the radius, in pixels, of the chart elements for the data points.
 *  This property applies only if you specify an item renderer
 *  using the <code>itemRenderer</code> property.  
 *  You can specify the <code>itemRenderer</code> in MXML or using styles.  
 *  
 *  @default 4 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="radius", type="Number", format="Length", inherit="no")]

/**
 *  Defines a data series for a LineChart control.
 *  By default, this class uses the ShadowLineRenderer class. 
 *  Optionally, you can define an itemRenderer for the data series.
 *  The itemRenderer must implement the IDataRenderer interface. 
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:LineSeries&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:LineSeries
 *    <strong>Properties</strong>
 *    fillFunction="<i>Internal fill function</i>"
 *    horizontalAxis="<i>No default</i>"
 *    interpolateValues="false|true"
 *    sortOnXField="false|true"
 *    verticalAxis="<i>No default</i>"
 *    xField="null"
 *    yField="null"
 * 
 *    <strong>Styles</strong>
 *    adjustedRadius="2"
 *    fill="0xFFFFFF"
 *    fills="<i>IFill; no default</i>"
 *    form="segment|curve|horizontal|reverseStep|step|vertical"
 *    itemRenderer="<i>itemRenderer</i>"
 *    legendMarkerRenderer="<i>Defaults to series's itemRenderer</i>"
 *    lineSegmentRenderer="<i>ShadowLineRenderer</i>"
 *    lineStroke="Stroke(0xE47801,3)"
 *    radius="4"
 *    stroke="<i>IStroke; no default</i>" 
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.charts.LineChart
 *  @see mx.core.IDataRenderer
 *  
 *  @includeExample ../examples/Line_AreaChartExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class LineSeries extends Series
{
//    include "../../core/Version.as";

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
    public function LineSeries()
    {
        super();

        _pointInstanceCache = new InstanceCache(null, this, 1000);
        _pointInstanceCache.creationCallback = applyItemRendererProperties;
        
        _segmentInstanceCache = new InstanceCache(null, this, 0);
        _segmentInstanceCache.properties = { styleName: this };
        
        dataTransform = new CartesianTransform();

        // our style settings
        initStyles();
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
    private var _pointInstanceCache:InstanceCache;
    
    /**
     *  @private
     */
    private var _renderData:LineSeriesRenderData;   

    /**
     *  @private
     */
    private var _segmentInstanceCache:InstanceCache;
    
    /**
     *  @private
     */
    private var _localFills:Array /* of IFill */;
    
        
    /**
     *  @private
     */
    private var _fillCount:int;
     
    /**
     * @private
     */
    private var _bAxesDirty:Boolean = false;
     
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
        if (fillFunction!=defaultFillFunction || _fillCount!=0)
        {
            var keyItems:Array /* of LegendData */ = [];
            return keyItems;
        }
        var radius:Number = getStyle("radius")
        var itemRenderer:IFactory = getStyle("itemRenderer");

        var markerAspectRatio:Number;
        var color:int = 0;
        var marker:IFlexDisplayObject;
        
        var ld:LegendData = new LegendData();
        ld.element = this;
        ld.label = displayName; 
        
        
        var markerFactory:IFactory = getStyle("legendMarkerRenderer");
        if (markerFactory)
        {
            marker = markerFactory.newInstance();
            if (marker is ISimpleStyleClient)
                (marker as ISimpleStyleClient).styleName = this;
            ld.aspectRatio = 1;
        }
        else if (!itemRenderer || radius == 0 || isNaN(radius))
        {
            marker = new LineSeriesLegendMarker(this);          
        }
        else
        {
            markerFactory = getStyle("itemRenderer");
            marker = markerFactory.newInstance();
            ld.aspectRatio = 1;
            if (marker as ISimpleStyleClient)
                (marker as ISimpleStyleClient).styleName = this;
        }

        ld.marker = marker;
        
        return [ld];
    }

    //----------------------------------
    //  renderData
    //----------------------------------

    /**
     *  @private
     */
    override protected function get renderData():Object
    {
        if (!_renderData||
            !(_renderData.cache) ||
            _renderData.cache.length == 0)
        {
            var renderDataType:Class = this.renderDataType;
            var ld:LineSeriesRenderData = new renderDataType();
            ld.cache = ld.filteredCache = [];
            ld.segments = [];
            ld.radius = 0;
            return ld;
        }

        _renderData.radius = getStyle("radius");

        return _renderData;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //-----------------------------------
    // fillFunction
    //-----------------------------------
    
    [Bindable]
    [Inspectable(category="General")]
    
    /**
     * @private
     * Storage for fillFunction property
     */
    private var _fillFunction:Function=defaultFillFunction;
    
    /**
     * Specifies a method that returns the fill for the current chart item in the series.
     * If this property is set, the return value of the custom fill function takes precedence over the 
     * <code>fill</code> and <code>fills</code> style properties.
     * But if it returns null, then <code>fills</code> and <code>fill</code> will be 
     * prefered in that order.  
     * 
     * <p>The custom <code>fillFunction</code> has the following signature:
     *  
     * <pre>
     * <i>function_name</i> (item:ChartItem, index:Number):IFill { ... }
     * </pre>
     * 
     * <code>item</code> is a reference to the chart item that is being rendered.
     * <code>index</code> is the index of the chart item in the renderData's cache. This is different
     * from the index of the chart's data provider because it is sorted based on the x, y, and z values.
     * This function returns an object that implements the <code>IFill</code> interface.
     * </p>
     *  
     * <p>An example usage of a customized <code>fillFunction</code> is to return a fill
     * based on some threshold.</p>
     *   
     * @example
     * <pre>
     * public function myFillFunction(item:ChartItem, index:Number):IFill {
     *      var curItem:LineSeriesItem = LineSeriesItem(item);
     *      if (curItem.yNumber > 10)
     *          return(new SolidColor(0x123456, .75));
     *      else
     *          return(new SolidColor(0x563412, .75));
     * }
     * </pre>
     *   
     * <p>
     *  If you specify a custom fill function for your chart series and you
     *  want to have a Legend control, you must manually create a Legend control and 
     *  add LegendItems to it.
     *  </p>
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get fillFunction():Function
    {
        return _fillFunction;
    }
   
    /**
     * @private
     */
    public function set fillFunction(value:Function):void
    {
        if (value ==_fillFunction)
            return;
            
        if (value != null)
            _fillFunction = value;
        
        else
            _fillFunction = defaultFillFunction;
        
        invalidateDisplayList();
        legendDataChanged();        
    }
    
    //----------------------------------
    //  horizontalAxis
    //----------------------------------

    /**
     *  @private
     *  Storage for the horizontalAxis property.
     */
    private var _horizontalAxis:IAxis;
    
    [Inspectable(category="Data")]

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
     *  @productversion Flex 3
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
        _bAxesDirty = true;

        invalidateData();
        invalidateProperties();
    }
    
    //----------------------------------
    //  interpolateValues
    //----------------------------------

    /**
     *  @private
     *  Storage for the interpolateValues property.
     */
    private var _interpolateValues:Boolean = false; 

    [Inspectable(category="General")]

    /** 
     *  Specifies how to represent missing data.
     *
     *  <p>Set to <code>false</code> to break the line at the missing value.
     *  Set to <code>true</code> to draw a continuous line by interpolating the missing value.</p>
     *  
     *  @default false
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function get interpolateValues():Boolean
    {
        return _interpolateValues;
    }

    /**
     *  @private
     */
    public function set interpolateValues(value:Boolean):void
    {
        if (_interpolateValues != value)
        {
            _interpolateValues = value;

            invalidateData();
        }       
    }

    //----------------------------------
    //  items
    //----------------------------------

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get items():Array /* of LineSeriesItem */
    {
        return _renderData ?
               _renderData.filteredCache :
               null;
    }

    //----------------------------------
    //  itemType
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The subtype of ChartItem used by this series
     *  to represent individual items.
     *  Subclasses can override and return a more specialized class
     *  if they need to store additional information in the items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get itemType():Class
    {
        return LineSeriesItem;
    }
    
    //----------------------------------
    //  lineSegmentType
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The class used by this series to store all data
     *  necessary to represent a line segment.
     *  Subclasses can override and return a more specialized class
     *  if they need to store additional information for rendering.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get lineSegmentType():Class
    {
        return LineSeriesSegment;
    }

    
    //----------------------------------
    //  lineStroke
    //----------------------------------
    
    /** 
     *  Sets the stroke for the actual line segments. 
     *  The default value for a LineChart control is orange (<code>0xE48701</code>). 
     *  The default color for a LineSeries used in a CartesianChart control is black (<code>0x000000</code>). 
     *  The default value for the width is 3.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get lineStroke():IStroke
    {
        return getStyle("lineStroke");
    }
    public function set lineStroke(value:IStroke):void
    {
        setStyle("lineStroke", value);
        if (parent)
            updateDisplayList(width, height);
        legendDataChanged();
    }
    
    //----------------------------------
    //  radius
    //----------------------------------
    
    [Inspectable(category="Styles")]

    /** 
     *  Specifies the radius, in pixels, of the chart elements
     *  for the data points.
     *  This property applies only if you specify an item renderer
     *  using the <code>itemRenderer</code> property.  
     *  You can specify the <code>itemRenderer</code> in MXML or using styles.  
     *  
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get radius():Number
    {
        return getStyle("radius");
    }
    
    /**
     *  @private
     */
    public function set radius(value:Number):void
    {
        setStyle("radius", value);
    }

    //----------------------------------
    //  renderDataType
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The subtype of ChartRenderData used by this series
     *  to store all data necessary to render.
     *  Subclasses can override and return a more specialized class
     *  if they need to store additional information for rendering.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get renderDataType():Class
    {
        return LineSeriesRenderData;
    }    
    
    //----------------------------------
    //  sortOnXField
    //----------------------------------

    /**
     *  @private
     *  Storage for the sortOnXField property.
     */
    private var _sortOnXField:Boolean = true;

    [Inspectable]

    /** 
     *  Requests the line datapoints be sorted from left to right
     *  before rendering.
     *
     *  <p>By default, the LineSeries renders points from left to right.
     *  Set this property to <code>false</code> to render the items
     *  in the order they appear in the data provider.</p>
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get sortOnXField():Boolean
    {
        return _sortOnXField;
    }

    /**
     *  @private
     */
    public function set sortOnXField(value:Boolean):void 
    {
        if (_sortOnXField == value)
            return;
        _sortOnXField = value;

        invalidateMapping();
    }

    //----------------------------------
    //  verticalAxis
    //----------------------------------

    /**
     *  @private
     *  Storage for the verticalAxis property.
     */
    private var _verticalAxis:IAxis;

    [Inspectable(category="Data")]

    /**
     *  Defines the labels, tick marks, and data position
     *  for items on the y-axis.
     *  Use either the LinearAxis class or the CategoryAxis class
     *  to set the properties of the verticalAxis as a child tag in MXML
     *  or create a LinearAxis or CategoryAxis object in ActionScript.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get verticalAxis():IAxis
    {
        return _verticalAxis;
    }
    
    /**
     *  @private
     */
    public function set verticalAxis(value:IAxis):void
    {
        _verticalAxis = value;
        _bAxesDirty = true;

        invalidateData();
        //invalidateChildOrder();
        invalidateProperties();
    }
    
    //----------------------------------
    //  xField
    //----------------------------------

    /**
     *  @private
     *  Storage for the xField property.
     */
    private var _xField:String = "";
    
    [Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider
     *  that determines the x-axis location of each data point. 
     *  If <code>null</code>, the data points are rendered
     *  in the order they appear in the data provider.
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get xField():String
    {
        return _xField;
    }
    
    /**
     *  @private
     */
    public function set xField(value:String):void
    {
        _xField = value;

        dataChanged();
    }

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
     *  Specifies the field of the data provider
     *  that determines the y-axis location of each data point. 
     *  If <code>null</code>, the LineSeries assumes the data provider
     *  is an Array of numbers, and uses the numbers as values. 
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

        dataChanged();
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

	/**
     *  @private
     */
    private function initStyles():void
    {
        HaloDefaults.init(styleManager);

		var lineSeriesStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.series.LineSeries");


		if (lineSeriesStyle)
		{
			lineSeriesStyle.setStyle("lineSegmentRenderer", new ClassFactory(LineRenderer));
			lineSeriesStyle.setStyle("fill", new SolidColor(0xFFFFFF));
			lineSeriesStyle.setStyle("fills", []);
			lineSeriesStyle.setStyle("lineStroke", new SolidColorStroke(0,3));
		}
        else
        {
            //Fallback to set the style to this chart directly.
			setStyle("lineSegmentRenderer", new ClassFactory(LineRenderer));
			setStyle("fill", new SolidColor(0xFFFFFF));
			setStyle("fills", []);
			setStyle("lineStroke", new SolidColorStroke(0,3));
        }
    }


    /**
     *  @inheritDoc
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
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function commitProperties():void
    {
        super.commitProperties();
        
        if (dataTransform)
        {
            if (_horizontalAxis)
            {
                _horizontalAxis.chartDataProvider = dataProvider;
                CartesianTransform(dataTransform).setAxis(
                    CartesianTransform.HORIZONTAL_AXIS,_horizontalAxis);
            }
              
            if (_verticalAxis)
            {
                _verticalAxis.chartDataProvider = dataProvider;
                CartesianTransform(dataTransform).setAxis(
                    CartesianTransform.VERTICAL_AXIS, _verticalAxis);
            } 
        }
        
        var c:CartesianChart = CartesianChart(chart);
        if (c)
        {
            if (!_horizontalAxis)
            {
                if (dataTransform.axes[CartesianTransform.HORIZONTAL_AXIS] != c.horizontalAxis)
                        CartesianTransform(dataTransform).setAxis(
                            CartesianTransform.HORIZONTAL_AXIS,c.horizontalAxis);
            }
                            
            if (!_verticalAxis)
            {
                if (dataTransform.axes[CartesianTransform.VERTICAL_AXIS] != c.verticalAxis)
                        CartesianTransform(dataTransform).setAxis(
                            CartesianTransform.VERTICAL_AXIS, c.verticalAxis);
            }
        }
        dataTransform.elements = [this];
    }
    
    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        var renderData:LineSeriesRenderData = (transitionRenderData)? LineSeriesRenderData(transitionRenderData) :_renderData; 
        if (!renderData || !(renderData.filteredCache))
            return;
        
        var g:Graphics = graphics;
        
        g.clear();

        var radius:Number = getStyle("radius");     
        var sampleCount:int = renderData.filteredCache.length;
        var i:int;
            
        
        var segCount:int = renderData.segments.length;

    
        var activeRenderCache:Array /* of LineSeriesItem */;
        
        // figure out what cache we're rendering from. If there's a bounds based transtion underway, we need
        // to rebuild our cache from the bounds
        if (renderData == transitionRenderData && renderData.elementBounds)
        {
            var elementBounds:Array /* of Rectangle */ = renderData.elementBounds;
            sampleCount= elementBounds.length;
            activeRenderCache = renderData.filteredCache;


            for (i = 0; i < sampleCount; i++)
            {
                var rcBounds:Object = elementBounds[i];
                var localData:LineSeriesItem = activeRenderCache[i];
                localData.x = (rcBounds.left + rcBounds.right)/2;
                localData.y = (rcBounds.bottom + rcBounds.top)/2;
            }
        }
        else
        {
            activeRenderCache = renderData.filteredCache;
        }

        // now position each segment
        
        _segmentInstanceCache.factory = getStyle("lineSegmentRenderer");
        _segmentInstanceCache.count = segCount;
        var instances:Array /* of IFlexDisplayObject */ = _segmentInstanceCache.instances;
        var v:LineSeriesItem;
        
        for (i = 0; i < segCount; i++)
        {
            var segment:IFlexDisplayObject = instances[i];
            if (segment is IDataRenderer)
                IDataRenderer(segment).data = renderData.segments[i];
            segment.setActualSize(unscaledWidth,unscaledHeight);
        }       
        
        
        // if the user has asked for markers at each datapoint, position those as well
        if (radius > 0)
        {
            _pointInstanceCache.factory = getStyle("itemRenderer");
            _pointInstanceCache.count = renderData.validPoints;         

            instances = _pointInstanceCache.instances;
            var nextInstanceIdx:int = 0;

            var bSetData:Boolean = (sampleCount > 0 && (instances[0] is IDataRenderer))

            var rc:Rectangle;
            var inst:IFlexDisplayObject;
            
            if (renderData == transitionRenderData && renderData.elementBounds)
            {
                for (i = 0; i < sampleCount; i++)
                {
                    v = activeRenderCache[i];
                    inst = instances[nextInstanceIdx++];
                    v.itemRenderer = inst;
                    v.fill = fillFunction(v,i);
                    if (!(v.fill))
                        v.fill = defaultFillFunction(v,i);
                    if (v.itemRenderer && (v.itemRenderer as Object).hasOwnProperty('invalidateDisplayList'))
                        (v.itemRenderer as Object).invalidateDisplayList();
                    if (inst)
                    {
                        if (bSetData)
                            IDataRenderer(inst).data = v;
                        rc = elementBounds[i];
                        inst.move(rc.left,rc.top);
                        inst.setActualSize(rc.width,rc.height);
                    }
                }
            }
            else
            {
                for (i = 0; i < sampleCount; i++)
                {
                    v  = activeRenderCache[i];
                    var e:Object = renderData.filteredCache[i];
                    //if (filterData && (isNaN(e.xFilter) || isNaN(e.yFilter)))
                    if(filterFunction == defaultFilterFunction && 
                            ((filterDataValues == "outsideRange" && (isNaN(e.xFilter) || isNaN(e.yFilter))) ||
                             (filterDataValues == "nulls" && (isNaN(e.xNumber) || isNaN(e.yNumber)))))
                        continue;

                    inst = instances[nextInstanceIdx++];
                    v.itemRenderer = inst;
                    v.fill = fillFunction(v,i);
                    if (!(v.fill))
                        v.fill = defaultFillFunction(v,i);
                    if (v.itemRenderer && (v.itemRenderer as Object).hasOwnProperty('invalidateDisplayList'))
                        (v.itemRenderer as Object).invalidateDisplayList();
                    if (inst)
                    {
                        if (bSetData)
                            IDataRenderer(inst).data = v;
                        inst.move(v.x-radius,v.y - radius);
                        inst.setActualSize(2*radius,2*radius);
                    }
                }
                if (chart && allSeriesTransform && chart.chartState == 0)
                    chart.updateAllDataTips();
            }               
        }
    }
    
    /**
     *  @private
     */
    override public function stylesInitialized():void
    {
        _localFills = getStyle('fills');
        if (_localFills != null)
            _fillCount = _localFills.length;
        else
            _fillCount = 0;
        super.stylesInitialized();
    }

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);
        var styles:String = "fills"
        if (styles.indexOf(styleProp)!=-1)
        {
            _localFills = getStyle('fills');
            if (_localFills != null)
                _fillCount = _localFills.length;
            else
                _fillCount = 0;                
        }
        if (styleProp == "itemRenderer")
        {
            _pointInstanceCache.remove = true;
            _pointInstanceCache.discard = true;
            _pointInstanceCache.count = 0;
            _pointInstanceCache.discard = false;
            _pointInstanceCache.remove = false;
        }
        if (styleProp == "lineSegmentRenderer")
        {
            _segmentInstanceCache.remove = true;
            _segmentInstanceCache.discard = true;
            _segmentInstanceCache.count = 0;
            _segmentInstanceCache.discard = false;
            _segmentInstanceCache.remove = false;
        }

        invalidateDisplayList();

        legendDataChanged();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: ???
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function updateData():void
    {
        var renderDataType:Class = this.renderDataType;
        _renderData= new renderDataType();

        _renderData.cache = [];

        if (dataProvider)
        {           
            cursor.seek(CursorBookmark.FIRST);
            var i:int = 0;
            var itemClass:Class = itemType;
            while (!cursor.afterLast)
            {
                _renderData.cache[i] = new itemClass(this,cursor.current,i);
                i++;
                cursor.moveNext();
            }

            cacheDefaultValues(_yField,_renderData.cache,"yValue");
            cacheIndexValues(_xField,_renderData.cache,"xValue");
        }
        if(dataTransform && dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) is NumericAxis &&
            !(dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) is DateTimeAxis) && 
            (dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) as NumericAxis).direction == "inverted")  
            _renderData.cache = reverseYValues(_renderData.cache);
        if(dataTransform && dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) is NumericAxis &&
            !(dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) is DateTimeAxis) &&
            (dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) as NumericAxis).direction == "inverted")  
            _renderData.cache = reverseXValues(_renderData.cache);  
        _renderData.validPoints = _renderData.cache.length;
        super.updateData();
    }

    /**
     *  @private
     */
    override protected function updateMapping():void
    {
        dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(_renderData.cache,"xValue","xNumber", (_xField == ""));
        dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(_renderData.cache,"yValue","yNumber");
        // now convert
        if (_xField != "" && _sortOnXField)
            _renderData.cache.sortOn("xNumber",Array.NUMERIC);      

        super.updateMapping();

    }

    /**
     *  @private
     */
    override protected function updateFilter():void
    {
        _renderData.segments = [];
        var lineSegmentType:Class = this.lineSegmentType;
        _renderData.filteredCache = filterFunction(_renderData.cache);
    
        if(filterFunction != defaultFilterFunction)
        // we do this only for custom filter function because default filter function
        //already does this as part of the function.
        {
            createLineSegments(_renderData.filteredCache);
        }
        super.updateFilter();
    }
    
    /**
     *  @private
     */
    override protected function updateTransform():void
    {
        dataTransform.transformCache(_renderData.filteredCache,"xNumber","x","yNumber","y");
        super.updateTransform();
        allSeriesTransform = true;
            
        if (chart && chart is CartesianChart)
        {   
            var cChart:CartesianChart = CartesianChart(chart);  
            var n:int = cChart.series.length;
            
            for (var i:int = 0; i < n; i++)
            {
                if (cChart.getSeriesTransformState(cChart.series[i]))
                    allSeriesTransform = false;
            }
            if (allSeriesTransform)
                cChart.measureLabels();
        }   
    }

    /**
     *  @private
     */
    override public function describeData(dimension:String,
                                          requiredFields:uint):Array /* of DataDescription */
    {
        validateData();

        if (_renderData.cache.length == 0)
            return [];
            
        var description:DataDescription = new DataDescription();
        description.boundedValues = null;

        var dataMargin:Number;
        var stroke:IStroke;
        var radius:Number;
        var renderer:Object;

        if (dimension == CartesianTransform.VERTICAL_AXIS)
        {
            extractMinMax(_renderData.cache,"yNumber",description);
            if ((requiredFields & DataDescription.REQUIRED_BOUNDED_VALUES) != 0)
            {
                dataMargin = 0;
                
                stroke = getStyle("lineStroke");
                if (stroke)
                    dataMargin = stroke.weight/2;
                
                radius = getStyle("radius");
                renderer = getStyle("itemRenderer");
                if (radius > 0 && renderer)
                {
                    stroke = getStyle("stroke");
                    if (stroke)
                        radius += stroke.weight/2;
                        
                    dataMargin = Math.max(radius,dataMargin);
                }

                if (dataMargin > 0)
                {
                    description.boundedValues= [];
                    description.boundedValues.push(new BoundedValue(description.max,0,dataMargin));
                    description.boundedValues.push(new BoundedValue(description.min,dataMargin,0));
                }
            }
        }
        else if (dimension == CartesianTransform.HORIZONTAL_AXIS)
        {
            if (_xField != "")
            {
                if ((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
                {
                    // if we need to know the min interval, then we rely on the cache being in order. So we need to sort it if it
                    // hasn't already been sorted
                    var cache:Array /* of LineSeriesItem */ = _renderData.cache;
                    if (_sortOnXField == false)
                    {
                        cache = _renderData.cache.concat();
                        cache.sortOn("xNumber",Array.NUMERIC);      
                    }
                    extractMinMax(cache,"xNumber",description,(0 != (requiredFields & DataDescription.REQUIRED_MIN_INTERVAL)));
                }
                else
                {
                    extractMinMax(_renderData.cache,"xNumber",description, (requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0);
                }
            }
            else 
            {
                description.min = _renderData.cache[0].xNumber;
                description.max = _renderData.cache[_renderData.cache.length-1].xNumber;
                if ((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
                {
                    extractMinInterval(_renderData.cache,"xNumber",description);
                }
            }

            if ((requiredFields & DataDescription.REQUIRED_BOUNDED_VALUES) != 0)
            {
                dataMargin = 0;
                
                stroke = getStyle("lineStroke");
                if (stroke)
                    dataMargin = stroke.weight/2;
                
                radius = getStyle("radius");
                renderer = getStyle("itemRenderer");
                if (radius > 0 && renderer)
                {
                    stroke = getStyle("stroke");
                    if (stroke)
                        radius += stroke.weight/2;
                        
                    dataMargin = Math.max(radius,dataMargin);
                }

                if (dataMargin > 0)
                {
                    description.boundedValues= [];
                    description.boundedValues.push(new BoundedValue(description.max,0,dataMargin));
                    description.boundedValues.push(new BoundedValue(description.min,dataMargin,0));
                }
            }
        }
        else
        {
            return [];
        }
            
        return [ description ];
    }
    
    /**
     *  @private
     */
    override public function getAllDataPoints():Array /* of HitData */
    {
        if (!_renderData)
            return [];
        if (!(_renderData.filteredCache))
            return [];
        
        var itemArr:Array /* of LineSeriesItem */ = [];
        if (chart && chart.dataTipItemsSet && dataTipItems)
            itemArr = dataTipItems;
        else if (chart && chart.showAllDataTips && _renderData.filteredCache)
            itemArr = _renderData.filteredCache;
        else
            itemArr = [];
        
        var n:uint = itemArr.length;
        var i:uint;
        var result:Array /* of HitData */ = [];
        
        for (i = 0; i < n; i++)
        {
            var v:LineSeriesItem = itemArr[i];
            if (_renderData.filteredCache.indexOf(v) == -1)
            {
                var itemExists:Boolean = false;
                var m:int  = _renderData.filteredCache.length;
                for (var j:int = 0; j < m; j++)
                {
                    if (v.item == _renderData.filteredCache[j].item)
                    {   
                        v = _renderData.filteredCache[j];
                        itemExists = true;
                        break;
                    }
                }
                if (!itemExists)
                    continue;
            }
            if (v)
            {
                var hd:HitData = new HitData(createDataID(v.index),Math.sqrt(0),v.x,v.y,v);

                var istroke:IStroke = getStyle("lineStroke");
                if (istroke is SolidColorStroke)
                    hd.contextColor = SolidColorStroke(istroke).color;
                /*
                else if (istroke is LinearGradientStroke)
                {
                    var gb:LinearGradientStroke = LinearGradientStroke(istroke);
                    if (gb.entries.length > 0)
                        hd.contextColor = gb.entries[0].color;
                }
                */
                hd.dataTipFunction = formatDataTip;
                result.push(hd);
            }
        }
        return result;
    }

    /**
     *  @private
     */
    override public function findDataPoints(x:Number,y:Number,sensitivity:Number):Array /* of HitData */
    {
        // esg, 8/7/06: if your mouse is over a series when it gets added and displayed for the first time, this can get called
        // before updateData, and before and render data is constructed. The right long term fix is to make sure a stubbed out 
        // render data is _always_ present, but that's a little disruptive right now.
        if (interactive == false || !_renderData)
            return [];

        var pr:Number = getStyle("radius");
        var minDist2:Number  = pr + sensitivity;
        minDist2 *= minDist2;
        var minItem:LineSeriesItem = null;     
        var pr2:Number = pr * pr;
        
        var n:int = _renderData.filteredCache.length;

        if (n == 0)
            return [];

        if (sortOnXField == true)
        {            
            var low:Number = 0;
            var high:Number = n;
            var cur:Number = Math.floor((low+high)/2);
    
            var bFirstIsNaN:Boolean = isNaN(_renderData.filteredCache[0]);
    
            while (true)
            {
                var v:LineSeriesItem = _renderData.filteredCache[cur];          
                if (!isNaN(v.yNumber) && !isNaN(v.xNumber))
                {
                    var dist:Number = (v.x  - x)*(v.x  - x) + (v.y - y)*(v.y -y);
                    if (dist <= minDist2)
                    {
                        minDist2 = dist;
                        minItem = v;                
                    }
                }
                var a:Number;
                var b:Number;
                if(dataTransform && dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) is NumericAxis &&
                (dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) as NumericAxis).direction == "inverted")
                {
                    a = x;
                    b = v.x;
                }
                else
                {
                    a = v.x;
                    b = x;
                }
                // if there are NaNs in this array, it's for one of a couple of reasons:
                // 1) there were NaNs in the data, which menas an xField was provided, which means they got sorted to the end
                // 2) some values got filtered out, in which case we can (sort of) safely assumed that the got filtered from one side, the other, or the entire thing.
                // we'll assume that an axis hasn't filtered a middle portion of the array.
                // since we can assume that any NaNs are at the beginning or the end, we'll rely on that in our binary search.  If there was a NaN in the first slot,
                // then we'll assume it's safe to move up the array if we encounter a NaN.  It's possible the entire array is NaN, but then nothing will match, so that's ok.
                if (a < b || (isNaN(v.x) && bFirstIsNaN))
                {
                    low = cur;
                    cur = Math.floor((low + high)/2);
                    if (cur == low)
                        break;
                }
                else
                {
                    high = cur;
                    cur = Math.floor((low + high)/2);
                    if (cur == high)
                        break;
                }
            }
        }
        else
        {
            var i:uint;
            for (i = 0; i < n; i++)
            {
               v = _renderData.filteredCache[i];          
               if (!isNaN(v.yNumber) && !isNaN(v.xNumber))
                {
                   dist = (v.x  - x)*(v.x  - x) + (v.y - y)*(v.y -y);
                   if (dist <= minDist2)
                   {
                       minDist2 = dist;
                       minItem = v;               
                   }
                }
           }
        }
        
        if (minItem)
        {
            var hd:HitData = new HitData(createDataID(minItem.index),Math.sqrt(minDist2),minItem.x,minItem.y,minItem);

            var istroke:IStroke = getStyle("lineStroke");
            if (istroke is SolidColorStroke)
                hd.contextColor = SolidColorStroke(istroke).color;
            /*
            else if (istroke is LinearGradientStroke)
            {
                var gb:LinearGradientStroke = LinearGradientStroke(istroke);
                if (gb.entries.length > 0)
                    hd.contextColor = gb.entries[0].color;
            }
            */
            hd.dataTipFunction = formatDataTip;
            return [ hd ];
        }

        return [];
    }


    /**
     *  @private
     */
    override public function getElementBounds(renderData:Object):void
    {
        var cache :Array /* of LineSeriesItem */ = renderData.cache;
        var segments:Array /* of LineSeriesSegment */ = renderData.segments;
        
        var rb :Array /* of Rectangle */ = [];
        var sampleCount:int = cache.length;     

        if (sampleCount == 0)
            maxBounds  = new Rectangle();
        else
        {
            var radius:Number = renderData.radius;

            if (radius == 0 || isNaN(radius))
                radius = 1;

            var segCount:int = segments.length;
            if (segCount)
            {
                var v:Object = cache[renderData.segments[0].start];
                var maxBounds:Rectangle = new Rectangle(v.x,v.y,0,0);
            }


            for (var i:int = 0; i < segCount; i++)
            {       
                var j:int;    
                var seg:Object = renderData.segments[i];
                if (i > 0){
                    var prevSeg:Object = renderData.segments[i-1];
                    if (seg.start > prevSeg.end + 1){
                        for (j = prevSeg.end + 1; j < seg.start ; j++){
                            var rect:Rectangle = new Rectangle(0, 0, 0, 0);
                            rb[j] = rect; 
                        }
                    }
                }
                for (j = seg.start; j <= seg.end; j++)
                {
                    v = cache[j];
                    var b:Rectangle = new Rectangle(v.x-radius,v.y-radius,2*radius,2*radius);

                    maxBounds.left = Math.min(maxBounds.left,b.left);
                    maxBounds.top = Math.min(maxBounds.top,b.top);
                    maxBounds.right = Math.max(maxBounds.right,b.right);
                    maxBounds.bottom = Math.max(maxBounds.bottom,b.bottom);
                    rb[j] = b;
                }
            }
        }
        

        renderData.elementBounds = rb;
        renderData.bounds =  maxBounds;
    }

    /**
     *  @private
     */
    override public function beginInterpolation(sourceRenderData:Object,
                                                destRenderData:Object):Object
    {
        var idata:Object = initializeInterpolationData(
            sourceRenderData.cache, destRenderData.cache,
            { x: true, y: true }, itemType,
            { sourceRenderData: sourceRenderData,
              destRenderData: destRenderData });

        var interpolationRenderData:LineSeriesRenderData = LineSeriesRenderData(destRenderData.clone());

        interpolationRenderData.cache = idata.cache;    
        interpolationRenderData.filteredCache = idata.cache;    

        /* the segments in the renderdata have pointers back to the filetered cache.  since we just replaced the filtered cache, we need to iterate through and 
        /  update those */
        var segs:Array /* of LineSeriesSegment */ = interpolationRenderData.segments;
        var n:int = segs.length;
        for (var i:int = 0; i < n; i++)
        {
            segs[i].items = idata.cache;
        }
        
        transitionRenderData = interpolationRenderData;
        return idata;
    }

    /**
     *  @private
     */
    override protected function getMissingInterpolationValues(
                                    sourceProps:Object, srcCache:Array /* of LineSeriesItem */,
                                    destProps:Object, destCache:Array /* of LineSeriesItem */,
                                    index:Number, customData:Object):void
    {
        var cache:Array /* of LineSeriesItem */ = customData.sourceRenderData.cache;
        var dstCache:Array /* of LineSeriesItem */ = customData.destRenderData.cache;
        
        for (var p:String in sourceProps)
        {
            var src:Number = sourceProps[p];
            var dst:Number = destProps[p];


            var lastValidIndex:int = index;
            if (isNaN(src))
            {
                if (cache.length == 0)
                {
                    src = (p == "x")? dstCache[index].x : unscaledHeight;
                }
                else
                {
                    if (lastValidIndex >= cache.length)
                        lastValidIndex = cache.length-1;
                    while (lastValidIndex >= 0 && isNaN(cache[lastValidIndex][p]))
                    {
                        lastValidIndex--;
                    }
                    if (lastValidIndex >= 0)
                        src =   cache[lastValidIndex][p] + .01 * (lastValidIndex - index);
                    if (isNaN(src))
                    {
                        lastValidIndex = index+1;
                        var cachelen:int = cache.length;
                        while (lastValidIndex < cachelen && isNaN(cache[lastValidIndex][p]))
                        {
                            lastValidIndex++;
                        }
                        if (lastValidIndex < cachelen)
                        {
                            src = cache[lastValidIndex][p] + .01 * (lastValidIndex - index);
                        }
                    }           
                }
            }
            
            sourceProps[p] = src;
            destProps[p] = dst;
        }
    }

    /**
     *  @private
     */
    override public function dataToLocal(... dataValues):Point
    {
        var data:Object = {};
        var da:Array /* of Object */ = [ data ];
        var n:int = dataValues.length;
        
        if (n > 0)
        {
            data["d0"] = dataValues[0];
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).
                mapCache(da, "d0", "v0");
        }
        
        if (n > 1)
        {
            data["d1"] = dataValues[1];
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).
                mapCache(da, "d1", "v1");           
        }

        dataTransform.transformCache(da,"v0","s0","v1","s1");
        
        return new Point(data.s0 + this.x,
                         data.s1 + this.y);
    }

    /**
     *  @private
     */
    override public function localToData(v:Point):Array /* of Object */
    {
        var values:Array /* of Object */ = dataTransform.invertTransform(
                                            v.x - this.x,
                                            v.y - this.y);
        return values;
    }

    /**
     *  @private
     */
    override public function getItemsInRegion(r:Rectangle):Array /* of LineSeriesItem */
    {
        if (interactive == false || !_renderData)
            return [];
        
        var arrItems:Array /* of LineSeriesItem */ = [];    
        var rc:Rectangle = new Rectangle();
        var localRectangle:Rectangle = new Rectangle();
        var n:uint = _renderData.filteredCache.length;
        
        localRectangle.topLeft = globalToLocal(r.topLeft);
        localRectangle.bottomRight = globalToLocal(r.bottomRight);

        
        for (var i:int = 0; i < n; i++)
        {
            var v:LineSeriesItem = _renderData.filteredCache[i];
                
            if (localRectangle.contains(v.x,v.y))
                arrItems.push(v);
        }
        return arrItems;
    }
    
     /**
     * @private
     */ 
    override protected function defaultFilterFunction(cache:Array /*of LineSeriesItem */ ):Array /*of LineeriesItem*/
    {
        var filteredCache:Array /*of LineSeriesItem*/ = [];
        var start:int;
        var end:int = -1;
        var n:int;
        var i:int;
        var v:LineSeriesItem;
        
        if (filterDataValues == "outsideRange")
        {
            filteredCache = cache.concat();
            
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).filterCache(filteredCache,"xNumber","xFilter")
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(filteredCache,"yNumber","yFilter");

            // since all nulls will end up out at the edges, we can safely strip this early

           if (xField != "" && sortOnXField)
                stripNaNs(filteredCache,"xFilter");
                
            _renderData.validPoints = filteredCache.length;

            if (_interpolateValues == false)
            {
                n = filteredCache.length;
                
                while (end<n)
                {
                    for (i = end + 1; i < n; i++)
                    {
                        v = LineSeriesItem(filteredCache[i]);
                        if (!isNaN(v.xFilter) && !isNaN(v.yFilter))
                            break;
                        _renderData.validPoints--;
                    }
                    if (i == n)
                        break;              

                    start = i;

                    for (i = start + 1; i < n; i++)
                    {
                        v = LineSeriesItem(filteredCache[i]);
                        if (isNaN(v.xFilter) || isNaN(v.yFilter))
                            break;                  
                    }
                    end = i-1;
                    if (end != start)
                    {
                        _renderData.segments.push(new lineSegmentType(this,_renderData.segments.length,filteredCache,start,end));
                    }
                }
            }
            else
            {
                stripNaNs(filteredCache,"yFilter");
                _renderData.validPoints = filteredCache.length;
                if (filteredCache.length > 1)
                    _renderData.segments.push(new lineSegmentType(this,0,filteredCache,start,filteredCache.length-1));
            }
        }
        else if (filterDataValues == "nulls")
        {
            filteredCache = cache.concat();
             // since all nulls will end up out at the edges, we can safely strip this early
            if (xField != "" && sortOnXField)
                stripNaNs(filteredCache,"xNumber");
                
            _renderData.validPoints = filteredCache.length;

            if (_interpolateValues == false)
            {
                n = filteredCache.length;
                while (end<n)
                {
                    for (i = end + 1; i < n; i++)
                    {
                        v = LineSeriesItem(filteredCache[i]);
                        if (!isNaN(v.xNumber) && !isNaN(v.yNumber))
                            break;
                        _renderData.validPoints--;
                    }
                    if (i == n)
                        break;              

                    start = i;

                    for (i = start + 1; i < n; i++)
                    {
                        v = LineSeriesItem(filteredCache[i]);
                        if (isNaN(v.xNumber) || isNaN(v.yNumber))
                            break;                  
                    }
                    end = i-1;
                    if (end != start)
                    {
                        _renderData.segments.push(new lineSegmentType(this,_renderData.segments.length,filteredCache,start,end));
                    }
                }
            }
            
            else
            {
                stripNaNs(filteredCache,"yNumber");
                _renderData.validPoints = filteredCache.length;
                if (filteredCache.length > 1)
                    _renderData.segments.push(new lineSegmentType(this,0,filteredCache,start,filteredCache.length-1));
            }
        }
        else if (filterDataValues == "none")
        {
            filteredCache = cache;
            _renderData.segments.push(new lineSegmentType(this,0,filteredCache,start,filteredCache.length-1));
        }
        return filteredCache;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  This method is to create line segments for the cache returned
     *  by custom filter function
     */
    private function createLineSegments(filteredCache:Array /* of LineSeriesItem */):void
    {
            _renderData.validPoints = filteredCache.length;

            if (_interpolateValues == false)
            {
                var start:int;
                var end:int = -1;
                var n:int = filteredCache.length;
                var i:int;
                var v:LineSeriesItem;
                
                while (end<n)
                {
                    for (i = end + 1; i < n; i++)
                    {
                        v = LineSeriesItem(filteredCache[i]);
                        if (!isNaN(v.xNumber) && !isNaN(v.yNumber))
                            break;
                        _renderData.validPoints--;
                    }
                    if (i == n)
                        break;              

                    start = i;

                    for (i = start + 1; i < n; i++)
                    {
                        v = LineSeriesItem(filteredCache[i]);
                        if (isNaN(v.xNumber) || isNaN(v.yNumber))
                            break;                  
                    }
                    end = i-1;
                    if (end != start)
                    {
                        _renderData.segments.push(new lineSegmentType(this,_renderData.segments.length,filteredCache,start,end));
                    }
                }
            }
            
            else
            {
                _renderData.validPoints = filteredCache.length;
                if (filteredCache.length > 1)
                    _renderData.segments.push(new lineSegmentType(this,0,filteredCache,start,filteredCache.length-1));
            }
    }  

    /**
     *  Customizes the item renderer instances that are used to represent the chart. This method is called automatically
     *  whenever a new item renderer is needed while the chart is being rendered. You can override this method to add your own customization as necessary.
     *  @param instance The new item renderer instance that is being created.
     *  @param cache The InstanceCache that is used to manage the item renderer instances.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function applyItemRendererProperties(instance:UIComponent,
                                                   cache:InstanceCache):void
    {
        if (instance is ISimpleStyleClient)
            ISimpleStyleClient(instance).styleName = this;
    }

    /**
     *  @private
     */
    private function formatDataTip(hd:HitData):String
    {
        var dt:String = "";
        
        var n:String = displayName;
        if (n && n != "")
            dt += "<b>" + n + "</b><BR/>";

        var xName:String = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).displayName;
        if (xName != "")
            dt += "<i>" + xName+ ":</i> ";
        dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(
            LineSeriesItem(hd.chartItem).xValue) + "\n";
        
        var yName:String = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).displayName;
        if (yName != "")
            dt += "<i>" + yName + ":</i> ";
        dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(
            LineSeriesItem(hd.chartItem).yValue) + "\n";
        
        return dt;
    }
    
    /**
     * @private
     */
    private function defaultFillFunction(element:LineSeriesItem,i:Number):IFill
    {
        if (_fillCount!=0)
        {
          return(GraphicsUtilities.fillFromStyle(_localFills[i % _fillCount]));
        }
        else
          return(GraphicsUtilities.fillFromStyle(getStyle("fill")));
    }
    
    
    private function reverseYValues(cache:Array):Array
    {
        var i:int = 0;
        var n:int = cache.length;
        for(i = 0; i < n ; i++)
        {
            cache[i]["yValue"] = -(cache[i]["yValue"]);
        }  
        return cache;
    }
    
    private function reverseXValues(cache:Array):Array
    {
        var i:int = 0;
        var n:int = cache.length;
        for(i = 0; i < n ; i++)
        {
            cache[i]["xValue"] = -(cache[i]["xValue"]);
        }  
        return cache;
    }
}

}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: LineSeriesLegendMarker
//
////////////////////////////////////////////////////////////////////////////////


import mx.display.Graphics;

import mx.charts.series.LineSeries;
import mx.graphics.IStroke;
import mx.graphics.LinearGradientStroke;
import mx.graphics.SolidColorStroke;
import mx.skins.ProgrammaticSkin;

/**
 *  @private
 */
class LineSeriesLegendMarker extends ProgrammaticSkin
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Constructor.
     */
    public function LineSeriesLegendMarker(element:LineSeries)
    {
        super();

        _element = element;
        styleName = _element;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private var _element:LineSeries;
    

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth,unscaledHeight);

        var fillStroke:IStroke = getStyle("lineStroke");
        var color:Number;

        if (fillStroke is SolidColorStroke)
        {
            color = SolidColorStroke(fillStroke).color;
        }
        /*
        else if (fillStroke is LinearGradientStroke)
        {
            var gb:LinearGradientStroke = LinearGradientStroke(fillStroke);
            if (gb.entries.length > 0)
                color = gb.entries[0].color;
        }
        */

        var g:Graphics = graphics;
        g.clear();
        g.moveTo(0, 0);
        g.lineStyle(0, 0, 0);
        g.beginFill(color);
        g.lineTo(width, 0);
        g.lineTo(width, height);
        g.lineTo(0, height);
        g.lineTo(0, 0);
        g.endFill();
    }
}
