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
	COMPILE::JS {
		import goog.DEBUG;
	}
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
	import mx.charts.chartClasses.IAxis;
	import mx.charts.HitData;
	import mx.charts.series.items.PieSeriesItem;
	import mx.collections.CursorBookmark;
	import org.apache.royale.core.ClassFactory;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	import mx.graphics.Stroke;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import mx.charts.chartClasses.Series;
/*
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.filters.DropShadowFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.Dictionary;

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
import mx.core.ContextualClassFactory;
import mx.core.IDataRenderer;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.IUITextField;
import mx.core.LayoutDirection;
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
*/
/**
 *  Specifies how much space, in pixels, to insert between the edge
 *  of the pie and the labels when rendering callouts.
 *  
 *  @default 10
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="calloutGap", type="Number", format="Length", inherit="no")]

/**
 *  Specifies the line style used to draw the lines to callouts.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
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
 *  @productversion Royale 0.9.3
 */
//[Style(name="fills", type="Array", arrayType="mx.graphics.IFill", inherit="no")]

/**
 *  A number from 0 to 1 specifying the distance from the center of the series
 *  to the inner edge of the rendered wedges,
 *  as a percentage of the total radius assigned to the series.
 *  This property is assigned directly to the series.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
//[Style(name="innerRadius", type="Number", inherit="no")]
    
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
 *  @productversion Royale 0.9.3
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
 *  @productversion Royale 0.9.3
 */
[Style(name="labelPosition", type="String", enumeration="none,outside,callout,inside,insideWithCallout", inherit="no")]

/**
 *  Specifies the line style used to draw the border
 *  between the wedges of the pie.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
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
//[Style(name="renderDirection", type="String", enumeration="clockwise,counterClockwise", inherit="no")]

/**
 *  Sets the stroke style for this data series.
 *  You must specify a Stroke object to define the stroke. 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
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
 *  @productversion Royale 0.9.3
 */
public class PieSeries extends Series
{
    //include "../../core/Version.as";

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
     *  @productversion Royale 0.9.3
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
     *  @productversion Royale 0.9.3
     */
    public function PieSeries()
    {
        super();

        _labelLayer = new UIComponent();
        /*_labelLayer.styleName = this;
        
        _labelCache = new InstanceCache(UITextField,_labelLayer);
        
        _labelCache.discard = true;
        _labelCache.remove = true;
        
        _labelCache.properties =
        {
            autoSize: TextFieldAutoSize.LEFT,
            selectable: false,
            styleName: this
        };
        
        perWedgeExplodeRadius = [];

        _instanceCache = new InstanceCache(null, this);
        _instanceCache.properties = { styleName: this };
		filters = [ new DropShadowFilter(DROP_SHADOW_SIZE, 45, 0, 60,
                                         DROP_SHADOW_SIZE, DROP_SHADOW_SIZE) ];
        
        dataTransform = new PolarTransform();  

		// our style settings
		initStyles();*/
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
    //private var _instanceCache:InstanceCache;

    /**
     *  @private
     */
    //private var _renderData:PieSeriesRenderData;

    /**
     *  @private
     */
    //private var _measuringField:IUITextField;
    
    /**
     *  @private
     */
    private var _labelLayer:UIComponent;
    
    /**
     *  @private
     */
    //private var _labelCache:InstanceCache;

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
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  field
    //----------------------------------

    /**
     *  @private
     *  Storage for the field property.
     */
    private var _field:String = "";
    
    //[Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines
     *  the data for each wedge of the PieChart control.
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
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
        
        //dataChanged();
    }

    //----------------------------------
    //  labelFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the labelFunction property.
     */
    private var _labelFunction:Function;

    //[Inspectable(category="General")]

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
     *  @productversion Royale 0.9.3
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

        //invalidateDisplayList();
    }
    
    //---------------------------------
    // labelField
    //---------------------------------
    
    /**
     * @private
     * Storage for labelField property
     */
    private var _labelField:String;
    
    //[Inspectable(category="General")]
    
    /**
     * Name of a field in the data provider whose value appears as label
     * Ignored if labelFunction is specified
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
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
        //invalidateTransform();              
    }

    //----------------------------------
    //  nameField
    //----------------------------------

    /**
     *  @private
     *  Storage for the nameField property.
     */
    private var _nameField:String = "";

    //[Inspectable(category="General")]

    /**
     *  Specifies the field of the data provider that determines
     *  the name of each wedge of the PieChart control.
     *  
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
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

        //dataChanged();

        //legendDataChanged();
    }

    //----------------------------------
    //  displayName
    //----------------------------------

    /**
     *  @private
     *  Storage for the displayName property.
     */
     private var _displayName:String;

    /**
     *  The name of the series, for display to the user.
     *  This property is used to represent the series in user-visible labels,
     *  such as data tips.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function get displayName():String
    {
        return _displayName;
    } 
    
    /**
     *  @private
     */
    public function set displayName(value:String):void
    {
        _displayName = value;
    } 
    
}

}

////////////////////////////////////////////////////////////////////////////////
	import org.apache.royale.geom.Rectangle;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;

/*
import flash.display.Graphics;
import flash.geom.Rectangle;

import mx.charts.chartClasses.LegendData;
import mx.core.IDataRenderer;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.skins.ProgrammaticSkin;
*/
/**
 *  @private
 */
class PieSeriesLegendData //extends LegendData
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
     *  @productversion Royale 0.9.3
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
    //public var fill:IFill;
}

/**
 *  @private
 */
class PieSeriesLegendMarker //extends ProgrammaticSkin implements IDataRenderer
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
     *  @productversion Royale 0.9.3
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

    //[Inspectable(category="General")]

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

        //invalidateDisplayList();
    }

}
