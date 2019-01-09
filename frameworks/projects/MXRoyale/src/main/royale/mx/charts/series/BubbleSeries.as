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

import mx.charts.BubbleChart;
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
import mx.charts.renderers.CircleItemRenderer;
import mx.charts.series.items.BubbleSeriesItem;
import mx.charts.series.renderData.BubbleSeriesRenderData;
import mx.charts.styles.HaloDefaults;
import mx.collections.CursorBookmark;
import mx.core.ClassFactory;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.mx_internal;
import mx.graphics.IFill;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;

include "../styles/metadata/FillStrokeStyles.as"
include "../styles/metadata/ItemRendererStyles.as"

/**
 *  Specifies an Array of fill objects that define the fill for
 *  each item in the series. This takes precedence over the <code>fill</code> style property.
 *  If a custom method is specified by the <code>fillFunction</code> property, that takes precedence over this Array.
 *  If you do not provide enough Array elements for every item,
 *  Flex repeats the fill from the beginning of the Array.
 *  
 *  <p>To set the value of this property using CSS:
 *   <pre>
 *    BubbleSeries {
 *      fills:#CC66FF, #9966CC, #9999CC;
 *    }
 *   </pre>
 *  </p>
 *  
 *  <p>To set the value of this property using MXML:
 *   <pre>
 *    &lt;mx:BubbleSeries ... &gt;
 *     &lt;mx:fills&gt;
 *      &lt;mx:SolidColor color="0xCC66FF"/&gt;
 *      &lt;mx:SolidColor color="0x9966CC"/&gt;
 *      &lt;mx:SolidColor color="0x9999CC"/&gt;
 *     &lt;/mx:fills&gt;
 *    &lt;/mx:BubbleSeries&gt;
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
 *  Defines a data series for a BubbleChart control. The default itemRenderer is the CircleRenderer class.
 *  Optionally, you can define an itemRenderer for the 
 *  data series. The itemRenderer must implement the IDataRenderer interface.
 *
 *  @mxml
 *  <p>
 *  The <code>&lt;mx:BubbleSeries&gt;</code> tag inherits all the properties of its parent classes, and 
 *  the following properties:
 *  </p>
 *  <pre>
 *  &lt;mx:BubbleSeries
 *    <strong>Properties</strong>
 *    fillFunction="<i>Internal fill function</i>"
 *    horizontalAxis="<i>No default</i>"
 *    itemType="<i>No default</i>"
 *    legendData="<i>No default</i>"
 *    maxRadius="50"
 *    minRadius="0"
 *    radiusAxis="<i>No default</i>"
 *    radiusField="<i>No default</i>"
 *    renderData="<i>No default</i>"
 *    renderDataType="<i>No default</i>"
 *    verticalAxis="<i>No default</i>"
 *    xField="null"
 *    yField="null"
 *    
 *    <strong>Styles</strong>
 *    fill="<i>IFill; no default</i>"
 *    fills="<i>IFill; no default</i>"
 *    itemRenderer="<i>itemRenderer</i>"
 *    legendMarkerRenderer="<i>Defaults to series's itemRenderer</i>"
 *    stroke="<i>IStroke; no default</i>"  
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.charts.BubbleChart
 *  
 *  @includeExample ../examples/BubbleChartExample.mxml
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class BubbleSeries extends Series
{
//    include "../../core/Version.as";
    
    
    //--------------------------------------------------------------------------
    //
    //  Class initialization
    //
    //--------------------------------------------------------------------------
   

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  The type of radius axis.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const RADIUS_AXIS:String = "bubbleRadius";    


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
    public function BubbleSeries()
    {
        super();

        _instanceCache = new InstanceCache(null,this);
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
//	private static var _moduleFactoryInitialized:Dictionary = new Dictionary(true); 
	
	/**
	 *  @private
	 */
    private var _renderData:BubbleSeriesRenderData;
    
	/**
	 *  @private
	 */
    private var _instanceCache:InstanceCache;
    
    /**
     *  @private
     */
    private var _localFills:Array /* of IFill */;
    
    
    /**
     *  @private
     */
    private var _fillCount:int;
    
    //--------------------------------------------------------------------------
    //
    // Overridden Properties
    //
    //--------------------------------------------------------------------------
    
    //-------------------------
    // items
    //-------------------------
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get items():Array /* of BubbleSeriesItem */
    {
        return (_renderData)? _renderData.filteredCache : null;
    }
    
    //-----------------------------
    // legendData
    //-----------------------------
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
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
        ld.label = displayName; 
        ld.aspectRatio = 1;

        return [ld];
        
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
     * </p>
     *  
     * <p>An example usage of a customized <code>fillFunction</code> is to return a fill
     * based on some threshold.</p>
     *   
     * @example
     * <pre>
     * public function myFillFunction(item:ChartItem, index:Number):IFill {
     *      var curItem:BubbleSeriesItem = BubbleSeriesItem(item);
     *      if (curItem.zNumber > 10)
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
     *  The subtype of ChartItem used by this series to represent individual items.
     *  Subclasses can override and return a more specialized class if they need to store additional information in the items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get itemType():Class
    {
        return BubbleSeriesItem;
    }
    
    //----------------------------------
    //  maxRadius
    //----------------------------------

    private var _maxRadius:Number = 50;
    
    [Inspectable(category="General")]
    
    /**
     *  The radius of the largest item renderered in this series. When you use a BubbleSeries object in a BubbleChart, 
     *  the chart automatically assigns its <code>maxRadius</code> style value to this property 
     *  on all series in the chart. When you use BubbleSeries objects in CartesianChart controls, you manage this property manually.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxRadius():Number
    {
        return _maxRadius;
    }
    public function set maxRadius(value:Number):void
    {
        _maxRadius = value;
    }
    
    //----------------------------------
    //  minRadius
    //----------------------------------

    private var _minRadius:Number = 0;
    
    [Inspectable(category="General")]
    
    /**
     *  The radius of the smallest item renderered in this series. When you use a BubbleSeries object in a BubbleChart, the chart automatically assigns its <code>minRadius</code> style value to this property 
     *  on all series in the chart. When you use BubbleSeries objects in CartesianChart controls, you manage this property manually.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minRadius():Number
    {
        return _minRadius;
    }
    public function set minRadius(value:Number):void
    {
        _minRadius = value;
    }

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
     *  The axis the bubble radius is mapped against.
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
        return _radiusAxis;
    }

    /**
     *  @private
     */
    public function set radiusAxis(value:IAxis):void
    {
        _radiusAxis = value;
        _bAxesDirty = true;

        invalidateData();
        invalidateProperties();
    }

    //----------------------------------
    //  radiusField
    //----------------------------------

    private var _radiusField:String = "";

    [Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines the radius of each symbol, relative to the other 
     *  data points in the chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get radiusField():String
    {
        return _radiusField;
    }
    
    /**
     *  @private
     */
    public function set radiusField(value:String):void
    {
        _radiusField = value;

        dataChanged();
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
        return BubbleSeriesRenderData;
    }
    
        private var _bAxesDirty:Boolean = false;
    
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

    private var _xField:String = "";
    
    [Inspectable(category="General")]
    
    /**
     *  Specifies the field of the data provider that determines the x-axis location of 
     *  each data point. If <code>null</code>, Flex renders the 
     *  data points in the order that they appear in the data provider. 
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

    private var _yField:String = "";
    
    [Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines the y-axis location of each data point. 
     *  If <code>null</code>, the BubbleSeries assumes that the data provider is an Array of numbers, 
     *  and uses the numbers as values for the data points. 
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
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
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

		var bubbleSeriesStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.series.BubbleSeries");


		if (bubbleSeriesStyle)
		{
			bubbleSeriesStyle.setStyle("itemRenderer", new ClassFactory(mx.charts.renderers.CircleItemRenderer));
			bubbleSeriesStyle.setStyle("fill", new SolidColor(0x444444));
			bubbleSeriesStyle.setStyle("fills", []);
			bubbleSeriesStyle.setStyle("stroke", new SolidColorStroke(0,1,0.2));
		}
        else
        {
            //Fallback to set the style to this chart directly.
			setStyle("itemRenderer", new ClassFactory(mx.charts.renderers.CircleItemRenderer));
			setStyle("fill", new SolidColor(0x444444));
			setStyle("fills", []);
			setStyle("stroke", new SolidColorStroke(0,1,0.2));
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
                        
            if (_radiusAxis)
            {
                _radiusAxis.chartDataProvider = dataProvider;
                CartesianTransform(dataTransform).setAxis(RADIUS_AXIS, radiusAxis);
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
            
            if (!_radiusAxis)
            {
                if (c is BubbleChart)
                {
                    if (dataTransform.axes[RADIUS_AXIS] != (c as BubbleChart).radiusAxis)
                            dataTransform.setAxis(RADIUS_AXIS, (c as BubbleChart).radiusAxis);
                }
            }
        }
        dataTransform.elements = [this];
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function updateData():void
    {
        var renderDataType:Class = this.renderDataType;
        _renderData= new renderDataType();

        _renderData.cache = [];

        var i:uint = 0;
        var itemClass:Class = itemType;

        if (cursor)
        {
            cursor.seek(CursorBookmark.FIRST);
            while (!cursor.afterLast)
            {
                _renderData.cache[i] = new itemClass(this,cursor.current,i);
                i++;
                cursor.moveNext();
            }
        }


        cacheIndexValues(_xField,_renderData.cache,"xValue");
        cacheDefaultValues(_yField,_renderData.cache,"yValue");
        cacheNamedValues(_radiusField,_renderData.cache,"zValue");
	
		if(dataTransform && dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) is NumericAxis &&
			!(dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) is DateTimeAxis) && 
        	(dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS) as NumericAxis).direction == "inverted")  
        	_renderData.cache = reverseYValues(_renderData.cache);
        if(dataTransform && dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) is NumericAxis &&
        	!(dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) is DateTimeAxis) &&
        	(dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) as NumericAxis).direction == "inverted")  
        	_renderData.cache = reverseXValues(_renderData.cache);
        /*if(dataTransform && dataTransform.getAxis(BubbleSeries.RADIUS_AXIS) is NumericAxis &&
        	(dataTransform.getAxis(BubbleSeries.RADIUS_AXIS) as NumericAxis).direction == "inverted")  
        	_renderData.cache = reverseZValues(_renderData.cache);*/
        super.updateData();
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function updateMapping():void
    {
        dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(_renderData.cache,"xValue","xNumber",(_xField == ""));
        dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(_renderData.cache,"yValue","yNumber");
        dataTransform.getAxis(BubbleSeries.RADIUS_AXIS).mapCache(_renderData.cache,"zValue","zNumber");


       // _renderData.cache.sortOn("zNumber",Array.NUMERIC | Array.DESCENDING);       
        super.updateMapping();
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function updateFilter():void
    {
        _renderData.filteredCache = filterFunction(_renderData.cache);
        super.updateFilter();
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function updateTransform():void
    {
        dataTransform.transformCache(_renderData.filteredCache,"xNumber","x","yNumber","y");
        dataTransform.getAxis(BubbleSeries.RADIUS_AXIS).transformCache(_renderData.filteredCache,"zNumber","z");
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
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        var g:Graphics = graphics;
        g.clear();

        var renderData:BubbleSeriesRenderData = (transitionRenderData)? BubbleSeriesRenderData(transitionRenderData):_renderData;
                
        if (!renderData)
            return;

        var renderCache:Array /* of BubbleSeriesItem */ = renderData.filteredCache;
            
            
        var sampleCount:uint = renderCache.length;
        var i:uint;
        var instances:Array /* of IFlexDisplayObject */;
        var inst:IFlexDisplayObject;
        var rc:Rectangle;
        var v:BubbleSeriesItem;
        

        _instanceCache.factory = getStyle("itemRenderer");
        _instanceCache.count = sampleCount;         
        instances = _instanceCache.instances;

        var bSetData:Boolean = (sampleCount > 0 && (instances[0] is IDataRenderer))

        if (renderData == transitionRenderData && transitionRenderData.elementBounds)
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
                inst.move(rc.left,rc.top);
                inst.setActualSize(rc.width,rc.height);
            }           
        }
        else
        {
            var offset:Number = maxRadius - minRadius;
            for (i = 0 ; i < sampleCount; i++)
            {
                v = renderCache[i];
                var rad:Number = minRadius + v.z * offset;
                if (isNaN(rad))
                    continue;

                inst = instances[i];
                v.fill = fillFunction(v,i);
                if (!(v.fill))
                    v.fill = defaultFillFunction(v,i);
                v.itemRenderer = inst;
                if ((v.itemRenderer as Object).hasOwnProperty('invalidateDisplayList'))
                    (v.itemRenderer as Object).invalidateDisplayList();
                if (bSetData)
                    (inst as IDataRenderer).data = v;
                inst.move(v.x-rad,v.y-rad);
                inst.setActualSize(2*rad,2*rad);

            }
            if (chart && allSeriesTransform && chart.chartState == 0)
                chart.updateAllDataTips();
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
    override public function describeData(dimension:String, requiredFields:uint):Array /* of DataDescription */
    {
        validateData();

        var desc:DataDescription = new DataDescription();

        var cache:Array /* of BubbleSeriesItem */ = _renderData.cache;
        
        if (dimension == CartesianTransform.HORIZONTAL_AXIS)
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
                desc.boundedValues.push(new BoundedValue(desc.max,0,maxRadius));
                desc.boundedValues.push(new BoundedValue(desc.min,maxRadius,0));
            }
        }
        else if (dimension == CartesianTransform.VERTICAL_AXIS)
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
                desc.boundedValues.push(new BoundedValue(desc.max,0,maxRadius));
                desc.boundedValues.push(new BoundedValue(desc.min,maxRadius,0));
            }
        }
        else if (dimension == BubbleSeries.RADIUS_AXIS)
        {
            extractMinMax(cache,"zNumber",desc);           
        }
        else
            return [];
                
        return [desc];  
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
        
        var itemArr:Array /* of BubbleSeriesItem */ = [];
        if (chart && chart.dataTipItemsSet && dataTipItems)
            itemArr = dataTipItems;
        else if (chart && chart.showAllDataTips && _renderData.filteredCache)
            itemArr = _renderData.filteredCache;
        else
            itemArr = [];
        
        var n:uint = itemArr.length;
        var i:uint;
        var right:Number = unscaledWidth;
        var result:Array /* of HitData */ = [];
        
        for (i = 0; i < n; i++)
        {
            var v:BubbleSeriesItem = itemArr[i];
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
                hd.dataTipFunction = formatDataTip;
                var fill:IFill = BubbleSeriesItem(hd.chartItem).fill;
                hd.contextColor = GraphicsUtilities.colorFromFill(fill);
                result.push(hd);
            }
        }
        return result;
    }
    

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function findDataPoints(x:Number, y:Number, sensitivity:Number):Array /* of HitData */
    {
        // esg, 8/7/06: if your mouse is over a series when it gets added and displayed for the first time, this can get called
        // before updateData, and before and render data is constructed. The right long term fix is to make sure a stubbed out 
        // render data is _always_ present, but that's a little disruptive right now.
        if (interactive == false || !_renderData)
            return [];

        var minDist2:Number = maxRadius + sensitivity;
        minDist2 *= minDist2;
        var minItems:Array /* of BubbleSeriesItem */ = [];        
        var n:int;
        var i:int;      
        
        n = _renderData.filteredCache.length;
        var offset:Number = maxRadius - minRadius;
        for (i = n - 1; i >= 0; i--)
        {
            var v:BubbleSeriesItem = _renderData.filteredCache[i];          
            var dist:Number = (v.x  - x) * (v.x  - x) + (v.y - y) * (v.y -y);
            var r2:Number = minRadius + (v.z * offset) + sensitivity;
            r2 *= r2;
            if (dist > r2)
                continue;
                
            if (dist <= minDist2)
                minItems.push(v);   
        }
        
        n = minItems.length;
        for (i = 0; i < n; i++)
        {
            var item:BubbleSeriesItem = minItems[i];
            var hd:HitData = new HitData(createDataID(item.index),Math.sqrt(minDist2),item.x,item.y,item);
            hd.dataTipFunction = formatDataTip;
            var fill:IFill = BubbleSeriesItem(hd.chartItem).fill;
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

    /**
     *  @private
     */
    override public function getItemsInRegion(r:Rectangle):Array /* of BubbleSeriesItem */
    {
        if (interactive == false || !_renderData)
            return [];
        
        var arrItems:Array /* of BubbleSeriesItem */ = [];    
        var localRectangle:Rectangle = new Rectangle();
        var n:uint = _renderData.filteredCache.length;
                    
        localRectangle.topLeft = globalToLocal(r.topLeft);
        localRectangle.bottomRight = globalToLocal(r.bottomRight);
        
        for (var i:int=0; i < n; i++)
        {
            var v:BubbleSeriesItem = _renderData.filteredCache[i];
            
            if (localRectangle.contains(v.x,v.y))
                arrItems.push(v);
        }
        return arrItems;
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
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function styleChanged(styleProp : String) : void
    {
        super.styleChanged(styleProp);
        var styles:String = "stroke fill";
        if (styleProp == null || styleProp == "" || styles.indexOf(styleProp) != -1)
        {
            invalidateDisplayList();
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
            invalidateDisplayList();
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
    }

    /**
     *  @inheritDoc
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
            return new renderDataType([],[]);
        }
            
        return _renderData;
    }
    
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function getElementBounds(renderData:Object):void
    {
        var cache :Array /* of BubbleSeriesItem */ = renderData.cache;
        var rb :Array /* of Rectangle */ = [];
        
        var sampleCount:uint = cache.length;        

        var maxBounds:Rectangle 

        if (sampleCount == 0)
        {
            maxBounds = new Rectangle(0,0,unscaledWidth,unscaledHeight);
        }
        else
        {
            var offset:Number = maxRadius - minRadius;
            var v:Object = cache[0];
            maxBounds= new Rectangle(v.x,v.y,0,0);
            var rad:Number = minRadius +(v.z * offset);//v.radius;
            for (var i:uint = 0; i < sampleCount; i++)
            {
                v = cache[i];
                rad = minRadius +(v.z * offset);//v.radius;
                var b:Rectangle = new Rectangle(v.x-rad,v.y-rad,2*rad,2*rad);
                maxBounds.left = Math.min(maxBounds.left,b.left);
                maxBounds.top = Math.min(maxBounds.top,b.top);
                maxBounds.right = Math.max(maxBounds.right,b.right);
                maxBounds.bottom = Math.max(maxBounds.bottom,b.bottom);
                rb[i] = b;
            }
        }

        
        renderData.elementBounds = rb;
        renderData.bounds =  maxBounds;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function beginInterpolation(sourceRenderData:Object,destRenderData:Object):Object
    {
        var idata:Object = initializeInterpolationData(
            sourceRenderData.cache, destRenderData.cache,
            { x: true, y: true, z: true }, itemType);

        var interpolationRenderData:BubbleSeriesRenderData = BubbleSeriesRenderData(_renderData.clone());

        interpolationRenderData.cache = idata.cache;    
        interpolationRenderData.filteredCache = idata.cache;    
        
        transitionRenderData = interpolationRenderData;
        return idata;
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function getMissingInterpolationValues(sourceProps:Object,
    										srcCache:Array /* of BubbleSeriesItem */,
    										destProps:Object,
    										destCache:Array /* of BubbleSeriesItem */,
    										index:Number,customData:Object):void
    {
        for (var p:String in sourceProps)
        {
            var src:Number = sourceProps[p];
            var dst:Number = destProps[p];

            if (p == "x" || p == "y") 
                {
                    if (isNaN(src))
                    {
                        src = dst;
                    }
                    if (isNaN(dst))
                    {
                        dst = src;
                    }
            }
            else if (p == "z")
            {
                if (isNaN(src))
                {
                    src = 0;
                }
                if (isNaN(dst))
                {
                    dst = 0;
                }
            }
            sourceProps[p] = src;
            destProps[p] = dst;
        }       
    }
    
     
    /**
     * @private
     */ 
    override protected function defaultFilterFunction(cache:Array /*of BubbleSeriesItem */ ):Array /*of BubbleSeriesItem*/
    {
    	var filteredCache:Array /*of BubbleSeriesItem*/ = [];	
    	if (filterDataValues == "outsideRange")
        {
            filteredCache = cache.concat();
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).filterCache(filteredCache,"xNumber","xFilter");
            stripNaNs(filteredCache,"xFilter");
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(filteredCache,"yNumber","yFilter");
            stripNaNs(filteredCache,"yFilter");
            dataTransform.getAxis(BubbleSeries.RADIUS_AXIS).filterCache(filteredCache,"zNumber","zFilter");
            stripNaNs(filteredCache,"zFilter");
        }
        else if (filterDataValues == "nulls")
        {
            filteredCache = cache.concat();

            stripNaNs(filteredCache,"xNumber");
            stripNaNs(filteredCache,"yNumber");
            stripNaNs(filteredCache,"zNumber");
    
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
    
    private function defaultFillFunction(element:BubbleSeriesItem,i:Number):IFill
    {
        if (_fillCount!=0)
            return(GraphicsUtilities.fillFromStyle(_localFills[i % _fillCount]));
        else
            return(GraphicsUtilities.fillFromStyle(getStyle("fill")));
    }

    
    /**
     *  Applies style properties to the specified DisplayObject. This method is the 
     *  callback that the InstanceCache calls when it creates a new renderer.  
     *  
     *  @param instance The instance being created.
     *  @param cache A reference to the instance cache itself.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function applyItemRendererProperties(instance:UIComponent,cache:InstanceCache):void
    {
        if (instance is ISimpleStyleClient)
            ISimpleStyleClient(instance).styleName = this;
    }   

	/**
	 * @private
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
        dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(BubbleSeriesItem(hd.chartItem).xValue) + "\n";

        var yName:String = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).displayName;
        if (yName != "")
            dt += "<i>" + yName + ":</i> ";
        dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(BubbleSeriesItem(hd.chartItem).yValue) + "\n";

        var radName:String = dataTransform.getAxis(BubbleSeries.RADIUS_AXIS).displayName;
        if (radName != "")
            dt += "<i>" + radName + ":</i> ";
        dt += dataTransform.getAxis(BubbleSeries.RADIUS_AXIS).formatForScreen(BubbleSeriesItem(hd.chartItem).zValue) + "\n";
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
