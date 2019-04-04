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
import org.apache.royale.reflection.getDefinitionByName;

import mx.charts.BarChart;
import mx.charts.DateTimeAxis;
import mx.charts.HitData;
import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.CartesianTransform;
import mx.charts.chartClasses.DataDescription;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.IBar;
import mx.charts.chartClasses.IStackable;
import mx.charts.chartClasses.IStackable2;
import mx.charts.chartClasses.InstanceCache;
import mx.charts.chartClasses.LegendData;
import mx.charts.chartClasses.NumericAxis;
import mx.charts.chartClasses.Series;
import mx.charts.chartClasses.StackedSeries;
import mx.charts.renderers.BoxItemRenderer;
import mx.charts.series.items.BarSeriesItem;
import mx.charts.series.renderData.BarSeriesRenderData;
import mx.charts.styles.HaloDefaults;
import mx.collections.CursorBookmark;
import mx.collections.ICollectionView;
import mx.collections.IViewCursor;
import mx.core.ClassFactory;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.IUITextField;
//import mx.core.LayoutDirection;
import mx.core.UIComponent;
import mx.core.UITextField;
import mx.core.mx_internal;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;

include "../styles/metadata/FillStrokeStyles.as"
include "../styles/metadata/ItemRendererStyles.as"
include "../styles/metadata/TextStyles.as"

/**
 *  Specifies an Array of fill objects that define the fill for
 *  each item in the series. This takes precedence over the <code>fill</code> style property.
 *  If a custom method is specified by the <code>fillFunction</code> property, that takes precedence over this Array.
 *  If you do not provide enough Array elements for every item,
 *  Flex repeats the fill from the beginning of the Array.
 *  
 *  <p>To set the value of this property using CSS:
 *   <pre>
 *    BarSeries {
 *      fills:#CC66FF, #9966CC, #9999CC;
 *    }
 *   </pre>
 *  </p>
 *  
 *  <p>To set the value of this property using MXML:
 *   <pre>
 *    &lt;mx:BarSeries ... &gt;
 *     &lt;mx:fills&gt;
 *      &lt;mx:SolidColor color="0xCC66FF"/&gt;
 *      &lt;mx:SolidColor color="0x9966CC"/&gt;
 *      &lt;mx:SolidColor color="0x9999CC"/&gt;
 *     &lt;/mx:fills&gt;
 *    &lt;/mx:BarSeries&gt;
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
 * Determines the alignment of the label. Considered only if <code>labelPostion</code>
 * is <code>inside</code>. Possible values are <code>center</code>, <code>left</code>, 
 * and <code>right</code>.
 * 
 * @default "center"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="labelAlign", type="String", enumeration="left,center,right", inherit="no")]

/**
 *  The class that is used by this component to render labels.
 *
 *  <p>It can be set to either the mx.controls.Label class
 *  or the spark.components.Label class.</p>
 *
 *  @default spark.components.Label
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10.2
 *  @playerversion AIR 2.0
 *  @productversion Flex 4
 */
[Style(name="labelClass", type="Class", inherit="no")]
/**
 * Determines the position of labels
 * Possible values are <code>"none"</code> , <code>"outside"</code>
 * and <code>"inside"</code>.
 * 
 * @default "none"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="labelPosition", type="String", enumeration="none,outside,inside", inherit="no")]

/** 
 *  @private
 *  Specifies the label rotation.
 *  Considered only if labelPosition is outside.
 */
[Style(name="labelRotation", type="Number", inherit="no")]

/**
 *  Specifies the font size threshold, in points,
 *  below which labels are considered illegible.
 *  Below this threshold, Flex truncates the label.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="labelSizeLimit", type="Number", inherit="no")]

/**
 *  Defines a data series for a BarChart control.
 *  By default, this class uses the BoxItemRenderer class. 
 *  Optionally, you can define an itemRenderer for the data series.
 *  The itemRenderer must implement the IDataRenderer interface. 
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:BarSeries&gt;</code> tag inherits all the properties
 *  of its parent classes and adds the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:BarSeries
 *    <strong>Properties</strong>
 *    barWidthRatio=".65"
 *    fillFunction="<i>Internal fill function</i>"
 *    horizontalAxis="<i>No default</i>"
 *    labelField="<i>No default</i>"
 *    labelFunction="<i>No default</i>"
 *    maxBarWidth="<i>No default</i>"
 *    minField="null"
 *    offset="<i>No default</i>"
 *    stacker="<i>No default</i>"
 *    stackTotals="<i>No default</i>"
 *    verticalAxis="<i>No default</i>" 
 *    xField="null"
 *    yField="null"
 *  
 *    <strong>Styles</strong>
 *    fill="<i>IFill; no default</i>"
 *    fills="<i>IFill; no default</i>"
 *    fontFamily="Verdana"
 *    fontSize="10"
 *    fontStyle="italic|normal"
 *    fontWeight="bold|normal"
 *    labelAlign="center|left|right"
 *    labelPosition="none|inside|outside"
 *    labelSizeLimit="9"
 *    itemRenderer="<i>itemRenderer</i>"
 *    legendMarkerRenderer="<i>Defaults to series's itemRenderer</i>"
 *    stroke="<i>IStroke; no default</i>"
 *    textDecoration="underline|none"
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.charts.BarChart
 *  
 *  @includeExample ../examples/Column_BarChartExample.mxml
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class BarSeries extends Series implements IStackable2, IBar
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
    public function BarSeries()
    {
        super();

        _instanceCache = new InstanceCache(null,this);
        _instanceCache.creationCallback = applyItemRendererProperties;
        
        _labelLayer = new UIComponent();
        _labelLayer.styleName = this;
        
        labelCache = new InstanceCache(getLabelClass(),_labelLayer);
        labelCache.discard = true;
        labelCache.properties =
        {
            styleName: this
        };
        
        dataTransform = new CartesianTransform();

        // our style settings
        initStyles();
    }
    
    private function getLabelClass():Class
    {
        var labelClass:Class = getStyle("labelClass");
        if(labelClass == null)
        {
            try{
                labelClass = Class(getDefinitionByName("spark.components::Label"));
            }
            catch(e:Error)
            {
                labelClass = Class(getDefinitionByName("mx.controls::Label"));
            }
        }
        return labelClass;
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
    private var _renderData:BarSeriesRenderData;
    
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
    mx_internal var measuringField:IUITextField;
    
    /**
     *  @private
     */
    private var _labelLayer:UIComponent;
    
    /**
     *  @private
     */
    mx_internal var labelCache:InstanceCache;
    
   /**
    * @private
    */
    mx_internal var labelPos:String = "none";
    
   /**
    * @private
    */
    mx_internal var labelAngle:Number;

   /**
    * @private
    */
    mx_internal var maxLabelSize:Number;
    
    /**
     * @private
     */
    private var _bAxesDirty:Boolean = false;
     

    //--------------------------------------------------------------------------
    //
    //  Overridden properties:Series
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
    override public function get items():Array /* of BarSeriesItem */
    {
        return _renderData ? _renderData.filteredCache : null;
    }

    //----------------------------------
    //  labelContainer
    //----------------------------------
 
    /**
     *  @private
     */
    override public function get labelContainer():UIComponent
    {
        return _labelLayer;
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
        
        var marker:IFlexDisplayObject;

        var ld:LegendData = new LegendData();
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
        if (!_renderData)
        {
            var renderDataType:Class = this.renderDataType;
            var rv:BarSeriesRenderData = new renderDataType();
            rv.cache = rv.filteredCache = [];
            rv.renderedHalfWidth = 0;
            rv.renderedYOffset = 0;
            rv.renderedBase = 0;

            return rv;
        }

        return _renderData;
    }

    mx_internal function get seriesRenderData():Object
    {
        if (!_renderData)
        {
            var renderDataType:Class = this.renderDataType;
            var rv:BarSeriesRenderData = new renderDataType();
            rv.cache = rv.filteredCache = [];
            rv.renderedHalfWidth = 0;
            rv.renderedYOffset = 0;
            rv.renderedBase = 0;

            return rv;
        }

        return _renderData;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  barWidthRatio
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the barWidthRatio property.
     */
    private var _barWidthRatio:Number = 0.65;

    [Inspectable(category="General", defaultValue="0.65")]

    /**
     *  Specifies how wide to render the bars relative to the category width.
     *  A value of 1 uses the entire space, while a value of .6 
     *  uses 60% of the bar's available space. 
     *  You typically do not set this property directly.
     *  The actual bar width used is the smaller of <code>barWidthRatio</code> and the <code>maxbarWidth</code> property
     *  
     *  @default .65
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get barWidthRatio():Number
    {
        return _barWidthRatio;
    }

    /**
     *  @private
     */
    public function set barWidthRatio(value:Number):void
    {
        _barWidthRatio = value;

        invalidateTransform();
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
     * from the chart's data provider because it is sorted based on the x, y, and z values.
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
     *      var curItem:BarSeriesItem = BarSeriesItem(item);
     *      if (curItem.xNumber > 10)
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
        return BarSeriesItem;
    }

    //---------------------------------
    // labelField
    //---------------------------------
    
    /**
     * @private
     * Storage for labelField property
     */
    private var _labelField:String;
    
    [Inspectable(category="General")]
    
    /**
     * Name of a field in the data provider whose value appears as the label.
     * This property is ignored if the <code>labelFunction</code> property is specified.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get labelField():String
    {
        return _labelField;
    }
       
    /**
     * @private
     */
    public function set labelField(value:String):void
    {
        _labelField = value;
        invalidateLabels();                
    }
    
    //----------------------------------
    //  labelFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the labelFunction property.
     */
    private var _labelFunction:Function;

    [Inspectable(category="General")]

    /**
     *  Specifies a callback function used to render each label
     *  of the Series.
     *
     *  A labelFunction must have the following signature:
     *
     * <pre>
     * function <i>function_name</i>(<i>element</i>:ChartItem, <i>series</i>:Series):String { ... }
     * </pre>
     * 
     * <code><i>element</i></code> is the chart item that is being rendered.
     * 
     * <code><i>series</i></code> is the series to which the chart item belongs.
     * 
     * The returned String is the label of the current item.
     *
     * <p>An example usage of a customized labelFunction is as follows:</p>
     * <pre>
     * private function myLabelFunction(element:ChartItem, series:Series):String {
     *      var item:BarSeriesItem = BarSeriesItem(element);
     *      var ser:BarSeries = BarSeries(series);
     *      return(item.item.Country + ":" +"" + ser.xField.toString() +":"+ item.xNumber);
     * }
     * </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get labelFunction():Function
    {
        return _labelFunction;
    }

    /**
     *  @private
     */
    public function set labelFunction(value:Function):void
    {
        _labelFunction = value;

        invalidateLabels();
    }

    //----------------------------------
    //  maxBarWidth
    //----------------------------------

    /**
     *  @private
     *  Storage for the maxBarWidth property.
     */
    private var _maxBarWidth:Number;

    [Inspectable(category="General")]

    /**
     *  Specifies the width of the bars, in pixels.
     *  The actual bar width used is the smaller of this style and the <code>barWidthRatio</code> property.
     *  Clustered bars divide this space proportionally among the bars in each cluster. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxBarWidth():Number
    {
        return _maxBarWidth;
    }

    /**
     *  @private
     */
    public function set maxBarWidth(value:Number):void
    {
        _maxBarWidth = value;

        invalidateTransform();
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
     *  Specifies the field of the data provider that determines the bottom of each bar. 
     *  If <code>null</code>, the columns are based at 
     *  the range minimum (or maximum, if the field value is negative). 
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
    //  offset
    //----------------------------------

    /**
     *  @private
     *  Storage for the offset property.
     */
    private var _offset:Number = 0;

    [Inspectable(category="General", defaultValue="0")]

    /**
     *  Specifies how far to offset the center of the bars from the center of the available space, relative the category width. 
     *  The range of values is a percentage in the range <code>-100</code> to <code>100</code>. 
     *  Set to <code>0</code> to center the bars in the space. Set to <code>-50</code> to center the column at the beginning of the available space. You typically do not set this property directly.
     *  
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get offset():Number
    {
        return _offset;
    }

    /**
     *  @private
     */
    public function set offset(value:Number):void
    {
        _offset = value;

        invalidateTransform();
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
        return BarSeriesRenderData;
    }
    
    //----------------------------------
    //  stacker
    //----------------------------------

    /**
     *  @private
     */
    private var _stacker:StackedSeries; 

    /**
     *  @private
     */
    private var _stacked:Boolean = false;
    /**
     *  The StackedSeries associated with this BarSeries.
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
     *  Specifies the field of the data provider that determines the x-axis location of the top of each bar. If <code>null</code>, 
     *  the BarSeries assumes that the data provider is an Array of numbers, and uses the numbers as values.
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
     *  Specifies the field of the data provider that determines the y-axis location of the bottom of each bar in the chart. 
     *  If <code>null</code>, Flex arranges the bars in the order of the data in the data provider. 
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
		
		var barSeriesStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.series.BarSeries");


		if (barSeriesStyle)
		{
			barSeriesStyle.setStyle("itemRenderer", new ClassFactory(mx.charts.renderers.BoxItemRenderer));
			barSeriesStyle.setStyle("fill", new SolidColor(0x000000));
			barSeriesStyle.setStyle("fills", []);
			barSeriesStyle.setStyle("stroke", HaloDefaults.emptyStroke);
		}
        else
        {
            //Fallback to set the style to this chart directly.
			setStyle("itemRenderer", new ClassFactory(mx.charts.renderers.BoxItemRenderer));
			setStyle("fill", new SolidColor(0x000000));
			setStyle("fills", []);
			setStyle("stroke", HaloDefaults.emptyStroke);
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
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override protected function createChildren():void
    {
        super.createChildren();
        measuringField = IUITextField(createInFontContext(UITextField));
        measuringField.visible = false;
        measuringField.styleName = this;
        addChild(UIComponent(measuringField));
    }
    
    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
                
        if (!dataTransform)
        {
            labelCache.count = 0;
            return;
        }
            
        
        var g:Graphics = graphics;
        g.clear();
        _labelLayer.graphics.clear();
        
        if (!dataProvider)
        {
            labelCache.count = 0;
            return;         
        }
        
        if (!isNaN(_maxBarWidth) && (_maxBarWidth <= 0 || _barWidthRatio <= 0))
            return;
        
        var renderData:BarSeriesRenderData =
            transitionRenderData ?
            BarSeriesRenderData(transitionRenderData) :
            _renderData;

        var activeRenderCache:Array /* of BarSeriesItem */ = renderData.filteredCache;

        var i:int;
        var sampleCount:int = activeRenderCache.length;

        var rc:Rectangle;
        var instances:Array /* of IFlexDisplayObject */;
        var inst:IFlexDisplayObject; 

        _instanceCache.factory = getStyle("itemRenderer");
        _instanceCache.count = sampleCount;         
        instances = _instanceCache.instances;

        var bSetData:Boolean = sampleCount > 0 &&
                               instances[0] is IDataRenderer;
                               
        if (renderData.length == 0)
        {
            labelCache.count = 0;
            _instanceCache.count = 0;
            if (chart && (chart.showAllDataTips || chart.dataTipItemsSet))
                chart.updateAllDataTips();
            return;
        }
                
        if (transitionRenderData &&
            transitionRenderData.elementBounds)
        {
            var elementBounds:Array /* of Rectangle */ = transitionRenderData.elementBounds;
            labelCache.count = 0;
            for (i = 0; i < sampleCount; i++)
            {
                inst = instances[i];
                v = activeRenderCache[i];
                v.fill = fillFunction(v,i);
                if (!(v.fill))
                    v.fill = defaultFillFunction(v,i);
                v.itemRenderer = inst;
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
            var bo:Number = renderData.renderedHalfWidth +
                            renderData.renderedYOffset;
            
            var to:Number = -renderData.renderedHalfWidth +
                            renderData.renderedYOffset;

            rc = new Rectangle();
            for (i = 0; i < sampleCount; i++)
            {
                var v:BarSeriesItem = activeRenderCache[i];

                rc.top = v.y + to;
                rc.bottom = v.y + bo;
                rc.right = v.x;
                if (!isNaN(v.min))
                    rc.left = v.min;
                else
                    rc.left = renderData.renderedBase;

                inst = instances[i]
                v = activeRenderCache[i];
                v.fill = fillFunction(v,i);
                if (!(v.fill))
                    v.fill = defaultFillFunction(v,i);
                v.itemRenderer = inst;                    
                if ((v.itemRenderer as Object).hasOwnProperty('invalidateDisplayList'))
                    (v.itemRenderer as Object).invalidateDisplayList();
                if (bSetData)
                    (inst as IDataRenderer).data = v;
                inst.move(rc.left,rc.top);
                inst.setActualSize(rc.width,rc.height);
            }
            if (chart && allSeriesTransform && chart.chartState == 0)
                chart.updateAllDataTips();
        }
    }

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);
        
        var style1:String = "stroke fill";
        var style2:String = "fills";
        if (styleProp == null || styleProp == "" ||
            style1.indexOf(styleProp) != -1)
        {
            invalidateDisplayList();
            legendDataChanged();
        }
        else if (styleProp == "itemRenderer")
        {
            _instanceCache.remove = true;
            _instanceCache.discard = true;
            _instanceCache.count = 0;
            _instanceCache.discard = false;
            _instanceCache.remove = false;
        }
        
        else if (style2.indexOf(styleProp)!=-1)
        {
            _localFills = getStyle('fills');
            if (_localFills != null)
                _fillCount = _localFills.length;
            else
                _fillCount = 0;                
            invalidateDisplayList();
            legendDataChanged();
        }
        
        else if (styleProp == "labelAlign")
        {
           invalidateLabels();
        }
        
        else if (styleProp == "labelPosition")
        {
            labelPos = getStyle('labelPosition');
            invalidateLabels();
        }
        
        else if (styleProp == "labelSizeLimit")
        {
            maxLabelSize = getStyle('labelSizeLimit');
            invalidateLabels();
        }
        
        else if (styleProp == "labelRotation")
        {
            labelAngle = getStyle('labelRotation');
            invalidateLabels();
        }
        
    }
    
    /**
     *  @private
     *  since the labels aren't a decendant of the PieSeries, changes aren't propogating down.
     *  They should, since the PieSeries is the styleName of the labelLayer, but there seems 
     *  to be a bug. It's been logged, but I'm fixing it specifically in PieSeries for now
     *  by explciitly passing change notifications to the label layer.
     override public function notifyStyleChangeInChildren(
                        styleProp:String, recursive:Boolean):void
    {
        super.notifyStyleChangeInChildren(styleProp,recursive);
        
        _labelLayer.styleChanged(styleProp);
        if (recursive)
        {
            _labelLayer.notifyStyleChangeInChildren(styleProp, recursive);
        }
    }
     */
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: ChartElement
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override public function describeData(dimension:String, requiredFields:uint):Array /* of DataDescription */
    {
        validateData();

        if (_renderData.cache.length == 0)
            return [];

        var description:DataDescription = new DataDescription();
        description.boundedValues = null;

        if (dimension == CartesianTransform.VERTICAL_AXIS)
        {
            if (_yField != "")
            {
                if ((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
                {
                    // if we need to know the min interval, then we rely on the cache being in order. So we need to sort it if it
                    // hasn't already been sorted
                    var sortedCache:Array /* of BarSeriesItem */ = _renderData.cache.concat();
                    sortedCache.sortOn("yNumber",Array.NUMERIC);        
                    extractMinMax(sortedCache,"yNumber",description, (requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0);
                }
                else
                {
                    extractMinMax(_renderData.cache,"yNumber",description, (requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0);
                }
            }
            else 
            {
                description.min = _renderData.cache[0].yNumber;
                description.max =
                    _renderData.cache[_renderData.cache.length - 1].yNumber;
                if ((requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
                {
                    extractMinInterval(_renderData.cache,"xNumber",description);
                }
            }
            description.padding = .5;
        }
        else if (dimension == CartesianTransform.HORIZONTAL_AXIS)
        {
            extractMinMax(_renderData.cache, "xNumber", description);
            
            if (_minField != "")
                extractMinMax(_renderData.cache, "minNumber", description);
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
        
        var itemArr:Array /* of BarSeriesItem */ = [];
        if (chart && chart.dataTipItemsSet && dataTipItems)
            itemArr = dataTipItems;
        else if (chart && chart.showAllDataTips && _renderData.filteredCache)
            itemArr = _renderData.filteredCache;
        else
            itemArr = [];
        
        var n:uint = itemArr.length;
        var i:uint;
        var bottom:Number = unscaledHeight;
        var result:Array /* of HitData */ = [];
        
        for (i = 0; i < n; i++)
        {
            var v:BarSeriesItem = itemArr[i];
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
                
            if (v.y + _renderData.renderedYOffset + _renderData.renderedHalfWidth <= 0)
                continue;
            if (v.y + _renderData.renderedYOffset - _renderData.renderedHalfWidth >= bottom)
                continue;
                
            var base:Number = ((isNaN(v.min))? _renderData.renderedBase : v.min);
            
            if (v)
            {
                var xpos:Number;
                if (v.xNumber >= 0)
                    xpos = isNaN(v.min) ? v.x : Math.max(v.x, v.min);
                else
                    xpos = isNaN(v.min) ? v.x : Math.min(v.x, v.min);
                var hd:HitData = new HitData(createDataID(v.index), 
                                         Math.sqrt(0), xpos,
                                         v.y + _renderData.renderedYOffset,
                                         v);
                hd.dataTipFunction = formatDataTip;
                var fill:IFill = BarSeriesItem(hd.chartItem).fill;
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

        var modY:Number = y + _renderData.renderedYOffset;
        var minDist:Number = _renderData.renderedHalfWidth + sensitivity;
        var minItem:BarSeriesItem;

        var n:int = _renderData.filteredCache.length;
        var bottom:Number = unscaledHeight;
        for (var i:int = 0; i < n; i++)
        {
            var v:BarSeriesItem = _renderData.filteredCache[i];
            
            if (v.y + _renderData.renderedYOffset +
                _renderData.renderedHalfWidth <= 0)
            {
                continue;
            }
            
            if (v.y + _renderData.renderedYOffset -
                _renderData.renderedHalfWidth >= bottom)
            {
                continue;
            }
                
            var dist:Number = Math.abs((v.y + _renderData.renderedYOffset) - y);
            if (dist > minDist)
                continue;
                
            var base:Number = (isNaN(v.min)) ? _renderData.renderedBase : v.min;
            
            var max:Number = Math.max(v.x, base);
            var min:Number = Math.min(v.x, base);

            if (min - x > sensitivity)
                continue;

            if (x - max > sensitivity)
                continue;
                
            minDist = dist;
            minItem = v;
            if (dist < _renderData.renderedHalfWidth)
            {
                // we're actually inside the column, so go no further.
                break;
            }
        }
        
        if (minItem)
        {
            var xpos:Number;
            if (minItem.xNumber >= 0)
                xpos = isNaN(minItem.min) ? minItem.x : Math.max(minItem.x, minItem.min);
            else
                xpos = isNaN(minItem.min) ? minItem.x : Math.min(minItem.x, minItem.min);
            var hd:HitData = new HitData(createDataID(minItem.index), 
                                         Math.sqrt(minDist), xpos,
                                         minItem.y + _renderData.renderedYOffset,
                                         minItem);
            hd.dataTipFunction = formatDataTip;
            var fill:IFill = BarSeriesItem(hd.chartItem).fill;
            hd.contextColor = GraphicsUtilities.colorFromFill(fill);
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
     *  Stacks the series. Normally, a series implements the <code>updateData()</code> method
     *  to load its data out of the data provider. But a stacking series performs special 
     *  operations because its values are not necessarily stored in its data provider. 
     *  Its values are whatever is stored in its data provider, summed with the values 
     *  that are loaded by the object it stacks on top of.
     *  <p>A custom stacking series should implement the <code>stack()</code> method by loading its 
     *  data out of its data provider, adding it to the base values stored in the dictionary
     *  to get the real values it should render with, and replacing the values in the dictionary 
     *  with its new, summed values.</p>
     *  
     *  @param stackedYValueDictionary Contains the base values that the series should stack 
     *  on top of. The keys in the dictionary are the x values, and the values are the y values.
     *  
     *  @param previousElement The previous element in the stack. If, for example, the element
     *  is of the same type, you can use access to this property to avoid duplicate effort when
     *  rendering.
     *  
     *  @return The maximum value in the newly stacked series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function stack(stackedYValueDictionary:Object, previousElement:IStackable):Number
    {
        var i:uint = 0;
        var itemClass:Class = itemType;
        var chartItem:BarSeriesItem;
        var haveYField:Boolean = (_yField != null && _yField != "");
        var haveXField:Boolean = (_xField != null && _xField != "");
        var maxValue:Number = 0;

        var renderDataType:Class = this.renderDataType;
        _renderData= new renderDataType();      
        _renderData.cache = [];
        _renderData.filteredCache = [];

        if (cursor)
        {
            cursor.seek(CursorBookmark.FIRST);
            while (!cursor.afterLast)
            {
                var dataItem:* = cursor.current;
                _renderData.cache[i] = chartItem = new itemClass(this,dataItem,i);

                var xValue:Number; 
                var yValue:*; 
                
                if (dataFunction != null)
                {
                    xValue = dataFunction(this,dataItem,'xValue');
                    yValue = dataFunction(this,dataItem,'yValue');
                }
                else
                {
                    xValue = Number((haveXField)? dataItem[_xField]:dataItem);
                    yValue = (haveYField)? dataItem[_yField]:i;
                }
                if(dataTransform && dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) is NumericAxis &&
                    (dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) as NumericAxis).direction == "inverted")  
                    xValue = -xValue;
                if (yValue == null)  
                {
                    i++;
                    cursor.moveNext();  
                    continue;
                }
                // accessing a property on an XML node always returns a new XMLList. Which means
                // that using hte XMLList as a dictionary key to store and retrieve 
                // values in a dictionary won't work.  So we need to convert XMLLists to string values
                // first.
                if (yValue is XMLList)
                    yValue = yValue.toString();
                if (isNaN(xValue))
                    xValue = 0;

                var stackedValue:Object = stackedYValueDictionary[yValue];
                if (stackedValue == null)
                {
                    stackedValue = 0;
                }
				if (xValue != 0)
				{
					chartItem.xValue = xValue + stackedValue;
					chartItem.minValue = stackedValue;
					
					xValue += stackedValue;
					stackedYValueDictionary[yValue] = xValue;
					chartItem.yValue = yValue;
					maxValue = Math.max(maxValue,xValue);
				}
                i++;
                cursor.moveNext();              
            }           
        }
        
        _stacked = (previousElement != null);
        invalidateMapping(true);
        invalidateData(false);
        return maxValue;
    }
        
    /**
     *  Stacks the series. Normally, a series implements the <code>updateData()</code> method
     *  to load its data out of the data provider. But a stacking series performs special 
     *  operations because its values are not necessarily stored in its data provider. 
     *  Its values are whatever is stored in its data provider, summed with the values 
     *  that are loaded by the object it stacks on top of.
     *  <p>A custom stacking series should implement the <code>stackAll()</code> method by loading its 
     *  data out of its data provider, adding it to the base values stored in the dictionary
     *  to get the real values it should render with, and replacing the values in the dictionary 
     *  with its new, summed values.</p>
     *  
     *  @param stackedPosYValueDictionary Contains the base values that the series should stack 
     *  on top of. The keys in the dictionary are the y values, and the values are the positive
     *  x values.
     * 
     *  @param stackedNegYValueDictionary Contains the base values that the series should stack 
     *  on top of. The keys in the dictionary are the y values, and the values are the negative
     *  x values.
     *  
     *  @param previousElement The previous element in the stack. If, for example, the element
     *  is of the same type, you can use access to this property to avoid duplicate effort when
     *  rendering.
     *  
     *  @return An object representing the maximum and minimum values in the newly stacked series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function stackAll(stackedPosYValueDictionary:Object, stackedNegYValueDictionary:Object, previousElement:IStackable2):Object
    {
        var i:uint = 0;
        var itemClass:Class = itemType;
        var chartItem:BarSeriesItem;
        var haveYField:Boolean = (_yField != null && _yField != "");
        var haveXField:Boolean = (_xField != null && _xField != "");
        var maxValue:Number = 0;
        var minValue:Number = 0;

        var renderDataType:Class = this.renderDataType;
        _renderData= new renderDataType();      
        _renderData.cache = [];
        _renderData.filteredCache = [];

        if (cursor)
        {
            cursor.seek(CursorBookmark.FIRST);
            while (!cursor.afterLast)
            {
                var dataItem:* = cursor.current;
                _renderData.cache[i] = chartItem = new itemClass(this,dataItem,i);

                var xValue:Number; 
                var yValue:*; 
                
                if (dataFunction != null)
                {
                    xValue = dataFunction(this,dataItem,'xValue');
                    yValue = dataFunction(this,dataItem,'yValue');
                }
                else
                {
                    xValue = Number((haveXField)? dataItem[_xField]:dataItem);
                    yValue = (haveYField)? dataItem[_yField]:i;
                }
                if(dataTransform && dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) is NumericAxis &&
                    (dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS) as NumericAxis).direction == "inverted")  
                    xValue = -xValue;
                if (yValue == null)  
                {
                    i++;
                    cursor.moveNext();  
                    continue;
                }
                // accessing a property on an XML node always returns a new XMLList. Which means
                // that using hte XMLList as a dictionary key to store and retrieve 
                // values in a dictionary won't work.  So we need to convert XMLLists to string values
                // first.
                if (yValue is XMLList)
                    yValue = yValue.toString();
                if (isNaN(xValue))
                    xValue = 0;

                var stackedValue:Object;
                if (xValue >= 0)
                    stackedValue = stackedPosYValueDictionary[yValue];
                else
                    stackedValue = stackedNegYValueDictionary[yValue];
                if (stackedValue == null)
                {
                    stackedValue = 0;
                }
                if (xValue == 0)
                {
                    // Do nothing
                }
                else
                {
                    chartItem.xValue = xValue + stackedValue;
                    chartItem.minValue = stackedValue;
                }
                xValue += stackedValue;
                if (xValue >= 0)
                {
                    stackedPosYValueDictionary[yValue] = xValue;
                    maxValue = Math.max(maxValue,xValue);
                }
                else
                {
                    stackedNegYValueDictionary[yValue] = xValue;
                    minValue = Math.min(minValue,xValue);
                }
                chartItem.yValue = yValue;               
                i++;
                cursor.moveNext();              
            }           
        }        
        _stacked = (previousElement != null);
        invalidateMapping(true);
        invalidateData(false);
        return ({ maxValue:maxValue, minValue:minValue });
    }

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
     *  The stack totals for the series.
     *
     *  @param totals The totals to set.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function set stackTotals(value:Object):void
    {
        if (value)
        {
            var cache:Array /* of BarSeriesItem */ = _renderData.cache;
            var n:int = _renderData.cache.length;
            for (var i:int = 0; i < n; i++)
            {
                var item:BarSeriesItem = cache[i];
                var total:Number = value[item.yValue];
                item.xValue = Math.min(100, Number(item.xValue) / total * 100);
                item.minValue =
                    Math.min(100, Number(item.minValue) / total * 100);
            }
        }
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
        _renderData= new renderDataType();
        
        _renderData.cache = [];

        var i:int = 0;
        var itemClass:Class = itemType;
        if (cursor)
        {
            cursor.seek(CursorBookmark.FIRST);
            while (!cursor.afterLast)
            {
                _renderData.cache[i] =
                    new itemClass(this,cursor.current, i);
                i++;
                cursor.moveNext();
            }
            
        }

        cacheDefaultValues(_xField, _renderData.cache, "xValue");
            
        cacheIndexValues(_yField, _renderData.cache, "yValue");

        if (_minField != "")        
        {
            cacheNamedValues(_minField, _renderData.cache, "minValue");
            _renderData.renderedBase = NaN;
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
            _renderData.cache, "xValue", "xNumber");
        
        dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(
            _renderData.cache, "yValue", "yNumber", (_yField == ""));
        
        if (_minField != "" || _stacked)
        {
            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(
                _renderData.cache, "minValue", "minNumber");
        }

        // now convert
        if (_yField != "")
            _renderData.cache.sortOn("yNumber", Array.NUMERIC);     
        
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
        var n:int;
        var i:int;
        
        if (_minField != "" || _stacked)        
        {   
            dataTransform.transformCache(
                _renderData.filteredCache, "minNumber", "min", "", "");
        }
        else
        {
            var baseVal:Number = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).baseline;
            var stub:Array /* of Object */ = [ { xNumber: baseVal } ];
            dataTransform.transformCache(stub, "xNumber", "x", null, null);
            _renderData.renderedBase = stub[0].x;
            
            n = _renderData.filteredCache.length;
            for (i = 0; i < n; i++)
            {
                _renderData.filteredCache[i].min = _renderData.renderedBase;
            }
        }

        dataTransform.transformCache(
            _renderData.filteredCache, "xNumber", "x", "yNumber", "y");

        var unitSize:Number = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).unitSize;
        var params:Array /* of Object */ =
        [
            { yNumber: 0 },
            { yNumber: _barWidthRatio*unitSize/2 },
            { yNumber: _offset*unitSize }
        ];
        
        dataTransform.transformCache(params, null, null, "yNumber", "y");

        if (!isNaN(_maxBarWidth) && (_maxBarWidth <= 0 || _barWidthRatio <= 0))
            return;
        
        if(params[1].y > params[0].y)   //direction is reverse for Y-axis
        {
            params[0].y = - (params[0].y);
            params[1].y = - (params[1].y);
            params[2].y = - (params[2].y);
        }    
        _renderData.renderedHalfWidth = params[0].y -  params[1].y;
        
        if (_offset == 0)
            _renderData.renderedYOffset = 0;
        else
            _renderData.renderedYOffset = params[2].y - params[0].y;

        if (_maxBarWidth && _maxBarWidth < _renderData.renderedHalfWidth)
        {
            _renderData.renderedYOffset *= _maxBarWidth / _renderData.renderedHalfWidth;
            _renderData.renderedHalfWidth = _maxBarWidth;
        }
        labelPos = getStyle('labelPosition');
        var temp:IUITextField = IUITextField(createInFontContext(UITextField));
        temp.text = "W";
        
        if (temp.textHeight > 2 * _renderData.renderedHalfWidth)
        {
            labelPos = "";
            labelCache.count = 0;
        }
        super.updateTransform();
        allSeriesTransform = true;
            
        if (chart && chart is CartesianChart)
        {   
            var cChart:CartesianChart = CartesianChart(chart);  
            n = cChart.series.length;
            
            for (i = 0; i < n; i++)
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
    override public function stylesInitialized():void
    {
		_localFills = getStyle('fills');
        if (_localFills != null)
            _fillCount = _localFills.length;
        else
            _fillCount = 0;
        labelPos = getStyle('labelPosition');
        if (labelPos == "none")
            labelPos = "";
        labelAngle = getStyle('labelRotation');
        maxLabelSize = getStyle('labelSizeLimit');
        super.stylesInitialized();
    }

    /**
     *  @private
     */
    override public function getElementBounds(renderData:Object):void
    {
        var cache :Array /* of BarSeriesItem */ = renderData.cache;
        var rb :Array /* of Rectangle */ = [];
        var sampleCount:int = cache.length;     

        var maxBounds:Rectangle

        if (sampleCount == 0)
        {
            maxBounds= new Rectangle(0,0,unscaledWidth,unscaledHeight);
        }
        else
        {
            var bo:Number = renderData.renderedHalfWidth +
                            renderData.renderedYOffset;
            var to:Number = -renderData.renderedHalfWidth +
                            renderData.renderedYOffset;

            var v:Object = cache[0];
            maxBounds= new Rectangle(v.x, v.y, 0, 0);
            for (var i:int = 0; i < sampleCount; i++)
            {
                v = cache[i];
                var l:Number = Math.min(v.min, v.x);
                var b:Rectangle = new Rectangle(l, v.y + to,
                                                Math.max(v.min, v.x) - l,
                                                bo - to);
                
                maxBounds.left = Math.min(maxBounds.left, b.left);
                maxBounds.top = Math.min(maxBounds.top, b.top);
                maxBounds.right = Math.max(maxBounds.right, b.right);
                maxBounds.bottom = Math.max(maxBounds.bottom, b.bottom);
                
                rb[i] = b;
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
            { x: true, y: true, min: true }, itemType,
            { sourceRenderData: sourceRenderData,
              destRenderData: destRenderData });
        
        var interpolationRenderData:BarSeriesRenderData =
            BarSeriesRenderData(destRenderData.clone());

        interpolationRenderData.cache = idata.cache;    
        interpolationRenderData.filteredCache = idata.cache;    

        transitionRenderData = interpolationRenderData;
        
        return idata;
    }

    /**
     *  @private
     */
    override protected function getMissingInterpolationValues(
                                    sourceProps:Object, srcCache:Array /* of BarSeriesItem */,
                                    destProps:Object, destCache:Array /* of BarSeriesItem */,
                                    index:Number, customData:Object):void
    {
        for (var p:String in sourceProps)
        {
            var src:Number = sourceProps[p];
            var dst:Number = destProps[p];

            if (p == "x" || p == "min")
            {
                if (isNaN(src))
                    src = customData.destRenderData.renderedBase;
                
                if (isNaN(dst))
                    dst = customData.sourceRenderData.renderedBase;
            }
            else if (p == "y")
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
    override public function getItemsInRegion(r:Rectangle):Array /* of BarSeriesItem */
    {
        if (interactive == false || !_renderData)
            return [];
        
        var arrItems:Array /* of BarSeriesItem */ = [];    
        var rc:Rectangle = new Rectangle();;
        var localRectangle:Rectangle = new Rectangle();
        var n:uint = _renderData.filteredCache.length;
        
        localRectangle.topLeft = globalToLocal(r.topLeft);
        localRectangle.bottomRight = globalToLocal(r.bottomRight);

        for (var i:int = 0; i < n; i++)
        {
            var v:BarSeriesItem = _renderData.filteredCache[i];

            var bo:Number = renderData.renderedHalfWidth +  renderData.renderedYOffset;
            var to:Number = -renderData.renderedHalfWidth + renderData.renderedYOffset;

            rc.top = v.y + to;
            rc.bottom = v.y + bo;
            rc.right = v.x;
            if (!isNaN(v.min))
                rc.left = v.min;
            else
                rc.left = renderData.renderedBase;

            // Handle cases when width and height are -ve.
            if (rc.right < rc.left || rc.bottom < rc.top)
            {
                var rcTemp:Rectangle = new Rectangle(rc.x,rc.y,rc.width,rc.height);
                if (rc.right < rc.left)
                {
                    rcTemp.left = rc.right;
                    rcTemp.right = rc.left;
                }
                if (rc.bottom < rc.top)
                {
                    rcTemp.top = rc.bottom;
                    rcTemp.bottom = rc.top;
                }
                rc = rcTemp;
            }
            if (rc.intersects(localRectangle))
                arrItems.push(v);
        }
        return arrItems;
    }   
     
    /**
     * @private
     */ 
    override protected function defaultFilterFunction(cache:Array /*of BarSeriesItem */ ):Array /*of BarSeriesItem*/
    {
        var filteredCache:Array /*of BarSeriesItem*/ = [];  
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
                dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).filterCache(
                    filteredCache, "minNumber", "minFilter");
                stripNaNs(filteredCache, "minFilter");
            }
    
        }
        else if (filterDataValues == "nulls")
        {
            filteredCache = cache.concat();

            stripNaNs(filteredCache,"xNumber");
            stripNaNs(filteredCache,"yNumber");
            if (_minField != "" || _stacked)
            {
                stripNaNs(filteredCache,"minNumber");
            }
    
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
    private function defaultFillFunction(element:BarSeriesItem,i:Number):IFill
    {
        if (_fillCount!=0)
            return(GraphicsUtilities.fillFromStyle(_localFills[i % _fillCount]));
        else
            return(GraphicsUtilities.fillFromStyle(getStyle("fill")));
    }

    /**
     *  Customizes the item renderer instances that are used to represent the chart. This method is called automatically
     *  whenever a new item renderer is needed while the chart is being rendered. You can override this method to add your own customization as necessary.
     *  @param instance The new item renderer instance that is being created.
     *  @param cache The InstanceCache that is being used to manage the item renderer instances.
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
        
        var yName:String = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).displayName;
        if (yName != "")
            dt += "<i>" + yName + ":</i> ";
        dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(
            BarSeriesItem(hd.chartItem).yValue) + "\n";

        var xName:String = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).displayName;
        if (minField == "")
        {
            if (xName != "")
                dt += "<i>" + xName + ":</i> ";
            dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(
                BarSeriesItem(hd.chartItem).xValue) + "\n";
        }
        else
        {
            if (xName != "")
                dt += "<i>" + xName + " (high):</i> ";
            else
                dt += "<i>high:</i> ";
            dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(
                BarSeriesItem(hd.chartItem).xValue) + "\n";

            if (xName != "")
                dt += "<i>" + xName + " (low):</i> ";
            else
                dt += "<i>low:</i> ";
            dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(
                BarSeriesItem(hd.chartItem).minValue) + "\n";
        }
        
        return dt;
    }
    
   /**
    * @private
    */
    mx_internal function invalidateLabels():void
    {
        if (chart && chart is BarChart)
        {
            var b:BarChart = BarChart(chart);
            b.measureLabels(); 
        }
    } 
    
   /**
    * @private
    */
    mx_internal function updateLabels():void
    {
        if (!dataTransform)
        {
            labelCache.count=0;
            return; 
        }
        
        _labelLayer.graphics.clear();
        
        if (!dataProvider)
        {
            labelCache.count=0;
            return; 
        }
        var renderData:BarSeriesRenderData = (!transitionRenderData)? _renderData:BarSeriesRenderData(transitionRenderData);
        var activeRenderCache:Array /* of BarSeriesItem */ = renderData.filteredCache;
        if (renderData.length == 0)
        {
            labelCache.count = 0;
            _instanceCache.count = 0;
            return;
        }
        
        if (chart && chart is BarChart && BarChart(chart).allLabelsMeasured)
        {
            var labelPosition:String = labelPos;
            if (labelPosition=="outside")
                renderExternalLabels(renderData,activeRenderCache);
            else if (labelPosition=="inside")
                renderInternalLabels(renderData,activeRenderCache);
            else
                labelCache.count = 0;
        }
    }
    /**
     * @private
     */
    private function renderInternalLabels(renderData:BarSeriesRenderData,activeCount:Array /* of BarSeriesItem */):void
    {
        var n:int=activeCount.length;
        labelCache.count = n;             
        var labels:Array /* of Label */ = labelCache.instances;
        var dataTransform:CartesianTransform=CartesianTransform(dataTransform);
        
        var sparkLabelClass:Class;
        try
        {
            if(getDefinitionByName("spark.components.Label"))
            {
                sparkLabelClass = Class(getDefinitionByName("spark.components.Label"));
            }
        }
        catch(e:Error)
        {
            // We need not do any thing here because we came here for projects which do not have spark.swc
            // It might be an MX-only or in compatible mode and hence using MX Label
        }
        var label:Object;
        var align:String = getStyle('labelAlign');
        var size:Number = getStyle('fontSize');
        for (var i:int = 0; i < n; i++)
        {
            var v:BarSeriesItem =activeCount[i];
            label=labels[i];
            label.x=v.labelX;
            label.y=v.labelY;
            label.text=v.labelText;
            label.width=v.labelWidth;
            label.height=v.labelHeight;
            label.setStyle('fontSize',size * renderData.labelScale);
            if(sparkLabelClass && labels[i] is sparkLabelClass)
            {
                label.setStyle("paddingTop", 5);
                label.setStyle("paddingLeft", 3);
            }
            if (align == 'left')
            {
                if (v.x > (isNaN(v.min) ? renderData.renderedBase : v.min))
                    label.setStyle('textAlign','left');
                else if (v.x < (isNaN(v.min) ? renderData.renderedBase : v.min))
                    label.setStyle('textAlign','right');
                else
                    label.text = "";
            }
            else if (align=='right')
            {
                if (v.x > (isNaN(v.min) ? renderData.renderedBase : v.min))
                    label.setStyle('textAlign','right');
                else if (v.x < (isNaN(v.min) ? renderData.renderedBase : v.min))
                    label.setStyle('textAlign','left');
                else
                    label.text = "";
            }
            else
            {
                if (v.x == (isNaN(v.min) ? renderData.renderedBase : v.min))
                    label.text = "";
                else
                    label.setStyle('textAlign','center');
            }
            label.validateNow();           
        }
    }

   /**
    * @private
    */
    private function renderExternalLabels(renderData:BarSeriesRenderData,activeCount:Array /* of BarSeriesItem */):void
    {
        var n:int=activeCount.length;
        labelCache.count = n;             
        var labels:Array /* of Label */ = labelCache.instances;
        var label:Object;
        var sparkLabelClass:Class;
        if(getDefinitionByName("spark.components.Label"))
        {
            sparkLabelClass = Class(getDefinitionByName("spark.components.Label"));
        }
        var rotation:Number = getStyle('labelRotation');        
        var size:Number = getStyle('fontSize');
        for (var i:int = 0; i < n; i++)
        {
            var v:BarSeriesItem =activeCount[i];
            label=labels[i];
            label.x=v.labelX;
            label.y=v.labelY;
            label.width=v.labelWidth;
            label.height=v.labelHeight;
            label.text=v.labelText;
            label.setStyle('fontSize',size * renderData.labelScale);
            if(sparkLabelClass && labels[i] is sparkLabelClass)
            {
                label.setStyle("paddingTop", 5);
                label.setStyle("paddingLeft", 2);
            }
            if (v.x > (isNaN(v.min) ? renderData.renderedBase : v.min)) // If on positive side of axis
            {
                /*
                if(chart && chart.layoutDirection == LayoutDirection.RTL)   //Align labels to right in rtl layout
                    label.setStyle('textAlign','right');
                else*/
                    label.setStyle('textAlign','left');
            }
            else if (v.x < (isNaN(v.min) ? renderData.renderedBase : v.min))    //on negative side of axis
            {
                /*
                if (!isNaN(rotation) && rotation!=0 && measuringField.embedFonts)
                {
                    label.setStyle('textAlign','left');
                    label.rotation = rotation;
                }
                else
                {*/
                    /*
                    if(chart && chart.layoutDirection == LayoutDirection.RTL)   //Align labels to left in rtl layout
                        label.setStyle('textAlign','left');
                    else*/
                        label.setStyle('textAlign','right');
                    label.rotation = 0;
                //}   
            }
            else
                label.text = "";
            label.validateNow();        
        }           
    }
    
    private function reverseXValues(cache:Array):Array
    {
        var i:int = 0;
        var n:int = cache.length;
        for(i = 0; i < n ; i++)
        {
            cache[i]["xValue"] = -(cache[i]["xValue"]);
            if(_minField != "")
                cache[i]["minValue"] = -(cache[i]["minValue"]);
        }  
        return cache;
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
}

}

