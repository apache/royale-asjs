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
//import flash.filters.DropShadowFilter;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;
//import flash.text.TextFieldAutoSize;
COMPILE::SWF
{
import flash.text.TextFormat;
}
COMPILE::JS
{
    import mx.text.TextFormat;
}

import mx.charts.HitData;
import mx.charts.chartClasses.DataDescription;
import mx.charts.chartClasses.GraphicsUtilities;
import mx.charts.chartClasses.IAxis;
import mx.charts.chartClasses.InstanceCache;
import mx.charts.chartClasses.LegendData;
import mx.charts.chartClasses.PolarChart;
import mx.charts.chartClasses.PolarTransform;
import mx.charts.chartClasses.Series;
import mx.charts.renderers.WedgeItemRenderer;
import mx.charts.series.items.PieSeriesItem;
import mx.charts.series.renderData.PieSeriesRenderData;
import mx.charts.styles.HaloDefaults;
import mx.collections.CursorBookmark;
import mx.core.ClassFactory;
//import mx.core.ContextualClassFactory;
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
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.styles.CSSStyleDeclaration;
import mx.styles.ISimpleStyleClient;

use namespace mx_internal;

include "../styles/metadata/ItemRendererStyles.as"
include "../styles/metadata/TextStyles.as"

/**
 *  Specifies how much space, in pixels, to insert between the edge
 *  of the pie and the labels when rendering callouts.
 *  
 *  @default 10
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="calloutGap", type="Number", format="Length", inherit="no")]

/**
 *  Specifies the line style used to draw the lines to callouts.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="calloutStroke", type="mx.graphics.IStroke", inherit="no")]
    
/**
 *  Specifies an array of fill objects used to render
 *  each wedge of the PieChart control.
 *  If you do not provide enough Array elements for every slice,
 *  Flex repeats the fill from the beginning of the Array.
 *  If you specify a method using the <code>fillFunction</code> property, the 
 *  values set by that method take precedence over this Array.
 *  
 *  <p>To set the value of this property using CSS:
 *   <pre>
 *    PieSeries {
 *      fills:#CC66FF, #9966CC, #9999CC;
 *    }
 *   </pre>
 *  </p>
 *  
 *  <p>To set the value of this property using MXML:
 *   <pre>
 *    &lt;mx:PieSeries ... &gt;
 *     &lt;mx:fills&gt;
 *      &lt;mx:SolidColor color="0xCC66FF"/&gt;
 *      &lt;mx:SolidColor color="0x9966CC"/&gt;
 *      &lt;mx:SolidColor color="0x9999CC"/&gt;
 *     &lt;/mx:fills&gt;
 *    &lt;/mx:PieSeries&gt;
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
 *  A number from 0 to 1 specifying the distance from the center of the series
 *  to the inner edge of the rendered wedges,
 *  as a percentage of the total radius assigned to the series.
 *  This property is assigned directly to the series.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="innerRadius", type="Number", inherit="no")]
    
/**
 *  Specifies the font size threshold, in points,
 *  below which inside labels are considered illegible.
 *  Below this threshold, Flex either removes labels entirely
 *  or renders them as callouts based on the setting of
 *  the <code>labelPosition</code> property.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="insideLabelSizeLimit", type="Number", inherit="no")]

/** 
 *  Specifies how to render value labels.
 *  You can set this property in MXML or using styles.
 *  Valid values are:
 *  <ul>
 *    <li><code>"none"</code> - 
 *    Do not draw labels.</li>
 *  
 *    <li><code>"outside"</code> - 
 *    Draw labels around the boundary of the pie.</li>
 *  
 *    <li><code>"callout"</code> - 
 *    Draw labels in two vertical stacks on either side of the pie.
 *    The pie is shrunk if necessary to make room for the labels
 *    (see <code>maxLabelRadius</code>).
 *    Draw key lines from each label to the associated wedge.
 *    Shrink labels as necessary to fit the space provided.</li>
 *  
 *    <li><code>"inside"</code> - 
 *    Draw labels inside the chart,
 *    centered approximately seven tenths of the way along each wedge.
 *    Shrink labels to ensure that they do not interfere with each other.
 *    If labels are shrunk below the <code>insideLabelSizeLimitSize</code>
 *    property, remove them.
 *    When two labels overlap, Flex gives priority
 *    to labels for larger slices.</li>
 *  
 *    <li><code>"insideWithCallout"</code> - 
 *    Draw labels inside the pie, but if labels are shrunk
 *    below a legible size, Flex converts them to callouts.</li>
 *  </ul>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="labelPosition", type="String", enumeration="none,outside,callout,inside,insideWithCallout", inherit="no")]

/**
 *  Specifies the line style used to draw the border
 *  between the wedges of the pie.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="radialStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  Sets the direction in which the series is rendered.
 *  Valid values are:
 *  <ul>
 *    <li><code>"clockwise"</code> - 
 *    Draw the wedges in clockwise direction.</li>
 *  
 *    <li><code>"counterClockwise"</code> - 
 *    Draw the wedges in anti-clockwise direction.</li>
 *  </ul>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 4
 */
[Style(name="renderDirection", type="String", enumeration="clockwise,counterClockwise", inherit="no")]

/**
 *  Sets the stroke style for this data series.
 *  You must specify a Stroke object to define the stroke. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="stroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  The PieSeries class defines the data series for a PieChart control.
 *  The default item renderer is the WedgeItemRenderer class.
 *  Optionally, you can define an itemRenderer for the data series.
 *  The itemRenderer must implement the IDataRenderer interface.
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:PieSeries&gt;</code> tag inherits all the properties
 *  of its parent classes, and the following properties:</p>
 *  
 *  <pre>
 *  &lt;mx:PieSeries
 *    <strong>Properties</strong>
 *    angularAxis=""
 *    explodeRadius="0"
 *    field="null"
 *    fillFunction="<i>Internal fill function</i>"
 *    itemType="<i>No default</i>"
 *    labelFunction="<i>No default</i>"
 *    labelField="<i>No default</i>"
 *    maxLabelRadius="0.6" 
 *    nameField="null"
 *    outerRadius="1"
 *    perWedgeExplodeRadius="<i>Array, no default</i>"
 *    renderDataType="<i>No default</i>"
 *    reserveExplodeRadius="0"
 *    startAngle="0"
 * 
 *    <strong>Styles</strong>
 *    calloutGap="10"
 *    calloutStroke="<i>IStroke; no default</i>"
 *    fills="<i>IFill; no default</i>"
 *    fontSize="10"
 *    innerRadius="0"
 *    insideLabelSizeLimit="9"
 *    itemRenderer="<i>No default</i>"
 *    labelPosition="none|callout|inside|insideWithCallout|outside"
 *    legendMarkerRenderer="<i>Defaults to series's itemRenderer</i>"
 *    radialStroke="<i>IStroke; no default</i>"
 *    renderDirection="clockwise|counterClockwise"
 *    stroke="<i>IStroke; no default</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @see mx.charts.PieChart
 *  
 *  @includeExample ../examples/PieChartExample.mxml
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class PieSeries extends Series
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
     *  private
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private static const DROP_SHADOW_SIZE:Number = 6;

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
    public function PieSeries()
    {
        super();

        _labelLayer = new UIComponent();
        _labelLayer.styleName = this;
        
        _labelCache = new InstanceCache(UITextField,_labelLayer);
        
        _labelCache.discard = true;
        _labelCache.remove = true;
        
        _labelCache.properties =
        {
//            autoSize: TextFieldAutoSize.LEFT,
            selectable: false,
            styleName: this
        };
        
        perWedgeExplodeRadius = [];

        _instanceCache = new InstanceCache(null, this);
        _instanceCache.properties = { styleName: this };
		//filters = [ new DropShadowFilter(DROP_SHADOW_SIZE, 45, 0, 60,
        //                                 DROP_SHADOW_SIZE, DROP_SHADOW_SIZE) ];
        
        dataTransform = new PolarTransform();  

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
    private var _instanceCache:InstanceCache;

    /**
     *  @private
     */
    private var _renderData:PieSeriesRenderData;

    /**
     *  @private
     */
    private var _measuringField:IUITextField;
    
    /**
     *  @private
     */
    private var _labelLayer:UIComponent;
    
    /**
     *  @private
     */
    private var _labelCache:InstanceCache;

    /**
     *  @private
     */
    private var _origin:Point;

    /**
     *  @private
     */
    private var _radiusInPixelsAfterLabels:Number;
    
    /**
     *  @private
     */
    private var _radiusInPixelsScaledForExplode:Number = 1;
    
    /**
     *  @private
     */
    private var _innerRadiusInPixels:Number = 0;
    
    /**
     *  @private
     */
    private var _innerRadiusInPixelsScaledForExplode:Number = 0;
    
    /**
     *  @private
     */
    private var _maxExplodeRadiusRatio:Number = 0;
    
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
    private var _bAxesDirty:Boolean = false;
 	

    //--------------------------------------------------------------------------
    //
    //  Overridden properties
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
    override public function get items():Array /* of PieSeriesItem */
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
        validateData();

        var keyItems:Array /* of LegendData */ = [];
        var localFills:Array /* of IFill */ = getStyle("fills");
        var labelText:String;
        var i:int = 0;
        var legendData:PieSeriesLegendData;
        var markerFactory:IFactory = getStyle("legendMarkerRenderer");

        // This function can get called
        // before the style chain is properly initialized.
        if (!localFills)
            localFills = [ new SolidColor(0) ];

        var cache:Array /* of PieSeriesItem */ = _renderData.filteredCache ?
                          _renderData.filteredCache :
                          _renderData.cache;
        
        var n:int = cache.length;
        for (i = 0; i < n; i++)
        {
            var current:PieSeriesItem = cache[i];

            legendData = new PieSeriesLegendData();
            
            legendData.fill = current.fill;
            
            if (_nameField != null && _nameField != "")
                legendData.label = current.item[_nameField];
            else
                legendData.label = null;
            
            legendData.element = this;
            
            if (markerFactory) 
            {
                legendData.marker = markerFactory.newInstance();
                if (legendData.marker is ISimpleStyleClient)
                    (legendData.marker as ISimpleStyleClient).styleName = this;
            }
            
            keyItems[i] = legendData;
        }

        return keyItems;
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
            var td:PieSeriesRenderData = new renderDataType();
            td.cache = td.filteredCache = [];
            return td;
        }

        return _renderData;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

	//----------------------------------
    //  angularAxis
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the angularAxis property.
     */
    private var _angularAxis:IAxis;

    [Inspectable(category="Data")]
    
    /**
     *  The axis object used to map data values to an angle
     *  between 0 and 2 * PI.
     *  By default, this is a linear axis with the <code>autoAdjust</code>
     *  property set to <code>false</code>.
     *  So, data values are mapped uniformly around the chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get angularAxis():IAxis
    {
        return _angularAxis;
    }   
    
    /**
     *  @private
     */
    public function set angularAxis(value:IAxis):void
    {
        _angularAxis = value;
        _bAxesDirty = true;

        invalidateData();
    }   

    //----------------------------------
    //  explodeRadius
    //----------------------------------

    /**
     *  @private
     *  Storage for the explodeRadius property.
     */
    private var _explodeRadius:Number = 0;
    
    [Inspectable(category="General")]

    /**
     *  A number from 0 to 1, specifying how far all wedges of the pie
     *  series should be exploded from the center of the chart
     *  as a percentage of the total radius. 
     *  
     *  <p>This value explodes all wedges in the pie series uniformly.
     *  You can set the value for individual wedges
     *  via the <code>perWedgeExplodeRadius</code> property.</p>
     *  
     *  <p>The explode radius for any individual wedge is the value of the 
     *  <code>explodeRadius</code> property plus its value
     *  in the <code>perWedgeExplodeRadius</code> Array.</p>
     *  
     *  <p>To guarantee that the pie series
     *  stays within its containing chart's bounds while pulling out wedges,
     *  the pie series might shrink the total radius of the pie.
     *  If you dynamically pull out wedges at run time,
     *  the total pie radius shrinks. 
     *  To avoid this effect, you can "reserve" the space
     *  and shrink the total radius initially by setting the
     *  <code>reserveExplodeRadius</code> property to the maximum explode radius
     *  you intend to set at run time.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get explodeRadius():Number
    {
        return _explodeRadius;
    }

    /**
     *  @private
     */
    public function set explodeRadius(value:Number):void
    {
        _explodeRadius = Math.max(0,Math.min(value, 1));
        
        invalidateData();
    }

    //----------------------------------
    //  field
    //----------------------------------

    /**
     *  @private
     *  Storage for the field property.
     */
    private var _field:String = "";
    
    [Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines
     *  the data for each wedge of the PieChart control.
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get field():String
    {
        return _field;
    }

    /**
     *  @private
     */
    public function set field(value:String):void
    {
        _field = value;
        
        dataChanged();
    }

	
 	//--------------------------------------
    // fillFunction
    //--------------------------------------
    
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
     * <code>fills</code> style property.
     * But if it returns null, then <code>fills</code> will be prefered.
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
     *      var curItem:PieSeriesItem = PieSeriesItem(item);
     *      if (curItem.number > 10)
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
        if (value == _fillFunction)
            return;
            
        if (value != null)
            _fillFunction=value;
        else
            _fillFunction=defaultFillFunction;
            
        invalidateDisplayList();
        legendDataChanged();
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
        return PieSeriesItem;
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
     *  of the PieSeries.
     *  
     *  The callback function has the following format:
     *  <pre>
     *  <i>function_name</i>(<i>data</i>:Object, <i>field</i>:String, <i>index</i>:Number, <i>percentValue</i>:Number):String { ... }
     *  </pre>
     * 
     *  The <code>data</code> Object is the dataProvider item being rendered.
     *
     *  The <code>field</code> String is the name of the field in the data that is being rendered.
     *
     *  The <code>index</code> Number is the index in the original dataProvider of the item being rendered.
     *
     *  The <code>percent</code> Number is the percentage of the total this item represents.
     *
     *  This function returns a String that is the label for this item.
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

        invalidateDisplayList();
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
     * Name of a field in the data provider whose value appears as label
     * Ignored if labelFunction is specified
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
        invalidateTransform();              
    }

    //----------------------------------
    //  maxLabelRadius
    //----------------------------------

    private var _maxLabelRadius:Number = 0.6;
    
    [Inspectable(category="General")]
    
    /**
     *  The maximum amount of the PieSeries's radius
     *  that can be allocated to labels.
     *  This value is only applicable when the series
     *  is rendering callout labels.
     *  
     *  <p>When rendering callout labels, the PieSeries reduces the radius
     *  of the wedges to allow space for the labels along the sides.
     *  Once the amount of space allocated to the labels reaches this limit,
     *  the series begins reducing the size of the labels
     *  to stay within this size.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxLabelRadius():Number
    {
        return _maxLabelRadius;
    }
    public function set maxLabelRadius(value:Number):void
    {
        _maxLabelRadius = value;
    }

    //----------------------------------
    //  nameField
    //----------------------------------

    /**
     *  @private
     *  Storage for the nameField property.
     */
    private var _nameField:String = "";

    [Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines
     *  the name of each wedge of the PieChart control.
     *  
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get nameField():String
    {
        return _nameField;
    }

    /**
     *  @private
     */
    public function set nameField(value:String):void
    {
        _nameField = value;

        dataChanged();

        legendDataChanged();
    }

    //----------------------------------
    //  outerRadius
    //----------------------------------

    /**
     *  @private
     *  Storage for the outerRadius property.
     */
    private var _outerRadius:Number = 1;
    
    [Inspectable(category="General")]
    
    /**
     *  The percentage of the total space available to the PieSeries
     *  to use when rendering the contents of the series.
     *  This value is managed by the containing chart,
     *  and should not be assigned to directly.
     *  <p>This value ranges from 0 to 1.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get outerRadius():Number
    {
        return _outerRadius;
    }

    /**
     *  @private
     */
    public function set outerRadius(value:Number):void
    {
        _outerRadius = value;

        invalidateDisplayList();
    }

    //----------------------------------
    //  perWedgeExplodeRadius
    //----------------------------------

    /**
     *  @private
     *  Storage for the perWedgeExplodeRadius property.
     */
    private var _perWedgeExplodeRadius:Array /* of Number */;
    
    [Inspectable(category="General", arrayType="Number")]

    /**
     *  An Array of numbers from 0 to 1, specifying how far each wedge
     *  of the pie series should be exploded from the center of the chart
     *  as a percentage of the total radius. 
     *  
     *  <p>The <i>n</i>th value in this Array corresponds to the <i>n</i>th pie wedge.
     *  For example, to pull the third wedge half way out,
     *  you assign <code>perWedgeExplodeRadius = [ 0, 0, 50];</code>.</p>
     *  
     *  <p><code>null</code> or missing values in the Array are treated as 0.</p>
     *  
     *  <p>To guarantee that the pie series stays within
     *  its containing chart's bounds while pulling out wedges,
     *  the pie series might shrink the total radius of the pie.</p>
     *       
     *  <p>If you dynamically pull out wedges at run time,
     *  the total pie radius shrinks.
     *  To avoid this effect, you can "reserve" the space
     *  and shrink the total radius initially by setting the
     *  <code>reserveExplodeRadius</code> property to the maximum explode radius
     *  you intend to set at run time.</p>
     *  
     *  <p>The value for an individual wedge in the
     *  <code>perWedgeExplodeRadius</code> Array is added to the value
     *  of the series's <code>explodeRadius</code> property to calculate
     *  the total explode radius for any given wedge.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get perWedgeExplodeRadius():Array /* of Number */
    {
        return _perWedgeExplodeRadius.concat();
    }

    /**
     *  @private
     */
    public function set perWedgeExplodeRadius(value:Array /* of Number */):void
    {
        _perWedgeExplodeRadius = value.concat();
        
        var n:int = _perWedgeExplodeRadius.length;
        for (var i:int = 0; i < n; i++) 
        {
            _perWedgeExplodeRadius[i] =
                _perWedgeExplodeRadius[i] is Number ?
                Math.max(0, Math.min(_perWedgeExplodeRadius[i], 1)) :
                undefined;          
        }

        invalidateData();
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
        return PieSeriesRenderData;
    }
    
    //----------------------------------
    //  reserveExplodeRadius
    //----------------------------------

    /**
     *  @private
     *  Storage for the reserveExplodeRadius property.
     */
    private var _reserveExplodeRadius:Number = 0;
    
    [Inspectable(category="General")]

    /**
     *  A number from 0 to 1, specifying how much of the total radius
     *  of the pie series should be reserved to explode wedges at runtime.
     *  When a pie wedge is exploded, the series must shrink
     *  the total radius of the pie to make sure it doesn't exceed
     *  the bounds of its containing chart.
     *  Thus if a developer changes the explode value of a wedge at runtime,
     *  it can effectively shrink all the wedges rather than
     *  the desired effect of pulling out a single wedge.
     *  To avoid this, set <code>reserveExplodeRadius</code>
     *  to the maximum value you intend to explode any wedge at runtime.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get reserveExplodeRadius():Number
    {
        return _reserveExplodeRadius;
    }

    /**
     *  @private
     */
    public function set reserveExplodeRadius(value:Number):void
    {
        _reserveExplodeRadius =
            Math.max(0, Math.min(value, 1));
        
        invalidateData();
    }

    //----------------------------------
    //  startAngle
    //----------------------------------

    /**
     *  @private
     *  Storage for the startAngle property.
     */
    private var _startAngleRadians:Number = 0;
    
    [Inspectable(category="General")]

    /**
     *  Specifies the starting angle for the first slice of the PieChart control.
     *  The default value is 0,
     *  which is horizontal on the right side of the PieChart control.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get startAngle():Number
    {
        return _startAngleRadians * 180 / Math.PI;
    }

    /**
     *  @private
     */
    public function set startAngle(value:Number):void
    {
        const twopi:Number = 2 * Math.PI;
        _startAngleRadians = (value * Math.PI / 180) % twopi;
        if (value < 0)
            _startAngleRadians += twopi;
        
        invalidateTransform();
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
		
		var pieSeriesStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.series.PieSeries");
		var pieFills:Array /* of IFill */ = [];
		var n:int = HaloDefaults.defaultFills.length;


		for (var i:int = 0; i < n; i++)
		{
			pieFills[i] = HaloDefaults.defaultFills[i];
		}


		if (pieSeriesStyle)
		{
			pieSeriesStyle.setStyle("itemRenderer", new ClassFactory(mx.charts.renderers.WedgeItemRenderer));
			pieSeriesStyle.setStyle("fills", pieFills);
			pieSeriesStyle.setStyle("legendMarkerRenderer", new ClassFactory(PieSeriesLegendMarker));
			pieSeriesStyle.setStyle("calloutStroke", new SolidColorStroke(0,0,1));
		}
        else
        {
            //Fallback to set the style to this chart directly.
			setStyle("itemRenderer", new ClassFactory(mx.charts.renderers.WedgeItemRenderer));
			setStyle("fills", pieFills);
			setStyle("legendMarkerRenderer", new ClassFactory(PieSeriesLegendMarker));
			setStyle("calloutStroke", new SolidColorStroke(0,0,1));
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
		
		var textFieldFactory:Class = getStyle('textFieldClass');
        /*
		if(textFieldFactory != null)
			_labelCache.factory = new ContextualClassFactory(textFieldFactory, moduleFactory);
		else
			_labelCache.factory = new ContextualClassFactory(UITextField, moduleFactory);
		*/
		if (dataTransform)
		{
			if (_angularAxis)
				dataTransform.setAxis(PolarTransform.ANGULAR_AXIS, _angularAxis);
		}
		
		var c:PolarChart = PolarChart(chart);
		if (c)
		{
			if (!_angularAxis && dataTransform.axes[PolarTransform.ANGULAR_AXIS] != c.angularAxis)
				PolarTransform(dataTransform).setAxis(PolarTransform.ANGULAR_AXIS, c.angularAxis);
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
        _measuringField = IUITextField(createInFontContext(UITextField));
        _measuringField.visible = false;
        _measuringField.styleName = this;
		
//        _measuringField.autoSize = TextFieldAutoSize.LEFT;
        addChild(UIComponent(_measuringField));
        
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

        var dataTransform:PolarTransform = PolarTransform(dataTransform);

        var g:Graphics = graphics;
        g.clear();
        _labelLayer.graphics.clear();

        if (!dataProvider)
        {
        	_labelCache.discard = true;
    		_labelCache.remove = true;
            _labelCache.count = 0;
            _labelCache.discard = false;
    		_labelCache.remove = false;
            return;
        }

        var i:int;
        var renderData:PieSeriesRenderData = (transitionRenderData)? PieSeriesRenderData(transitionRenderData) :_renderData;

        if (!renderData || !(renderData.filteredCache))
            return;
        var renderCache:Array /* of PieSeriesItem */ = renderData.filteredCache;
        var n:int = renderCache.length;
        var item:PieSeriesItem;



        // ff we have element bounds, go through and reverse map from the bounds to actual inner,outer radius and start/end angles.
        if (renderData == transitionRenderData && transitionRenderData.elementBounds)
        {
            const twoP:Number = Math.PI*2;
            var boundsArray:Array /* of Rectangle */ = transitionRenderData.elementBounds;
            n = renderCache.length;

            var visibleBoundsStart:Number = transitionRenderData.visibleRegion.left;
            var visibleBoundsEnd:Number = transitionRenderData.visibleRegion.right;

            for (i = 0; i < n; i++)
            {
                var dataItem:PieSeriesItem = renderCache[i];
                var dataItemBounds:Rectangle = boundsArray[i];
                var tmpStartAngle:Number = dataItemBounds.left;
                var tmpA:Number = dataItemBounds.width;

                if (tmpStartAngle < visibleBoundsStart)
                {
                    tmpA = Math.max(0,tmpA + tmpStartAngle - visibleBoundsStart);
                    tmpStartAngle = visibleBoundsStart;
                }
                else if (tmpStartAngle + tmpA > visibleBoundsEnd)
                {
                    tmpStartAngle= Math.min(visibleBoundsEnd,tmpStartAngle);
                    tmpA = Math.max(0,visibleBoundsEnd - tmpStartAngle);
                }

                dataItem.startAngle = tmpStartAngle;
                dataItem.angle = tmpA;
                dataItem.innerRadius = dataItemBounds.top;
                dataItem.outerRadius = dataItemBounds.bottom;
            }
        }

        if (renderData.itemSum == 0)
        {
        	_labelCache.discard = true;
    		_labelCache.remove = true;
            _labelCache.count = 0;
            _labelCache.discard = false;
    		_labelCache.remove = false;
            _instanceCache.count = 0;
            if (chart && (chart.showAllDataTips || chart.dataTipItemsSet))
        		chart.updateAllDataTips();
            return;
        }

        var labelPosition:String = getStyle("labelPosition");
        
        // secondly, if our inner radius is larger than our outer radius, we should be completely invisible, so we'll just hide the labels.
        if (getStyle("innerRadius") >= _outerRadius || (renderData == transitionRenderData) || n == 0){
        	_labelCache.discard = true;
    		_labelCache.remove = true;
            _labelCache.count = 0;
            _labelCache.discard = false;
    		_labelCache.remove = false;
        }
        else if (labelPosition=="outside")
            renderRadialLabels(renderData,renderCache);
        else if (labelPosition=="inside" || labelPosition=="insideWithCallout")
            renderInternalLabels(renderData,renderCache);
        else if (labelPosition=="callout")
            renderCalloutLabels(renderData);
        else{
           	_labelCache.discard = true;
    		_labelCache.remove = true;
            _labelCache.count = 0;
            _labelCache.discard = false;
    		_labelCache.remove = false;
        }




        // OK, draw away
        var fills:Array /* of IFill */ = getStyle("fills");
        var fillCount:int = fills.length;
        var inst:IFlexDisplayObject;
        var instances:Array /* of IFlexDisplayObject */;
        
		_instanceCache.factory = getStyle("itemRenderer");
        _instanceCache.count = n;
        instances = _instanceCache.instances;
		
        for (i = 0; i < n; i++)
        {
            item = renderCache[i];
            inst = instances[i];
            item.fill = fillFunction(item,i);
            if (!(item.fill))
            	item.fill = defaultFillFunction(item,i);           
            inst.setActualSize(unscaledWidth,unscaledHeight);
            item.itemRenderer = inst;
            (inst as IDataRenderer).data = item;
            if ((item.itemRenderer as Object).hasOwnProperty('invalidateDisplayList'))
            	(item.itemRenderer as Object).invalidateDisplayList();
        }
        if (allSeriesTransform && chart && chart.chartState == 0)
        	chart.updateAllDataTips();

    }

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);

        if (styleProp == null || styleProp == "" || styleProp == "fills")
        {
            invalidateDisplayList();
            legendDataChanged();
        }
        if (styleProp == "labelPosition")
        {
            invalidateTransform();
        }
        if (styleProp == "renderDirection")
        {
            invalidateTransform();
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
    override public function getAllDataPoints():Array /* of HitData */
    {
    	if (!_renderData)
    		return [];
    	if (!(_renderData.filteredCache))
    		return [];
    	if (_renderData.filteredCache.length == 0)
    		return[];
    	var itemArr:Array /* of PieSeriesItem */ = [];
    	if (chart && chart.dataTipItemsSet && dataTipItems)
    		itemArr = dataTipItems;
    	else if (chart && chart.showAllDataTips && _renderData.filteredCache)
    		itemArr = _renderData.filteredCache;
    	else
    		itemArr = [];
    	
    	var n:uint = itemArr.length;
    	var i:uint;
    	var inr:Number= _innerRadiusInPixelsScaledForExplode;
    	var startAngle:Number;
    	var angleAdjustment:Number;
        var renderDirection:String = getStyle('renderDirection');
        if(renderDirection == "clockwise")
        	angleAdjustment = _renderData.filteredCache[n - 1].startAngle;
        else
        	angleAdjustment = _renderData.filteredCache[0].startAngle;
    	var result:Array /* of HitData */ = [];
    	
    	for (i = 0; i < n; i++)
        {
            var v:PieSeriesItem = itemArr[i];
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
            	startAngle = v.startAngle - angleAdjustment;

            	var a:Number;
            	if(renderDirection == "clockwise")
            		a  = startAngle + (2*Math.PI)-_startAngleRadians + v.angle/2;
            	else
            		a  = startAngle + _startAngleRadians + v.angle/2;
            	var xpos:Number = v.origin.x + Math.cos(a)*(inr + (_radiusInPixelsScaledForExplode-inr)*.5);
            	var ypos:Number = v.origin.y - Math.sin(a)*(inr + (_radiusInPixelsScaledForExplode-inr)*.5);;
            	var hd:HitData = new HitData(createDataID(v.index),0,xpos,ypos,v);
            	hd.dataTipFunction = formatDataTip;
            	var fills:Array /* of IFill */ = getStyle("fills");
            	if (fills)
            	{
                	// can't be strongly typed since it could be a raw string.
                	var fill:Object = PieSeriesItem(hd.chartItem).fill;
                	hd.contextColor = GraphicsUtilities.colorFromFill(fill);
            	}
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

        var dataTransform:PolarTransform = PolarTransform(dataTransform);
        var n:int = _renderData.filteredCache.length;
        var o:Point = dataTransform.origin;
        var hitItem:PieSeriesItem;
        var msPt:Point = new Point(x,y);
        var innerRadius:Number = getStyle("innerRadius");
        var inr:Number= _innerRadiusInPixelsScaledForExplode;
        var mp2:Number = Math.PI*2;

        if (n == 0)
            return [];

        var angle:Number = calcAngle(msPt.x - _origin.x,msPt.y - _origin.y);

        var angleAdjustment:Number;
        var renderDirection:String = getStyle('renderDirection');
        if(renderDirection == "clockwise")
        	angleAdjustment = _renderData.filteredCache[n - 1].startAngle;
        else
        	angleAdjustment = _renderData.filteredCache[0].startAngle;
       
        angle -= angleAdjustment;
        if (angle < 0)
            angle += mp2;

        var startAngle:Number;

        for (var i:int = 0; i < n; i++)
        {
            var v:PieSeriesItem = _renderData.filteredCache[i];

            angle = calcAngle(msPt.x - v.origin.x, msPt.y - v.origin.y);
            angle -= angleAdjustment;
            if (angle < 0)
                angle += mp2;
            if(renderDirection == "clockwise")
            {
				while(angle > mp2)
					angle = angle - mp2;
			}
            startAngle = v.startAngle - angleAdjustment;
            if (angle >= startAngle && angle < startAngle + v.angle)
            {
                hitItem = v;
                break;
            }
        }
        if (hitItem)
        {

            var dst2:Number = (x - hitItem.origin.x)*(x-hitItem.origin.x) + (y-hitItem.origin.y)*(y-hitItem.origin.y);
            var s2:Number = sensitivity * sensitivity;

            if (dst2 < inr*inr - s2 || dst2 > _radiusInPixelsScaledForExplode*_radiusInPixelsScaledForExplode + s2)
            {
                return [];
            }

            var a:Number;
            if(renderDirection == "clockwise")
            	a  = startAngle + (2*Math.PI)-_startAngleRadians + hitItem.angle/2;
            else
            	a  = startAngle + _startAngleRadians + hitItem.angle/2;
            var xpos:Number = hitItem.origin.x + Math.cos(a)*(inr + (_radiusInPixelsScaledForExplode-inr)*.5);
            var ypos:Number = hitItem.origin.y - Math.sin(a)*(inr + (_radiusInPixelsScaledForExplode-inr)*.5);;
            var hd:HitData = new HitData(createDataID(hitItem.index),0,xpos,ypos,hitItem);
            hd.dataTipFunction = formatDataTip;
            var fills:Array /* of IFill */ = getStyle("fills");
            if (fills)
            {
                // can't be strongly typed since it could be a raw string.
                var fill:Object = PieSeriesItem(hd.chartItem).fill;
                hd.contextColor = GraphicsUtilities.colorFromFill(fill);
            }
            return [hd];
        }
        return [];
    }
    
   /**
     *  @inheritDoc 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function dataToLocal(...dataValues):Point
    {
        var data:Object = {};
        
        var da:Array /* of Object */ = [ data ];
        
        var n:int = dataValues.length;
        
        var dataTransform:PolarTransform = PolarTransform(dataTransform);
        
        if (n > 0)
        {
            data["d0"] = dataValues[0];
            
            dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).
                mapCache(da, "d0", "v0");
        }
        
        if (n > 1)
        {
            data["d1"] = dataValues[1];
            
            dataTransform.getAxis(PolarTransform.RADIAL_AXIS).
                mapCache(da, "d1", "v1");           
        }
        
        dataTransform.transformCache(da, "v0", "s0", "v1", "s1");
        
        return new Point(dataTransform.origin.x +
                         Math.cos(data.s0) * data.s1,
                         dataTransform.origin.y -
                         Math.sin(data.s0) * data.s1);
    }
    
    /**
     *  @inheritDoc 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function localToData(v:Point):Array /* of Object */
    {
     	var dataTransform:PolarTransform = PolarTransform(dataTransform);
     	
        var dx:Number = v.x - dataTransform.origin.x;
        var dy:Number = v.y - dataTransform.origin.y;
        
        var a:Number = calcAngle(dx,dy);
        
        var r:Number = Math.sqrt(dx * dx + dy * dy);        
        
        var values:Array /* of Object */ = dataTransform.invertTransform(a, r);
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
        _renderData= new renderDataType();

        _renderData.cache = [];

        if (dataProvider)
        {
            cursor.seek(CursorBookmark.FIRST);
            var i:int = 0;
            var itemClass:Class = itemType;
            while (!cursor.afterLast)
            {
                _renderData.cache[i]=new itemClass(this,cursor.current,i);
                i++;
                cursor.moveNext();
            }

            cacheDefaultValues(_field,_renderData.cache,"value");
        }

        super.updateData();
    }

    /**
     *  @private
     */
    override protected function updateMapping():void
    {

        dataTransform.getAxis(PolarTransform.ANGULAR_AXIS).mapCache(_renderData.cache,"value","number");

        var total:Number = 0;
        var n:int = _renderData.cache.length;
        var i:int;

        for (i = 0; i < n; i++)
        {
            var v:Number= _renderData.cache[i].number;
            if (!isNaN(v))
                total += _renderData.cache[i].number;
        }
        _renderData.itemSum = total;
        total /= 100;
        
        // avoid dividing by zero.  If total is 0, we're not going to be rendering anything anyway.
        // avoiding a divide by zero means we'll still end up with valid calculations, in case
        // we need to animate from or to these values.
        if (total == 0)
            total = 1;
        
        for (i = 0; i < n; i++)
        {
            _renderData.cache[i].percentValue = _renderData.cache[i].number/total;
        }

        super.updateMapping();
    }

    /**
     *  @private
     */
    override protected function updateFilter():void
    {
        _renderData.filteredCache = filterFunction(_renderData.cache);
        legendDataChanged();

        super.updateFilter();
    }

    /**
     *  @private
     */
    override protected function updateTransform():void
    {
        var dataTransform:PolarTransform = PolarTransform(dataTransform);

        dataTransform.transformCache(_renderData.filteredCache,"percentValue","angle",null,null);
        var sampleCount:int = _renderData.filteredCache.length;
        var lastItem:PieSeriesItem;
        var thisItem:PieSeriesItem;
        var i:int;

        if (sampleCount)
        {
            lastItem = _renderData.filteredCache[0];

            lastItem.startAngle = _startAngleRadians;
            for (i = 1; i < sampleCount; i++)
            {
                thisItem = _renderData.filteredCache[i];
                thisItem.startAngle = lastItem.startAngle + lastItem.angle;
                lastItem = thisItem;
            }
        }

        var renderData:PieSeriesRenderData = _renderData;

        var assignRadiusToAllItems:Boolean = true;
        var assignOriginToAllItems:Boolean = true;

        if (!renderData || !(renderData.filteredCache))
            return;
        var renderCache:Array /* of PieSeriesItem */ = renderData.filteredCache;

        //clean up before we start

        var n:int = renderCache.length;

        if (n == 0)
        {
            _labelCache.discard = true;
    		_labelCache.remove = true;
            _labelCache.count = 0;
            _labelCache.discard = false;
    		_labelCache.remove = false;
            return;
        }

        _origin = dataTransform.origin;

        var labelData:Object;

        // we're about to go through and calculate placement for our labels. That will determine how much we need to scale
        // our radius by. We'll start by being optomistic, and assuming that we need to scale everything by only whatever the preset values are.
        _radiusInPixelsAfterLabels = dataTransform.radius - DROP_SHADOW_SIZE;


        // if someone has asked to have any of our wedges exploded, we'll have to calculate their origin offsets so they get/
        // rendered in the correct place. We'll also have to check to see if we need to scale down the radius as a result. Remember
        // that at this point, all of our wedges are as big as they can be and still fit inside the labels. So by definition, if we want
        // one of them to stick out past the others, it will be sticking into the labels. To make up for this, we instead scale down all the
        // wedges as much as we need to to make sure that the wedges sticking out just reach the edge.
        if (_perWedgeExplodeRadius && _perWedgeExplodeRadius.length > 0)
        {
            // determine per-wedge offsets

            var er:Number=_explodeRadius;
            if (isNaN(er))
                er = 0;
            _maxExplodeRadiusRatio = er;


            // This code always reduces the radius to match the maximum explode size.
            // However, if that maximum explode size is on an angle at 45 degrees,
            // it might not extend past the bounds using the current radius.
            // Or, it might extend vertically, but there may be room to spare vertically.
            // So we should really track maximum width/height of the bounds of all wedges,
            // and adjust the outer radius appropriately.

            for (i = 0; i < n; i++)
            {
                var pwer:Number = (_perWedgeExplodeRadius[i] != null)? (parseFloat(_perWedgeExplodeRadius[i])):0;
                if (isNaN(pwer))
                    pwer = 0;
                _maxExplodeRadiusRatio = Math.max(_maxExplodeRadiusRatio,er + pwer);
            }
        }
        else if (!isNaN(_explodeRadius) && _explodeRadius != 0)
        {
            _maxExplodeRadiusRatio = _explodeRadius;
        }
        else
        {
            // no exploding wedges
            _maxExplodeRadiusRatio = 0;
        }
        _maxExplodeRadiusRatio = Math.max(_maxExplodeRadiusRatio,_reserveExplodeRadius);



        _renderData.labelScale = 1;

        var labelPosition:String = getStyle("labelPosition");

        // now we caluclate label positioning. There's a couple of special cases we needt ohandle first. FIrst of all, we
        // know the player can't handle fonts scaled to below two pts.  so if our scale would make our labels smaller than 2 pts, we just won't
        // show the pts.

        var r1:Point = new Point(0,0);
        var r2:Point = new Point(1,1);
        r1 = localToGlobal(r1);
        r2 = localToGlobal(r2);

        // the flash player screws up display of device fonts at very small point sizes...it blows out to large sizes instead. So if it looks
        // like fonts will be displayed at a tiny point size, just don't show them at all.
        var actualScale:Number;
        /*
		if(chart && chart.layoutDirection == LayoutDirection.RTL)
			actualScale = r1.x - r2.x;
		else */
			actualScale = r2.x - r1.x;
        if (getStyle("fontSize")*actualScale < 2)
            labelPosition = "none";
        
    
        // secondly, if our inner radius is larger than our outer radius, we should be completely invisible, so we'll just hide the labels.
        if (getStyle("innerRadius") >= _outerRadius)
        {
            _renderData.labelData = null;
            _labelCache.discard = true;
    		_labelCache.remove = true;
            _labelCache.count = 0;
            _labelCache.discard = false;
    		_labelCache.remove = false;
        }
        else if (labelPosition=="outside")
            _renderData.labelData = measureRadialLabels(renderCache);
        else if (labelPosition=="callout")
            _renderData.labelData = measureCalloutLabels(renderCache);
        else if (labelPosition=="inside")
            _renderData.labelData = measureInternalLabels(false,renderCache);
        else if (labelPosition=="insideWithCallout")
            _renderData.labelData = measureInternalLabels(true,renderCache);
        else
        {
            _renderData.labelData = null;
            _labelCache.discard = true;
    		_labelCache.remove = true;
            _labelCache.count = 0;
            _labelCache.discard = false;
    		_labelCache.remove = false;
        }

        // OK, at this point, we've calculated our actual label placement, and thus can calculate our actual
        // radius' (radii?).  The outer radius is whatever outerradius is provided by our enclosing chart, scaled as appropriate to
        // make room for the labels.
        // the inner radius, on the other hand, is the value specified by the devloper (through styles) scaled as appropriate to
        // make room for the labels.
        var innerRadius:Number = getStyle("innerRadius");
        var item:PieSeriesItem;

        _innerRadiusInPixels = _radiusInPixelsAfterLabels*innerRadius;
        _radiusInPixelsAfterLabels = _radiusInPixelsAfterLabels*_outerRadius;
        // ok, we know how much we need to reduce the radius by. let's do it.
        _radiusInPixelsScaledForExplode = _radiusInPixelsAfterLabels*(1-_maxExplodeRadiusRatio);
        _innerRadiusInPixelsScaledForExplode = _innerRadiusInPixels*(1-_maxExplodeRadiusRatio);

        var renderDirection:String = getStyle('renderDirection');
        // if someone has asked to have any of our wedges exploded, we'll have to calculate their origin offsets so they get/
        // rendered in the correct place. We'll also have to check to see if we need to scale down the radius as a result. Remember
        // that at this point, all of our wedges are as big as they can be and still fit inside the labels. So by definition, if we want
        // one of them to stick out past the others, it will be sticking into the labels. To make up for this, we instead scale down all the
        // wedges as much as we need to to make sure that the wedges sticking out just reach the edge.
        if ((_perWedgeExplodeRadius && _perWedgeExplodeRadius.length > 0) || _explodeRadius != 0)
        {
            assignOriginToAllItems= false;

            // determine per-wedge offsets

            var sa:Number = startAngle;


            // This code always reduces the radius to match the maximum explode size.
            // However, if that maximum explode size is on an angle at 45 degrees,
            // it might not extend past the bounds using the current radius.
            // Or, it might extend vertically, but there may be room to spare vertically.
            // So we should really track maximum width/height of the bounds of all wedges,
            // and adjust the outer radius appropriately.

            for (i = 0; i < n; i++)
            {
                var wedgeExplodeRadius:Number = calculateExplodeRadiusForWedge(i);

                item = renderCache[i];
                if (!isNaN(item.startAngle))
                    sa = item.startAngle;
                var wedgeAngle:Number = renderCache[i].angle;

                var angle:Number;
                if(renderDirection == 'clockwise')
                	angle = (2*Math.PI)-(wedgeAngle/2 + sa);
                else
                	angle = wedgeAngle/2 + sa;

                item.origin = new Point(_origin.x + Math.cos(angle)*wedgeExplodeRadius,_origin.y + -Math.sin(angle)*wedgeExplodeRadius);

                sa += wedgeAngle;
            }
        }

        if (assignOriginToAllItems || assignRadiusToAllItems)
        {
            for (i = 0; i< sampleCount; i++)
            {
                item = renderCache[i];
                if (assignOriginToAllItems)
                    item.origin = _origin;

                if (assignRadiusToAllItems)
                {
                    item.innerRadius = _innerRadiusInPixelsScaledForExplode;
                    item.outerRadius = _radiusInPixelsScaledForExplode;
                }
            }
        }
        
        if(renderDirection == "clockwise")
        {
			if (sampleCount)
        	{
           		for (i = 0; i < sampleCount; i++)
            	{
                	item = _renderData.filteredCache[i];
                	item.startAngle = 2*Math.PI - (item.startAngle + item.angle);
            	}
        	}
        }
        super.updateTransform();
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
        var rb :Array /* of Rectangle */ = [];
        var cache:Array /* of PieSeriesItem */ = renderData.filteredCache;
        var sampleCount:int = cache.length;
        var sample:PieSeriesItem;

        var minAngle:Number = Number.MAX_VALUE;
        var maxAngle:Number = Number.MIN_VALUE;
        for (var i:int = 0; i < sampleCount; i++)
        {
            sample = cache[i];
            rb.push(new Rectangle(sample.startAngle,sample.innerRadius,sample.angle,sample.outerRadius - sample.innerRadius));
            maxAngle = Math.max(maxAngle,sample.startAngle + sample.angle);
            minAngle = Math.min(minAngle,sample.startAngle);
        }


        sample  = cache[sampleCount-1];
        renderData.elementBounds = rb;
        renderData.bounds =     new Rectangle(minAngle,_innerRadiusInPixelsScaledForExplode,maxAngle - minAngle,_radiusInPixelsScaledForExplode - _innerRadiusInPixelsScaledForExplode);
        renderData.visibleRegion =  new Rectangle(minAngle,_innerRadiusInPixelsScaledForExplode,maxAngle - minAngle,_radiusInPixelsScaledForExplode - _innerRadiusInPixelsScaledForExplode);
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
            sourceRenderData.filteredCache, destRenderData.filteredCache,
            { angle: true, startAngle: true,
              innerRadius: true, outerRadius: true }, itemType,
            { lastInvalidSrcValue: 0, lastInvalidSrcIndex: NaN,
              lastInvalidDestValue: 0, lastInvalidDestIndex: NaN });

        var origin:Point = PolarTransform(dataTransform).origin;
        
        var srcCache:Array /* of PieSeriesItem */ = sourceRenderData.filteredCache;
        var dstCache:Array /* of PieSeriesItem */ = destRenderData.filteredCache;
        
        var n:int = Math.max(srcCache.length,dstCache.length);
        var shortLen:int = Math.min(srcCache.length,dstCache.length);
        
        var srcItem:PieSeriesItem;
        var dstItem:PieSeriesItem;

        for (var i:int = 0; i < shortLen; i++)
        {
            dstItem = dstCache[i];
            srcItem = srcCache[i];
            idata.interpolationSource[i].origin = srcItem.origin;
            idata.deltaCache[i].origin = new Point(dstItem.origin.x - srcItem.origin.x,
                                                   dstItem.origin.y - srcItem.origin.y);
            idata.cache[i].origin = srcItem.origin.clone();
        }

        if (shortLen < srcCache.length)
        {
            // src is longer than dest
            for (i = shortLen; i < n; i++)
            {
                srcItem = srcCache[i];
                idata.interpolationSource[i].origin = srcItem.origin;
                idata.deltaCache[i].origin = new Point(origin.x - srcItem.origin.x,
                                                       origin.y - srcItem.origin.y);
                idata.cache[i].origin = srcItem.origin.clone();
            }
        }
        else
        {
            // dest is longer than src
            for (i = shortLen; i < n; i++)
            {
                dstItem = dstCache[i];
                idata.interpolationSource[i].origin = origin;
                idata.deltaCache[i].origin = new Point(dstItem.origin.x - origin.x,
                                                       dstItem.origin.y - origin.y);
                idata.cache[i].origin = origin.clone();
            }
        }
        var interpolationRenderData:Object = destRenderData.clone();

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
    override public function interpolate(interpolationValues:Array /* of Number */,interpolationData:Object):void
    {
        super.interpolate(interpolationValues,interpolationData);

        var n:int = interpolationValues.length;
        var srcCache:Array /* of PieSeriesItem */ = interpolationData.interpolationSource;
        var deltaCache:Array /* of PieSeriesItem */ = interpolationData.deltaCache;
        var interpolationCache:Array /* of PieSeriesItem */ = interpolationData.cache;
        var iProps:Object = interpolationData.properties;

        n = interpolationCache.length;


        for (var i:int = 0; i < n; i++)
        {
            var interpValue:Number=interpolationValues[i];
            var src:PieSeriesItem = srcCache[i];
            var delta:PieSeriesItem = deltaCache[i];
            var interp:PieSeriesItem = interpolationCache[i];

            interp.origin.x = src.origin.x + delta.origin.x * interpValue;
            interp.origin.y = src.origin.y + delta.origin.y * interpValue;
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
    override protected function getMissingInterpolationValues(sourceProps:Object,
    									srcCache:Array /* of PieSeriesItem */,destProps:Object,
    									destCache:Array /* of PieSeriesItem */,
    									index:Number,customData:Object):void
    {
        for (var p:String in sourceProps)
        {
            var src:Number = sourceProps[p];
            var dst:Number = destProps[p];
            var i:int;
			var n:int;
			
            if (p == "startAngle")
            {
                if (isNaN(src))
                {
                    if (customData.lastInvalidSrcIndex != index-1)
                    {
                        if (index == 0)
                        {
                        	n  = srcCache.length;
                            for (i = 0; i < n; i++)
                            {
                                if (srcCache[i] != null && !isNaN(srcCache[i].startAngle))
                                {
                                    customData.lastInvalidSrcValue = srcCache[i].startAngle + srcCache[i].angle;
                                    break;
                                }
                            }
                        }
                        else
                        {
                            for (i = index - 1; i >= 0; i--)
                            {
                                if (srcCache[i] != null && !isNaN(srcCache[i].startAngle))
                                {
                                    customData.lastInvalidSrcValue = srcCache[i].startAngle + srcCache[i].angle;
                                    break;
                                }
                            }
                        }
                    }

                    src = customData.lastInvalidSrcValue;
                    customData.lastInvalidSrcIndex = index;
                }

                if (isNaN(dst))
                {
                    if (customData.lastInvalidDestIndex != index-1)
                    {
                        if (index == 0)
                        {
                        	n = destCache.length;
                            for (i = 0; i < n; i++)
                            {
                                if (destCache[i] != null && !isNaN(destCache[i].startAngle))
                                {
                                    customData.lastInvalidDestValue = destCache[i].startAngle + destCache[i].angle;
                                    break;
                                }
                            }
                        }
                        else
                        {
                            for (i = index - 1; i >= 0; i--)
                            {
                                if (destCache[i] != null && !isNaN(destCache[i].startAngle))
                                {
                                    customData.lastInvalidDestValue = destCache[i].startAngle + destCache[i].angle;
                                    break;
                                }
                            }
                        }
                    }
                    dst = customData.lastInvalidDestValue;
                    customData.lastInvalidDestIndex = index;
                }
            }
            else if (p == "angle")
            {
                if (isNaN(src))
                    src = 0;
                if (isNaN(dst))
                    dst = 0;
            }
            else if (p == "innerRadius")
            {
                if (isNaN(src))
                {
                    src = _innerRadiusInPixelsScaledForExplode;
                }
                if (isNaN(dst))
                {
                    dst = _innerRadiusInPixelsScaledForExplode;
                }
            }
            else if (p == "outerRadius")
            {
                if (isNaN(src))
                {
                    src = _radiusInPixelsScaledForExplode;
                }
                if (isNaN(dst))
                {
                    dst = _radiusInPixelsScaledForExplode;
                }
            }
            else
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
     *  @private
     */
    override public function getItemsInRegion(r:Rectangle):Array /* of PieSeriesItem */
    {
        // esg, 8/7/06: if your mouse is over a series when it gets added and displayed for the first time, this can get called
        // before updateData, and before and render data is constructed. The right long term fix is to make sure a stubbed out 
        // render data is _always_ present, but that's a little disruptive right now.
        if (interactive == false || !_renderData)
            return [];
        
        var arrItems:Array /* of PieSeriesItem */ = [];    
        var localRectangle:Rectangle = new Rectangle();
        var n:uint = _renderData.filteredCache.length;
        var inr:Number= _innerRadiusInPixelsScaledForExplode;
        
        localRectangle.topLeft = globalToLocal(r.topLeft);
        localRectangle.bottomRight = globalToLocal(r.bottomRight);
        var angleAdjustment:Number;
        var renderDirection:String = getStyle('renderDirection');
        if(renderDirection == "clockwise")
        	angleAdjustment = _renderData.filteredCache[n - 1].startAngle;
        else
        	angleAdjustment = _renderData.filteredCache[0].startAngle;
        for (var i:int = 0; i < n; i++)
        {
            var v:PieSeriesItem = _renderData.filteredCache[i];
            var startAngle:Number = v.startAngle - angleAdjustment;
            var a:Number;
             if(renderDirection == "clockwise")
             	a  = startAngle + (2*Math.PI)-_startAngleRadians + v.angle/2;
             else
             	a  = startAngle + _startAngleRadians + v.angle/2;
            var xpos:Number = v.origin.x + Math.cos(a)*(inr + (_radiusInPixelsScaledForExplode-inr)*.5);
            var ypos:Number = v.origin.y - Math.sin(a)*(inr + (_radiusInPixelsScaledForExplode-inr)*.5);;
            
            if (localRectangle.contains(xpos,ypos))
                arrItems.push(v);
        }
        return arrItems;
    }

    /**
     *  @private
     */
    override public function describeData(dimension:String,
                                          requiredFields:uint):Array /* of DataDescription */
    {
        validateData();

        if (dimension == PolarTransform.ANGULAR_AXIS)
        {
            var description:DataDescription = new DataDescription();
            description.boundedValues = null;
            description.min = 0;
            description.max = 100;
            return [ description ];
        }
        
        return [];
    }
    
     
    /**
     * @private
     */ 
    override protected function defaultFilterFunction(cache:Array /*of PieSeriesItem */ ):Array /*of PieSeriesItem*/
    {
    	var filteredCache:Array /*of PieSeriesItem*/ = [];	
    	if (filterDataValues == "outsideRange" || filterDataValues == "nulls")
        {
            filteredCache = cache.concat();
            stripNaNs(filteredCache,"number");
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
     *  @private
     */
    private function defaultFillFunction(element:PieSeriesItem,i:Number):IFill
    {
        _localFills = getStyle("fills");
        _fillCount = _localFills.length; 
        return(GraphicsUtilities.fillFromStyle(_localFills[i % _fillCount]));
    }

    /**
     *  @private
     */
    private function calculateExplodeRadiusForWedge(i:int):Number
    {
        var pwer:Number = (_perWedgeExplodeRadius && _perWedgeExplodeRadius[i] != null)? (parseFloat(_perWedgeExplodeRadius[i])):0;
        if (isNaN(pwer))
            pwer = 0;
        return (((isNaN(_explodeRadius))?0:_explodeRadius)+pwer) * _radiusInPixelsAfterLabels;
    }

    /**
     *  @private
     */
    private function measureCalloutLabels(renderCache:Array /* of PieSeriesItem */):Object //type return value
    {
        var n:int = renderCache.length;

        var baseAngle:Number = _startAngleRadians;

        for (var i:int = 0; i < n; i++)
        {
            var v:PieSeriesItem = renderCache[i];

            //type
            if (_labelFunction != null)
                _measuringField.text = v.labelText = _labelFunction(v.item,_field,i,v.percentValue);
            else if (_labelField)
                _measuringField.text = v.labelText = v.item[_labelField];
            else
                _measuringField.text = v.labelText = v.value.toString();

            var renderDirection:String = getStyle('renderDirection');
        	if(renderDirection == "clockwise")
        		v.labelAngle = (2*Math.PI - (baseAngle + v.angle/2))%(2*Math.PI);
        	else
        		v.labelAngle = (baseAngle + v.angle/2)%(2*Math.PI);
            v.labelCos = Math.cos(v.labelAngle);
            v.labelSin = -Math.sin(v.labelAngle);
            v.labelWidth = _measuringField.width;
            v.labelHeight = _measuringField.height;
            baseAngle += v.angle;
        }

        return auxMeasureCalloutLabels(_renderData,renderCache);
    }

    /**
     *  @private
     */
    private function auxMeasureCalloutLabels(renderData:PieSeriesRenderData,labelSet:Array /* of PieSeriesItem */):Object //type return value
    {
        var dataTransform:PolarTransform = PolarTransform(dataTransform);
        var n:int = labelSet.length;
        var rc:Rectangle= new Rectangle(0,0,unscaledWidth,unscaledHeight);

        var baseRadius:Number = dataTransform.radius*_outerRadius;

        var baseAngle:Number = _startAngleRadians;

        var leftStack:Array /* of PieSeriesItem */ = [];
        var rightStack:Array /* of PieSeriesItem */ = [];
        var leftHeight:Number = 0;
        var rightHeight:Number = 0;
        var i:int;
        var ly:Number;
        var labelScale:Number =  renderData.labelScale;

        //type
        var ld:PieSeriesItem;

        var lastTop:Number;

        var calloutGap:Number = getStyle("calloutGap");
        for (i = 0; i < n; i++)
        {

            //type
            ld = labelSet[i];
            if (((ld.labelAngle+Math.PI/2) % (2*Math.PI)) < Math.PI)
            {
                //right half
                if (ld.labelAngle > Math.PI)
                    ld.labelAngle -= 2*Math.PI

                ld.labelX = 0;
                baseRadius = Math.min(baseRadius,rc.right - ld.labelWidth - _origin.x - calloutGap);
                rightStack.push(ld);
                rightHeight += ld.labelHeight;

            }
            else
            {
                //left half
                ld.labelX = - ld.labelWidth;
                baseRadius = Math.min(baseRadius,_origin.x  - ld.labelWidth - calloutGap);
                leftStack.push(ld);
                leftHeight += ld.labelHeight;
            }

            ly = -ld.labelHeight/2 + _origin.y + ld.labelSin*baseRadius*1.1;
            if (ly < rc.top)
            {
                baseRadius = (rc.top + ld.labelHeight/2 - _origin.y)/(ld.labelSin*1.1);
            }
            if (ly > rc.bottom - ld.labelHeight)
            {
                baseRadius = (rc.bottom - ld.labelHeight+ ld.labelHeight/2 - _origin.y)/(ld.labelSin*1.1);
            }

        }


        leftStack.sortOn("labelAngle",Array.NUMERIC);
        rightStack.sortOn("labelAngle",Array.NUMERIC | Array.DESCENDING);

        if (leftHeight > rc.height)
            labelScale = Math.min(labelScale,rc.height / leftHeight);

        if (rightHeight > rc.height)
            labelScale = Math.min(labelScale,rc.height / rightHeight);

        if ((baseRadius) < (1-maxLabelRadius)*(dataTransform.radius*_outerRadius))
        {
            // we've scaled down too much. Let's adjust backwards.
            var oldTextSize:Number = dataTransform.radius*_outerRadius - baseRadius - calloutGap;
            baseRadius = (1-maxLabelRadius)*(dataTransform.radius*_outerRadius);
            labelScale = Math.min(labelScale,(dataTransform.radius*_outerRadius - baseRadius - calloutGap)/oldTextSize);
        }
        //now, convert our baseRadius base to a scaled down fullRadius
        _radiusInPixelsAfterLabels = baseRadius/_outerRadius;

        var leftEdge:Number = _origin.x - baseRadius - calloutGap;
        var lastBottom:Number = 0;
        
        n = leftStack.length;
        for (i = 0; i < n; i++)
        {
            //type
            ld = leftStack[i];

            ld.labelX = leftEdge + ld.labelX*labelScale;
            ly = -ld.labelHeight/2 + _origin.y + ld.labelSin*baseRadius*1.1;
            if (ly < lastBottom)
                ly = lastBottom;
            ld.labelY = ly;
            lastBottom = ly + ld.labelHeight;
        }
        if (lastBottom > rc.bottom)
        {
            lastTop = rc.bottom;
            for (i = n - 1; i >= 0; i--)
            {
                ld = leftStack[i];
                if (ld.labelY + ld.labelHeight <= lastTop)
                {
                    break;
                }
                ld.labelY = lastTop - ld.labelHeight;
                lastTop = ld.labelY;
            }
        }


        var rightEdge:Number = _origin.x + baseRadius + calloutGap;
        lastBottom = 0;

		n = rightStack.length;
        for (i = 0; i < n; i++)
        {
            ld = rightStack[i];


            ld.labelX = rightEdge;
            ly = -ld.labelHeight/2 + _origin.y + ld.labelSin*baseRadius*1.1;
            if (ly < lastBottom)
                ly = lastBottom;
            ld.labelY = ly;
            lastBottom = ly + ld.labelHeight;
        }
        if (lastBottom > rc.bottom)
        {
            lastTop = rc.bottom;
            for (i = n - 1; i >= 0; i--)
            {
                ld = rightStack[i];

                if (ld.labelY + ld.labelHeight <= lastTop)
                {
                    break;
                }
                ld.labelY = lastTop - ld.labelHeight;
                lastTop = ld.labelY;
            }
        }

        renderData.labelScale = labelScale;
        return { leftStack: leftStack, rightStack: rightStack };
    }

    /**
     *  @private
     */
    private function renderCalloutLabels(renderData:PieSeriesRenderData):void
    {
    	_labelCache.discard = true;
    	_labelCache.remove = true;
    	_labelCache.count = 0;
    	_labelCache.discard = false;
    	_labelCache.remove = false;
        var labelData:Object = renderData.labelData;
        if (!labelData)
            return;
        _labelCache.count = labelData.leftStack.length + labelData.rightStack.length;
        auxRenderCalloutLabels(renderData,renderData.labelData,0);
    }

    /**
     *  @private
     */
    private function auxRenderCalloutLabels(renderData:PieSeriesRenderData,labelData:Object,firstLabelIndex:Number):void
    {
        var dataTransform:PolarTransform = PolarTransform(dataTransform);
        var rc:Rectangle = new Rectangle(0, 0, unscaledWidth, unscaledHeight);
        var leftStack:Array /* of PieSeriesItem */ = labelData.leftStack;
        var rightStack:Array /* of PieSeriesItem */ = labelData.rightStack;

        var g:Graphics = _labelLayer.graphics;
        var labels:Array /* of IUITextField */ = _labelCache.instances;

        var inr:Number= _innerRadiusInPixelsScaledForExplode;
            var startRad:Number = inr + (_radiusInPixelsScaledForExplode-inr)*.8;

        var calloutStroke:IStroke = getStyle("calloutStroke");



        if (calloutStroke)
        {
            GraphicsUtilities.setLineStyle(g,calloutStroke);
        }

        var calloutGap:Number = getStyle("calloutGap");
        var i:int;
        var n:int;
        //type
        var ld:PieSeriesItem;
        var label:IUITextField;
        var endRad:Number;
        var labelScale:Number = renderData.labelScale;

        var leftEdge:Number = _origin.x - _radiusInPixelsAfterLabels - calloutGap;
        
        n = leftStack.length;
        for (i = 0;i < n; i++)
        {
            ld = leftStack[i];
            if (ld.percentValue == 0)
            	continue;
            var o:Point = ld.origin;


            label = ld.label = labels[firstLabelIndex++];
			label.scaleX = label.scaleY = labelScale;
            label.x = ld.labelX;
            label.y = ld.labelY;
            label.text = ld.labelText;
            

            endRad = (ld.labelSin == 0)? leftEdge:((label.y + label.height/2 - o.y)/ld.labelSin);

            if (endRad >= startRad)
            {
                if (o.y + ld.labelSin * endRad > rc.top)
            	{
            		g.moveTo(o.x + ld.labelCos*startRad,o.y + ld.labelSin*startRad);
                	if (o.x + ld.labelCos*endRad > leftEdge)
                	{
                    	g.lineTo(o.x + ld.labelCos*endRad,o.y + ld.labelSin*endRad);
                	}
                	else
                	{
                    	g.lineTo(o.x + ld.labelCos*_radiusInPixelsScaledForExplode,o.y + ld.labelSin*_radiusInPixelsScaledForExplode);
                	}
                	g.lineTo(leftEdge,o.y + ld.labelSin*endRad);
             	}
            }
            else if (endRad > _radiusInPixelsScaledForExplode*.2)
            {
                if (o.y + ld.labelSin * endRad > rc.top)
            	{
            		g.moveTo(o.x + ld.labelCos*endRad,o.y + ld.labelSin*endRad);
                	g.lineTo(leftEdge,o.y + ld.labelSin*endRad);
             	}
            }	
            else
            {
            	if (o.y + ld.labelSin * endRad > rc.top)
            	{
                	g.moveTo(o.x + ld.labelCos*_radiusInPixelsScaledForExplode*.2,o.y + ld.labelSin*_radiusInPixelsScaledForExplode*.2);
                	g.lineTo(leftEdge,o.y + ld.labelSin*endRad);
             	}
            }
        }
        var rightEdge:Number = _origin.x + _radiusInPixelsAfterLabels + calloutGap;
        
        n = rightStack.length;
        for (i = 0; i < n; i++)
        {
            ld = rightStack[i];
			if (ld.percentValue == 0)
				continue;
            o = ld.origin;


            label = ld.label = labels[firstLabelIndex++];
			label.scaleX = label.scaleY = labelScale;
            label.x = ld.labelX;
            label.y = ld.labelY;
            label.text = ld.labelText;
            

            endRad = (label.y + label.height/2 - o.y)/ld.labelSin;

            if (endRad == Infinity || endRad == -Infinity || isNaN(endRad))
            {
                // valid case: when ld.labelSin == 0, which occurs when the label's angle == 0
                if (o.y + ld.labelSin * endRad > rc.top)
            	{
                	g.moveTo(o.x + ld.labelCos*startRad,o.y + ld.labelSin*startRad);
                	g.lineTo(rightEdge,o.y + ld.labelSin*startRad);
             	}
            }
            else if (endRad >= startRad)
            {
             	if (o.y + ld.labelSin * endRad > rc.top)
            	{
            		g.moveTo(o.x + ld.labelCos*startRad,o.y + ld.labelSin*startRad);
                	if (o.x + ld.labelCos*endRad < rightEdge)
                	{
                    	g.lineTo(o.x + ld.labelCos*endRad,o.y + ld.labelSin*endRad);
                	}
                	else
                	{
                    	g.lineTo(o.x + ld.labelCos*_radiusInPixelsScaledForExplode,o.y + ld.labelSin*_radiusInPixelsScaledForExplode);
                	}
                	g.lineTo(rightEdge,o.y + ld.labelSin*endRad);
             	}
            }
            else if (endRad > _radiusInPixelsScaledForExplode*.2)
            {
            	if (o.y + ld.labelSin * endRad > rc.top)
            	{
                	g.moveTo(o.x + ld.labelCos*endRad,o.y + ld.labelSin*endRad);
                	g.lineTo(rightEdge,o.y + ld.labelSin*endRad);
             	}
            }
           else
            {
            	if (o.y + ld.labelSin * endRad > rc.top)
            	{
                	g.moveTo(o.x + ld.labelCos*_radiusInPixelsScaledForExplode*.2,o.y + ld.labelSin*_radiusInPixelsScaledForExplode*.2);
                	g.lineTo(rightEdge,o.y + ld.labelSin*endRad);
             	}
            }
        }
    }

    /**
     *  @private
     */
    private function renderRadialLabels(renderData:PieSeriesRenderData, renderCache:Array /* of PieSeriesItem */):void
    {
    	_labelCache.discard = true;
    	_labelCache.remove = true;
    	_labelCache.count = 0;
    	_labelCache.remove = false;
    	_labelCache.discard = false;
    	
        var n:int = renderCache.length;
        _labelCache.count = n;
        var labels:Array /* of IUITextField */ = _labelCache.instances;

        var i:int;
        var ld:PieSeriesItem;
        var label:IUITextField;
        var labelScale:Number = renderData.labelScale;

        for (i = 0; i < n; i++)
        {
            ld = renderCache[i];
            if (ld.percentValue == 0)
            	continue;
            label = labels[i];
            ld.label = label;
            label.text = ld.labelText;
            label.scaleX = label.scaleY = labelScale;
            label.x = ld.labelX;
            label.y = ld.labelY;
        }

    }

    /**
     *  @private
     */
    private function measureRadialLabels(renderCache:Array /* of PieSeriesItem */):Object
    {
        var dataTransform:PolarTransform = PolarTransform(dataTransform);
        var n:int = renderCache.length;
        var rc:Rectangle= new Rectangle(0,0,unscaledWidth,unscaledHeight);
        var o:Point = dataTransform.origin;

        var labels:Array /* of IUITextField */ = _labelCache.instances;


        var baseRadius:Number = dataTransform.radius*_outerRadius;

        var labelData:Array /* of PieSeriesItem */ = [];
        var baseAngle:Number = _startAngleRadians;
        var i:int;
        var ld:PieSeriesItem;
        var label:IUITextField;
        var labelScale:Number = 1;
        for (i = 0; i < n; i++)
        {
            ld = renderCache[i];

            if (_labelFunction != null)
                _measuringField.text = ld.labelText = _labelFunction(renderCache[i].item,_field,i,renderCache[i].percentValue);
            else if (_labelField)
                _measuringField.text = ld.labelText = renderCache[i].item[_labelField];
            else
                _measuringField.text = ld.labelText = renderCache[i].value.toString();
	
			var renderDirection:String = getStyle('renderDirection');
        	if(renderDirection == "clockwise")
        		ld.labelAngle = (2*Math.PI - (baseAngle + renderCache[i].angle/2))%(2*Math.PI);
        	else
        		ld.labelAngle = (baseAngle + renderCache[i].angle/2)%(2*Math.PI);
            
            ld.labelCos = Math.cos(ld.labelAngle);
            ld.labelSin = -Math.sin(ld.labelAngle);

            if (ld.labelAngle<Math.PI)
            {
                // top half
                ld.labelY = - _measuringField.height;
                baseRadius = Math.min(baseRadius,(o.y  - _measuringField.height)/Math.abs(ld.labelSin));
            }
            else
            {
                //bottom half;
                ld.labelY  = 0;
                baseRadius = Math.min(baseRadius,(rc.bottom - _measuringField.height - o.y)/Math.abs(ld.labelSin));
            }
            if (((ld.labelAngle+Math.PI/2) % (2*Math.PI)) < Math.PI)
            {
                //right half
                ld.labelX = 0;
                baseRadius = Math.min(baseRadius,(rc.right - _measuringField.width - o.x)/Math.abs(ld.labelCos));
            }
            else
            {
                //left half
                ld.labelX = - _measuringField.width;
                baseRadius = Math.min(baseRadius,(o.x  - _measuringField.width)/Math.abs(ld.labelCos));
            }
            labelData[i] = ld;
            baseAngle += renderCache[i].angle;
        }



        if ((baseRadius) < (1-maxLabelRadius)*(dataTransform.radius*_outerRadius))
        {
            // we've scaled down too much. Let's adjust backwards.
            var oldTextSize:Number = dataTransform.radius*_outerRadius - baseRadius;
            baseRadius = (1-maxLabelRadius)*(dataTransform.radius*_outerRadius);
            labelScale = (dataTransform.radius*_outerRadius - baseRadius)/oldTextSize;
        }

        //now, convert our baseRadius base to a scaled down fullRadius
        _radiusInPixelsAfterLabels = baseRadius/_outerRadius;

        for (i = 0; i < n; i++)
        {
            ld = labelData[i];
            ld.labelX = ld.labelX*labelScale  + o.x + (ld.labelCos*baseRadius);
            ld.labelY = ld.labelY*labelScale  + o.y + ld.labelSin*baseRadius;
        }
        _renderData.labelScale = labelScale;
        return null;
    }

    /**
     *  @private
     */
    private function renderInternalLabels(renderData:PieSeriesRenderData,renderCache:Array /* of PieSeriesItem */):void
    {
    	_labelCache.discard = true;
    	_labelCache.remove = true;
    	_labelCache.count = 0;
    	_labelCache.discard = false;
    	_labelCache.remove = false;
        var labelData:Object= renderData.labelData;
        
        if (!labelData)
            return;
        
        var visibleLabelSet:Array /* of PieSeriesItem */ = labelData.visibleLabels;

        var n:int = visibleLabelSet.length;

        _labelCache.count = (labelData.renderCallouts)? renderCache.length:visibleLabelSet.length;

        var labels:Array /* of IUITextField */ = _labelCache.instances;

        var i:int;
        var ld:PieSeriesItem;
        var label:IUITextField;
        var labelScale:Number = renderData.labelScale;

        for (i = 0; i < n; i++)
        {
            ld = visibleLabelSet[i];
            if (ld.percentValue == 0)
            	continue;
            label = labels[i];
            ld.label = label;
            label.text = ld.labelText;
            label.scaleX = label.scaleY = labelScale;
            label.x = ld.labelX;
            label.y = ld.labelY;
        }

        if (labelData.renderCallouts)
        {
            auxRenderCalloutLabels(renderData,labelData.calloutLabelData,visibleLabelSet.length);
        }
    }

    /**
     *  @private
     */
    private function measureInternalLabels(bCallout:Boolean,renderCache:Array /* of PieSeriesItem */):Object
    {
        //type
        var returnData:Object = null;
        var dataTransform:PolarTransform = PolarTransform(dataTransform);
        var n:int = renderCache.length;
        var rc:Rectangle= new Rectangle(0,0,unscaledWidth,unscaledHeight);
        var o:Point = dataTransform.origin;
        var removedLabels:Array /* of PieSeriesItem */ = [];
        var visibleLabels:Array /* of PieSeriesItem */ = [];
        var baseRadius:Number = _radiusInPixelsAfterLabels*_outerRadius* (1-_maxExplodeRadiusRatio) * .7;
        var labelData:Array /* of PieSeriesItem */ = [];
        var baseAngle:Number = _startAngleRadians;
        var i:int;
        var labelScale:Number = 1;

        var ld:PieSeriesItem;
        var label:IUITextField;

        for (i= 0; i < n; i++)
        {
            ld = renderCache[i];

            if (_labelFunction != null)
                _measuringField.text = ld.labelText = _labelFunction(renderCache[i].item,_field,i,renderCache[i].percentValue);
            else if (_labelField)
                _measuringField.text = ld.labelText = renderCache[i].item[_labelField];
            else
                _measuringField.text = ld.labelText = renderCache[i].value.toString();

            var renderDirection:String = getStyle('renderDirection');
        	if(renderDirection == "clockwise")
        		ld.labelAngle = (2*Math.PI - (baseAngle + renderCache[i].angle/2))%(2*Math.PI);
        	else
        		ld.labelAngle = (baseAngle + renderCache[i].angle/2)%(2*Math.PI);
        	
            ld.labelCos = Math.cos(ld.labelAngle);
            ld.labelSin = -Math.sin(ld.labelAngle);

            ld.labelWidth = _measuringField.width;
            ld.labelHeight = _measuringField.height;
            var wedgeExplodeRadiusInPixels:Number = calculateExplodeRadiusForWedge(i);
            ld.labelX =  ld.labelCos*(wedgeExplodeRadiusInPixels+baseRadius) + o.x - ld.labelWidth/2;
            ld.labelY =  ld.labelSin*(wedgeExplodeRadiusInPixels+baseRadius) + o.y - ld.labelHeight/2;

            if (i > 0)
            {
                ld.prev = labelData[i-1];
                ld.prev.next = ld;
            }

            labelData[i] = ld;
            baseAngle += renderCache[i].angle;
        }
        labelData[0].prev = labelData[n-1];
        labelData[n-1].next = labelData[0];


        var sortedLabels:Array /* of PieSeriesItem */ = labelData.concat();
        sortedLabels.sortOn("angle",Array.NUMERIC);


        // now we're going to go through each label and scale down to make sure it doesn't run into it's nearest neighbor

        var insideLabelSizeLimit:Number = getStyle("insideLabelSizeLimit");

        i = 0;

        //var labelFormat:TextFormat = determineTextFormatFromStyles();
        while (i < sortedLabels.length)
        {
            ld = sortedLabels[i];
            label = ld.label;
            //type these
            var nextNeighbor:PieSeriesItem = ld.next;
            var prevNeighbor:PieSeriesItem = ld.prev;

            var rscale:Number = 1;
            // find out how much we would have to scale to get to the next neighbor up
            var RXScale:Number = Math.abs(ld.labelX - nextNeighbor.labelX)/(ld.labelWidth/2 + nextNeighbor.labelWidth/2);
            var RYScale:Number = Math.abs(ld.labelY - nextNeighbor.labelY)/(ld.labelHeight/2 + nextNeighbor.labelHeight/2);
            if (RXScale < 1 && RYScale < 1)
            {
                rscale = Math.max(RXScale,RYScale);
            }
            RXScale = Math.abs(ld.labelX - prevNeighbor.labelX)/(ld.labelWidth/2 + prevNeighbor.labelWidth/2);
            RYScale = Math.abs(ld.labelY - prevNeighbor.labelY)/(ld.labelHeight/2 + prevNeighbor.labelHeight/2);
            if (RXScale < 1 && RYScale < 1)
            {
                rscale = Math.min(rscale,Math.max(RXScale,RYScale));
            }

            if (rscale * Number(getStyle("fontSize")) < insideLabelSizeLimit)
            {
                ld.prev.next = ld.next;
                ld.next.prev = ld.prev;
                removedLabels.push(ld);
                sortedLabels.splice(i,1);
                continue;
            }
            else
            {
                visibleLabels.push(ld);
                labelScale = Math.min(labelScale,rscale);
            }
            i++;
        }
        labelScale = Math.max(.6,labelScale);

        _renderData.labelScale = labelScale;

        if (bCallout == false)
        {
            returnData = { visibleLabels: visibleLabels, renderCallouts: false };
        }
        else
        {
            returnData = { visibleLabels: visibleLabels, renderCallouts: true,
                           calloutLabelData: auxMeasureCalloutLabels(_renderData, removedLabels) };
        }
        return returnData;
    }

    
/* Mouse handling*/
    private function calcAngle(x:Number,y:Number):Number
    {
        const twoMP:Number = Math.PI*2;

        var angle:Number;
        var at:Number = Math.atan(-y/x);
        if (x < 0)
            angle = at + Math.PI;
        else if (y < 0)
            angle = at;
        else
            angle = at + twoMP;

//      angle = (angle - _startAngleRadians) % (twoMP);
//      if (angle < 0)
//          angle += twoMP;
        return angle;
    }

    /**
     *  @private
     */
    private function formatDataTip(hd:HitData):String
    {
        var dt:String = "";


        var sliceName:String = "";
        if (_nameField != "")
            sliceName = PieSeriesItem(hd.chartItem).item[_nameField];
        if (sliceName != "")
            dt += "<b>" + sliceName + ":</b> <b> " + Math.round(PieSeriesItem(hd.chartItem).percentValue*10)/10 + "%</b><BR/>";
        else
            dt += "<b>" + Math.round(PieSeriesItem(hd.chartItem).percentValue*10)/10 + "%</b><BR/>";


        dt += "<i>("+PieSeriesItem(hd.chartItem).value +")</i>";

        return dt;

    }

    /**
     *  @private
     */
    mx_internal function getRadiusInPixels():Number
    {
        return _radiusInPixelsScaledForExplode;
    }

    /**
     *  @private
     */
    mx_internal function getInnerRadiusInPixels():Number
    {
        return _innerRadiusInPixelsScaledForExplode;
    }
}

}

////////////////////////////////////////////////////////////////////////////////

import mx.display.Graphics;
import org.apache.royale.geom.Rectangle;

import mx.charts.chartClasses.LegendData;
import mx.core.IDataRenderer;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.skins.ProgrammaticSkin;

/**
 *  @private
 */
class PieSeriesLegendData extends LegendData
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
    public function PieSeriesLegendData()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public var fill:IFill;
}

/**
 *  @private
 */
class PieSeriesLegendMarker extends ProgrammaticSkin implements IDataRenderer
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
    public function PieSeriesLegendMarker()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  data
    //----------------------------------

    /**
     *  @private
     */
    private var _data:Object;

    [Inspectable(category="General")]

    /**
     *  @private
     */
    public function get data():Object
    {
        return _data;
    }

    /**
     *  @private
     */
    public function set data(value:Object):void
    {
        _data = value;

        invalidateDisplayList();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth,unscaledHeight);

        var stroke:IStroke = getStyle("stroke");
        
        var fill:IFill;
        if (_data != null && "fill" in _data)
            fill = _data.fill;
        else
            fill = getStyle("fill");

        var g:Graphics = graphics;
        
        g.clear();
        g.moveTo(0, 0);
        
        if (stroke)
            stroke.apply(g,null,null);
        else
            g.lineStyle(0, 0, 0);
        
        if (fill)
            fill.begin(g,  new Rectangle(0, 0, width, height), null);
        
        g.lineTo(width, 0);
        g.lineTo(width, height);
        g.lineTo(0, height);
        g.lineTo(0, 0);
        
        if (fill)
            fill.end(g);
    }

}

