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
import org.apache.royale.reflection.getDefinitionByName;

import mx.charts.ColumnChart;
import mx.charts.DateTimeAxis;
import mx.charts.HitData;
import mx.charts.chartClasses.CartesianChart;
import mx.charts.chartClasses.CartesianTransform;
import mx.charts.chartClasses.DataDescription;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.IColumn;
import mx.charts.chartClasses.IStackable;
import mx.charts.chartClasses.IStackable2;
import mx.charts.chartClasses.InstanceCache;
import mx.charts.chartClasses.LegendData;
import mx.charts.chartClasses.NumericAxis;
import mx.charts.chartClasses.Series;
import mx.charts.chartClasses.StackedSeries;
import mx.charts.renderers.BoxItemRenderer;
import mx.charts.series.items.ColumnSeriesItem;
import mx.charts.series.renderData.ColumnSeriesRenderData;
import mx.charts.styles.HaloDefaults;
import mx.collections.CursorBookmark;
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
 *    ColumnSeries {
 *      fills:#CC66FF, #9966CC, #9999CC;
 *    }
 *   </pre>
 *  </p>
 *  
 *  <p>To set the value of this property using MXML:
 *   <pre>
 *    &lt;mx:ColumnSeries ... &gt;
 *     &lt;mx:fills&gt;
 *      &lt;mx:SolidColor color="0xCC66FF"/&gt;
 *      &lt;mx:SolidColor color="0x9966CC"/&gt;
 *      &lt;mx:SolidColor color="0x9999CC"/&gt;
 *     &lt;/mx:fills&gt;
 *    &lt;/mx:ColumnSeries&gt;
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
 * Determines the alignment of the label. Considered only 
 * when labelPosition is <code>inside</code> and label is shown vertically. 
 * Possible values are <code>center</code>, <code>top</code>, and <code>bottom</code>.
 * 
 * @default "center"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="labelAlign", type="String", enumeration="top,center,bottom", inherit="no")]

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
 * Possible values are <code>none</code> , <code>outside</code>
 * and <code>inside</code>.
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
 *  Defines a data series for a ColumnChart control. By default, this class uses the BoxItemRenderer class.
 *  Optionally, you can define a custom itemRenderer for the 
 *  data series. The custom itemRenderer must implement the IDataRenderer interface. 
 *
 *  @mxml
 *  <p>
 *  The <code>&lt;mx:ColumnSeries&gt;</code> tag inherits all the properties of its parent classes, and 
 *  the following properties:
 *  </p>
 *  <pre>
 *  &lt;mx:ColumnSeries
 *    <strong>Properties</strong>
 *    columnWidthRatio=".65"
 *    fillFunction="<i>Internal fill function</i>"
 *    horizontalAxis="<i>No default</i>"
 *    labelField="<i>No default</i>"
 *    labelFunction="<i>No default</i>"
 *    legendData="<i>No default</i>"
 *    maxColumnWidth="<i>No default</i>"
 *    minField="null"
 *    offset="<i>No default</i>"
 *    sortOnXField="false|true"
 *    stacker="<i>No default</i>"
 *    stackTotals="<i>No default</i>"
 *    verticalAxis="<i>No default</i>"
 *    xField="null"
 *    yField="null"
 * 
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
 *    itemRenderer="<i>BoxItemRenderer</i>"
 *    legendMarkerRenderer="<i>Defaults to series's itemRenderer</i>"
 *    stroke="<i>Stroke; no default</i>"
 *    textDecoration="underline|none"
 *  /&gt;
 *  </pre>
 *  </p>
 *  
 *  @see mx.charts.ColumnChart
 *  
 *  @includeExample ../examples/Column_BarChartExample.mxml
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ColumnSeries extends Series implements IColumn,IStackable2
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
    public function ColumnSeries()
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
    mx_internal var labelCache:InstanceCache;
    
    /**
     *  @private
     */
    private var _labelLayer:UIComponent;
    
    /**
     *  @private
     */
    mx_internal var measuringField:IUITextField;
    
    /**
     *  @private
     */
    private var _renderData:ColumnSeriesRenderData;
        
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
    //  Overridden Properties
    //
    //--------------------------------------------------------------------------
    
    //-----------------------------------
    // items
    //-----------------------------------
    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get items():Array /* of ColumnSeriesItem */
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
    
    //-----------------------------------
    // legendData
    //-----------------------------------
    /**
     *  @private
     */
    
    override public function get legendData():Array /* of LegendData */
    {
        if ((fillFunction!=defaultFillFunction) || _fillCount!=0)
        {
            var keyItems:Array /* of LegendData */ = [];
            return keyItems;
        }
        var ld:LegendData = new LegendData();
        var marker:IFlexDisplayObject;
        var markerFactory:IFactory = getStyle("legendMarkerRenderer");
        ld.element = this;
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
    
    //---------------------------------------------------------------------
    //
    // Properties
    //
    //---------------------------------------------------------------------

    //----------------------------------
    //  columnWidthRatio
    //----------------------------------

    /**
     *  @private
     */
    private var _columnWidthRatio:Number = 0.65;
    
    [Inspectable(category="General", defaultValue="0.65")]

    /**
     *  Specifies the width of columns relative to the category width. A value of 1 uses the entire space, while a value of .6 
     *  uses 60% of the column's available space. 
     *  You typically do not set this property directly. 
     *  The actual column width used is the smaller of <code>columnWidthRatio</code> and the <code>maxColumnWidth</code> property.
     *  
     *  @default 0.65
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get columnWidthRatio():Number
    {
        return _columnWidthRatio;
    }       
    
    /**
     *  @private
     */
    public function set columnWidthRatio(value:Number):void
    {
        _columnWidthRatio = value;

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
    private var _fillFunction:Function = defaultFillFunction;
    
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
     *      var curItem:ColumnSeriesItem = ColumnSeriesItem(item);
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
        if (value != null)
            _fillFunction = value;
        
        else
            _fillFunction = defaultFillFunction;
            
        invalidateProperties();
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
     *  Subclasses can override and return a more specialized class if they need to store additional information in the items
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get itemType():Class
    {
        return ColumnSeriesItem;
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
     *      var item:ColumnSeriesItem = ColumnSeriesItem(element);
     *      var ser:ColumnSeries = ColumnSeries(series);
     *      return(item.item.Country + ":" +"" + ser.yField.toString() +":"+ item.yNumber);
     * }
     * </pre>
     *
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
    //  maxColumnWidth
    //----------------------------------

    /**
     *  @private
     */
    private var _maxColumnWidth:Number;
    
    [Inspectable(category="General")]

    /**
     *  Specifies the width of the columns, in pixels. The actual column width used is the smaller 
     *  of this style and the <code>columnWidthRatio</code> property.
     *  Clustered columns divide this space proportionally among the columns in each cluster. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxColumnWidth():Number
    {
        return _maxColumnWidth;
    }
    
    /**
     *  @private
     */
    public function set maxColumnWidth(value:Number):void
    {
        _maxColumnWidth = value;

        invalidateTransform();
    }

    //----------------------------------
    //  minField
    //----------------------------------

    /**
     *  @private
     */
    private var _minField:String = "";
    
    /**
     *  @private
     */
    private var _userMinField:String = "";
    
    [Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines the y-axis location of the bottom of a column. 
     *  If <code>null</code>, the columns are based at the range minimum (or maximum, if the field value is negative). 
     *  The default value is <code>null</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minField():String
    {
        return _userMinField;
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
     */
    private var _offset:Number = 0;

    [Inspectable(category="General", defaultValue="0")]

    /**
     *  Specifies how far to offset the center of the columns from the center of the available space, relative to the category width. 
     *  At the value of default 0, the columns are centered on the space.
     *  Set to -50 to center the column at the beginning of the available space.
     *  You typically do not set this property directly. The ColumnChart control manages this value based on 
     *  its <code>columnWidthRatio</code> property.
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
        return ColumnSeriesRenderData;
    }
    
    //----------------------------------
    //  sortOnXField
    //----------------------------------

    /**
     *  @private
     */
    private var _sortOnXField:Boolean = false;
    
    [Inspectable]

    /** 
     *  Requests the columns be sorted from left to right before rendering. By default, the 
     *  ColumnSeries renders columns in the order they appear in the data provider. 
     *  
     *  <p>If you use the <code>xField</code> property to determine the position of each column, 
     *  columns can appear in a different order on the screen. Columns can be rendered in 
     *  any order. However, some custom columns might rely on the columns being rendered 
     *  from left to right.</p>
     *  
     *  @default false
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
     */
    private var _xField:String = "";
    
    [Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines the x-axis location of the column. 
     *  If <code>null</code>, Flex renders the columns in the order they appear in the data provider. 
     *  The default value is <code>null</code>.
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
     */
    private var _yField:String = "";
    
    [Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines the y-axis location of the top of a column. 
     *  If <code>null</code>, the ColumnSeries assumes the data provider is an Array of numbers and uses the numbers as values. 
     *  The default value is <code>null</code>.
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
		
		var columnSeriesStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.series.ColumnSeries");


		if (columnSeriesStyle)
		{
			columnSeriesStyle.setStyle("itemRenderer", new ClassFactory(mx.charts.renderers.BoxItemRenderer));
			columnSeriesStyle.setStyle("fill", new SolidColor(0x000000));
			columnSeriesStyle.setStyle("fills", []);
			columnSeriesStyle.setStyle("stroke", HaloDefaults.emptyStroke);
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
    override protected function createChildren():void
    {
        super.createChildren();
        measuringField = IUITextField(createInFontContext(UITextField));
        measuringField.visible = false;
        measuringField.styleName = this;
        addChild(UIComponent(measuringField));
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
     *   @private
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
        _renderData= new renderDataType();      
        _renderData.cache = [];

        var i:uint = 0;
        var itemClass:Class = itemType;
        var v:ColumnSeriesItem;
        if (cursor)
        {
            cursor.seek(CursorBookmark.FIRST);
            while (!cursor.afterLast)
            {
                _renderData.cache[i] = v = new itemClass(this,cursor.current,i);
                i++;
                cursor.moveNext();
                
            }
            
        }
        cacheIndexValues(_xField,_renderData.cache,"xValue");
        cacheDefaultValues(_yField,_renderData.cache,"yValue");
        
        if (_minField != "")        
        {
            cacheNamedValues(_minField,_renderData.cache,"minValue");
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
        dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(_renderData.cache,"xValue","xNumber",(_xField == ""));
        dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(_renderData.cache,"yValue","yNumber");
        if (_minField != "" || _stacked)
        {
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).mapCache(_renderData.cache,"minValue","minNumber");
        }
        
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
            dataTransform.transformCache(_renderData.filteredCache,null,null,"minNumber","min");
        else
        {
            var baseVal:Number = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).baseline;
            var stub:Array /* of Object */ = [ { yNumber:baseVal } ];
            dataTransform.transformCache(stub,null,null,"yNumber","y");
            n = _renderData.filteredCache.length;
            _renderData.renderedBase = stub[0].y;
            for (i = 0; i < n; i++)
            {
                _renderData.filteredCache[i].min=_renderData.renderedBase;
            }
        }
        dataTransform.transformCache(_renderData.filteredCache,"xNumber","x","yNumber","y");


        var unitSize:Number = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).unitSize;
        
        var params:Array /* of Object */ = [{ xNumber:0 }, { xNumber:_columnWidthRatio*unitSize/2 },{ xNumber:_offset*unitSize }];
        dataTransform.transformCache(params,"xNumber","x",null,null);

        if (!isNaN(_maxColumnWidth) && (_maxColumnWidth <= 0 || _columnWidthRatio <= 0))
            return;

        if(params[1].x < params[0].x)   //direction is reverse for X-axis
        {
            params[0].x = - (params[0].x);
            params[1].x = - (params[1].x);
            params[2].x = - (params[2].x);
        } 
        _renderData.renderedHalfWidth = (params[1].x -  params[0].x);
        
        if (_offset == 0)
        {
            _renderData.renderedXOffset = 0;
        }
        else
        {
            _renderData.renderedXOffset = (params[2].x -  params[0].x);
        }
        if (!isNaN(_maxColumnWidth) && _maxColumnWidth < _renderData.renderedHalfWidth)
        {
            _renderData.renderedXOffset *=   _maxColumnWidth/_renderData.renderedHalfWidth;
            _renderData.renderedHalfWidth = _maxColumnWidth;
        }
        
        labelPos = getStyle('labelPosition');
        var temp:IUITextField = IUITextField(createInFontContext(UITextField));
        temp.text = "W";
        if (labelPos=="inside")
        {
            if (temp.textWidth > 2 * _renderData.renderedHalfWidth)
            {
                /*
                if (measuringField.embedFonts)
                {
                    if (temp.textHeight > 2 * renderData.renderedHalfWidth)
                    {
                        labelPos = "";
                        labelCache.count = 0;
                    }   
                }
                else
                {*/
                    labelPos = "";
                    labelCache.count = 0;
                //}
            }
        }
        else if (labelPos=="outside")
        {
            if (chart  && chart is ColumnChart)
            {
                if (!(ColumnChart(chart).showLabelVertically))
                {
                    if (temp.textWidth / 2 > 2 * _renderData.renderedHalfWidth) // .25% of column width
                    {
                        labelPos = "";
                        labelCache.count = 0;
                    }
                }
                else
                {
                    if (temp.textWidth > 2 * _renderData.renderedHalfWidth) // .25% of column width
                    {
                        /*
                        if (measuringField.embedFonts)
                        {
                            if (temp.textHeight > 2 * renderData.renderedHalfWidth)
                            {
                                labelPos = "";
                                labelCache.count = 0;
                            }   
                        }
                        else
                        {*/
                            labelPos = "";
                            labelCache.count = 0;
                        //}
                    }
                }
            }
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
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        if (!dataTransform)
        {
            labelCache.count=0;
            return; 
        }
        
        var g:Graphics = graphics;
        g.clear();

        _labelLayer.graphics.clear();
        
        if (!dataProvider)
        {
            labelCache.count=0;
            return;
        }

        if (!isNaN(_maxColumnWidth) && (_maxColumnWidth <= 0 || _columnWidthRatio <= 0))
            return;
        
        var renderData:ColumnSeriesRenderData = (transitionRenderData == null)? _renderData:ColumnSeriesRenderData(transitionRenderData);
        var activeCount:Array /* of ColumnSeriesItem */ = renderData.filteredCache;

        var i:uint;
        var sampleCount:uint = activeCount.length;
        
        var rc:Rectangle;
        var instances:Array /* of IFlexDisplayObject */;
        var inst:IFlexDisplayObject;
        var v:ColumnSeriesItem;
        
        _instanceCache.factory = getStyle("itemRenderer");
        _instanceCache.count = sampleCount;
        
        instances = _instanceCache.instances;
        
        var bSetData:Boolean = (sampleCount > 0 && (instances[0] is IDataRenderer))
        
        if (renderData.length == 0)
        {
            labelCache.count = 0;
            _instanceCache.count = 0;
            if (chart && (chart.showAllDataTips || chart.dataTipItemsSet))
                chart.updateAllDataTips();
            return;
        }
        
        if (transitionRenderData && transitionRenderData.elementBounds)
        {
            var elementBounds:Array /* of Rectangle */ = transitionRenderData.elementBounds;
            labelCache.count = 0;
            for (i = 0; i < sampleCount; i++)
            {
                inst = instances[i];
                v = activeCount[i];
                v.fill = fillFunction(v,i);
                if (!(v.fill))
                    v.fill = defaultFillFunction(v,i);
                v.itemRenderer = inst;
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
            var ro:Number = renderData.renderedHalfWidth + renderData.renderedXOffset;
            var lo:Number = - renderData.renderedHalfWidth + renderData.renderedXOffset;

            rc = new Rectangle();
            rc.bottom = Number((_minField == "")? - renderData.renderedBase : 0);

            for (i = 0; i < sampleCount; i++)
            {
                v = activeCount[i];
                
                rc.left = v.x + lo;
                rc.right = v.x + ro;
                rc.top = v.y;
                if (!isNaN(v.min))
                    rc.bottom = v.min;
                else
                    rc.bottom = renderData.renderedBase;
                inst = instances[i];
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
    override public function describeData(dimension:String, requiredFields:uint) :Array /* of DataDescription */
    {
        validateData();

        if (_renderData.cache.length == 0)
            return [];

        var description:DataDescription = new DataDescription();
        description.boundedValues = null;

        if (dimension == CartesianTransform.VERTICAL_AXIS)
        {
            extractMinMax(_renderData.cache,"yNumber",description);
            if (_minField != "")
                extractMinMax(_renderData.cache,"minNumber",description);

        }
        else if (dimension == CartesianTransform.HORIZONTAL_AXIS)
        {
            if (_xField != "")
            {
                if (_sortOnXField == false && (requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0)
                {
                    // if we need to know the min interval, then we rely on the cache being in order. So we need to sort it if it
                    // hasn't already been sorted
                    var sortedCache:Array /* of ColumnSeriesItem */ = _renderData.cache.concat();
                    sortedCache.sortOn("xNumber",Array.NUMERIC);        
                    extractMinMax(sortedCache,"xNumber",description, (requiredFields & DataDescription.REQUIRED_MIN_INTERVAL) != 0);
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
            
            description.padding = .5;
        }
        else
            return [];
            
        return [description];
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
        
        var itemArr:Array /* of ColumnSeriesItem */ = [];
        if (chart && chart.dataTipItemsSet && dataTipItems)
            itemArr = dataTipItems;
        else if (chart  && chart.showAllDataTips && _renderData.filteredCache)
            itemArr = _renderData.filteredCache;
        else
            itemArr = [];
        
        var n:uint = itemArr.length;
        var i:uint;
        var right:Number = unscaledWidth;
        var result:Array /* of HitData */ = [];
        
        for (i = 0; i < n; i++)
        {
            var v:ColumnSeriesItem = itemArr[i];
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
            if (v.x + _renderData.renderedXOffset + _renderData.renderedHalfWidth <= 0)
                continue;
            if (v.x + _renderData.renderedXOffset - _renderData.renderedHalfWidth >= right)
                continue;
                
            var base:Number = ((isNaN(v.min))? _renderData.renderedBase : v.min);
            
            if (v)
            {
                var ypos:Number;
                if (v.yNumber >= 0)
                    ypos = (isNaN(v.min))? v.y : Math.min(v.y,v.min);
                else
                    ypos = (isNaN(v.min))? v.y : Math.max(v.y,v.min);
                var id:uint = v.index;
                var hd:HitData = new HitData(createDataID(id),Math.sqrt(0),v.x + _renderData.renderedXOffset,ypos,v);
                hd.dataTipFunction = formatDataTip;
                var fill:IFill = ColumnSeriesItem(hd.chartItem).fill;
                hd.contextColor = GraphicsUtilities.colorFromFill(fill);
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
            
            
        
        var minDist:Number = _renderData.renderedHalfWidth + sensitivity;
        var minItem:ColumnSeriesItem;       

        var n:uint = _renderData.filteredCache.length;
        var i:uint;
        var right:Number = unscaledWidth;
        
        for (i = 0; i < n; i++)
        {
            var v:ColumnSeriesItem = _renderData.filteredCache[i];
            
            if (v.x + _renderData.renderedXOffset + _renderData.renderedHalfWidth <= 0)
                continue;
            if (v.x + _renderData.renderedXOffset - _renderData.renderedHalfWidth >= right)
                continue;

            var dist:Number = Math.abs((v.x + _renderData.renderedXOffset) - x);
            if (dist > minDist)
                continue;
                
            var base:Number = ((isNaN(v.min))? _renderData.renderedBase : v.min);
            var max:Number = Math.max(v.y,base);
            var min:Number = Math.min(v.y,base);


            if (min - y > sensitivity)
                continue;

            if (y - max > sensitivity)
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
            var ypos:Number
            if (minItem.yNumber >= 0)
                ypos = (isNaN(minItem.min))? minItem.y : Math.min(minItem.y,minItem.min);
            else
                ypos = (isNaN(minItem.min))? minItem.y : Math.max(minItem.y,minItem.min);
            var id:uint = minItem.index;
            var hd:HitData = new HitData(createDataID(id),Math.sqrt(minDist),minItem.x + _renderData.renderedXOffset,ypos,minItem);
            hd.dataTipFunction = formatDataTip;
            var fill:IFill = ColumnSeriesItem(hd.chartItem).fill;
            hd.contextColor = GraphicsUtilities.colorFromFill(fill);
            return [hd];
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

    /**
     *  @private
     */
    override public function getItemsInRegion(r:Rectangle):Array /* of ColumnSeriesItem */
    {
        // esg, 8/7/06: if your mouse is over a series when it gets added and displayed for the first time, this can get called
        // before updateData, and before and render data is constructed. The right long term fix is to make sure a stubbed out 
        // render data is _always_ present, but that's a little disruptive right now.
        if (interactive == false || !_renderData)
            return [];
        
        var arrItems:Array /* of ColumnSeriesItem */ = [];    
        var rc:Rectangle = new Rectangle();
        var localRectangle:Rectangle = new Rectangle();
        var n:uint = _renderData.filteredCache.length;
            
        localRectangle.topLeft = globalToLocal(r.topLeft);
        localRectangle.bottomRight = globalToLocal(r.bottomRight);

        
        for (var i:int = 0; i < n; i++)
        {
            var v:ColumnSeriesItem = _renderData.filteredCache[i];

            var ro:Number = renderData.renderedHalfWidth + renderData.renderedXOffset;
            var lo:Number = - renderData.renderedHalfWidth + renderData.renderedXOffset;


            rc.left = v.x + lo;
            rc.right = v.x + ro;
            rc.top = v.y;
            if (!isNaN(v.min))
                rc.bottom = v.min;
            else
                rc.bottom = _renderData.renderedBase;
            
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
     *  @private
     */
    override public function styleChanged(styleProp : String) : void
    {
        super.styleChanged(styleProp);
        var style1:String = "stroke fill";
        var style2:String = "fills";
        
        if (styleProp == null || styleProp == "" || style1.indexOf(styleProp) != -1)
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

    /**
     *  @private
     */
    override protected function get renderData():Object
    {
        if (!_renderData)
        {
            var renderDataType:Class = this.renderDataType;
            var rv:ColumnSeriesRenderData = new renderDataType();
            rv.cache = rv.filteredCache = [];
            rv.renderedHalfWidth = 0;
            rv.renderedXOffset = 0;
            rv.renderedBase = 0;

            return rv;
        }

        return _renderData;
    }
    
    /**
     *  @private
     */
    override public function beginInterpolation(sourceRenderData:Object,destRenderData:Object):Object
    {
        var idata:Object = initializeInterpolationData(
            sourceRenderData.cache, destRenderData.cache,
            { x: true, y: true, min: true }, itemType,
            { sourceRenderData: sourceRenderData,
              destRenderData: destRenderData });

        var interpolationRenderData:ColumnSeriesRenderData = ColumnSeriesRenderData(destRenderData.clone());

        interpolationRenderData.cache = idata.cache;    
        interpolationRenderData.filteredCache = idata.cache;    

        transitionRenderData = interpolationRenderData;
        return idata;
    }
    
    
    /**
     *  @private
     */
    override protected function getMissingInterpolationValues(sourceProps:Object,
                                        srcCache:Array /* of ColumnSeriesItem */,
                                        destProps:Object,destCache:Array /* of ColumnSeriesItem */,
                                        index:Number,customData:Object):void
    {
        for (var p:String in sourceProps)
        {
            var src:Number = sourceProps[p];
            var dst:Number = destProps[p];

            if (p == "y" || p == "min")
            {
                if (isNaN(src))
                {
                    src = customData.destRenderData.renderedBase;
                }
                if (isNaN(dst))
                {
                    dst = customData.sourceRenderData.renderedBase;
                }
            }
            else if (p == "x")
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
            sourceProps[p] = src;
            destProps[p] = dst;
        }       
    }


    /**
     *  @private
     */
    override public function getElementBounds(renderData:Object):void
    {
        var cache :Array /* of ColumnSeriesItem */ = renderData.filteredCache;
        var rb :Array /* of Rectangle */ = [];
        var sampleCount:uint = cache.length;        

        if (sampleCount)
        {
            var ro:Number = renderData.renderedHalfWidth + renderData.renderedXOffset;
            var lo:Number = - renderData.renderedHalfWidth + renderData.renderedXOffset;
    
            var v:Object = cache[0];
            var maxBounds:Rectangle = new Rectangle(v.x, v.y,0,0);
            for (var i:uint = 0; i < sampleCount; i++)
            {
                v = cache[i];
                var top:Number = Math.min(v.y,v.min);
                var b:Rectangle = new Rectangle(v.x+lo, top,ro-lo, Math.max(v.y,v.min) - top);
                maxBounds.left = Math.min(maxBounds.left,b.left);
                maxBounds.top = Math.min(maxBounds.top,b.top);
                maxBounds.right = Math.max(maxBounds.right,b.right);
                maxBounds.bottom = Math.max(maxBounds.bottom,b.bottom);
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
     * @private
     */ 
    override protected function defaultFilterFunction(cache:Array /*of ColumnSeriesItem */ ):Array /*of ColumnSeriesItem*/
    {
        var filteredCache:Array /*of ColumnSeriesItem*/ = [];   
        if (filterDataValues == "outsideRange")
        {
            filteredCache = cache.concat();

            dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).filterCache(filteredCache,"xNumber","xFilter");
            dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(filteredCache,"yNumber","yFilter");
            if (_minField != "" || _stacked)
            {
                dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).filterCache(filteredCache,"minNumber","minFilter");
            }

            stripNaNs(filteredCache,"yFilter");
            stripNaNs(filteredCache,"xFilter");
            if (_minField != "" || _stacked)
            {
                stripNaNs(filteredCache,"minFilter");
            }
    
        }
        else if (filterDataValues == "nulls")
        {
            filteredCache = cache.concat();

            stripNaNs(filteredCache,"yNumber");
            stripNaNs(filteredCache,"xNumber");
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
    private function defaultFillFunction(element:ColumnSeriesItem,i:Number):IFill
    {
        if (_fillCount!=0)
            return(GraphicsUtilities.fillFromStyle(_localFills[i % _fillCount]));
        else
            return(GraphicsUtilities.fillFromStyle(getStyle("fill")));
    }
    
    /**
     * @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    public function stack(stackedXValueDictionary:Object, previousElement:IStackable):Number
    {
        var i:uint = 0;
        var itemClass:Class = itemType;
        var chartItem:ColumnSeriesItem;
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
				if (yValue != 0)
				{
					chartItem.yValue = yValue + stackedValue;
					chartItem.minValue = stackedValue;
					
					yValue += stackedValue;
					stackedXValueDictionary[xValue] = yValue;
					chartItem.xValue = xValue;
					maxValue = Math.max(maxValue,yValue);
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
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function stackAll(stackedPosXValueDictionary:Object, stackedNegXValueDictionary:Object, previousElement:IStackable2):Object
    {
        var i:uint = 0;
        var itemClass:Class = itemType;
        var chartItem:ColumnSeriesItem;
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
                
                if (yValue == 0)
                {
                   // Do nothing
                }
                else
                {
                    chartItem.yValue = yValue + stackedValue;
                    chartItem.minValue = stackedValue;
                }
                
                yValue += stackedValue;
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
                chartItem.xValue = xValue;
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
            var cache:Array /* of ColumnSeriesItem */ = _renderData.cache;
            var n:int = _renderData.cache.length;
            for (var i:int = 0; i < n; i++)
            {
                var item:ColumnSeriesItem = cache[i];
                var total:Number = value[item.xValue];
                item.yValue = Math.min(100, Number(item.yValue) / total * 100);
                item.minValue =
                    Math.min(100, Number(item.minValue) / total * 100);
            }
        }
    }

   /**
    *  @private
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
        var renderData:ColumnSeriesRenderData = (transitionRenderData == null)? _renderData:ColumnSeriesRenderData(transitionRenderData);
        var activeCount:Array /* of ColumnSeriesItem */ = renderData.filteredCache;
        if (renderData.length == 0)
        {
            labelCache.count = 0;
            _instanceCache.count = 0;
            return;
        }
        
        if (chart && chart is ColumnChart && ColumnChart(chart).allLabelsMeasured)
        {
            var labelPosition:String = labelPos;
            if (labelPosition=="outside")
                renderExternalLabels(renderData,activeCount);
            else if (labelPosition=="inside")
                renderInternalLabels(renderData,activeCount);
            else
                labelCache.count = 0;
        }
    }
    
    /**
     * @private
     */
    private function renderInternalLabels(renderData:ColumnSeriesRenderData,activeCount:Array /* of ColumnSeriesItem */):void
    {
        var n:int=activeCount.length;
        labelCache.count = n;
        
        var labels:Array /* of Label */ = labelCache.instances;
        
        var dataTransform:CartesianTransform=CartesianTransform(dataTransform);
 
        var label:Object;
        var size:Number = getStyle('fontSize');
        var align:String = getStyle('labelAlign');
        for (var i:int = 0; i < n; i++)
        {
            var v:ColumnSeriesItem =activeCount[i];
            label = labels[i];
            label.x=v.labelX+2;
            label.y=v.labelY+4;
            label.width=v.labelWidth;
            label.height=v.labelHeight;
            label.setStyle('fontSize',size * renderData.labelScale);
            label.text = v.labelText;
            if (v.labelIsHorizontal)
            {
                if (v.y == (isNaN(v.min) ? renderData.renderedBase : v.min))
                    label.text = "";
                else
                {
                    label.setStyle('textAlign','center');
                    label.rotation = 0;
                }
            }
            else
            {
                if (align == "bottom")
                {
                    if (v.y < (isNaN(v.min) ? renderData.renderedBase : v.min))
                        label.setStyle('textAlign','left');
                    else if (v.y > (isNaN(v.min) ? renderData.renderedBase : v.min))
                        label.setStyle('textAlign','right');
                    else
                        label.text = "";
                }
                else if (align=="top")
                {
                    if (v.y < (isNaN(v.min) ? renderData.renderedBase : v.min))
                        label.setStyle('textAlign','right');
                    else if (v.y > (isNaN(v.min) ? renderData.renderedBase : v.min))
                        label.setStyle('textAlign','left');
                    else
                        label.text = "";
                }
                else 
                {
                    if (v.y == (isNaN(v.min) ? renderData.renderedBase : v.min))
                        label.text = "";
                    else
                        label.setStyle('textAlign','center');
                }
                    
                label.rotation = -90;              
            } 
            label.validateNow();
        }
    }
 
    /**
     * @private
     */       
    private function renderExternalLabels(renderData:ColumnSeriesRenderData,activeCount:Array /* of ColumnSeriesItem */):void
    {
        var n:int=activeCount.length;
        labelCache.count = n;
        var labels:Array /* of Label */ = labelCache.instances;
        var label:Object;
        var size:Number = getStyle('fontSize');
        
        for (var i:int = 0; i < n; i++)
        {
            var v:ColumnSeriesItem =activeCount[i];
            label=labels[i];
            
            label.x=v.labelX+2;
            label.y=v.labelY+4;
            label.width=v.labelWidth;
            label.height=v.labelHeight;
            label.setStyle('fontSize',size * renderData.labelScale);
            label.text = v.labelText;
            var rotation:Number = getStyle('labelRotation');     
            
            if (v.labelIsHorizontal)
            {   
                if (v.y == (isNaN(v.min) ? renderData.renderedBase : v.min))
                    label.text = "";
                else if (chart && !(ColumnChart(chart).showLabelVertically))
                {
                    /*
                    if(chart && chart.layoutDirection == LayoutDirection.RTL)       //Align labels to right of the item in rtl layout
                        label.setStyle('textAlign','right');
                    else*/                                            //Align them to left of the column in ltr layout
                        label.setStyle('textAlign','left');
                    label.setStyle('paddingLeft',0);
                    label.rotation = 0;
                }
                else
                {
                    label.setStyle('textAlign','center');
                    label.rotation = 0;
                }                
            }
            else
            {                
                if (v.y < (isNaN(v.min) ? renderData.renderedBase : v.min))
                    label.setStyle('textAlign','left');
                else if (v.y > (isNaN(v.min) ? renderData.renderedBase : v.min))
                {
                    if (!(isNaN(rotation)))
                        label.setStyle('textAlign','left');
                    else
                        label.setStyle('textAlign','right');
                }
                else
                    label.text = "";
                if (!(isNaN(rotation)))
                    label.rotation = rotation;
                else
                    label.rotation = -90;
            }
            label.validateNow();           
        }
    } 
    
   /**
    * @private
    */
    public function invalidateLabels():void
    {
        labelPos = getStyle('labelPosition');
        var temp:IUITextField = IUITextField(createInFontContext(UITextField));
        temp.text = "W";
        if (labelPos=="inside")
        {
            if (temp.textWidth > 2 * _renderData.renderedHalfWidth)
            {
                /*
                if (measuringField.embedFonts)
                {
                    if (temp.textHeight > 2 * renderData.renderedHalfWidth)
                    {
                        labelPos = "";
                        labelCache.count = 0;
                    }   
                }
                else
                {*/
                    labelPos = "";
                    labelCache.count = 0;
                //}
            }
        }
        else if (labelPos=="outside")
        {
            if (chart && chart is ColumnChart)
            {
                if (!(ColumnChart(chart).showLabelVertically))
                {
                    if (temp.textWidth / 2 > 2 * _renderData.renderedHalfWidth) // .25% of column width
                    {
                        labelPos = "";
                        labelCache.count = 0;
                    }
                }
                else
                {
                    if (temp.textWidth > 2 * _renderData.renderedHalfWidth) // .25% of column width
                    {
                        /*
                        if (measuringField.embedFonts)
                        {
                            if (temp.textHeight > 2 * renderData.renderedHalfWidth)
                            {
                                labelPos = "";
                                labelCache.count = 0;
                            }   
                        }
                        else
                        {*/
                            labelPos = "";
                            labelCache.count = 0;
                        //}
                    }
                }
            }
        }
        if (chart && chart is ColumnChart)
        {
            var c:ColumnChart = ColumnChart(chart);
            c.measureLabels(); 
        }
    }  

    /**
     *  Customizes the item renderer instances that are used to represent the chart. 
     *  This method is called automatically whenever a new item renderer is needed 
     *  while the chart is being rendered. 
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
    protected function applyItemRendererProperties(instance:UIComponent,cache:InstanceCache):void
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
        if (n != null && n.length>0)
        dt += "<b>" + n + "</b><BR/>";
        
        var xName:String = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).displayName;
        if (xName != "")
            dt += "<i>" + xName + ":</i> ";
        dt += dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).formatForScreen(ColumnSeriesItem(hd.chartItem).xValue) + "\n";


        var yName:String = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).displayName;
        if (_minField == "")
        {
            if (yName != "")
                dt += "<i>" + yName + ":</i> ";
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(ColumnSeriesItem(hd.chartItem).yValue) + "\n";
        }
        else
        {
            if (yName != "")
                dt += "<i>" + yName + " (high):</i> ";
            else
                dt += "<i>high:</i> ";
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(ColumnSeriesItem(hd.chartItem).yValue) + "\n";

            if (yName != "")
                dt += "<i>" + yName + " (low):</i> ";
            else
                dt += "<i>low:</i> ";
            dt += dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS).formatForScreen(ColumnSeriesItem(hd.chartItem).minValue) + "\n";
        }
        
        return dt;
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

    mx_internal function get seriesRenderData():Object
    {
        if (!_renderData)
        {
            var renderDataType:Class = this.renderDataType;
            var rv:ColumnSeriesRenderData = new renderDataType();
            rv.cache = rv.filteredCache = [];
            rv.renderedHalfWidth = 0;
            rv.renderedXOffset = 0;
            rv.renderedBase = 0;

            return rv;
        }

        return _renderData;
    }
}

}

