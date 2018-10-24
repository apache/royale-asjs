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

import mx.core.UIComponent;
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
import mx.charts.renderers.DiamondItemRenderer;
import mx.charts.series.items.PlotSeriesItem;
import mx.charts.series.renderData.PlotSeriesRenderData;
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
 *    PlotSeries {
 *      fills:#CC66FF, #9966CC, #9999CC;
 *    }
 *   </pre>
 *  </p>
 *  
 *  <p>To set the value of this property using MXML:
 *   <pre>
 *    &lt;mx:PlotSeries ... &gt;
 *     &lt;mx:fills&gt;
 *      &lt;mx:SolidColor color="0xCC66FF"/&gt;
 *      &lt;mx:SolidColor color="0x9966CC"/&gt;
 *      &lt;mx:SolidColor color="0x9999CC"/&gt;
 *     &lt;/mx:fills&gt;
 *    &lt;/mx:PlotSeries&gt;
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
 *  Specifies the radius, in pixels, of the chart element at each data point. 
 *  By default, the PlotChart control draws a circle at each data point.  
 *  You can set this property in MXML or using styles. 
 *  The default value is <code>5</code> pixels. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="radius", type="Number", format="Length", inherit="no")]

/**
 *  Defines a data series for a PlotChart control.
 *  The default item renderer for a PlotChart control
 *  is the DiamondItemRenderer class. 
 *  Optionally, you can define an item renderer for the data series.
 *  The item renderer must implement the IDataRenderer interface. 
 *
 *  @mxml
 *
 *  <p>The <code>&lt;mx:PlotSeries&gt;</code> tag inherits all the properties
 *  of its parent classes, and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:PlotSeries
 *    <strong>Properties</strong>
 *    fillFunction="<i>Internal fill function</i>"
 *    horizontalAxis="<i>No default</i>"
 *    verticalAxis="<i>No default</i>"
 *    xField="null"
 *    yField="null"
 * 
 *    <strong>Styles</strong>
 *    adjustedRadius="2"
 *    fill="0xFFFFFF"
 *    fills="<i>IFill; no default</i>"
 *    itemRenderer="<i>itemRenderer</i>"
 *    legendMarkerRenderer="<i>Defaults to series's itemRenderer</i>"
 *    radius="5"
 *    stroke="<i>IStroke; no default</i>" 
 *  /&gt;
 *  </pre>
 *  </p>
 *  
 *  @see mx.charts.PlotChart
 *  @see mx.charts.renderers.DiamondItemRenderer
 *  
 *  @includeExample ../examples/PlotChartExample.mxml
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class PlotSeries extends Series
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
    public function PlotSeries()
    {
        super();

        _instanceCache = new InstanceCache(null, this);
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
//    private static var _moduleFactoryInitialized:Dictionary = new Dictionary(true); 
    
    /**
     *  @private
     */
    private var _instanceCache:InstanceCache;

    /**
     *  @private
     */
    private var _renderData:PlotSeriesRenderData;   
    
    /**
     *  @private
     */
    private var _localFills:Array /* of IFill */;
    
    
    /**
     *  @private
     */
    private var _fillCount:Number;
    
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
        var ld:LegendData = new LegendData();
        var marker:IFlexDisplayObject;
        
        ld.element = this;
        var markerFactory:IFactory = getStyle("legendMarkerRenderer");
        if (!markerFactory)
            markerFactory = getStyle("itemRenderer");
        if (markerFactory) 
        {
            marker = markerFactory.newInstance();
            if (marker as ISimpleStyleClient)
                (marker as ISimpleStyleClient).styleName = this;
        }

        ld.marker = marker;
        ld.aspectRatio = 1;
        ld.label = displayName; 

        return [ ld ];
        
    }

    //----------------------------------
    //  renderData
    //----------------------------------

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
    override protected function get renderData():Object
    {
        if (!_renderData)
        {
            var renderDataType:Class = this.renderDataType;
            return new renderDataType([], [], 0);
        }

        _renderData.radius = getStyle("radius");            
        return _renderData;
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
    override public function get items():Array /* of PlotSeriesItem */
    {
        return _renderData ? _renderData.filteredCache : null;
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
     *      var curItem:PlotSeriesItem = PlotSeriesItem(item);
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
        return PlotSeriesItem;
    }

    //----------------------------------
    //  renderDataType
    //----------------------------------

    [Inspectable(environment="none")]

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
        return PlotSeriesRenderData;
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
     *  If <code>null</code>, Flex renders the data points
     *  in the order they appear in the dataProvider. 
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
     *  If <code>null</code>, the PlotSeries assumes the data provider
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
		
		var plotSeriesStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.series.PlotSeries");


		if (plotSeriesStyle)
		{
			plotSeriesStyle.setStyle("itemRenderer", new ClassFactory(mx.charts.renderers.DiamondItemRenderer));
			plotSeriesStyle.setStyle("fill", new SolidColor(0x4444AA));
			plotSeriesStyle.setStyle("fills", []);
		}
        else
        {
            //Fallback to set the style to this chart directly.
			setStyle("itemRenderer", new ClassFactory(mx.charts.renderers.DiamondItemRenderer));
			setStyle("fill", new SolidColor(0x4444AA));
			setStyle("fills", []);
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
        
        var g:Graphics = graphics;
        g.clear();

        var renderData:PlotSeriesRenderData =
            transitionRenderData ?
            PlotSeriesRenderData(transitionRenderData) :
            _renderData;
        if (!renderData)
            return;
        
        var renderCache:Array /* of PlotSeriesItem */ = renderData.filteredCache;

        var sampleCount:int = renderCache.length;
        var i:int;
        var instances:Array /* of IFlexDisplayObject */;
        var inst:IFlexDisplayObject;
        var rc:Rectangle;
        var v:PlotSeriesItem;
        
        _instanceCache.factory = getStyle("itemRenderer");
        _instanceCache.count = sampleCount;         
        instances = _instanceCache.instances;

        var bSetData:Boolean =
            (sampleCount > 0 && (instances[0] is IDataRenderer));

        if (renderData == transitionRenderData &&
            transitionRenderData.elementBounds)
        {
            var elementBounds:Array /* of Rectangle */ = renderData.elementBounds;

            for (i = 0; i < sampleCount; i++)
            {
                inst = instances[i];
                v = renderCache[i];
                v.itemRenderer = inst;
                v.fill = fillFunction(v,i);
                if (!(v.fill))
                    v.fill = defaultFillFunction(v,i);
                if ((v.itemRenderer as Object).hasOwnProperty('invalidateDisplayList'))
                        (v.itemRenderer as Object).invalidateDisplayList();
                if (bSetData)
                    (inst as IDataRenderer).data = v;
                rc = elementBounds[i];
                inst.move(rc.left, rc.top);
                inst.setActualSize(rc.width, rc.height);
            }           
        }
        else
        {
            var radius:Number = getStyle("radius");
                        
            for (i = 0; i < sampleCount; i++)
            {
                v = renderCache[i];
                inst = instances[i];
                v.itemRenderer = inst;
                v.fill = fillFunction(v,i);
                if (!(v.fill))
                    v.fill = defaultFillFunction(v,i);
                if ((v.itemRenderer as Object).hasOwnProperty('invalidateDisplayList'))
                        (v.itemRenderer as Object).invalidateDisplayList();
                if (bSetData)
                    (inst as IDataRenderer).data = v;
                inst.move(v.x - radius, v.y - radius);
                inst.setActualSize(2 * radius, 2 * radius);
            }
            if (chart && allSeriesTransform && chart.chartState == 0)
            chart.updateAllDataTips();
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
            _instanceCache.remove = true;
            _instanceCache.discard = true;
            _instanceCache.count = 0;
            _instanceCache.discard = false;
            _instanceCache.remove = false;
        }

        invalidateDisplayList();
        legendDataChanged();
        invalidateData();
    }

    /**
     *  @private
     */
    override public function describeData(dimension:String,
                                          requiredFields:uint):Array /* of DataDescription */
    {
        validateData();

        var desc:DataDescription = new DataDescription();
        var cache:Array /* of PlotSeriesItem */ = _renderData.cache;
        var radius:Number = getStyle("radius");
        
        if (dimension == CartesianTransform.VERTICAL_AXIS)
        {
            if ((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
            {
                cache = cache.concat();
                cache.sortOn("yNumber",Array.NUMERIC);      
            }
            extractMinMax(cache, "yNumber", desc, (requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0);
            if ((requiredFields & DataDescription.REQUIRED_BOUNDED_VALUES) != 0)
            {
                desc.boundedValues= [];
                desc.boundedValues.push(new BoundedValue(desc.max,0,radius));
                desc.boundedValues.push(new BoundedValue(desc.min,radius,0));
            }
        }
        else if (dimension == CartesianTransform.HORIZONTAL_AXIS)
        {
            if ((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
            {
                cache = cache.concat();
                cache.sortOn("xNumber",Array.NUMERIC);      
            }
            extractMinMax(cache, "xNumber", desc, (requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0);
            if ((requiredFields & DataDescription.REQUIRED_BOUNDED_VALUES) != 0)
            {
                desc.boundedValues= [];
                desc.boundedValues.push(new BoundedValue(desc.max,0,radius));
                desc.boundedValues.push(new BoundedValue(desc.min,radius,0));
            }
        }
        else
        {
            return [];
        }

        return [ desc ];    
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
        
        var itemArr:Array /* of PlotSeriesItem */ = [];
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
            var v:PlotSeriesItem = itemArr[i];
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
                hd.dataTipFunction = formatDataTip;
                var fill:IFill = PlotSeriesItem(hd.chartItem).fill;
                hd.contextColor = GraphicsUtilities.colorFromFill(fill);
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

        var radius:Number = getStyle("radius");
        var minDist2:Number = radius + sensitivity;
        minDist2 *= minDist2;
        var minItems:Array /* of PlotSeriesItem */ = [];         
        var pr2:Number = radius * radius;
        
        var n:int = _renderData.filteredCache.length;
        var i:int;
        
        for (i = n - 1; i >= 0; i--)
        {
            var v:Object= _renderData.filteredCache[i];         
            var dist:Number = (v.x  - x) * (v.x  - x) + (v.y - y) * (v.y - y);
            if (dist <= minDist2)
                minItems.push(v);
        }

        n = minItems.length;
        for (i = 0; i < n; i++)
        {
            var item:PlotSeriesItem = minItems[i];
            var hd:HitData = new HitData(createDataID(item.index),
                                         Math.sqrt(minDist2),
                                         item.x, item.y, item);
            hd.dataTipFunction = formatDataTip;
            var fill:IFill = PlotSeriesItem(hd.chartItem).fill;
            hd.contextColor = GraphicsUtilities.colorFromFill(fill);
            minItems[i] = hd;
        }

        return minItems;
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

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Series
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function updateData():void
    {
        var renderDataType:Class = this.renderDataType;
        _renderData = new renderDataType();

        _renderData.cache = [];
        var i:int = 0;
        var itemType:Class = this.itemType;
        if (cursor)
        {
            cursor.seek(CursorBookmark.FIRST);
            while (!cursor.afterLast)
            {
                _renderData.cache[i] = new itemType(this, cursor.current, i);
                i++;
                cursor.moveNext();
            }
        }

        cacheIndexValues(_xField, _renderData.cache, "xValue");
        cacheDefaultValues(_yField, _renderData.cache, "yValue");
        
        if(dataTransform && dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) is NumericAxis &&
            !(dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) is DateTimeAxis) && 
            (dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) as NumericAxis).direction == "inverted")  
            _renderData.cache = reverseYValues(_renderData.cache);
        if(dataTransform && dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) is NumericAxis &&
            !(dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) is DateTimeAxis) &&
            (dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) as NumericAxis).direction == "inverted")  
            _renderData.cache = reverseXValues(_renderData.cache);
            
        super.updateData();

        var radius:Number = getStyle("radius");

        var n:int = _renderData.cache.length;
        for (i = 0; i < n; i++)
        {
            _renderData.cache[i].radius = radius;
        }
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
        dataTransform.transformCache(
            _renderData.filteredCache, "xNumber", "x", "yNumber", "y");
        
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
        var cache:Array /* of PlotSeriesItem */ = renderData.cache;
        var rb:Array /* of Rectangle */ = [];
        var sampleCount:int = cache.length;     

        if (sampleCount)
        {
            var radius:Number = renderData.radius;
            var v:Object = cache[0];
            var maxBounds:Rectangle = new Rectangle(v.x, v.x, 0, 0);
    
            for (var i:int = 0; i < sampleCount; i++)
            {
                v = cache[i];
                
                var b:Rectangle = new Rectangle(v.x - radius, v.y - radius,
                                                2 * radius, 2 * radius);
                
                maxBounds.left = Math.min(maxBounds.left, b.left);
                maxBounds.top = Math.min(maxBounds.top, b.top);
                maxBounds.right = Math.max(maxBounds.right, b.right);
                maxBounds.bottom = Math.max(maxBounds.bottom, b.bottom);
                
                rb[i] = b;
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
        var idata:Object = initializeInterpolationData(
            sourceRenderData.cache, destRenderData.cache,
            { x: true, y: true }, itemType);
        
        var interpolationRenderData:PlotSeriesRenderData =
            PlotSeriesRenderData(destRenderData.clone());

        interpolationRenderData.cache = idata.cache;    
        interpolationRenderData.filteredCache = idata.cache;    

        transitionRenderData = interpolationRenderData;
        return idata;
    }

    /**
     *  @private
     */
    override protected function getMissingInterpolationValues(
                                    sourceProps:Object, srcCache:Array /* of PlotSeriesItem */,
                                    destProps:Object, destCache:Array /* of PlotSeriesItem */,
                                    index:Number, customData:Object):void
    {
        for (var p:String in sourceProps)
        {
            var src:Number = sourceProps[p];
            var dst:Number = destProps[p];

            if (p == "x" || p == "y") 
            {
                if (isNaN(src))
                    src = dst;
                if (isNaN(dst))
                    dst = src;
            }

            sourceProps[p] = src;
            destProps[p] = dst;
        }       
    }
    
    /**
     *  @private
     */
    override public function getItemsInRegion(r:Rectangle):Array /* of PlotSeriesItem */
    {
        if (interactive == false || !_renderData)
            return [];
        
        var arrItems:Array /* of PlotSeriesItem */ = [];    
        var localRectangle:Rectangle = new Rectangle();
        var n:uint = _renderData.filteredCache.length;
                               
        localRectangle.topLeft = globalToLocal(r.topLeft);
        localRectangle.bottomRight = globalToLocal(r.bottomRight);
        
        for (var i:int = 0; i < n; i++)
        {
            var v:PlotSeriesItem = _renderData.filteredCache[i];

            if (localRectangle.contains(v.x,v.y))
                arrItems.push(v);
        }
        return arrItems;
    }

     
    /**
     * @private
     */ 
    override protected function defaultFilterFunction(cache:Array /*of PlotSeriesItem */ ):Array /*of PlotSeriesItem*/
    {
        var filteredCache:Array /*of PlotSeriesItem*/ = []; 
        if (filterDataValues == "outsideRange")
        {
            filteredCache = cache.concat();

            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).filterCache(
                filteredCache, "xNumber", "xFilter");
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(
                filteredCache, "yNumber", "yFilter");
            
            stripNaNs(filteredCache, "yFilter");
            stripNaNs(filteredCache, "xFilter");
    
        }
        else if (filterDataValues == "nulls")
        {
            filteredCache = cache.concat();

            stripNaNs(filteredCache,"yNumber");
            stripNaNs(filteredCache,"xNumber");    
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
    private function defaultFillFunction(element:PlotSeriesItem,i:Number):IFill
    {
        if (_fillCount!=0)
        {
          return(GraphicsUtilities.fillFromStyle(_localFills[i % _fillCount]));
        }
        else
          return(GraphicsUtilities.fillFromStyle(getStyle("fill")));
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
            PlotSeriesItem(hd.chartItem).xValue) + "\n";

        var yName:String = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).displayName;
        if (yName != "")
            dt += "<i>" + yName + ":</i> ";
        dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(
            PlotSeriesItem(hd.chartItem).yValue) + "\n";
            
        return dt;
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
