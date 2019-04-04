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

package mx.charts.chartClasses
{

COMPILE::JS
{
    import goog.DEBUG;
}
import mx.charts.ChartItem;
import mx.charts.HitData;
import mx.charts.events.ChartEvent;
import mx.charts.events.ChartItemEvent;
import mx.charts.styles.HaloDefaults;
import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IList;
import mx.collections.ListCollectionView;
import mx.collections.XMLListCollection;
import mx.core.DragSource;
import mx.core.EventPriority;
import mx.core.FlexGlobals;
import mx.core.IDataRenderer;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.display.Graphics;
import mx.events.DragEvent;
import mx.events.EffectEvent;
import mx.events.KeyboardEvent;
import mx.graphics.IFill;
import mx.graphics.IStroke;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;
import mx.graphics.Stroke;
import mx.managers.IFocusManagerComponent;
import mx.managers.ILayoutManagerClient;
import mx.managers.ISystemManager;
import mx.styles.CSSStyleDeclaration;

import org.apache.royale.events.Event;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.events.MouseEvent;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the selection changes in the chart.
 *
 *  @eventType mx.charts.events.ChartItemEvent.CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="change", type="mx.charts.events.ChartItemEvent")]

/**
 *  Dispatched when no data point is found under the mouse pointer
 *  when mouse is clicked on chart.
 *  Flex considers only data points within the radius determined by
 *  the <code>mouseSensitivity</code> property.
 *
 *  @eventType mx.charts.events.ChartEvent.CHART_CLICK
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="chartClick", type="mx.charts.events.ChartEvent")]

/**
 *  Dispatched when no data point is found under the mouse pointer
 *  when mouse is double-clicked on chart.
 *  Flex considers only data points within the radius determined by
 *  the <code>mouseSensitivity</code> property.
 *
 *  @eventType mx.charts.events.ChartEvent.CHART_DOUBLE_CLICK
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="chartDoubleClick", type="mx.charts.events.ChartEvent")]

/**
 *  Dispatched when a data point is found under the mouse pointer
 *  when it is clicked.
 *  Flex considers only data points within the radius determined by
 *  the <code>mouseSensitivity</code> property.
 *
 *  @eventType mx.charts.events.ChartItemEvent.MOUSE_CLICK_DATA
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemClick", type="mx.charts.events.ChartItemEvent")]

/**
 *  Dispatched when a data point is found under the mouse pointer
 *  when it is double clicked.
 *  Flex considers only data points within the radius determined by
 *  the <code>mouseSensitivity</code> property.
 *
 *  @eventType mx.charts.events.ChartItemEvent.ITEM_DOUBLE_CLICK
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemDoubleClick", type="mx.charts.events.ChartItemEvent")]

/**
 *  Dispatched when a data point is found under the mouse pointer
 *  when it is pressed down.
 *  Flex considers only data points within the radius determined by
 *  the <code>mouseSensitivity</code> property.
 *
 *  @eventType mx.charts.events.ChartItemEvent.ITEM_MOUSE_DOWN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemMouseDown", type="mx.charts.events.ChartItemEvent")]

/**
 *  Dispatched when the mouse pointer moves while over a data point.
 *  Flex considers only data points within the radius determined by
 *  the <code>mouseSensitivity</code> property.
 *
 *  @eventType mx.charts.events.ChartItemEvent.ITEM_MOUSE_MOVE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemMouseMove", type="mx.charts.events.ChartItemEvent")]

/**
 *  Dispatched when a data point is found under the mouse pointer
 *  when it is released.
 *  Flex considers only data points within the radius determined by
 *  the <code>mouseSensitivity</code> property.
 *
 *  @eventType mx.charts.events.ChartItemEvent.ITEM_MOUSE_UP
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemMouseUp", type="mx.charts.events.ChartItemEvent")]

/**
 *  Dispatched when the closest data point under the mouse pointer changes.
 *  Flex considers only data points within the radius determined by
 *  the <code>mouseSensitivity</code> property.
 *
 *  @eventType mx.charts.events.ChartItemEvent.ITEM_ROLL_OUT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemRollOut", type="mx.charts.events.ChartItemEvent")]

/**
 *  Dispatched when a new data point is found under the mouse pointer.
 *  Flex only considers data points within the radius determined by
 *  the <code>mouseSensitivity</code> property.
 *
 *  @eventType mx.charts.events.ChartItemEvent.ITEM_ROLL_OVER
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemRollOver", type="mx.charts.events.ChartItemEvent")]

/**
 *  @private
 *  Hidden from metadata, since it's not to exposed to end users
 */
/*
[Event(name="legendDataChanged", type="flash.events.Event")]
*/

//--------------------------------------
//  Styles
//--------------------------------------

//include "../../styles/metadata/PaddingStyles.as"
include "../styles/metadata/TextStyles.as"

/**
 *  Contains a list of Strings, each corresponding to a CSS type selector
 *  to be used as the default CSS style for a series.
 *  Each series in the chart draws a CSS type selector from the list
 *  contained in the <code>chartSeriesStyles</code> style.
 *  The first series uses the first selector, the second uses
 *  the second, and so on.
 *  Style properties in this type selector can be overridden
 *  by specifying a <code>styleName</code> property for the series.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="chartSeriesStyles", type="Array", arrayType="String", inherit="no")]

/**
 *  The Stroke to use to render the callout line
 *  from the data tip target to the tip.
 *  If set to <code>null</code>, no Stroke is drawn
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="dataTipCalloutStroke", type="mx.graphics.IStroke", inherit="no")]

/**
 *  Specifies the class to use to render data tips.
 *  This class must implement the IFlexDisplayObject
 *  and IDataRenderer interfaces.
 *  The chart assigns the custom data tip's <code>data</code> property
 *  to be the HitData structure describing the data point being described.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="dataTipRenderer", type="Class", inherit="no")]

/**
 *  Specifies the fill style used for the chart background.
 *  The fill can be either a simple color value
 *  or an object that implements the mx.graphics.IFill interface.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="fill", type="mx.graphics.IFill", inherit="no")]

/**
 *  Color of disabled chartitem in the chart.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */ 
[Style(name="itemDisabledColor", type="uint", format="Color", inherit="yes")]

/**
 *  Color of rolledOver chartitem in the chart.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */ 
[Style(name="itemRollOverColor", type="uint", format="Color", inherit="yes")] 

/**
 *  Color of selected chartitem in the chart.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */ 
[Style(name="itemSelectionColor", type="uint", format="Color", inherit="yes")]

/**
 *  Specifies the maximum number of datatips a chart will show.
 *  If more datapoints are in range of the chart than allowed by this style,
 *  they will be prioritized by distance,
 *  with the closest showing first.
 *  
 *  <p>The default value is NaN, which shows whatever datatips are within range.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="maximumDataTipCount", type="int", inherit="no")]

/**
 *  Specifies the number of pixels between the chart's bottom border
 *  and its content area.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  Specifies the number of pixels between the chart's top border
 *  and its content area.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

/**
 *  Specifies whether to show targets over the datapoints
 *  when <code>showDataTips</code> is set to true.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="showDataTipTargets", type="Boolean", inherit="no")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultProperty("dataProvider")]

/**
 *  The ChartBase class is the link between the Flex component
 *  architecture and the DualStyleObject architecture.
 *  It extends the Flex UIComponent base class,
 *  but contains DualStyleObject classes.
 *
 *  <p>You typically do not use the ChartBase class directly.
 *  Instead you use one of its subclasses, such as PlotChart or BubbleChart.
 *  It acts as the base class for the common chart types
 *  provided in the mx.charts package.</p>
 *  
 *  <p>This class defines a number of CSS styles and properties
 *  that provide easy access to the more common features of the framework.</p>
 *  
 *  <p>A chart's minimum size is 20 x 20 pixels.
 *  A chart's maximum size is unbounded.
 *  A chart's preferred size is 400 x 400 pixels.</p>
 *  
 *  <p>ChartBase objects, and its subclasses, augment the normal
 *  mouse event objects with additional data that describes
 *  the nearest chart data point under the mouse.
 *  The event object for mouse events contains an additional property,
 *  <code>hitData</code>, which contains a HitData object
 *  that describes the nearest data point.
 *  See mx.charts.HitData for more information on the contents
 *  of the HitData object.</p>
 *  
 *  <p>ChartBase objects consider data points only within a certain radius
 *  of the mouse pointer.
 *  You can set this radius using the <code>mouseSensitivity</code>
 *  property.
 *  If there is no data point within the <code>mouseSensitivity</code>
 *  radius, event.hitData is <code>null</code>.</p>
 *
 *  @mxml
 *  
 *  <p>Flex components inherit the following properties
 *  from the ChartBase class:</p>
 *
 *  <pre>
 *  &lt;mx:<i>tagname</i>
 *    <strong>Properties</strong>
 *    allElements="<i>Array; No default</i>"
 *    annotationElements="<i>Array; No default</i>"
 *    backgroundElements="<i>Array; No default</i>"
 *    chartState="<i></i>"
 *    clipContent="false|true"
 *    dataProvider="<i>No default</i>"
 *    dataRegion"<i>No default</i>"
 *    dataTipFunction="<i>No default</i>"
 *    dataTipLayerIndex"<i>No default</i>"
 *    dataTipMode"<i>No default</i>"
 *    description"<i>No default</i>"
 *    dragEnabled="false|true"
 *    dragMoveEnabled="false|true"
 *    dropEnabled="false|true"
 *    labelElements"<i>No default</i>"
 *    legendData"<i>No default</i>"
 *    mouseSensitivity="5"
 *    selectedChartItem=<i>ChartItem; No default</i>"
 *    selectedChartItems=<i>Array; No default</i>"
 *    selectionMode="none|single|multiple"
 *    series="<i>No default</i>"
 *    seriesFilters"<i>No default</i>"
 *    showAllDataTips="true|false"
 *    showDataTips="true|false"
 *    transforms="<i>No default</i>"
 *    
 *    <strong>Styles</strong>
 *    chartSeriesStyles="<i>Style; No default</i>"
 *    dataTipCalloutStroke="<i>Stroke; No default</i>"
 *    dataTipRenderer="<i>Renderer; No default</i>"
 *    fill="<i>IFill; No default</i>"
 *    fontFamily="<i>Verdana</i>"
 *    fontSize="<i>10</i>"
 *    itemDisabledColor="<i>uint; No default</i>"
 *    itemRollOverColor="<i>uint; No default</i>"
 *    itemSelectionColor="<i>uint; No default</i>"
 *    maximumDataTipCount="NaN"
 *    paddingBottom="<i>No default</i>"
 *    paddingTop="<i>No default</i>"
 *    paddingLeft="<i>0</i>"
 *    paddingRight="<i>0</i>"
 *    showDataTipTargets="true|false"  
 *    
 *   <strong>Events</strong>
 *    change="<i>Event; No default</i>"
 *    itemClick="<i>Event; No default</i>"
 *    itemDoubleClick="<i>Event; No default</i>"
 *    itemMouseDown="<i>Event; No default</i>"
 *    itemMouseMove="<i>Event; No default</i>"
 *    itemMouseUp="<i>Event; No default</i>"
 *    itemRollOut="<i>Event; No default</i>"
 *    itemRollOver="<i>Event; No default</i>"
 *  &gt;
 *  </pre>
 *  
 *  @see mx.charts.HitData
 *  @see mx.charts.CategoryAxis
 *  @see mx.charts.LinearAxis
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ChartBase extends UIComponent implements IFocusManagerComponent
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class Initialization
    //
    //--------------------------------------------------------------------------
    
    
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static const TOOLTIP_TARGET_INNER_RADIUS:Number = 1.5;
    
    /**
     *  @private
     */
    private static const TOOLTIP_TARGET_RADIUS:Number = 4.5;

    /**
     *  The value of this constant is passed to methods such as <code>getNextItem()</code> and <code>getPrevItem()</code>. 
     *  These methods use this constant to determine which item or series to select when the user 
     *  presses a key such as the left arrow.
     *  
     *  For example, if the left arrow or right arrow key was pressed, the direction is set to "horizontal" 
     *  (<code>ChartBase.HORIZONTAL</code>).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const HORIZONTAL:String = "horizontal";
    
    /**
     *  The value of this constant is passed to methods such as <code>getNextItem()</code> and <code>getPrevItem()</code>. 
     *  These methods use this constant to determine which item or series to select when the user 
     *  presses a key such as the left arrow.
     *  
     *  For example, if the up arrow or down arrow key was pressed, the direction is set to "vertical" 
     *  (<code>ChartBase.VERTICAL</code>).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const VERTICAL:String = "vertical";
    
    /**
     *  @private
     *  Mouse movement threshold for determining when to start a drag.
     */
    mx_internal static const DRAG_THRESHOLD:int = 4;

        
    /**
     *  @private
     */
    private static var ITEM_EVENTS:Object =
    {
        chartClick: true,
        chartDoubleClick: true,
        itemClick: true,
        itemDoubleClick: true,
        itemMouseDown: true,
        itemMouseUp: true,
        itemMouseMove: true,
        itemRollOver: true,
        itemRollOut: true
    }

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
    public function ChartBase()
    {
        super();
        this.addEventListener(DragEvent.DRAG_START, dragStartHandler);
        
        tabEnabled = false;

        _seriesHolder = new UIComponent();
        COMPILE::JS
        {
            if (goog.DEBUG)
                _seriesHolder.name = "_seriesHolder";
        }
        _seriesFilterer = new UIComponent();
        
        COMPILE::JS
        {
            if (goog.DEBUG)
                _seriesFilterer.name = "_seriesHolder";
        }
        _seriesHolder.addChild(_seriesFilterer);
        addChild(_seriesHolder);
        COMPILE::JS
        {
            _seriesHolder.element.style.position = "absolute";
            _seriesFilterer.element.style.position = "absolute";
        }

        _backgroundElementHolder = new UIComponent();
        COMPILE::JS
        {
            if (goog.DEBUG)
                _backgroundElementHolder.name = "_backgroundElementHolder";
        }
        addChild(_backgroundElementHolder);
        COMPILE::JS
        {
            _backgroundElementHolder.element.style.position = "absolute";            
        }

        _annotationElementHolder = new UIComponent();
        COMPILE::JS
        {
            if (goog.DEBUG)
                _annotationElementHolder.name = "_annotationElementHolder";
        }
        addChild(_annotationElementHolder);
        COMPILE::JS
        {
            _annotationElementHolder.element.style.position = "absolute";
        }
        
        _dataTipOverlay = new UIComponent();
        _dataTipOverlay.name = "dataTipOverlay";
        addChild(_dataTipOverlay);
        COMPILE::JS
        {
            _dataTipOverlay.element.style.position = "absolute";
        }
        
        _allDataTipOverlay = new UIComponent();
        _allDataTipOverlay.name = "allDataTipOverlay";
        addChild(_allDataTipOverlay);
        COMPILE::JS
        {
            _allDataTipOverlay.element.style.position = "absolute";
        }

        var g:Graphics;
        
        /*
        _seriesMask = new FlexShape();
        _seriesMask.name = "seriesMask";
        g = _seriesMask.graphics;
        g.clear();
        g.beginFill(0, 100);
        g.drawRect(0,0,10,10);
        g.endFill();    
        _seriesMask.visible = false;

        _backgroundElementMask = new FlexShape();
        _backgroundElementMask.name = "backgroundElementMask";
        g = _backgroundElementMask.graphics;
        g.clear();
        g.beginFill(0, 100);
        g.drawRect(0,0,10,10);
        g.endFill();    
        _backgroundElementMask.visible = false;

        _annotationElementMask = new FlexShape();
        _annotationElementMask.name = "annotationElementMask";
        g = _annotationElementMask.graphics;
        g.clear();
        g.beginFill(0, 100);
        g.drawRect(0,0,10,10);
        g.endFill();    
        _annotationElementMask.visible = false;
        
        _seriesHolder.addChild(_seriesMask);
        _seriesHolder.mask = _seriesMask;       

        _backgroundElementHolder.addChild(_backgroundElementMask);
        _backgroundElementHolder.mask = _backgroundElementMask;

        _annotationElementHolder.addChild(_annotationElementMask);
        _annotationElementHolder.mask = _annotationElementMask;
        */
        
        _currentHitSet = [];
                        
        invalidateChildOrder();
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
    private var _allTipCache:InstanceCache;
    
    /**
     *  @private
     */
    private var _tipCache:InstanceCache;

    /**
     *  @private
     */
    private var _dataTipOverlay:UIComponent;
    
    /**
     *  @private
     */
    private var _allDataTipOverlay:UIComponent;
    /**
     *  We need commitProperties() to be called before an update.
     *  Since there are scenarios where that might not be guaranteed,
     *  we'll enforce it ourselves.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _commitPropertiesCalled:Boolean = false;
    
    /**
     *  @private
     */
    private var _seriesMask:UIComponent;

    /**
     *  @private
     */
    private var _backgroundElementMask:UIComponent;

    /**
     *  @private
     */
    private var _annotationElementMask:UIComponent;
    
    /**
     *  @private
     */
    private var _bSeriesDirty:Boolean = false;
    
    /**
     *  @private
     */
    private var _bDataDirty:Boolean = false;
    
    /**
     *  @private
     */
    private var _childOrderDirty:Boolean = false;
    
    /**
     *  @private
     */
    private var _userSeries:Array /* of Series */ = [];
    
    /**
     *  @private
     */
    private var _backgroundElements:Array /* of ChartElement */ = [];
    
    /**
     *  @private
     */
    private var _annotationElements:Array /* of ChartElement */ = [];
    
    /**
     *  @private
     */
    private var _description:String = "";
    
    /**
     *  @private
     */
    private var _dataProvider:ICollectionView;

    /**
    * @private
    */
    protected var _seriesHolder:UIComponent;
    
    /**
    * @private
    */
    protected var _seriesFilterer:UIComponent;

    /**
    * @private
    */
    protected var _backgroundElementHolder:UIComponent;

    /**
    * @private
    */
    protected var _annotationElementHolder:UIComponent;
    
    /**
     *  The set of all chart elements displayed in the chart.
     *  This set includes series, second series, background elements,
     *  and annotation elements.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var allElements:Array /* of ChartElement */ = [];
    
    /**
     *  The set of display objects that represent the labels
     *  for the chart elements.
     *  Some series, annotation, and background types include overlays
     *  such elements and callouts.
     *  Elements can pass a display object to the chart that contains
     *  the overlays to be placed on top of all other chart elememnts.
     *  Chart implementors can access these overlay objects
     *  in the <code>labelElements</code> array.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected var labelElements:Array /* of UIComponent */ = [];
    
    /**
     *  @private
     */
    private var _clipContent:Boolean = true;

    /**
    * @private
    */
    protected var _transforms:Array /* of DataTransform */;
    
    /**
     *  @private
     */
    private var _showAllDataTips:Boolean = false;

    /**
     *  @private
     */
    private var _showDataTips:Boolean = false;

    /**
     *  @private
     */
    private var _dataTipMode:String = "multiple";

    /**
     *  @private
     */
    private var _currentHitSet:Array /* of HitData */;

    /**
     *  @private
     */
    private var _mouseEventsInitialzed:Boolean = false;

    /**
     *  @private
     */
    private var _rangeEventsInitialzed:Boolean = false;

    /**
     *  @private
     */
    private var _transitionState:uint = 0;
    
    /**
     *  @private
     */
    //private var _transitionEffect:ParallelInstance;

    /**
     *  @private
     */
    private var _seriesStylesDirty:Boolean = true;

   /**
     *  @private
     */
    protected var _selectedSeries:Series=null;
        
   /**
     *  @private
     *  Storage for the selectionMode property.
     */
    private var _selectionMode:String="none";

    /**
     *  @private
     */
    private var _mouseDown:Boolean=false;    

    /**
     *  @private
     */
    private var _mouseDownPoint:Point=null;    
    
    /**
     *  @private
     */
    private var _mouseDownItem:ChartItem=null;    
    
    /**
     *  @private
     */
    protected var _caretItem:ChartItem=null;

    /**
     *  @private
     */
    protected var _anchorItem:ChartItem=null;
    
     /**
     *  @private
     */
    private var dLeft:Number = 0;
    
    /**
     *  @private
     */
    private var dTop:Number = 0;
    
    /**
     *  @private
     */
    private var dRight:Number = 0;
    
     /**
     *  @private
     */
    private var dBottom:Number = 0;
    
     /**
     *  @private
     */
    private var tX:Number;
    
    /**
     *  @private
     */
    private var tY:Number;    
        
    /**
     *  @private
     */
    private var rangeItemRenderer:RangeSelector = null;
    
    /**
     *  @private
     */
    private var dataRegionForRange:Rectangle = null;
    
    /**
     *  @private
     *  @royalesuppresspublicvarwarning
     */
    public var dataTipItemsSet:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  showInAutomationHierarchy
    //----------------------------------

    /**
     *  @private
    override public function set showInAutomationHierarchy(value:Boolean):void
    {
        //do not allow value changes
    }
     */
    
    
    //-------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  annotationElements
    //----------------------------------

    [Inspectable(arrayType="mx.charts.chartClasses.ChartElement")]
    
    /**
     *  Sets an array of ChartElement objects that appears on top
     *  of any data series rendered by the chart.
     *  Each item in the array must extend the mx.charts.DualStyleObject
     *  class and implement the IChartElement2 interface.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get annotationElements():Array /* of ChartElement */
    {
        return _annotationElements;
    }
    
    /**
     *  @private
     */
    public function set annotationElements(value:Array /* of ChartElement */):void
    {
        _annotationElements = value;

        invalidateSeries();
    }

    //----------------------------------
    //  backgroundElements
    //----------------------------------

    [Inspectable(arrayType="mx.charts.chartClasses.ChartElement")]

    /**
     *  Sets an array of background ChartElement objects that appear below
     *  any data series rendered by the chart.
     *  Each item in the Array must extend the mx.charts.DualStyleObject
     *  class and implement the IChartElement2 interface.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get backgroundElements():Array /* of ChartElement */
    {
        return _backgroundElements;
    }
    
    /**
     *  @private
     */
    public function set backgroundElements(value:Array /* of ChartElement */):void
    {
        _backgroundElements = value;

        invalidateSeries();
    }

    //----------------------------------
    //  chartState
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  The current transition state of the chart.
     *  Use this property to determine whether the chart
     *  is currently transitioning out its old data,
     *  transitioning in its new data,
     *  or has completed all transitions and is showing its current data set.
     *  See the mx.charts.chartClasses.ChartState enumeration
     *  for possible values.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get chartState():uint
    {
        return _transitionState;
    }

    /**
    * @private
    */
    protected function setChartState(value:uint):void
    {
        if (_transitionState == value)
            return;

        var oldState:uint = _transitionState;
        _transitionState = value;

        var n:int = allElements.length;
        for (var i:int = 0; i < n; i++)
        {
            var g:IChartElement = allElements[i] as IChartElement;
            if (g)
                g.chartStateChanged(oldState, value);
        }

        invalidateDisplayList();
    }

    //----------------------------------
    //  clipContent
    //----------------------------------

    [Inspectable(defaultValue="true")]

    /**
     *  Determines whether Flex clips the chart to the area bounded by the axes.
     *  Set to <code>false</code> to clip the chart.
     *  Set to <code>true</code> to avoid clipping when the data is rendered.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get clipContent():Boolean
    {
        return _clipContent;
    }

    /**
     *  @private
     */
    public function set clipContent(value:Boolean):void
    {
        if (_clipContent == value)
            return;
        _clipContent = value;

        _seriesHolder.mask = _clipContent ?
                             _seriesMask :
                             null;

        _backgroundElementHolder.mask = _clipContent ?
                                        _backgroundElementMask :
                                        null;

        _annotationElementHolder.mask = _clipContent ?
                                        _annotationElementMask :
                                        null;                                        
    }
    
    //----------------------------------
    //  dataProvider
    //----------------------------------
    
    [Inspectable(category="Data", arrayType="Object")]

    /**
     *  Specifies the data provider for the chart.
     *  Data series rendered by the chart are assigned this data provider.
     *  To render disparate data series in the same chart,
     *  use the <code>dataProvider</code> property on the individual series.
     *  
     *  <p>This property can accept an array
     *  or any other object that implements the IList or ICollectionView interface.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dataProvider():Object
    {
        return _dataProvider;
    }

    /**
     *  @private
     */
    public function set dataProvider(value:Object):void
    {
        if (value is Array)
        {
            value = new ArrayCollection(value as Array);
        }
        else if (value is ICollectionView)
        {
        }
        else if (value is IList)
        {
            value = new ListCollectionView(value as IList);
        }
        else if (value is XMLList)
        {
            value = new XMLListCollection(XMLList(value));
        }
        else if (value != null)
        {
            value = new ArrayCollection([ value ]);
        }
        else
        {
            value = new ArrayCollection();
        }
        
        _dataProvider = ICollectionView(value);

        invalidateData();        
    }

    //----------------------------------
    //  dataRegion
    //----------------------------------

    /**
     *  The area of the chart used to display data.
     *  This rectangle excludes the area used for gutters, axis lines and labels, and padding.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get dataRegion():Rectangle
    {
        return null;
    }

    //----------------------------------
    //  dataTipFunction
    //----------------------------------

    private var _dataTipFunction:Function;
    
    [Inspectable(category="Data")]
    
    /**
     *  Specifies a callback method used to generate data tips from values.
     *  This method should use the following signature:
     *  <pre>
     *  function dataTipFunction(<i>hitData</i>:HitData):String
     *  </pre>
     *  <p>This method returns a string that is displayed for each data point.
     *  The text can include HTML formatting.
     *  The single parameter is a HitData object that describes the data point.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dataTipFunction():Function
    {
        return _dataTipFunction;
    }
    public function set dataTipFunction(value:Function):void
    {
        _dataTipFunction = value;
    }

    //----------------------------------
    //  dataTipLayerIndex
    //----------------------------------

    /**
     *  The index of the child that is responsible for rendering data tips.
     *  Derived classes that add visual elements to the chart
     *  should add them below this layer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get dataTipLayerIndex():int
    {
        return getChildIndex(_dataTipOverlay);
    }

    //----------------------------------
    //  dataTipMode
    //----------------------------------
    
    [Inspectable(category="Data", enumeration="single,multiple", defaultValue="single")]

    /**
     *  Specifies how Flex displays DataTip controls for the chart.
     *  DataTip controls are similar to ToolTip controls, except that they display
     *  an appropriate value that represents the nearest chart data point
     *  under the mouse pointer.
     * 
     *  <p>Possible values of <code>dataTipMode</code> are:
     *   <ul>
     *    <li><code>"single"</code> - Data tips are shown for the closest data point
     *    to the mouse cursor.</li>
     *  
     *    <li><code>"multiple"</code> - Data tips are shown for any DataTip control
     *    within range of the mouse cursor. You can control the sensitivity 
     *    with the <code>mouseSensitivity</code> property.</li>
     *   </ul>
     *  </p>
     * 
     *  <p>You can customize DataTip controls with the
     *  <code>dataTipFunction</code> property.</p>
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dataTipMode():String
    {
        return _dataTipMode;
    }
    
    /**
     *  @private
     */
    public function set dataTipMode(value:String):void
    {
        _dataTipMode = value;

        updateDataTips();               
    }

    //----------------------------------
    //  description
    //----------------------------------

    [Inspectable(defaultValue="")]

    /**
     *  A short description of the data in the chart.
     *  When accessibility is enabled, screen readers use this property to describe the chart.
     *  <p>This string defaults to the empty string, and must be
     *  explicitly assigned by the developer to have meaning.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get description():String
    {
        return _description;
    }

    /**
     *  @private
     */
    public function set description(value:String):void
    {
        setDescription(value);
        tabEnabled = true;
    }
    
    /**
     *  @private
     */
    mx_internal function setDescription(value:String):void
    {
        _description = value;
    }
    
    //----------------------------------
    //  dragEnabled
    //----------------------------------

    /**
     *  @private
     *  Storage for the dragEnabled property.
     */
    private var _dragEnabled:Boolean = false;

    /**
     *  Specifies whether you can drag items out of
     *  this chart and drop them on other controls.
     *  If <code>true</code>, dragging is enabled for the chart.
     *  If the <code>dropEnabled</code> property is also <code>true</code>,
     *  you can drag items and drop them in the chart
     *  to reorder the items.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dragEnabled():Boolean
    {
        return _dragEnabled;
    }

    /**
     *  @private
     */
    public function set dragEnabled(value:Boolean):void
    {
        if (_dragEnabled && !value)
        {
            removeEventListener(DragEvent.DRAG_COMPLETE,
                                dragCompleteHandler, false);    
        }

        _dragEnabled = value;

        if (value)
        {
            addEventListener(DragEvent.DRAG_COMPLETE, dragCompleteHandler,
                             false, EventPriority.DEFAULT_HANDLER);                
        }
    }
    
    //----------------------------------
    //  dragImage
    //----------------------------------

    /**
     *  Gets an instance of a class that displays the visuals
     *  during a drag-and-drop operation.
     *
     *  @default mx.controls.chartClasses.ChartItemDragProxy
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function get dragImage():IUIComponent
    {
        var image:ChartItemDragProxy = new ChartItemDragProxy();
        image.owner = this;
        return image;
    }

    //----------------------------------
    //  dragMoveEnabled
    //----------------------------------

    /**
     *  @private
     *  Storage for the dragMoveEnabled property.
     */
    private var _dragMoveEnabled:Boolean = false;

    [Inspectable(defaultValue="false")]

    /**
     *  Indicates which display cursor to show as drag feedback.
     * 
     *  If <code>true</code>, and the <code>dragEnabled</code> property
     *  is <code>true</code> and the Control key is not held down,
     *  <code>moveCursor</code> is shown as feedback. 
     *  If the Control key is held down, <code>copyCursor</code> is shown.
     *  
     *  If <code>false</code> and the <code>dragEnabled</code> property
     *  is <code>true</code>, then <code>copyCursor</code> is shown
     *  whether the Control key is held down or not.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dragMoveEnabled():Boolean
    {
        return _dragMoveEnabled;
    }

    /**
     *  @private
     */
    public function set dragMoveEnabled(value:Boolean):void
    {
        _dragMoveEnabled = value;
    }


    //----------------------------------
    //  dropEnabled
    //----------------------------------

    /**
     *  @private
     *  Storage for the <code>dropEnabled</code> property.
     */
    private var _dropEnabled:Boolean = false;

    [Inspectable(defaultValue="false")]

    /**
     *  A flag that specifies whether dragged items can be dropped onto the 
     *  chart.
     *
     *  <p>If you set this property to <code>true</code>,
     *  the chart accepts all data formats, and assumes that
     *  the dragged data matches the format of the data in the data provider.
     *  To explicitly check the data format of the data
     *  being dragged, you must handle one or more of the drag events,
     *  such as <code>dragOver</code>, and call the
     *  <code>preventDefault()</code> method of the DragEvent to customize
     *  the way the list class accepts dropped data.</p>
     *
     *  <p>When <code>dropEnabled</code> is set to <code>true</code>, 
     *  Flex automatically calls the <code>showDropFeedback()</code> 
     *  and <code>hideDropFeedback()</code> methods to display the drop indicator.</p>
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get dropEnabled():Boolean
    {
        return _dropEnabled;
    }

    /**
     *  @private
     */
    public function set dropEnabled(value:Boolean):void
    {
        if (_dropEnabled && !value)
        {
            removeEventListener(DragEvent.DRAG_ENTER, dragEnterHandler, false);
            removeEventListener(DragEvent.DRAG_EXIT, dragExitHandler, false);
            removeEventListener(DragEvent.DRAG_OVER, dragOverHandler, false);
            removeEventListener(DragEvent.DRAG_DROP, dragDropHandler, false);
        }

        _dropEnabled = value;

        if (value)
        {
            addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler, false,
                             EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_EXIT, dragExitHandler, false,
                             EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_OVER, dragOverHandler, false,
                             EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_DROP, dragDropHandler, false,
                             EventPriority.DEFAULT_HANDLER);
        }
    }

    //----------------------------------
    //  legendData
    //----------------------------------

    [Bindable("legendDataChanged")]
    [Inspectable(environment="none")]
    
    /**
     *  An array of Legend items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get legendData():Array /* of LegendData */
    {
        var keyItems:Array /* of LegendItem */ = [];
        
        var n:int = allElements.length;
        for (var i:int = 0; i < n; i++)
        {
            var s:Series = allElements[i] as Series;
            if (s)
                keyItems = keyItems.concat(s.legendData);
        }

        return keyItems;
    }

    //----------------------------------
    //  mouseSensitivity
    //----------------------------------
    
    private var _mouseSensitivity:Number = 5;
    
    /**
     *  Specifies the distance, in pixels, that Flex considers a data point
     *  to be under the mouse pointer when the pointer moves around a chart.
     *  Flex considers any data point less than <code>mouseSensitivity</code>
     *  pixels away to be under the mouse pointer.
     *  This value is also used by the <code>findDataPoints</code> method.
     *
     *  @default 5
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get mouseSensitivity():Number
    {
        return _mouseSensitivity;
    }
    public function set mouseSensitivity(value:Number):void
    {
        _mouseSensitivity = value;
    }

    //----------------------------------
    //  selectedChartItem
    //----------------------------------

    [Inspectable(category="Data")]

    /**
     *  Specifies the selected ChartItem in the chart. If multiple items are selected, 
     *  this property specifies the most recently selected item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedChartItem():ChartItem
    {
        if (_selectedSeries)
            return _selectedSeries.selectedItem;
        return null;
    }

    //----------------------------------
    //  selectedChartItems
    //----------------------------------

    [Inspectable(category="Data")]

    /**
     *  Specifies an array of all the selected ChartItem objects in the chart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectedChartItems():Array /* of ChartItem */
    {
        var arr:Array /* of ChartItem */ = [];
        
        var n:int = series.length;
        for (var i:int = 0; i < n; i++)
        {
            var m:int = series[i].selectedItems.length;
            for (var j:int = 0; j < m; j++)
            {
                arr.push(series[i].selectedItems[j])
            }
        }
                
        return arr;
    }
    
    //----------------------------------
    //  selectionMode
    //----------------------------------

    [Inspectable(category="General", enumeration="none,single,multiple", defaultValue="none")]

    /**
     *  Specifies whether or not ChartItem objects can be selected. Possible 
     *  values are <code>none</code>, <code>single</code>, or <code>multiple</code>.
     *  Set to <code>none</code> to prevent chart items from being selected. 
     *  Set to <code>single</code> to allow only one item to be selected at a time. 
     *  Set to <code>multiple</code> to allow one or more chart items to be selected at a time.
     *  
     *  <P>If you set this to <code>single</code> or <code>multiple</code>, you can override this on a 
     *  per-series basis by setting the value of the series' <code>selectable</code> property to <code>false</code>.
     *  If you set the value of the <code>selectionMode</code> property to <code>none</code>, then chart items will not be selectable, 
     *  regardless of the value of the series' <code>selectable</code> property.</P>
     *
     *  @default none
     *  
     *  @see mx.charts.ChartItem
     *  @see mx.charts.chartClasses.Series
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get selectionMode():String
    {
        return _selectionMode;
    }

    /**
     *  @private
     */
    public function set selectionMode(value:String):void
    {
        if (_selectionMode == value)
            return;
            
        _selectionMode = value;
        
        /*if (_selectionMode != "none")    
        {
            if (_mouseEventsInitialzed == false)
                setupMouseDispatching();
        }*/
        
        invalidateProperties();     
    }

    //----------------------------------
    //  series
    //----------------------------------

    [Inspectable(category="Data", arrayType="mx.charts.chartClasses.Series")]

    /**
     *  An array of Series objects that define the chart data.
     *  Each chart defines the type of Series objects
     *  that you use to populate this array.
     *  For example, a ColumnChart control expects ColumnSeries objects
     *  as part of this array.
     *  Some charts accept any object of type IChartElement2
     *  as part of the array, but in general each chart
     *  expects a specific type.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get series():Array /* of Series */
    {
        return _userSeries;
    }

    /**
     *  @private
     */
    public function set series(value:Array /* of Series */):void
    {
        value = value == null ? [] : value;
        _userSeries = value;
        
        var n:int = value.length;
        for (var i:int = 0; i < n; ++i)
        {
            if (value[i] is Series)
            {
                (value[i] as Series).owner = this;                
            }
        }
        
        invalidateSeries();
        invalidateData();
        legendDataChanged();
    }

    //----------------------------------
    //  seriesFilters
    //----------------------------------

    /**
     *  An array of filters that are applied to all series in the chart. 
     *  Assign an array of bitmap filters to this property to apply them to all the series at once. 
     *  Set the <code>seriesFilter</code> property to an empty array to clear the default 
     *  filters on the chart's series.
     *  Assigning filters to the <code>seriesFilters</code> property, which applies to all 
     *  series, is more efficient than assigning them to individual series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get seriesFilters():Array
    {
        return _seriesFilterer.filters;
    }
    
    /**
     *  @private
     */
    public function set seriesFilters(value:Array):void
    {
        _seriesFilterer.filters = value;
    }
    
    //----------------------------------
    //  showAllDataTips
    //----------------------------------

    [Inspectable(category="Data", defaultValue="false")]

    /**
     *  Specifies whether Flex shows all DataTip controls for the chart.
     *  DataTip controls are similar to tool tips,
     *  except that they display an appropriate value
     *  representing the chart data point.
     *  
     *  <p>Different chart elements might show different styles
     *  of DataTip controls.
     *  For example, a stacked chart element might show both the values
     *  of the column and the percentage that it contributes to the whole.</p>
     *
     *  <p>You can customize DataTip controls with the
     *  <code>dataTipFunction</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get showAllDataTips():Boolean
    {
        return _showAllDataTips;
    }

    /**
     *  @private
     */
    public function set showAllDataTips(value:Boolean):void
    {
        if (_showAllDataTips == value)
            return;
            
        _showAllDataTips = value;

        updateAllDataTips();
    }
    
    //----------------------------------
    //  showDataTips
    //----------------------------------

    [Inspectable(category="Data", defaultValue="false")]

    /**
     *  Specifies whether Flex shows DataTip controls for the chart.
     *  DataTip controls are similar to tool tips,
     *  except that they display an appropriate value
     *  that represents the nearest chart data point under the mouse pointer.
     *  
     *  <p>Different chart elements might show different styles
     *  of DataTip controls.
     *  For example, a stacked chart element might show both the values
     *  of the column and the percentage that it contributes to the whole.</p>
     *
     *  <p>You can customize DataTip controls with the
     *  <code>dataTipFunction</code> property.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get showDataTips():Boolean
    {
        return _showDataTips;
    }

    /**
     *  @private
     */
    public function set showDataTips(value:Boolean):void
    {
        if (_showDataTips == value)
            return;
            
        _showDataTips = value;

        if (_showDataTips)
        {
            if (_mouseEventsInitialzed == false)
                setupMouseDispatching();
        }

        updateDataTips();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Diagnostics
    //
    //--------------------------------------------------------------------------

    mx_internal function get allElementsArray():Array /* of ChartElement */
    {
        return allElements;
    }

    mx_internal function get labelElementsArray():Array /* of UIComponent */
    {
        return labelElements;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: EventDispatcher
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
    override public function addEventListener(
                                    type:String, listener:Function,
                                    useCapture:Boolean = false,
                                    priority:int = 0,
                                    useWeakReference:Boolean = false):void
    {
        if (_mouseEventsInitialzed == false &&
            ITEM_EVENTS[type] == true)
        {
            setupMouseDispatching();
        }

        super.addEventListener(type, listener, useCapture,
                               priority, useWeakReference);
    }
     */
    
	/**
     *  @private
     */
    private function initStyles():Boolean
    {
        HaloDefaults.init(styleManager);
		
		var chartBaseStyle:CSSStyleDeclaration = HaloDefaults.findStyleDeclaration(styleManager, "mx.charts.chartClasses.ChartBase");
		if (chartBaseStyle)
		{
			chartBaseStyle.setStyle("chartSeriesStyles", HaloDefaults.chartBaseChartSeriesStyles);
			chartBaseStyle.setStyle("fill", new SolidColor(0xFFFFFF, 0));
			chartBaseStyle.setStyle("calloutStroke", new SolidColorStroke(0x888888,2));
		}
		
        return true;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

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
    override public function invalidateSize():void
    {
        cancelEffect();

        super.invalidateSize();
    }
    
    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        _commitPropertiesCalled = true;

        super.commitProperties();

        if (_bSeriesDirty)
        {
            updateSeries();
            _selectedSeries = null;
            _bSeriesDirty = false;
        }

        updateSeriesStyles();

        if (_bDataDirty)
        {
            updateData();
            _bDataDirty = false;
        }
        
        if (_childOrderDirty)
        {
            updateChildOrder();
            _childOrderDirty = false;
        }

        if (_selectionMode != "none")    
        {
            if (_mouseEventsInitialzed == false)
                setupMouseDispatching();
            if (_rangeEventsInitialzed == false)
                setupRangeDispatching()
            tabEnabled = true;
        }
        else
        {
            tabEnabled = false;
            dragEnabled = false;
        }                       
    }

    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();

        measuredWidth = 400;
        measuredHeight = 400;
    }

    /**
     *  @private
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        // Since there are some scenarios where we might get
        // an updateDisplayList() before a commitProperties(),
        //  we need to guarantee it.
        if (_commitPropertiesCalled == false)
            commitProperties();
            
        graphics.clear();
        graphics.lineStyle(0, 0, 0);

        var fill:IFill = GraphicsUtilities.fillFromStyle(getStyle("fill"));

        GraphicsUtilities.fillRect(graphics, 0, 0,
            unscaledWidth, unscaledHeight, fill);
    }

    /**
     *  @inheritDoc
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function setActualSize(w:Number, h:Number):void
    {
        if (w != this.width || h != this.height)
            cancelEffect();
        
        super.setActualSize(w, h);
        updateDisplayList(w, h);
    }

    /**
     *  @private
     */
    override public function styleChanged(styleProp:String):void
    {
        if (styleProp == null || styleProp == "chartSeriesStyles")
            invalidateSeries();

        super.styleChanged(styleProp);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------


    /**
     *  Returns an array of HitData objects that describe
     *  the nearest data point to the coordinates passed to the method.
     *  The <code>x</code> and <code>y</code> arguments should be values
     *  in the coordinate system of the ChartBase object.
     *  <p>This method adheres to the limits specified by the
     *  <code>mouseSensitivity</code> property of the ChartBase object
     *  when looking for nearby data points.</p>
     *
     *  @param x The x coordinate relative to the ChartBase object.
     *  @param y The y coordinate relative to the ChartBase object.
     *
     *  @return An array of HitData objects.
     *  
     *  @see mx.charts.HitData
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function findDataPoints(x:Number, y:Number):Array /* of HitData */
    {
        var result:Array /* of HitData */ = [];
        
        if (dataRegion.contains(x, y) == false)
            return result;
            
        var n:int;
        var i:int;
        
        n = allElements.length;
        for (i = n-1; i >= 0; i--)
        {
            var g:IChartElement = allElements[i] as IChartElement;
            
            if (!g || g.visible == false)
                continue;
            
            var hds:Array /* of HitData */ = g.findDataPoints(x - _seriesHolder.x,
                                             y - _seriesHolder.y,
                                             mouseSensitivity);

            if (hds.length == 0)
                continue;
            
            result = result.concat(hds);
        }

        n = result.length;
        for (i = 0; i < n; i++)
        {
            result[i].x += _seriesHolder.x;
            result[i].y += _seriesHolder.y;
        }

        return result;
    }
    
    /**
     *  Returns an array of HitData objects representing the chart items
     *  in the underlying objects that implement the IChartElement2 interface.
     * 
     *  @return An array of HitData objects that represent the data points.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getAllDataPoints():Array /* of HitData */
    {
        var result:Array /* of HitData */ = [];    
        var n:int;
        var i:int;
        
        n = allElements.length;
        for (i = n-1; i >= 0; i--)
        {
            var g:IChartElement2 = allElements[i] as IChartElement2;
            
            if (!g || g.visible == false)
                continue;
            
            var hds:Array /* of HitData */ = g.getAllDataPoints();

            if (hds.length == 0)
                continue;
            
            result = result.concat(hds);
        }

        n = result.length;
        for (i = 0; i < n; i++)
        {
            result[i].x += _seriesHolder.x;
            result[i].y += _seriesHolder.y;
        }

        return result;
    }
    
    /**
     *  Gets all the chart items that are within the defined rectangular region.
     *  You call this method to determine what chart items are under
     *  a particular rectangular region.
     *  <p>Individual chart types determine whether their chart item is under the region.
     *  The point should be in the global coordinate space.</p>
     *  
     *  @param value The rectangular region.
     *  
     *  @return An array of ChartItem objects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     
    public function getItemsInRegion(value:Rectangle):Array /* of ChartItem */
    {
        var arrAllItems:Array /* of ChartItem */ = [];
 
        if (_transforms)
        {
            var n:int  = _transforms.length;
            for (var i:int = 0; i < n; i++)
            {
                arrAllItems = arrAllItems.concat(findItemsInRegionFromElements(_transforms[i],value));
            }
        }       
        return arrAllItems;
    }
    
    /**
     *  Gets the chart item next to the currently focused item in the chart, 
     * with respect to the axes. If no chart items are currently selected, 
     * then this method returns the first item in the first series.
     *  
     *  @param direction The direction in which the next item should be returned. Possible values
     *                   are <code>ChartBase.NAVIGATE_HORIZONTAL</code> and <code>ChartBase.NAVIGATE_VERTICAL</code>.
     *  @return The corresponding ChartItem object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     
    public function getNextItem(direction:String):ChartItem
    {
        return null;
    }

    /**
     *  Gets the chart item that is before the currently focused item in the chart, 
     *  with respect to the axes. If no chart items are currently selected,
     *  then this method returns the first item in the first series.
     *  
     *  @param direction The direction in which the previous item should be returned. Possible values
     *                   are <code>ChartBase.NAVIGATE_HORIZONTAL</code> and <code>ChartBase.NAVIGATE_VERTICAL</code>.
     *  @return The corresponding ChartItem object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     
    public function getPreviousItem(direction:String):ChartItem
    {
        return null;    
    }
    
    /**
     *  Gets the first item in the chart, with respect to the axes.
     *  
     *  @param direction The direction in which the first item should be returned. Possible values
     *                   are <code>ChartBase.NAVIGATE_HORIZONTAL</code> and <code>ChartBase.NAVIGATE_VERTICAL</code>.
     *  @return The corresponding ChartItem object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     
    public function getFirstItem(direction:String):ChartItem
    {
        return null;
    }

    /**
     *  Gets the last chart item in the chart, with respect to the axes.
     *
     *  @param direction The direction in which the last item should be returned. Possible values
     *                   are <code>ChartBase.NAVIGATE_HORIZONTAL</code> and <code>ChartBase.NAVIGATE_VERTICAL</code>.
     *  @return The corresponding ChartItem object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     
    public function getLastItem(direction:String):ChartItem
    {
        return null;    
    }

    
    /**
     *  Dispatches a new LegendDataChanged event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function legendDataChanged():void
    {
        dispatchEvent(new Event("legendDataChanged"));
    }

    /**
     *  Informs the chart that the underlying data displayed in the chart 
     *  has been changed. 
     *  Chart series and elements call this function when their rendering has 
     *  changed in order to trigger a coordinated execution of show and hide data effects. 
     *  You typically do not call this method on the chart directly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function hideData():void
    {
        /*
        if (_transitionEffect)
        {
            setChartState(ChartState.NONE);
            _transitionEffect.end();
            _transitionEffect = null;
        }
        */
        setChartState(ChartState.PREPARING_TO_HIDE_DATA);
    }

    /**
     *  Triggers a redraw of the chart.
     *  Call this method when you change the style properties
     *  of the chart's series.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function invalidateSeriesStyles():void
    {
        if (!_seriesStylesDirty)
        {
            _seriesStylesDirty = true;

            invalidateProperties();
        }
    }
    
    /**
     *  Informs the chart that its series array was modified and 
     *  should be reprocessed. Derived chart classes can call this method to trigger a 
     *  call to the chart's internal <code>updateSeries()</code> method on the next <code>commitProperties()</code> cycle.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function invalidateSeries():void
    {
        if (_bSeriesDirty == false)
        {
            _bSeriesDirty = true;

            invalidateProperties();
            invalidateDisplayList();
        }
    }
    
    /**
     *  Informs the chart that its child list was modified and should be reordererd. 
     *  Derived chart classes can call this method to trigger a call to the chart's internal 
     *  <code>updateChildOrder()</code> method on the next <code>commitProperties()</code> cycle.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function invalidateChildOrder():void
    {
        if (_childOrderDirty == false)
        {
            _childOrderDirty = true;

            invalidateProperties();
        }
    }

    /**
     *  @private
     */
    private function cancelEffect():void
    {
        /*
        if (_transitionEffect)
        {
            _transitionEffect.end();
            _transitionEffect = null;
        }
        */

        setChartState(ChartState.NONE);
    }

    /**
     *  @private
     */
    protected function advanceEffectState():void
    {
        /*
        var p:Parallel;
        var transitionChildren:Array;
        var i:int;
        var n:int;

        if (_transitionState == ChartState.PREPARING_TO_HIDE_DATA)
        {
            transitionChildren = collectTransitions();
            
            if (transitionChildren.length == 0)
            {
                setChartState(ChartState.PREPARING_TO_SHOW_DATA);
            }
            else
            {
                setChartState(ChartState.HIDING_DATA);

                p = new Parallel();

                _transitionEffect = ParallelInstance(p.createInstance());

                n = transitionChildren.length;
                for (i = 0; i < n; i++)
                {
                    _transitionEffect.addChildSet([transitionChildren[i]]);
                }

                _transitionEffect.addEventListener(EffectEvent.EFFECT_END,
                                                   dataEffectEndHandler);

                _transitionEffect.play();
            }
        }

        if (_transitionState == ChartState.PREPARING_TO_SHOW_DATA)
        {
            transitionChildren = collectTransitions();
            
            if (transitionChildren.length == 0)
            {
                setChartState(ChartState.NONE);
            }
            else
            {
                setChartState(ChartState.SHOWING_DATA);

                p = new Parallel();

                _transitionEffect = ParallelInstance(p.createInstance());

                n = transitionChildren.length;
                for (i = 0; i < n; i++)
                {
                    _transitionEffect.addChildSet([transitionChildren[i]]);
                }

                _transitionEffect.addEventListener(EffectEvent.EFFECT_END,
                                                   dataEffectEndHandler);

                _transitionEffect.play();

            }
        }
        */
        invalidateDisplayList();
    }

    /**
     *  @private
     */
    private function setupMouseDispatching():void
    {
        _mouseEventsInitialzed = true;

        super.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        super.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        super.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
        super.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        super.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        super.addEventListener(MouseEvent.CLICK, mouseClickHandler);
        super.addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClickHandler);
    }

   /**
     *  @private
     */
    private function setupRangeDispatching():void
    {
        _rangeEventsInitialzed = true;
        addEventListener(RangeEvent.REGION_CHANGE, regionChangeHandler);
    }
    
    /**
     *  @private
     */
    private function processRollEvents(hitSet:Array /* of HitData */, event:MouseEvent):void
    {
        var removedSet:Array /* of HitData */ = [];
        var addedSet:Array /* of HitData */ = [];
        var unchangedSet:Array /* of HitData */ = [];
        var newLen:int = hitSet.length;
        var oldLen:int = _currentHitSet.length;
        var oldIndex:int = 0;
        var newIndex:int = 0;
        
        var pt:Point = null;
    
        if (hitSet.length == 0 && _currentHitSet.length == 0)
        {
            if (_selectionMode == "single" && event.type == MouseEvent.MOUSE_DOWN)
            {
                clearSelection();
                return;
            }
            else if (_selectionMode == "multiple" && event.type == MouseEvent.MOUSE_DOWN)
            {
                startTracking(event);
                return;
            }
            return;
        }
        
        var sortingSet:Array /* of HitData */ = hitSet.concat();
        if (newLen > 1)
            sortingSet.sortOn("id", Array.NUMERIC);
                    
        while (oldIndex < oldLen || newIndex < newLen)
        {
            if (newIndex == newLen ||
                (oldIndex < oldLen &&
                 _currentHitSet[oldIndex].id < sortingSet[newIndex].id))
            {
                removedSet.push(_currentHitSet[oldIndex]);
                oldIndex++;
            } 
            else if (oldIndex == oldLen ||
                     (newIndex < newLen &&
                      _currentHitSet[oldIndex].id > sortingSet[newIndex].id))
            {
                addedSet.push(sortingSet[newIndex]);
                newIndex++;
            }
            else
            {
                unchangedSet.push(sortingSet[newIndex]);
                newIndex++;
                oldIndex++;
            }
        }
        
        if (removedSet.length > 0)
        {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_ROLL_OUT,
                                             removedSet, event, this));
        }
        
        if (addedSet.length > 0)
        {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_ROLL_OVER,
                                             addedSet, event, this));
        }
        
        if (unchangedSet.length > 0)
        {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_MOUSE_MOVE,
                                             unchangedSet, event, this));                                    
        }
        
        if (event.type == MouseEvent.MOUSE_DOWN)
        {
            /*
            if (_dragEnabled && !DragManager.isDragging)
            {
                _mouseDown = true;
                pt = new Point(event.localX, event.localY);
                pt = UIComponent(event.target).localToGlobal(pt);
                _mouseDownPoint = globalToLocal(pt);
                _mouseDownItem = hitSet[0].chartItem;
            }
            else */if (hitSet.length > 0) // If dragEnabled is true, selection change happens on mouseup as items will get deselected.
                selectItem(hitSet[0].chartItem,event);
        }
       
        if (event.type == MouseEvent.MOUSE_UP)
        {
            /*
            if (_dragEnabled && _mouseDown && !DragManager.isDragging)
                selectItem(_mouseDownItem,event);
            */    
            _mouseDown = false;
            _mouseDownPoint = null;
            _mouseDownItem = null;
        }
        
        if (event.type != MouseEvent.MOUSE_DOWN && event.type != MouseEvent.MOUSE_UP)
        {
            //if (!(DragManager.isDragging))
                rollOverItem(hitSet,removedSet);
        }
        
        if (event.type == MouseEvent.MOUSE_MOVE)
        {
            pt = new Point(event.localX, event.localY);
            pt = UIComponent(event.target).localToGlobal(pt);
            pt = globalToLocal(pt);

            /*
            if (_dragEnabled && _mouseDown && !DragManager.isDragging && (Math.abs(_mouseDownPoint.x - pt.x) > DRAG_THRESHOLD || Math.abs(_mouseDownPoint.y - pt.y) > DRAG_THRESHOLD))
            {
                // check whether the mousedown item is selected or not.
                var seriesObject:Series = Series(_mouseDownItem.element);
                if (seriesObject.selectedItems.indexOf(_mouseDownItem) == -1)
                    selectItem(_mouseDownItem,event);
                
                if (_selectedSeries) // if atleast one item is selected, then only drag
                {   
                    var mousePt:Point = localToGlobal(_mouseDownPoint);
                    mousePt = _selectedSeries.globalToLocal(mousePt);
                    var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_START);
                    dragEvent.dragInitiator = this;
                    dragEvent.localX = mousePt.x;
                    dragEvent.localY = mousePt.y;
                    dragEvent.buttonDown = true;
                    _selectedSeries.dispatchEvent(dragEvent);
                }
            }
            */
        }
  
        _currentHitSet = hitSet;
        
        // Do not show datatips when drag is happening as drag image will not be having datatip
        /*if (_dragEnabled && _mouseDown && DragManager.isDragging)
            updateDataTipToMatchHitSet([]);
        else*/
            updateDataTipToMatchHitSet(_currentHitSet);        
    }

   /**
    *  @private
    */    
   mx_internal function rollOverItem(hitSet:Array /* of HitData */,removedSet:Array /* of HitData */):void
   {
        var data:HitData = null;
        var seriesObject:Series = null;
        var index:int = 0;
        
        // Set the first item in the hitset to roll over - as per datatip logic.
        if (hitSet.length > 0)
        {
            data = hitSet[0];
            if (_selectionMode != "none" && Series(data.chartItem.element).selectable)
                data.chartItem.currentState = ChartItem.ROLLOVER;
        }  
        
        // removedset also can be set when hitset is set
        if (removedSet.length > 0)
        {
            var n: int = removedSet.length;
            // we do not know which item has rollover hence loop through all removed set
            for (var i:int = 0; i < n; i++) 
            {
                data = removedSet[i];
                seriesObject = Series(data.chartItem.element);
                if (seriesObject.selectable) // handle for those series, which are selectable
                {
                    index = seriesObject.selectedItems.indexOf(data.chartItem);
                    if (index == -1) // item not selected in the series
                    {
                        if (!_selectedSeries)
                            data.chartItem.currentState = ChartItem.NONE;
                        else
                            data.chartItem.currentState = ChartItem.DISABLED;
                    }
                    else // item is selected in the series
                    {
                        data.chartItem.currentState = ChartItem.SELECTED;
                    }
                }
            }
        }
    }

   /**
    *  @private
    */
     
   mx_internal function selectItem(item:ChartItem, event:MouseEvent):void
   {
        var seriesObject:Series = null;
        var bSelectionChanged:Boolean = false;
        var bAddToSelection:Boolean = false;
        var index:int = -1;
        
        seriesObject = Series(item.element);
            
        if (_selectionMode == "multiple" && event.shiftKey && _anchorItem)
        {
            handleShift(item);
            bSelectionChanged = true;
            // now make data.chartItem as the last item in that series to get selected.
            // if that is selectable otherwise take the selected series
            if (seriesObject.selectedItems.length > 1)
            {
                var id:int = seriesObject.selectedItems.indexOf(item);
                seriesObject.selectedItems.splice(id,1);
                seriesObject.selectedItems.push(item);
                _selectedSeries = seriesObject;
            }               
        }
        else
        if (_selectionMode != "none" && seriesObject.selectable)
        {
            // If the item is selected
            if (seriesObject.selectedItems.indexOf(item) == -1) 
                bAddToSelection = true;
                    
            if (bAddToSelection)
            {
                if (!_selectedSeries)
                    setChartItemsToDisabled();
                else
                {   
                    if (_selectionMode == "single")
                    {
                        // if multiple selection was enabled earlier and now its single check that.
                        if (selectedChartItems.length > 1)   
                        {
                            clearSelection();
                            setChartItemsToDisabled();
                        }
                        else
                            _selectedSeries.removeItemfromSelection(_selectedSeries.selectedItem);
                    }
                    else if (!event.ctrlKey)
                    {
                        clearSelection();
                        setChartItemsToDisabled();
                    }
                }
                seriesObject.addItemtoSelection(item);
                _selectedSeries = seriesObject; 
                
                bSelectionChanged = true;           
            }
            else
            {
                if (_selectionMode == "multiple")
                {
                    if (event.ctrlKey) // remove this item from selection
                    {
                        seriesObject.removeItemfromSelection(item);
                        if (_selectedSeries.selectedItems.length == 0)
                        {
                            var nextSeries:Series = seriesObject;
                            nextSeries = getSelectedSeries(seriesObject);
                        
                            if (!nextSeries) // This was the only item selected
                                clearSelection(); 
                            else
                                _selectedSeries = nextSeries;
                        }
                        bSelectionChanged = true;
                    }
                    else // clear all others except this
                    {
                        // if this is the same item as the only selected item - do nothing.
                        if (seriesObject == _selectedSeries && !(getSelectedSeries(seriesObject)) && _selectedSeries.selectedItems.length == 1)
                            bSelectionChanged = false;
                        else
                        {
                            clearSelection();
                            setChartItemsToDisabled();
    
                            seriesObject.addItemtoSelection(item);
                            _selectedSeries = seriesObject;
                            bSelectionChanged = true;
                        }
                    }
                    // As the mouse is over that item, but the item is selected                 
                    item.currentState = ChartItem.ROLLOVER; 
                }
                else // If the selection mode is single, just change the selected series
                {
                    if (selectedChartItems.length > 1)
                    {
                        clearSelection();                  
                        seriesObject.addItemtoSelection(item);
                    }
                    _selectedSeries = seriesObject;
                }
            }       
        }
        
       if (bSelectionChanged)
       {
            if (_selectedSeries)
            {
                if (_caretItem) // caret item could have been selected as part of keyboard, clear that.
                {
                    if (Series(_caretItem.element).selectedItems.indexOf(_caretItem) != -1)
                        _caretItem.currentState = ChartItem.SELECTED;
                    else
                        _caretItem.currentState = ChartItem.DISABLED;
                }
                    
                _caretItem = _selectedSeries.selectedItem;
                _caretItem.currentState = ChartItem.FOCUSEDSELECTED;
                if (!_anchorItem || !event.shiftKey)
                    _anchorItem = _caretItem;
            }
            dispatchEvent(new ChartItemEvent(ChartItemEvent.CHANGE,null,event,this));    
       }
   }
   
  /**
    *  @private
    */
     
   mx_internal function getSelectedSeries(seriesObject:Series):Series
   {    
        var n:int  = _transforms.length;
        for (var i:int = 0; i < n; i++)
        {
            var m:int = _transforms[i].elements.length;
            for (var j:int = 0; j < m; j++)
            {
                if (_transforms[i].elements[j] is Series && _transforms[i].elements[j] != seriesObject && _transforms[i].elements[j].selectedItems.length != 0)
                    return _transforms[i].elements[j];
            }
        }
        
        return null;
    }

  /**
    *  @private
    */
     
   mx_internal function setChartItemsToDisabled():void
   {
        var n:int = _transforms.length;
        for (var i:int = 0; i < n; i++)
        {           
            var m:int = _transforms[i].elements.length;
            for (var j:int = 0; j < m; j++)
            {
                if (_transforms[i].elements[j] is Series)
                    _transforms[i].elements[j].clearSeriesItemsState(false,ChartItem.DISABLED); 
            }
        }
    }
  
   /**
     *  Deselects all selected chart items in the chart control. Sets the <code>currentState</code> property of all chart items in the 
     *  chart to <code>none</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
     
   public function clearSelection():void
   {
        if (_selectedSeries)
        {
            var n:int  = _transforms.length;
            for (var i:int = 0; i < n; i++)
            {
                var m:int = _transforms[i].elements.length;
                for (var j:int = 0; j < m; j++)
                {
                    if (_transforms[i].elements[j] is Series)
                        _transforms[i].elements[j].clearSeriesItemsState(true);
                }
            }
                
            _selectedSeries = null;
            _caretItem = null;
            _anchorItem = null;
        }
   }

    /**
     *  @private
     */
     
    mx_internal function selectSpecificChartItems(arrItems:Array /* of ChartItem */):void
    {
        var seriesObject:Series = null;
        var item:ChartItem = null;
        var index:int = -1;
        var bDisabled:Boolean = false;
        
        // clear all
        clearSelection();
        
        var n:int = arrItems.length;    
        for (var i:int = 0; i < n; i++)
        {
            seriesObject = Series(arrItems[i].element);             
            if (seriesObject.selectable) 
            {
                if (!bDisabled) // set items to disabled, only if there are items to be selected
                {
                    bDisabled = true;
                    setChartItemsToDisabled();
                }
                // if an item is already selected - deselect that and selct this item
                if (_selectionMode == "single" && _selectedSeries)
                    _selectedSeries.removeItemfromSelection(_selectedSeries.selectedItem);
                
                if (seriesObject.selectedItems.indexOf(arrItems[i]) == -1)
                    seriesObject.addItemtoSelection(arrItems[i]);
                _selectedSeries = seriesObject;
            }
        }
        
        if (_selectedSeries)
        {
            _caretItem = _selectedSeries.selectedItem;
            _caretItem.currentState = ChartItem.FOCUSEDSELECTED;
            _anchorItem = _caretItem;
        }
    }
    
     /**
     *  @private
     */
     
    mx_internal function seriesSelectionChanged(seriesObject:Series,arrItems:Array /* of ChartItem */):void
    {
        var nextSeries:Series = null;
        
        if (_selectionMode == "none")
            return;
        
        // if nothing is selected, disable all.
        if (!_selectedSeries)
            setChartItemsToDisabled();
        else
            seriesObject.clearSeriesItemsState(true,ChartItem.DISABLED);
            
        if (arrItems.length == 0)
        {
            // Is any other series selected
            nextSeries = getSelectedSeries(seriesObject);
            if (!nextSeries)
                clearSelection();
            else
                _selectedSeries = nextSeries;
        }
        else
        {
            if (_selectionMode == "single")
            {
                if (_selectedSeries && _selectedSeries != seriesObject)
                    _selectedSeries.removeItemfromSelection(_selectedSeries.selectedItem);
                seriesObject.addItemtoSelection(arrItems[arrItems.length - 1]); 
            }
            else
            {
                var n:int = arrItems.length;
                for (var i:int = 0; i < n; i++)
                {
                    seriesObject.addItemtoSelection(arrItems[i]);
                }
            }
            
            _selectedSeries = seriesObject;
        }
        
        if (_selectedSeries)
        {
            _caretItem = _selectedSeries.selectedItem;
            _caretItem.currentState = ChartItem.FOCUSEDSELECTED;
            _anchorItem = _caretItem;
        }                                                                           
    }
    
    /**
     *  @private
     */
     mx_internal function handleSpace(event:KeyboardEvent):void
     {
        // select or deselect the caret item depending upon the ctrl key
        if (!_caretItem)
            return;
        
        var caretSeries:Series;
        var bSelectionChanged:Boolean = false;
        var bControl:Boolean = false;
        var bShift:Boolean = false;
        
        if (event.ctrlKey)
            bControl = true;
        
        if (event.shiftKey) // Shift takes precedence over control. But Shift will behave same as normal case.
        {
            bShift = true;
            bControl = false;
        }
            
        caretSeries = Series(_caretItem.element);
        
        if (caretSeries.selectable)
        {
            if (caretSeries.selectedItems.indexOf(_caretItem) != -1) // already selected
            {
                if (bControl) // now deselect that
                {
                    caretSeries.removeItemfromSelection(_caretItem);
                    _caretItem.currentState = ChartItem.FOCUSED;
                    
                    if (selectionMode == "single")
                        clearSelection();
                    else if (_selectedSeries.selectedItems.length == 0) // more items from other series are there
                    {
                        var nextSeries:Series = caretSeries;
                        nextSeries = getSelectedSeries(caretSeries);
                        if (!nextSeries) // This was the only item selected
                            clearSelection(); 
                        else
                            _selectedSeries = nextSeries;
                    }
                    bSelectionChanged = true;
                }
            }
            else // not selected, select that
            {
                if (_selectionMode == "single" || (_selectionMode == "multiple" && !bControl))
                {
                    var item:ChartItem = _caretItem;
                    clearSelection();  
                    _caretItem = item;
                    _anchorItem = item;
                }
                
                if (!_selectedSeries) // nothing is selected
                    setChartItemsToDisabled();
                    
                _selectedSeries = caretSeries;
                _selectedSeries.addItemtoSelection(_caretItem);
                _caretItem.currentState = ChartItem.FOCUSEDSELECTED;
                bSelectionChanged = true;
            }
        }
        
        if (bSelectionChanged)
        {
            if (_selectedSeries && (!bShift || !_anchorItem))
                _anchorItem = _selectedSeries.selectedItem;
            dispatchEvent(new ChartItemEvent(ChartItemEvent.CHANGE,null,null,this));
        }
     }
     
    /**
     *  @private
     */
    mx_internal function handleNavigation(item:ChartItem,event:KeyboardEvent):void
    {
        var seriesObject:Series;
        var caretSeriesObject:Series;
        var bSelectionChanged:Boolean = false;
        var bControl:Boolean = false;
        var bShift:Boolean = false;
        
        seriesObject = Series(item.element);
        
        if (event.ctrlKey)
            bControl = true;
        
        if (event.shiftKey) // Shift takes precedence over control.
        {
            bShift = true;
            bControl = false;
        }
            
        if (bControl) // Do not change the selection but change the highlight
        {
            if (_caretItem)
            {
                var caretSeries:Series;
                caretSeries = Series(_caretItem.element);
                if (caretSeries.selectable)
                {
                    if (caretSeries.selectedItems.indexOf(_caretItem) != -1)
                        _caretItem.currentState = ChartItem.SELECTED
                    else if (_selectedSeries)
                            _caretItem.currentState = ChartItem.DISABLED;
                        else
                            _caretItem.currentState = ChartItem.NONE;
                }
            }
            item.currentState = ChartItem.FOCUSED;
        }
        else // Change the selection
        {
            if (!bShift || !_anchorItem)
            {
                if (!_selectedSeries)
                    setChartItemsToDisabled();
                else
                    if (selectionMode == "single")
                        _selectedSeries.removeItemfromSelection(_selectedSeries.selectedItem);
                    else
                    {
                        clearSelection();
                        setChartItemsToDisabled();
                    }
                        
                seriesObject.addItemtoSelection(item);
                _selectedSeries = seriesObject;
                item.currentState = ChartItem.FOCUSEDSELECTED;
            }
            else // select the item under shift, _selectedSeries should not be null.
            {
                if (selectionMode == "single")
                {
                    _selectedSeries.removeItemfromSelection(_selectedSeries.selectedItem);
                    seriesObject.addItemtoSelection(item);
                }
                else // clear all except the anchor item and select range from anchor to item.
                {
                    var tempItem:ChartItem = _anchorItem;
                    var index1:int = Series(_anchorItem.element).items.indexOf(_anchorItem);
                    var index2:int = seriesObject.items.indexOf(item);
                    var temp:int;

                    clearSelection();
                    setChartItemsToDisabled();                  
                    _anchorItem = tempItem;
                    
                    // With current behavior anchor and item should be from the same series for range selection.
                    if (Series(_anchorItem.element) == seriesObject)
                    {
                        if (index1 > index2)
                        {
                            temp = index1;
                            index1 = index2;
                            index2 = temp;
                        }
                        for (temp = index1; temp <= index2; temp++)
                        {
                            seriesObject.addItemtoSelection(seriesObject.items[temp]);
                        }
                    }
                    else
                    {
                        Series(_anchorItem.element).addItemtoSelection(_anchorItem);
                        seriesObject.addItemtoSelection(item);
                    }
                }
                _selectedSeries = seriesObject;
                item.currentState = ChartItem.FOCUSEDSELECTED;
            }
            bSelectionChanged = true;
        }
        
        _caretItem = item;
        
        if (bSelectionChanged && _selectedSeries)
        {
            if (!bShift || (_selectedSeries && !_anchorItem)) // This can happen when nothing is selected and shift is pressed
                _anchorItem = _selectedSeries.selectedItem; 
            dispatchEvent(new ChartItemEvent(ChartItemEvent.CHANGE,null,null,this));
        }
    }

    /**
     *  @private
     */
     mx_internal function handleShift(item:ChartItem):void
     {
        // is called only when anchor item is not null 
        // leverage the region selection algo for handling shift - but it resets the anchor and caret items. 
        var tempItem:ChartItem = _anchorItem;  
        var tempCaretItem:ChartItem = _caretItem;       
        
        if (!(_anchorItem.itemRenderer) || !(item.itemRenderer))
            return;
            
        var rc:Rectangle = new Rectangle;
        var pt1:Point = new Point(_anchorItem.itemRenderer.x ,_anchorItem.itemRenderer.y);
        var pt2:Point = new Point(item.itemRenderer.x ,item.itemRenderer.y);
        var arrItems:Array /* of ChartItem */;
        var pt:Point;
        
        pt1 = Series(_anchorItem.element).localToGlobal(pt1);
        pt2 = Series(item.element).localToGlobal(pt2);
        
        
        rc.left = Math.min(pt1.x, pt2.x,pt1.x + _anchorItem.itemRenderer.width, pt2.x + item.itemRenderer.width);
        rc.top = Math.min(pt1.y, pt2.y,pt1.y + _anchorItem.itemRenderer.height, pt2.y + item.itemRenderer.height);
        
        rc.right = Math.max(pt1.x, pt2.x,pt1.x + _anchorItem.itemRenderer.width, pt2.x + item.itemRenderer.width);
        rc.bottom = Math.max(pt1.y, pt2.y,pt1.y + _anchorItem.itemRenderer.height, pt2.y + item.itemRenderer.height);
        
        // Make sure we relax the bounds a little bit, otherwise neighbors can get selected
        rc.left = rc.left + 2;
        rc.top  = rc.top + 2;
        rc.right = rc.right - 2;
        rc.bottom = rc.bottom - 2;
        
        selectRectangleRegion(rc);
        
        // restore anchor item and caret item
        _anchorItem = tempItem;
        _caretItem = tempCaretItem;
     }
    
    /**
     *  @private
     */
     private function selectRectangleRegion(r:Rectangle, bPreserveSelection:Boolean = false):void
     {
        var arrItems:Array /* of ChartItem */ = getItemsInRegion(r);

        if (bPreserveSelection)
            arrItems = arrItems.concat(selectedChartItems);
                        
        selectSpecificChartItems(arrItems);
     }
     
    /**
     *  @private
     */
     
    mx_internal function getSeriesTransformState(seriesObject:Object):Boolean
    {
        return (seriesObject as Series).getTransformState();
    }

    /**
     *  @private
     */
    private function findItemsInRegionFromElements(transform:DataTransform,value:Rectangle):Array /* of ChartItem */
    {
        var elements:Array /* of ChartElement */ = transform.elements;
        var arrItems:Array /* of ChartItem */ = [];
        var n:int = elements.length;
        for (var i:int = 0; i < n; i++)
        {
            if (elements[i] is Series && elements[i].selectable && elements[i].visible)
                arrItems = arrItems.concat(elements[i].getItemsInRegion(value));
        }
        return arrItems;
    }
           
    /**
     *  @private
     */
    private function updateDataTips():void
    {
        var hitPoints:Array /* of HitData */ = findDataPoints(mouseX, mouseY);
        _currentHitSet = hitPoints;

        updateDataTipToMatchHitSet(_currentHitSet);
    }
    
    /**
     *  Displays all noninteractive data tips
     *  if <code>showAllDataTips</code> is set.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function updateAllDataTips():void
    {
        var hitSet:Array /* of HitData */;
        
        if (!showAllDataTips && !dataTipItemsSet)
            hitSet = [];
        else
            hitSet = getAllDataPoints();        
            
        var tipCount:Number = hitSet.length;
        
        if (tipCount == 0)
        {
            if (_allTipCache)
                _allTipCache.count = 0;
        }
        else
        {
            if (!_allTipCache)
            {
                var tipClass:* = getStyle("dataTipRenderer");
                _allTipCache = new InstanceCache(tipClass, this, -1, moduleFactory);
                _allTipCache.discard = true;                              
                _allTipCache.remove = true;

            }
            _allTipCache.count = tipCount;

            for (var i:int = 0; i < tipCount; i++)
            {
                var currentHitData:HitData = hitSet[i];
                
                var tipInstance:IFlexDisplayObject  = _allTipCache.instances[i];
                
                if (dataTipFunction != null)
                    currentHitData.dataTipFunction = invokeDTFunction;
    
                if (tipInstance is IDataRenderer)
                    (tipInstance as IDataRenderer).data = currentHitData;
            }
        }

        positionAllDataTips(hitSet);
    }

    /**
     *  @private
     */
    private function updateDataTipToMatchHitSet(hitSet:Array /* of HitData */):void
    {
        var tipCount:Number;
        
        if (_showDataTips == false)
        {
            tipCount = 0;
        }
        else if (_dataTipMode == "multiple")    
        {
            tipCount= getStyle("maximumDataTipCount");
            if (isNaN(tipCount))
                tipCount = hitSet.length;   
            else
                tipCount = Math.min(tipCount, hitSet.length);
        }
        else // "single"
        {
            tipCount = Math.min(hitSet.length, 1);
        }
        
        if (tipCount == 0)
        {
            if (_tipCache)
                _tipCache.count = 0;
        }
        else
        {
            if (!_tipCache)
            {
                var tipClass:* = getStyle("dataTipRenderer");
                _tipCache = new InstanceCache(tipClass,
                                              systemManager/*.toolTipChildren*/, -1, moduleFactory);
                _tipCache.discard = true;                              
                _tipCache.remove = true;
                _tipCache.creationCallback = tipCreated;

            }
            _tipCache.count = tipCount;

            for (var i:int = 0; i < tipCount; i++)
            {
                var currentHitData:HitData = hitSet[i];
                
                var tipInstance:IFlexDisplayObject  = _tipCache.instances[i];
                
                if (dataTipFunction != null)
                    currentHitData.dataTipFunction = invokeDTFunction;
    
                if (tipInstance is IDataRenderer)
                    (tipInstance as IDataRenderer).data = currentHitData;
            }
        }

        positionDataTips();
    }
    
    /**
     *  @private
     */
    private function tipCreated(tip:IEventDispatcher, cache:InstanceCache):void
    {
        tip.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
        tip.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        tip.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
    }

    /**
     *  @private
     */
    private function invokeDTFunction(hd:HitData):String
    {
        return dataTipFunction(hd);
    }

    /**
     *  Defines the locations of DataTip objects on the chart when the
     *  <code>showAllDataTips</code> property is set to <code>true</code>.
     *  This method ensures that DataTips do not overlap each other
     *  (if multiple DataTips are visible) or overlap their target data items.
     *  
     *  @param hitSet An Array of HitData objects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function positionAllDataTips(hitSet:Array /* of HitData */):void
    {
        var tipCount:int = _allTipCache ? _allTipCache.count:0;
        var rc:Rectangle = dataRegion;
        var g:Graphics = _allDataTipOverlay.graphics;
        var pData:Array /* of TipPositionData */;
        var pLeft:Array /* of TipPositionData */ = [];
        var pRight:Array /* of TipPositionData */ = [];
        var sortList:Array /* of TipPositionData */ = [];
        var i:int;
        var data:TipPositionData;
        var minX:Number;
        var maxX:Number;
        var len:int;
        var stacks:Array /* of TipStack */;
        var currentStack:TipStack;
        var calloutStroke:IStroke = getStyle("calloutStroke");
        var dataTipHOffset:Number = getStyle("horizontalDataTipOffset");
        var dataTipVOffset:Number = getStyle("horizontalDataTipOffset");
        
        if (isNaN(dataTipHOffset))
            dataTipHOffset = 6;
        if (isNaN(dataTipVOffset))
            dataTipVOffset = 6;
        
        g.clear();

        if (tipCount == 0)
            return;
            
        var showTargetValue:Object = getStyle("showDataTipTargets");
        var showTarget:Boolean = showTargetValue != false &&
                                 showTargetValue != "false";
        
        pData = _allTipCache.instances.slice(0, tipCount);
        var localPts:Point = new Point();

        for (i = 0; i < tipCount; i++)
        {
            var hitData:HitData = hitSet[i];
            var tipInstance:IFlexDisplayObject = pData[i];

            localPts.x = Math.max(rc.left, Math.min(hitData.x, rc.right));
            localPts.y = Math.max(rc.top, Math.min(hitData.y, rc.bottom));
            var pts:Point = localToGlobal(localPts);
            
            var xpos:Number;
            var ypos:Number;

            if (tipInstance is ILayoutManagerClient)
                ILayoutManagerClient (tipInstance).validateSize();
            
            data = new TipPositionData(tipInstance, hitData,
                                       localPts.x, localPts.y, pts.x, pts.y);
                        
            if (data.gy - dataTipVOffset - tipInstance.measuredHeight > 0)
                data.py = data.gy - dataTipVOffset - tipInstance.measuredHeight;
            else                        
                data.py = data.gy + dataTipVOffset;

            sortList.push(data);
            pData[i] = data;
        }
        
        if (sortList.length > 0)
        {
            sortList.sortOn("gx", Array.NUMERIC);
            
            minX = sortList[0].gx;
            maxX = sortList[sortList.length - 1].gx;
            
            var screenTL:Point = new Point(4, 4);
            var screenBR:Point = new Point(screen.width - 4, screen.height - 4);
            
            i = 0;

            // This code pre-examines the datatips for tips that would
            // stick out off screen, and forces them to flip to the other side.
            // While this gets datatips that don't stick off screen and don't
            // overlap the points, it makes for some fantastically unattractive
            // datatip layouts.
            // So for now I'm opting for the prettier but occasionally slightly
            // annoying behavior of sliding tips over until they don't stick
            // off screen, potentially overlapping the points.
            /*          
            while (i < sortList.length)
            {
                data = sortList[i];         
                if (maxX + dataTipHOffset + tipInstance.measuredWidth >
                    screenBR.x) 
                {
                    pLeft.push(data);
                    sortList.splice(i, 1);
                }
                else if (minX - dataTipHOffset - tipInstance.measuredWidth <
                         screenTL.x) 
                {
                    pRight.push(data);
                    sortList.splice(i ,1);
                }
                else
                {
                    i++;
                }
            }
            */
            
            var splitPoint:int = Math.floor(sortList.length / 2);

            // As a first approximation, we just divide these in half.
            // But our goal is to end up with an even set of left/right stacks.
            // So if we already have items in those stacks,
            // let's adjust our split.
            if (pLeft.length > pRight.length)
            {
                splitPoint = Math.max(0, splitPoint -
                                      (pLeft.length - pRight.length));
            }
            else if (pRight.length > pLeft.length)
            {
                splitPoint = Math.min(sortList.length,
                                      splitPoint +
                                      (pRight.length - pLeft.length));
            }

            pLeft = pLeft.concat(sortList.slice(0, splitPoint));
            pRight = pRight.concat(sortList.slice(splitPoint, sortList.length));
        }
                
        pRight.sortOn("gy");
        len = pRight.length;
        stacks = [];
        currentStack = null;

        for (i = 0; i < len; i++)
        {           
            data = pRight[i];
            data.isRight = true;
            data.px = data.gx + dataTipHOffset;
            if (currentStack)
            {
                if (data.py < currentStack.gy + currentStack.height)
                {
                    currentStack.addTip(data, screen.height);
                }
                else
                {
                    reduceStacks(stacks, currentStack);
                    currentStack = new TipStack();
                    currentStack.addTip(data, screen.height);
                }
            }
            else
            {
                currentStack = new TipStack();
                currentStack.addTip(data, screen.height);
            }
        }

        if (currentStack)
            reduceStacks(stacks, currentStack);
        
        // Now make sure none of the tips block any targets.
        var startTarget:Number = 0;
        var endTarget:Number = 0;
        
        len = stacks.length;
        for (i = 0; i < len; i++)
        {
            stacks[i].positionY();
        }

        pLeft.sortOn("gy");
        len = pLeft.length;
        stacks = [];
        currentStack = null;
        for (i = 0; i < len; i++)
        {           
            data = pLeft[i];
            data.isRight = false;
            data.px = data.gx - data.width - dataTipHOffset;
            
            if (currentStack)
            {
                if (data.py < currentStack.gy + currentStack.height)
                {
                    currentStack.addTip(data, screen.height);
                }
                else
                {
                    reduceStacks(stacks, currentStack);
                    currentStack = new TipStack();
                    currentStack.addTip(data, screen.height);
                }
            }
            else
            {
                currentStack = new TipStack();
                currentStack.addTip(data, screen.height);
            }
        }

        if (currentStack)
            reduceStacks(stacks, currentStack);

        len = stacks.length;
        for (i = 0; i < len; i++)
        {
            stacks[i].positionY();
        }

        pData.sortOn("py");
        len = pData.length;
        maxX = -Infinity;
        minX = Infinity;

        var minForRightTips:Number = -Infinity;
        var maxForLeftTips:Number = Infinity;
        var repeatLayout:Boolean = true;
        
        // We should never have to go through this loop more than twice.
        var repeatCount:Number = 0;
        while (repeatLayout && repeatCount <= 2)
        {
            repeatLayout = false;
            repeatCount++;
            for (i = 0; i < len; i++)
            {
                var tipData:TipPositionData = pData[i];
                
                var bResetMaxX:Boolean = false;
                var bResetMinX:Boolean = false;
                
                while (startTarget < pData.length &&
                       pData[startTarget].gy + TOOLTIP_TARGET_RADIUS <
                       tipData.py)
                {
                    if (pData[startTarget].gx >= maxX)
                        bResetMaxX = true;
                    if (pData[startTarget].gx <= minX)
                        bResetMinX = true;

                    startTarget++;
                }

                endTarget = Math.max(endTarget, startTarget);
                
                while (endTarget < pData.length &&
                       pData[endTarget].gy - TOOLTIP_TARGET_RADIUS <
                       tipData.py + tipData.height)
                {
                    if (pData[endTarget].gx >= maxX)
                    {
                        bResetMaxX = false;
                        maxX = pData[endTarget].gx;
                    }

                    if (pData[endTarget].gx <= minX)
                    {
                        bResetMinX = false;
                        minX = pData[endTarget].gx;
                    }

                    endTarget++;
                }

                if (bResetMaxX || bResetMinX)
                {
                    maxX = -Infinity;
                    minX = Infinity;
                    
                    for (var j:int = startTarget; j < endTarget; j++)
                    {
                        maxX = Math.max(maxX, pData[j].gx);
                        minX = Math.min(minX, pData[j].gx);
                    }
                }

                if (tipData.isRight)
                {
                    tipData.px = Math.max(tipData.px,
                                          maxX + TOOLTIP_TARGET_RADIUS);
                    tipData.px = Math.max(minForRightTips, tipData.px);
                    
                    if (tipData.px > screenBR.x - tipData.width)
                    {
                        tipData.px = screenBR.x - tipData.width;
                        if (maxForLeftTips > tipData.px)
                        {
                            maxForLeftTips = tipData.px;
                            repeatLayout = true;
                        }
                    }
                }
                else
                {
                    tipData.px = Math.min(tipData.px,
                                          minX - TOOLTIP_TARGET_RADIUS -
                                          tipData.width);
                    tipData.px = Math.min(maxForLeftTips - tipData.width,
                                          tipData.px);
                    
                    if (tipData.px < screenTL.x)
                    {
                        tipData.px = screenTL.x;
                        if (tipData.px + tipData.width > minForRightTips)
                        {
                            minForRightTips = tipData.px + tipData.width;
                            repeatLayout = true;
                        }
                    }
                }
                
                pts.x = tipData.px;
                pts.y = tipData.py;
                localPts = globalToLocal(pts);
                /*if(layoutDirection == LayoutDirection.RTL)
                    tipData.tip.move(localPts.x - tipData.width, localPts.y);
                else*/
                    tipData.tip.move(localPts.x, localPts.y);
              
                if (showTarget)
                {   
                    if (len > 1)
                    {
                        if (calloutStroke)
                        {
                            calloutStroke.apply(g,null,null);

                            if (tipData.isRight)
                            {                   
                                g.moveTo(localPts.x,
                                         localPts.y + tipData.height /  2);
                                g.lineTo(tipData.x,
                                         localPts.y + tipData.height / 2);
                                g.lineTo(tipData.x, tipData.y);
                            }
                            else
                            {
                                /*
                                if(layoutDirection == LayoutDirection.RTL)
                                {
                                    g.moveTo(localPts.x - tipData.width,
                                         localPts.y + tipData.height / 2);
                                }
                                else
                                {*/
                                    g.moveTo(localPts.x + tipData.width,
                                        localPts.y + tipData.height / 2);
                                //}
                                g.lineTo(tipData.x,
                                         localPts.y + tipData.height / 2);
                                g.lineTo(tipData.x, tipData.y);
                            }
                        }
                    }

                    var tipColor:uint = tipData.hd.contextColor;
                    g.lineStyle(1, tipColor, 100);
                    g.moveTo(tipData.x, tipData.y);
                    g.beginFill(0xFFFFFF, 1);
                    g.drawCircle(tipData.x, tipData.y, TOOLTIP_TARGET_RADIUS);
                    g.endFill();

                    g.beginFill(tipColor, 1);
                    g.drawCircle(tipData.x, tipData.y,
                                 TOOLTIP_TARGET_INNER_RADIUS);
                    g.endFill();
                }
            }
        }
    }
    
    /**
     *  Defines the locations of DataTip objects on the chart.
     *  This method ensures that DataTip objects do not overlap each other
     *  (if multiple DataTip objects are visible) or overlap their target data items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function positionDataTips():void
    {
        var tipCount:int = _tipCache ? _tipCache.count:0;
        var rc:Rectangle = dataRegion;
        var g:Graphics = _dataTipOverlay.graphics;
        var pData:Array /* of TipPositionData */;
        var pLeft:Array /* of TipPositionData */ = [];
        var pRight:Array /* of TipPositionData */  = [];
        var sortList:Array /* of TipPositionData */ = [];
        var i:int;
        var data:TipPositionData;
        var minX:Number;
        var maxX:Number;
        var len:int;
        var stacks:Array /* of TipStack */;
        var currentStack:TipStack;
        var calloutStroke:IStroke = getStyle("calloutStroke");
        var dataTipHOffset:Number = getStyle("horizontalDataTipOffset");
        var dataTipVOffset:Number = getStyle("horizontalDataTipOffset");
        
        if (isNaN(dataTipHOffset))
            dataTipHOffset = 6;
        if (isNaN(dataTipVOffset))
            dataTipVOffset = 6;
        
        g.clear();

        if (tipCount == 0)
            return;
            
        var showTargetValue:Object = getStyle("showDataTipTargets");
        var showTarget:Boolean = showTargetValue != false &&
                                 showTargetValue != "false";
        
        pData = _tipCache.instances.slice(0, tipCount);
        var localPts:Point = new Point();

        for (i = 0; i < tipCount; i++)
        {
            var hitData:HitData = _currentHitSet[i];
            var tipInstance:IFlexDisplayObject = pData[i];

            localPts.x = Math.max(rc.left, Math.min(hitData.x, rc.right));
            localPts.y = Math.max(rc.top, Math.min(hitData.y, rc.bottom));
            var pts:Point = localToGlobal(localPts);            
            
            var xpos:Number;
            var ypos:Number;

            if (tipInstance is ILayoutManagerClient)
                ILayoutManagerClient (tipInstance).validateSize();
            
            //if current systemManager is not sandbox root,
            // marshalling support is enabled and localToGlobal does not give
            // expected result because current sub application becomes top level
            // In such cases, sub-application's offset needs to be subtracted
            // from obtained localToGlobal values.
            // http://bugs.adobe.com/jira/browse/FLEXDMV-2536
            /*
            if(systemManager != systemManager.topLevelSystemManager.getSandboxRoot())
            {
                var appOffset:Point = FlexGlobals.topLevelApplication.localToGlobal(new Point(0,0));
                data = new TipPositionData(tipInstance, hitData,
                    localPts.x, localPts.y, pts.x - appOffset.x, pts.y - appOffset.y);                      
            }
            else
            {*/
                data = new TipPositionData(tipInstance, hitData,
                    localPts.x, localPts.y, pts.x, pts.y);
            //}      
                        
            if (data.gy - dataTipVOffset - tipInstance.measuredHeight > 0)
                data.py = data.gy - dataTipVOffset - tipInstance.measuredHeight;
            else                        
                data.py = data.gy + dataTipVOffset;

            sortList.push(data);
            pData[i] = data;
        }
        
        if (sortList.length > 0)
        {
            sortList.sortOn("gx", Array.NUMERIC);
            
            minX = sortList[0].gx;
            maxX = sortList[sortList.length - 1].gx;
            
            var screenTL:Point = new Point(4, 4);
            var screenBR:Point = new Point(screen.width - 4, screen.height - 4);
            
            i = 0;

            // This code pre-examines the datatips for tips that would
            // stick out off screen, and forces them to flip to the other side.
            // While this gets datatips that don't stick off screen and don't
            // overlap the points, it makes for some fantastically unattractive
            // datatip layouts.
            // So for now I'm opting for the prettier but occasionally slightly
            // annoying behavior of sliding tips over until they don't stick
            // off screen, potentially overlapping the points.
            /*          
            while (i < sortList.length)
            {
                data = sortList[i];         
                if (maxX + dataTipHOffset + tipInstance.measuredWidth >
                    screenBR.x) 
                {
                    pLeft.push(data);
                    sortList.splice(i, 1);
                }
                else if (minX - dataTipHOffset - tipInstance.measuredWidth <
                         screenTL.x) 
                {
                    pRight.push(data);
                    sortList.splice(i ,1);
                }
                else
                {
                    i++;
                }
            }
            */
            
            var splitPoint:int = Math.floor(sortList.length / 2);

            // As a first approximation, we just divide these in half.
            // But our goal is to end up with an even set of left/right stacks.
            // So if we already have items in those stacks,
            // let's adjust our split.
            if (pLeft.length > pRight.length)
            {
                splitPoint = Math.max(0, splitPoint -
                                      (pLeft.length - pRight.length));
            }
            else if (pRight.length > pLeft.length)
            {
                splitPoint = Math.min(sortList.length,
                                      splitPoint +
                                      (pRight.length - pLeft.length));
            }
            /*
            if(sortList.length == 1 && layoutDirection == LayoutDirection.RTL)
            {
                pRight = pRight.concat(sortList.slice(0, splitPoint));
                pLeft = pLeft.concat(sortList.slice(splitPoint, sortList.length));
            }
            else
            {*/
                pLeft = pLeft.concat(sortList.slice(0, splitPoint));
                pRight = pRight.concat(sortList.slice(splitPoint, sortList.length));
            //}
        }
                
        pRight.sortOn("gy");
        len = pRight.length;
        stacks = [];
        currentStack = null;

        for (i = 0; i < len; i++)
        {           
            data = pRight[i];
            data.isRight = true;
            data.px = data.gx + dataTipHOffset;
            if (currentStack)
            {
                if (data.py < currentStack.gy + currentStack.height)
                {
                    currentStack.addTip(data, screen.height);
                }
                else
                {
                    reduceStacks(stacks, currentStack);
                    currentStack = new TipStack();
                    currentStack.addTip(data, screen.height);
                }
            }
            else
            {
                currentStack = new TipStack();
                currentStack.addTip(data, screen.height);
            }
        }

        if (currentStack)
            reduceStacks(stacks, currentStack);
        
        // Now make sure none of the tips block any targets.
        var startTarget:Number = 0;
        var endTarget:Number = 0;
        
        len = stacks.length;
        for (i = 0; i < len; i++)
        {
            stacks[i].positionY();
        }

        pLeft.sortOn("gy");
        len = pLeft.length;
        stacks = [];
        currentStack = null;
        for (i = 0; i < len; i++)
        {           
            data = pLeft[i];
            data.isRight = false;
            data.px = data.gx - data.width - dataTipHOffset;
            
            if (currentStack)
            {
                if (data.py < currentStack.gy + currentStack.height)
                {
                    currentStack.addTip(data, screen.height);
                }
                else
                {
                    reduceStacks(stacks, currentStack);
                    currentStack = new TipStack();
                    currentStack.addTip(data, screen.height);
                }
            }
            else
            {
                currentStack = new TipStack();
                currentStack.addTip(data, screen.height);
            }
        }

        if (currentStack)
            reduceStacks(stacks, currentStack);

        len = stacks.length;
        for (i = 0; i < len; i++)
        {
            stacks[i].positionY();
        }

        pData.sortOn("py");
        len = pData.length;
        maxX = -Infinity;
        minX = Infinity;

        var minForRightTips:Number = -Infinity;
        var maxForLeftTips:Number = Infinity;
        var repeatLayout:Boolean = true;
        
        // We should never have to go through this loop more than twice.
        var repeatCount:Number = 0;
        while (repeatLayout && repeatCount <= 2)
        {
            repeatLayout = false;
            repeatCount++;
            for (i = 0; i < len; i++)
            {
                var tipData:TipPositionData = pData[i];
                
                var bResetMaxX:Boolean = false;
                var bResetMinX:Boolean = false;
                
                while (startTarget < pData.length &&
                       pData[startTarget].gy + TOOLTIP_TARGET_RADIUS <
                       tipData.py)
                {
                    if (pData[startTarget].gx >= maxX)
                        bResetMaxX = true;
                    if (pData[startTarget].gx <= minX)
                        bResetMinX = true;

                    startTarget++;
                }

                endTarget = Math.max(endTarget, startTarget);
                
                while (endTarget < pData.length &&
                       pData[endTarget].gy - TOOLTIP_TARGET_RADIUS <
                       tipData.py + tipData.height)
                {
                    if (pData[endTarget].gx >= maxX)
                    {
                        bResetMaxX = false;
                        maxX = pData[endTarget].gx;
                    }

                    if (pData[endTarget].gx <= minX)
                    {
                        bResetMinX = false;
                        minX = pData[endTarget].gx;
                    }

                    endTarget++;
                }

                if (bResetMaxX || bResetMinX)
                {
                    maxX = -Infinity;
                    minX = Infinity;
                    
                    for (var j:int = startTarget; j < endTarget; j++)
                    {
                        maxX = Math.max(maxX, pData[j].gx);
                        minX = Math.min(minX, pData[j].gx);
                    }
                }

                if (tipData.isRight)
                {
                    tipData.px = Math.max(tipData.px,
                                          maxX + TOOLTIP_TARGET_RADIUS);
                    tipData.px = Math.max(minForRightTips, tipData.px);
                    
                    if (tipData.px > screenBR.x - tipData.width)
                    {
                        tipData.px = screenBR.x - tipData.width;
                        if (maxForLeftTips > tipData.px)
                        {
                            maxForLeftTips = tipData.px;
                            repeatLayout = true;
                        }
                    }
                }
                else
                {
                    tipData.px = Math.min(tipData.px,
                                          minX - TOOLTIP_TARGET_RADIUS -
                                          tipData.width);
                    tipData.px = Math.min(maxForLeftTips - tipData.width,
                                          tipData.px);
                    
                    if (tipData.px < screenTL.x)
                    {
                        tipData.px = screenTL.x;
                        if (tipData.px + tipData.width > minForRightTips)
                        {
                            minForRightTips = tipData.px + tipData.width;
                            repeatLayout = true;
                        }
                    }
                }
                pts.x = tipData.px;
                pts.y = tipData.py;
                
                
                localPts = this.parentApplication.systemManager.getSandboxRoot().globalToLocal(pts);
                
                var chartLocalPts:Point = globalToLocal(pts);
                
                tipData.tip.move(localPts.x, localPts.y);
                
                if (showTarget)
                {   
                    if (len > 1)
                    {
                        if (calloutStroke)
                        {
                            calloutStroke.apply(g,null,null);

                            if (tipData.isRight)
                            {                   
                                g.moveTo(chartLocalPts.x,
                                         chartLocalPts.y + tipData.height /  2);
                                g.lineTo(tipData.x,
                                         chartLocalPts.y + tipData.height / 2);
                                g.lineTo(tipData.x, tipData.y);
                            }
                            else
                            {
                                /*
                                if(layoutDirection == LayoutDirection.RTL)
                                {
                                    g.moveTo(chartLocalPts.x - tipData.width,
                                        chartLocalPts.y + tipData.height / 2);
                                }
                                else
                                {*/
                                    g.moveTo(chartLocalPts.x + tipData.width,
                                        chartLocalPts.y + tipData.height / 2);
                                //}
                                g.lineTo(tipData.x,
                                         chartLocalPts.y + tipData.height / 2);
                                g.lineTo(tipData.x, tipData.y);
                            }
                        }
                    }

                    var tipColor:uint = tipData.hd.contextColor;
                    g.lineStyle(1, tipColor, 100);
                    g.moveTo(tipData.x, tipData.y);
                    g.beginFill(0xFFFFFF, 1);
                    g.drawCircle(tipData.x, tipData.y, TOOLTIP_TARGET_RADIUS);
                    g.endFill();

                    g.beginFill(tipColor, 1);
                    g.drawCircle(tipData.x, tipData.y,
                                 TOOLTIP_TARGET_INNER_RADIUS);
                    g.endFill();
                }
            }
        }
    }

    /**
     *  @private
     */
    private function reduceStacks(stacks:Array /* of TipStack */, currentStack:TipStack):void
    {
        while (stacks.length > 0)
        {
            var prevStack:TipStack = stacks[stacks.length - 1];
            if (prevStack.gy + prevStack.height < currentStack.gy)
                break;
            
            prevStack.merge(currentStack, screen.height);
            
            currentStack = stacks.pop();
        }

        stacks.push(currentStack);
    }
    
    /**
     *  Applies per-series customization and formatting to the series of the chart. 
     *  This method is called once for each series when the series 
     *  has been changed by a call to the <code>invalidateSeries()</code> method.
     *  
     *  @param seriesGlyph The series to customize.
     *  @param i The series' index in the series array.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function customizeSeries(seriesGlyph:Series, i:uint):void
    {
    }

    private var doingValidation:Boolean;
    
    /**
     *  Triggers a redraw of the chart.
     *  Call this method when you add or change
     *  the chart's series or data providers.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function invalidateData():void
    {
        _bDataDirty=true;
        invalidateProperties();
        if (parent && !doingValidation)
        {
            doingValidation = true;
            commitProperties();
            measure();
            updateDisplayList(width, height);
            doingValidation = false;
        }
    }

    /**
     *  Preprocesses the series and transform for display. You typically do not call 
     *  this method directly. Instead, this method is called automatically during the 
     *  chart control's <code>commitProperties()</code> cycle when the series has 
     *  been invalidated by a call to the <code>invalidateSeries()</code> method.
     *  <p>By default, this method calls the <code>customizeSeries()</code> method once for each series in the set.  
     *  Chart subclasses can override this method to add customization logic that is global to the whole series set.</p>
     *  
     *  @param seriesSet An array of series to preprocess.
     *  @param transform The transform used by the series.
     *  
     *  @return An array of series with the series set applied.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function applySeriesSet(seriesSet:Array /* of Series */,
                                      transform:DataTransform):Array /* of Series */
    {
        var n:int = seriesSet.length;
        for (var i:int = 0; i < n; i++)
        {
            var newSeries:IChartElement = seriesSet[i];
            if (newSeries is Series)
                customizeSeries(Series(seriesSet[i]), i);
        }

        return seriesSet;
    }

    /**
     *  @private
     */
    mx_internal function updateChildOrder():void
    {
        var nextindex:int = 0;
        setChildIndex(_backgroundElementHolder, nextindex++);
        nextindex = updateAxisOrder(nextindex);
        setChildIndex(_seriesHolder, nextindex++);
        setChildIndex(_annotationElementHolder, nextindex++);
        setChildIndex(_allDataTipOverlay, nextindex++);
        setChildIndex(_dataTipOverlay, nextindex++);
    }

    /**
     *  @private
     */
    mx_internal function updateAxisOrder(nextindex:int):int
    {
        return nextindex;
    }
    
    /**
     *  @private
     */
    mx_internal function updateSeries():void
    {
        var displayedSeries:Array /* of Series */ = applySeriesSet(_userSeries, _transforms[0]);

        var len:int = displayedSeries ? displayedSeries.length : 0;
        var c:UIComponent;
        var g:IChartElement;
        var labelLayer:UIComponent;

        len = labelElements.length; // was numChildren?

        removeElements(_backgroundElementHolder, true);
        removeElements(_seriesFilterer, false);
        removeElements(_annotationElementHolder, true);

        addElements(_backgroundElements, _transforms[0],
                    _backgroundElementHolder);

        allElements = _backgroundElements.concat();

        addElements(displayedSeries, _transforms[0], _seriesFilterer);

        allElements = allElements.concat(displayedSeries);
        
        labelElements = [];
        var n:int  = displayedSeries.length;
        for (var i:int = 0; i < n; i++) 
        {
            g = displayedSeries[i] as IChartElement;
            if (!g)
                continue;
                
            Series(g).invalidateProperties();

            labelLayer = UIComponent(g.labelContainer);
            if (labelLayer) 
                labelElements.push(labelLayer);             
        }

        addElements(labelElements, _transforms[0],_annotationElementHolder);
        
        allElements = allElements.concat(labelElements);

        addElements(_annotationElements,
                    _transforms[0],_annotationElementHolder);
        
        allElements = allElements.concat(_annotationElements);

        _transforms[0].elements = _annotationElements.concat(displayedSeries).
                                  concat(_backgroundElements);

        _bDataDirty = true;
        invalidateSeriesStyles();
    }

    /**
     *  @private
     */
    mx_internal function addElements(elements:Array /* of ChartElement */, transform:DataTransform,
                                   elementParent:UIComponent):void
    {
        var c:UIComponent;
        var g:IChartElement;
        
        var n:int = elements.length;
        for (var i:int = 0; i < n; i++)
        {
            c = elements[i];
            g = c as IChartElement;
            if (g && !(g is Series) && !(g is IDataCanvas))
                g.dataTransform = transform;

            elementParent.addChild(c);
        }
    }

    /**
     * @private
     */
    mx_internal function removeElements(parent:UIComponent,hasMask:Boolean):void
    {
        var n:int = parent.numChildren;
        var stopIndex:int = hasMask ? 1 : 0;
        for (var i:int = n - 1;
             i >= stopIndex; // intentional -- leave the mask in place
             i--)
        {
            var c:UIComponent = parent.removeChildAt(i) as UIComponent;
            var g:IChartElement = (c as IChartElement);
            if (g)
                g.dataTransform = null;
        }
    }
    
    /**
     *  @private 
     */
    mx_internal function updateSeriesStyles():void
    {
        if (_seriesStylesDirty)
        {
            _seriesStylesDirty = false;

            var nextAvailableStyle:uint = 0;
            
            var styles:Array /* of Object */ = getStyle("chartSeriesStyles");
            if (styles)
            {
                var n:int = allElements.length;
                for (var i:int = 0; i < n; i++)
                {
                    var g:IChartElement = allElements[i] as IChartElement;
                    if (g)
                    {
                        nextAvailableStyle =
                            g.claimStyles(styles, nextAvailableStyle);
                    }
                }
            }
        }
    }

    /**
     *  @private
     */
    mx_internal function applyDataProvider(dp:ICollectionView,
                                         transform:DataTransform):void
    {
        var axes:Object = transform.axes;
        for (var p:String in axes)
        {
            axes[p].chartDataProvider = dp;     
        }

        var elements:Array /* of ChartElement */ = transform.elements;
        var n:int = elements.length;
        for (var i:int = 0; i < n; i++)
        {
            if (elements[i] is Series)
                elements[i].chartDataProvider = dp;
        }
        clearSelection();
    }

    /**
     *  @private
     */
    mx_internal function updateData():void
    {
        if (_dataProvider != null)
            applyDataProvider(_dataProvider,_transforms[0]);
            
        var n:uint = series.length;
        for (var i:int = 0; i < n; i++)
        {
            applyDataProvider(ICollectionView(dataProvider),series[i].dataTransform);
        }
    }

    /**
     *  @private
     */
    private function collectTransitions():Array /* of IEffectInstance */
    {
        var a:Array /* of IEffectInstance */ = [];

        var n:int = allElements.length;
        for (var i:int = 0; i < n; i++)
        {
            var g:IChartElement = allElements[i] as IChartElement;
            if (g)
                g.collectTransitions(_transitionState, a);
        }
        
        return a;
    }
    
    /**
     *  @private
     */
    mx_internal function updateKeyboardCache():void
    {
        return;
    }
    
    /**
     *  @private
     */
    mx_internal function getNextSeries(seriesArray:Array /* of Series */):ChartItem
    {
        var itemFound:Boolean = false;
        var index:int;
 
        // We are not cycling through the items if we reach the end as per some customers suggestion
        if (!_caretItem)
            index = -1;
        else 
            index = seriesArray.indexOf(Series(_caretItem.element));
        
        while (!itemFound && index < seriesArray.length - 1)
        {
            ++index;
            if (seriesArray[index].selectable && seriesArray[index].visible && seriesArray[index].items.length > 0)
                itemFound = true;
        }
        
        if (itemFound)
            return seriesArray[index].items[0];
        return null;
    }
    
    /**
     *  @private
     */
    mx_internal function getPreviousSeries(seriesArray:Array /* of Series */ ):ChartItem
    {
        var itemFound:Boolean = false;
        var index:int;
 
        // We are not cycling through the items if we reach the end as per some customers suggestion
        if (!_caretItem)
            index = seriesArray.length;
        else 
            index = seriesArray.indexOf(Series(_caretItem.element));
        while (!itemFound && index > 0)
        {
            --index;        
            if (seriesArray[index].selectable && seriesArray[index].visible && seriesArray[index].items.length > 0)
                itemFound = true;
        }
        
        if (itemFound)
            return seriesArray[index].items[0];
        return null;
    }
    
    /**
     *  @private
     */
    mx_internal function getNextSeriesItem(seriesArray:Array /* of Series */ ):ChartItem
    {
        var index:int = 0;
        var caretSeries:Series;

        if (!_caretItem)
            return getNextSeries(seriesArray);
        
        caretSeries = Series(_caretItem.element);
        index = caretSeries.items.indexOf(_caretItem);
        if (index == caretSeries.items.length - 1)
            return null;
        return caretSeries.items[++index];
    }
    
    /**
     *  @private
     */
    mx_internal function getPreviousSeriesItem(seriesArray:Array /* of Series */):ChartItem
    {
        var index:int = 0;
        var caretSeries:Series;

        if (!_caretItem)
            return getPreviousSeries(seriesArray);
        
        caretSeries = Series(_caretItem.element);   
        index = caretSeries.items.indexOf(_caretItem);
        if (index == 0)
            return null;
        return caretSeries.items[--index];
    }
    
    /**
     *  Adds the selected items to the DragSource object as part of a
     *  drag and drop operation.
     *  You can override this method to add other data to the drag source.
     * 
     * @param ds The DragSource object to which the data is added.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function addDragData(ds:Object):void // actually a DragSource
    {
        ds.addData(selectedChartItems, "chartitems");
    }
    
    /**
     *  Displays a drop indicator under the mouse pointer to indicate that a
     *  drag-and-drop operation is allowed. The drop indicator also indicates where the items will
     *  be dropped.
     *
     *  @param event A DragEvent object that contains information about where
     *  the mouse pointer is.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function showDropFeedback(event:DragEvent):void
    {
        //drawFocus(true);
    }

    /**
     *  Hides the drop indicator that indicates that a
     *  drag-and-drop operation is allowed.
     *
     *  @param event A DragEvent object that contains information about the
     *  mouse location.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function hideDropFeedback(event:DragEvent):void
    {
        //drawFocus(false);
    }

    //--------------------------------------------------------------------------
    //
    //  Region Selection
    //
    //--------------------------------------------------------------------------
    
    private function startTracking(event:MouseEvent) :void
    {
       /* the user clicked the mouse down. First, we need to add listeners for the mouse dragging */   
       if (dataRegion.contains(mouseX,mouseY) == false)
           return;
       
       if (rangeItemRenderer)
       {
           rangeItemRenderer.clear();    
           removeChild(rangeItemRenderer);  
       }
      
       rangeItemRenderer = new RangeSelector();
       addChild(rangeItemRenderer);
       
       dataRegionForRange = dataRegion;

       systemManager.getSandboxRoot().addEventListener("mouseUp",endTracking,true);
       systemManager.getSandboxRoot().addEventListener("mouseMove",track,true);
       
       var mouseVals:Array /* of Number */;
        
       tX = mouseX;
       tY = mouseY;
       mouseVals = [tX,tY];
                
       updateTrackBounds(mouseVals);
    }
    
    private function track(event:MouseEvent):void 
    {
        if (event.buttonDown == false)
        {
            endTracking(event);
            return;
        }
        updateTrackBounds([mouseX,mouseY]);
        dispatchRegionChange(event);
        event.stopPropagation();
    }

    private function dispatchRegionChange(event:MouseEvent):void
    {
        var leftTop:Point = new Point(dLeft,dTop);
        var rightBottom:Point = new Point(dRight,dBottom);
        leftTop = localToGlobal(leftTop);
        rightBottom = localToGlobal(rightBottom);
        var r:Rectangle = new Rectangle(leftTop.x, leftTop.y, rightBottom.x - leftTop.x, rightBottom.y - leftTop.y);
        
        dispatchEvent(new RangeEvent(RangeEvent.REGION_CHANGE,r,event));
    }
    
    private function endTracking(event:MouseEvent):void
    {
        systemManager.getSandboxRoot().removeEventListener("mouseUp",endTracking,true);
        systemManager.getSandboxRoot().removeEventListener("mouseMove",track,true);
           
        rangeItemRenderer.clear();
        removeChild(rangeItemRenderer);
        rangeItemRenderer = null;
        
        dispatchRegionChange(event); 
     }
  
    private function updateTrackBounds(mouseVals:Array /* of Number */):void
    {
        /* store the bounding rectangle of the selection, in a normalized mouse coordinates -based rectangle */
 
        dRight = Math.max(tX,mouseVals[0]);
        dLeft = Math.min(tX,mouseVals[0]);
        dTop = Math.min(tY,mouseVals[1]);
        dBottom = Math.max(tY,mouseVals[1]);
        
        dLeft = Math.max(dLeft,dataRegionForRange.left);
        dTop = Math.max(dTop,dataRegionForRange.y);
        dRight = Math.min(dRight,dataRegionForRange.x + dataRegionForRange.width);
        dBottom = Math.min(dBottom, dataRegionForRange.y + dataRegionForRange.height);
        
        rangeItemRenderer.move(dLeft,dTop);
        rangeItemRenderer.setActualSize(dRight - dLeft,dBottom - dTop);
    }


    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
   
    
    /**
     *  @private
     */
    private function mouseOverHandler(event:MouseEvent):void
    {
        if (_tipCache)
        {
            var n:int = _tipCache.count;
            for (var i:int = 0; i < n; i++)
            {
                var ti:IFlexDisplayObject = _tipCache.instances[i];
                
                if (event.target == ti ||
                    ((ti is UIComponent) &&  
                     (ti as UIComponent).contains(
                        event.target as UIComponent)))
                {                  
                    return;
                }

                if (event.relatedObject&&
                    (ti == event.relatedObject ||
                     ((ti is UIComponent) && 
                      (ti as UIComponent).contains(
                        event.relatedObject as IUIComponent))))
                {
                    return;
                }
            }
        }
            
        if (!(event.relatedObject) || 
            (event.relatedObject != this && 
             !contains(event.relatedObject as IUIComponent)))
        {
            var p:Point = new Point(event.localX, event.localY);
            p = globalToLocal(UIComponent(event.target).localToGlobal(p));

            var hitPoints:Array /* of HitData */ = findDataPoints(p.x, p.y);
            
            processRollEvents(hitPoints, event);
        }
    }

    /**
     *  @private
     */
    private function mouseOutHandler(event:MouseEvent):void
    {

        if (_tipCache)
        {
            var n:int = _tipCache.count;
            for (var i:int = 0; i < n; i++)
            {
                var ti:IFlexDisplayObject = _tipCache.instances[i];

                if (event.target == ti ||
                    ((ti is UIComponent) &&  
                     (ti as UIComponent).contains(
                        event.target as UIComponent)))
                {                  
                    return;
                }
                
                if (event.relatedObject &&
                    (ti == event.relatedObject ||
                     ((ti is UIComponent) && 
                      (ti as UIComponent).contains(
                            event.relatedObject as IUIComponent))))
                {
                    return;
                }
            }
        }

        if (!(event.relatedObject) || 
            (event.relatedObject != this && 
             !contains(event.relatedObject as IUIComponent)))  
        {
            processRollEvents([], event);
        }
    }

    /**
     *  @private
     */
    private function mouseDownHandler(event:MouseEvent):void
    {
        var p:Point = new Point(event.localX, event.localY);
        p = globalToLocal(UIComponent(event.target).localToGlobal(p));
        
        var hitPoints:Array /* of HitData */ = findDataPoints(p.x, p.y);
        setFocus();
        processRollEvents(hitPoints, event);

        if (_currentHitSet)
        {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_MOUSE_DOWN,
                                             _currentHitSet, event, this));
        }
    }

    /**
     *  @private
     */
    private function mouseMoveHandler(event:MouseEvent):void
    {
        if (_tipCache)
        {
            var n:int = _tipCache.count;
            for (var i:int = 0; i < n; i++)
            {
                var ti:IFlexDisplayObject = _tipCache.instances[i];

                if (event.target == ti ||
                    ((ti is UIComponent) &&  
                    (ti as UIComponent).contains(
                        event.target as UIComponent)))
                {          
                    return;
                }
            }       
        }

        var p:Point = new Point(event.localX, event.localY);
        p = globalToLocal(UIComponent(event.target).localToGlobal(p));
        
        var hitPoints:Array /* of HitData */ = findDataPoints(p.x, p.y);
        
        processRollEvents(hitPoints, event);
    }

    /**
     *  @private
     */
    private function mouseUpHandler(event:MouseEvent):void
    {
        var p:Point = new Point(event.localX, event.localY);
        p = globalToLocal(UIComponent(event.target).localToGlobal(p));
        
        var hitPoints:Array /* of HitData */  = findDataPoints(p.x, p.y);

        processRollEvents(hitPoints, event);

        if (_currentHitSet)
        {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_MOUSE_UP,
                                             _currentHitSet, event, this));
        }
    }

    /**
     *  @private
     */
    private function mouseClickHandler(event:MouseEvent):void
    {
        var p:Point = new Point(event.localX, event.localY);
        p = globalToLocal(UIComponent(event.target).localToGlobal(p));

        var hitPoints:Array /* of HitData */ = findDataPoints(p.x, p.y);

        processRollEvents(hitPoints, event);
            
        if (_currentHitSet && _currentHitSet.length > 0)
        {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_CLICK,
                                             _currentHitSet, event, this));
        }
        else
        {
            dispatchEvent(new ChartEvent(ChartEvent.CHART_CLICK, event, this));
        }
    }

    /**
     *  @private
     */
    private function mouseDoubleClickHandler(event:MouseEvent):void
    {
        var p:Point = new Point(event.localX, event.localY);
        p = globalToLocal(UIComponent(event.target).localToGlobal(p));
        
        var hitPoints:Array /* of HitData */ = findDataPoints(p.x, p.y);

        processRollEvents(hitPoints, event);

        if (_currentHitSet && _currentHitSet.length > 0)
        {
            dispatchEvent(new ChartItemEvent(ChartItemEvent.ITEM_DOUBLE_CLICK,
                                             _currentHitSet, event, this));
        }
        else
        {
            dispatchEvent(new ChartEvent(ChartEvent.CHART_DOUBLE_CLICK, event, this));
        }
    }

    /**
     *  @private
     */
    private function dataEffectEndHandler(event:EffectEvent):void
    {
        event.target.removeEventListener(EffectEvent.EFFECT_END,
                                         dataEffectEndHandler);

        if (chartState == ChartState.HIDING_DATA)
            setChartState(ChartState.PREPARING_TO_SHOW_DATA);
        else
            setChartState(ChartState.NONE);

        //_transitionEffect = null;

        invalidateDisplayList();
    }

    /**
     *  @private
     */
    private function regionChangeHandler(event:RangeEvent):void
    {
        var bSelected:Boolean = true;
        if (!_selectedSeries)
            bSelected = false;
        selectRectangleRegion(event.regionSelected,event.mouseEvent.ctrlKey || event.mouseEvent.shiftKey);
        if ((bSelected || _selectedSeries) && !event.mouseEvent.buttonDown) // Fire the event only if the earlier or current selection is non-empty and if mouse is up
            dispatchEvent(new ChartItemEvent(ChartItemEvent.CHANGE,null,event.mouseEvent,this));   
    }

    /**
     *  The default handler for the <code>dragStart</code> event.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function dragStartHandler(event:DragEvent):void
    {
        if (event.isDefaultPrevented())
            return;

        var dragSource:DragSource = new DragSource();

        addDragData(dragSource);
        
        var proxyOrigin:Point = event.target.localToGlobal(
                        new Point(event.localX, event.localY));
        proxyOrigin = globalToLocal(proxyOrigin);
        
        var xOffset:Number = - (proxyOrigin.x - event.localX);
        var yOffset:Number = - (proxyOrigin.y - event.localY);
        /*
        DragManager.doDrag(this, dragSource, event, dragImage,
                           xOffset, yOffset, 0.5, dragMoveEnabled);
        */
    }

    /**
     *  Handles events of type <code>DragEvent.DRAG_ENTER</code>. This method
     *  determines if the DragSource object contains valid elements and uses
     *  the <code>showDropFeedback()</code> method to set up the UI feedback.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function dragEnterHandler(event:DragEvent):void
    {
        if (event.isDefaultPrevented())
            return;

        /*
        if (event.dragSource.hasFormat("chartitems"))
        {
            DragManager.acceptDragDrop(this);
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            showDropFeedback(event);
            return;
        }

        hideDropFeedback(event);
        
        DragManager.showFeedback(DragManager.NONE);
        */
    }

    /**
     *  Handles events of type <code>DragEvent.DRAG_OVER</code>. This method
     *  determines whether the DragSource object contains valid elements and uses
     *  the <code>showDropFeedback()</code> method to set up the UI feeback.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function dragOverHandler(event:DragEvent):void
    {
        if (event.isDefaultPrevented())
            return;

        /*
        if (event.dragSource.hasFormat("chartitems"))
        {
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            showDropFeedback(event);
            return;
        }

        hideDropFeedback(event);
        
        DragManager.showFeedback(DragManager.NONE);
        */
    }

    /**
     *  Handles events of type <code>DragEvent.DRAG_EXIT</code>. This method hides
     *  the UI feeback by calling the <code>hideDropFeedback()</code> method.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function dragExitHandler(event:DragEvent):void
    {
        if (event.isDefaultPrevented())
            return;

        /*
        hideDropFeedback(event);
        
        DragManager.showFeedback(DragManager.NONE);
        */
    }
    
    /**
     *  Handles events of type <code>DragEvent.DRAG_DROP</code>. This method hides
     *  the UI feeback by calling the <code>hideDropFeedback()</code> method.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function dragDropHandler(event:DragEvent):void
    {
        if (event.isDefaultPrevented())
            return;

        hideDropFeedback(event);
    }

    /**
     *  Handles events of type <code>DragEvent.DRAG_COMPLETE</code>. This method
     *  removes the item from the data provider.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    protected function dragCompleteHandler(event:DragEvent):void
    {
       _mouseDown = false;
       _mouseDownItem = null;
       _mouseDownPoint = null;
       
       if (event.isDefaultPrevented())
            return;

    }
}

}

import mx.charts.HitData;
import mx.core.IFlexDisplayObject;

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: TipStack
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 */
class TipStack
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
    public function TipStack()
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
    public var tips:Array /* of TipSPositionData */ = [];

    /**
     *  @private
     */
    public var height:Number;

    /**
     *  @private
     */
    public var gy:Number;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public function merge(ts:TipStack, screenHeight:Number):void
    {
        tips = tips.concat(ts.tips);

        var newHeight:Number = ts.gy + ts.height - gy;
        gy = Math.max(0, gy - (gy + height - ts.gy) / 2);
        if (gy + newHeight > screenHeight)
            gy = Math.max(0, screenHeight - newHeight);
        height = newHeight;
    }

    /**
     *  @private
     */
    public function addTip(tip:TipPositionData, screenHeight:Number):void
    {
        tips.push(tip);

        if (tips.length == 1)
        {
            gy = tip.py;
            height = tip.height;
        }
        else if (tips.length == 2)
        {
            height += tip.height;
            gy = Math.min(screenHeight - height,
                 Math.max(0, (tips[0].gy + tips[1].gy) / 2) - height / 2);
        }
        else
        {
            height += tip.height;
            gy = Math.min(screenHeight - height,
                 Math.max(0, ((gy + height / 2) *
                 (tips.length - 1) + tip.gy) / tips.length - height / 2));
        }
    }

    /**
     *  @private
     */
    public function positionY():void
    {
        var gy:Number = this.gy;
        var n:int = tips.length;
        for (var i:int = 0; i < n; i++)
        {
            var tipData:TipPositionData = tips[i];
            tipData.py = gy;
            gy += tipData.height;
        }
    }
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: TipPositionData
//
////////////////////////////////////////////////////////////////////////////////

/**
 *  @private
 */
class TipPositionData
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
    public function TipPositionData(tipInstance:IFlexDisplayObject,
                                    hitData:HitData,
                                    x:Number, y:Number,
                                    gx:Number, gy:Number)
    {
        super();

        tip = tipInstance;
        hd = hitData;
        this.x = x;
        this.y = y;
        this.gx = gx;
        this.gy = gy;
        this.width = tipInstance.measuredWidth;
        this.height = tipInstance.measuredHeight+4;
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public var tip:IFlexDisplayObject;

    /**
     *  @private
     */
    public var hd:HitData;

    /**
     *  @private
     */
    public var x:Number;

    /**
     *  @private
     */
    public var y:Number;

    /**
     *  @private
     */
    public var gx:Number;

    /**
     *  @private
     */
    public var gy:Number;

    /**
     *  @private
     */
    public var px:Number;

    /**
     *  @private
     */
    public var py:Number;

    /**
     *  @private
     */
    public var width:Number;

    /**
     *  @private
     */
    public var height:Number;

    /**
     *  @private
     */
    public var isRight:Boolean;
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: RangeEvent
//
////////////////////////////////////////////////////////////////////////////////
/**
 * The RangeEvent class represents events that are specific
 * to the Range Selection.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
 
import org.apache.royale.events.Event;
import org.apache.royale.events.MouseEvent;
import mx.charts.HitData;
import mx.charts.chartClasses.ChartBase;
import org.apache.royale.geom.Point;
import org.apache.royale.geom.Rectangle;

/**
 *  @private
*/
     
class RangeEvent extends Event
{
//    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    
    /**
     *  Event type constant; indicates that the rectangular selection region has changed
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    
    public static const REGION_CHANGE:String = "regionChange"

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *
     *  @param type The type of the event.
     *
     *  @param the rectangular region of selection
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function RangeEvent(type:String, rect:Rectangle, event:MouseEvent)
    {               
        super(type);
        this.regionSelected = rect;     
        this.mouseEvent = event;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  regionSelected
    //----------------------------------

    [Inspectable(environment="none")]

    /**
     *  A rectangular region that was drawn to select items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var regionSelected:Rectangle;
    
    //----------------------------------
    //  mouseEvent
    //----------------------------------
    /**
     *  Indicates whether ctrl key has been pressed or not.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var mouseEvent:MouseEvent;
    //--------------------------------------------------------------------------
    //
    //  Overridden methods: Event
    //
    //--------------------------------------------------------------------------
 
    /** 
     *  @private
     */
    COMPILE::SWF { override }
    public function clone():Event
    {
        return new RangeEvent(type, regionSelected,mouseEvent);
    }
}

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: RangeSelector
//
////////////////////////////////////////////////////////////////////////////////
import mx.display.*;
import org.apache.royale.geom.*;
import mx.skins.ProgrammaticSkin

/**
 *  @private
 */

class RangeSelector extends ProgrammaticSkin
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
    public function RangeSelector() 
    {
        super();
    }
            
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    public function clear():void
    {
        var g:Graphics = graphics;
        g.clear();  
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
        
        g.moveTo(0,0);                
        g.beginFill(0xDAF1FF,0.5);
        g.lineStyle(1,0x009DFF);
        g.drawRect(0,0,width,height);
        g.endFill();
    }
}
