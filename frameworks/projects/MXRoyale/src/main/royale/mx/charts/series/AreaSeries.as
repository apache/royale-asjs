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
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.skins.ProgrammaticSkin;

import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;

import mx.skins.ProgrammaticSkin;
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
 *  The class that the series uses to represent the filled area on the chart. This class is instantiated once per series.
 *  Classes used as areaRenderers should implement the IFlexDisplayObject, ISimpleStyleClient, and IDataRenderer 
 *  interfaces. The data property is assigned the 
 *  AreaSeriesRenderData that describes the area data.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="areaRenderer", type="mx.core.IFactory", inherit="no")]


/**
 *  Specifies an Array of fill objects that define the fill for
 *  each item in the series. This takes precedence over the <code>fill</code> style property.
 *  If a custom method is specified by the <code>fillFunction</code> property, that takes precedence over this Array.
 *  If you do not provide enough Array elements for every item,
 *  Flex repeats the fill from the beginning of the Array.
 *  
 *  <p>To set the value of this property using CSS:
 *   <pre>
 *    AreaSeries {
 *      fills:#CC66FF, #9966CC, #9999CC;
 *    }
 *   </pre>
 *  </p>
 *  
 *  <p>To set the value of this property using MXML:
 *   <pre>
 *    &lt;mx:AreaSeries ... &gt;
 *     &lt;mx:fills&gt;
 *      &lt;mx:SolidColor color="0xCC66FF"/&gt;
 *      &lt;mx:SolidColor color="0x9966CC"/&gt;
 *      &lt;mx:SolidColor color="0x9999CC"/&gt;
 *     &lt;/mx:fills&gt;
 *    &lt;/mx:AreaSeries&gt;
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
 *  Specifies the boundary type for the area.
 *  Possible values are:
 *  
 *  <ul>
 *   <li><code>"curve"</code> - Draws curves for the boundary between data points.</li>
 *  
 *   <li><code>"horizontal"</code> - Draws only the boundary from the x-coordinate of 
 *    the first point to the x-coordinate of the second point at the y-coordinate of 
 *    the second point. Repeats this for each data point.</li>
 *  
 *   <li><code>"reverseStep"</code> - Draws boundaries of the area as horizontal segments. 
 *    At the first data point, draws a vertical boundary line and then a horizontal boundary 
 *    line to the second point, and repeats for each data point.</li>
 *  
 *   <li><code>"segment"</code> - Draws boundaries of the area as connected segments that 
 *    are angled to connect at each data point in the series.</li>
 *  
 *   <li><code>"step"</code> - Draws boundaries of the area as horizontal segments. At the 
 *    first data point, draws a horizontal boundary line and then a vertical boundary 
 *    line to the second point, and repeats for each data point.</li>
 *  
 *   <li><code>"vertical"</code> - Draws only the boundary from the y-coordinate of the first 
 *    point to the y-coordinate of the second point at the x-coordinate of the second point. 
 *    Repeats this for each data point.</li>
 *  </ul>
 *  
 *  @default segment
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="form", type="String", enumeration="segment,step,reverseStep,vertical,horizontal,curve", inherit="no")]

/** 
 *  Specifies the radius, in pixels, of the chart elements for the data points. This property only applies
 *  if you specify an <code>itemRenderer</code> property.  
 *  You can specify the itemRenderer in MXML or using styles.  
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
public class AreaSeries extends Series implements IStackable2
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
    public function AreaSeries()
    {
        super();

        _instanceCache = new InstanceCache(null, this, 1);
        _instanceCache.creationCallback = applyItemRendererProperties;
        
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
	//private static var _moduleFactoryInitialized:Dictionary = new Dictionary(true);
	
    /**
     *  @private
     */
    private var _areaRenderer:IFlexDisplayObject;
    
    /**
     *  @private
     */
    private var _instanceCache:InstanceCache;
    
    /**
     *  @private
     */
    private var _renderData:AreaSeriesRenderData;
    
    /**
     *  @private
     */
    private var _stacked:Boolean = false;
    
    /**
     *  @private
     */
    private var _localFills:Array /* of IFill */;
    
    /**
     *  @private
     */
    private var _fillCount:int;
    
    /**
     *  @private
     */
    private var _transition:Boolean = false;

    //--------------------------------------------------------------------------
    //
    //  Overridden properties: Series
    //
    //--------------------------------------------------------------------------

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
    override public function get items():Array /* of AreaSeriesItem */
    {
        return _renderData ? _renderData.filteredCache : null;
    }

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
        var marker:IFlexDisplayObject = null;       
        
        var ld:LegendData = new LegendData();
        ld.element = this;
    
        var markerClass:IFactory = getStyle("legendMarkerRenderer");
        
        if (markerClass)
        {
            marker = markerClass.newInstance();
            if (marker as ISimpleStyleClient)
                (marker as ISimpleStyleClient).styleName = this;
        }
            
        
        ld.marker = marker;
        ld.label = displayName; 

        return [ ld ];
        
    }

    //----------------------------------
    //  renderData
    //----------------------------------

    /**
     *  @private
     */
    override protected function get renderData():Object
    {
        if (!_renderData)
        {
            var renderDataType:Class = this.renderDataType
            var td:AreaSeriesRenderData = new renderDataType(this);
            td.cache = td.filteredCache = [];
            td.radius = 0;
            return td;
        }
                    
        _renderData.radius = getStyle("radius");
            
        return _renderData;
    }
    
        private var _bAxesDirty:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //-----------------------------------
    // areaFill
    //-----------------------------------
        
    /** 
     *  Sets the fill for the area. You can specify either an object implementing the 
     *  IFill interface, or a number representing a solid color value. You can also specify a solid fill using CSS.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get areaFill():mx.graphics.IFill
    {
        return getStyle("areaFill");
    }
    public function set areaFill(value:mx.graphics.IFill):void
    {
        setStyle("areaFill", value);
        if (parent && areaStroke)
            updateDisplayList(width, height);
        legendDataChanged();
    }
        
    //-----------------------------------
    // areaStroke
    //-----------------------------------
    
    /** 
     *  Sets the line style for the area.
     *  You use a Stroke object to define the stroke.
     *  You can specify the itemRenderer in MXML or using styles.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Style(name="areaStroke", type="mx.graphics.IStroke", inherit="no")]
    public function get areaStroke():mx.graphics.IStroke
    {
        return getStyle("areaStroke");
    }
    public function set areaStroke(value:mx.graphics.IStroke):void
    {
        setStyle("areaStroke", value);
        if (parent && areaFill)
            updateDisplayList(width, height);
        legendDataChanged();
    }
    
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
     * from the chart's data provider's index because it is sorted based on the x, y, and z values.
     * This function returns an object that implements the <code>IFill</code> interface.
     * </p>
     *  
     * <p>An example usage of a customized <code>fillFunction</code> is to return a fill
     * based on some threshold.</p>
     *   
     * @example
     * <pre>
     * public function myFillFunction(item:ChartItem, index:Number):IFill 
     * {
     *      var curItem:AreaSeriesItem = AreaSeriesItem(item);
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
        if (value==_fillFunction)
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
    //  itemType
    //----------------------------------
    
    /**
     *  The subtype of ChartItem used by this series to represent individual items.
     *  Subclasses can override and return a more specialized class if they need to store additional information in the items
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get itemType():Class
    {
        return AreaSeriesItem;
    }
    
    //----------------------------------
    //  minField
    //----------------------------------

    /**
     *  @private
     *  Storage for the minField property.
     */
    private var _minField:String = "";

    /**
     *  @private
     */
    private var _userMinField:String = "";

    [Inspectable(category="General")]
    
    /**
     *  Specifies the field of the dataProvider that determines the bottom boundary of the area. 
     *  If <code>null</code>, the area is based at the range minimum (or maximum, if the field value is negative). 
     *  
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minField():String
    {
        return _minField;
    }

    /**
     *  @private
     */
    public function set minField(value:String):void
    {
        _userMinField = value;
        _minField = value;

        dataChanged();
    }

    //----------------------------------
    //  renderDataType
    //----------------------------------

    /**
     *  The subtype of ChartRenderData used by this series to store all data necessary to render.
     *  Subclasses can override and return a more specialized class if they need to store additional information for rendering.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get renderDataType():Class
    {
        return AreaSeriesRenderData;
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
    //  stacker
    //----------------------------------

    /**
     *  @private
     *  Storage for the stacker property.
     */
    private var _stacker:StackedSeries;
    
    /**
     *  The StackedSeries associated with this AreaSeries.
     *  The stacker manages the series's stacking behavior.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get stacker():StackedSeries
    {
        return _stacker;
    }

    /**
     *  @private
     */
    public function set stacker(value:StackedSeries):void
    {
        _stacker = value;
    }

    //----------------------------------
    //  upperBoundCache
    //----------------------------------

    /**
     *  @private
     */
    mx_internal function get upperBoundCache():Array /* of AreaSeriesItem */
    {
        return _renderData.cache;
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
     *  Specifies the field of the data provider that determines the position of the data 
     *  points on the horizontal axis. If <code>null</code>, the 
     *  data points are rendered in the order they appear in the data provider.
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

        dataChanged();
    }
    
    //-----------------------------------------------------------------------
    //
    // Overridden Methods
    //
    //-----------------------------------------------------------------------
    
    /**
     *  @private
     */
    override public function getItemsInRegion(r:Rectangle):Array /* of AreaSeriesItem */
    {
        if (interactive == false || !_renderData)
            return [];
        
        var arrItems:Array /* of AreaSeriesItem */ = [];    
        var localRectangle:Rectangle = new Rectangle();
        var n:uint = _renderData.filteredCache.length;
        
        localRectangle.topLeft = globalToLocal(r.topLeft);
        localRectangle.bottomRight = globalToLocal(r.bottomRight);
        
        for (var i:int = 0; i < n; i++)
        {
            var v:AreaSeriesItem = _renderData.filteredCache[i];
            
            if (localRectangle.contains(v.x,v.y))
                arrItems.push(v);
        }
        return arrItems;
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

		var areaSeriesStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.series.AreaSeries");


		if (areaSeriesStyle)
		{
			areaSeriesStyle.setStyle("areaRenderer", new ClassFactory(mx.charts.renderers.AreaRenderer));
			areaSeriesStyle.setStyle("legendMarkerRenderer", new ClassFactory(AreaSeriesLegendMarker));
			areaSeriesStyle.setStyle("areaFill", new SolidColor(0x000000));
			areaSeriesStyle.setStyle("fills", []);
			areaSeriesStyle.setStyle("stroke", HaloDefaults.pointStroke);
		}
        else
        {
            //Fallback to set the style to this chart directly.
			setStyle("areaRenderer", new ClassFactory(mx.charts.renderers.AreaRenderer));
			setStyle("legendMarkerRenderer", new ClassFactory(AreaSeriesLegendMarker));
			setStyle("areaFill", new SolidColor(0x000000));
			setStyle("fills", []);
			setStyle("stroke", HaloDefaults.pointStroke);
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

        var i:int;
        var v:AreaSeriesItem;
        var elementBounds:Array /* of Rectangle */;
        
        if (!_areaRenderer)
        {
            var asClass:IFactory = getStyle("areaRenderer");
            _areaRenderer = asClass.newInstance();
            if (_areaRenderer is ISimpleStyleClient)
                (_areaRenderer as ISimpleStyleClient).styleName = this;
            addChildAt(_areaRenderer as UIComponent, 0);
        }

        var renderData:AreaSeriesRenderData =
            transitionRenderData ?
            AreaSeriesRenderData(transitionRenderData) :
            _renderData; 

        var activeRenderCache:Array /* of AreaSeriesItem */ = renderData.filteredCache;

        var pointRadius:Number;
        
        if (renderData == transitionRenderData &&
            transitionRenderData.elementBounds)
        {
            elementBounds = renderData.elementBounds;
            sampleCount = elementBounds.length;
            pointRadius = renderData.radius;
            
            for (i = 0; i < sampleCount; i++)
            {
                rcBounds = elementBounds[i];
                v = activeRenderCache[i];
                v.x = (rcBounds.left + rcBounds.right) / 2;
                v.y = rcBounds.top + pointRadius;
                v.min = rcBounds.bottom;
            }
            _transition = true;
        }
        else if (_transition && minField == "" && renderData.elementBounds)
        {
            elementBounds = renderData.elementBounds;
            sampleCount = elementBounds.length;
            for (i = 0; i < sampleCount; i++)
            {
                v = activeRenderCache[i];
                v.min = NaN;
            }
            _transition = false;
        }

        if (_areaRenderer is ProgrammaticSkin)
           (_areaRenderer as ProgrammaticSkin).invalidateDisplayList(); // some visual changes don't change the size
        _areaRenderer.setActualSize(unscaledWidth, unscaledHeight);
        
        (_areaRenderer as IDataRenderer).data = renderData;     
        
        var sampleCount:int = activeRenderCache.length;     

        var renderCache:Array /* of AreaSeriesItem */; 
        var rcBounds:Rectangle;
        
        pointRadius = getStyle("radius");
        if (isNaN(pointRadius))
            pointRadius = 0;
            
        if (pointRadius > 0)
        {
            _instanceCache.factory = getStyle("itemRenderer");
            _instanceCache.count = sampleCount;         
            var instances:Array /* of IFlexDisplayObject */ = _instanceCache.instances;

            var bSetData:Boolean = sampleCount > 0 &&
                                   instances[0] is IDataRenderer;

            var rc:Rectangle;
            var inst:IFlexDisplayObject;
            
            if (renderData == transitionRenderData &&
                renderData.elementBounds)
            {
                elementBounds = renderData.elementBounds;
                for (i = 0; i < sampleCount; i++)
                {
                    inst = instances[i];
                    v = activeRenderCache[i];
                    v.fill = fillFunction(v,i);
                    if (!(v.fill))
                        v.fill = defaultFillFunction(v,i);
                    v.itemRenderer = inst;
                    if (v.itemRenderer && (v.itemRenderer as Object).hasOwnProperty('invalidateDisplayList'))
                        (v.itemRenderer as Object).invalidateDisplayList();
                    if (inst)
                    {
                        if (bSetData)
                            (inst as IDataRenderer).data = v;
                        rc = elementBounds[i];
                        inst.move(rc.left, rc.top);
                        inst.setActualSize(rc.width, rc.height);
                    }
                }
            }
            else
            {
                for (i = 0; i < sampleCount; i++)
                {
                    v = activeRenderCache[i];

                    inst = instances[i];
                    v.fill = fillFunction(v,i);
                    if (!(v.fill))
                        v.fill = defaultFillFunction(v,i);
                    v.itemRenderer = inst;
                    if (v.itemRenderer && (v.itemRenderer as Object).hasOwnProperty('invalidateDisplayList'))
                        (v.itemRenderer as Object).invalidateDisplayList();
                    if (inst)
                    {
                        if (bSetData)
                            (inst as IDataRenderer).data = v;
                        rc = new Rectangle(v.x - pointRadius,
                                           v.y - pointRadius,
                                           2 * pointRadius, 2 * pointRadius);
                        inst.move(rc.left, rc.top);
                        inst.setActualSize(rc.width, rc.height);
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

        var styles:String = "stroke fill";
        if (styleProp == null || styleProp == "" ||
            styles.indexOf(styleProp) != -1)
        {
            legendDataChanged();
        }
        styles = "fills"
        if (styles.indexOf(styleProp)!=-1)
        {
            _localFills = getStyle('fills');
            if (_localFills != null)
        		_fillCount = _localFills.length;
        	else
        		_fillCount = 0;                
            legendDataChanged();
        }
        if (styleProp == "itemRenderer")
        {
        	_instanceCache.remove = true;
            _instanceCache.discard = true;
            _instanceCache.count = 0;
            _instanceCache.discard = false;
            _instanceCache.remove = false;
        }
        invalidateDisplayList();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: ChartElement
    //
    //--------------------------------------------------------------------------

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

        if (dimension == CartesianTransform.VERTICAL_AXIS)
        {
            extractMinMax(_renderData.cache, "yNumber", description);
            if (_minField != "")
                extractMinMax(_renderData.cache, "minNumber", description);

            if ((requiredFields & DataDescription.REQUIRED_BOUNDED_VALUES) != 0)
            {
                // for performance reasons, we're assuming people are ok with clipping on the origin. 
                var dataMargin:Number = 0;
                var stroke:IStroke = getStyle("lineStroke");
                if (stroke)
                    dataMargin = stroke.weight/2;
                var radius:Number = getStyle("radius");
                var renderer:Object = getStyle("itemRenderer");
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
                    var cache:Array /* of AreaSeriesItem */ = _renderData.cache;
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
                description.max =
                    _renderData.cache[_renderData.cache.length - 1].xNumber;
                if ((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
                {
                    extractMinInterval(_renderData.cache,"xNumber",description);
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
        
        var itemArr:Array /* of AreaSeriesItem */ = [];
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
            var v:AreaSeriesItem = itemArr[i];
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
                var hd:HitData = new HitData(createDataID(v.index),
                                             Math.sqrt(0),
                                             v.x, v.y, v);
                hd.contextColor = GraphicsUtilities.colorFromFill(getStyle("areaFill"));
                                                     
                hd.dataTipFunction = formatDataTip;
                result.push(hd);
            }
        }
        return result;
    }

    /**
     *  @private
     */
    override public function findDataPoints(x:Number, y:Number,
                                            sensitivity:Number):Array /* of HitData */
    {
        // esg, 8/7/06: if your mouse is over a series when it gets added and displayed for the first time, this can get called
        // before updateData, and before and render data is constructed. The right long term fix is to make sure a stubbed out 
        // render data is _always_ present, but that's a little disruptive right now.
        if (interactive == false || !_renderData)
            return [];

        var pr:Number = getStyle("radius");
        var minDist2:Number = pr + sensitivity;
        minDist2 *= minDist2;
        var minItem:AreaSeriesItem;     
        var minIndex:int;
        var pr2:Number = pr * pr;
        
        var n:int = _renderData.filteredCache.length;

        if (n == 0)
            return [];
        if (sortOnXField == true)
        {   
            var low:Number = 0;
            var high:Number = n;
            var cur:Number = Math.floor((low + high) / 2);
        
            while (true)
            {
                var v:AreaSeriesItem = _renderData.filteredCache[cur];          
            
                if (!isNaN(v.yNumber))
                {
                    var dist:Number = (v.x - x) * (v.x - x) +
                                      (v.y - y) * (v.y - y);
                    if (dist <= minDist2)
                    {
                        minDist2 = dist;
                        minItem = v;                
                        minIndex = cur;
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
                if (a < b)
                {
                    low = cur;
                    cur = Math.floor((low + high) / 2);
                    if (cur == low)
                        break;
                }
                else
                {
                    high = cur;
                    cur = Math.floor((low + high) / 2);
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
            var hd:HitData = new HitData(createDataID(minItem.index),
                                         Math.sqrt(minDist2),
                                         minItem.x, minItem.y, minItem);
            hd.contextColor = GraphicsUtilities.colorFromFill(getStyle("areaFill"));
                                                     
            hd.dataTipFunction = formatDataTip;
            return [ hd ];
        }

        return [];
    }
    
    /**
     *  @private
     */
    override public function dataToLocal(... dataValues):Point
    {
        var data:Object = {};
        var da:Array /* of Object */= [ data ];
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

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Series
    //
    //--------------------------------------------------------------------------

	/**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function invalidateData(invalid:Boolean=true):void
    {
        if (_stacker)
            _stacker.invalidateStacking();
        super.invalidateData(invalid);      
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function invalidateMapping(invalid:Boolean=true):void
    {
        if (_stacker)
            _stacker.invalidateStacking();
        super.invalidateMapping(invalid);       
    }

    /**
     *  @private
     */
    override protected function updateData():void
    {
        if (_stacker)
        {
            _stacker.stack();
            super.updateData();
            return;
        }   
        _stacked = false;

        var renderDataType:Class = this.renderDataType;
        _renderData = new renderDataType(this);

        _renderData.cache = [];
        
        if (cursor)
        {                       
            cursor.seek(CursorBookmark.FIRST);
            var i:int = 0;
            var itemType:Class = this.itemType;
            while (!cursor.afterLast)
            {
                _renderData.cache[i] =
                    new itemType(this, cursor.current, i);
                i++;
                cursor.moveNext();
            }

            cacheDefaultValues(_yField, _renderData.cache, "yValue");

            cacheIndexValues(_xField, _renderData.cache, "xValue");
            
            if (_minField != "")
                cacheNamedValues(_minField, _renderData.cache, "minValue");             
        }
        if(dataTransform && dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) is NumericAxis &&
			!(dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) is DateTimeAxis) && 
        	(dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) as NumericAxis).direction == "inverted")  
        	_renderData.cache = reverseYValues(_renderData.cache);
        if(dataTransform && dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) is NumericAxis &&
        	!(dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) is DateTimeAxis) &&
        	(dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) as NumericAxis).direction == "inverted")  
        	_renderData.cache = reverseXValues(_renderData.cache);
        super.updateData();
    }

    /**
     *  @private
     */
    override protected function updateMapping():void
    {
        dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(
            _renderData.cache, "xValue", "xNumber", (_xField == ""));
        
        dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(
            _renderData.cache, "yValue", "yNumber");
        
        if (_minField != "" || _stacked)        
        {
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(
                _renderData.cache, "minValue", "minNumber");
        }

        if (_xField != "" && _sortOnXField)
            _renderData.cache.sortOn("xNumber",Array.NUMERIC);      

        super.updateMapping();
    }

    /**
     *  @private
     */
    override protected function updateFilter():void
    {
        _renderData.filteredCache = filterFunction(_renderData.cache);

        super.updateFilter();
    }
    
    /**
     *  @private
     */
    override protected function updateTransform():void
    {
        if (dataProvider == null || _renderData.filteredCache.length == 0)
            return;

        dataTransform.transformCache(
            _renderData.filteredCache, "xNumber", "x", "yNumber", "y");

        var baseVal:Number = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).baseline;
        var stub:Array /* of Object */ = [ { yNumber: baseVal } ];
        dataTransform.transformCache(stub, null, null, "yNumber", "y");
        _renderData.renderedBase = stub[0].y;

        if (_minField != "" || _stacked)        
        {
            dataTransform.transformCache(
                _renderData.filteredCache,null,null,"minNumber","min");
        }

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
    override public function getElementBounds(renderData:Object):void
    {
        var cache:Array /* of AreaSeriesItem */ = renderData.filteredCache;

        var rb:Array /* of Rectangle */ = [];
        
        var sampleCount:int = cache.length;     
        
        if (sampleCount)
        {
            var pointRadius:Number = getStyle("radius");
            if (isNaN(pointRadius))
                pointRadius = 0;
            
            var v:AreaSeriesItem = cache[0];
            var maxBounds:Rectangle = new Rectangle(v.x, v.y, 0, 0);
            var i:int;
            var b:Rectangle;
            
            if (minField == "")
            {
                var base:Number = renderData.renderedBase;
                maxBounds.bottom = base;
                
                for (i = 0; i < sampleCount; i++)
                {
                    v = cache[i];

                    b = new Rectangle(v.x - pointRadius,
                                      v.y - pointRadius,
                                      2 * pointRadius,
                                      base - (v.y - pointRadius));

                    maxBounds.left = Math.min(maxBounds.left, b.left);
                    maxBounds.top = Math.min(maxBounds.top, b.top);
                    maxBounds.right = Math.max(maxBounds.right, b.right);

                    rb[i] = b;
                }
            }
            else
            {
                for (i = 0; i < sampleCount; i++)
                {
                    v = cache[i];
                    
                    var top:Number = v.y-pointRadius;
                    var bottom:Number = v.min;
                    var min:Number = Math.min(top,bottom);
                    
                    b = new Rectangle(v.x - pointRadius, min,
                                      2 * pointRadius,
                                      Math.max(top, bottom) - min);
                    maxBounds.left = Math.min(maxBounds.left, b.left);
                    maxBounds.top = Math.min(maxBounds.top, b.top);
                    maxBounds.right = Math.max(maxBounds.right, b.right);
                    maxBounds.bottom = Math.max(maxBounds.bottom, b.bottom);
                    
                    rb[i] = b;
                }
            }
        }
        else
        {
            maxBounds = new Rectangle();
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
        var interpolatedFields:Object = { x: true, y: true };
        if (minField != "") 
            interpolatedFields["min"] = true;
            
        var idata:Object = initializeInterpolationData(
            sourceRenderData.cache, destRenderData.filteredCache,
            interpolatedFields, itemType,
            { sourceRenderData: sourceRenderData,
              destRenderData: destRenderData });
        
        var interpolationRenderData:AreaSeriesRenderData =
            AreaSeriesRenderData(destRenderData.clone());

        interpolationRenderData.filteredCache =
            interpolationRenderData.cache = idata.cache;
            
        transitionRenderData = interpolationRenderData;
        
        return idata;
    }

    /**
     *  @private
     */
    override protected function getMissingInterpolationValues(
                                    sourceProps:Object, srcCache:Array /* of AreaSeriesItem */,
                                    destProps:Object, destCache:Array /* of AreaSeriesItem */,
                                    index:Number, customData:Object):void
    {
        for (var p:String in sourceProps)
        {
            var src:Number = sourceProps[p];
            var dst:Number = destProps[p];

            if (isNaN(src))
            {
                if (srcCache.length == 0)
                {
                    sourceProps[p] = p == "x" ?
                                            dst :
                                            unscaledHeight;
                }
                else
                {
                    sourceProps[p] =
                        findClosestValidValue(index,p,srcCache);
                }
            }

            if (isNaN(dst))
            {
                if (srcCache.length == 0)
                {
                    destProps[p] = p == "x" ?
                                          src :
                                          unscaledHeight;
                }
                else
                {
                    destProps[p] =
                        findClosestValidValue(index,p,destCache);
                }
            }
        }
    }
    
    /**
     * @private
     */ 
    override protected function defaultFilterFunction(cache:Array /*of AreaSeriesItem */ ):Array /*of AreaSeriesItem*/
    {
    	var filteredCache:Array /*of AreaSeriesItem*/ = [];
    	if (filterDataValues == "outsideRange")
        {
            filteredCache = cache.concat();

            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).filterCache(
                filteredCache, "xNumber", "xFilter");
            stripNaNs(filteredCache, "xFilter");
            
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(
                filteredCache, "yNumber", "yFilter");
            stripNaNs(filteredCache, "yFilter");
            
            if (_minField != "" || _stacked)        
            {
                dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(
                    filteredCache, "minNumber", "minFilter");
                stripNaNs(filteredCache, "minFilter");
            }
        }
        else if (filterDataValues == "nulls")
        {
        	filteredCache = cache.concat();        	
        	stripNaNs(filteredCache, "xNumber");
            stripNaNs(filteredCache, "yNumber");

            if (_minField != "" || _stacked)
                stripNaNs(filteredCache, "minNumber");
        }
        else if (filterDataValues == "none")
        {
            filteredCache = cache;
        }
        return filteredCache;        
    }

	//--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     * @private
     */ 
    private function defaultFillFunction(element:AreaSeriesItem,i:Number):IFill
    {
        if (_fillCount!=0)
            return(GraphicsUtilities.fillFromStyle(_localFills[i % _fillCount]));
        else
            return(GraphicsUtilities.fillFromStyle(getStyle("fill")));
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function stack(stackedXValueDictionary:Object/*Dictionary*/, previousElement:IStackable):Number
    {
        var i:uint = 0;
        var itemClass:Class = itemType;
        var chartItem:AreaSeriesItem;
        var haveYField:Boolean = (_yField != null && _yField != "");
        var haveXField:Boolean = (_xField != null && _xField != "");
        var maxValue:Number = 0;

        var renderDataType:Class = this.renderDataType;
        _renderData= new renderDataType(this);      
        _renderData.cache = [];
        _renderData.filteredCache = [];

        if (cursor)
        {
            cursor.seek(CursorBookmark.FIRST);
            while (!cursor.afterLast)
            {
                var dataItem:* = cursor.current;
                _renderData.cache[i] = chartItem = new itemClass(this,dataItem,i);

                var xValue:*; 
                var yValue:Number; 
                if (dataFunction != null)
                {
                    xValue = dataFunction(this,dataItem,'xValue');
                    yValue = dataFunction(this,dataItem,'yValue');
                }
                else
                {
                    xValue = (haveXField)? dataItem[_xField]:i;
                    yValue = Number((haveYField)? dataItem[_yField]:dataItem);
                }
                if(dataTransform && dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) is NumericAxis &&
        			(dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) as NumericAxis).direction == "inverted")  
                	yValue = -yValue;
                if (xValue == null)  
                {
                	i++;
                	cursor.moveNext();  
                    continue;
                }
                // accessing a property on an XML node always returns a new XMLList. Which means
                // that using hte XMLList as a dictionary key to store and retrieve 
                // values in a dictionary won't work.  So we need to convert XMLLists to string values
                // first.
                if (xValue is XMLList)
                    xValue = xValue.toString();
                if (isNaN(yValue))
                    yValue = 0;

                var stackedValue:Object = stackedXValueDictionary[xValue];
                if (stackedValue == null)
                {
                    stackedValue = 0;
                }
				chartItem.yValue = yValue + stackedValue;
                chartItem.minValue = stackedValue;
                yValue += stackedValue;
                //chartItem.minValue = stackedValue;
                stackedXValueDictionary[xValue] = yValue;
                //chartItem.yValue = yValue;
                chartItem.xValue = xValue;
                maxValue = Math.max(maxValue,yValue);
                
                i++;
                cursor.moveNext();              
            }           
        }
        
        invalidateMapping(true);
        invalidateData(false);
        _stacked = (previousElement != null);
        return maxValue;
    }
        
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function stackAll(stackedPosXValueDictionary:Object/*Dictionary*/, stackedNegXValueDictionary:Object/*Dictionary*/, previousElement:IStackable2):Object
    {
        var i:uint = 0;
        var itemClass:Class = itemType;
        var chartItem:AreaSeriesItem;
        var haveYField:Boolean = (_yField != null && _yField != "");
        var haveXField:Boolean = (_xField != null && _xField != "");
        var maxValue:Number = 0;
        var minValue:Number = 0;

        var renderDataType:Class = this.renderDataType;
        _renderData= new renderDataType(this);      
        _renderData.cache = [];
        _renderData.filteredCache = [];

        if (cursor)
        {
            cursor.seek(CursorBookmark.FIRST);
            while (!cursor.afterLast)
            {
                var dataItem:* = cursor.current;
                _renderData.cache[i] = chartItem = new itemClass(this,dataItem,i);

                var xValue:*; 
                var yValue:Number; 
                if (dataFunction != null)
                {
                    xValue = dataFunction(this,dataItem,'xValue');
                    yValue = dataFunction(this,dataItem,'yValue');
                }
                else
                {
                    xValue = (haveXField)? dataItem[_xField]:i;
                    yValue = Number((haveYField)? dataItem[_yField]:dataItem);
                }
                if(dataTransform && dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) is NumericAxis &&
        			(dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) as NumericAxis).direction == "inverted")  
                	yValue = -yValue;
                if (xValue == null)  
                {
                	i++;
                	cursor.moveNext();  
                    continue;
                }
                // accessing a property on an XML node always returns a new XMLList. Which means
                // that using hte XMLList as a dictionary key to store and retrieve 
                // values in a dictionary won't work.  So we need to convert XMLLists to string values
                // first.
                if (xValue is XMLList)
                    xValue = xValue.toString();
                if (isNaN(yValue))
                    yValue = 0;

                var stackedValue:Object
                if (yValue >= 0)
                     stackedValue = stackedPosXValueDictionary[xValue];
                else
                    stackedValue = stackedNegXValueDictionary[xValue];
                if (stackedValue == null)
                {
                    stackedValue = 0;
                }
                
                chartItem.yValue = yValue + stackedValue;
                chartItem.minValue = stackedValue;
                yValue += stackedValue;
                //chartItem.minValue = stackedValue;
                if (yValue >= 0)
                {                   
                    stackedPosXValueDictionary[xValue] = yValue;
                    maxValue = Math.max(maxValue,yValue);
                }
                else if (yValue < 0)
                {
                    stackedNegXValueDictionary[xValue] = yValue;
                    minValue = Math.min(minValue, yValue);
                }
                //chartItem.yValue = yValue;
                chartItem.xValue = xValue;
                
                i++;
                cursor.moveNext();              
            }           
        }
        
        invalidateMapping(true);
        invalidateData(false);
        _stacked = (previousElement != null);
        return ({ maxValue:maxValue, minValue:minValue });
    }

    /**
     *  The stack totals for the series.
     *  @param totals The totals to set.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function set stackTotals(value:Object/*Dictionary*/):void
    {
        if (value)
        {
            var cache:Array /* of AreaSeriesItem */ = _renderData.cache;
            var n:int = _renderData.cache.length;
            for (var i:int = 0; i < n; i++)
            {
                var item:AreaSeriesItem = cache[i];
                var total:Number = value[item.xValue];
                item.yValue = Math.min(100, Number(item.yValue) / total * 100);
                item.minValue =
                    Math.min(100, Number(item.minValue) / total * 100);
            }
        }
    }

    /**
     *  Customizes the item renderer instances used to represent the chart. This method is called 
     *  automatically whenever a new item renderer is needed while the chart is being rendered. 
     *  You can override this method to add your own customization as necessary.
     *  
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
            dt += "<b>"+ n + "</b><BR/>";
        
        var xName:String = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).displayName;
        if (xName == "")
            xName = xField;
        if (xName != "")
            dt += "<i>" + xName + ": </i>";
            
        var item:AreaSeriesItem = AreaSeriesItem(hd.chartItem);
        var lowItem:AreaSeriesItem = (minField != "") ?
                                     item :
                                     null;
        dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(item.xValue) + "\n";

        var yName:String = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).displayName;

        if (!lowItem)
        {
            if (yName != "")
                dt += "<i>" + yName + ":</i> ";
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(item.yValue) + "\n";
        }
        else
        {
            if (yName != "")
                dt += "<i>" + yName + " (high):</i> ";
            else
                dt += "<i>high: </i>";
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(item.yValue) + "\n";

            if (yName != "")
                dt += "<i>" + yName + " (low):</i> ";
            else
                dt += "<i>low:</i> ";
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(lowItem.yValue) + "\n";
        }
        
        return dt;
    }

    /**
     *  @private
     */
    private function findClosestValidValue(index:uint, propName:String,
                                           cache:Array /* of AreaSeriesItem */):Number
    {
        var lastValidIndex:int = index;
        var value:Number;
        
        if (lastValidIndex >= cache.length)
            lastValidIndex = cache.length - 1;
        
        while (lastValidIndex >= 0 && isNaN(cache[lastValidIndex][propName]))
        {
            lastValidIndex--;
        }
        
        if (lastValidIndex >= 0)
            value =  cache[lastValidIndex][propName] 
            
        if (isNaN(value))
        {
            lastValidIndex = index + 1;
            var cachelen:int = cache.length;
            while (lastValidIndex < cachelen &&
                   isNaN(cache[lastValidIndex][propName]))
            {
                lastValidIndex++;
            }
            if (lastValidIndex < cachelen)
            {
                value = cache[lastValidIndex][propName] +
                        0.01 * (lastValidIndex - index);
            }
        }
                    
        return value + 0.01 * (lastValidIndex - index);
    }
    
    private function reverseYValues(cache:Array):Array
    {
    	var i:int = 0;
        var n:int = cache.length;
        for(i = 0; i < n ; i++)
        {
        	cache[i]["yValue"] = -(cache[i]["yValue"]);
        	if(_minField != "")
        		cache[i]["minValue"] = -(cache[i]["minValue"]);
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
import org.apache.royale.geom.Rectangle;

import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.series.AreaSeries;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.LinearGradientStroke;
import mx.graphics.Stroke;
import mx.skins.ProgrammaticSkin;

/**
 *  @private
 */
class AreaSeriesLegendMarker extends ProgrammaticSkin
{
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
    public function AreaSeriesLegendMarker()
    {
        super();
    }

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
        super.updateDisplayList(unscaledWidth, unscaledHeight);
                
        var fill:IFill = GraphicsUtilities.fillFromStyle(getStyle("areaFill"));
        var stroke:IStroke = getStyle("areaStroke");
                
        var w:Number = stroke ? 0.5 : 0;
        
        var rc:Rectangle = new Rectangle(w, w, width - 2 * w, height - 2 * w);
        
        var g:Graphics = graphics;
        g.clear();      
        g.moveTo(rc.left,rc.top);
        var strokeWeight:Number;
        if (stroke)
        {
            strokeWeight = stroke.weight;
            stroke.weight = 1;
            stroke.apply(g,null,null);
        }
        if (fill)
            fill.begin(g,rc,null);
        g.lineTo(rc.right,rc.top);
        g.lineTo(rc.right,rc.bottom);
        g.lineTo(rc.left,rc.bottom);
        g.lineTo(rc.left,rc.top);
        if (fill)
            fill.end(g);
        if (stroke)
            stroke.weight = strokeWeight;
    }
}
