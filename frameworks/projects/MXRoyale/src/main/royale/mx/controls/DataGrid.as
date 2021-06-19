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

package mx.controls
{
/*
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.ui.Keyboard;
import flash.utils.Dictionary;
import flash.utils.describeType;

import mx.collections.CursorBookmark;
import mx.collections.ICollectionView;
import mx.collections.ISort;
import mx.collections.ISortField;
import mx.collections.ItemResponder;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.collections.errors.ItemPendingError;
import mx.controls.dataGridClasses.DataGridBase;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.controls.dataGridClasses.DataGridDragProxy;
import mx.controls.dataGridClasses.DataGridHeader;
import mx.controls.dataGridClasses.DataGridItemRenderer;
import mx.controls.dataGridClasses.DataGridListData;
import mx.controls.listClasses.IDropInListItemRenderer;
import mx.controls.listClasses.ListBaseContentHolder;
import mx.controls.listClasses.ListBaseSeekPending;
import mx.controls.listClasses.ListRowInfo;
import mx.controls.scrollClasses.ScrollBar;
import mx.core.ContextualClassFactory;
import mx.core.EdgeMetrics;
import mx.core.EventPriority;
import mx.core.FlexShape;
import mx.core.FlexSprite;
import mx.core.IFactory;
import mx.core.IFlexDisplayObject;
import mx.core.IFlexModuleFactory;
import mx.core.IIMESupport;
import mx.core.IInvalidating;
import mx.core.IPropertyChangeNotifier;
import mx.core.IRectangularBorder;
import mx.core.IUIComponent;
import mx.core.ScrollPolicy;
import mx.core.UIComponent;
import mx.core.UIComponentGlobals;
import mx.core.mx_internal;
import mx.events.CollectionEvent;
import mx.events.CollectionEventKind;
import mx.events.DataGridEvent;
import mx.events.DataGridEventReason;
import mx.events.DragEvent;
import mx.events.IndexChangedEvent;
import mx.events.ListEvent;
import mx.events.SandboxMouseEvent;
import mx.events.ScrollEvent;
import mx.events.ScrollEventDetail;
import mx.managers.IFocusManager;
import mx.managers.IFocusManagerComponent;
import mx.skins.halo.ListDropIndicator;
import mx.styles.ISimpleStyleClient;
import mx.utils.ObjectUtil;
import mx.utils.StringUtil;

use namespace mx_internal;
*/

import mx.controls.listClasses.IListItemRenderer;
import mx.core.UIComponent;
import mx.controls.beads.DataGridSortBead;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.controls.listClasses.ListBase;
import mx.controls.listClasses.AdvancedListBase;
import mx.controls.listClasses.DataGridListBase;
import mx.controls.beads.DataGridColumnResizeBead;
import mx.controls.beads.DataGridLinesBeadForICollectionView;
import mx.events.DragEvent;

import mx.core.mx_internal;
use namespace mx_internal;

import org.apache.royale.core.IBead;
import org.apache.royale.core.IDataGrid;
import org.apache.royale.core.IDataGridModel;
import org.apache.royale.html.beads.IDataGridView;
import org.apache.royale.core.IDataGridPresentationModel;
import org.apache.royale.core.ValuesManager;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the user releases the mouse button while over an item 
 *  renderer, tabs to the DataGrid control or within the DataGrid control, 
 *  or in any other way attempts to edit an item.
 *
 *  @eventType mx.events.DataGridEvent.ITEM_EDIT_BEGINNING
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="itemEditBeginning", type="mx.events.DataGridEvent")]

/**
 *  Dispatched when the <code>editedItemPosition</code> property has been set
 *  and the item can be edited.
 *
 *  @eventType mx.events.DataGridEvent.ITEM_EDIT_BEGIN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemEditBegin", type="mx.events.DataGridEvent")]

/**
 *  Dispatched when the item editor has just been instantiated.
 *
 *  @eventType mx.events.DataGridEvent.ITEM_EDITOR_CREATE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="itemEditorCreate", type="mx.events.DataGridEvent")]

/**
 *  Dispatched when an item editing session ends for any reason.
 *
 *  @eventType mx.events.DataGridEvent.ITEM_EDIT_END
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemEditEnd", type="mx.events.DataGridEvent")]

/**
 *  Dispatched when an item renderer gets focus, which can occur if the user
 *  clicks on an item in the DataGrid control or navigates to the item using
 *  a keyboard.  Only dispatched if the item is editable.
 *
 *  @eventType mx.events.DataGridEvent.ITEM_FOCUS_IN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="itemFocusIn", type="mx.events.DataGridEvent")]

/**
 *  Dispatched when an item renderer loses focus, which can occur if the user
 *  clicks another item in the DataGrid control or clicks outside the control,
 *  or uses the keyboard to navigate to another item in the DataGrid control
 *  or outside the control.
 *  Only dispatched if the item is editable.
 *
 *  @eventType mx.events.DataGridEvent.ITEM_FOCUS_OUT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="itemFocusOut", type="mx.events.DataGridEvent")]

/**
 *  Dispatched when a user changes the width of a column, indicating that the 
 *  amount of data displayed in that column may have changed.
 *  If <code>horizontalScrollPolicy</code> is <code>"off"</code>, other
 *  columns shrink or expand to compensate for the columns' resizing,
 *  and they also dispatch this event.
 *
 *  @eventType mx.events.DataGridEvent.COLUMN_STRETCH
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="columnStretch", type="mx.events.DataGridEvent")]

/**
 *  Dispatched when the user releases the mouse button on a column header
 *  to request the control to sort
 *  the grid contents based on the contents of the column.
 *  Only dispatched if the column is sortable and the data provider supports 
 *  sorting. The DataGrid control has a default handler for this event that implements
 *  a single-column sort.  Multiple-column sort can be implemented by calling the 
 *  <code>preventDefault()</code> method to prevent the single column sort and setting 
 *  the <code>sort</code> property of the data provider.
 * <p>
 * <b>Note</b>: The sort arrows are defined by the default event handler for
 * the headerRelease event. If you call the <code>preventDefault()</code> method
 * in your event handler, the arrows are not drawn.
 * </p>
 *
 *  @eventType mx.events.DataGridEvent.HEADER_RELEASE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="headerRelease", type="mx.events.DataGridEvent")]

/**
 *  Dispatched when the user releases the mouse button on a column header after 
 *  having dragged the column to a new location resulting in shifting the column
 *  to a new index.
 *
 *  @eventType mx.events.IndexChangedEvent.HEADER_SHIFT
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Event(name="headerShift", type="mx.events.IndexChangedEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

//include "../styles/metadata/IconColorStyles.as"

/**
 *  Name of the class of the itemEditor to be used if one is not
 *  specified for a column.  This is a way to set
 *  an item editor for a group of DataGrids instead of having to
 *  set each one individually.  If you set the DataGridColumn's itemEditor
 *  property, it supercedes this value.
 *  @default null
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="defaultDataGridItemEditor", type="Class", inherit="no")]

/**
 *  Name of the class of the itemRenderer to be used if one is not
 *  specified for a column or its header.  This is a way to set
 *  an itemRenderer for a group of DataGrids instead of having to
 *  set each one individually.  If you set the DataGrid's itemRenderer
 *  property, it supercedes this value.
 *  @default null
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
//[Style(name="defaultDataGridItemRenderer", type="Class", inherit="no")]

/**
 *  A flag that indicates whether to show vertical grid lines between
 *  the columns.
 *  If <code>true</code>, shows vertical grid lines.
 *  If <code>false</code>, hides vertical grid lines.
 *  @default true
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="verticalGridLines", type="Boolean", inherit="no")]

/**
 *  A flag that indicates whether to show horizontal grid lines between
 *  the rows.
 *  If <code>true</code>, shows horizontal grid lines.
 *  If <code>false</code>, hides horizontal grid lines.
 *  @default false
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="horizontalGridLines", type="Boolean", inherit="no")]

/**
 *  The color of the vertical grid lines.
 *  
 *  The default value for the Halo theme is <code>0xCCCCCC</code>.
 *  The default value for the Spark theme is <code>0x696969</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="verticalGridLineColor", type="uint", format="Color", inherit="yes")]

/**
 *  The color of the horizontal grid lines.
 *  @default 0xF7F7F7
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="horizontalGridLineColor", type="uint", format="Color", inherit="yes")]

/**
 *  An array of two colors used to draw the header background gradient.
 *  The first color is the top color.
 *  The second color is the bottom color.
 *  @default [0xFFFFFF, 0xE6E6E6]
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="headerColors", type="Array", arrayType="uint", format="Color", inherit="yes", theme="halo")]

/**
 *  The color of the row background when the user rolls over the row.
 *  
 *  The default value for the Halo theme is <code>0xB2E1FF</code>.
 *  The default value for the Spark theme is <code>0xCEDBEF</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="rollOverColor", type="uint", format="Color", inherit="yes")]

/**
 *  The color of the background for the row when the user selects 
 *  an item renderer in the row.
 * 
 *  The default value for the Halo theme is <code>0x7FCEFF</code>.
 *  The default value for the Spark theme is <code>0xA8C6EE</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="selectionColor", type="uint", format="Color", inherit="yes")]

/**
 *  The name of a CSS style declaration for controlling other aspects of
 *  the appearance of the column headers.
 *  @default "dataGridStyles"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="headerStyleName", type="String", inherit="no")]

/**
 *  The class to use as the skin for a column that is being resized.
 * 
 *  @default mx.skins.halo.DataGridColumnResizeSkin (for both Halo and Spark themes)
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="columnResizeSkin", type="Class", inherit="no")]


/**
 *  The class to use as the skin that defines the appearance of the  
 *  background of the column headers in a DataGrid control.
 *  The default value for the Halo theme is <code>mx.skins.halo.DataGridHeaderBackgroundSkin</code>.
 *  The default value for the Spark theme is <code>mx.skins.spark.DataGridHeaderBackgroundSkin</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="headerBackgroundSkin", type="Class", inherit="no")]

/**
 *  The class to use as the skin that defines the appearance of the 
 *  separator between column headers in a DataGrid control.
 *  The default value for the Halo theme is <code>mx.skins.halo.DataGridHeaderSeparator</code>.
 *  The default value for the Spark theme is <code>mx.skins.spark.DataGridHeaderSeparatorSkin</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="headerSeparatorSkin", type="Class", inherit="no")]

/**
 *  The class to use as the skin that defines the appearance of the 
 *  separator between rows in a DataGrid control. 
 *  By default, the DataGrid control uses the 
 *  <code>drawHorizontalLine()</code> and <code>drawVerticalLine()</code> methods
 *  to draw the separators.
 *
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="horizontalSeparatorSkin", type="Class", inherit="no")]

/**
 *  The class to use as the skin that defines the appearance of the 
 *  separator between the locked and unlocked rows in a DataGrid control.
 *  By default, the DataGrid control uses the 
 *  <code>drawHorizontalLine()</code> and <code>drawVerticalLine()</code> methods
 *  to draw the separators.
 *
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="horizontalLockedSeparatorSkin", type="Class", inherit="no")]

/**
 *  The class to use as the skin that defines the appearance of the 
 *  separators between columns in a DataGrid control.
 *  By default, the DataGrid control uses the 
 *  <code>drawHorizontalLine()</code> and <code>drawVerticalLine()</code> methods
 *  to draw the separators.
 *
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="verticalSeparatorSkin", type="Class", inherit="no")]

/**
 *  The class to use as the skin that defines the appearance of the 
 *  separator between the locked and unlocked columns in a DataGrid control.
 *  By default, the DataGrid control uses the 
 *  <code>drawHorizontalLine()</code> and <code>drawVerticalLine()</code> methods
 *  to draw the separators.
 *
 *  @default undefined
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="verticalLockedSeparatorSkin", type="Class", inherit="no")]

/**
 *  The class to use as the skin for the arrow that indicates the column sort 
 *  direction.
 *  The default value for the Halo theme is <code>mx.skins.halo.DataGridSortArrow</code>.
 *  The default value for the Spark theme is <code>mx.skins.spark.DataGridSortArrow</code>.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="sortArrowSkin", type="Class", inherit="no")]

/**
 *  The class to use as the skin for the cursor that indicates that a column
 *  can be resized.
 *  The default value is the "cursorStretch" symbol from the Assets.swf file.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="stretchCursor", type="Class", inherit="no")]

/**
 *  The class to use as the skin that indicates that 
 *  a column can be dropped in the current location.
 *
 *  @default mx.skins.halo.DataGridColumnDropIndicator (for both Halo and Spark themes)
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="columnDropIndicatorSkin", type="Class", inherit="no")]

/**
 *  The name of a CSS style declaration for controlling aspects of the
 *  appearance of column when the user is dragging it to another location.
 *
 *  @default "headerDragProxyStyle"
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
//[Style(name="headerDragProxyStyleName", type="String", inherit="no")]

//--------------------------------------
//  Excluded APIs
//--------------------------------------

[Exclude(name="columnCount", kind="property")]
[Exclude(name="columnWidth", kind="property")]
[Exclude(name="iconField", kind="property")]
[Exclude(name="iconFunction", kind="property")]
[Exclude(name="labelField", kind="property")]
[Exclude(name="offscreenExtraRowsOrColumns", kind="property")]
[Exclude(name="offscreenExtraRows", kind="property")]
[Exclude(name="offscreenExtraRowsTop", kind="property")]
[Exclude(name="offscreenExtraRowsBottom", kind="property")]
[Exclude(name="offscreenExtraColumns", kind="property")]
[Exclude(name="offscreenExtraColumnsLeft", kind="property")]
[Exclude(name="offscreenExtraColumnsRight", kind="property")]
[Exclude(name="offscreenExtraRowsOrColumnsChanged", kind="property")]
[Exclude(name="showDataTips", kind="property")]
[Exclude(name="cornerRadius", kind="style")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[AccessibilityClass(implementation="mx.accessibility.DataGridAccImpl")]

[DataBindingInfo("acceptedTypes", "{ dataProvider: &quot;String&quot; }")]

[DefaultBindingProperty(source="selectedItem", destination="dataProvider")]

[DefaultProperty("dataProvider")]

[DefaultTriggerEvent("change")]

//[IconFile("DataGrid.png")]

[RequiresDataBinding(true)]

[Alternative(replacement="spark.components.DataGrid", since="4.5")]

/**
 *  The <code>DataGrid</code> control is like a List except that it can 
 *  show more than one column of data making it suited for showing 
 *  objects with multiple properties.
 *  <p>
 *  The DataGrid control provides the following features:
 *  <ul>
 *  <li>Columns of different widths or identical fixed widths</li>
 *  <li>Columns that the user can resize at runtime </li>
 *  <li>Columns that the user can reorder at runtime </li>
 *  <li>Optional customizable column headers</li>
 *  <li>Ability to use a custom item renderer for any column to display 
 *      data 
 *  other than text</li>
 *  <li>Support for sorting the data by clicking on a column</li>
 *  </ul>
 *  </p>
 *  The DataGrid control is intended for viewing data, and not as a
 *  layout tool like an HTML table.
 *  The mx.containers package provides those layout tools.
 *  
 *  <p>The DataGrid control has the following default sizing 
 *     characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>If the columns are empty, the default width is 300 
 *               pixels. If the columns contain information but define 
 *               no explicit widths, the default width is 100 pixels 
 *               per column. The DataGrid width is sized to fit the 
 *               width of all columns, if possible. 
 *               The default number of displayed rows, including the 
 *               header is 7, and each row, by default, is 20 pixels 
 *               high.
 *           </td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0 pixels.</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>5000 by 5000.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *  <p>
 *  The <code>&lt;mx:DataGrid&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass, except for <code>labelField</code>, 
 *  <code>iconField</code>, and <code>iconFunction</code>, and adds the 
 *  following tag attributes:
 *  </p>
 *  <pre>
 *  &lt;mx:DataGrid
 *    <b>Properties</b>
 *    columns="<i>From dataProvider</i>"
 *    draggableColumns="true|false"
 *    editable="false|true"
 *    editedItemPosition="<code>null</code>"
 *    horizontalScrollPosition="null"
 *    imeMode="null"
 *    itemEditorInstance="null"
 *    minColumnWidth="<code>NaN</code>"
 *    resizableColumns="true|false"
 *    sortableColumns="true|false"
 *    
 *    <b>Styles</b>
 *    backgroundDisabledColor="0xEFEEEF"
 *    columnDropIndicatorSkin="DataGridColumnDropIndicator"
 *    columnResizeSkin="DataGridColumnResizeSkin"
 *    disabledIconColor="0x999999"
 *    headerColors="[#FFFFFF, #E6E6E6]"
 *    headerDragProxyStyleName="headerDragProxyStyle"
 *    headerSeparatorSkin="DataGridHeaderSeparator"
 *    headerStyleName="dataGridStyles"
 *    horizontalGridLineColor="0xF7F7F7"
 *    horizontalGridLines="false|true"
 *    horizontalLockedSeparatorSkin="undefined"
 *    horizontalSeparatorSkin="undefined"
 *    iconColor="0x111111"
 *    rollOverColor="0xB2E1FF"
 *    selectionColor="0x7FCEFF"
 *    sortArrowSkin="DataGridSortArrow"
 *    stretchCursor="<i>"cursorStretch" symbol from the Assets.swf file</i>"
 *    verticalGridLineColor="0xCCCCCC"
 *    verticalGridLines="false|true"
 *    verticalLockedSeparatorSkin="undefined"
 *    verticalSeparatorSkin="undefined"
 *     
 *    <b>Events</b>
 *    columnStretch="<i>No default</i>"
 *    headerRelease="<i>No default</i>"
 *    headerShift="<i>No default</i>"
 *    itemEditBegin="<i>No default</i>"
 *    itemEditBeginning="<i>No default</i>" 
 *    itemEditEnd="<i>No default</i>"
 *    itemFocusIn="<i>No default</i>"
 *    itemFocusOut="<i>No default</i>"
 *  /&gt;
 *   
 *  <b>The following DataGrid code sample specifies the column order:</b>
 *  &lt;mx:DataGrid&gt;
 *    &lt;mx:dataProvider&gt;
 *        &lt;mx:Object Artist="Pavement" Price="11.99"
 *          Album="Slanted and Enchanted"/&gt;
 *        &lt;mx:Object Artist="Pavement"
 *          Album="Brighten the Corners" Price="11.99"/&gt;
 *    &lt;/mx:dataProvider&gt;
 *    &lt;mx:columns&gt;
 *        &lt;mx:DataGridColumn dataField="Album"/&gt;
 *        &lt;mx:DataGridColumn dataField="Price"/&gt;
 *    &lt;/mx:columns&gt;
 *  &lt;/mx:DataGrid&gt;
 *  </pre>
 *  </p>
 *
 *  @see mx.controls.dataGridClasses.DataGridItemRenderer
 *  @see mx.controls.dataGridClasses.DataGridColumn
 *  @see mx.controls.dataGridClasses.DataGridDragProxy
 *  @see mx.events.DataGridEvent
 *
 *  @includeExample examples/SimpleDataGrid.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class DataGrid extends DataGridListBase/*ListBase*/ implements IDataGrid// implements IIMESupport
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
    public function DataGrid()
    {
        super();
        typeNames = "DataGrid";
        addBead(new DataGridLinesBeadForICollectionView());
        addBead(new DataGridColumnResizeBead());
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------


    /**
     *  A flag that indicates whether the user can change the size of the
     *  columns.
     *  If <code>true</code>, the user can stretch or shrink the columns of
     *  the DataGrid control by dragging the grid lines between the header cells.
     *  If <code>true</code>, individual columns must also have their
     *  <code>resizable</code> properties set to <code>false</code> to
     *  prevent the user from resizing a particular column.
     *
     *  @default true
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var resizableColumns:Boolean = true;

    /**
     *  A flag that indicates whether the user can sort the data provider items
     *  by clicking on a column header cell.
     *  If <code>true</code>, the user can sort the data provider items by
     *  clicking on a column header cell.
     *  The <code>DataGridColumn.dataField</code> property of the column
     *  or the <code>DataGridColumn.sortCompareFunction</code> property
     *  of the column is used as the sort field.
     *  If a column is clicked more than once
     *  the sort alternates between ascending and descending order.
     *  If <code>true</code>, individual columns can be made to not respond
     *  to a click on a header by setting the column's <code>sortable</code>
     *  property to <code>false</code>.
     *
     *  <p>When a user releases the mouse button over a header cell, the DataGrid
     *  control dispatches a <code>headerRelease</code> event if both
     *  this property and the column's sortable property are <code>true</code>.
     *  If no handler calls the <code>preventDefault()</code> method on the event, the
     *  DataGrid sorts using that column's <code>DataGridColumn.dataField</code> or
     *  <code>DataGridColumn.sortCompareFunction</code> properties.</p>
     *
     *  @default true
     *
     *  @see mx.controls.dataGridClasses.DataGridColumn#dataField
     *  @see mx.controls.dataGridClasses.DataGridColumn#sortCompareFunction
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public var sortableColumns:Boolean = true;


    /**
     *  Returns the item renderer for a column cell or for a column header. 
     *  This method returns the default item renderer if no custom render is assigned
     *  to the column.
     *
     *  <p>This method is public so that is can be accessed by the DataGridHeader class, 
     *  and is primarily used in subclasses of the DataGrid control.</p>
     * 
     *  @param c The DataGridColumn instance of the item renderer.
     * 
     *  @param forHeader <code>true</code> to return the header item renderer, 
     *  and <code>false</code> to return the item render for the column cells.
     * 
     *  @param data If <code>forHeader</code> is <code>false</code>, 
     *  the <code>data</code> Object for the item renderer. 
     *  If <code>forHeader</code> is <code>true</code>, 
     *  the DataGridColumn instance.  
     * 
     *  @return The item renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function createColumnItemRenderer(c:DataGridColumn, forHeader:Boolean, data:Object):IListItemRenderer // not implemented
    {
        //var factory:IFactory;
//
        //// get the factory for the data
        //factory = c.getItemRendererFactory(forHeader, data);
        //if (!factory)
        //{
            //if (data == null)
                //factory = nullItemRenderer;
            //if (!factory)
                //factory = itemRenderer;
        //}
//
        //var renderer:IListItemRenderer;
//
        //// if it is the default column factory, see if
        //// the freeItemRenderersTable has a free one
        //if (factory == c.itemRenderer)
        //{
            //if (freeItemRenderersTable[c] && freeItemRenderersTable[c].length)
            //{
                //renderer = freeItemRenderersTable[c].pop();
                //delete c.freeItemRenderersByFactory[factory][renderer];
            //}
        //}
        //else if (c.freeItemRenderersByFactory)
        //{
            //// other re-usable renderers are in the FactoryMap
            //var d:Dictionary = c.freeItemRenderersByFactory[factory];
            //if (d)
            //{
                //for (var p:* in d)
                //{
                    //renderer = IListItemRenderer(p);
                    //delete d[p];
                    //break;
                //}
            //}
        //}
//
        //if (!renderer )
        //{
            //renderer = factory.newInstance();
            //if (renderer)
            //{
        //renderer.styleName = c;
        //factoryMap[renderer] = factory;
        //}
        //}
//
//
        //if (renderer)
            //renderer.owner = this;
        //return renderer;
	    return null;
    }


    /**
     *  This method closes an item editor currently open on an item renderer. 
     *  You typically only call this method from within the event listener 
     *  for the <code>itemEditEnd</code> event, after
     *  you have already called the <code>preventDefault()</code> method to 
     *  prevent the default event listener from executing.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function destroyItemEditor():void // not implemented
    {
        //// trace("destroyItemEditor");
        //if (itemEditorInstance)
        //{
            //DisplayObject(itemEditorInstance).removeEventListener(KeyboardEvent.KEY_DOWN, editorKeyDownHandler);
            //if (focusManager)
                //focusManager.defaultButtonEnabled = true;
            //systemManager.getSandboxRoot().
                //removeEventListener(MouseEvent.MOUSE_DOWN, editorMouseDownHandler, true);
            //systemManager.getSandboxRoot().
                //removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, editorMouseDownHandler);
            //systemManager.removeEventListener(Event.RESIZE, editorAncestorResizeHandler);
            //removeEventListener(Event.RESIZE, editorAncestorResizeHandler);
//
            //var event:DataGridEvent =
                //new DataGridEvent(DataGridEvent.ITEM_FOCUS_OUT);
            //event.columnIndex = _editedItemPosition.columnIndex;
            //event.rowIndex = _editedItemPosition.rowIndex;
            //event.itemRenderer = itemEditorInstance;
            //dispatchEvent(event);
//
            //if (! _columns[_editedItemPosition.columnIndex].rendererIsEditor)
            //{
                //// FocusManager.removeHandler() does not find
                //// itemEditors in focusableObjects[] array
                //// and hence does not remove the focusRectangle
                //if (itemEditorInstance && itemEditorInstance is UIComponent)
                    //UIComponent(itemEditorInstance).drawFocus(false);
//
                //// setfocus back to us so something on stage has focus
				//// only if focus is null or is in this DG
				//var focusComp:InteractiveObject = getFocus();
				//if (focusComp == null || contains(focusComp))
	                //deferFocus();
                //
                //// defer focus can cause focusOutHandler to destroy the editor
                //// and make itemEditorInstance null
                //if (itemEditorInstance)
                //{
                    //// must call removeChild() so FocusManager.lastFocus becomes null
                    //actualContentHolder.removeChild(DisplayObject(itemEditorInstance));
                    //editedItemRenderer.visible = true;
                //}
            //}
            //itemEditorInstance = null;
            //_editedItemPosition = null;
        //}
    }

    protected function drawRowBackground(s:UIComponent, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int):void
    {
	// not implemented
    }
    
    public function set horizontalGridLines(value:Boolean):void {} // not implemented
    public function set horizontalGridLineColor(value:uint):void {} // not implemented
    public function set selectionColor(value:uint):void {} // not implemented
    public function set headerSeparatorSkin(value:Class):void {} // not implemented
    
    //public function set editable(value:Boolean):void {} // not implemented
	
	//----------------------------------
    //  editable
    //----------------------------------

    /**
     *  @private
     *  Storage for the draggableColumns property.
     */
    private var _editable:Boolean = false;
    
    [Inspectable(category="General")]

    /**
     *  A flag that indicates whether or not the user can edit
     *  items in the data provider.
     *  If <code>true</code>, the item renderers in the control are editable.
     *  The user can click on an item renderer to open an editor.
     *
     *  <p>You can turn off editing for individual columns of the
     *  DataGrid control using the <code>DataGridColumn.editable</code> property,
     *  or by handling the <code>itemEditBeginning</code> and
     *  <code>itemEditBegin</code> events</p>
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get editable():Boolean
    {
        return _editable;
    }
    
    /**
     *  @private
     */
    public function set editable(value:Boolean):void
    {
        _editable = value;
    }
	
	//----------------------------------
    //  editedItemPosition
    //----------------------------------

    /**
     *  @private
     */
    private var bEditedItemPositionChanged:Boolean = false;

    /**
     *  @private
     *  undefined means we've processed it
     *  null means don't put up an editor
     *  {} is the coordinates for the editor
     */
    private var _proposedEditedItemPosition:*;

    /**
     *  @private
     *  the last editedItemPosition and the last
     *  position where editing was attempted if editing
     *  was cancelled.  We restore editing
     *  to this point if we get focus from the TAB key
     */
    private var lastEditedItemPosition:*;

    /**
     *  @private
     */
    private var _editedItemPosition:Object;

    /**
     *  @private
     */
    private var itemEditorPositionChanged:Boolean = false;


    [Bindable("itemFocusIn")]

    /**
     *  The column and row index of the item renderer for the
     *  data provider item being edited, if any.
     *
     *  <p>This Object has two fields, <code>columnIndex</code> and 
     *  <code>rowIndex</code>,
     *  the zero-based column and row indexes of the item.
     *  For example: {columnIndex:2, rowIndex:3}</p>
     *
     *  <p>Setting this property scrolls the item into view and
     *  dispatches the <code>itemEditBegin</code> event to
     *  open an item editor on the specified item renderer.</p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get editedItemPosition():Object
    {
        if (_editedItemPosition)
            return {rowIndex: _editedItemPosition.rowIndex,
                columnIndex: _editedItemPosition.columnIndex};
        else
            return _editedItemPosition;
    }

    /**
     *  @private
     */
    public function set editedItemPosition(value:Object):void
    {
        if (!value)
        {
            //setEditedItemPosition(null);
            return;
        }
 
        var newValue:Object = {rowIndex: value.rowIndex,
            columnIndex: value.columnIndex};

        //setEditedItemPosition(newValue);
    }

    /**
     *  @private
     *  Storage for the headerHeight property.
     */
   /* mx_internal*/ private var _headerHeight:Number = 22;

    [Bindable("resize")]
    //[Inspectable(category="General", defaultValue="22")]

    /**
     *  The height of the header cell of the column, in pixels.
     *  If set explicitly, that height will be used for all of
     *  the headers. If not set explicitly,
     *  the height will based on style settings and the header
     *  renderer.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get headerHeight():Number
    {
        return _headerHeight;
    }

    /**
     *  @private
     */
    public function set headerHeight(value:Number):void
    {
        _headerHeight = value;
       /* _explicitHeaderHeight = true;
        itemsSizeChanged = true;

        invalidateDisplayList();*/
    }

    /**
     *  @private
     *  Storage for the showHeaders property.
     */
    private var _showHeaders:Boolean = true;

    [Bindable("showHeadersChanged")]
  //  [Inspectable(category="General", defaultValue="true")]

    /**
     *  A flag that indicates whether the control should show
     *  column headers.
     *  If <code>true</code>, the control shows column headers.
     *
     *  @default true
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get showHeaders():Boolean
    {
        return _showHeaders;
    }

    /**
     *  @private
     */
    public function set showHeaders(value:Boolean):void
    {
        if (value == _showHeaders)
            return;

        _showHeaders = value;
        /*itemsSizeChanged = true;

        invalidateDisplayList();

        dispatchEvent(new Event("showHeadersChanged"));*/
    }

	//----------------------------------
    //  minColumnWidth
    //----------------------------------

    /**
     *  @private
     */
    private var _minColumnWidth:Number;

    /**
     *  @private
     */
    private var minColumnWidthInvalid:Boolean = false;

    [Inspectable(defaultValue="NaN")]

    /**
     *  The minimum width of the columns, in pixels.  If not NaN,
     *  the DataGrid control applies this value as the minimum width for
     *  all columns.  Otherwise, individual columns can have
     *  their own minimum widths.
     *  
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minColumnWidth():Number
    {
        return _minColumnWidth;
    }

    /**
     *  @private
     */
    public function set minColumnWidth(value:Number):void
    {
        _minColumnWidth = value;
        minColumnWidthInvalid = true;
        //itemsSizeChanged = true;
       // columnsInvalid = true;
       // invalidateDisplayList();
    }
    [Inspectable(environment="none")]



    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  columns
    //----------------------------------

    [Bindable("columnsChanged")]
    [Inspectable(category="General", arrayType="mx.controls.dataGridClasses.DataGridColumn")]

    /**
     *  An array of DataGridColumn objects, one for each column that
     *  can be displayed.  If not explicitly set, the DataGrid control 
     *  attempts to examine the first data provider item to determine the
     *  set of properties and display those properties in alphabetic
     *  order.
     *
     *  <p>If you want to change the set of columns, you must get this array,
     *  make modifications to the columns and order of columns in the array,
     *  and then assign the new array to the columns property.  This is because
     *  the DataGrid control returned a new copy of the array of columns and therefore
     *  did not notice the changes.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get columns():Array
    {
        var arr:Array = IDataGridModel(model).columns;
        return arr ? arr.slice() : [];
    }
    /**
     * @royaleignorecoercion org.apache.royale.core.IDataGridModel
     */
    public function set columns(value:Array):void
    {
        var index:int = 0;
        for each (var col:DataGridColumn in value)
        {
            col.owner = this;
            col.colNum = index++;
        }
        value = value? value.slice() : value;
        IDataGridModel(model).columns = value;
    }

    /**
     *  @private
     *  Storage for the draggableColumns property.
     */
    private var _draggableColumns:Boolean = true;

    [Inspectable(defaultValue="true")]

    /**
     *  A flag that indicates whether the user is allowed to reorder columns.
     *  If <code>true</code>, the user can reorder the columns
     *  of the DataGrid control by dragging the header cells.
     *
     *  @default true
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get draggableColumns():Boolean
    {
        return _draggableColumns;
    }

    /**
     *  @private
     */
    public function set draggableColumns(value:Boolean):void
    {
        _draggableColumns = value;
    }

    /**
     * @private
     */
    private var _presentationModel:IDataGridPresentationModel;
    
    /**
     *  The DataGrid's presentation model
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     *  @royaleignorecoercion org.apache.royale.core.IDataGridPresentationModel
     *  @royaleignorecoercion org.apache.royale.core.IBead
     */
    override public function get presentationModel():IBead
    {
        if (_presentationModel == null) {
            var c:Class = ValuesManager.valuesImpl.getValue(this, "iDataGridPresentationModel");
            if (c) {
                _presentationModel = new c() as IDataGridPresentationModel;
                addBead(_presentationModel as IBead);
            }
        }
        
        return _presentationModel;
    }
    /**
     *  @royaleignorecoercion org.apache.royale.core.IDataGridPresentationModel
     *  @royaleignorecoercion org.apache.royale.core.IBead
     */
    public function set presentationModel(value:IBead):void
    {
        _presentationModel = value as IDataGridPresentationModel;
    }
    
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
     *  @productversion Flex 3
     */
    public function showDropFeedback(event:DragEvent):void
    {
        //To Do
        trace("showDropFeedback is not implemented");
    }

    override public function addedToParent():void
    {
        super.addedToParent();

        addBead(new DataGridSortBead())

        COMPILE::JS{
            this.element.style['overflow-y'] = 'hidden';
        }

       /* addBead(new AdvancedDataGridSortBead());
        addEventListener(AdvancedDataGridEvent.SORT, sortHandler);
        // Register default handlers for item editing.

        addEventListener(AdvancedDataGridEvent.ITEM_EDIT_BEGINNING,
                itemEditorItemEditBeginningHandler);

        addEventListener(AdvancedDataGridEvent.ITEM_EDIT_BEGIN,
                itemEditorItemEditBeginHandler);

        addEventListener(AdvancedDataGridEvent.ITEM_EDIT_END,
                itemEditorItemEditEndHandler);*/

    }

    COMPILE::JS
    /**
     * @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
     */
    override protected function getVerticalScrollElement():HTMLElement{
        return view is IDataGridView && IDataGridView(view).listArea ? IDataGridView(view).listArea.element : null;
    }

    COMPILE::JS
    /**
     * @royaleignorecoercion org.apache.royale.html.beads.IDataGridView
     */
    override protected function getHorizontalScrollElement():HTMLElement{
        return view is IDataGridView && IDataGridView(view).listArea ? IDataGridView(view).listArea.element : null;
    }
}

}
