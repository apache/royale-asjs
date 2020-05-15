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


package mx.controls.listClasses
{
import mx.controls.dataGridClasses.DataGridColumnList;

/* import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Keyboard;
import flash.utils.Dictionary;
import flash.utils.clearInterval;
import flash.utils.setInterval;

import mx.collections.ArrayCollection;
*/
COMPILE::SWF{
    import flash.display.DisplayObject;
}
COMPILE::JS{
    import DisplayObject = org.apache.royale.core.UIBase;
}

import mx.collections.CursorBookmark;
import mx.collections.ICollectionView;
import mx.collections.IViewCursor;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.beads.DataGridView;
import mx.controls.beads.layouts.DataGridLayout;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.controls.dataGridClasses.DataGridListArea;
import mx.core.IFactory;
import mx.core.Keyboard;
import mx.core.ScrollControlBase;
import mx.core.UIComponent;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.FlexEvent;
import mx.events.ListEvent;

import org.apache.royale.core.IChild;
import org.apache.royale.core.IDataProviderNotifier;
import org.apache.royale.core.IIndexedItemRenderer;
import org.apache.royale.core.IItemRenderer;
import org.apache.royale.core.IParent;
import org.apache.royale.core.ISelectionModel;
import org.apache.royale.core.IUIBase;
import org.apache.royale.events.Event;
import org.apache.royale.events.MouseEvent;
import org.apache.royale.geom.Point;
import org.apache.royale.utils.loadBeadFromValuesManager;
import org.apache.royale.html.beads.IDataGridView;
import org.apache.royale.core.IDataGrid;
import org.apache.royale.core.IDataGridModel;

use namespace mx_internal;


//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the <code>selectedIndex</code> or <code>selectedItem</code> property
 *  changes as a result of user interaction.
 *
 *  @eventType mx.events.ListEvent.CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
[Event(name="change", type="mx.events.ListEvent")]

/**
 *  Dispatched when the <code>data</code> property changes.
 *
 *  <p>When you use a component as an item renderer,
 *  the <code>data</code> property contains the data to display.
 *  You can listen for this event and update the component
 *  when the <code>data</code> property changes.</p>
 * 
 *  @eventType mx.events.FlexEvent.DATA_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
[Event(name="dataChange", type="mx.events.FlexEvent")]

/**
 *  Dispatched when the user rolls the mouse pointer over an item in the control.
 *
 *  @eventType mx.events.ListEvent.ITEM_ROLL_OVER
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Event(name="itemRollOver", type="mx.events.ListEvent")]

/**
 *  Dispatched when the user rolls the mouse pointer out of an item in the control.
 *
 *  @eventType mx.events.ListEvent.ITEM_ROLL_OUT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Event(name="itemRollOut", type="mx.events.ListEvent")]

/**
 *  Dispatched when the user clicks on an item in the control.
 *
 *  @eventType mx.events.ListEvent.ITEM_CLICK
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
[Event(name="itemClick", type="mx.events.ListEvent")]

/**
 *  Dispatched when the user double-clicks on an item in the control.
 *
 *  @eventType mx.events.ListEvent.ITEM_DOUBLE_CLICK
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
[Event(name="itemDoubleClick", type="mx.events.ListEvent")]

//--------------------------------------
//  Styles
//--------------------------------------
/* 
include "../../styles/metadata/FocusStyles.as"
include "../../styles/metadata/PaddingStyles.as"
 */
/**
 *  The colors to use for the backgrounds of the items in the list. 
 *  The value is an array of two or more colors. 
 *  The backgrounds of the list items alternate among the colors in the array. 
 *
 *  <p>For DataGrid controls, all items in a row have the same background color, 
 *  and each row's background color is determined from the array of colors.</p>
 *
 *  <p>For the TileList control, which uses a single list to populate a 
 *  two-dimensional display, the style can result in a checkerboard appearance,
 *  stripes, or other patterns based on the number of columns and rows and
 *  the number of colors specified.  TileList cycles through the colors, placing
 *  the individual item background colors according to the 
 *  layout direction. If you have an even number of colors and an even number of
 *  columns for a TileList layed out horizontally, you will get striping.  If
 *  the number of columns is an odd number, you will get a checkerboard pattern.
 *  </p>
 *
 *  <p>Only takes effect if no <code>backgroundColor</code> is specified.</p>
 *
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="alternatingItemColors", type="Array", arrayType="uint", format="Color", inherit="yes")]

/**
 *  The skin to use to indicate where a dragged item can be dropped.
 *  When an AdvancedListBase-derived component is a potential drop target in a
 *  drag-and-drop operation, a call to the <code>showDropFeedback()</code>
 *  method makes an instance of this class and positions it one pixel above
 *  the item renderer for the item where, if the drop occurs, is the item after
 *  the dropped item.
 *
 *  @default mx.controls.listClasses.ListDropIndicator
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="dropIndicatorSkin", type="Class", inherit="no")]

/**
 *  The number of pixels between the bottom of the row
 *  and the bottom of the renderer in the row.
 *
 *  @default 2
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="paddingBottom", type="Number", format="Length", inherit="no")]

/**
 *  The number of pixels between the top of the row
 *  and the top of the renderer in the row.
 *  
 *  @default 2
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="paddingTop", type="Number", format="Length", inherit="no")]

/**
 *  The color of the background of a renderer when the user rolls over it.
 *
 *  @default 0xEEFEE6
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="rollOverColor", type="uint", format="Color", inherit="yes")]

/**
 *  The color of the background of a renderer when the user selects it.
 *
 *  @default 0x7FCEFF
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="selectionColor", type="uint", format="Color", inherit="yes")]

/**
 *  The color of the background of a renderer when the component is disabled.
 *
 *  @default 0xDDDDDD
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="selectionDisabledColor", type="uint", format="Color", inherit="yes")]

/**
 *  The duration of the selection effect.
 *  When an item is selected an effect plays as the background is colored.
 *  Set to 0 to disable the effect.
 *  
 *  @default 250
 *  
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="selectionDuration", type="Number", format="Time", inherit="no")]

/**
 *  The easingFunction for the selection effect.
 *  When an item is selected an effect plays as the background is colored.
 *  The default is a linear fade in of the color.  An easingFunction can be used 
 *  for controlling the selection effect.
 *
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="selectionEasingFunction", type="Function", inherit="no")]

/**
 *  The color of the text of a renderer when the user rolls over a it.
 *
 *  @default 0x2B333C
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="textRollOverColor", type="uint", format="Color", inherit="yes")]

/**
 *  The color of the text of a renderer when the user selects it.
 *
 *  @default 0x2B333C
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="textSelectedColor", type="uint", format="Color", inherit="yes")]

/**
 *  A flag that controls whether items are highlighted as the mouse rolls 
 *  over them.
 *  If <code>true</code>, rows are highlighted as the mouse rolls over them.
 *  If <code>false</code>, rows are highlighted only when selected.
 *
 *  @default true
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="useRollOver", type="Boolean", inherit="no")]

/**
 *  The vertical alignment of a renderer in a row.
 *  Possible values are <code>"top"</code>, <code>"middle"</code>,
 *  and <code>"bottom"</code>.
 *  The DataGrid positions the renderers in a row based on this style
 *  and the <code>paddingTop</code> and <code>paddingBottom</code> styles.
 *  if the item in the columns for a row have different heights
 *  Other list classes do not use <code>verticalAlign</code> but
 *  the item renderers can examine this style property
 *  and adjust their layout based on it.
 *
 *  @default "top"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="verticalAlign", type="String", enumeration="bottom,middle,top", inherit="no")]

/**
 * The effect used when changes occur in the control's data provider.
 *
 * This can be a class reference (to a subclass of effect) or an 
 * Effect object instance. The former is appropriate for CSS, the
 * latter for inline definition within a component.
 *
 * @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
//[Style(name="dataChangeEffect", type="Object", inherit="no")]

//--------------------------------------
//  Other metadata
//--------------------------------------

//[AccessibilityClass(implementation="mx.accessibility.ListBaseAccImpl")]

/**
 *  The AdvancedListBase class is the base class for controls,
 *  such as the AdvancedDataGrid and OLAPDataGrid controls, that represent lists
 *  of items that can have one or more selected items and can scroll through the
 *  items.  Items are supplied using the <code>dataProvider</code> property
 *  and displayed via item renderers.
 *
 *  <p>In a model/view architecture, the AdvancedListBase subclass represent
 *  the view, and the data provider represents the model.</p>
 *
 *  @mxml
 *  
 *  <p>The AdvancedListBase class inherits all of the tag properties of its superclasses,
 *  and adds the following tag properties:</p>
 *  
 *  <pre>
 *  &lt;mx:<i>tagname</i>
 *    <b>Properties</b>
 *    allowDragSelection="false|true"
 *    allowMultipleSelection="false|true"
 *    columnCount="4"
 *    columnWidth="NaN"
 *    dataProvider="null"
 *    dataTipField="label"
 *    dataTipFunction="null"
 *    dragEnabled="false|true"
 *    dragMoveEnabled="false|true"
 *    dropEnabled="false|true"
 *    iconField="null"
 *    iconFunction="null"
 *    itemRenderer="null"
 *    labelField="label"
 *    labelFunction="null"
 *    lockedColumnCount=0
 *    lockedRowCount=0
 *    menuSelectionMode="false|true"
 *    rowCount="-1"
 *    rowHeight="NaN"
 *    selectable="true|false"
 *    selectedIndex="-1"
 *    selectedIndices="null"
 *    selectedItem="null"
 *    selectedItems="null"
 *    showDataTips="false|true"
 *    variableRowHeight="false|true"
 *    wordWrap="false|true"
 * 
 *    <b>Styles</b>
 *    alternatingItemColors="undefined"
 *    dataChangeEffect="undefined"
 *    dropIndicatorSkin="ListDropIndicator"
 *    focusAlpha="0.5"
 *    focusRoundedCorners="tl tr bl br"
 *    paddingBottom="2"
 *    paddingLeft="2"
 *    paddingRight="0"
 *    paddingTop="2"
 *    rollOverColor="0xEEFEE6"
 *    selectionColor="0x7FCEFF"
 *    selectionDisabledColor="0xDDDDDD"
 *    selectionDuration="250"
 *    selectionEasingFunction="undefined"
 *    textRollOverColor="0x2B333C"
 *    textSelectedColor="0x2B333C"
 *    useRollOver="true|false"
 *    verticalAlign="top|middle|bottom"
 * 
 *    <b>Events</b>
 *    change="<i>No default</i>"
 *    dataChange="<i>No default</i>"
 *    itemClick="<i>No default</i>"
 *    itemDoubleClick="<i>No default</i>"
 *    itemRollOut="<i>No default</i>"
 *    itemRollOver="<i>No default</i>"
 *    itemClick="<i>No default</i>"
 *   /&gt;
 *  </pre>
 *
 *  @see mx.collections.ICollectionView
 *  @see mx.controls.AdvancedDataGrid
 *  @see mx.controls.OLAPDataGrid
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 *  @royalesuppresspublicvarwarning
 */
public class DataGridListBase extends ListBase /* extends UIComponent
                      implements IDataRenderer, IFocusManagerComponent,
                      IListItemRenderer, IDropInListItemRenderer,
                      IEffectTargetHost */
{
    /* include "../../core/Version.as";
 */
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Anything in this list of styles will trigger a full repaint.
     */
    /* private var IS_ITEM_STYLE:Object =
    {
        alternatingItemColors: true,
        backgroundColor: true,
        backgroundDisabledColor: true,
        color: true,
        rollOverColor: true,
        selectionColor: true,
        selectionDisabledColor: true,
        styleName: true,
        textColor:true,
        textRollOverColor: true,
        textSelectedColor: true
    }; */

    /**
     *  @private
     *  Mouse movement threshold for determining when to start a drag.
     */
   // mx_internal static const DRAG_THRESHOLD:int = 4;

    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Placeholder for mixin by ListBaseAccImpl.
     */
   // mx_internal static var createAccessibilityImplementation:Function;

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
     *  @productversion Royale 0.9.4
     */
    public function DataGridListBase()
    {
        super();

      // tabEnabled = true;

         // addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
        // addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
        // addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
        // addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        // addEventListener(MouseEvent.CLICK, mouseClickHandler);
        // addEventListener(MouseEvent.DOUBLE_CLICK, mouseDoubleClickHandler);

      //  invalidateProperties();
    }

    /**
     *  @private
     */
    override public function set dataProvider(value:Object):void
    {
        if (collection)
            collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);

        collection = value as ICollectionView;
        if (collection)
		{
        		collection.addEventListener(CollectionEvent.COLLECTION_CHANGE, collectionChangeHandler);
	        iterator = collection.createCursor();
	        collectionIterator = collection.createCursor(); //IViewCursor(collection);
		}
        clearSelectionData();
        (model as ISelectionModel).selectedIndex = -1;
        super.dataProvider = value;

    }

    override public function addedToParent():void
    {
        if (!dataNotifier) {
            dataNotifier = loadBeadFromValuesManager(IDataProviderNotifier, "iDataProviderNotifier", this) as IDataProviderNotifier;
        }
        super.addedToParent();
        COMPILE::JS
        {
            // turn off drag and shift select of text
            element.style["user-select"] = "none";
            element.style["-webkit-touch-callout"] = "none";
            element.style["-webkit-user-select"] = "none";
            element.style["-moz-user-select"] = "none";
            element.style["-ms-user-select"] = "none";
        }
        if (!layout)
            layout = getBeadByType(DataGridLayout) as DataGridLayout;
    }

    private var _dataNotifier:IDataProviderNotifier;
    /**
     *  The IDataProviderNotifier that will watch for data
     *  provider changes.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
    public function get dataNotifier():IDataProviderNotifier
    {
        return _dataNotifier;
    }
    public function set dataNotifier(value:IDataProviderNotifier):void
    {
        _dataNotifier = value;
    }
    

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  An ICollectionView that represents the data provider.
     *  When you set the <code>dataProvider</code> property,
     *  Flex wraps the data provider as necessary to 
     *  support the ICollectionView interface and 
     *  sets this property to the result.
     *  The AdvancedListBase class then uses this property to access
     *  data in the provider.
     *  When you  get the <code>dataProvider</code> property, 
     *  Flex returns this value.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected var collection:ICollectionView;

    /**
     *  The main IViewCursor instance used to fetch items from the
     *  data provider and pass the items to the renderers.
     *  At the end of any sequence of code, it must always
     *  be positioned at the topmost visible item being displayed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected var iterator:IViewCursor;

    /**
     *  A flag that indicates that a page fault as occurred and that
     *  the iterator's position is not valid (not positioned at the topmost
     *  item being displayed).
     *  If the component gets a page fault (an ItemPending error), 
     *  it sets <code>iteratorValid</code> to <code>false</code>.  Code that
     *  normally handles the rendering of items checks this flag and does not 
     *  run until the page of data comes in from the server.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected var iteratorValid:Boolean = true;

    /**
     *  The most recent seek that caused a page fault.
     *  If there are multiple page faults, only the most recent one
     *  is of interest, as that is where to position the iterator 
     *  and start rendering rows again.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var lastSeekPending:ListBaseSeekPending;

    /**
     *  A hash table of data provider item renderers currently in view.
     *  The table is indexed by the data provider item's UID and is used
     *  to quickly get the renderer used to display a particular item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //protected var visibleData:Object = {};

    /**
     *  An internal display object that parents all of the item renderers,
     *  selection and highlighting indicators and other supporting graphics.
     *  This is roughly equivalent to the <code>contentPane</code> in the 
     *  Container class, and is used for managing scrolling.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var listContent:AdvancedListBaseContentHolder;

    /**
     *  The layer in <code>listContent</code> where all selection 
     *  and highlight indicators are drawn.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var selectionLayer:Sprite;

    /**
     *  An Array of Arrays that contains
     *  the item renderer instances that render each data provider item.
     *  This is a two-dimensional row major Array
     *  (Array of rows that are Arrays of columns).
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var listItems:Array = [];

    /**
     *  An array of ListRowInfo objects that cache row heights and 
     *  other tracking information for the rows in the <code>listItems</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var rowInfo:Array = [];

    /**
     *  A hash map of item renderers to their respective ListRowInfo object.
     *  The ListRowInfo object is indexed by the DisplayObject name of the
     *  item renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //protected var rowMap:Object = {};

    /**
     *  A stack of unused item renderers.
     *  Most list classes recycle renderers they've already created
     *  as they scroll out of the displayable area; doing so 
     *  saves time during scrolling.
     *  The recycled renderers are stored here.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var freeItemRenderers:Array = [];

    /**
     *  A hash map of currently unused item renderers that may be
     *  used again in the near future. Used when running data effects.
     *  The map is indexed by the data provider item's UID.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //protected var reservedItemRenderers:Object = {};

    /**
     *  A hash map of item renderers that are not subject
     *  to the layout algorithms of the list
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //protected var unconstrainedRenderers:Object = {};

    /**
     *  A dictionary mapping item renderers to the ItemWrappers
     *  used to supply their data. Only applicable if a data
     *  effect is running.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var dataItemWrappersByRenderer:Dictionary = new Dictionary(true);

    /**
     *  A flag that indicates if a data effect should be initiated
     *  the next time the display is updated.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //protected var runDataEffectNextUpdate:Boolean = false;

    /**
     *  A flag indicating if a data change effect is currently running
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var runningDataEffect:Boolean = false;

    /**
     *  The effect that plays when changes occur in the data
     *  provider for the control. 
     *  Set the effect by setting the <code>dataChangeEffect</code>
     *  style.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var cachedDataChangeEffect:Effect = null;

    /**
     *  The collection view that temporarily preserves previous
     *  data provider state to facilitate running data change effects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var modifiedCollectionView:ModifiedCollectionView;

    /**
     *  A copy of the value normally stored in the <code>collection</code>
     *  property used while running data changes effects. This value should be
     *  null when a data change effect is not running.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var actualCollection:ICollectionView;

    /**
     *  The number of extra item renderers the layout algorithm can use when
     *  constructing animations for data effects. Changes that take place in
     *  the data provider corresponding to the items visible onscreen or this
     *  many items before or after the items onscreen will be subject to 
     *  full effects processing. Items outside this range may not be 
     *  animated perfectly by the effects.
     *
     *  <p>A reasonable value for this property is approximately the number
     *  of rows visible onscreen. Setting it to a very large value may
     *  cause performance problems when used with a dataProvider with many
     *  items.</p>
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // public var offscreenExtraRows:int = 0;

     // TODO May have to reconsider for Tilelists (do we want to consider
     // rows? Do we do this separately for vertical/horizontal?
     // TODO this should be a property, and changing it should trigger
     //  update
     //  
     //  TODO Would rather not make this protected
     
    /**
     *  The number of offscreen items currently above the topmost visible
     *  renderer. This number will be &lt;= offscreenExtraRows / 2.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var offscreenExtraRowsTop:int = 0;

    /**
     *  The number of offscreen items currently below the bottommost visible
     *  item renderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var offscreenExtraRowsBottom:int = 0;

    /**
     *  The number of columns that are currently not visible.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
  //  public var offscreenExtraColumns:int = 0;

    /**
     *  The number of columns on the left side of the control 
     *  that are currently not visible.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
  //  protected var offscreenExtraColumnsLeft:int = 0;

    /**
     *  The number of columns on the right side of the control 
     *  that are currently not visible.
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
  //  protected var offscreenExtraColumnsRight:int = 0;
        
    /**
     *  A copy of the value normally stored in the <code>iterator</code>
     *  property used while running data changes effects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
  //  protected var actualIterator:IViewCursor;
            
    /**
     *  The UID of the item that is current rolled over or under the caret.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected var highlightUID:String;

    /**
     *  The renderer that is currently rolled over or under the caret.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected var highlightItemRenderer:IListItemRenderer;

    /**
     *  The DisplayObject that contains the graphics that indicates
     *  which renderer is highlighted.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //protected var highlightIndicator:Sprite;

    /**
     *  The UID of the item under the caret.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected var caretUID:String;

    /**
     *  The renderer for the item under the caret.  In the selection
     *  model, there is an anchor, a caret and a highlighted item.  When
     *  the mouse is being used for selection, the item under the mouse is
     *  highlighted as the mouse rolls over the item.  
     *  When the mouse is clicked with no modifier keys (Shift or Control), the
     *  set of selected items is cleared and the item under the highlight is
     *  selected and becomes the anchor.  The caret is unused in mouse
     *  selection.  
     *
     *  <p>If there is an anchor and another item is selected while
     *  using the Shift key, the old set of selected items is cleared, and
     *  all items between the item and the anchor are selected.  Clicking
     *  items while using the Control key toggles the selection of individual
     *  items and does not move the anchor.</p>
     *
     *  <p>When selecting items using the keyboard, if the arrow keys are used
     *  with no modifier keys, the old selection is cleared and the new item
     *  is selected and becomes the anchor and the caret, and a caret indicator
     *  is shown around the selection highlight.  </p>
     *
     *  <p>If the user uses arrow keys
     *  with the Shift key, the old selection is cleared and the items between
     *  the anchor and the new item are selected.  The caret moves to the new
     *  item.  </p>
     *
     *  <p>If arrow keys are used with the Control key, just the caret moves.
     *  The user can use the Space key to toggle selection of the item under
     *  the caret.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
 //   protected var caretItemRenderer:IListItemRenderer;

    /**
     *  The DisplayObject that contains the graphics that indicate
     *  which renderer is the caret.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //protected var caretIndicator:Sprite;

    /**
     *  A hash table of ListBaseSelectionData objects that track which
     *  items are currently selected.  The table is indexed by the UID
     *  of the items.
     *
     *  @see mx.controls.listClasses.ListBaseSelectionData
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
     protected var selectedData:Object = {};

    /**
     *  A hash table of selection indicators.  This table allows the component
     *  to quickly find and remove the indicators when the set of selected
     *  items is cleared.  The table is indexed by the item's UID.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected var selectionIndicators:Object = {};

    /**
     *  A hash table of selection tweens.  This allows the component to
     *  quickly find and clean up any tweens in progress if the set
     *  of selected items is cleared.  The table is indexed by the item's UID.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
  //  protected var selectionTweens:Object = {};

    /**
     *  A bookmark to the item under the caret.  A bookmark allows the
     *  component to quickly seek to a position in the collection of items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected var caretBookmark:CursorBookmark;

    /**
     *  A bookmark to the item that is the anchor.  A bookmark allows the
     *  component to quickly seek to a position in the collection of items.
     *  This property is used when selecting a set of items between the anchor
     *  and the caret or highlighted item, and when finding the selected item
     *  after a Sort or Filter is applied.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected var anchorBookmark:CursorBookmark;

    /**
     *  A flag that indicates whether to show caret.  
     *  This property is usually set
     *  to <code>false</code> when mouse activity is detected and set back to 
     *  <code>true</code> when the keyboard is used for selection.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected var showCaret:Boolean;

    /**
     *  The most recently calculated index where the drag item
     *  should be added to the drop target.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //protected var lastDropIndex:int;

    /**
     *  A flag that indicates whether the <code>columnWidth</code> 
     *  and <code>rowHeight</code> properties need to be calculated.
     *  This property is set to <code>true</code> if a style changes that can affect the
     *  measurements of the renderer, or if the data provider is changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //protected var itemsNeedMeasurement:Boolean = true;

    /**
     *  A flag that indicates that the size of the renderers may have changed.
     *  The component usually responds by re-applying the data items to all of
     *  the renderers on the next <code>updateDisplayList()</code> call.
     *  There is an assumption that re-applying the items will invalidate the
     *  item renderers and cause them to re-measure.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //protected var itemsSizeChanged:Boolean = false;

    /**
     *  A flag that indicates that the renderer changed.
     *  The component usually responds by destroying all existing renderers
     *  and redrawing all of the renderers on the next 
     *  <code>updateDisplayList()</code> call.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //protected var rendererChanged:Boolean = false;

    /**
     *  A flag that indicates that the a data change effect has
     *  just completed.
     *  The component usually responds by cleaning up various 
     *  internal data structures on the next 
     *  <code>updateDisplayList()</code> call.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var dataEffectCompleted:Boolean = false;

    /**
     *  A flag that indicates whether the value of the <code>wordWrap</code> 
     *  property has changed since the last time the display list was updated.
     *  This property is set when you change the <code>wordWrap</code> 
     *  property value, and is reset 
     *  to <code>false</code> by the <code>updateDisplayList()</code> method.
     *  The component usually responds by re-applying the data items to all of
     *  the renderers on the next <code>updateDisplayList()</code> call.
     *  This is different from itemsSizeChanged because it further indicates
     *  that re-applying the data items to the renderers may not invalidate them
     *  since the only thing that changed was whether or not the renderer should
     *  factor in wordWrap into its size calculations
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var wordWrapChanged:Boolean = false;

    /**
     *  A flag that indicates if keyboard selection was interrupted by 
     *  a page fault.  The component responds by suspending the rendering
     *  of items until the page of data arrives.
     *  The <code>finishKeySelection()</code> method will be called
     *  when the paged data arrives
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected var keySelectionPending:Boolean = false;
    
    
    /**
     *  The offset of the item in the data provider that is the selection
     *  anchor point.
     *
     *  @see mx.controls.listClasses.ListBase#caretItemRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected var anchorIndex:int = -1;

    /**
     *  The offset of the item in the data provider that is at the selection
     *  caret point.
     *
     *  @see mx.controls.listClasses.ListBase#caretItemRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected var caretIndex:int = -1;
    
    /**
     *  @private
     */
    //private var columnCountChanged:Boolean = true;
    
    /**
     *  @private
     */
    //private var columnWidthChanged:Boolean = false;

    /**
     *  The default number of columns to display.  This value
     *  is used if the calculation for the number of
     *  columns results in a value less than 1 when
     *  trying to calculate the column count based on size or
     *  content.
     *
     *  @default 4
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var defaultColumnCount:int = 4;

    /**
     *  The default number of rows to display.  This value
     *  is used  if the calculation for the number of
     *  columns results in a value less than 1 when
     *  trying to calculate the row count based on size or
     *  content.
     *
     *  @default 4
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var defaultRowCount:int = 4;

    /**
     *  The column count requested by explicitly setting the
     *  <code>columnCount</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var explicitColumnCount:int = -1;

    /**
     *  The column width requested by explicitly setting the 
     *  <code>columnWidth</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var explicitColumnWidth:Number;

    /**
     *  The row count requested by explicitly setting
     *  <code>rowCount</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var explicitRowCount:int = -1;

    /**
     *  The row height requested by explicitly setting
     *  <code>rowHeight</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var explicitRowHeight:Number;
    
    /**
     *  @private
     */
   // private var rowCountChanged:Boolean = true;
    
    /**
     *  @private
     *  Cached style value.
     */
   // mx_internal var cachedPaddingTop:Number;
    
    /**
     *  @private
     *  Cached style value.
     */
  //  mx_internal var cachedPaddingBottom:Number;
    
    /**
     *  @private
     *  Cached style value.
     */
   // mx_internal var cachedVerticalAlign:String;
    
    /**
     *  @private
     */
  //  private var oldUnscaledWidth:Number;
    
    /**
     *  @private
     */
   // private var oldUnscaledHeight:Number;

    /**
     *  @private
     */
    //private var horizontalScrollPositionPending:Number;

    /**
     *  @private
     */
   // private var verticalScrollPositionPending:Number;

    /**
     *  @private
     */
   // private var mouseDownPoint:Point;

    /**
     *  @private
     */
   // private var bSortItemPending:Boolean = false;

    // these three keep track of the key selection that caused
    // the page fault
    private var bShiftKey:Boolean = false;
    private var bCtrlKey:Boolean = false;
    private var lastKey:uint = 0;
    private var bSelectItem:Boolean = false;
 
    /**
     *  @private
     *  true if we don't know for sure what index we're on in the database
     */
    private var approximate:Boolean = false;

    // if false, pixel scrolling only in horizontal direction
   // mx_internal var bColumnScrolling:Boolean = true;

    // either "horizontal", "vertical", "grid"  Used to determine how
    // to measure the list.
   // mx_internal var listType:String = "grid";

    // mx_internal for automation delegate access
    mx_internal var bSelectOnRelease:Boolean;
    
    private var mouseDownItem:IItemRenderer; //IListItemRenderer;
    /*
	private var mouseDownIndex:int; // For drag and drop
   */
    mx_internal var bSelectionChanged:Boolean = false;
    mx_internal var bSelectedIndexChanged:Boolean = false;
    private var bSelectedItemChanged:Boolean = false;
    private var bSelectedItemsChanged:Boolean = false;
    private var bSelectedIndicesChanged:Boolean = false;

    /**
     *  @private
     *  Dirty flag for the cache style value cachedPaddingTop.
     */
    //private var cachedPaddingTopInvalid:Boolean = true;
    
    /**
     *  @private
     *  Dirty flag for the cache style value cachedPaddingBottom.
     */
   // private var cachedPaddingBottomInvalid:Boolean = true;
    
    /**
     *  @private
     *  Dirty flag for the cache style value cachedVerticalAlign.
     */
   // private var cachedVerticalAlignInvalid:Boolean = true;

    /**
     *  @private
     *  The first ListBaseSelectionData in a link list of ListBaseSelectionData.
     *  This represents the item that was most recently selected.  
     *  ListBaseSelectionData instances are linked together and keep track of the 
     *  order the user selects an item.  This order is reflected in selectedIndices 
     *  and selectedItems.
     */
    private var firstSelectionData:ListBaseSelectionData;

    /**
     *  The renderer that is or was rolled over or under the caret.
     *  In DG, this is always column 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // mx_internal var lastHighlightItemRenderer:IListItemRenderer;

    /**
     *  The renderer that is or was rolled over or under the caret.
     *  In DG, this is the actual item
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // mx_internal var lastHighlightItemRendererAtIndices:IListItemRenderer;

    /**
     *  The last coordinate send in ITEM_ROLL_OVER
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // private var lastHighlightItemIndices:Point;

   // private var dragScrollingInterval:int = 0;

    /**
     *  @private
     *  An Array of Shapes that are used as clip masks for the list items
     */
   // private var itemMaskFreeList:Array;

    /**
     *  @private
     *  An array of item renderers being tracked for MoveEvents while 
     *  data change effects are running.
     */
   // private var trackedRenderers:Array = [];

    /**
     *  @private
     *  Whether the mouse button is pressed
     */
    mx_internal var isPressed:Boolean = false;

    /**
     *  A separate IViewCursor used to find indices of items and
     *  other things.  The collectionIterator can be at any
     *  place within the set of items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    mx_internal var collectionIterator:IViewCursor;
 /*
    mx_internal var dropIndicator:IFlexDisplayObject;
 */
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: UIComponent
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  enabled
    //----------------------------------

   // [Inspectable(category="General")]

    /**
     *  @private
     */
    /* override public function set enabled(value:Boolean):void
    {
        super.enabled = value;

        var ui:IFlexDisplayObject = border as IFlexDisplayObject;
        if (ui)
        {
            if (ui is IUIComponent)
                IUIComponent(ui).enabled = value;
            if (ui is IInvalidating)
                IInvalidating(ui).invalidateDisplayList();
        }

        itemsSizeChanged = true;

        invalidateDisplayList();
    } */

    //----------------------------------
    //  showInAutomationHierarchy
    //----------------------------------

    /**
     *  @private
     */
    /* override public function set showInAutomationHierarchy(value:Boolean):void
    {
        //do not allow value changes
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties: ScrollControlBase
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  horizontalScrollPolicy
    //----------------------------------

    /**
     *  @private
     */
    /* override public function set horizontalScrollPolicy(value:String):void
    {
        super.horizontalScrollPolicy = value;
        itemsSizeChanged = true;

        invalidateDisplayList();
    } */

    //----------------------------------
    //  horizontalScrollPosition
    //----------------------------------

    /**
     *  @private
     */
   /*  override public function get horizontalScrollPosition():Number
    {
        if (!isNaN(horizontalScrollPositionPending))
            return horizontalScrollPositionPending;

        return super.horizontalScrollPosition;
    } */

    /**
     *  @private
     */
    /* override public function set horizontalScrollPosition(value:Number):void
    {
        // if not init or no data;
        if (listItems.length == 0 || !dataProvider || !isNaN(horizontalScrollPositionPending))
        {
            horizontalScrollPositionPending = value;
            if (dataProvider)
                invalidateDisplayList();
            return;
        }
        horizontalScrollPositionPending = NaN;

        // trace("set horizontalScrollPosition " + value + " " + super.horizontalScrollPosition);

        var oldValue:int = super.horizontalScrollPosition;
        super.horizontalScrollPosition = value;

        removeClipMask();

        if (oldValue != value)
        {
            // we're going to get a full repaint soon so don't bother here.
            if (itemsSizeChanged)
                return;

            var deltaPos:int = value - oldValue;
            var direction:Boolean = (deltaPos > 0);
            deltaPos = Math.abs(deltaPos);
            if (bColumnScrolling && deltaPos >= columnCount - lockedColumnCount)
            {
                clearIndicators();
                visibleData = {};
                makeRowsAndColumnsWithExtraColumns(oldUnscaledWidth, oldUnscaledHeight);
                drawRowBackgrounds();
            }
            else
            {
                scrollHorizontally(value, deltaPos, direction);
            }
        }

        addClipMask(false);
    } */
    
    
   /* //----------------------------------
    //  borderVisible
    //----------------------------------
    public function get borderVisible():Boolean
    {
        return true;
    }
    public function set borderVisible(value:Boolean):void
    {
    } */

    //----------------------------------
    //  verticalScrollPolicy
    //----------------------------------

    /**
     *  @private
     */
    /* override public function set verticalScrollPolicy(value:String):void
    {
        super.verticalScrollPolicy = value;
        itemsSizeChanged = true;

        invalidateDisplayList();
    } */

    //----------------------------------
    //  verticalScrollPosition
    //----------------------------------

    /* [Bindable("scroll")]
    [Bindable("viewChanged")]
 */
    /**
     *  @private
     */
    /* override public function get verticalScrollPosition():Number
    {
        if (!isNaN(verticalScrollPositionPending))
            return verticalScrollPositionPending;

        return super.verticalScrollPosition;
    } */

    /**
     *  @private
     */
    /* override public function set verticalScrollPosition(value:Number):void
    {
        if (listItems.length == 0 || !dataProvider || !isNaN(verticalScrollPositionPending))
        {
            verticalScrollPositionPending = value;
            if (dataProvider)
                invalidateDisplayList();
            return;
        }
        verticalScrollPositionPending = NaN;

        var oldValue:int = super.verticalScrollPosition;
        super.verticalScrollPosition = value;

        removeClipMask();
        var oldoffscreenExtraRowsTop:int = offscreenExtraRowsTop;
        var oldoffscreenExtraRowsBottom:int = offscreenExtraRowsBottom;

        // trace("set verticalScrollPosition", oldValue, value);
        if (oldValue != value)
        {
            var deltaPos:int = value - oldValue;
            var direction:Boolean = (deltaPos > 0);
            deltaPos = Math.abs(deltaPos);
            if (deltaPos >= rowInfo.length - lockedRowCount || !iteratorValid)
            {
                clearIndicators();
                visibleData = {};
                makeRowsAndColumnsWithExtraRows(oldUnscaledWidth, oldUnscaledHeight);
            }
            else
            {
                scrollVertically(value, deltaPos, direction);
                adjustListContent(oldUnscaledWidth,oldUnscaledHeight);
            }
            // if variable rowheight, we have to recalibrate the scrollbars thumb size
            // on each scroll, otherwise you can't scroll down to a bunch of fat rows
            // at the bottom of a list.
            if (variableRowHeight)
                configureScrollBars();

            drawRowBackgrounds();
        }
        // if needed, add a clip mask to the items in the last row of the list
        addClipMask((offscreenExtraRowsTop != oldoffscreenExtraRowsTop) || (offscreenExtraRowsBottom != oldoffscreenExtraRowsBottom));
    } */

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
     public function get headerStyleName():String
    {
        return "";
    } 

    /**
     *  @private
     */
    public function set headerStyleName(value:String):void
    {
    }
    //----------------------------------
    //  allowDragSelection
    //----------------------------------

    /**
     *  A flag that indicates whether drag-selection is enabled.
     *  Drag-selection is the ability to select an item by dragging
     *  into it as opposed to normal selection where you can't have
     *  the mouse button down when you mouse over the item you want
     *  to select.  This feature is used in ComboBox dropdowns
     *  to support pressing the mouse button when the mouse is over the 
     *  dropdown button, and then dragging the mouse into the dropdown to select
     *  an item.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
	 *	@royalesuppresspublicvarwarning 
	 */	 	
    public var allowDragSelection:Boolean = false;

    
    //----------------------------------
    //  styleFunction
    //----------------------------------
	
     private var _styleFunction:Function;
	 
     public function get styleFunction():Function
     {
	 return _styleFunction;
     }
     public function set styleFunction(value:Function):void
     {
	 _styleFunction = value;
     }
	 
	 
    //----------------------------------
    //  columnCount
    //----------------------------------

    /**
     *  @private
     *  Storage for the columnCount property.
     */
    private var _columnCount:int = -1;

    /**
     *  The number of columns to be displayed in a TileList control or items 
     *  in a HorizontalList control. 
     *  For the data grids, specifies the number of visible columns.
     *
     *  <p><b>Note</b>: Setting this property has no effect on a DataGrid control,
     *  which bases the number of columns on the control width and the
     *  individual column widths.</p>
     * 
     *  @default 4
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
     public function get columnCount():int
    {
        return _columnCount;
    } 

    /**
     *  @private
     */
     public function set columnCount(value:int):void
    {
       /* explicitColumnCount = value;

        if (_columnCount != value)
        {
            setColumnCount(value);
            columnCountChanged = true;
            invalidateProperties();

            invalidateSize();
            itemsSizeChanged = true;
            invalidateDisplayList();

            dispatchEvent(new Event("columnCountChanged"));
        } */
    } 

    /**
     *  Internal version for setting columnCount
     *  without invalidation or notification.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  mx_internal function setColumnCount(value:int):void
    {
        _columnCount = value;
    } */


    //----------------------------------
    //  data
    //----------------------------------

    /**
     *  @private
     *  Storage for the data property.
     */
    /* private var _data:Object;

    [Bindable("dataChange")]
    [Inspectable(environment="none")] */

    /**
     *  The item in the data provider this component should render when
     *  this component is used as an item renderer or item editor.
     *  The list class sets this property on each renderer or editor
     *  and the component displays the data.  ListBase-derived classes
     *  support this property for complex situations like having a
     *  List of DataGrids or a DataGrid where one column is a List.
     *
     *  <p>The list classes use the <code>listData</code> property
     *  in addition to the <code>data</code> property to determine what
     *  to display.
     *  If the list class is in a DataGrid it expects the <code>dataField</code>
     *  property of the column to map to a property in the data
     *  and sets <code>selectedItem</code> value to that property.
     *  If it is in a List or TileList control, it expects the 
     *  <code>labelField</code> property of the list to map to a property 
     *  in the data, and sets <code>selectedItem</code> value to that property.
     *  Otherwise it sets the <code>selectedItem</code> to the data itself.</p>
     * 
     *  <p>This property uses the data provider but does not set it. 
     *  In all cases, you must set the data provider in some other way.</p>
     *
     *  <p>You do not set this property in MXML.</p>
     *
     *  @see mx.core.IDataRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get data():Object
    {
        return _data;
    } */

    /**
     *  @private
     */
   /*  public function set data(value:Object):void
    {
        _data = value;

        if (_listData && _listData is DataGridListData)
            selectedItem = _data[DataGridListData(_listData).dataField];
        else if (_listData is ListData && ListData(_listData).labelField in _data)
            selectedItem = _data[ListData(_listData).labelField];
        else
            selectedItem = _data;

        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    } */


    //----------------------------------
    //  dataTipField
    //----------------------------------

    /**
     *  @private
     *  Storage for the dataTipField property.
     */
    /* private var _dataTipField:String = "label";

    [Bindable("dataTipFieldChanged")]
    [Inspectable(category="Data", defaultValue="label")]
 */
    /**
     *  Name of the field in the data provider items to display as the 
     *  data tip. By default, the list looks for a property named 
     *  <code>label</code> on each item and displays it.
     *  However, if the data objects do not contain a <code>label</code> 
     *  property, you can set the <code>dataTipField</code> property to
     *  use a different property in the data object. An example would be 
     *  "FullName" when viewing a
     *  set of people's names retrieved from a database.
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  public function get dataTipField():String
    {
        return _dataTipField;
    }
	*/
    /**
     *  @private
     */
   /* public function set dataTipField(value:String):void
    {
        _dataTipField = value;

        itemsSizeChanged = true;
        invalidateDisplayList();

        dispatchEvent(new Event("dataTipFieldChanged"));
    } */

    //----------------------------------
    //  dataTipFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for the dataTipFunction property.
     */
    private var _dataTipFunction:Function;

    [Bindable("dataTipFunctionChanged")]
    [Inspectable(category="Data")]
 
    /**
     *  User-supplied function to run on each item to determine its dataTip.  
     *  By default, the list looks for a property named <code>label</code> 
     *  on each data provider item and displays it.
     *  However, some items do not have a <code>label</code> property 
     *  nor do they have another property that can be used for displaying 
     *  in the rows. An example is a data set that has lastName and firstName 
     *  fields, but you want to display full names. You can supply a 
     *  <code>dataTipFunction</code> that finds the appropriate
     *  fields and return a displayable string. The 
     *  <code>dataTipFunction</code> is also good for handling formatting
     *  and localization.
     *
     *  <p>The dataTipFunction takes a single argument which is the item
     *  in the data provider and returns a String:</p>
     * 
     *  <blockquote>
     *  <code>myDataTipFunction(item:Object):String</code>
     *  </blockquote>
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
     public function get dataTipFunction():Function
    {
        return _dataTipFunction;
    } 

    /**
     *  @private
     */
     public function set dataTipFunction(value:Function):void
    {
        _dataTipFunction = value;

        /* itemsSizeChanged = true;
        invalidateDisplayList();

        dispatchEvent(new Event("dataTipFunctionChanged")); */
    } 


    //----------------------------------
    //  dragImage
    //----------------------------------

    /**
     *  An instance of a class that displays the visuals
     *  during a drag and drop operation.
     *
     *  @default mx.controls.listClasses.ListItemDragProxy
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function get dragImage():IUIComponent
    {
        var image:ListItemDragProxy = new ListItemDragProxy();
        image.owner = this;
        image.moduleFactory = moduleFactory;
        return image;
    } */

    //----------------------------------
    //  dragImageOffsets
    //----------------------------------

    /**
     *  The offset of the drag image for drag and drop.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function get dragImageOffsets():Point
    {
        var pt:Point = new Point;

        var n:int = listItems.length;
        for (var i:int = lockedRowCount; i < n; i++)
        {
            if (selectedData[rowInfo[i].uid])
            {
                pt.x = listItems[i][0].x;
                pt.y = listItems[i][0].y;
            }
        }

        return pt;
    }
 */
    //----------------------------------
    //  dragMoveEnabled
    //----------------------------------

    /**
     *  @private
     *  Storage for the dragMoveEnabled property.
     */
    /* private var _dragMoveEnabled:Boolean = false;

    [Inspectable(defaultValue="false")]
 */
    /**
     *  A flag that indicates whether items can be moved instead
     *  of just copied from the control as part of a drag-and-drop
     *  operation.
     *  If <code>true</code>, and the <code>dragEnabled</code> property
     *  is <code>true</code>, items can be moved.
     *  Often the data provider cannot or should not have items removed
     *  from it, so a MOVE operation should not be allowed during
     *  drag-and-drop.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get dragMoveEnabled():Boolean
    {
        return _dragMoveEnabled;
    } */

    /**
     *  @private
     */
    /* public function set dragMoveEnabled(value:Boolean):void
    {
        _dragMoveEnabled = value;
    } */

    //----------------------------------
    //  dropEnabled
    //----------------------------------

    /**
     *  @private
     *  Storage for the <code>dropEnabled</code> property.
     */
    /* private var _dropEnabled:Boolean = false;

    [Inspectable(defaultValue="false")]
 */
    /**
     *  A flag that indicates whether dragged items can be dropped onto the 
     *  control.
     *
     *  <p>If you set this property to <code>true</code>,
     *  the control accepts all data formats, and assumes that
     *  the dragged data matches the format of the data in the data provider.
     *  If you want to explicitly check the data format of the data
     *  being dragged, you must handle one or more of the drag events,
     *  such as <code>dragOver</code>, and call the DragEvent's
     *  <code>preventDefault()</code> method to customize
     *  the way the list class accepts dropped data.</p>
     *
     *  <p>When you set <code>dropEnabled</code> to <code>true</code>, 
     *  Flex automatically calls the <code>showDropFeedback()</code> 
     *  and <code>hideDropFeedback()</code> methods to display the drop indicator.</p>
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get dropEnabled():Boolean
    {
        return _dropEnabled;
    } */

    /**
     *  @private
     */
    /* public function set dropEnabled(value:Boolean):void
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
    } */

    //----------------------------------
    //  iconField
    //----------------------------------

    /**
     *  @private
     *  Storage for iconField property.
     */
   /*  private var _iconField:String = "icon";

    [Bindable("iconFieldChanged")]
    [Inspectable(category="Data", defaultValue="")]
 */
    /**
     *  The name of the field in the data provider object that determines what to 
     *  display as the icon. By default, the list class does not try to display 
     *  icons with the text in the rows.  However, by specifying an icon 
     *  field, you can specify a graphic that is created and displayed as an 
     *  icon in the row.  This property is ignored by DataGrid.
     *
     *  <p>The renderers will look in the data provider object for a property of 
     *  the name supplied as the iconField.  If the value of the property is a 
     *  Class, it will instantiate that class and expect it to be an instance 
     *  of an IFlexDisplayObject.  If the value of the property is a String, 
     *  it will look to see if a Class exists with that name in the application, 
     *  and if it can't find one, it will also look for a property on the 
     *  document with that name and expect that property to map to a Class.</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get iconField():String
    {
        return _iconField;
    } */

    /**
     *  @private
     */
    /* public function set iconField(value:String):void
    {
        _iconField = value;

        itemsSizeChanged = true;
        invalidateDisplayList();

        dispatchEvent(new Event("iconFieldChanged"));
    } */

    //----------------------------------
    //  iconFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for iconFunction property.
     */
   /*  private var _iconFunction:Function;

    [Bindable("iconFunctionChanged")]
    [Inspectable(category="Data")]
 */
    /**
     *  A user-supplied function to run on each item to determine its icon.  
     *  By default the list does not try to display icons with the text 
     *  in the rows.  However, by specifying an icon function, you can specify 
     *  a Class for a graphic that will be created and displayed as an icon 
     *  in the row.  
     *
     *  <p>The <code>iconFunction</code> takes a single argument which is the item
     *  in the data provider and returns a Class. 
     *  Shown below is the signature of the function:</p>
     * 
     *  <pre>iconFunction(item:Object):Class</pre>
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get iconFunction():Function
    {
        return _iconFunction;
    } */

    /**
     *  @private
     */
   /*  public function set iconFunction(value:Function):void
    {
        _iconFunction = value;

        itemsSizeChanged = true;
        invalidateDisplayList();

        dispatchEvent(new Event("iconFunctionChanged"));
    } */


    //----------------------------------
    //  labelField
    //----------------------------------

    /**
     *  @private
     *  Storage for labelField property.
     */
   /*  private var _labelField:String = "label";

    [Bindable("labelFieldChanged")]
    [Inspectable(category="Data", defaultValue="label")]
 */
    /**
     *  The name of the field in the data provider items to display as the label. 
     *  By default the list looks for a property named <code>label</code> 
     *  on each item and displays it.
     *  However, if the data objects do not contain a <code>label</code> 
     *  property, you can set the <code>labelField</code> property to
     *  use a different property in the data object. An example would be 
     *  "FullName" when viewing a set of people names fetched from a database.
     *
     *  @default "label"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  public function get labelField():String
    {
        return _labelField;
    } */

    /**
     *  @private
     */
    /* public function set labelField(value:String):void
    {
        _labelField = value;

        itemsSizeChanged = true;
        invalidateDisplayList();

        dispatchEvent(new Event("labelFieldChanged"));
    } */
    public function get verticalAlign():String
    {
        return "middle";
    }
    public function set verticalAlign(value:String):void
    {
    }
    //----------------------------------
    //  labelFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for labelFunction property.
     */
   /*  private var _labelFunction:Function;

    [Bindable("labelFunctionChanged")]
    [Inspectable(category="Data")]
 */
    /**
     *  A user-supplied function to run on each item to determine its label.  
     *  By default, the list looks for a property named <code>label</code> 
     *  on each data provider item and displays it.
     *  However, some data sets do not have a <code>label</code> property
     *  nor do they have another property that can be used for displaying.
     *  An example is a data set that has lastName and firstName fields
     *  but you want to display full names.
     *
     *  <p>You can supply a <code>labelFunction</code> that finds the 
     *  appropriate fields and returns a displayable string. The 
     *  <code>labelFunction</code> is also good for handling formatting and 
     *  localization. </p>
     *
     *  <p>For most components, the label function takes a single argument
     *  which is the item in the data provider and returns a String.</p>
     *  <pre>
     *  myLabelFunction(item:Object):String</pre>
     *
     *  <p>The method signature for the data grid classes is:</p>
     *  <pre>
     *  myLabelFunction(item:Object, column:DataGridColumn):String</pre>
     * 
     *  <p>where <code>item</code> contains the DataGrid item object, and
     *  <code>column</code> specifies the DataGrid column.</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get labelFunction():Function
    {
        return _labelFunction;
    } */

    /**
     *  @private
     */
    /* public function set labelFunction(value:Function):void
    {
        _labelFunction = value;

        itemsSizeChanged = true;
        invalidateDisplayList();

        dispatchEvent(new Event("labelFunctionChanged"));
    }
 */
    //----------------------------------
    //  listData
    //----------------------------------

    /**
     *  @private
     *  Storage for the listData property.
     */
   /*  private var _listData:BaseListData;

    [Bindable("dataChange")]
    [Inspectable(environment="none")]
 */
    /**
     *  
     *  When a component is used as a drop-in item renderer or drop-in
     *  item editor, Flex initializes the <code>listData</code> property
     *  of the component with the additional data from the list control.
     *  The component can then use the <code>listData</code> property
     *  and the <code>data</code> property to display the appropriate
     *  information as a drop-in item renderer or drop-in item editor.
     *
     *  <p>You do not set this property in MXML or ActionScript;
     *  Flex sets it when the component is used as a drop-in item renderer
     *  or drop-in item editor.</p>
     *
     *  @see mx.controls.listClasses.IDropInListItemRenderer
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get listData():BaseListData
    {
        return _listData;
    } */

    /**
     *  @private
     */
   /*  public function set listData(value:BaseListData):void
    {
        _listData = value;
    } */
    
    //----------------------------------
    //  lockedColumnCount
    //----------------------------------

    /**
     *  @private
     *  Storage for the lockedColumnCount property.
     */
    /* mx_internal var _lockedColumnCount:int = 0;

    [Inspectable(defaultValue="0")]
 */
    /**
     *  The index of the first column in the control that scrolls,
     *  where the first column is at an index of 0.
     *  Columns with indexes that are lower than this value remain fixed
     *  in view. This property is not supported by all list classes.
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get lockedColumnCount():int
    {
        return _lockedColumnCount;
    } */

    /**
     *  @private
     */
   /*  public function set lockedColumnCount(value:int):void
    {
        _lockedColumnCount = value;

        invalidateDisplayList();
    } */

    //----------------------------------
    //  lockedRowCount
    //----------------------------------

    /**
     *  @private
     *  Storage for the lockedRowCount property.
     */
    mx_internal var _lockedRowCount:int = 0;

    [Inspectable(defaultValue="0")]

    /**
     *  The index of the first row in the control that scrolls,
     *  where the first row is at an index of 0.
     *  Rows above this one remain fixed in view.
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function get lockedRowCount():int
    {
        return _lockedRowCount;
    }

    /**
     *  @private
     */
    public function set lockedRowCount(value:int):void
    {
        _lockedRowCount = value;

        invalidateDisplayList();
    }

    //----------------------------------
    //  menuSelectionMode
    //----------------------------------

    /**
     *  A flag that indicates whether menu-style selection
     *  should be used.
     *  In a Menu, dragging from
     *  one renderer into another selects the new one
     *  and un-selects the old.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //public var menuSelectionMode:Boolean = false;

    //----------------------------------
    //  selectable
    //----------------------------------

    /**
     *  @private
     *  Storage for the selectable property.
     */
    private var _selectable:Boolean = true;

    [Inspectable(defaultValue="true")]

    /**
     *  A flag that indicates whether the list shows selected items
     *  as selected.
     *  If <code>true</code>, the control supports selection.
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function get selectable():Boolean
    {
        return _selectable;
    }

    /**
     *  @private
     */
    public function set selectable(value:Boolean):void
    {
        _selectable = value;
    }

    /**
     *  @private
     *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
     */
    override public function set selectedIndex(value:int):void
    {   
        if (collection)
            value = Math.min(collection.length - 1, value);
        clearSelected();
        super.selectedIndex = value;
    }
    
    //----------------------------------
    //  showDataTips
    //----------------------------------

    /**
     *  @private
     *  Storage for the showDataTips property.
     */
    /* private var _showDataTips:Boolean = false;

    [Bindable("showDataTipsChanged")]
    [Inspectable(category="Data", defaultValue="false")]
 */
    /**
     *  A flag that indicates whether dataTips are displayed for text in the rows.
     *  If <code>true</code>, dataTips are displayed.  DataTips
     *  are tooltips designed to show the text that is too long for the row.
     *  If you set a dataTipFunction, dataTips are shown regardless of whether the
     *  text is too long for the row.
     * 
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get showDataTips():Boolean
    {
        return _showDataTips;
    } */

    /**
     *  @private
     */
    /* public function set showDataTips(value:Boolean):void
    {
        _showDataTips = value;

        itemsSizeChanged = true;
        invalidateDisplayList();

        dispatchEvent(new Event("showDataTipsChanged"));
    } */

    //----------------------------------
    //  value
    //----------------------------------

    /* [Bindable("change")]
    [Bindable("valueCommit")]
 */
    /**
     *  The selected item, or the data or label field of the selected item.
     *  If the selected item is a Number or String
     *  the value is the item.  If the item is an object, the value is
     *  the data property if it exists, or the label property if it exists.
     *
     *  <p>Note: Using <code>selectedItem</code> is often preferable. This
     *  property exists for backward compatibility with older applications</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get value():Object
    {
        var item:Object = selectedItem;

        if (!item)
            return null;

        if (typeof(item) != "object")
            return item;

        return item.data != null ? item.data : item.label;
    } */

    //----------------------------------
    //  wordWrap
    //----------------------------------

    /**
     *  @private
     *  Storage for the wordWrap property.
     */
     private var _wordWrap:Boolean = false;

    [Inspectable(category="General")] 

    /**
     *  A flag that indicates whether text in the row should be word wrapped.
     *  If <code>true</code>, enables word wrapping for text in the rows.
     *  Only takes effect if <code>variableRowHeight</code> is also 
     *  <code>true</code>
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function get wordWrap():Boolean
    {
        return _wordWrap;
    } 

    /**
     *  @private
     */
     public function set wordWrap(value:Boolean):void
    {
       /*  if (value == _wordWrap)
            return; */

        _wordWrap = value;

       /*  wordWrapChanged = true;
        itemsSizeChanged = true;

        invalidateDisplayList();

        dispatchEvent(new Event("wordWrapChanged")); */
    } 

    //--------------------------------------------------------------------------
    //
    //  Overridden methods: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
   /*  override protected function initializeAccessibility():void
    {
        //if (AdvancedListBase.createAccessibilityImplementation != null)
            //AdvancedListBase.createAccessibilityImplementation(this);
    } */

    /**
     *  Create objects that are children of this ListBase, in this case
     *  the <code>listContent</code> object that will hold all the item 
     *  renderers.
     *  Note that the item renderers are not created immediately, but later
     *  when Flex calls the <code>updateDisplayList()</code> method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* override protected function createChildren():void
    {
        super.createChildren();

        if (!listContent)
        {
            listContent = new AdvancedListBaseContentHolder(this);
            listContent.styleName = this;
            addChild(listContent);
        }

        // This invisible layer, which is a child of listContent
        // catches mouse events for all items
        // and is where we put selection highlighting by default.
        if (!selectionLayer)
        {
            selectionLayer = new FlexSprite();
            selectionLayer.name = "selectionLayer";
            selectionLayer.mouseEnabled = false;
            listContent.addChild(selectionLayer);

            // trace("selectionLayer parent set to " + selectionLayer.parent);

            var g:Graphics = selectionLayer.graphics;
            g.beginFill(0, 0); // 0 alpha means transparent
            g.drawRect(0, 0, 10, 10);
            g.endFill();
        }
    }
 */
    /**
     *  Calculates the column width and row height and number of rows and
     *  columns based on whether properties like <code>columnCount</code>
     *  <code>columnWidth</code>, <code>rowHeight</code> and 
     *  <code>rowCount</code> were explicitly set.
     *
     *  @see mx.core.ScrollControlBase
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* override protected function commitProperties():void
    {
        super.commitProperties();

        if (cachedPaddingTopInvalid)
        {
            cachedPaddingTopInvalid = false;
            cachedPaddingTop = getStyle("paddingTop");
            itemsSizeChanged = true;
            invalidateDisplayList();
        }

        if (cachedPaddingBottomInvalid)
        {
            cachedPaddingBottomInvalid = false;
            cachedPaddingBottom = getStyle("paddingBottom");
            itemsSizeChanged = true;
            invalidateDisplayList();
        }

        if (cachedVerticalAlignInvalid)
        {
            cachedVerticalAlignInvalid = false;
            cachedVerticalAlign = getStyle("verticalAlign");
            itemsSizeChanged = true;
            invalidateDisplayList();
        }

        if (columnCountChanged)
        {
            if (_columnCount < 1)
                _columnCount = defaultColumnCount;
            if (!isNaN(explicitWidth) && isNaN(explicitColumnWidth) && explicitColumnCount > 0)
                setColumnWidth((explicitWidth - viewMetrics.left - viewMetrics.right) / columnCount);
            columnCountChanged = false;
        }

        if (rowCountChanged)
        {
            if (_rowCount < 1)
                _rowCount = defaultRowCount;
            if (!isNaN(explicitHeight) && isNaN(explicitRowHeight) && explicitRowCount > 0)
                setRowHeight((explicitHeight - viewMetrics.top - viewMetrics.bottom) / rowCount);
            rowCountChanged = false;
        }
    } */

    /**
     *  Calculates the measured width and height of the component based 
     *  on the <code>rowCount</code>,
     *  <code>columnCount</code>, <code>rowHeight</code> and
     *  <code>columnWidth</code> properties.
     *
     *  @see mx.core.ScrollControlBase
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* override protected function measure():void
    {
        super.measure();

        var o:EdgeMetrics = viewMetrics;
        
        var cc:int = explicitColumnCount < 1 ?
                     defaultColumnCount :
                     explicitColumnCount;
        
        var rc:int = explicitRowCount < 1 ?
                     defaultRowCount :
                     explicitRowCount;

        if (!isNaN(explicitRowHeight))
        {
            measuredHeight = explicitRowHeight * rc + o.top + o.bottom;
            measuredMinHeight = explicitRowHeight * Math.min(rc, 2) +
                                o.top + o.bottom;
        }
        else
        {
            measuredHeight = rowHeight * rc + o.top + o.bottom;
            measuredMinHeight = rowHeight * Math.min(rc, 2) +
                                o.top + o.bottom;
        }

        if (!isNaN(explicitColumnWidth))
        {
            measuredWidth = explicitColumnWidth * cc + o.left + o.right;
            measuredMinWidth = explicitColumnWidth * Math.min(cc, 1) +
                               o.left + o.right;
        }
        else
        {
            measuredWidth = columnWidth * cc + o.left + o.right;
            measuredMinWidth = columnWidth * Math.min(cc, 1) +
                               o.left + o.right;
        }

        // Factor out scrollbars if policy == AUTO. See Container.viewMetrics.
        if (verticalScrollPolicy == ScrollPolicy.AUTO &&
            verticalScrollBar && verticalScrollBar.visible)
        {
            measuredWidth -= verticalScrollBar.minWidth;
            measuredMinWidth -= verticalScrollBar.minWidth;
        }
        if (horizontalScrollPolicy == ScrollPolicy.AUTO &&
            horizontalScrollBar && horizontalScrollBar.visible)
        {
            measuredHeight -= horizontalScrollBar.minHeight;
            measuredMinHeight -= horizontalScrollBar.minHeight;
        }
    } */

    /**
     *  @private 
     *  This is a copy of the code in UIComponent, modified to
     *  start a data change effect if appropriate.
     */
    /* override public function validateDisplayList():void
    {
        // this code is nearly duplicating UIComponent.validateDisplayList();
		
		oldLayoutDirection = layoutDirection;
		
        if (invalidateDisplayListFlag)
        {
            // Check if our parent is the top level system manager
            var sm:ISystemManager = parent as ISystemManager;
            if (sm)
            {
                if (sm == systemManager.topLevelSystemManager &&
                    sm.document != this)
                {
                    // Size ourself to the new measured width/height
                    setActualSize(getExplicitOrMeasuredWidth(),
                                  getExplicitOrMeasuredHeight());
                }
            }
			
			// Don't validate transform.matrix until after setting actual size
			validateMatrix();

            if (runDataEffectNextUpdate)
            {
                runDataEffectNextUpdate = false;
                runningDataEffect = true;
                initiateDataChangeEffect(unscaledWidth, unscaledHeight);
            }
            else
            {
                updateDisplayList(unscaledWidth, unscaledHeight);
            }

            invalidateDisplayListFlag = false;
        }
		else
		{
			validateMatrix();
		}
    }
 */
    /**
     *  Adds or removes item renderers if the number of displayable items 
     *  changed.
     *  Refreshes the item renderers if they might have changed.
     *  Applies the selection if it was changed programmatically.
     *
     *  @param unscaledWidth Specifies the width of the component, in pixels,
     *  in the component's coordinates, regardless of the value of the
     *  <code>scaleX</code> property of the component.
     *
     *  @param unscaledHeight Specifies the height of the component, in pixels,
     *  in the component's coordinates, regardless of the value of the
     *  <code>scaleY</code> property of the component.
     *
     *  @see mx.core.ScrollControlBase
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        if (oldUnscaledWidth == unscaledWidth &&
            oldUnscaledHeight == unscaledHeight &&
            !itemsSizeChanged && !bSelectionChanged &&
            !scrollAreaChanged)
        {
            return;
        }
        
        if (oldUnscaledWidth != unscaledWidth)
            itemsSizeChanged = true;

        super.updateDisplayList(unscaledWidth, unscaledHeight);

        var cursorPos:CursorBookmark;

        adjustListContent(unscaledWidth,unscaledHeight);
        
        var collectionHasItems:Boolean = (collection && collection.length > 0);

        if (collectionHasItems)
            adjustScrollPosition();

        // Remove the clip mask that was applied to items in the last row.
        removeClipMask();

        // have to resize selection layer without scaling so refill it
        var g:Graphics = selectionLayer.graphics;
        g.clear();
        if (listContent.width > 0 && listContent.height > 0)
        {
            g.beginFill(0x808080, 0);
            g.drawRect(0, 0, listContent.width, listContent.height);
            g.endFill();
        }

        if (rendererChanged)
            purgeItemRenderers(); 
        else if (dataEffectCompleted)
            partialPurgeItemRenderers();

        // optimize layout if only height is changing
        if (oldUnscaledWidth == unscaledWidth &&
            !scrollAreaChanged &&
            !itemsSizeChanged &&
            listItems.length > 0 &&
            iterator &&
            columnCount == 1)
        {
            var rowIndex:int = listItems.length - 1;
            if (oldUnscaledHeight > unscaledHeight)
                // shrinking, so just toss extra rows
                reduceRows(rowIndex);
            else 
                makeAdditionalRows(rowIndex);
        }
        else    // redo all layout
        {
            if (iterator)
                cursorPos = iterator.bookmark;
            clearIndicators();
            // visibleData = {};

            if (iterator)
            {
                if (offscreenExtraColumns)
                    makeRowsAndColumnsWithExtraColumns(unscaledWidth, unscaledHeight);
                else
                    makeRowsAndColumnsWithExtraRows(unscaledWidth, unscaledHeight);
            }
            else
            {
                makeRowsAndColumns(0, 0, listContent.width, listContent.height, 0, 0);
            }

            // restore iterator to original position
            seekPositionIgnoreError(iterator,cursorPos);
        }

        oldUnscaledWidth = unscaledWidth;
        oldUnscaledHeight = unscaledHeight;

        configureScrollBars();

        // if needed, add a clip mask to the items in the last row
        addClipMask(true);

        itemsSizeChanged = false;
        wordWrapChanged = false;

        adjustSelectionSettings(collectionHasItems);
        
        if (keySelectionPending && iteratorValid)
        {
            keySelectionPending = false;
            finishKeySelection();
        }
    } */

    /**
     *  @private
     */
    /* override public function styleChanged(styleProp:String):void
    {
        if (IS_ITEM_STYLE[styleProp])
        {
            itemsSizeChanged = true;
            invalidateDisplayList();
        }
        else if (styleProp == "paddingTop")
        {
            cachedPaddingTopInvalid = true;
            invalidateProperties();
        }
        else if (styleProp == "paddingBottom")
        {
            cachedPaddingBottomInvalid = true;
            invalidateProperties();
        }
        else if (styleProp == "verticalAlign")
        {
            cachedVerticalAlignInvalid = true;
            invalidateProperties();
        }
        else if (styleProp == "dataChangeEffect")
        {
            cachedDataChangeEffect = null;
        }
        else if (listItems)
        {
            var n:int = listItems.length;
            for (var i:int = 0; i < n; i++)
            {
                var m:int = listItems[i].length;
                for (var j:int = 0; j < m; j++)
                {
                    if (listItems[i][j])
                        listItems[i][j].styleChanged(styleProp);
                }
            }
        }

        super.styleChanged(styleProp);

        if (invalidateSizeFlag)
        {
            itemsNeedMeasurement = true;
            invalidateProperties();
        }

        if (styleManager.isSizeInvalidatingStyle(styleProp))
            scrollAreaChanged = true;
    } */

    //--------------------------------------------------------------------------
    //
    //  Methods: Measuring
    //
    //--------------------------------------------------------------------------

    /**
     *  Measures a set of items from the data provider using
     *  the current item renderer and returns the
     *  maximum width found.  This method is used to calculate the
     *  width of the component.  The various ListBase-derived classes
     *  have slightly different implementations.  DataGrid measures
     *  its columns instead of data provider items, and TileList
     *  just measures the first item and assumes all items are the
     *  same size.
     *
     *  <p>This method is not implemented in the AdvancedListBase class
     *  and must be implemented in the child class.</p>
     *
     *  <p>A negative <code>index</code> value can be used to specify
     *  that the width calculation includes any headers.</p>
     *
     *  @param index The data provider item at which to start measuring
     *  the width.
     *
     *  @param count The number of items to measure in calculating the width.
     *
     *  @return The widest of the measured items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function measureWidthOfItems(index:int = -1, count:int = 0):Number
    {
        return NaN;
    } */

    /**
     *  Measures a set of items from the data provider using the
     *  current item renderer and returns the sum of the heights
     *  of those items.
     *
     *  <p>This method is not implemented in the AdvancedListBase class
     *  and must be implemented in the child class.</p>
     *
     *  <p>A negative <code>index</code> value can be used to specify
     *  that the height calculation includes any headers.</p>
     *
     *  @param index The data provider item at which to start calculating
     *  the height.
     *
     *  @param count The number of items to use in calculating the height.
     *
     *  @return The sum of the height of the measured items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function measureHeightOfItems(index:int = -1, count:int = 0):Number
    {
        return NaN;
    } */

    //--------------------------------------------------------------------------
    //
    //  Methods: Item fields
    //
    //--------------------------------------------------------------------------

   /**
     *  Returns the string the renderer would display for the given data object
     *  based on the labelField and labelFunction properties.
     *  If the method cannot convert the parameter to a string, it returns a
     *  single space.
     *
     *  @param data Object to be rendered.
     *
     *  @return The string to be displayed based on the data.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function itemToLabel(data:Object):String
    {
        if (data == null)
            return " ";

        if (labelFunction != null)
            return labelFunction(data);

        if (data is XML)
        {
            try
            {
                if (data[labelField].length() != 0)
                    data = data[labelField];
                //by popular demand, this is a default XML labelField
                //else if (data.@label.length() != 0)
                //  data = data.@label;
            }
            catch (e:Error)
            {
            }
        }
        else if (data is Object)
        {
            try
            {
                if (data[labelField] != null)
                    data = data[labelField];
            }
            catch(e:Error)
            {
            }
        }

        if (data is String)
            return String(data);

        try
        {
            return data.toString();
        }
        catch(e:Error)
        {
        }

        return " ";
    } */

    /**
     *  Returns the dataTip string the renderer would display for the given
     *  data object based on the dataTipField and dataTipFunction properties.
     *  If the method cannot convert the parameter to a string, it returns a
     *  single space.
     *  <p>For use by developers creating subclasses of ListBase or its children.
     *  Not used by application developers.</p>
     *
     *  @param data Object to be rendered.
     *
     *  @return String displayable string based on the data.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function itemToDataTip(data:Object):String
    {
        if (dataTipFunction != null)
            return dataTipFunction(data);

        if (typeof(data) == "object")
        {
            try
            {
                if (data[dataTipField] != null)
                    data = data[dataTipField];
                else if (data.label != null)
                    data = data.label;
            }
            catch(e:Error)
            {
            }
        }

        if (typeof(data) == "string")
            return String(data);

        try
        {
            return data.toString();
        }
        catch(e:Error)
        {
        }

        return " ";
    }
 */
    /**
     *  Returns the class for an icon, if any, for a data item,  
     *  based on the iconField and iconFunction properties.
     *  The field in the item can return a string as long as that
     *  string represents the name of a class in the application.
     *  The field in the item can also be a string that is the name
     *  of a variable in the document that holds the class for
     *  the icon.
     *  
     *  @param data The item from which to extract the icon class.
     *  
     *  @return The icon for the item, as a class reference or 
     *  <code>null</code> if none.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function itemToIcon(data:Object):Class
    {
        if (data == null)
            return null;

        if (iconFunction != null)
            return iconFunction(data);

        var iconClass:Class;
        var icon:*;

        if (data is XML)
        {
            try
            {
                if (data[iconField].length() != 0)
                {
                   icon = String(data[iconField]);
                   if (icon != null)
                   {
                       iconClass =
                            Class(systemManager.getDefinitionByName(icon));
                       if (iconClass)
                           return iconClass;

                       return document[icon];
                   }
                }
            }
            catch(e:Error)
            {
            }
        }

        else if (data is Object)
        {
            try
            {
                if (data[iconField] != null)
                {
                    if (data[iconField] is Class)
                        return data[iconField];

                    if (data[iconField] is String)
                    {
                        iconClass = Class(systemManager.getDefinitionByName(
                                                data[iconField]));
                        if (iconClass)
                            return iconClass;

                        return document[data[iconField]];
                    }
                }
            }
            catch(e:Error)
            {
            }
        }

        return null;
    } */

    //--------------------------------------------------------------------------
    //
    //  Methods: Renderer management
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Make enough rows and columns to fill the area
     *  described by left, top, right, bottom.
     *  Renderers are created and inserted into the <code>listItems</code>
     *  array starting at <code>(firstColumn, firstRow)(</code>
     *  and moving downwards.
     *
     *  <p>If <code>byCount</code> and <code>rowsNeeded</code> are specified,
     *  then just make that many rows and ignore the <code>bottom</code>
     *  and <code>right</code> parameters.</p>
     *
     *  @param left Horizontal pixel offset of area to fill.
     *
     *  @param top Vertical pixel offset of area to fill.
     *
     *  @param right Horizontal pixel offset of area to fill
     *  (from left side of component).
     *
     *  @param bottom Vertical pixel offset of area to fill
     *  (from top of component).
     *
     *  @param firstColumn Offset into <code>listItems</code> to store
     *  the first renderer to be created.
     *
     *  @param firstRow Offset into <code>listItems</code> to store
     *  the first renderer to be created.
     *
     *  @param byCount If true, make <code>rowsNeeded</code> number of rows
     *  and ignore <code>bottom</code> parameter
     *
     *  @param rowsNeeded Number of rows to create if <code>byCount</code>
     *  is true;
     *
     *  @return A Point containing the number of rows and columns created.
     */
   /*  protected function makeRowsAndColumns(left:Number, top:Number,
                                          right:Number, bottom:Number,
                                          firstColumn:int, firstRow:int,
                                          byCount:Boolean = false,
                                          rowsNeeded:uint = 0):Point
    {
        return new Point(0,0);
    }
    
    private function makeRowsAndColumnsWithExtraRows(unscaledWidth:Number,unscaledHeight:Number):void
    {
        var pt:Point;
        var desiredExtraRowsTop:int = offscreenExtraRows / 2;
        var desiredExtraRowsBottom:int = offscreenExtraRows / 2;
        
        offscreenExtraRowsTop = Math.min(desiredExtraRowsTop, verticalScrollPosition);

        var index:int = scrollPositionToIndex(horizontalScrollPosition, verticalScrollPosition - offscreenExtraRowsTop);
        seekPositionSafely(index);

        var cursorPos:CursorBookmark = iterator.bookmark;

        // if necessary, make the rows that will eventually be offscreen, above visible rows
        if (offscreenExtraRowsTop > 0)
            makeRowsAndColumns(0, 0, listContent.width, listContent.height, 0, 0,true,offscreenExtraRowsTop);

        var curY:Number = offscreenExtraRowsTop > 0 ? rowInfo[offscreenExtraRowsTop-1].y + rowHeight : 0;
        // make onscreen items
        pt = makeRowsAndColumns(0, curY, listContent.width, curY + listContent.heightExcludingOffsets, 0, offscreenExtraRowsTop);

        // if necessary, and possible, make offscreen rows below visible rows.
       if (desiredExtraRowsBottom > 0 && !iterator.afterLast)
       {
            //  watch out for boundary condition
            if (offscreenExtraRowsTop + pt.y - 1 < 0)
                curY = 0;
            else
                curY = rowInfo[offscreenExtraRowsTop + pt.y - 1].y + rowInfo[offscreenExtraRowsTop + pt.y - 1].height;
            var currentRows:int = listItems.length;
            //
            pt = makeRowsAndColumns(0,curY,listContent.width,curY,0,offscreenExtraRowsTop + pt.y,true,desiredExtraRowsBottom);
            if (pt.y < desiredExtraRowsBottom)
            {
                var extraEmptyRows:int = listItems.length - (currentRows + pt.y);
                if (extraEmptyRows)
                    for (var i:int = 0; i < extraEmptyRows; i++)
                    {
                        listItems.pop();
                        rowInfo.pop();
                    }
            }
            offscreenExtraRowsBottom = pt.y;
       }
       // adjust the ListContent offsets so that the first visible row is exactly at the top of the screen, etc.
       var oldContentHeight:Number = listContent.heightExcludingOffsets;
       listContent.topOffset = -offscreenExtraRowsTop * rowHeight;

        listContent.bottomOffset = (offscreenExtraRowsBottom > 0) ?
            listItems[listItems.length-1][0].y + rowHeight - oldContentHeight + listContent.topOffset :
            0;
       
        if (iteratorValid)
            iterator.seek(cursorPos, 0);
        // make sure list content is moved to the appropriate place.
        // might be able to optimize and not do this every time
        adjustListContent(unscaledWidth,unscaledHeight);
    }

    private function makeRowsAndColumnsWithExtraColumns(unscaledWidth:Number,unscaledHeight:Number):void
    {
        // NOTE: this function only works correctly for fixed column width

         //if we scrolled more than the number of scrollable rows
         var desiredOffscreenColumnsLeft:int = offscreenExtraColumns / 2;
         var desiredOffscreenColumnsRight:int = offscreenExtraColumns / 2;

        offscreenExtraColumnsLeft = Math.min(desiredOffscreenColumnsLeft,horizontalScrollPosition);
        var index:int = scrollPositionToIndex(horizontalScrollPosition - offscreenExtraColumnsLeft, verticalScrollPosition);
        seekPositionSafely(index);
        var cursorPos:CursorBookmark = iterator.bookmark;

        // if we are maintaining an extra column buffer, make extra columns
        if (offscreenExtraColumnsLeft > 0)
            makeRowsAndColumns(0,0,0,listContent.height,0,0,true,offscreenExtraColumnsLeft);                    

        var curX:Number = offscreenExtraColumnsLeft ? listItems[0][offscreenExtraColumnsLeft-1].x + columnWidth : 0;

        var pt:Point = makeRowsAndColumns(curX, 0, curX + listContent.widthExcludingOffsets, listContent.height, offscreenExtraColumnsLeft, 0);
        if (desiredOffscreenColumnsRight > 0 && !iterator.afterLast)
        {
            if (offscreenExtraColumnsLeft + pt.x - 1 < 0)
                curX = 0;
            else
                curX = listItems[0][offscreenExtraColumnsLeft + pt.x - 1].x + columnWidth;
            var currentColumns:int = listItems[0].length;
            pt = makeRowsAndColumns(curX,0,curX,listContent.height,offscreenExtraColumnsLeft+pt.x,0,true,desiredOffscreenColumnsRight);
            if (pt.x < desiredOffscreenColumnsRight)
            {
                var extraEmptyColumns:int = listItems[0].length - (currentColumns + pt.x);
                if (extraEmptyColumns)
                {
                    for (var i:int = 0; i < listItems.length; i++)
                        for (var j:int = 0; j < extraEmptyColumns; j++)
                            listItems[i].pop();
                }
            }
            offscreenExtraColumnsRight = pt.x; // I *think* this is always true
        }

        var oldContentWidth:Number = listContent.widthExcludingOffsets;
        listContent.leftOffset = -offscreenExtraColumnsLeft * columnWidth;
        listContent.rightOffset = (offscreenExtraColumnsRight > 0) ?
            listItems[0][listItems[0].length-1].x + columnWidth - oldContentWidth + listContent.leftOffset :
            0;
        
        iterator.seek(cursorPos, 0);
        adjustListContent(unscaledWidth, unscaledHeight);
    } */

    /**
     *  Computes the offset into the data provider of the item
     *  at colIndex, rowIndex.
     *  The 9th row 3rd column in a TileList could be different items
     *  in the data provider based on the direction the tiles are laid
     *  out and the number of rows and columns in the TileList.
     *
     *  @param rowIndex The 0-based index of the row, including rows
     *  scrolled off the top.  Thus, if <code>verticalScrollPosition</code>
     *  is 2 then the first visible row has a rowIndex of 2.
     *
     *  @param colIndex The 0-based index of the column, including
     *  columns scrolled off the left.  If 
     *  <code>horizontalScrollPosition</code> is 2 then the first column
     *  on the left has a columnIndex of 2.
     *
     *  @return The offset into the data provider.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  public function indicesToIndex(rowIndex:int, colIndex:int):int
    {
        return rowIndex * columnCount + colIndex;
    } */

    /**
     *  The row for the data provider item at the given index.
     *
     *  @param index The offset into the data provider.
     *
     *  @return The row the item would be displayed at in the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function indexToRow(index:int):int
    {
        return index;
    } */

    /**
     *  The column for the data provider item at the given index.
     *
     *  @param index The offset into the data provider.
     *
     *  @return The column the item would be displayed at in the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function indexToColumn(index:int):int
    {
        return 0;
    } */

    /**
     *  @private
     *  Used by accessibility.
     */
   /*  mx_internal function indicesToItemRenderer(row:int, 
                                               col:int):IListItemRenderer
    {
         return listItems[row][col];
    } */

    /**
     *  Returns a Point instance containing the column index and row index of an
     *  item renderer. Since item renderers are only created for items
     *  within the set of viewable rows
     *  you cannot use this method to get the indices for items
     *  that are not visible. Also note that item renderers
     *  are recycled so the indices you get for an item may change
     *  if that item renderer is reused to display a different item.
     *  Usually, this method is called during mouse and keyboard handling
     *  when the set of data displayed by the item renderers hasn't yet
     *  changed.
     *
     *  @param item An item renderer.
     *
     *  @return A Point instance. The <code>x</code> property contains the column index
     *  and the <code>y</code> property contains the row index.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
     protected function itemRendererToIndices(item:IListItemRenderer):Point
    {
        //inr royale, the renderer is IIndexedItemRenderer
        if (!item) return null;
        var index:int = item.index;


        var list:DataGridColumnList = item.parent as DataGridColumnList;
        if (!list) return null;
        var column:DataGridColumn = list.columnInfo as DataGridColumn;

        if (column) {
            var colIndex:int = IDataGridModel(IDataGrid(list.grid).model).columns.indexOf(column);
            return new Point(colIndex, index);
        }

        return null;
       /* if (!item || !(item.name in rowMap))
            return null;
            
        var index:int = rowMap[item.name].rowIndex;
        var len:int = listItems[index].length;
        for (var i:int = 0; i < len; i++)
        {
            if (listItems[index][i] == item)
                break;
        }

        return new Point(i < lockedColumnCount ?
                         i :
                         i + horizontalScrollPosition,
                         index < lockedRowCount ?
                         index :
                         index + verticalScrollPosition + offscreenExtraRowsTop);*/
    }

    /**
     *  Get an item renderer for the index of an item in the data provider,
     *  if one exists.  Since item renderers only exist for items 
     *  within the set of viewable rows
     *  items, you cannot use this method for items that are not visible.
     *
     *  @param index The offset into the data provider for an item.
     *
     *  @return The item renderer that is displaying the item, or 
     *  <code>null</code> if the item is not currently displayed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function indexToItemRenderer(index:int):IListItemRenderer
    {
        var firstItemIndex:int = verticalScrollPosition - offscreenExtraRowsTop;
        
        if (index < firstItemIndex ||
            index >= firstItemIndex + listItems.length)
        {
            return null;
        }

        return listItems[index - firstItemIndex][0];
    } */

    /**
     *  Returns the index of the item in the data provider of the item
     *  being rendered by this item renderer.  Since item renderers
     *  only exist for items that are within the set of viewable
     *  rows, you cannot
     *  use this method for items that are not visible.
     *
     *  @param itemRenderer The item renderer that is displaying the
     *  item for which you want to know the data provider index.
     *
     *  @return The index of the item in the data provider.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function itemRendererToIndex(itemRenderer:IListItemRenderer):int
    {
        if (itemRenderer.name in rowMap)
        {
            var index:int = rowMap[itemRenderer.name].rowIndex;
            return index < lockedRowCount ?
                   index :

            // not clear why the commented out logic isn't correct...
            // maybe rowIndex isn't being set correctly?                   
            // index + verticalScrollPosition + offscreenExtraRowsTop;
             index + verticalScrollPosition;
        }
        else
        {
            return int.MIN_VALUE;
        }
    } */

    /**
     *  Determines the UID for a data provider item.  All items
     *  in a data provider must either have a unique ID (UID)
     *  or one will be generated and associated with it.  This
     *  means that you cannot have an object or scalar value
     *  appear twice in a data provider. 
     *  
     *  <p>For example, the following
     *  data provider is not supported because the value "foo"
     *  appears twice and the UID for a string is the string itself:</p>
     *
     *  <pre>
     *  var sampleDP:Array = ["foo", "bar", "foo"]
     *  </pre>
     *
     *  <p>Simple dynamic objects can appear twice if they are two
     *  separate instances. The following is supported because
     *  each of the instances will be given a different UID because
     *  they are different objects:</p>
     *
     *  <pre>
     *  var sampleDP:Array = [{label: "foo"}, {label: "foo"}]
     *  </pre>
     *
     *  <p>Note that the following is not supported because the same instance
     *  appears twice:</p>
     *
     *  <pre>
     *  var foo:Object = {label: "foo"};
     *  sampleDP:Array = [foo, foo];
     *  </pre>
     *
     *  @param data The data provider item.
     *
     *  @return The UID as a string.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function itemToUID(data:Object):String
    {
        if (data == null)
            return "null";

        return UIDUtil.getUID(data);
    } */

    /**
     *  Returns the item renderer for a given item in the data provider,
     *  if there is one.  Since item renderers only exist for items
     *  that are within the set of viewable rows, this method
     *  returns <code>null</code> if the item is not visible.
     *  For a data grid, this returns the first column's renderer.
     *
     *  @param item The data provider item.
     *
     *  @return The item renderer or <code>null</code> if the item is not 
     *  currently displayed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function itemToItemRenderer(item:Object):IListItemRenderer
    {
        return visibleData[itemToUID(item)];
    } */

    /**
     *  Determines if an item is being displayed by a renderer.
     *
     *  @param item A data provider item.
     *  @return <code>true</code> if the item is being displayed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function isItemVisible(item:Object):Boolean
    {
        return itemToItemRenderer(item) != null;
    } */

    /**
     *  Determines which item renderer is under the mouse.  Item
     *  renderers can be made of multiple mouse targets, or have 
     *  visible areas that are not mouse targets.  This method
     *  checks both targets and position to determine which
     *  item renderer the mouse is over from the user's perspective,
     *  which can differ from the information provided by the 
     *  mouse event.
     *  
     *  @param event A MouseEvent that contains the position of
     *  the mouse and the object it is over.
     *
     *  @return The item renderer the mouse is over or 
     *  <code>null</code> if none.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected function mouseEventToItemRenderer(
                                event:MouseEvent):IItemRenderer
    {
        return mouseEventToItemRendererOrEditor(event);
    }

    /**
     *  @private
     */
    mx_internal function mouseEventToItemRendererOrEditor(
                                event:MouseEvent):IItemRenderer
    {
        /*
        var target:DisplayObject = DisplayObject(event.target);
        if (target == listContent)
        {
            var pt:Point = new Point(event.stageX, event.stageY);
            pt = listContent.globalToLocal(pt);
            
            var yy:Number = 0;
            
            var n:int = listItems.length;
            for (var i:int = 0; i < n; i++)
            {
                if (listItems[i].length)
                {
                    if (pt.y < yy + rowInfo[i].height)
                    {
                        var m:int = listItems[i].length;
                        if (m == 1)
                            return listItems[i][0];
                        
                        var j:int = Math.floor(pt.x / columnWidth);
                        return listItems[i][j];
                    }
                }
                yy += rowInfo[i].height;
            }
        }
        else if (target == highlightIndicator)
        {
            return lastHighlightItemRenderer;
        }

        while (target && target != this)
        {
            if (target is IListItemRenderer && target.parent == listContent)
            {
                if (target.visible)
                    return IListItemRenderer(target);
                break;
            }

            if (target is IUIComponent)
                target = IUIComponent(target).owner;
            else 
                target = target.parent;
        }
        */

        var target:IUIBase = event.target as IUIBase;
        do {
            if (target is IItemRenderer)
                return target as IItemRenderer;
            target = (target as IChild).parent as IUIBase;
            if (target == this)
                return null;
        } while (target);
        
        return null;
    }

    /**
     *  @private
     *  Helper function for addClipMask().
     *  Returns true if all of the IListItemRenderers are UITextFields.
     */
   /*  private function hasOnlyTextRenderers():Boolean
    {
        if (listItems.length == 0)
            return true;

        var rowItems:Array = listItems[listItems.length - 1];
        var n:int = rowItems.length;
        for (var i:int = 0; i < n; i++)
        {
            if (!(rowItems[i] is IUITextField))
                return false;
        }

        return true;
    } */

    /**
     *  Determines whether a renderer contains (or owns) a display object.
     *  Ownership means that the display object isn't actually parented
     *  by the renderer but is associated with it in some way.  Popups
     *  should be owned by the renderers so that activity in the popup
     *  is associated with the renderer and not seen as activity in another
     *  component.
     *
     *  @param renderer The renderer that might contain or own the 
     *  display object.
     *
     *  @param object The display object that might be associated with the
     *  renderer.
     *
     *  @return <code>true</code> if the display object is contained
     *  or owned by the renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function itemRendererContains(renderer:IListItemRenderer,
                                         object:DisplayObject):Boolean
    {
        if (!object)
            return false;

        if (!renderer)
            return false;

        return renderer.owns(object);
    } */

    /**
     *  Adds a renderer to the recycled renderer list,
     *  making it invisible and cleaning up references to it.
     *  If a data effect is running, the renderer is reserved for
     *  future use for that data. Otherwise it is added to the
     *  general freeItemRenderers stack.
     *
     *  @param item The IListItemRenderer to add.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function addToFreeItemRenderers(item:IListItemRenderer):void
    {
        // trace("addToFreeItemRenderers ", item);

        DisplayObject(item).visible = false;
        var oldWrapper:ItemWrapper = dataItemWrappersByRenderer[item];
        
        // Before deleting from visibleData, make sure it is referring to this
        // renderer. (If not, we rendered the data elsewhere).
        var UID:String = oldWrapper ? itemToUID(oldWrapper) : itemToUID(item.data);
        if (visibleData[UID] == item)
            delete visibleData[UID];

        // If a data effect is running, reserve any renderer that isn't
        // being used, since it may be used again momentarily.
        if (oldWrapper)
            reservedItemRenderers[itemToUID(oldWrapper)] = item;
        else
            freeItemRenderers.push(item);

        delete rowMap[item.name];
    } */

    /**
     *  Retrieves an already-created item renderer not currently in use.
     *  If a data effect is running, it first tries to retrieve from the
     *  reservedItemRenderers map. Otherwise (or if no reserved renderer
     *  is found) it retrieves from the freeItemRenderers stack.
     *
     *  @param data The data to be presented by the item renderer.
     *
     *  @return An already-created item renderer not currently in use.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function getReservedOrFreeItemRenderer(data:Object):IListItemRenderer
    {
        var item:IListItemRenderer;
        var uid:String;
        
        if (runningDataEffect)
            item = IListItemRenderer(reservedItemRenderers[uid = itemToUID(data)]); 

        if (item)
            delete reservedItemRenderers[uid];
        else if (freeItemRenderers.length)
            item = freeItemRenderers.pop();
        
        return item;
    } */
    
    /** 
     *  diagnostics
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  mx_internal function get rendererArray():Array 
    {
        return listItems;
    }
	
	mx_internal var lastDragEvent:DragEvent;
     */
    //--------------------------------------------------------------------------
    //
    //  Methods: Drawing
    //
    //--------------------------------------------------------------------------

    /**
     *  Draws any alternating row colors, borders and backgrounds for the rows.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function drawRowBackgrounds():void
    {
    }
 */
    /**
     *  Draws the renderer with indicators
     *  that it is highlighted, selected, or the caret.
     *
     *  @param item The renderer.
     *  @param selected <code>true</code> if the renderer should be drawn in
     *  its selected state.
     *  @param highlighted <code>true</code> if the renderer should be drawn in
     *  its highlighted state.
     *  @param caret <code>true</code> if the renderer should be drawn as if
     *  it is the selection caret.
     *  @param transition <code>true</code> if the selection state should fade in
     *  via an effect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected function drawItem(index:int, selected:Boolean = false,
                                highlighted:Boolean = false,
                                caret:Boolean = false,
                                transition:Boolean = false):void
    {
        (view as DataGridView).drawItem(index, selected, highlighted, caret);
    }
    // protected function drawItem(item:IListItemRenderer,
                                // selected:Boolean = false,
                                // highlighted:Boolean = false,
                                // caret:Boolean = false,
                                // transition:Boolean = false):void
    // {
        // var o:Sprite;
        // var g:Graphics;

        // if (!item)
            // return;

        // var rowData:BaseListData = rowMap[item.name];
        //this can happen due to race conditions when using data effects
        // if (!rowData)
            // return;

        //trace("drawitem " + rowData.uid + " " + selected + " " + highlighted + " " + caret);

        // if (highlighted &&
            // (!highlightItemRenderer || highlightUID != rowData.uid))
        // {
            // if (!highlightIndicator)
            // {
                // o = new SpriteAsset();
                // selectionLayer.addChild(DisplayObject(o));
                // highlightIndicator = o;
            // }
            // else
            // {
                // selectionLayer.setChildIndex(DisplayObject(highlightIndicator),
                                             // selectionLayer.numChildren - 1);
            // }

            // o = highlightIndicator;
			
			//Let the highlightIndicator inherit the layoutDirection
			// if (o is ILayoutDirectionElement)
				// ILayoutDirectionElement(o).layoutDirection = null;
			
            // drawHighlightIndicator(
                // o, item.x, rowInfo[rowData.rowIndex].y,
                // item.width, rowInfo[rowData.rowIndex].height, 
                // getStyle("rollOverColor"), item);

            // lastHighlightItemRenderer = highlightItemRenderer = item;
            // highlightUID = rowData.uid;
        // }
        // else if (!highlighted && highlightItemRenderer && (rowData && highlightUID == rowData.uid) )
        // {
            // if (highlightIndicator)
                // Sprite(highlightIndicator).graphics.clear();
            // highlightItemRenderer = null;
            // highlightUID = "";
        // }

        // if (selected)
        // {
            // var effectiveRowY:Number = runningDataEffect ? 
                // item.y - mx_internal::cachedPaddingTop :
                // rowInfo[rowData.rowIndex].y;
                
            // if (!selectionIndicators[rowData.uid])
            // {
                // o = new SpriteAsset();
                // o.mouseEnabled = false;
				//Let the selectionIndicator inherit the layoutDirection
				// ILayoutDirectionElement(o).layoutDirection = null;
                // selectionLayer.addChild(DisplayObject(o));
                // selectionIndicators[rowData.uid] = o;
                
                // drawSelectionIndicator(
                    // o, item.x, effectiveRowY /* rowInfo[rowData.rowIndex].y */,
                    // item.width, rowInfo[rowData.rowIndex].height,
                    // enabled ?
                    // getStyle("selectionColor") :
                    // getStyle("selectionDisabledColor"),
                    // item);
                
                // if (transition)
                    // applySelectionEffect(o, rowData.uid, item);
            // }
            // else
            // {
                // o = selectionIndicators[rowData.uid];
                
				//Let the selectionIndicator inherit the layoutDirection
				// if (o is ILayoutDirectionElement)
					// ILayoutDirectionElement(o).layoutDirection = null;
				
                // drawSelectionIndicator(
                    // o, item.x, effectiveRowY /* rowInfo[rowData.rowIndex].y */,
                    // item.width, rowInfo[rowData.rowIndex].height,
                    // enabled ?
                    // getStyle("selectionColor") :
                    // getStyle("selectionDisabledColor"),
                    // item);
            // }

        // }
        // else if (!selected)
        // {
            // if (rowData && selectionIndicators[rowData.uid])
            // {
                // if (selectionTweens[rowData.uid])
                // {
                    // selectionTweens[rowData.uid].removeEventListener(
                        // TweenEvent.TWEEN_UPDATE, selectionTween_updateHandler);
                    // selectionTweens[rowData.uid].removeEventListener(
                        // TweenEvent.TWEEN_END, selectionTween_endHandler);
                    // if (selectionIndicators[rowData.uid].alpha < 1)
                        // Tween.removeTween(selectionTweens[rowData.uid]);
                    // delete selectionTweens[rowData.uid];
                // }

                // selectionLayer.removeChild(selectionIndicators[rowData.uid]);
                // delete selectionIndicators[rowData.uid]
            // }
        // }

        // if (caret) // && (!caretItemRenderer || caretUID != rowData.uid))
        // {
           // Only draw the caret if there has been keyboard navigation.
            // if (showCaret)
            // {
                // if (!caretIndicator)
                // {
                    // o = new SpriteAsset();
                    // o.mouseEnabled = false;
                    // selectionLayer.addChild(DisplayObject(o));
                    // caretIndicator = o;
                // }
                // else
                // {
                    // selectionLayer.setChildIndex(DisplayObject(caretIndicator),
                                                 // selectionLayer.numChildren - 1);
                // }
                
                // o = caretIndicator;
				
				//Let the caretIndicator inherit the layoutDirection
				// if (o is ILayoutDirectionElement)
					// ILayoutDirectionElement(o).layoutDirection = null;
                
                // drawCaretIndicator(
                    // o, item.x, rowInfo[rowData.rowIndex].y,
                    // item.width, rowInfo[rowData.rowIndex].height,
                    // getStyle("selectionColor"), item);

				// var oldCaretItemRenderer:IListItemRenderer = caretItemRenderer;
                // caretItemRenderer = item;
                // caretUID = rowData.uid;
				
				// if (oldCaretItemRenderer)
				// {
					// if (oldCaretItemRenderer is IFlexDisplayObject)
					// {
						// if (oldCaretItemRenderer is IInvalidating)
						// {
							// IInvalidating(oldCaretItemRenderer).invalidateDisplayList();
							// IInvalidating(oldCaretItemRenderer).validateNow();
						// }
					// }
					// else if (oldCaretItemRenderer is IUITextField)
					// {
						// IUITextField(oldCaretItemRenderer).validateNow();
					// }
				// }
            // }
        // }
        // else if (!caret && caretItemRenderer && caretUID == rowData.uid)
        // {
            // if (caretIndicator)
                // Sprite(caretIndicator).graphics.clear();
            // caretItemRenderer = null;
            // caretUID = "";
        // }

        // if (item is IFlexDisplayObject)
        // {
            // if (item is IInvalidating)
            // {
                // IInvalidating(item).invalidateDisplayList();
                // IInvalidating(item).validateNow();
            // }
        // }
        // else if (item is IUITextField)
        // {
            // IUITextField(item).validateNow();
        // }
    // }

    /**
     *  Draws the highlight indicator into the given Sprite
     *  at the position, width and height specified using the
     *  color specified.
     * 
     *  @param indicator A Sprite that should contain the graphics
     *  for that make a renderer look highlighted.
     *  @param x The suggested x position for the indicator.
     *  @param y The suggested y position for the indicator.
     *  @param width The suggested width for the indicator.
     *  @param height The suggested height for the indicator.
     *  @param color The suggested color for the indicator.
     *  @param itemRenderer The item renderer that is being highlighted.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function drawHighlightIndicator(
                                indicator:Sprite, x:Number, y:Number,
                                width:Number, height:Number, color:uint,
                                itemRenderer:IListItemRenderer):void
    {
        var g:Graphics = Sprite(indicator).graphics;
        g.clear();
        g.beginFill(color);
        g.drawRect(0, 0, width, height);
        g.endFill();
        
        indicator.x = x;
        indicator.y = y;
    } */

    /**
     *  Draws the selection indicator into the given Sprite
     *  at the position, width and height specified using the
     *  color specified.
     * 
     *  @param indicator A Sprite that should contain the graphics
     *  for that make a renderer look highlighted.
     *  @param x The suggested x position for the indicator.
     *  @param y The suggested y position for the indicator.
     *  @param width The suggested width for the indicator.
     *  @param height The suggested height for the indicator.
     *  @param color The suggested color for the indicator.
     *  @param itemRenderer The item renderer that is being highlighted.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function drawSelectionIndicator(
                                indicator:Sprite, x:Number, y:Number,
                                width:Number, height:Number, color:uint,
                                itemRenderer:IListItemRenderer):void
    {
        var g:Graphics = Sprite(indicator).graphics;
        g.clear();
        g.beginFill(color);
        g.drawRect(0, 0, width, height);
        g.endFill();
        
        indicator.x = x;
        indicator.y = y;
    } */

    
    /**
     *  Draws the caret indicator into the given Sprite
     *  at the position, width and height specified using the
     *  color specified.
     * 
     *  @param indicator A Sprite that should contain the graphics
     *  for that make a renderer look highlighted.
     *  @param x The suggested x position for the indicator.
     *  @param y The suggested y position for the indicator.
     *  @param width The suggested width for the indicator.
     *  @param height The suggested height for the indicator.
     *  @param color The suggested color for the indicator.
     *  @param itemRenderer The item renderer that is being highlighted.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function drawCaretIndicator(
                                indicator:Sprite, x:Number, y:Number,
                                width:Number, height:Number, color:uint,
                                itemRenderer:IListItemRenderer):void
    {
        var g:Graphics = Sprite(indicator).graphics;
        g.clear();
        g.lineStyle(1, color, 1);
        g.drawRect(0, 0, width - 1, height - 1);
        
        indicator.x = x;
        indicator.y = y;
    } */

    /**
     *  Removes all selection and highlight and caret indicators.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected function clearIndicators():void
    {
        /*for (var uniqueID:String in selectionTweens)
        {
            removeIndicators(uniqueID);
        }*/

        /*if (selectionLayer)
        {
            while (selectionLayer.numChildren > 0)
            {
                selectionLayer.removeChildAt(0);
            }
        }*/
        
        //selectionTweens = {};
        selectionIndicators = {};
        
        //highlightIndicator = null;
        highlightUID = null;
        
        //caretIndicator = null;
        caretUID = null;
    }

    /**
     *  Cleans up selection highlights and other associated graphics
     *  for a given item in the data provider.
     *
     *  @param uid The UID of the data provider item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function removeIndicators(uid:String):void
    {
        if (selectionTweens[uid])
        {
            selectionTweens[uid].removeEventListener(
                TweenEvent.TWEEN_UPDATE, selectionTween_updateHandler);
        
            selectionTweens[uid].removeEventListener(
                TweenEvent.TWEEN_END, selectionTween_endHandler);

            if (selectionIndicators[uid].alpha < 1)
                Tween.removeTween(selectionTweens[uid]);
            
            delete selectionTweens[uid];
        }

        // toss associated graphics if needed

        if (selectionIndicators[uid])
        {
            selectionLayer.removeChild(selectionIndicators[uid]);
            selectionIndicators[uid] = null;
        }

        if (uid == highlightUID)
        {
            highlightItemRenderer = null;
            highlightUID = null;
            if (highlightIndicator)
                Sprite(highlightIndicator).graphics.clear();
        }

        if (uid == caretUID)
        {
            caretItemRenderer = null;
            caretUID = null;
            if (caretIndicator)
                Sprite(caretIndicator).graphics.clear();
        }
    } */

    /**
     *  @private
     */
   /*  mx_internal function clearHighlight(item:IListItemRenderer):void
    {
        var uid:String = itemToUID(item.data);
        
        drawItem(visibleData[uid], isItemSelected(item.data),
                 false, uid == caretUID);

        var pt:Point = itemRendererToIndices(item);
        if (pt && lastHighlightItemIndices)
        {
            var listEvent:ListEvent =
                new ListEvent(ListEvent.ITEM_ROLL_OUT);
            listEvent.columnIndex = lastHighlightItemIndices.x;
            listEvent.rowIndex = lastHighlightItemIndices.y;
            listEvent.itemRenderer = lastHighlightItemRendererAtIndices;
            dispatchEvent(listEvent);
            lastHighlightItemIndices = null;
        }
    } */

    /**
     *  Refresh all rows on next update.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
     public function invalidateList():void
    {
       // itemsSizeChanged = true;
       // invalidateDisplayList();
    } 

    /**
     *  Refreshes all rows now.  Calling this method can require substantial
     *  processing, because can be expensive at it completely redraws all renderers
     *  in the list and won't return until complete.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected function updateList():void
    {/*
        // trace("updateList " + verticalScrollPosition);
        
        removeClipMask();
        
        var cursorPos:CursorBookmark = (iterator) ? iterator.bookmark : null;
        
        clearIndicators();
        
        visibleData = {};
        
        makeRowsAndColumns(0, 0, listContent.width, listContent.height, 0, 0);
        
        if (iterator)
            iterator.seek(cursorPos, 0);
        
        drawRowBackgrounds();
        
        configureScrollBars();
        
        addClipMask(true);*/
    }
 
    //--------------------------------------------------------------------------
    //
    //  Methods: Clipping
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  By default, there's a single large clip mask applied to the entire
     *  listContent area of the List.  When the List contains a mixture of
     *  device text and vector graphics (e.g.: there are custom item renderers),
     *  that clip mask imposes a rendering overhead.
     *
     *  When graphical (non-text) item renderers are used, we optimize by only
     *  applying a clip mask to the list items in the last row ... and then
     *  only when it's needed.
     *
     *  This optimization breaks down when there's a horizontal scrollbar.
     *  Rather than attempting to apply clip masks to every item along the left
     *  and right edges, we give up and use the default clip mask that covers
     *  the entire List.
     *
     *  For Lists and DataGrids containing custom item renderers, this
     *  optimization yields a 25% improvement in scrolling speed.
     */
   /*  mx_internal function addClipMask(layoutChanged:Boolean):void
    {
        // If something about the List has changed, check to see if we need
        // to clip items in the last row.
        if (layoutChanged)
        {
            if ((horizontalScrollBar && horizontalScrollBar.visible) || 
                    hasOnlyTextRenderers() || runningDataEffect ||
                    listContent.bottomOffset != 0 ||
                    listContent.topOffset != 0 ||
                    listContent.leftOffset != 0 ||
                    listContent.rightOffset != 0)
            {
                // As described above, we just use the default clip mask
                // when there's a horizontal scrollbar or the item renders
                // are all UITextFields.
                listContent.mask = maskShape;
                selectionLayer.mask = null;
            }
            else
            {
                // When we're not applying the default clip mask to the whole
                // listContent, we still want to apply it to the selectionLayer
                // (so that the selection rectangle and the mouseOver rectangle
                // are properly clipped)
                listContent.mask = null;
                selectionLayer.mask = maskShape;
            }
        }

        // If we've decided to clip the entire listContent, then stop here.
        // There's no need to clip individual items
        if (listContent.mask)
            return;

        // If the last row fits inside listContent, then stop here.  There's
        // no need to do any clipping.
        var lastRowIndex:int = listItems.length - 1;
        var lastRowInfo:ListRowInfo = rowInfo[lastRowIndex];
        var lastRowItems:Array = listItems[lastRowIndex];
        if (lastRowInfo.y + lastRowInfo.height <= listContent.height)
            return;

        // For each list item in the last row, either apply a clip mask or
        // set the row's height to not exceed the height of listContent
        var numColumns:int = lastRowItems.length;
        var rowY:Number = lastRowInfo.y;
        var rowWidth:Number = listContent.width;
        var rowHeight:Number = listContent.height - lastRowInfo.y;
        for (var i:int = 0; i < numColumns; i++)
        {
            var item:DisplayObject = lastRowItems[i];
            var yOffset:Number = item.y - rowY;
            if (item is IUITextField)
                item.height = rowHeight - yOffset;
            else
                item.mask = createItemMask(0, rowY + yOffset, rowWidth, rowHeight - yOffset);
        }
    } */

    /**
     *  @private
     *  Helper function for addClipMask().
     *  Creates a clip mask with the specified dimensions.
     */
   /*  private function createItemMask(x:Number, y:Number,
                                    width:Number, height:Number):DisplayObject
    {
        var mask:Shape;

        // To avoid constantly creating and destroying clip masks, we'll
        // maintain a "free list" of masks that are not currently being
        // used.  Items are added to the free list in removeClipMask, below.
        if (!itemMaskFreeList)
            itemMaskFreeList = [];

        if (itemMaskFreeList.length > 0)
        {
            mask = itemMaskFreeList.pop();

            if (mask.width != width)
                mask.width = width;
            if (mask.height != height)
                mask.height = height;
        }
        else
        {
            mask = new FlexShape();
            mask.name = "mask";

            var g:Graphics = mask.graphics;
            g.beginFill(0xFFFFFF);
            g.drawRect(0, 0, width, height);
            g.endFill();

            mask.visible = false;
            listContent.addChild(mask);
        }

        if (mask.x != x)
            mask.x = x;
        if (mask.y != y)
            mask.y = y;
        return mask;
    } */

    /**
     *  @private
     *
     *  Undo the effects of the addClipMask function (above)
     */
  /*   mx_internal function removeClipMask():void
    {
        // If we're currently using the default clip mask to clip the entire
        // listContent, then there's no need to undo clipping on individual
        // list items.
        if (listContent && listContent.mask)
            return;

        // If there are no rows, do nothing.
        var lastRowIndex:int = listItems.length - 1;
        if (lastRowIndex < 0)
            return;

        // Undo the effects of the last "for" loop in addClipMask
        var rowHeight:Number = rowInfo[lastRowIndex].height;
        var lastRowInfo:ListRowInfo = rowInfo[lastRowIndex];
        var lastRowItems:Array = listItems[lastRowIndex];
        var numColumns:int = lastRowItems.length;
        for (var i:int = 0; i < numColumns; i++)
        {
            var item:DisplayObject = lastRowItems[i];
            if (item is IUITextField)
            {
                if (item.height != rowHeight - (item.y - lastRowInfo.y))
                    item.height = rowHeight - (item.y - lastRowInfo.y);
            }
            else if (item && item.mask)
            {
                if(itemMaskFreeList)
                {
                    itemMaskFreeList.push(item.mask);
                }
                item.mask = null;
            }
        }
    } */

    //--------------------------------------------------------------------------
    //
    //  Methods: Highlighting and selection
    //
    //--------------------------------------------------------------------------

	/**
	 *  Determines if the item renderer for a data provider item 
	 *  is the item under the caret due to keyboard navigation.
	 *
	 *  @param data The data provider item.
	 *  @return <code>true</code> if the item under the caret
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.4
	 */
	/* public function isItemShowingCaret(data:Object):Boolean
	{
		if (data == null)
			return false;
		
		if (data is String)
			return (data == caretUID);
		
		return itemToUID(data) == caretUID;
	} */
	
    /**
     *  Determines if the item renderer for a data provider item 
     *  is highlighted (is rolled over via the mouse or
     *  or under the caret via keyboard navigation).
     *
     *  @param data The data provider item.
     *  
     *  @return <code>true</code> if the item is highlighted.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function isItemHighlighted(data:Object):Boolean
    {
        if (data == null)
            return false;

        // When something is selected, the selection indicator
        // overlays the highlighted indicator so we want
        // to draw as selected and not highlighted.
        var isSelected:Boolean = highlightUID && selectedData[highlightUID];

        if (data is String)
            return (data == highlightUID && !isSelected);

        return itemToUID(data) == highlightUID && !isSelected;
    } */

    /**
     *  Determines if the item renderer for a data provider item 
     *  is selected.
     *
     *  @param data The data provider item.
     *  
     *  @return <code>true</code> if the item is highlighted.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function isItemSelected(data:Object):Boolean
    {
        if (data == null)
            return false;

        if (data is String)
            return (selectedData[data] != undefined)

        return selectedData[itemToUID(data)] != undefined;
    } 
    
    /**
     *  Determines if the item renderer for a data provider item 
     *  is selectable.
     *
     *  @param data The data provider item
     *  @return <code>true</code> if the item is selectable
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function isItemSelectable(data:Object):Boolean
    {
        if (!selectable)
            return false;

        if (data == null)
            return false;

        return true;
    }

    /**
     *  @private
     */
    private function calculateSelectedIndexAndItem():void
    {
        var num:int = 0;
        for (var p:String in selectedData)
        {
            num = 1;
            break;
        }

        if (!num)
        {
            (model as ISelectionModel).selectedIndex/*_selectedIndex*/ = -1;
            //_selectedItem = null;
            return;
        }

        //this should always resolve to the most recently selected index for the single selection model
        var idx:int = (model as ISelectionModel).selectedIndex;
        var newIndex:int = this.selectedIndices[0];
        if (idx == newIndex) {
            //force a change
            (model as ISelectionModel).selectedIndex = -1;
        }
        (model as ISelectionModel).selectedIndex = newIndex;
        //_selectedItem = selectedData[p].data;
    }

    /**
     *  Updates the set of selected items given that the item renderer provided
     *  was clicked by the mouse and the keyboard modifiers are in the given
     *  state.  This method also updates the display of the item renderers based
     *  on their updated selected state.
     *
     *  @param item The item renderer that was clicked.
     *  @param shiftKey <code>true</code> if the shift key was held down when
     *  the mouse was clicked.
     *  @param ctrlKey <code>true</code> if the ctrl key was held down when
     *  the mouse was clicked.
     *  @param transition <code>true</code> if the graphics for the selected 
     *  state should be faded in using an effect.
     *
     *  @return <code>true</code> if the set of selected items changed.
     *  Clicking on an already-selected item doesn't always change the set
     *  of selected items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected function selectItem(data:Object, index:int,
                                  shiftKey:Boolean, ctrlKey:Boolean,
                                  transition:Boolean = true):Boolean
    {
        if (!data  || !isItemSelectable(/*item.*/data))
            return false;

        // Begin multiple selection cases.
        // We'll start by assuming the selection has changed.
        var selectionChange:Boolean = false;
        var placeHolder:CursorBookmark = iterator.bookmark;
        //var index:int = itemRendererToIndex(item);
        var uid:String = itemToUID(/*item.*/data);

        if (!allowMultipleSelection || (!shiftKey && !ctrlKey))
        {
            // we want to know if 0, 1 or more items are selected
            var numSelected:int = 0;
            if (allowMultipleSelection)
            {
                var curSelectionData:ListBaseSelectionData = firstSelectionData;
                if (curSelectionData != null)
                {
                    numSelected++;
                    if (curSelectionData.nextSelectionData)
                        numSelected++;
                }
            }

            // allow unselecting via ctrl-click
            if (ctrlKey && selectedData[uid])
            {
                selectionChange = true;
                var oldCaretIndex:int = caretIndex;
                clearSelected(transition);
                caretIndex = oldCaretIndex;
            }
            // plain old click, ignore if same item is selected unless number of selected items
            // is going to change
            else if ((model as ISelectionModel).selectedIndex /*_selectedIndex*/ != index || bSelectedIndexChanged || (allowMultipleSelection && numSelected != 1))
            {
                selectionChange = true;

                //Clear all other selections, this is a single click
                clearSelected(transition);
                addSelectionData(uid, new ListBaseSelectionData(/*item.*/data, index, approximate));
                drawItem(index, true, uid == highlightUID, true, transition);
                (model as ISelectionModel).selectedIndex = index; //_selectedIndex = index;
                //_selectedItem = item.data;
                iterator.seek(CursorBookmark.CURRENT, (model as ISelectionModel).selectedIndex /*_selectedIndex*/ - 
                    layout.firstVisibleIndex/*indicesToIndex(verticalScrollPosition - offscreenExtraRowsTop, horizontalScrollPosition - offscreenExtraColumnsLeft)*/);
                caretIndex = (model as ISelectionModel).selectedIndex; //_selectedIndex;
                caretBookmark = iterator.bookmark;
                anchorIndex = (model as ISelectionModel).selectedIndex; //_selectedIndex;
                anchorBookmark = iterator.bookmark;
                iterator.seek(placeHolder, 0);
            }
        }
        
        else if (shiftKey && allowMultipleSelection)
        {
            // trace("begin shiftsel");
            if (anchorBookmark)
            {
                var oldAnchorBookmark:CursorBookmark = anchorBookmark;
                var oldAnchorIndex:int = anchorIndex;
                var incr:Boolean = (anchorIndex < index);
                clearSelected(false);
                caretIndex = index;
                caretBookmark = iterator.bookmark;
                anchorIndex = oldAnchorIndex;
                anchorBookmark = oldAnchorBookmark;

                //try
                //{
                    iterator.seek(anchorBookmark, 0);
                //}
                //catch (e:ItemPendingError)
                //{
                //    e.addResponder(new ItemResponder(selectionPendingResultHandler, selectionPendingFailureHandler,
                //                                        new ListBaseSelectionPending(incr, index, item.data, transition, placeHolder, CursorBookmark.CURRENT, 0)));
                //    iteratorValid = false;
                //}

                shiftSelectionLoop(incr, anchorIndex, /*item.*/data, transition, placeHolder);
            }

            // selection may or may not change for this case.
            // but requires complicated testing.
            // so just assume that selection changed.
            selectionChange = true;
            // trace("end shiftsel");
        }
        
        else if (ctrlKey && allowMultipleSelection)
        {
            var selectionData:ListBaseSelectionData = selectedData[uid] as ListBaseSelectionData;
            if (selectionData)
            {
                removeSelectionData(uid);
                drawItem(selectionData.index, false, uid == highlightUID, true, transition);
               // if (/*item.*/data == selectedItem)
                    calculateSelectedIndexAndItem();
            }
            else
            {
                addSelectionData(uid, new ListBaseSelectionData(/*item.*/data, index, approximate));
                drawItem(index, true, uid == highlightUID, true, transition);
                (model as ISelectionModel).selectedIndex = index; //_selectedIndex = index;
                //_selectedItem = item.data;
            }
            iterator.seek(CursorBookmark.CURRENT, index - layout.firstVisibleIndex/*indicesToIndex(verticalScrollPosition, horizontalScrollPosition)*/);
            caretIndex = index;
            caretBookmark = iterator.bookmark;
            anchorIndex = index;
            anchorBookmark = iterator.bookmark;
            iterator.seek(placeHolder, 0);

            // if user is clicking with ctl key then
            // selection gets changed always.
            selectionChange = true;
        }

        return selectionChange;
    }

    /**
     *  @private
     */
    private function shiftSelectionLoop(incr:Boolean, index:int,
                                        stopData:Object, transition:Boolean,
                                        placeHolder:CursorBookmark):void
    {
        var data:Object;
        var uid:String;

        // Correct the iterator position which, for some strange reason, doesn't
        // point to the correct place.
        iterator.seek(CursorBookmark.FIRST, anchorIndex);

        //try
        //{
            do
            {
                data = iterator.current;
                uid = itemToUID(data);
                // trace(uid);
                addSelectionData(uid, new ListBaseSelectionData(data, index, approximate));
                if (isVisibleIndex(index))
                    drawItem(index, true, uid == highlightUID, false, transition);
                if (data === stopData)
                {
                    if (isVisibleIndex(index))
                        drawItem(index, true, uid == highlightUID, true, transition);
                    break;
                }
                if (incr)
                    index++;
                else
                    index--;

            }
            while (incr ? iterator.moveNext() : iterator.movePrevious());
        //}
        //catch (e:ItemPendingError)
        //{
        //    e.addResponder(new ItemResponder(
        //        selectionPendingResultHandler, selectionPendingFailureHandler,
        //        new ListBaseSelectionPending(incr, index, stopData, transition,
        //                                     placeHolder,
        //                                     CursorBookmark.CURRENT, 0)));
        //    
        //    iteratorValid = false;
        //}

        //try
        //{
            iterator.seek(placeHolder, 0);
            iteratorValid = true;
        //}
        //catch (e2:ItemPendingError)
        //{
        //    lastSeekPending = new ListBaseSeekPending(placeHolder, 0);
        //    
        //    e2.addResponder(new ItemResponder(
        //        seekPendingResultHandler, seekPendingFailureHandler,
        //        lastSeekPending));
        //
        //}

        //set the selection model index to the most recent index
        (model as ISelectionModel).selectedIndex = index;
    }

    /**
     *  Clears the set of selected items and removes all graphics
     *  depicting the selected state of those items.
     *
     *  @param transition <code>true</code> if the graphics should
     *  have a fadeout effect.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected function clearSelected(transition:Boolean = false):void
    {
        for (var p:String in selectedData)
        {
            var selectionData:ListBaseSelectionData = selectedData[p];
            var data:Object = selectedData[p].data;
            
            removeSelectionData(p);
            
            //var item:IListItemRenderer = visibleData[itemToUID(data)];
            //if (item)
            if (isVisibleIndex(selectionData.index))
                 drawItem(selectionData.index, false, p == highlightUID, false, transition);
        }

        clearSelectionData();

        (model as ISelectionModel).selectedIndex = -1; //_selectedIndex = -1;
        //_selectedItem = null;
		_selectedItems = null;

        caretIndex = -1;
        anchorIndex = -1;

        caretBookmark = null;
        anchorBookmark = null;
    }

    /**
     *  Moves the selection in a horizontal direction in response
     *  to the user selecting items using the left-arrow or right-arrow
     *  keys and modifiers such as  the Shift and Ctrl keys.  This method
     *  might change the <code>horizontalScrollPosition</code>, 
     *  <code>verticalScrollPosition</code>, and <code>caretIndex</code>
     *  properties, and call the <code>finishKeySelection()</code>method
     *  to update the selection.
     *
     *  <p>Not implemented in AdvancedListBase because the default list
     *  is single column and therefore doesn't scroll horizontally.</p>
     *
     *  @param code The key that was pressed (e.g. Keyboard.LEFT)
     *  @param shiftKey <code>true</code> if the shift key was held down when
     *  the keyboard key was pressed.
     *  @param ctrlKey <code>true</code> if the ctrl key was held down when
     *  the keyboard key was pressed
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected function moveSelectionHorizontally(code:uint, shiftKey:Boolean,
                                                 ctrlKey:Boolean):void
    {
		// For Keyboard.LEFT and Keyboard.RIGHT and maybe Keyboard.UP and Keyboard.DOWN,
		// need to account for layoutDirection="rtl".
		
        return;
    }

    /**
     *  Moves the selection in a vertical direction in response
     *  to the user selecting items using the up-arrow or down-arrow
     *  Keys and modifiers such as the Shift and Ctrl keys.  This method
     *  might change the <code>horizontalScrollPosition</code>, 
     *  <code>verticalScrollPosition</code>, and <code>caretIndex</code>
     *  properties, and call the <code>finishKeySelection()</code>method
     *  to update the selection
     *
     *  @param code The key that was pressed (e.g. Keyboard.DOWN)
     *  @param shiftKey <code>true</code> if the shift key was held down when
     *  the keyboard key was pressed.
     *  @param ctrlKey <code>true</code> if the ctrl key was held down when
     *  the keyboard key was pressed
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected function moveSelectionVertically(code:uint, shiftKey:Boolean,
                                               ctrlKey:Boolean):void
    {
        var newVerticalScrollPosition:Number;
        var listItem:IListItemRenderer;
        var uid:String;
        var len:int;
        var bSelChanged:Boolean = false;

        showCaret = true;

        var rowCount:int = layout.lastVisibleIndex - layout.firstVisibleIndex; //listItems.length;
        var partialRow:int = /*(rowInfo[rowCount-1].y + rowInfo[rowCount-1].height >
                                  listContent.height) ? 1 :*/ 0;
        var bUpdateVerticalScrollPosition:Boolean = false;
        bSelectItem = false;
        
        switch (code)
        {
            case Keyboard.UP:
            {
                if (caretIndex > 0)
                {
                    caretIndex--;
                    bUpdateVerticalScrollPosition = true;
                    bSelectItem = true;
                }
                break;
            }

            case Keyboard.DOWN:
            {
                if (caretIndex < collection.length - 1)
                {
                    caretIndex++;
                    bUpdateVerticalScrollPosition = true;
                    bSelectItem = true;
                }
                else if ((caretIndex == collection.length - 1) && partialRow)
                {
                    if (verticalScrollPosition < layout.maxVerticalScrollPosition)
                        newVerticalScrollPosition = verticalScrollPosition + layout.actualRowHeight/*1*/;
                }
                break;
            }

            case Keyboard.PAGE_UP:
            {
                if (caretIndex < lockedRowCount)
                {
                    newVerticalScrollPosition = 0;
                    caretIndex = 0;
                }
                // if the caret is on-screen, but not at the top row
                // just move the caret to the top row
                else if (caretIndex > layout.firstVisibleIndex/*verticalScrollPosition*/ + lockedRowCount &&
                    caretIndex < layout.firstVisibleIndex/*verticalScrollPosition*/ + rowCount)
                {
                    caretIndex = layout.firstVisibleIndex/*verticalScrollPosition*/ + lockedRowCount;
                }
                else
                {
                    // paging up is really hard because we don't know how many
                    // rows to move because of variable row height.  We would have
                    // to double-buffer a previous screen in order to get this exact
                    // so we just guess for now based on current rowCount
                    caretIndex = Math.max(caretIndex - rowCount + lockedRowCount, 0);
                    newVerticalScrollPosition = Math.max(caretIndex - lockedRowCount,0) * layout.actualRowHeight;
                }
                bSelectItem = true;
                break;
            }

            case Keyboard.PAGE_DOWN:
            {
                if (caretIndex < lockedRowCount)
                {
                    newVerticalScrollPosition = 0;
                }
                // if the caret is on-screen, but not at the bottom row
                // just move the caret to the bottom row (not partial row)
                else if (caretIndex >= verticalScrollPosition + lockedRowCount &&
                    caretIndex < verticalScrollPosition + rowCount - partialRow - 1)
                {
                }
                else
                {
                    newVerticalScrollPosition = Math.min((caretIndex - lockedRowCount) * layout.actualRowHeight, layout.maxVerticalScrollPosition);
                }
                bSelectItem = true;
                break;
            }

            case Keyboard.HOME:
            {
                if (caretIndex > 0)
                {
                    caretIndex = 0;
                    bSelectItem = true;
                    newVerticalScrollPosition = 0;
                }
                break;
            }

            case Keyboard.END:
            {
                if (caretIndex < collection.length - 1)
                {
                    caretIndex = collection.length - 1;
                    bSelectItem = true;
                    newVerticalScrollPosition = layout.maxVerticalScrollPosition;
                }
                break;
            }
        }

        if (bUpdateVerticalScrollPosition)
        {
            if (caretIndex < lockedRowCount)
                newVerticalScrollPosition = 0;
            else if (caretIndex < layout.firstVisibleIndex/*verticalScrollPosition*/ + lockedRowCount)
                newVerticalScrollPosition = caretIndex - lockedRowCount;
            else if (caretIndex >= layout.firstVisibleIndex/*verticalScrollPosition */+ rowCount - partialRow)
                newVerticalScrollPosition = Math.min(layout.maxVerticalScrollPosition, 
                    (caretIndex - rowCount + partialRow + 1) * layout.actualRowHeight);
        }

        if (!isNaN(newVerticalScrollPosition))
        {
            if (verticalScrollPosition != newVerticalScrollPosition)
            {
                var se:Event = new Event("scroll");
                /*
                var se:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
                se.detail = ScrollEventDetail.THUMB_POSITION;
                se.direction = ScrollEventDirection.VERTICAL;
                se.delta = newVerticalScrollPosition - verticalScrollPosition;
                se.position = newVerticalScrollPosition;
                */
                verticalScrollPosition = newVerticalScrollPosition;
                dispatchEvent(se);
            }
            
            // bail if we page faulted
            if (!iteratorValid)
            {
                keySelectionPending = true;
                return;
            }
        }

        bShiftKey = shiftKey;
        bCtrlKey = ctrlKey;

        lastKey = code;

        finishKeySelection();
    }

    /**
     *  Sets selected items based on the <code>caretIndex</code> and 
     *  <code>anchorIndex</code> properties.  
     *  Called by the keyboard selection handlers
     *  and by the <code>updateDisplayList()</code> method in case the 
     *  keyboard selection handler
     *  got a page fault while scrolling to get more items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected function finishKeySelection():void
    {
        var uid:String;
        var rowCount:int = layout.lastVisibleIndex = layout.firstVisibleIndex; //listItems.length;
        var partialRow:int = /*(rowInfo[rowCount-1].y + rowInfo[rowCount-1].height >
                                  listContent.height) ? 1 :*/ 0;

        if (lastKey == Keyboard.PAGE_DOWN)
        {
            // set caret to last full row of new screen
            caretIndex = Math.min(verticalScrollPosition + rowCount - partialRow - 1,
                                  collection.length - 1);
        }

        var listItem:IListItemRenderer;
        var bSelChanged:Boolean = false;

        if (bSelectItem && caretIndex - layout.firstVisibleIndex/*verticalScrollPosition*/ >= 0)
        {
            if (caretIndex - layout.firstVisibleIndex/*verticalScrollPosition*/ > rowCount/*listItems.length*/ - 1)
                caretIndex = rowCount/*listItems.length*/ - 1 + layout.firstVisibleIndex/*verticalScrollPosition*/;

            //listItem = listItems[caretIndex - verticalScrollPosition][0];
            if (isVisibleIndex(caretIndex))/*(listItem)*/
            {
                var bookmark:CursorBookmark = iterator.bookmark;
                iterator.seek(CursorBookmark.CURRENT, caretIndex - layout.firstVisibleIndex);
                var data:Object = iterator.current;
                uid = itemToUID(/*listItem.*/data);
                if (!bCtrlKey)
                {
                    selectItem(data, caretIndex, bShiftKey, bCtrlKey);
                    bSelChanged = true;
                }
                if (bCtrlKey)
                {
                    drawItem(caretIndex, selectedData[uid] != null, uid == highlightUID, true);
                }
            }
        }

        if (bSelChanged)
        {
            //var pt:Point = itemRendererToIndices(listItem);
            var evt:ListEvent = new ListEvent(ListEvent.CHANGE);
            //if (pt)
            //{
            //    evt.columnIndex = pt.x;
            //    evt.rowIndex = pt.y;
            //}
            evt.itemRenderer = listItem;
            dispatchEvent(evt);
        }
    }

    /**
     *  @private
     */
    mx_internal function commitSelectedIndex(value:int):void
    {
        if (value != -1)
        {
            value = Math.min(value, collection.length - 1);
            var bookmark:CursorBookmark = iterator.bookmark;
            var len:int = value - layout.firstVisibleIndex; //scrollPositionToIndex(horizontalScrollPosition, verticalScrollPosition);
            //try
            //{
                iterator.seek(CursorBookmark.CURRENT, len);
            //}
            //catch (e:ItemPendingError)
            //{
            //    iterator.seek(bookmark, 0);
                // if we can't seek to that spot, try again later.
            //    bSelectedIndexChanged = true;
            //    _selectedIndex = value;
            //    return;
            //}
            var data:Object = iterator.current;
            var selectedBookmark:CursorBookmark = iterator.bookmark;
            var uid:String = itemToUID(data);
            iterator.seek(bookmark, 0);
            selectData(uid, data, value, selectedBookmark);
        }
        else
        {
            clearSelected();
        }

        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
    }

    private var layout:DataGridLayout;
    
    private function isVisibleIndex(index:int):Boolean
    {
        if (!layout)
            layout = getBeadByType(DataGridLayout) as DataGridLayout;
        
        if (!layout) return false;
        return layout.isVisibleIndex(index);        
    }
    
    /**
     *  Implementation detail on selecting a data, used by commitSelectedIndex.
     *  @private
     */
    protected function selectData(uid:String, data:Object,
                            index:int, selectedBookmark:CursorBookmark):void
    {
        if (!selectedData[uid])
        {
            if (isVisibleIndex(index))
                selectItem(data, index, false, false);
            else
            {
                clearSelected();
                addSelectionData(uid, new ListBaseSelectionData(data, index, approximate));
                (model as ISelectionModel).selectedIndex = index; // was _selectedIndex = index;
                caretIndex = index;
                caretBookmark = selectedBookmark;
                anchorIndex = index;
                anchorBookmark = selectedBookmark;
                //_selectedItem = data;
            }
        }
    }

    override public function get selectedIndices():Array
    {
        return copySelectedItems(false);
    }
    
    /**
     *  @private
     */
    override public function set selectedIndices(indices:Array):void
    {
        commitSelectedIndices(indices);
    }

    /**
     *  @private
     */
    mx_internal function commitSelectedIndices(indices:Array):void
    {
        // trace("setting indices");
        clearSelected();

        //try
        //{
            collectionIterator.seek(CursorBookmark.FIRST, 0);
        //}
        //catch (e:ItemPendingError)
        //{
        //    e.addResponder(new ItemResponder(selectionIndicesPendingResultHandler, selectionIndicesPendingFailureHandler,
        //                                            new ListBaseSelectionDataPending(true, 0, indices, CursorBookmark.FIRST, 0)));
        //    return;
        //}

        setSelectionIndicesLoop(0, indices, true);
    }

    /**
     *  @private
     */
    private function setSelectionIndicesLoop(index:int, indices:Array, firstTime:Boolean = false):void
    {
        while (indices.length)
        {
            if (index != indices[0])
            {
                //try
                //{
                    collectionIterator.seek(CursorBookmark.CURRENT, indices[0] - index);
                //}
                //catch (e:ItemPendingError)
                //{
                //    e.addResponder(new ItemResponder(selectionIndicesPendingResultHandler, selectionIndicesPendingFailureHandler,
                //                                new ListBaseSelectionDataPending(firstTime, index, indices, CursorBookmark.CURRENT, indices[0] - index)));
                //    return;
                //}

            }
            index = indices[0];
            indices.shift();

            var data:Object = collectionIterator.current;
            if (firstTime)
            {
                (model as ISelectionModel).selectedIndex = index; //_selectedIndex = index;
                //_selectedItem = data;
				caretIndex = index;
				caretBookmark = collectionIterator.bookmark;
				anchorIndex = index;
				anchorBookmark = collectionIterator.bookmark;
                firstTime = false;
            }
            addSelectionData(itemToUID(data), new ListBaseSelectionData(data, index, false));
            // trace("uid = " + itemToUID(data));
        }

        if (initialized)
            updateList();

        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
    }

    /**
     *  @private
     */
    private function commitSelectedItem(data:Object, clearFirst:Boolean = true):void
    {
        if (clearFirst)
            clearSelected();
        if (data != null)
            commitSelectedItems([data]);
    }

    /**
     *  @private
     */
    private function commitSelectedItems(items:Array):void
    {
        clearSelected();

        var useFind:Boolean = collection.sort != null;

        //try
        //{
            collectionIterator.seek(CursorBookmark.FIRST, 0);
        //}
        //catch (e:ItemPendingError)
        //{
        //    e.addResponder(new ItemResponder(selectionDataPendingResultHandler, selectionDataPendingFailureHandler,
        //                                            new ListBaseSelectionDataPending(useFind, 0, items, null, 0)));
        //    return;
        //}

        setSelectionDataLoop(items, 0, useFind);
    }

    /**
     *  @private
     */
    private function setSelectionDataLoop(items:Array, index:int, useFind:Boolean = true):void
    {
        var uid:String;

        if (useFind)
        {
            while (items && items.length)
            {
                var item:Object = items.pop();
                uid = itemToUID(item);

                //try
                //{
                    collectionIterator.findAny(item);
                //}
                //catch (e1:ItemPendingError)
                //{
                //    items.push(item);
                //    e1.addResponder(new ItemResponder(selectionDataPendingResultHandler, selectionDataPendingFailureHandler,
                //                                            new ListBaseSelectionDataPending(useFind, 0, items, null, 0)));
                //    return;
                //}
                var bookmark:CursorBookmark = collectionIterator.bookmark;
                var viewIndex:int = bookmark.getViewIndex();
                if (viewIndex >= 0)
                {
                    addSelectionData(uid, new ListBaseSelectionData(item, viewIndex, true));
                }
                else
                {
                    //try
                    //{
                        collectionIterator.seek(CursorBookmark.FIRST, 0);
                    //}
                    //catch (e2:ItemPendingError)
                    //{
                    //    e2.addResponder(new ItemResponder(selectionDataPendingResultHandler, selectionDataPendingFailureHandler,
                    //                                            new ListBaseSelectionDataPending(false, 0, items, CursorBookmark.FIRST, 0)));
                    //    return;
                    //}

                    // collection doesn't support indexes from bookmarks so
                    // try again w/o using bookmarks
                    items.push(item);
                    setSelectionDataLoop(items, 0, false);
                    return;
                }
                if (items.length == 0)
                {
                    (model as ISelectionModel).selectedIndex = viewIndex; //_selectedIndex = viewIndex;
                    //_selectedItem = item;
                    caretIndex = viewIndex;
                    caretBookmark = collectionIterator.bookmark;
                    anchorIndex = viewIndex;
                    anchorBookmark = collectionIterator.bookmark;
                }
            }
        }
        else
        {
            while (items && items.length && !collectionIterator.afterLast)
            {
                var n:int = items.length;
                var data:Object = collectionIterator.current;
                for (var i:int = 0; i < n; i++)
                {
                    if (data == items[i])
                    {
                        uid = itemToUID(data);
                        addSelectionData(uid, new ListBaseSelectionData(data, index, false));
                        items.splice(i, 1);
                        if (items.length == 0)
                        {
                            (model as ISelectionModel).selectedIndex = index; //_selectedIndex = index;
                            //_selectedItem = data;
                            caretIndex = index;
                            caretBookmark = collectionIterator.bookmark;
                            anchorIndex = index;
                            anchorBookmark = collectionIterator.bookmark;
                        }
                        break;
                    }
                }
                //try
                //{
                    collectionIterator.moveNext();
                    index++;
                //}
                //catch (e2:ItemPendingError)
                //{
                //    e2.addResponder(new ItemResponder(selectionDataPendingResultHandler, selectionDataPendingFailureHandler,
                //                                            new ListBaseSelectionDataPending(false, index, items, CursorBookmark.CURRENT, 1)));
                //    return;
                //}
            }
        }

        if (initialized)
            updateList();

        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));

    }

    /**
     *  @private
     */
    private function clearSelectionData():void
    {
        selectedData = {};
        firstSelectionData = null;
    }

    /**
     *  @private
     */
    mx_internal function addSelectionData(uid:String, selectionData:ListBaseSelectionData):void
    {
        if (firstSelectionData != null)
            firstSelectionData.prevSelectionData = selectionData;
        selectionData.nextSelectionData = firstSelectionData;
        firstSelectionData = selectionData;
        
        selectedData[uid] = selectionData;
    }

    /**
     *  @private
     */
    private function removeSelectionData(uid:String):void
    {
        var curSelectionData:ListBaseSelectionData = selectedData[uid];
        
        if (firstSelectionData == curSelectionData)
            firstSelectionData = curSelectionData.nextSelectionData;
        
        if (curSelectionData.prevSelectionData != null)
            curSelectionData.prevSelectionData.nextSelectionData = curSelectionData.nextSelectionData;

        if (curSelectionData.nextSelectionData != null)
            curSelectionData.nextSelectionData.prevSelectionData = curSelectionData.prevSelectionData;
        
        delete selectedData[uid];
    }

    /**
     *  Sets up the effect for applying the selection indicator.
     *  The default is a basic alpha tween.
     *
     *  @param indicator A Sprite that contains the graphics depicting selection.
     *  @param uid The UID of the item being selected which can be used to index
     *  into a table and track more than one selection effect.
     *  @param itemRenderer The item renderer that is being shown as selected.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function applySelectionEffect(indicator:Sprite, uid:String,
                                            itemRenderer:IListItemRenderer):void
    {
        var selectionDuration:Number =
            getStyle("selectionDuration");

        if (selectionDuration != 0)
        {
            indicator.alpha = 0;

            selectionTweens[uid] =
                new Tween(indicator, 0, 1, selectionDuration, 5);

            selectionTweens[uid].addEventListener(TweenEvent.TWEEN_UPDATE,
                                                  selectionTween_updateHandler);

            selectionTweens[uid].addEventListener(TweenEvent.TWEEN_END,
                                                  selectionTween_endHandler);

            selectionTweens[uid].setTweenHandlers(onSelectionTweenUpdate,
                                                  onSelectionTweenUpdate);

            var selectionEasingFunction:Function =
                getStyle("selectionEasingFunction") as Function;
            if (selectionEasingFunction != null)
                selectionTweens[uid].easingFunction = selectionEasingFunction;
        }
    } */

    /**
     *  @private
     */
    /* private function onSelectionTweenUpdate(value:Number):void
    {
    }
 */
    /**
     *  Makes a copy of the selected items in the order they were
     *  selected.
     *
     *  @param useDataField <code>true</code> if the array should
     *  be filled with the actual items or <code>false</code>
     *  if the array should be filled with the indexes of the items.
     *
     *  @return Array of selected items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected function copySelectedItems(useDataField:Boolean = true):Array
    {
        var tmp:Array = [];

        var curSelectionData:ListBaseSelectionData = firstSelectionData;
        while (curSelectionData != null)
        {
            if (useDataField)
                tmp.push(curSelectionData.data);
            else
                tmp.push(curSelectionData.index);
            
            curSelectionData = curSelectionData.nextSelectionData;
        }
        
        return tmp;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods: Scrolling
    //
    //--------------------------------------------------------------------------

    /**
     *  Returns the data provider index for the item at the first visible
     *  row and column for the given scroll positions.
     *
     *  @param horizontalScrollPosition The <code>horizontalScrollPosition</code>
     *         property value corresponding to the scroll position.
     *  @param verticalScrollPosition The <code>verticalScrollPosition</code>
     *         property value corresponding to the scroll position.
     *
     *  @return The data provider index.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function scrollPositionToIndex(horizontalScrollPosition:int,
                                             verticalScrollPosition:int):int
    {
        return iterator ? verticalScrollPosition : -1;
    } */

    /**
     *  Ensures that the data provider item at the given index is visible.
     *  If the item is visible, the <code>verticalScrollPosition</code>
     *  property is left unchanged even if the item is not the first visible
     *  item. If the item is not currently visible, the 
     *  <code>verticalScrollPosition</code>
     *  property is changed make the item the first visible item, unless there
     *  aren't enough rows to do so because the 
     *  <code>verticalScrollPosition</code> value is limited by the 
     *  <code>maxVerticalScrollPosition</code> property.
     *
     *  @param index The index of the item in the data provider.
     *
     *  @return <code>true</code> if <code>verticalScrollPosition</code> changed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    override public function scrollToIndex(index:int):Boolean
    {
		/*
       var newVPos:int;

        if (index >= verticalScrollPosition + listItems.length - lockedRowCount - offscreenExtraRowsBottom || index < verticalScrollPosition)
        {
            newVPos = Math.min(index, maxVerticalScrollPosition);
            verticalScrollPosition = newVPos;
            return true;
        }
		*/
		COMPILE::JS
		{
			var listArea:IUIBase = (view as DataGridView).listArea;
			var element:HTMLElement = listArea.element;
			var max:Number = Math.max(0, dataProvider.length * rowHeight - element.clientHeight);
			var yy:Number = Math.min(index * rowHeight, max);
			element.scrollTop = yy;
		}
        return false; 
    } 
     

    /**
     *  Adjusts the renderers in response to a change
     *  in scroll position.
     *
     *  <p>The list classes attempt to optimize scrolling
     *  when the scroll position has changed by less than
     *  the number of visible rows.  In that situation,
     *  some rows are unchanged and just need to be moved,
     *  other rows are removed and then new rows are added.
     *  If the scroll position changes too much, all old rows are removed
     *  and new rows are added by calling the <code>makeRowsAndColumns()</code>
     *  method for the entire viewable area.</p>
     *
     *  @param pos The new scroll position.
     *
     *  @param deltaPos The change in position. It is always
     *  a positive number.
     *
     *  @param scrollUp <code>true</code> if scroll position
     *  is getting smaller.
     *
     *  @see mx.controls.listClasses.ListBase#makeRowsAndColumns()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function scrollVertically(pos:int, deltaPos:int,
                                        scrollUp:Boolean):void
    {
        // trace("scrollVertically " + pos);

        var i:int;
        var j:int;
        var r:IListItemRenderer;
        var item:IListItemRenderer;

        var numRows:int;
        var numCols:int;
        var uid:String;

        var visibleY:Number;
        var curY:Number;

        var rowCount:int = rowInfo.length;
        
        if(rowCount > listItems.length)
        {
            rowCount = listItems.length;
        }
        
        var columnCount:int = listItems[0].length;
        var cursorPos:CursorBookmark;

        var moveBlockDistance:Number = 0;
        visibleY = (lockedRowCount > 0) ? rowInfo[lockedRowCount - 1].y + rowInfo[lockedRowCount - 1].height : rowInfo[0].y;
        if (scrollUp)
        {
            // find first fully visible row not spanning onto the screen;
            // trace("visibleY = " + visibleY);
            for (i = lockedRowCount; i < rowCount; i++)
            {
                if (rowInfo[i].y >= visibleY)
                    break;
            }

            var startRow:int = i;

            // measure how far we have to move by measuring each row
            for (i; i < deltaPos + startRow; i++)
            {
                // after we shift the items, see if any are still visible
                moveBlockDistance += rowInfo[i].height;
                try
                {
                    iterator.moveNext();
                }
                catch (e:ItemPendingError)
                {
                    lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, pos)
                    e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler,
                                                        lastSeekPending));
                    iteratorValid = false;
                    // trace("itemPending in ScrollVertically");
                    return;
                }
            }

            // trace("moveBlockDistance = " + moveBlockDistance);
            
            //  shift rows upward and toss invisible ones.
            for (i = lockedRowCount; i < rowCount; i++)
            {
                numCols = Math.min(columnCount,listItems[i].length);

                // if row is not visible, toss it
                if (i < deltaPos + lockedRowCount)
                {
                    destroyRow(i, numCols);
                }
                else if (deltaPos > 0)
                {
                    // after we shift the items, see if any are still visible
                    for (j = 0; j < numCols; j++)
                    {
                        r = listItems[i][j];
                        r.move(r.x, r.y - moveBlockDistance);
                        if (r.data && r is IDropInListItemRenderer)
                            IDropInListItemRenderer(r).listData.rowIndex = i;
                        rowMap[r.name].rowIndex = i;
                    }
                    rowInfo[i].y -= moveBlockDistance;
                    uid = rowInfo[i].uid;
                    if (uid)
                    {
                        // This assumes all the selection indicators in this row are at
                        // the same 'y' position
                        moveIndicators(uid, -moveBlockDistance, false);
                    }
                }
            }
            
            // trace("tossed " + deltaPos + " " + rowCount);
            // deltaPos is now the number of rows we tossed
            if (deltaPos)
            {
                for (i = lockedRowCount + deltaPos; i < rowCount; i++)
                {
                    numCols = listItems[i].length;
                    for (j = 0; j < numCols; j++)
                    {
                        // trace("compacting " + i + " " + j);
                        // compact the array
                        r = listItems[i][j];
                        if (r.data && r is IDropInListItemRenderer)
                            IDropInListItemRenderer(r).listData.rowIndex = i - deltaPos;
                        rowMap[r.name].rowIndex = i - deltaPos;
                        listItems[i - deltaPos][j] = r;
                    }
                    if (listItems[i - deltaPos].length > numCols)
                        listItems[i-deltaPos].splice(numCols);
                    // if no columns, make destination row empty.  Normally this is filled in by
                    // makeRowsAndColumns, but if it page faults it won't fill it in
                    // but the item in [i - deltapos] is already on the free list
                    if (!numCols)
                        listItems[i - deltaPos].splice(0);
                    rowInfo[i - deltaPos] = rowInfo[i];
                }
                listItems.splice(rowCount - deltaPos);
                rowInfo.splice(rowCount - deltaPos);
                // trace("listItems.length = " + listItems.length);
            }
          if(rowInfo && rowInfo.length > 0)
             curY = rowInfo[rowCount - deltaPos - 1].y + rowInfo[rowCount - deltaPos - 1].height;
          else
             curY = 0;

            cursorPos = iterator.bookmark;
            try
            {
                iterator.seek(CursorBookmark.CURRENT, rowCount - lockedRowCount - deltaPos);
            }
            catch (e1:ItemPendingError)
            {
                // trace("IPE in scrollVertically");
                lastSeekPending = new ListBaseSeekPending(cursorPos, 0)
                e1.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler,
                                                    lastSeekPending));
                iteratorValid = false;
                // we don't do anything here and will repaint when the rows arrive
            }

            // fill it in
          makeRowsAndColumns(0, curY, listContent.width, listContent.height, 0, rowCount - deltaPos);
             
            iterator.seek(cursorPos, 0);
        }
        else
        {
            // scrolling down is different because rows are locked to top.
            // instead of measuring how much space we lost, we make the rows requested
            // and then toss as many (including 0) rows as needed to make room for the
            // new rows
            // copy the old rows
            curY = 0;
            if (lockedRowCount > 0)
                curY = rowInfo[lockedRowCount - 1].y + rowInfo[lockedRowCount - 1].height;
            else
                curY = rowInfo[0].y

            // insert slots to be filled by new rows
            for (i = 0; i < deltaPos; i++)
            {
                listItems.splice(lockedRowCount, 0, null);
                rowInfo.splice(lockedRowCount, 0, null);
            }

            try
            {
                iterator.seek(CursorBookmark.CURRENT, -deltaPos);
            }
            catch (e2:ItemPendingError)
            {
                lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT, -deltaPos)
                e2.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler,
                                                        lastSeekPending));
                iteratorValid = false;
            }
            cursorPos = iterator.bookmark;

            var actual:Point = makeRowsAndColumns(0, curY, listContent.width, listContent.height, 0, lockedRowCount, true, deltaPos);
            // trace("made " + actual.y);
            iterator.seek(cursorPos, 0);

            if (actual.y == 0)
            {
                // no more rows, set verticalScrollPosition to 0, restore the rows and leave
                verticalScrollPosition = 0;
                rowInfo.splice(lockedRowCount, deltaPos);
                listItems.splice(lockedRowCount, deltaPos);
            }

            // measure how far we have to move by measuring each new row
            for (i = 0; i < actual.y; i++)
            {
                moveBlockDistance += rowInfo[lockedRowCount + i].height;
            }
            // trace("moveBlockDistance = " + moveBlockDistance);

            var row:Array;
            var rowData:Object;

            // trace("curY = " + curY);
            var deltaY:Number;
            curY += moveBlockDistance;

            // trace("curY = " + curY);
            // fix up positions of old rows and delete any that fell off bottom
            for (i = lockedRowCount + actual.y; i < listItems.length; i++)
            {
                row = listItems[i];
                rowData = rowInfo[i];
                var deleteRow:Boolean = false;
                deltaY = curY - rowData.y;
                // trace("deltaY = " + deltaY + " curY = " + curY + " newRowIndex = " + newRowIndex);
                rowData.y = curY;
                if (row.length)
                {
                    for (j = 0; j < row.length; j++)
                    {
                        item = row[j];
                        item.move(item.x, item.y + deltaY);
                        if (item.y >= listContent.height)
                        {
                            deleteRow = true;
                        }
                        if (!deleteRow)
                        {
                            rowMap[item.name].rowIndex += deltaPos;
                        }
                    }
                }
                else
                {
                    if (rowData.y >= listContent.height)
                        deleteRow = true;
                }
                uid = rowInfo[i].uid;
                if (deleteRow)
                {
                    var oldRow:Array = listItems[i];
                    if (oldRow.length && oldRow[0].data)
                    {
                        removeIndicators(uid);
                    }
                    for (j = 0; j < oldRow.length; j++)
                    {
                        if (oldRow[j] && oldRow[j].data)
                        {
                            delete visibleData[uid];
                            addToFreeItemRenderers(oldRow[j]);
                        }
                    }
                    listItems.splice(i, 1);
                    rowInfo.splice(i, 1);
                    i--;    // backup one cuz we deleted one
                }
                if (uid)
                {
                    // This assumes all the selection indicators in this row are at
                    // the same 'y' position
                    moveIndicators(uid, curY, true);

                    if (selectionIndicators[uid])
                        selectionIndicators[uid].y = curY;
                    if (highlightUID == uid)
                        highlightIndicator.y = curY;
                    if (caretUID == uid)
                        caretIndicator.y = curY;
                }
                curY += rowData.height;
            }
            rowCount = listItems.length;
        }
    }                                       

    private function destroyRow(i:int, numCols:int):void
    {
        var r:IListItemRenderer;
        var uid:String = rowInfo[i].uid;

        removeIndicators(uid);
        for (var j:int = 0; j < numCols; j++)
        {
            r = listItems[i][j];
            if (r.data)
                delete visibleData[uid];
            addToFreeItemRenderers(r);
            // we don't seem to be doing this consistently throughout the code?
            // listContent.removeChild(DisplayObject(r));
        }
    }

    private function moveRowVertically(i:int, numCols:int, moveBlockDistance:Number):void
    {
        var r:IListItemRenderer;

        for (var j:int = 0; j < numCols; j++)
        {
            r = listItems[i][j];
            r.move(r.x, r.y + moveBlockDistance);
        }
        rowInfo[i].y += moveBlockDistance;
    }

    private function shiftRow(oldIndex:int, newIndex:int, numCols:int, shiftItems:Boolean):void
    {
        var r:IListItemRenderer;
        for (var j:int = 0; j < numCols; j++)
        {
            r = listItems[oldIndex][j];
            if (shiftItems)
            {
                listItems[newIndex][j] = r;
                rowMap[r.name].rowIndex = newIndex;
            }
            // this is sort of a hack to accomodate the fact that
            // scrolling down does a splice which throws off these values.
            // probably better to call shiftRow with different parameters?
            else
            {
                rowMap[r.name].rowIndex = oldIndex;
            }
        }
    } */

    /**
     *  @copy mx.controls.listClasses.ListBase#moveIndicatorsVertically()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function moveIndicatorsVertically(uid:String, moveBlockDistance:Number):void
    {
        if (uid)
        {
            if (selectionIndicators[uid])
                selectionIndicators[uid].y += moveBlockDistance;
            if (highlightUID == uid)
                highlightIndicator.y += moveBlockDistance;
            if (caretUID == uid)
                caretIndicator.y += moveBlockDistance;
        }
    } */

    /**
     *  @copy mx.controls.listClasses.ListBase#moveIndicatorsHorizontally()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function moveIndicatorsHorizontally(uid:String, moveBlockDistance:Number):void
    {
        if (uid)
        {
            if (selectionIndicators[uid])
                selectionIndicators[uid].x += moveBlockDistance;
            if (highlightUID == uid)
                highlightIndicator.x += moveBlockDistance;
            if (caretUID == uid)
                caretIndicator.x += moveBlockDistance;
        }
    }

    private function sumRowHeights(startRowIdx:int, endRowIdx:int):Number
    {
        var sum:Number = 0;
        
        for (var i:int = startRowIdx ; i <= endRowIdx; i++)
            sum += rowInfo[i].height;
        return sum;
    }    */

    /**
     *  Adjusts the renderers in response to a change
     *  in scroll position.
     *
     *  <p>The list classes attempt to optimize scrolling
     *  when the scroll position has changed by less than
     *  the number of visible rows.  In that situation
     *  some rows are unchanged and just need to be moved,
     *  other rows are removed and then new rows are added.
     *  If the scroll position changes too much, all old rows are removed
     *  and new rows are added by calling the <code>makeRowsAndColumns()</code>
     *  method for the entire viewable area.</p>
     *
     *  <p>Not implemented in AdvancedListBase because the default list
     *  is single column and therefore doesn't scroll horizontally.</p>
     *
     *  @param pos The new scroll position.
     *  @param deltaPos The change in position.  It is always
     *  a positive number.
     *  @param scrollUp <code>true</code> if scroll position
     *  is getting smaller.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function scrollHorizontally(pos:int, deltaPos:int, scrollUp:Boolean):void
    {
        // update visible columns

        // translate vertical logic here
    } */

    /**
     *  Configures the ScrollBars based on the number of rows and columns and
     *  viewable rows and columns.
     *  This method is called from the <code>updateDisplayList()</code> method
     *  after the rows and columns have been updated.
     *  The method should figures out what parameters to pass into the 
     *  <code>setScrollBarProperties()</code> to properly set the ScrollBars up.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function configureScrollBars():void
    {
    } */

    /**
     *  Interval function that scrolls the list up or down
     *  if the mouse goes above or below the list.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function dragScroll():void
    {
        var slop:Number = 0;
        var scrollInterval:Number;
        var oldPosition:Number;
        var d:Number;
        var scrollEvent:ScrollEvent;

        // sometimes, we'll get called even if interval has been cleared
        if (dragScrollingInterval == 0)
            return;

        const minScrollInterval:Number = 30;

        if (DragManager.isDragging)
        {
            slop = viewMetrics.top
                + (variableRowHeight ? getStyle("fontSize") / 4 : rowHeight);
        }

        clearInterval(dragScrollingInterval);

        if (mouseY < slop)
        {
            oldPosition = verticalScrollPosition;
            verticalScrollPosition = Math.max(0, oldPosition - 1);
            if (DragManager.isDragging)
            {
                scrollInterval = 100;
            }
            else
            {
                d = Math.min(0 - mouseY - 30, 0);
                // quadratic relation between distance and scroll speed
                scrollInterval = 0.593 * d * d + 1 + minScrollInterval;
            }

            dragScrollingInterval = setInterval(dragScroll, scrollInterval);

            if (oldPosition != verticalScrollPosition)
            {
                scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
                scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
                scrollEvent.direction = ScrollEventDirection.VERTICAL;
                scrollEvent.position = verticalScrollPosition;
                scrollEvent.delta = verticalScrollPosition - oldPosition;
                dispatchEvent(scrollEvent);
            }
        }
        else if (mouseY > (unscaledHeight - slop))
        {
            oldPosition = verticalScrollPosition;
            verticalScrollPosition = Math.min(maxVerticalScrollPosition, verticalScrollPosition + 1);
            if (DragManager.isDragging)
            {
                scrollInterval = 100;
            }
            else
            {
                d = Math.min(mouseY - unscaledHeight - 30, 0);
                scrollInterval = 0.593 * d * d + 1 + minScrollInterval;
            }

            dragScrollingInterval = setInterval(dragScroll, scrollInterval);

            if (oldPosition != verticalScrollPosition)
            {
                scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
                scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
                scrollEvent.direction = ScrollEventDirection.VERTICAL;
                scrollEvent.position = verticalScrollPosition;
                scrollEvent.delta = verticalScrollPosition - oldPosition;
                dispatchEvent(scrollEvent);
            }
        }
        else
        {
            dragScrollingInterval = setInterval(dragScroll, 15);
        }
		
		if (DragManager.isDragging && lastDragEvent && oldPosition != verticalScrollPosition)
		{
			dragOverHandler(lastDragEvent);
		}
    } */

    /**
     *  @private
     *  Stop the drag scrolling callback.
     */
    /* mx_internal function resetDragScrolling():void
    {
        if (dragScrollingInterval != 0)
        {
            clearInterval(dragScrollingInterval);
            dragScrollingInterval = 0;
        }
    } */

    //--------------------------------------------------------------------------
    //
    //  Methods: Drag and drop
    //
    //--------------------------------------------------------------------------

    /**
     *  Adds the selected items to the DragSource object as part of a
     *  drag-and-drop operation.
     *  Override this method to add other data to the drag source.
     * 
     * @param dragSource The DragSource object to which to add the data.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function addDragData(dragSource:Object):void // actually a DragSource
    {
		// The Halo drag drop data format
		dragSource.addHandler(copySelectedItems, "items");
		
		// The Spark drag drop data format
		dragSource.addHandler(copySelectedItemsForDragDrop, "itemsByIndex");
		
		// Calculate the index of the focus item within the vector
		// of ordered items returned for the "itemsByIndex" format.
		var caretIndex:int = 0;
		var draggedIndices:Array = selectedIndices;
		var count:int = draggedIndices.length;
		for (var i:int = 0; i < count; i++)
		{
			if (mouseDownIndex > draggedIndices[i])
				caretIndex++;
		}
		dragSource.addData(caretIndex, "caretIndex");
    } */

    /**
     *  Returns the index where the dropped items should be added 
     *  to the drop target.
     *
     *  @param event A DragEvent that contains information about
     *  the position of the mouse.  If <code>null</code> the
     *  method should return the <code>dropIndex</code> value from the 
     *  last valid event.
     *
     *  @return Index where the dropped items should be added.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  public function calculateDropIndex(event:DragEvent = null):int
    {
        if (event)
        {
            var item:IListItemRenderer;
            var pt:Point = new Point(event.localX, event.localY);
            pt = DisplayObject(event.target).localToGlobal(pt);
            pt = listContent.globalToLocal(pt);

            var n:int = listItems.length;
            for (var i:int = 0; i < n; i++)
            {
                if (rowInfo[i].y <= pt.y && pt.y <= rowInfo[i].y + rowInfo[i].height)
                {
                    item = listItems[i][0];
                    break;
                }
            }

            if (item)
            {
                lastDropIndex = itemRendererToIndex(item);
            }
            else
                lastDropIndex = collection ? collection.length : 0;
        }

        return lastDropIndex;
    } */

    /**
     *  Calculates the y position of the drop indicator 
     *  when performing a drag-and-drop operation.
     *
     *  @param rowCount The number of visible rows in the control.
     *
     *  @param rowNum The row number in the control where the drop indicator should appear.
     *
     *  @return The y axis coordinate of the drop indicator.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function calculateDropIndicatorY(rowCount:Number,
                                               rowNum:int):Number
    {
        var i:int;
        var yy:Number = 0;

        if (rowCount && listItems[rowNum].length && listItems[rowNum][0])
        {
           return listItems[rowNum][0].y - 1
        }

        for (i = 0; i < rowCount; i++)
        {
            if (listItems[i].length)
                yy += rowInfo[i].height;
            else
                break;
        }
        return yy;
    } */
    
    /**
     *  Displays a drop indicator under the mouse pointer to indicate that a
     *  drag and drop operation is allowed and where the items will
     *  be dropped.
     *
     *  @param event A DragEvent object that contains information as to where
     *  the mouse is.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  public function showDropFeedback(event:DragEvent):void
    {
        if (!dropIndicator)
        {
            var dropIndicatorClass:Class = getStyle("dropIndicatorSkin");
            if (!dropIndicatorClass)
                dropIndicatorClass = ListDropIndicator;
            dropIndicator = IFlexDisplayObject(new dropIndicatorClass());

            var vm:EdgeMetrics = viewMetrics;

            drawFocus(true);

            dropIndicator.x = 2;
            dropIndicator.setActualSize(listContent.width - 4, 4);
            dropIndicator.visible = true;
            listContent.addChild(DisplayObject(dropIndicator));

            if (collection)
                dragScroll();
        }

        var rowNum:Number = calculateDropIndex(event);
        if (rowNum >= lockedRowCount)
            rowNum -= verticalScrollPosition;

        var rc:Number = listItems.length;
        if (rowNum >= rc)
            rowNum = rc - 1;
        
        if (rowNum < 0)
            rowNum = 0;

        dropIndicator.y = calculateDropIndicatorY(rc, rowNum);
    } */

    /**
     *  Hides the drop indicator under the mouse pointer that indicates that a
     *  drag and drop operation is allowed.
     *
     *  @param event A DragEvent object that contains information about the
     *  mouse location.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function hideDropFeedback(event:DragEvent):void
    {
        if (dropIndicator)
        {
            listContent.removeChild(DisplayObject(dropIndicator));
            dropIndicator = null;
            drawFocus(false);
            if (dragScrollingInterval != 0)
            {
                clearInterval(dragScrollingInterval);
                dragScrollingInterval = 0;
            }
        }
    } */
	
	/**
	 *  Makes a deep copy of the object by calling the 
	 *  <code>ObjectUtil.copy()</code> method, and replaces 
	 *  the copy's <code>uid</code> property (if present) with a 
	 *  new value by calling the <code>UIDUtil.createUID()</code> method.
	 * 
	 *  <p>This method is used for a drag and drop copy.</p>
	 * 
	 *  @param item The item to copy.
	 *  
	 *  @return The copy of the object.
	 *
	 *  @see mx.utils.ObjectUtil
	 *  @see mx.utils.UIDUtil
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.4
	 */
	/* protected function copyItemWithUID(item:Object):Object
	{
		var copyObj:Object = ObjectUtil.copy(item);
		
		if (copyObj is IUID)
		{
			IUID(copyObj).uid = UIDUtil.createUID();
		}
		else if (copyObj is Object && "mx_internal_uid" in copyObj)
		{
			copyObj.mx_internal_uid = UIDUtil.createUID();
		}
		
		return copyObj;
	} */
	
	/**
	 *  @private
	 */
	/* private function copySelectedItemsForDragDrop():Vector.<Object>
	{
		// Copy the vector so that we don't modify the original
		// since selectedIndices returns a reference.
		var draggedIndices:Array = selectedIndices.slice(0, selectedIndices.length);
		var result:Vector.<Object> = new Vector.<Object>(draggedIndices.length);
		
		// Sort in the order of the data source
		draggedIndices.sort();
		
		// Copy the items
		var count:int = draggedIndices.length;
		for (var i:int = 0; i < count; i++)
			result[i] = dataProvider.getItemAt(draggedIndices[i]);  
		return result;
	} */
	
	/**
	 *  @private 
	 *  Insert for drag and drop, handles the Spark "itemsByIndex" data format.
	 */
	/* private function insertItemsByIndex(dropIndex:int, dragSource:DragSource, event:DragEvent):void
	{
		var items:Vector.<Object> = dragSource.dataForFormat("itemsByIndex") as Vector.<Object>;
		
		// Copy or move the items. No need to check whether the operation is
		// reorder within this list, as ListBase never creates the
		// "itemsByIndex" data format. This is a new data format from Spark List only. 
		collectionIterator.seek(CursorBookmark.FIRST, dropIndex);
		var count:int = items.length;
		for (var i:int = 0; i < count; i++)
		{
			if (event.action == DragManager.COPY)
			{
				collectionIterator.insert(copyItemWithUID(items[i]));
			}
			else if (event.action == DragManager.MOVE)
			{
				collectionIterator.insert(items[i]);
			} 
		}
	} */
	
	/**
	 *  @private
	 *  Insert for drag and drop, handles the Halo "items" data format. 
	 */
	/* private function insertItems(dropIndex:int, dragSource:DragSource, event:DragEvent):void
	{
		var items:Array = dragSource.dataForFormat("items") as Array;
		if (event.action == DragManager.MOVE && 
			dragMoveEnabled &&
			event.dragInitiator == this)
		{
			var indices:Array = selectedIndices;
			indices.sort(Array.NUMERIC);
			
			for (var i:int = indices.length - 1; i >= 0; i--)
			{
				collectionIterator.seek(CursorBookmark.FIRST, indices[i]);
				if (indices[i] < dropIndex)
					dropIndex--;
				collectionIterator.remove();
			}
			clearSelected(false);
		}
		collectionIterator.seek(CursorBookmark.FIRST, dropIndex);
		
		for (i = items.length - 1; i >= 0; i--)
		{
			if (event.action == DragManager.COPY)
			{
				collectionIterator.insert(copyItemWithUID(items[i]));
			}
			else if (event.action == DragManager.MOVE)
			{
				collectionIterator.insert(items[i]);
			} 
		}
	} */

    //--------------------------------------------------------------------------
    //
    //  Methods: Support for pending data
    //
    //--------------------------------------------------------------------------

    /**
     *  The default failure handler when a seek fails due to a page fault.
     *
     *  @param data The data that caused the error.
     *
     *  @param info Data about a seek operation 
     *  that was interrupted by an ItemPendingError error.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function seekPendingFailureHandler(data:Object,
                                                 info:ListBaseSeekPending):void
    {
    }
 */
    /**
     *  The default result handler when a seek fails due to a page fault.
     *  This method checks to see if it has the most recent page fault result:
     *  if not it simply exits; if it does, it sets the iterator to
     *  the correct position.
     *
     *  @param data The data that caused the error.
     *
     *  @param info Data about a seek operation 
     *  that was interrupted by an ItemPendingError error.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function seekPendingResultHandler(data:Object,
                                                info:ListBaseSeekPending):void
    {
        // trace("seekPendingResultHandler", this);

        if (info != lastSeekPending)
        {
            return;
        }

        lastSeekPending = null;

        iteratorValid = true;
        try 
        {
            iterator.seek(info.bookmark, info.offset);
        }
        catch (e:ItemPendingError)
        {
            lastSeekPending = new ListBaseSeekPending(info.bookmark, info.offset)
            e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler,
                                                lastSeekPending));
            iteratorValid = false;
        }
        if (bSortItemPending)
        {
            bSortItemPending = false;
            adjustAfterSort();
        }
        itemsSizeChanged = true;
        invalidateDisplayList();
    } */

    /**
     *  @private
     */
   /*  private function findPendingFailureHandler(data:Object,
                                               info:ListBaseFindPending):void
    {
    } */

    /**
     *  @private
     */
   /*  private function findPendingResultHandler(data:Object,
                                              info:ListBaseFindPending):void
    {
        // trace("findPendingResultHandler", this);
        iterator.seek(info.bookmark, info.offset);
        findStringLoop(info.searchString, info.startingBookmark, info.currentIndex, info.stopIndex);
    } */

    /**
     *  @private
     */
    /* private function selectionPendingFailureHandler(
                                    data:Object,
                                    info:ListBaseSelectionPending):void
    {
    } */

    /**
     *  @private
     */
    /* private function selectionPendingResultHandler(
                                    data:Object,
                                    info:ListBaseSelectionPending):void
    {
        // trace("selectionPendingResultHandler", this);
        iterator.seek(info.bookmark, info.offset);
        shiftSelectionLoop(info.incrementing, info.index, info.stopData,
                           info.transition, info.placeHolder);
    } */

    /**
     *  @private
     */
    /* private function selectionDataPendingFailureHandler(
                                    data:Object,
                                    info:ListBaseSelectionDataPending):void
    {
    } */

    /**
     *  @private
     */
    /* private function selectionDataPendingResultHandler(
                                    data:Object,
                                    info:ListBaseSelectionDataPending):void
    {
        // trace("selectionDataPendingResultHandler", this);
        if (info.bookmark)
            iterator.seek(info.bookmark, info.offset);
        setSelectionDataLoop(info.items, info.index, info.useFind);
    } */

    /**
     *  @private
     */
    /* private function selectionIndicesPendingFailureHandler(
                                    data:Object,
                                    info:ListBaseSelectionDataPending):void
    {
    } */

    /**
     *  @private
     */
    /* private function selectionIndicesPendingResultHandler(
                                    data:Object,
                                    info:ListBaseSelectionDataPending):void
    {
        // trace("selectionIndicesPendingResultHandler", this);
        if (info.bookmark)
            iterator.seek(info.bookmark, info.offset);
        setSelectionIndicesLoop(info.index, info.items, info.useFind);
    } */

    //--------------------------------------------------------------------------
    //
    //  Methods: Keyboard lookup
    //
    //--------------------------------------------------------------------------

    /**
     *  Tries to find the next item in the data provider that
     *  starts with the character in the <code>eventCode</code> parameter.
     *  You can override this to do fancier typeahead lookups.  The search
     *  starts at the <code>selectedIndex</code> location; if it reaches
     *  the end of the data provider it starts over from the beginning.
     *
     *  @param eventCode The key that was pressed on the keyboard.
     *  @return <code>true</code> if a match was found.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function findKey(eventCode:int):Boolean
    {
        var tmpCode:int = eventCode;
        
        return tmpCode >= 33 &&
               tmpCode <= 126 &&
               findString(String.fromCharCode(tmpCode));
    } */

    /**
     *  Finds an item in the list based on a string
     *  and moves the selection to it. The search
     *  starts at the <code>selectedIndex</code> location; if it reaches
     *  the end of the data provider it starts over from the beginning.
     *
     *  @param str The string to match.
     *  @return <code>true</code> if a match was found.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function findString(str:String):Boolean
    {
        if (!collection || collection.length == 0)
            return false;

        var cursorPos:CursorBookmark;
        cursorPos = iterator.bookmark;

        var stopIndex:int = selectedIndex;
        var i:int = stopIndex + 1;  // start at next

        if (selectedIndex == -1)
        {
            try
            {
                iterator.seek(CursorBookmark.FIRST, 0);
            }
            catch (e1:ItemPendingError)
            {
                e1.addResponder(new ItemResponder(
                    findPendingResultHandler, findPendingFailureHandler,
                    new ListBaseFindPending(str, cursorPos,
                    CursorBookmark.FIRST, 0, 0, collection.length)));
                
                iteratorValid = false;
                return false;
            }
            stopIndex = collection.length;
            i = 0;
        }
        else
        {
            try
            {
                iterator.seek(CursorBookmark.FIRST, stopIndex);
            }
            catch (e2:ItemPendingError)
            {
                if (anchorIndex == collection.length - 1)
                {
                    e2.addResponder(new ItemResponder(
                        findPendingResultHandler, findPendingFailureHandler,
                        new ListBaseFindPending(str, cursorPos,
                        CursorBookmark.FIRST, 0, 0, collection.length)));
                }
                else
                {
                    e2.addResponder(new ItemResponder(
                        findPendingResultHandler, findPendingFailureHandler,
                        new ListBaseFindPending(str, cursorPos,
                        anchorBookmark, 1, anchorIndex + 1, anchorIndex)));
                }
                
                iteratorValid = false;
                return false;
            }

            var bMovedNext:Boolean = false;
            
            // If we ran off the end, go back to beginning.
            try
            {
                bMovedNext = iterator.moveNext();
            }
            catch (e3:ItemPendingError)
            {
                // Assume we don't fault unless there is more data.
                e3.addResponder(new ItemResponder(
                    findPendingResultHandler, findPendingFailureHandler,
                    new ListBaseFindPending(str, cursorPos,
                    anchorBookmark, 1, anchorIndex + 1, anchorIndex)));
                
                iteratorValid = false;
                return false;
            }

            if (!bMovedNext)
            {
                try
                {
                    iterator.seek(CursorBookmark.FIRST, 0);
                }
                catch (e4:ItemPendingError)
                {
                    e4.addResponder(new ItemResponder(
                        findPendingResultHandler, findPendingFailureHandler,
                        new ListBaseFindPending(str, cursorPos,
                        CursorBookmark.FIRST, 0, 0, collection.length)));
                    
                    iteratorValid = false;
                    return false;
                }
                
                stopIndex = collection.length;
                i = 0;
            }
        }

        return findStringLoop(str, cursorPos, i, stopIndex);
    } */

    /**
     *  @private
     */
   /*  private function findStringLoop(str:String, cursorPos:CursorBookmark,
                                    i:int, stopIndex:int):Boolean
    {
        // Search from the current index.
        // Jump back to beginning if we hit the end.
        for (i; i != stopIndex; i++)
        {
            var itmStr:String = itemToLabel(iterator.current);
	
			if (itmStr) 
			{
	            itmStr = itmStr.substring(0, str.length);
				
	            if (str == itmStr || str.toUpperCase() == itmStr.toUpperCase())
	            {
	                iterator.seek(cursorPos, 0);
	                scrollToIndex(i);
	                commitSelectedIndex(i);
	                var item:IListItemRenderer = indexToItemRenderer(i);
	                var pt:Point = itemRendererToIndices(item);
	                var evt:ListEvent = new ListEvent(ListEvent.CHANGE);
	                evt.itemRenderer = item;
	                if (pt)
	                {
	                    evt.columnIndex = pt.x;
	                    evt.rowIndex = pt.y;
	                }
	                dispatchEvent(evt);
	                return true;
	            }
			}

            try
            {
                var more:Boolean = iterator.moveNext();
            }
            catch (e1:ItemPendingError)
            {
                e1.addResponder(new ItemResponder(
                    findPendingResultHandler, findPendingFailureHandler,
                    new ListBaseFindPending(str, cursorPos,
                    CursorBookmark.CURRENT, 1, i + 1, stopIndex)));
                
                iteratorValid = false;
                return false;
            }

            // Start from beginning if we hit the end
            if (!more && stopIndex != collection.length)
            {
                i = -1;
                try
                {
                    iterator.seek(CursorBookmark.FIRST, 0);
                }
                catch (e2:ItemPendingError)
                {
                    e2.addResponder(new ItemResponder(
                        findPendingResultHandler, findPendingFailureHandler,
                        new ListBaseFindPending(str, cursorPos,
                        CursorBookmark.FIRST, 0, 0, stopIndex)));
                    
                    iteratorValid = false;
                    return false;
                }
            }
        }

        iterator.seek(cursorPos, 0);
        iteratorValid = true;
        
        return false;
    } */

    //--------------------------------------------------------------------------
    //
    //  Methods: Sorting
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    /* private function adjustAfterSort():void
    {
        var i:int = 0;
        for (var p:String in selectedData)
        {
            i++;
        }

        var index:int = anchorBookmark ? anchorBookmark.getViewIndex() : -1;
        if (index >= 0)
        {
            // If only one thing selected, then we're done.
            if (i == 1)
            {
                _selectedIndex = anchorIndex = caretIndex = index;
                var data:ListBaseSelectionData = selectedData[p];
                data.index = index;
                
            }

            var newVerticalScrollPosition:int = indexToRow(index);
            newVerticalScrollPosition =
                Math.min(maxVerticalScrollPosition, newVerticalScrollPosition);
            
            var newHorizontalScrollPosition:int = indexToColumn(index);
            newHorizontalScrollPosition =
                Math.min(maxHorizontalScrollPosition, newHorizontalScrollPosition);
        
            // Prepare to refresh from there.
            var pos:int = scrollPositionToIndex(newHorizontalScrollPosition,
                                                newVerticalScrollPosition);
            try
            {
                iterator.seek(CursorBookmark.CURRENT, pos - index);
            }
            catch (e:ItemPendingError)
            {
                lastSeekPending = new ListBaseSeekPending(
                    CursorBookmark.CURRENT, pos - index)
                
                e.addResponder(new ItemResponder(
                    seekPendingResultHandler, seekPendingFailureHandler,
                    lastSeekPending));
                
                iteratorValid = false;
                return;
            }

            super.verticalScrollPosition = newVerticalScrollPosition;
            if (listType != "vertical")
                super.horizontalScrollPosition = newHorizontalScrollPosition;
        }
        else
        {
            try
            {
                iterator.seek(CursorBookmark.FIRST, verticalScrollPosition);
            }
            catch (e:ItemPendingError)
            {
                lastSeekPending = new ListBaseSeekPending(
                    CursorBookmark.FIRST, verticalScrollPosition);

                e.addResponder(new ItemResponder(
                    seekPendingResultHandler, seekPendingFailureHandler,
                    lastSeekPending));
                
                iteratorValid = false;
                return;
            }
        }

        // If there's more than one selection, find their new indices.
        if (i > 1)
            commitSelectedItems(selectedItems);
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Initiates a data change effect when there have been changes
     *  in the data provider.
     *
     *  @param unscaledWidth Specifies the width of the component, in pixels,
     *  in the component's coordinates, regardless of the value of the
     *  <code>scaleX</code> property of the component.
     *
     *  @param unscaledHeight Specifies the height of the component, in pixels,
     *  in the component's coordinates, regardless of the value of the
     *  <code>scaleY</code> property of the component.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function initiateDataChangeEffect(unscaledWidth:Number,
                                                unscaledHeight:Number):void
    {
        // as optimization, we might get targets from visibleData
        // if we know that nothing else has changed.
        // otherwise, rerender using our preserved collection view

        // store original collection and iterator so we can
        // return to using it after the effect has finished
        actualCollection = collection;
        actualIterator = iterator;

        // switch to a view of the collection before the data change
        // and call updateDisplayList()
        collection = modifiedCollectionView;
        modifiedCollectionView.showPreservedState = true;
        iterator = collection.createCursor();

        var index:int = scrollPositionToIndex(horizontalScrollPosition - offscreenExtraColumnsLeft, 
            verticalScrollPosition - offscreenExtraRowsTop);

        iterator.seek(CursorBookmark.FIRST,index);
        updateDisplayList(unscaledWidth,unscaledHeight);

        var targets:Array = [];
        var targetHash:Dictionary = new Dictionary(true);

        // record the initial set of targets for the
        // data change effect
        var n:int = listItems.length;
        var m:int = 0;
        for (var i:int = 0; i < n; i++)
        {
            var rowItems:Array = listItems[i];
            if (rowItems && (rowItems.length > 0))
            {
                m = rowItems.length;
                for (var j:int = 0; j < m; j++)
                {
                    var target:Object = rowItems[j];
                    if (target)
                    {
                        targets.push(target);
                        targetHash[target] = true;
                    }
                }
            }
        }
        
        
        cachedDataChangeEffect.targets = targets;
        if (cachedDataChangeEffect.effectTargetHost != this)
            cachedDataChangeEffect.effectTargetHost = this;
        cachedDataChangeEffect.captureStartValues();

        // Now get additional targets that are only in endstate
        modifiedCollectionView.showPreservedState = false;
            // This is not great from a usability point of view if all the items have
            // been added offscreen...we're scrolling the view as well.
            // Also, ideally we wouldn't have to do this seek; the iterator
            // would notice via events that the modifiedCollectionView had changed
        iterator.seek(CursorBookmark.FIRST,index);
        itemsSizeChanged = true;
        updateDisplayList(unscaledWidth,unscaledHeight);

        // Acquire additional targets
        var newTargets:Array = [];
        var oldTargets:Array = cachedDataChangeEffect.targets;
        
        n = listItems.length;
        for (i = 0; i < n; i++)
        {
            rowItems = listItems[i];
            if (rowItems && (rowItems.length > 0))
            {
                m = rowItems.length;
                for (j = 0; j < m; j++)
                {
                    target = rowItems[j];
                    if (target && !targetHash[target])
                    {
                        oldTargets.push(target);
                        newTargets.push(target);
                    }
                }
            }
        }

        // Get start values for additional targets,
        // and end values for all targets
        if (newTargets.length > 0)
        {
            cachedDataChangeEffect.targets = oldTargets;
            cachedDataChangeEffect.captureMoreStartValues(newTargets);
        }
        cachedDataChangeEffect.captureEndValues();

        // Do the layout for the control one more time, to ensure
        // that only the items visible before the data change
        // occurred are visible
        modifiedCollectionView.showPreservedState = true;
        iterator.seek(CursorBookmark.FIRST,index);          
        itemsSizeChanged = true;
        updateDisplayList(unscaledWidth,unscaledHeight);

        initiateSelectionTracking(oldTargets);
        // Start the data effect, which will rewind to start state
        cachedDataChangeEffect.addEventListener(EffectEvent.EFFECT_END,finishDataChangeEffect);
        cachedDataChangeEffect.play();
    } */

    /**
     *  @private
     *  Sets up listeners for MoveEvents for a set of renderers. Listeners are only
     *  created for renderers representing selected items.
     * 
     *  This functionality is used by data change effects, to update selections
     *  when the item renderers move.
     */ 
    /* private function initiateSelectionTracking(renderers:Array):void
    {
        var n:int = renderers.length;
        for (var i:int = 0; i < n; i++)
        {
            var renderer:IListItemRenderer = renderers[i] as IListItemRenderer;
            if (selectedData[itemToUID(renderer.data)])
            {
                renderer.addEventListener(mx.events.MoveEvent.MOVE,rendererMoveHandler);
                trackedRenderers.push(renderer);
            }
        }
    } */
    
    /**
     *  @private
     *  Removes event listeners for MoveEvents set up by initiateSelectionTracking().
     * 
     */ 
    /* private function terminateSelectionTracking():void
    {
        var n:int = trackedRenderers.length;
        for (var i:int = 0; i < n; i++)
        {
            var renderer:IListItemRenderer = trackedRenderers[i] as IListItemRenderer;
            renderer.removeEventListener(mx.events.MoveEvent.MOVE,rendererMoveHandler);
        }
        trackedRenderers = [];
    }
 */
    /**
     *  Removes an item renderer if a data change effect is running.
     *  The item renderer must correspond to data that has already
     *  been removed from the data provider collection.
     * 
     *  This function will be called by a <code>RemoveItemAction</code>
     *  effect as part of a data change effect to specify the point
     *  at which a data item ceases to displayed by the control using
     *  an item renderer.
     * 
     *  @param item The item renderer to remove from the control's layout.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  public function removeDataEffectItem(item:Object):void
    {
        // Shouldn't need to check this, but there
        // currently appears to be a race condition
        // (perhaps a bug in when effectEnd occurs)
        if (modifiedCollectionView)
            modifiedCollectionView.removeItem(dataItemWrappersByRenderer[item]);
        // again, this should not really be necessary
        iterator.seek(CursorBookmark.CURRENT);

        // force validation, otherwise it can be delayed until the
        // end of a data effect
        if (mx_internal::invalidateDisplayListFlag)
        {
            itemsSizeChanged = true;
            validateDisplayList();
        }
        else
            invalidateList();
    } */

    /**
     *  Adds an item renderer if a data change effect is running.
     *  The item renderer should correspond to a recently added
     *  data item in the data provider's collection that isn't
     *  yet being displayed.
     * 
     *  This function will be called by an <code>AddItemAction</code>
     *  effect as part of a data change effect to specify the point
     *  at which a data item added to a collection begins to be displayed
     *  by the control using an item renderer.
     * 
     *  @param item The item renderer to add to the control's layout.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function addDataEffectItem(item:Object):void
    {
        if (modifiedCollectionView)
            modifiedCollectionView.addItem(dataItemWrappersByRenderer[item]);

        // if it was previously empty, set cursor to first item
        // We shouldn't really have to do this here.
        if (iterator.afterLast)
            iterator.seek(CursorBookmark.FIRST)
        else
            iterator.seek(CursorBookmark.CURRENT);

        // force validation, otherwise it can be delayed until the
        // end of a data effect
        if (mx_internal::invalidateDisplayListFlag)
        {
            itemsSizeChanged = true;
            validateDisplayList();
        }
        else
        {
            invalidateList();
        }
    } */

    
    /**
     *  Temporarily stops an item renderer from being positioned
     *  by the control's layout algorithm.
     * 
     *  This function will be called 
     *  as part of a data change effect if the item renderers corresponding
     *  to certain data items need to move outside the normal positions
     *  of item renderers in the control.
     *
     *  @param item The data for the item renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  public function unconstrainRenderer(item:Object):void
    {
        unconstrainedRenderers[item] = true;
    } */

    /** 
     *  Returns the value for a particular semantic property of
     *  an item renderer, or null if that property is not defined,
     *  while a data effect is running.
     *
     *  This function is used by filters in data change effects 
     *  to restrict effects to renderers corresponding to removed 
     *  or added data items.
     * 
     *  @param target An item renderer.
     * 
     *  @param semanticProperty The semantic property of the renderer
     *  whose value will be returned.
     *
     *  @return The value for a particular semantic property of
     *  an item renderer, or null if that property is not defined,
     *  while a data effect is running.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function getRendererSemanticValue(target:Object,semanticProperty:String):Object
    {
        // this is really only a temporary solution, assuming single boolean semantics
        // e.g. "removed" or "added"
        return (modifiedCollectionView.getSemantics(dataItemWrappersByRenderer[target]) == semanticProperty);
    } */

    /**
     *  Returns <code>true</code> if an item renderer is no longer being positioned
     *  by the list's layout algorithm while a data change effect is
     *  running as a result of a call to the <code>unconstrainRenderer()</code> method.
     * 
     *  @param item An item renderer.
     * 
     *  @return <code>true</code> if an item renderer is no longer being positioned
     *  by the list's layout algorithm.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function isRendererUnconstrained(item:Object):Boolean
    {
        return (unconstrainedRenderers[item] != null);
    }
   */
    /**
     *  Cleans up after a data change effect has finished running
     *  by restoring the original collection and iterator and removing
     *  any cached values used by the effect. This method is called by
     *  the Flex framework; you do not need to call it from your code.
     * 
     *  @param event The effect that has finished running.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function finishDataChangeEffect(event:EffectEvent):void
    {
        // We are doing a bunch of stuff here, possibly more
        // than necessary, with the goal of guaranteeing that we leave
        // the control in an acceptable state.
        collection = actualCollection;
        actualCollection = null;
        modifiedCollectionView = null;
        iterator = actualIterator;
        runningDataEffect = false;

        unconstrainedRenderers = {};
        // rendererChanged = true;
        terminateSelectionTracking();

        // at the end of a data effect, in order to make sure we
        // can re-use the renderers intelligently, we have to
        // re-key the item renderers in visibleData
        var newVisibleData:Object = {};
        for each (var item:Object in visibleData)
            if (item.data)
                newVisibleData[itemToUID(item.data)] = item;
        visibleData = newVisibleData;
        
        // TODO This code seems redundant with the code in cleanupAfterDataChangeEffect();
        // need to investigate what's actually needed & where.
        var index:int = scrollPositionToIndex(horizontalScrollPosition - offscreenExtraColumnsLeft, verticalScrollPosition - offscreenExtraRowsTop);
        iterator.seek(CursorBookmark.FIRST,index);
        callLater(cleanupAfterDataChangeEffect);
    }
 */
    /**
     * @private
     * 
     *  Initiates a somewhat expensive relayout of the control after finishing up
     *  a data change effect.
     */
   /*  private function cleanupAfterDataChangeEffect():void
    {
        if (runningDataEffect || runDataEffectNextUpdate)
            return;
        var index:int = scrollPositionToIndex(horizontalScrollPosition - offscreenExtraColumnsLeft, verticalScrollPosition - offscreenExtraRowsTop);

        iterator.seek(CursorBookmark.FIRST,index);
        dataEffectCompleted = true;
        itemsSizeChanged = true;
        //rendererChanged = true;
        invalidateList();
        dataItemWrappersByRenderer = new Dictionary();
    } */

    /**
     *  Called from the <code>updateDisplayList()</code> method to 
     *  adjust the size and position of list content.
     *
     *  @param unscaledWidth Specifies the width of the component, in pixels,
     *  in the component's coordinates.
     *
     *  @param unscaledHeight Specifies the height of the component, in pixels,
     *  in the component's coordinates.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function adjustListContent(unscaledWidth:Number = -1,
                                       unscaledHeight:Number = -1):void
    {
        if (unscaledHeight < 0)
        {
            unscaledHeight = oldUnscaledHeight;
            unscaledWidth = oldUnscaledWidth
        }
        var lcx:Number = viewMetrics.left + listContent.leftOffset;
        var lcy:Number = viewMetrics.top + listContent.topOffset;
        listContent.move(lcx, lcy);
        var ww:Number = Math.max(0, listContent.rightOffset) - lcx - viewMetrics.right;
        var hh:Number = Math.max(0, listContent.bottomOffset) - lcy - viewMetrics.bottom;
        listContent.setActualSize(unscaledWidth + ww, unscaledHeight + hh);
    } */

    /**
     *  @private
     *  
     *  Called by updateDisplayList() to make adjustments to vertical and
     *  horizontal scroll position.
     */
   /*  private function adjustScrollPosition():void    
    {
        if (!isNaN(horizontalScrollPositionPending))
        {
            var hPos:Number = Math.min(horizontalScrollPositionPending,
                                       maxHorizontalScrollPosition);
            horizontalScrollPositionPending = NaN;
            super.horizontalScrollPosition = hPos;
        }

        if (!isNaN(verticalScrollPositionPending))
        {
            var vPos:Number = Math.min(verticalScrollPositionPending,
                                       maxVerticalScrollPosition);
            verticalScrollPositionPending = NaN;
            super.verticalScrollPosition = vPos;
        }
    } */

    /**
     *  @private
     *  
     *  Called by updateDisplayList() to remove existing item renderers
     *  and clean up various caching structures when renderer changes.
     */
   /*  protected function purgeItemRenderers():void
    {
        rendererChanged = false;
        while (listItems.length)
        {
            var row:Array = listItems.pop();
            while (row.length)
            {
                var item:IListItemRenderer = IListItemRenderer(row.pop());
                if (item)
                {
                    listContent.removeChild(DisplayObject(item));
                    if (dataItemWrappersByRenderer[item])
                        delete visibleData[itemToUID(dataItemWrappersByRenderer[item])];
                    else
                        delete visibleData[itemToUID(item.data)];
                    // addToFreeItemRenderers(item);
                }
            }
        }

        while (freeItemRenderers.length)
        {
            var freeRenderer:DisplayObject = DisplayObject(freeItemRenderers.pop());
            if (freeRenderer.parent)
                listContent.removeChild(freeRenderer);
        }

        rowMap = {};
        rowInfo = [];
    } */

    /**
     *  @private
     *  
     *  Called by updateDisplayList() to remove existing item renderers
     *  and clean up various internal structures at the end of running
     *  a data change effect.
     */
   /*  private function partialPurgeItemRenderers():void
    {
        dataEffectCompleted = false;

        // We make sure all free and reserved itemRenderers are de-parented
        // after a data change effect finishes, and also blow away visibleData 
        // and rowMap. Ideally, this would not be necessary, but it seems
        // safest at the moment.
        
        // Note that the makeRowsAndColumns pass after this function is
        // called should not make any changes to listItems.
        
        while (freeItemRenderers.length)
        {
            var freeRenderer:DisplayObject = DisplayObject(freeItemRenderers.pop());
            if (freeRenderer.parent)
                listContent.removeChild(freeRenderer);
        }

        for (var p:String in reservedItemRenderers)
        {
            freeRenderer = DisplayObject(reservedItemRenderers[p]);
            if (freeRenderer.parent)
                listContent.removeChild(freeRenderer);
        }
        reservedItemRenderers = {}

        rowMap = {};
        visibleData = {};
    } */

    /**
     *  @private
     *  
     *  Called by updateDisplayList()
     */
    /* private function reduceRows(rowIndex:int):void
    {
        while (rowIndex >= 0)
        {
            if (rowInfo[rowIndex].y >= listContent.height)
            {
                var colLen:int = listItems[rowIndex].length;
                for (var j:int = 0; j < colLen; j++)
                    addToFreeItemRenderers(listItems[rowIndex][j]);
                var uid:String = rowInfo[rowIndex].uid;

                delete visibleData[uid];
                removeIndicators(uid);

                listItems.pop();    // remove the row
                rowInfo.pop();
                rowIndex--;
            }
            else
                break;
        }
    } */

    /**
     *  @private
     * 
     *  Called from updateDisplayList()
     */
   /*  private function makeAdditionalRows(rowIndex:int):void
    {
        var cursorPos:CursorBookmark;

        // do layout for additional rows
        if (iterator)
        {
            cursorPos = iterator.bookmark;
            try
            {
                iterator.seek(CursorBookmark.CURRENT, listItems.length - lockedRowCount);
            }
            catch (e:ItemPendingError)
            {
                lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT, listItems.length - lockedRowCount)
                e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler,
                                                lastSeekPending));
                // trace("IPE in UpdateDisplayList");
                iteratorValid = false;
                // don't do anything, we'll repaint when the data arrives
            }
        }
        var curY:Number = rowInfo[rowIndex].y + rowInfo[rowIndex].height;
        // fill it in
        makeRowsAndColumns(0, curY, listContent.width, listContent.height, 0, rowIndex + 1);
        // restore iterator to original position
        seekPositionIgnoreError(iterator,cursorPos);
    }
 */
    /**
     *  @private
     * 
     *  Called from updateDisplayList() to make adjustments to internal
     *  properties representing selections.
     */
   /*  private function adjustSelectionSettings(collectionHasItems:Boolean):void
    {
        if (bSelectionChanged)
        {
            bSelectionChanged = false;

            // bSelectedIndexChanged can be true if the dp was reset.
            // if selectedItem or cousins are also set, we will resolve
            // selectedIndex in there and therefore don't need to process
            // it

            //in each of these cases allow the "unsetting" of a value regardless
            //of whether the collection has items

            if (bSelectedIndicesChanged
                && (collectionHasItems || (_selectedIndices == null)))
            {
                bSelectedIndicesChanged = false;
                bSelectedIndexChanged = false;
                commitSelectedIndices(_selectedIndices);
            }

            if (bSelectedItemChanged
                && (collectionHasItems || (_selectedItem == null)))
            {
                bSelectedItemChanged = false;
                bSelectedIndexChanged = false;
                commitSelectedItem(_selectedItem);
            }

            if (bSelectedItemsChanged
                && (collectionHasItems || (_selectedItems == null)))
            {
                bSelectedItemsChanged = false;
                bSelectedIndexChanged = false;
                commitSelectedItems(_selectedItems);
            }

            if (bSelectedIndexChanged
                && (collectionHasItems || (_selectedIndex == -1)))
            {
                commitSelectedIndex(_selectedIndex);
                bSelectedIndexChanged = false;
            }

        }
    }   */

    /**
     *  @private
     *  
     *  Called from updateDisplayList() to seek to a cursorPosition while ignoring any errors
     */
   /*  private function seekPositionIgnoreError(iterator:IViewCursor, cursorPos:CursorBookmark):void
    {
        if (iterator)
        {
            try
            {
                iterator.seek(cursorPos, 0);
            }
            catch (e:ItemPendingError)
            {
                // we don't recover here since we'd only get here if the first seek failed.
            }
        }
    } */
    
    /**
     *  @private
     * 
     *  A convenience function to move the iterator to the next position and handle
     *  errors if necessary. 
     */
    /* private function seekNextSafely(iterator:IViewCursor, pos:int):Boolean
    {
        try
        {
            iterator.moveNext();
        }
        catch (e:ItemPendingError)
        {
            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, pos)
            e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler,
                                                lastSeekPending));
            iteratorValid = false;
        }
        // assumption is that iteratorValid was true when we were called.
        return iteratorValid;
    } */

    /* private function seekPreviousSafely(iterator:IViewCursor, pos:int):Boolean
    {
        try
        {
            iterator.movePrevious();
        }
        catch (e:ItemPendingError)
        {
            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, pos)
            e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler,
                                                lastSeekPending));
            iteratorValid = false;
        }
        // assumption is that iteratorValid was true when we were called.
        return iteratorValid;
    } */
    
    // TODO make this mx_internal?
    /**
     *  @private
     */
   /*  protected function seekPositionSafely(index:int):Boolean
    {
        try
        {
            iterator.seek(CursorBookmark.FIRST, index);
        }
        catch (e:ItemPendingError)
        {
            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, index);
            e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler, 
                                            lastSeekPending));
            iteratorValid = false;
        }
        return iteratorValid;
    } */
    
    /**
     *  @private
     *  for automation delegate access
     */
   /*  mx_internal function getListVisibleData():Object
    {
        return visibleData;
    } */
    
    /**
     *  @private
     *  for automation delegate access
     */
    /* mx_internal function getItemUID(data:Object):String
    {
        return itemToUID(data);
    }
     */
    /**
     *  @private
     *  for automation delegate access
     */
    /* mx_internal function getItemRendererForMouseEvent(event:MouseEvent):IListItemRenderer
    {
        return mouseEventToItemRenderer(event);
    } */

    /**
     *  @private
     *  for automation delegate access
     */
   /*  mx_internal function getListContentHolder():AdvancedListBaseContentHolder
    {
        return listContent;
    } */
    
    /**
     *  @private
     *  for automation delegate access
     */
   /*  mx_internal function getRowInfo():Array
    {
        return rowInfo;
    } */
    
    /**
     *  @private
     *  for automation delegate access
     */
   /*  mx_internal function convertIndexToRow(index:int):int
    {
        return indexToRow(index);
    }
     */
    /**
     *  @private
     *  for automation delegate access
     */
    /* mx_internal function convertIndexToColumn(index:int):int
    {
        return indexToColumn(index);
    } */

    /**
     *  @private
     *  for automation delegate access
     */
    /* mx_internal function getCaretIndex():int
    {
        return caretIndex;
    } */

    /**
     *  @private
     *  for automation delegate access
     */
    /* mx_internal function getIterator():IViewCursor
    {
        return iterator;
    } */
    
    /**
     *  @private
     *  Move the indicators up or down by the given offset. 
     *  This method assumes that all the selection indicators in 
     *  this row are at the same 'y' position.
     */
    /* protected function moveIndicators(uid:String, offset:int, absolute:Boolean):void
    {
        if (selectionIndicators[uid])
        {
            if (absolute)
                selectionIndicators[uid].y = offset;
            else
                selectionIndicators[uid].y += offset;
        }

        if (highlightUID == uid)
        {
            if (absolute)
                highlightIndicator.y = offset;
            else
                highlightIndicator.y += offset;
        }

        if (caretUID == uid)
        {
            if (absolute)
                caretIndicator.y = offset;
            else
                caretIndicator.y += offset;
        }
    } */
    
    /**
     *  Internal version of setting columnWidth
     *  without invalidation or notification.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  mx_internal function setColumnWidth(value:Number):void
    {
        _columnWidth = value;
    }
     */
    /**
     *  Sets the <code>rowCount</code> property without causing
     *  invalidation or setting the <code>explicitRowCount</code>
     *  property, which permanently locks in the number of rows.
     *
     *  @param v The row count.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function setRowCount(v:int):void
    {
        //trace("setRowCount " + v);
        _rowCount = v;
    } */
    
    /**
     *  Sets the <code>rowHeight</code> property without causing invalidation or 
     *  setting of <code>explicitRowHeight</code> which
     *  permanently locks in the height of the rows.
     *
     *  @param v The row height, in pixels.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function setRowHeight(v:Number):void
    {
        _rowHeight = v;
    } */

    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers: UIComponent
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    /* override protected function keyDownHandler(event:KeyboardEvent):void
    {
        if (!selectable)
            return;

        if (!iteratorValid)
            return;

        if (!collection)
            return;

        switch (event.keyCode)
        {
            case Keyboard.UP:
            case Keyboard.DOWN:
            {
                moveSelectionVertically(
                    event.keyCode, event.shiftKey, event.ctrlKey);
                event.stopPropagation();
                break;
            }

            case Keyboard.LEFT:
            case Keyboard.RIGHT:
            {
                moveSelectionHorizontally(
                    event.keyCode, event.shiftKey, event.ctrlKey);
                event.stopPropagation();
                break;
            }

            case Keyboard.END:
            case Keyboard.HOME:
            case Keyboard.PAGE_UP:
            case Keyboard.PAGE_DOWN:
            {
                moveSelectionVertically(
                    event.keyCode, event.shiftKey, event.ctrlKey);
                event.stopPropagation();
                break;
            }

            case Keyboard.SPACE:
            {
                if (caretIndex != -1 && ((caretIndex - verticalScrollPosition + lockedRowCount) >= 0) &&
                    ((caretIndex - verticalScrollPosition + lockedRowCount) < listItems.length))
                {
                    var li:IListItemRenderer =
                        listItems[caretIndex - verticalScrollPosition + lockedRowCount][0];
                    if (selectItem(li, event.shiftKey, event.ctrlKey))
                    {
                        var pt:Point = itemRendererToIndices(li);
                        var evt:ListEvent = new ListEvent(ListEvent.CHANGE);
                        if (pt)
                        {
                            evt.columnIndex = pt.x;
                            evt.rowIndex = pt.y;
                        }
                        evt.itemRenderer = li;
                        dispatchEvent(evt);
                    }
                }
                break;
            }

            default:
            {
                if (findKey(event.charCode))
                    event.stopPropagation();
            }
        }
    } */

    /**
     *  Handles <code>mouseWheel</code> events by changing scroll positions.
     *  This is a copy of the version in the ScrollControlBase class,
     *  modified to change the <code>horizontalScrollPosition</code> property
     *  if the target is run horizontally.
     *
     *  @param event The MouseEvent object.
     *
     *  @see mx.core.ScrollControlBase#mouseWheelHandler()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  override protected function mouseWheelHandler(event:MouseEvent):void
    {
        if (verticalScrollBar && verticalScrollBar.visible)
        {
            event.stopPropagation();
            var oldPosition:Number = verticalScrollPosition;
            var newPos:int = verticalScrollPosition;
            newPos -= event.delta * verticalScrollBar.lineScrollSize;
            newPos = Math.max(0, Math.min(newPos, verticalScrollBar.maxScrollPosition));
            verticalScrollPosition = newPos;

            if (oldPosition != verticalScrollPosition)
            {
                var scrollEvent:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
                scrollEvent.direction = ScrollEventDirection.VERTICAL;
                scrollEvent.position = verticalScrollPosition;
                scrollEvent.delta = verticalScrollPosition - oldPosition;
                dispatchEvent(scrollEvent);
            }
        }
    }
 */
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  Handles CollectionEvents dispatched from the data provider
     *  as the data changes.
     *  Updates the renderers, selected indices and scrollbars as needed.
     *
     *  @param event The CollectionEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected function collectionChangeHandler(event:Event):void
    {
        var len:int;
        var i:int;
        var n:int;
        var data:ListBaseSelectionData;
        var p:String;
        var selectedUID:String;

        if (event is CollectionEvent)
        {
            var ce:CollectionEvent = CollectionEvent(event);

            // trace("ListBase collectionEvent", ce.kind);
            if (ce.kind == CollectionEventKind.ADD)
            {
                //prepareDataEffect(ce);                        
                // trace("ListBase collectionEvent ADD", ce.location, verticalScrollPosition);
                // special case when we have less than a screen full of stuff
				/*
                if (ce.location == 0 && verticalScrollPosition == 0)
                {
                    try
                    {
                        // trace("ListBase collectionEvent ADD adjust");
                        iterator.seek(CursorBookmark.FIRST);
                    }
                    catch (e:ItemPendingError)
                    {
                        // trace("IPE in ADD event");
                        lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, 0)
                        e.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler,
                                                            lastSeekPending));
                        iteratorValid = false;
                        // do nothing, we'll repaint when the data arrives
                    }
                }
                else if (listType == "vertical" && verticalScrollPosition >= ce.location)
                {
                    super.verticalScrollPosition = super.verticalScrollPosition + ce.items.length;
                }*/

                len = ce.items.length;
                for (p in selectedData)
                {
                    data = selectedData[p];
                    if (data.index > ce.location)
                        data.index += len;
                }
                /* model will handle this
                if (_selectedIndex >= ce.location)
                {
                    _selectedIndex += len;
                    dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                }*/
            }
			/*
            else if (ce.kind == CollectionEventKind.REPLACE)
            {
                // trace("ListBase collectionEvent REPLACE");
                selectedUID = selectedItem ? itemToUID(selectedItem) : null;
                n = ce.items.length;
                for (i = 0; i < n; i++)
                {
                    var oldUID:String = itemToUID(ce.items[i].oldValue);
                    var sd:ListBaseSelectionData = selectedData[oldUID];
                    if (sd)
                    {
                        sd.data = ce.items[i].newValue;
                        delete selectedData[oldUID];
                        selectedData[itemToUID(sd.data)] = sd;
                    
                        if (selectedUID == oldUID)
                        {
                            _selectedItem = sd.data;
                            dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                        }
                    }
                }

                prepareDataEffect(ce);                        
            }*/

            else if (ce.kind == CollectionEventKind.REMOVE)
            {
                //prepareDataEffect(ce);                        
                var requiresValueCommit:Boolean = false;
    
                // trace("ListBase collectionEvent REMOVE", ce.location, verticalScrollPosition);
                // make sure we've generated rows for the actual data
                // at startup time we might just have blank rows
				/*
                if (listItems.length && listItems[lockedRowCount].length)
                {
                    // special case when we have less than a screen full of stuff
                    var firstUID:String = rowMap[listItems[lockedRowCount][0].name].uid;
                    selectedUID = selectedItem ? itemToUID(selectedItem) : null;
					*/
                    n = ce.items.length;
                    for (i = 0; i < n; i++)
                    {
                        var uid:String = itemToUID(ce.items[i]);
                        
						/*
                        if (uid == firstUID && verticalScrollPosition == 0)
                        {
                            try
                            {
                                iterator.seek(CursorBookmark.FIRST);
                            }
                            catch (e1:ItemPendingError)
                            {
                                // trace("IPE in REMOVE event");
                                lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, 0)
                                e1.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler,
                                                                    lastSeekPending));
                                iteratorValid = false;
                                // do nothing, we'll repaint when the data arrives
                            }
                        }*/
                        
                        if (selectedData[uid])
                            removeSelectionData(uid);
                        
						/* model should take care of this
                        if (selectedUID == uid)
                        {
                            _selectedItem = null;
                            _selectedIndex = -1;
                            requiresValueCommit = true;
                        }*/

                        //removeIndicators(uid);
                    }
					/*
                    // Decrement verticalScrollPosition by the number of items that have
                    // been removed from the top.
                    if (listType == "vertical" && verticalScrollPosition >= ce.location)
                    {
                        if (verticalScrollPosition > ce.location)
                        {
                            super.verticalScrollPosition = verticalScrollPosition -
                                Math.min(ce.items.length,
                                verticalScrollPosition - ce.location);
                        }
                        else
                        {
                            // else the underlying collection goes to invalid cuz we removed the current
                            // so we force a re-seek next, but we want to keep everything in range
                            if (verticalScrollPosition >= collection.length)
                                super.verticalScrollPosition = Math.max(collection.length - 1, 0);
                        }

                        try
                        {
                            offscreenExtraRowsTop = Math.min(offscreenExtraRowsTop, verticalScrollPosition);
                            iterator.seek(CursorBookmark.FIRST, verticalScrollPosition - offscreenExtraRowsTop);
                        }
                        catch (e2:ItemPendingError)
                        {
                            // trace("IPE in Remove 2");
                            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, verticalScrollPosition - offscreenExtraRowsTop)
                            e2.addResponder(new ItemResponder(seekPendingResultHandler, seekPendingFailureHandler,
                                                                lastSeekPending));
                            iteratorValid = false;
                            // do nothing, we'll repaint when the data arrives
                         }
                    }
					*/
                    var emitEvent:Boolean = adjustAfterRemove(ce.items, ce.location, requiresValueCommit);
                    if (emitEvent)
                        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                /*}*/
            }
			/*
            else if (ce.kind == CollectionEventKind.MOVE)
            {
                if (ce.oldLocation < ce.location)
                {
                    for (p in selectedData)
                    {
                        data = selectedData[p];
                        if (data.index > ce.oldLocation &&
                            data.index < ce.location)
                            data.index --;

                        else if (data.index == ce.oldLocation)
                            data.index = ce.location;
                    }
                    if (_selectedIndex > ce.oldLocation &&
                        _selectedIndex < ce.location)
                        _selectedIndex --;
                    else if (_selectedIndex == ce.oldLocation)
                        _selectedIndex = ce.location;
                }
                else if (ce.location < ce.oldLocation)
                {
                    for (p in selectedData)
                    {
                        data = selectedData[p];
                        if (data.index > ce.location &&
                            data.index < ce.oldLocation)
                            data.index ++;

                        else if (data.index == ce.oldLocation)
                            data.index = ce.location;
                    }
                    if (_selectedIndex > ce.location &&
                        _selectedIndex < ce.oldLocation)
                        _selectedIndex ++;
                    else if (_selectedIndex == ce.oldLocation)
                        _selectedIndex = ce.location;
                }

                // if the current item got moved
                if (ce.oldLocation == verticalScrollPosition)
                {
                    // iterator is at new position, jump to it,
                    // but make sure we don't max out first
                    if (ce.location > maxVerticalScrollPosition)
                    {
                        iterator.seek(CursorBookmark.CURRENT, maxVerticalScrollPosition - ce.location);
                    }
                    super.verticalScrollPosition = Math.min(ce.location, maxVerticalScrollPosition);
                }
                // if the old location and new location are on
                // different sides of the scrollposition
                else if ((ce.location >= verticalScrollPosition) && 
                     (ce.oldLocation < verticalScrollPosition))
                    seekNextSafely(iterator,verticalScrollPosition);
                else if ((ce.location <= verticalScrollPosition) && 
                         (ce.oldLocation > verticalScrollPosition))
                    seekPreviousSafely(iterator,verticalScrollPosition);
            }*/

            else if (ce.kind == CollectionEventKind.REFRESH)
            {
                /*
                if (anchorBookmark)
                {
                    try
                    {
                        iterator.seek(anchorBookmark, 0);
                    }
                    catch (e:ItemPendingError)
                    {
                        bSortItemPending = true;

                        lastSeekPending = new ListBaseSeekPending(anchorBookmark, 0);
                        e.addResponder(new ItemResponder(
                            seekPendingResultHandler, seekPendingFailureHandler,
                            lastSeekPending));

                        // trace("IPE in UpdateDisplayList");
                        iteratorValid = false;
                    }
                    catch (cursorError:CursorError)
                    {
                        // might have been filtered out so
                        // clear selections
                        clearSelected();
                    }
                    adjustAfterSort();
                }
                else
                {
                    try
                    {
                        iterator.seek(CursorBookmark.FIRST,
                                      verticalScrollPosition);
                */
                //update the selectedIndices after the sort
                var items:Array = copySelectedItems(true);
                commitSelectedItems(items);

                        // re-dispatch off strand so DataGridView can pick it up
                        dispatchEvent(event);
                        /*
                    }
                    catch (e:ItemPendingError)
                    {
                        bSortItemPending = true;

                        lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST, verticalScrollPosition)
                        e.addResponder(new ItemResponder(
                            seekPendingResultHandler, seekPendingFailureHandler,
                            lastSeekPending));

                        // trace("IPE in UpdateDisplayList");
                        iteratorValid = false;
                    }
                }*/
            }

            else if (ce.kind == CollectionEventKind.RESET)
            {
                /*
                // RemoveAll() on ArrayCollection currently triggers a reset
                // Special handling for this case.
                if ((collection.length == 0) || (runningDataEffect && actualCollection.length == 0))
                {
                    // All the data is already gone, so in order to run a data
                    // effect, we reconstruct it from the renderers
                    var deletedItems:Array = reconstructDataFromListItems();
                    if (deletedItems.length)
                    {
                        var fakeRemove:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                        fakeRemove.kind = CollectionEventKind.REMOVE;
                        fakeRemove.items = deletedItems;
                        fakeRemove.location = 0;
                        prepareDataEffect(fakeRemove);
                    }
                }

                try
                {
                    iterator.seek(CursorBookmark.FIRST);
                    collectionIterator.seek(CursorBookmark.FIRST);
                */
                    // re-dispatch off strand so DataGridView can pick it up
                    dispatchEvent(event);
                    /*
                }
                catch (e:ItemPendingError)
                {
                    lastSeekPending =
                        new ListBaseSeekPending(CursorBookmark.FIRST, 0);
                    
                    e.addResponder(new ItemResponder(
                        seekPendingResultHandler, seekPendingFailureHandler,
                        lastSeekPending));

                    iteratorValid = false;
                }
                
                if (bSelectedIndexChanged || bSelectedItemChanged ||
                    bSelectedIndicesChanged || bSelectedItemsChanged)
                {
                    bSelectionChanged = true;
                }
                else
                {
                    commitSelectedIndex(-1);
                }
                
                if (isNaN(verticalScrollPositionPending))
                {
                    verticalScrollPositionPending = 0;
                    super.verticalScrollPosition = 0;
                }
                
                if (isNaN(horizontalScrollPositionPending))
                {
                    horizontalScrollPositionPending = 0;
                    super.horizontalScrollPosition = 0;
                }
                
                invalidateSize();  
                    */
            }
                    
        }

        //itemsSizeChanged = true;

        //invalidateDisplayList();
    }
    
    /**
     *  @private
     *  Reconstructs an array of items for a pseudo-data provider. Used to
     *  leverage the data effects infrastructure after removeAll() has been
     *  called on the data provider.
     * 
     *  Subclasses may need to override this function, e.g. for TileLists
     *  with vertical layout.
     */
   /*  mx_internal function reconstructDataFromListItems():Array
    {
        if (!listItems)
            return [];
        var items:Array = [];
        
        // might make sense to ignore offscreen rows here
        var n:int = listItems.length;
        for (var i:int = 0; i < n; i++)
        {
            if (listItems[i])
            {
                var renderer:IListItemRenderer = listItems[i][0] as IListItemRenderer;
                var data:Object;
                var data2:Object;
                if (renderer)
                {
                    data = renderer.data;
                    items.push(data);
                    var m:int = listItems[i].length;
                    for (var j:int = 0; j < m; j++)
                    {
                        renderer = listItems[i][j] as IListItemRenderer;
                        if (renderer)
                        {
                            data2 = renderer.data;
                            if (data2 != data)
                                items.push(data2);
                        }
                    }
                }
            }
        }
        return items;
    } */
    
    /**
     *  @private
     */
   /*  protected function prepareDataEffect(ce:CollectionEvent):void
    {           
        if (!cachedDataChangeEffect)
        {
            // Style can set dataChangeEffect to an Effect object
            // or a Class which is a subclass of Effect
            var dce:Object = getStyle("dataChangeEffect");
            var dceClass:Class = dce as Class;
            if (dceClass)
                dce = new dceClass();
            cachedDataChangeEffect = dce as Effect;
        }

        if (runningDataEffect)
        {
            collection = actualCollection;
            iterator = actualIterator;
            cachedDataChangeEffect.end();
            modifiedCollectionView  = null;
        }   
    
        // For now, if iterator is not valid, don't run the data effect.
        if (cachedDataChangeEffect && iteratorValid)
        {
            var firstItemIndex:int = iterator.bookmark.getViewIndex();
            var lastItemIndex:int = firstItemIndex + (rowCount * columnCount) - 1;
            if (!modifiedCollectionView && (collection is IList))
                modifiedCollectionView = new ModifiedCollectionView(ICollectionView(collection));
            if (modifiedCollectionView)
            {
                modifiedCollectionView.processCollectionEvent(ce, firstItemIndex, lastItemIndex);
                runDataEffectNextUpdate = true;
                
                if (mx_internal::invalidateDisplayListFlag)
                    callLater(invalidateList);
                else
                    invalidateList();
           }
        }
    } */

    /**
     *  @private
     */
    protected function adjustAfterRemove(items:Array, location:int, emitEvent:Boolean):Boolean
    {
        var data:ListBaseSelectionData;
        var requiresValueCommit:Boolean = emitEvent;
        var i:int = 0;
        var length:int = items.length;
        for (var p:String in selectedData)
        {
            i++;
            data = selectedData[p];
            if (data.index > location)
                data.index -= length;
        }

		/* model should handle this on it sown
        if (_selectedIndex > location)
        {
            _selectedIndex -= length;
            requiresValueCommit = true;
        }*/
        
        // selected the last thing if the selected item
        // got removed.
        if (i > 0 && /*_*/selectedIndex == -1)
        {
            /*_*/selectedIndex = data.index;
            /*_selectedItem = data.data;*/
            requiresValueCommit = true;
        }

		/* model should handle this on it sown
        if (i == 0)
        {
            _selectedIndex = -1;
            bSelectionChanged = true;
            bSelectedIndexChanged = true;
            invalidateDisplayList();
        }*/
        
        return requiresValueCommit;
    }

    /**
     *  Handles <code>MouseEvent.MOUSE_OVER</code> events from any mouse
     *  targets contained in the list, including the renderers.
     *  This method finds out which renderer the mouse is over
     *  and shows it as highlighted.
     *
     *  <p>The list classes also call this from a 
     *  <code>MouseEvent.MOUSE_MOVE</code> event.
     *  This event is used to detect movement in non-target areas of the
     *  renderers and in padded areas around the renderers.</p>
     *
     *  @param event The MouseEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function mouseOverHandler(event:MouseEvent):void
    {
        var evt:ListEvent;
        
        if (!enabled || !selectable)
            return;

        if (dragScrollingInterval != 0 && !event.buttonDown)
        {
            // trace("mouseOver found mouse not pressed but dragInterval");
            mouseIsUp();
        }

        isPressed = event.buttonDown;

        var item:IListItemRenderer = mouseEventToItemRenderer(event);
        var pt:Point = itemRendererToIndices(item);
        
        if (!item)
            return;

        var uid:String = itemToUID(item.data);

        if (!isPressed || allowDragSelection)
        {
            // we're rolling onto different subpieces of ourself or our highlight indicator
            if (event.relatedObject)
            {
                var lastUID:String;
                if (lastHighlightItemRenderer && highlightUID)
                {
                    var rowData:BaseListData = rowMap[item.name];
                    lastUID = rowData.uid;
                }
                if (itemRendererContains(item, event.relatedObject) ||
                    uid == lastUID ||
                    event.relatedObject == highlightIndicator)
                        return;
            }       

            if (getStyle("useRollOver") && (item.data != null))
            {
                if (allowDragSelection)
                    bSelectOnRelease = true;
                
                drawItem(visibleData[uid], isItemSelected(item.data), true, uid == caretUID);
                if (pt) // during tweens, we may get null
                {
                    evt = new ListEvent(ListEvent.ITEM_ROLL_OVER);
                    evt.columnIndex = pt.x;
                    evt.rowIndex = pt.y;
                    evt.itemRenderer = item;
                    dispatchEvent(evt);
                    lastHighlightItemIndices = pt;
                    lastHighlightItemRendererAtIndices = item;
                }
            }
        }
        else
        {
            if (DragManager.isDragging)
                return;
            
            if ((dragScrollingInterval != 0 && allowDragSelection) || menuSelectionMode)
            {
                if (selectItem(item, event.shiftKey, event.ctrlKey))
                {
                    evt = new ListEvent(ListEvent.CHANGE);
                    evt.itemRenderer = item;
                    if (pt)
                    {
                        evt.columnIndex = pt.x;
                        evt.rowIndex = pt.y;
                    }
                    dispatchEvent(evt);
                }
            }
        }
    } */

    /**
     *  Handles <code>MouseEvent.MOUSE_OUT</code> events from any mouse targets
     *  contained in the list including the renderers.  This method
     *  finds out which renderer the mouse has left
     *  and removes the highlights.
     *
     *  @param event The MouseEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function mouseOutHandler(event:MouseEvent):void
    {
        if (!enabled || !selectable)
            return;

        isPressed = event.buttonDown;

        var item:IListItemRenderer = mouseEventToItemRenderer(event);
        if (!item)
            return;

        if (!isPressed)
        {
            // either we're rolling onto different subpieces of ourself or our 
            // highlight indicator, or the clearing of the highlighted item has 
            // already happened care of the mouseMove handler
            if (itemRendererContains(item, event.relatedObject) || 
                event.relatedObject == listContent || 
                event.relatedObject == highlightIndicator || 
                !highlightItemRenderer)
                return;

            if (getStyle("useRollOver") && item.data != null)
                clearHighlight(item);
        }
    } */

    /**
     *  Handles <code>MouseEvent.MOUSE_MOVE</code> events from any mouse
     *  targets contained in the list including the renderers.  This method
     *  watches for a gesture that constitutes the beginning of a
     *  drag drop and send a <code>DragEvent.DRAG_START</code> event.
     *  It also checks to see if the mouse is over a non-target area of a
     *  renderer so that Flex can try to make it look like that renderer was 
     *  the target.
     *
     *  @param event The MouseEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function mouseMoveHandler(event:MouseEvent):void
    {
        if (!enabled || !selectable)
            return;

        var pt:Point = new Point(event.localX, event.localY);
        pt = DisplayObject(event.target).localToGlobal(pt);
        pt = globalToLocal(pt);


        if (isPressed && mouseDownPoint &&
            (Math.abs(mouseDownPoint.x - pt.x) > DRAG_THRESHOLD ||
             Math.abs(mouseDownPoint.y - pt.y) > DRAG_THRESHOLD))
        {
            if (dragEnabled && !DragManager.isDragging && mouseDownPoint)
            {
                var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_START);
                dragEvent.dragInitiator = this;
                dragEvent.localX = mouseDownPoint.x;
                dragEvent.localY = mouseDownPoint.y;
                dragEvent.buttonDown = true;
                dispatchEvent(dragEvent);
            }
        }

        // we used to put shields into each of the renderers so leftover space was hittable
        // but that's makes too many shields at startup and scrolling.  The gamble is that we
        // can run the code even on a large grid very quickly compared to mouse move intervals.
        var item:IListItemRenderer = mouseEventToItemRenderer(event);
        if (item && highlightItemRenderer)
        {
            var rowData:BaseListData = rowMap[item.name];
            if (highlightItemRenderer && highlightUID && rowData.uid != highlightUID)
            {
                if (!isPressed)
                {
                    if (getStyle("useRollOver") && highlightItemRenderer.data != null)
                    {
                        clearHighlight(highlightItemRenderer)
                    }
                }
            }
        }
        else if (!item && highlightItemRenderer)
        {
            if (!isPressed)
            {
                if (getStyle("useRollOver") && highlightItemRenderer.data)
                {
                    clearHighlight(highlightItemRenderer)
                }
            }
        }

        if (item && !highlightItemRenderer)
        {
            mouseOverHandler(event);
        }
    } */

    /**
     *  Handles <code>MouseEvent.MOUSE_DOWN</code> events from any mouse
     *  targets contained in the list including the renderers.  This method
     *  finds the renderer that was pressed and prepares to receive
     *  a <code>MouseEvent.MOUSE_UP</code> event.
     *
     *  @param event The MouseEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected function mouseDownHandler(event:MouseEvent):void
    {
        if (!enabled || !selectable)
            return;

        //if it was a click elsewhere (e.g. on the header, then ignore it
        var listArea:DataGridListArea = IDataGridView(this.view).listArea as DataGridListArea;
        if (listArea && !listArea.contains(event.target as DisplayObject)) {
            return;
        }
        // trace("mouseDown");
        isPressed = true;

        var item:IIndexedItemRenderer = mouseEventToItemRenderer(event) as IIndexedItemRenderer;
        if (!item)
            return;
        
        bSelectOnRelease = false;

        /*
        var pt:Point = new Point(event.localX, event.localY);
        pt = DisplayObject(event.target).localToGlobal(pt);
        mouseDownPoint = globalToLocal(pt);*/

        systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true/*, 0, true);
        systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseLeaveHandler, false, 0, true*/);

        /*
        if (!dragEnabled)
        {
            dragScrollingInterval = setInterval(dragScroll, 15);
        }
		
		if (dragEnabled)
			mouseDownIndex = itemRendererToIndex(item);

        // If dragEnabled is true, clicks on selected contents should cause
        // a selection change on mouse up instead of mouse down. Otherwise,
        // clicking in a selection to drag will deselect any multiple selection
        // before the drag occurs.
        if (dragEnabled && selectedData[rowMap[item.name].uid])
        {
            bSelectOnRelease = true;
        }
        else
        {*/
            if (selectItem(item.data, item.index, event.shiftKey, event.ctrlKey))
                mouseDownItem = item;
        /*}*/
    }

    private function mouseIsUp():void
    {
        systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, true);
        /*systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, mouseLeaveHandler);

        if (!dragEnabled && dragScrollingInterval != 0)
        {
            clearInterval(dragScrollingInterval);
            dragScrollingInterval = 0;
        }*/
    }

    /* private function mouseLeaveHandler(event:Event):void
    {
		mouseDownPoint = null;
		mouseDownIndex = -1;
		
        mouseIsUp();
		
		if (!enabled || !selectable)
			return;
		
		if (mouseDownItem)
		{
			var evt:ListEvent = new ListEvent(ListEvent.CHANGE);
			evt.itemRenderer = mouseDownItem;
			var pt:Point = itemRendererToIndices(mouseDownItem);
			if (pt)
			{
				evt.columnIndex = pt.x;
				evt.rowIndex = pt.y;
			}
			dispatchEvent(evt);
			mouseDownItem = null;
		}
		
        isPressed = false;
    } */

    /**
     *  Handles <code>MouseEvent.MOUSE_DOWN</code> events from any mouse
     *  targets contained in the list including the renderers.  This method
     *  finds the renderer that was pressed and prepares to receive
     *  a <code>MouseEvent.MOUSE_UP</code> event.
     *
     *  @param event The MouseEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    protected function mouseUpHandler(event:MouseEvent):void
    {
        //mouseDownPoint = null;
		//mouseDownIndex = -1;
        //trace("mouseUp");
        var item:IIndexedItemRenderer = mouseEventToItemRenderer(event) as IIndexedItemRenderer;
        //var pt:Point = itemRendererToIndices(item);
        var evt:ListEvent;

        mouseIsUp();

        if (!enabled || !selectable)
            return;

        if (mouseDownItem)
        {
            /*
            evt = new ListEvent(ListEvent.CHANGE);
            evt.itemRenderer = mouseDownItem;
            pt = itemRendererToIndices(mouseDownItem);
            if (pt)
            {
                evt.columnIndex = pt.x;
                evt.rowIndex = pt.y;
            }
            dispatchEvent(evt);
            */
            mouseDownItem = null;
        }

        if (!item /*|| !hitTestPoint(event.stageX, event.stageY)*/)
        {
            isPressed = false;
            return;
        }

        if (bSelectOnRelease)
        {
            bSelectOnRelease = false;
            if (selectItem(item.data, item.index, event.shiftKey, event.ctrlKey))
            {
                /*
                evt = new ListEvent(ListEvent.CHANGE);
                evt.itemRenderer = item;
                if (pt)
                {
                    evt.columnIndex = pt.x;
                    evt.rowIndex = pt.y;
                }
                dispatchEvent(evt);
                */
            }
        }

        isPressed = false;
    }

    /**
     *  Handles <code>MouseEvent.MOUSE_CLICK</code> events from any mouse
     *  targets contained in the list including the renderers.  This method
     *  determines which renderer was clicked
     *  and dispatches a <code>ListEvent.ITEM_CLICK</code> event.
     *
     *  @param event The MouseEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function mouseClickHandler(event:MouseEvent):void
    {
        var item:IListItemRenderer = mouseEventToItemRenderer(event);
        if (!item)
            return;

        var pt:Point = itemRendererToIndices(item);
        if (pt) // during tweens, we may get null
        {
            var listEvent:ListEvent =
                new ListEvent(ListEvent.ITEM_CLICK);
            listEvent.columnIndex = pt.x;
            listEvent.rowIndex = pt.y;
            listEvent.itemRenderer = item;
            dispatchEvent(listEvent);
        }
    } */

    /**
     *  Handles <code>MouseEvent.MOUSE_DOUBLE_CLICK</code> events from any
     *  mouse targets contained in the list including the renderers.
     *  This method determines which renderer was clicked
     *  and dispatches a <code>ListEvent.ITEM_DOUBLE_CLICK</code> event.
     *
     *  @param event The MouseEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function mouseDoubleClickHandler(event:MouseEvent):void
    {
        var item:IListItemRenderer = mouseEventToItemRenderer(event);
        if (!item)
            return;

        var pt:Point = itemRendererToIndices(item);
        if (pt) // during tweens, we may get null
        {
            var listEvent:ListEvent =
                new ListEvent(ListEvent.ITEM_DOUBLE_CLICK);
            listEvent.columnIndex = pt.x;
            listEvent.rowIndex = pt.y;
            listEvent.itemRenderer = item;
            dispatchEvent(listEvent);
        }
    } */

    /**
     *  The default handler for the <code>dragStart</code> event.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function dragStartHandler(event:DragEvent):void
    {
        if (event.isDefaultPrevented())
            return;

        var dragSource:DragSource = new DragSource();

        addDragData(dragSource);

        DragManager.doDrag(this, dragSource, event, dragImage,
                           0, 0, 0.5, dragMoveEnabled);
    } */

    /**
     *  Handles <code>DragEvent.DRAG_ENTER</code> events.  This method
     *  determines if the DragSource object contains valid elements and uses
     *  the <code>showDropFeedback()</code> method to set up the UI feedback.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function dragEnterHandler(event:DragEvent):void
    {
        if (event.isDefaultPrevented())
            return;

		lastDragEvent = event;
		
        if (enabled && iteratorValid && 
			(event.dragSource.hasFormat("items")  || event.dragSource.hasFormat("itemsByIndex")))
        {
            DragManager.acceptDragDrop(this);
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            showDropFeedback(event);
            return;
        }

        hideDropFeedback(event);
        
        DragManager.showFeedback(DragManager.NONE);
    }
 */
    /**
     *  Handles <code>DragEvent.DRAG_OVER</code> events.  This method
     *  determines if the DragSource object contains valid elements and uses
     *  the <code>showDropFeedback()</code> method to set up the UI feeback.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
  /*   protected function dragOverHandler(event:DragEvent):void
    {
        if (event.isDefaultPrevented())
            return;

		lastDragEvent = event;
		
        if (enabled && iteratorValid && 
			(event.dragSource.hasFormat("items") || event.dragSource.hasFormat("itemsByIndex")))
        {
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            showDropFeedback(event);
            return;
        }

        hideDropFeedback(event);
        
        DragManager.showFeedback(DragManager.NONE);
    } */

    /**
     *  Handles <code>DragEvent.DRAG_EXIT</code> events.  This method hides
     *  the UI feeback by calling the <code>hideDropFeedback()</code> method.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function dragExitHandler(event:DragEvent):void
    {
        if (event.isDefaultPrevented())
            return;

		lastDragEvent = null;
		
        hideDropFeedback(event);
		
		resetDragScrolling();
        
        DragManager.showFeedback(DragManager.NONE);
    } */

    /**
     *  Handles <code>DragEvent.DRAG_DROP events</code>.  This method  hides
     *  the UI feeback by calling the <code>hideDropFeedback()</code> method.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function dragDropHandler(event:DragEvent):void
    {
        if (event.isDefaultPrevented())
            return;

        hideDropFeedback(event);
		lastDragEvent = null;
		resetDragScrolling();
		
		if (!enabled)
			return;

		var dragSource:DragSource = event.dragSource;
		if (!dragSource.hasFormat("items") && !dragSource.hasFormat("itemsByIndex"))
			return;
		
        if (!dataProvider)
            // Create an empty collection to drop items into.
            dataProvider = [];

        var dropIndex:int = calculateDropIndex(event);
        
		if (dragSource.hasFormat("items"))
			insertItems(dropIndex, dragSource, event);
		else
			insertItemsByIndex(dropIndex, dragSource, event);
		
		lastDragEvent = null;
    } */

    /**
     *  Handles <code>DragEvent.DRAG_COMPLETE</code> events.  This method
     *  removes the item from the data provider.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function dragCompleteHandler(event:DragEvent):void
    {
        isPressed = false;

        if (event.isDefaultPrevented())
            return;

        if (event.action == DragManager.MOVE && dragMoveEnabled)
        {
            if (event.relatedObject != this)
            {
                var indices:Array = selectedIndices;
				
				// clear the selection, otherwise we'll be adjusting it on every element being removed
				clearSelected(false);
				
                indices.sort(Array.NUMERIC);
                var n:int = indices.length;
                for (var i:int = n - 1; i >= 0; i--)
                {
                    collectionIterator.seek(CursorBookmark.FIRST, indices[i]);
                    collectionIterator.remove();
                }
                clearSelected(false);
            }
        }
		
		// this can probably be removed b/c it's in dragExit and dragDrop, but leaving these two 
		// lines for now
		lastDragEvent = null;
		resetDragScrolling();
    } */

    /**
     *  @private
     */
    /* private function selectionTween_updateHandler(event:TweenEvent):void
    {
        Sprite(event.target.listener).alpha = Number(event.value);
    }
 */
    /**
     *  @private
     */
    /* private function selectionTween_endHandler(event:TweenEvent):void
    {
        selectionTween_updateHandler(event);
    } */

    /**
     *  @private
     *  Handles item renderers moving after initiateSelectionTracking() has been
     *  called. This is used during data effects to redraw selections after
     *  item renderers move.
     * 
     */ 
    /* private function rendererMoveHandler(event:MoveEvent):void
    {
        var renderer:IListItemRenderer = event.currentTarget as IListItemRenderer;
        // currently, the assumption is that this is only called for renderers that
        // are representing selected items.
        drawItem(renderer,true);
    }   */  

    //----------------------------------
    //  selectedItems
    //----------------------------------
    
    private var _selectedItems:Array;
    
    [Bindable("change")]
    [Bindable("valueCommit")]
    [Inspectable(category="General")]
    
    /**
     *  An Array of references to the selected items in the data provider.  The
     *  items are in the reverse order that the user selected the items.
     *  @default [ ]
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get selectedItems():Array
    {
        return bSelectedItemsChanged && _selectedItems ? _selectedItems : copySelectedItems();
    }
    
    /**
     *  @private
     */
    override public function set selectedItems(items:Array):void
    {
        if (!collection || collection.length == 0)
        {
            _selectedItems = items;
            bSelectedItemsChanged = true;
            bSelectionChanged = true;
            
            invalidateDisplayList();
            return;
        }
        
        commitSelectedItems(items);
    }
    

}

}
