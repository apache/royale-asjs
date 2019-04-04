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

package spark.components
{
	/*
    import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.ui.Keyboard;
	*/

	import org.apache.royale.events.Event;
	import mx.events.FocusEvent;
	import mx.events.KeyboardEvent;
	import mx.events.MouseEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
	import mx.core.Keyboard;
	
    import mx.collections.ArrayCollection;
    import mx.collections.ComplexFieldChangeWatcher;
    import mx.collections.ICollectionView;
    import mx.collections.IComplexSortField;
    import mx.collections.IList;
    import mx.collections.ISort;
    import mx.collections.ISortField;
    import mx.collections.ListCollectionView;
    import mx.core.DragSource;
    import mx.core.EventPriority;
    import mx.core.IFactory;
    import mx.core.IFlexDisplayObject;
    import mx.core.IIMESupport;
    import mx.core.IUID;
    import mx.core.IVisualElement;
    import mx.core.InteractionMode;
    import mx.core.LayoutDirection;
    import mx.core.ScrollPolicy;
    import mx.core.UIComponent;
    import mx.core.mx_internal;
    import mx.events.DragEvent;
    import mx.events.FlexEvent;
    import mx.events.SandboxMouseEvent;
    // import mx.events.TouchInteractionEvent;
    import mx.managers.CursorManager;
    import mx.managers.CursorManagerPriority;
    import mx.managers.DragManager;
    import mx.managers.IFocusManagerComponent;
    import mx.styles.IAdvancedStyleClient;
    import mx.utils.ObjectUtil;
    import mx.utils.UIDUtil;

    import spark.collections.Sort;
    import spark.components.gridClasses.CellPosition;
    import spark.components.gridClasses.CellRegion;
    import spark.components.gridClasses.DataGridEditor;
    import spark.components.gridClasses.GridColumn;
    import spark.components.gridClasses.GridItemEditorActivationMouseEvent;
    import spark.components.gridClasses.GridLayout;
    import spark.components.gridClasses.GridSelection;
    import spark.components.gridClasses.GridSelectionMode;
    import spark.components.gridClasses.GridView;
    import spark.components.gridClasses.GridViewLayout; //
    import spark.components.gridClasses.IDataGridElement;
    import spark.components.gridClasses.IGridItemEditor;
    import spark.components.supportClasses.IDataProviderEnhance;
    import spark.components.supportClasses.RegExPatterns;
    import spark.components.supportClasses.SkinnableContainerBase;
    import spark.core.NavigationUnit;
    import spark.events.GridCaretEvent;
    import spark.events.GridEvent;
    import spark.events.GridSelectionEvent;
    import spark.events.GridSelectionEventKind;
    import spark.events.GridSortEvent;
    import spark.layouts.supportClasses.DropLocation;

    use namespace mx_internal;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  Used to initialize the DataGrid's <code>rowBackground</code> skin part.   
 *  If the <code>alternatingRowColors</code> style is specified, 
 *  then use the <code>alternatingRowColorsBackground</code> skin part 
 *  as the value of the <code>rowBackground</code> skin part.  
 *  The alternating colors for the grid rows are defined by 
 *  successive entries in the Array value of this style.
 *
 *  <p>If you want to change how this style is rendered, 
 *  replace the <code>alternatingRowColorsBackground</code> skin part
 *  in the DataGridSkin class.   
 *  If you want to specify the background for each row, then 
 *  initialize the <code>rowBackground</code> skin part directly.</p>
 * 
 *  @default undefined
 *
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Style(name="alternatingRowColors", type="Array", arrayType="uint", format="Color", inherit="no", theme="spark")]

/**
 *  The alpha value of the border for this component.
 *  Valid values are 0.0 to 1.0. 
 *
 *  @default 1.0
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Style(name="borderAlpha", type="Number", inherit="no", theme="spark", minValue="0.0", maxValue="1.0")]

/**
 *  The color of the border for this component.
 *
 *  @default #696969
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Style(name="borderColor", type="uint", format="Color", inherit="no", theme="spark")]

/**
 *  Controls the visibility of the border for this component.
 *
 *  @default true
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Style(name="borderVisible", type="Boolean", inherit="no", theme="spark")]

/**
 *  Color of the caret indicator when navigating the Grid.
 *
 *  @default 0x0167FF
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Flex 4.5
 */
[Style(name="caretColor", type="uint", format="Color", inherit="yes", theme="spark")]

/**
 *  The alpha of the content background for this component.
 *  Valid values are 0.0 to 1.0. 
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Style(name="contentBackgroundAlpha", type="Number", inherit="yes", theme="spark", minValue="0.0", maxValue="1.0")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:contentBackgroundColor
 *   
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Style(name="contentBackgroundColor", type="uint", format="Color", inherit="yes", theme="spark")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:rollOverColor
 *   
 *  @default 0xCEDBEF
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Flex 4.5
 */
[Style(name="rollOverColor", type="uint", format="Color", inherit="yes", theme="spark")]

/**
 *  @copy spark.components.List#style:selectionColor
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Flex 4.5
 */
[Style(name="selectionColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

/**
 *  The class to use as the skin for the cursor that indicates that a column
 *  can be resized.
 *  The default value is the <code>cursorStretch</code> symbol from the Assets.swf file.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Style(name="stretchCursor", type="Class", inherit="no")]

/**
 *  @copy spark.components.supportClasses.GroupBase#style:symbolColor
 *   
 *  @default 0x000000
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.0
 *  @productversion Flex 4.5
 */ 
[Style(name="symbolColor", type="uint", format="Color", inherit="yes", theme="spark, mobile")]

// include "../styles/metadata/BasicInheritingTextStyles.as"

/**
 *  The class to use as the item editor, if one is not
 *  specified by a column.  
 *  This style property lets you set
 *  an item editor for a group of DataGrid controls instead of having to
 *  set each one individually.  
 *  The <code>DataGridColumn.itemEditor</code> property supercedes this value.
 *  
 *  @default null
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Style(name="defaultDataGridItemEditor", type="Class", inherit="no")]

/**
 *  Indicates the conditions for which the horizontal scroll bar is displayed.
 * 
 *  <ul>
 *  <li>
 *  <code>ScrollPolicy.ON</code> ("on") - The scroll bar is always displayed.
 *  </li> 
 *  <li>
 *  <code>ScrollPolicy.OFF</code> ("off") - The scroll bar is never displayed.
 *  The viewport can still be scrolled programmatically, by setting its
 *  <code>horizontalScrollPosition</code> property.
 *  </li>
 *  <li>
 *  <code>ScrollPolicy.AUTO</code> ("auto") - The scroll bar is displayed when 
 *  the viewport's <code>contentWidth</code> is larger than its width.
 *  </li>
 *  </ul>
 * 
 *  <p>
 *  The scroll policy affects the measured size of the scroller skin part.  
 *  This style is a reference to the scroller skin part's 
 *  <code>horizontalScrollPolicy</code> style.  
 *  It is not an inheriting style 
 *  Therefor, for example, it will not affect item renderers. </p>
 * 
 *  @default ScrollPolicy.AUTO
 *
 *  @see mx.core.ScrollPolicy
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */ 
[Style(name="horizontalScrollPolicy", type="String", inherit="no", enumeration="off,on,auto")]

/**
 *  Indicates under what conditions the vertical scroll bar is displayed.
 * 
 *  <ul>
 *  <li>
 *  <code>ScrollPolicy.ON</code> ("on") - The scroll bar is always displayed.
 *  </li> 
 *  <li>
 *  <code>ScrollPolicy.OFF</code> ("off") - The scroll bar is never displayed.
 *  The viewport can still be scrolled programmatically, by setting its
 *  <code>verticalScrollPosition</code> property.
 *  </li>
 *  <li>
 *  <code>ScrollPolicy.AUTO</code> ("auto") - The scroll bar is displayed when 
 *  the viewport's <code>contentHeight</code> is larger than its height.
 *  </li>
 *  </ul>
 * 
 *  <p>
 *  The scroll policy affects the measured size of the scroller skin part.  
 *  This style is a reference to the scroller skin part's 
 *  <code>verticalScrollPolicy</code> style.  
 *  It is not an inheriting style 
 *  Therefor, for example, it will not affect item renderers. </p>
 * 
 *  @default ScrollPolicy.AUTO
 *
 *  @see mx.core.ScrollPolicy
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */ 
[Style(name="verticalScrollPolicy", type="String", inherit="no", enumeration="off,on,auto")]

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched by the <code>grid</code> skin part when the caret position, size, or
 *  visibility has changed due to user interaction or being programmatically set.
 *
 *  <p>To handle this event, assign an event handler to the <code>grid</code> skin part 
 *  of the DataGrid control.</p>
 *
 *  @eventType spark.events.GridCaretEvent.CARET_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="caretChange", type="spark.events.GridCaretEvent")]

/**
 *  Dispatched by the <code>grid</code> skin part when the mouse button 
 *  is pressed over a grid cell.
 *
 *  <p>To handle this event, assign an event handler to the <code>grid</code> skin part 
 *  of the DataGrid control.</p>
 *
 *  @eventType spark.events.GridEvent.GRID_MOUSE_DOWN
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="gridMouseDown", type="spark.events.GridEvent")]

/**
 *  Dispatched by the <code>grid</code> skin part after a <code>gridMouseDown</code> event 
 *  if the mouse moves before the button is released.
 *
 *  <p>To handle this event, assign an event handler to the <code>grid</code> skin part 
 *  of the DataGrid control.</p>
 *
 *  @eventType spark.events.GridEvent.GRID_MOUSE_DRAG
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="gridMouseDrag", type="spark.events.GridEvent")]

/**
 *  Dispatched by the <code>grid</code> skin part after a <code>gridMouseDown</code> event 
 *  when the mouse button is released, even if the mouse is no longer within the grid.
 *
 *  <p>To handle this event, assign an event handler to the <code>grid</code> skin part 
 *  of the DataGrid control.</p>
 *
 *  @eventType spark.events.GridEvent.GRID_MOUSE_UP
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="gridMouseUp", type="spark.events.GridEvent")]

/**
 *  Dispatched by the <code>grid</code> skin part when the mouse enters a grid cell.
 *
 *  <p>To handle this event, assign an event handler to the <code>grid</code> skin part 
 *  of the DataGrid control.</p>
 *
 *  @eventType spark.events.GridEvent.GRID_ROLL_OVER
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="gridRollOver", type="spark.events.GridEvent")]

/**
 *  Dispatched by the <code>grid</code> skin part when the mouse leaves a grid cell.
 *
 *  <p>To handle this event, assign an event handler to the <code>grid</code> skin part 
 *  of the DataGrid control.</p>
 *
 *  @eventType spark.events.GridEvent.GRID_ROLL_OUT
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="gridRollOut", type="spark.events.GridEvent")]

/**
 *  Dispatched by the <code>grid</code> skin part when the mouse is clicked over a cell.
 *
 *  <p>To handle this event, assign an event handler to the <code>grid</code> skin part 
 *  of the DataGrid control.</p>
 *
 *  @eventType spark.events.GridEvent.GRID_CLICK
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="gridClick", type="spark.events.GridEvent")]

/**
 *  Dispatched by the <code>grid</code> skin part when the mouse is double-clicked over a cell.
 *
 *  <p>To handle this event, assign an event handler to the <code>grid</code> skin part 
 *  of the DataGrid control.</p>
 *
 *  @eventType spark.events.GridEvent.GRID_DOUBLE_CLICK
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="gridDoubleClick", type="spark.events.GridEvent")]

/**
 *  Dispatched when the selection is going to change.
 *  Calling the <code>preventDefault()</code> method
 *  on the event prevents the selection from changing.
 *  
 *  <p>This event is dispatched when the user interacts with the control.
 *  When you change the selection programmatically, 
 *  the component does not dispatch the <code>selectionChanging</code> event. </p>
 *
 *  @eventType spark.events.GridSelectionEvent.SELECTION_CHANGING
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="selectionChanging", type="spark.events.GridSelectionEvent")]

/**
 *  Dispatched when the selection has changed. 
 *  
 *  <p>This event is dispatched when the user interacts with the control.
 *  When you change the selection programmatically, 
 *  the component does not dispatch the <code>selectionChange</code> event. 
 *  In either case it dispatches the <code>valueCommit</code> event as well.</p>
 *
 *  @eventType spark.events.GridSelectionEvent.SELECTION_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="selectionChange", type="spark.events.GridSelectionEvent")]

/**
 *  Dispatched before the sort has been applied to the data provider's collection.
 *  Typically this is when the user releases the mouse button on a column header
 *  to request the control to sort the grid contents based on the contents of the column.
 *  Only dispatched if the column is sortable and the data provider supports sorting.
 *  
 *  <p>The DataGrid control has a default handler for this event that implements
 *  a single-column sort and updates the <code>visibleSortIndices</code> in the grid's
 *  <code>columnHeaderGroup</code> with the <code>columnIndices</code>.</p>
 * 
 *  <p>Multiple-column sort can be implemented by calling the <code>preventDefault()</code> method 
 *  to prevent the single column sort and setting the <code>columnIndices</code> and 
 *  <code>newSortFields</code> parameters of the event to change the default behavior.
 *  <code>newSortFields</code> should be set to the desired sort fields.
 *  <code>columnIndices</code> should be set to the indices of the columns that should
 *  have a visible sort indicator in the column header bar.</p>
 *   
 *  <p>This event is dispatched when the user interacts with the control.
 *  When you sort the data provider's collection programmatically, 
 *  the component does not dispatch the <code>sortChanging</code> event. </p>
 *
 *  @eventType spark.events.GridSortEvent.SORT_CHANGING
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="sortChanging", type="spark.events.GridSortEvent")]

/**
 *  Dispatched after the sort has been applied to the data provider's collection. 
 *  Typically this is after the user releases the mouse button on a column header and 
 *  the sort has been applied to the data provider's collection. 
 *  
 *  <p>This event is dispatched when the user interacts with the control.
 *  When you sort the data provider's collection programmatically, 
 *  the component does not dispatch the <code>sortChanging</code> event.</p>
 *
 *  @eventType spark.events.GridSortEvent.SORT_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="sortChange", type="spark.events.GridSortEvent")]

//--------------------------------------
//  Edit Events
//--------------------------------------

/**
 *  Dispatched when a new item editor session has been requested. A listener can
 *  dynamically determine if a cell is editable and cancel the edit (by calling
 *  the <code>preventDefault()</code> method) if it is not. 
 *  A listener may also dynamically change the editor used by assigning a 
 *  different item editor to a column.
 * 
 *  <p>If this event is canceled the item editor will not be created.</p>
 *
 *  @eventType spark.events.GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_STARTING
 *  
 *  @see spark.components.DataGrid.itemEditorInstance
 *  @see flash.events.Event
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="gridItemEditorSessionStarting", type="spark.events.GridItemEditorEvent")]

/**
 *  Dispatched immediately after an item editor has been opened. 
 *
 *  @eventType spark.events.GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_START
 *  
 *  @see spark.components.DataGrid.itemEditorInstance
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="gridItemEditorSessionStart", type="spark.events.GridItemEditorEvent")]

/**
 *  Dispatched after the data in item editor has been saved into the data provider
 *  and the editor has been closed.  
 *
 *  @eventType spark.events.GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE
 *  
 *  @see spark.components.DataGrid.itemEditorInstance
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="gridItemEditorSessionSave", type="spark.events.GridItemEditorEvent")]

/**
 *  Dispatched after the item editor has been closed without saving its data.  
 *
 *  @eventType spark.events.GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_CANCEL
 *  
 *  @see spark.components.DataGrid.itemEditorInstance
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 */
[Event(name="gridItemEditorSessionCancel", type="spark.events.GridItemEditorEvent")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[AccessibilityClass(implementation="spark.accessibility.DataGridAccImpl")]

[DefaultProperty("dataProvider")]

[DefaultTriggerEvent("selectionChange")]

[DiscouragedForProfile("mobileDevice")]

//[IconFile("DataGrid.png")]

/**
 *  The DataGrid displays a row of column headings above a scrollable grid. 
 *  The grid is arranged as a collection of individual cells arranged 
 *  in rows and columns. 
 *  The DataGrid control is designed to support smooth scrolling through 
 *  large numbers of rows and columns.
 *
 *  <p>The Spark DataGrid control is implemented as a skinnable wrapper 
 *  around the Spark Grid control. 
 *  The Grid control defines the columns of the data grid, and much of 
 *  the functionality of the DataGrid control itself.</p>
 *
 *  <p>The DataGrid skin is responsible for laying out the grid, column header, and scroller. 
 *  The skin also configures the graphic elements used to render visual elements 
 *  used as indicators, separators, and backgrounds. 
 *  The DataGrid skin also defines a default item renderer, 
 *  used to display the contents of each cell.  
 *  Please see the documentation for the renderer class for the list of supported styles.</p>
 *
 *  <p>Transitions in DataGrid item renderers aren't supported. The GridItemRenderer class 
 *  has disabled its <code>transitions</code> property so setting it will have no effect.</p>
 *
 *  @mxml <p>The <code>&lt;s:DataGrid&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:DataGrid 
 *    <strong>Properties</strong>
 *    columns="null"
 *    dataProvider="null"  
 *    dataTipField="null"  
 *    dataTipFunction="null"
 *    doubleClickMode="row"
 *    editable="false"
 *    editorColumnIndex="-1"
 *    editorRowIndex="-1"
 *    imeMode="null"
 *    itemEditor="null"
 *    itemRenderer="<i>DefaultGridItemRenderer</i>" 
 *    preserveSelection="true"
 *    requestedColumnCount="-1"
 *    requestedMaxRowCount="-1"
 *    requestedMinColumnCount="-1"
 *    requestedMinRowCount="-1"
 *    requestedRowCount="-1"
 *    requireSelection="false"
 *    resizeableColumns="true"
 *    rowHeight="<i>Calculated default</i>"
 *    selectedCell="null"
 *    selectedCells="<i>empty Vector.&lt;CellPosition&gt</i>"
 *    selectedIndex="null"
 *    selectedIndices="<i>empty Vector.&lt;CellPosition&gt</i>"
 *    selectedItem="null"
 *    selectedItems="<i>empty Vector.&lt;Object&gt</i>"
 *    selectionMode="singleRow"
 *    showDataTips="false"
 *    sortableColumns="true"
 *    typicalItem="null"
 *    variableRowHeight="false" 
 * 
 *    <strong>Styles</strong>
 *    alignmentBaseline="useDominantBaseline"
 *    baselineShift="0.0"
 *    cffHinting="horizontalStem"
 *    color="0"
 *    defaultGridItemEditor="null"
 *    digitCase="default"
 *    digitWidth="default"
 *    direction="ltr"
 *    dominantBaseline="auto"
 *    fontFamily="Arial"
 *    fontLookup="device"
 *    fontSize="12"
 *    fontStyle="normal"
 *    fontWeight="normal"
 *    justificationRule="auto"
 *    justificationStyle="auto"
 *    kerning="auto"
 *    ligatureLevel="common"
 *    lineHeight="120%"
 *    lineThrough="false"
 *    locale="en"
 *    renderingMode="cff"
 *    stretchCursor="<i>cursorStretch symbol from Assets.swf</i>"
 *    textAlign="start"
 *    textAlignLast="start"
 *    textAlpha="1"
 *    textDecoration="none"
 *    textJustify="interWord"
 *    trackingLeft="0"
 *    trackingRight="0"
 *    typographicCase="default"
 *    verticalScrollPolicy="auto"
 *
 *    <strong>Styles for the Spark Theme</strong>
 *    alternatingRowColors="undefined"
 *    borderAlpha="1.0"
 *    borderColor="0x696969"
 *    borderVisible="true"
 *    caretColor="0x0167FF"
 *    contentBackgroundAlpha="1.0"
 *    contentBackgroundColor="0xFFFFFF"
 *    rollOverColor="0xCEDBEF"
 *    selectionColor="0xA8C6EE"
 *    symbolColor="0x000000"
 * 
 *    <strong>Styles for the Mobile Theme</strong>
 *    leading="0"
 *    letterSpacing="0"
 *    selectionColor="0xE0E0E0"
 *    symbolColor="0x000000"
 * 
 *    <strong>Events</strong>
 *    caretChange="<i>No default</i>"
 *    gridClick="<i>No default</i>"
 *    gridDoubleClick="<i>No default</i>"
 *    gridItemEditorSessionCancel="<i>No default</i>"
 *    gridItemEditorSessionSave="<i>No default</i>"
 *    gridItemEditorSessionStart="<i>No default</i>"
 *    gridItemEditorSessionStarting="<i>No default</i>"
 *    gridMouseDown="<i>No default</i>"
 *    gridMouseDrag="<i>No default</i>"
 *    gridMouseUp="<i>No default</i>"
 *    gridMouseRollOut="<i>No default</i>"
 *    gridMouseRollOver="<i>No default</i>"
 *    selectionChange="<i>No default</i>"
 *    selectionChanging="<i>No default</i>"
 *    sortChange="<i>No default</i>"
 *    sortChanging="<i>No default</i>" 
 *  /&gt;
 *  </pre>
 *
 *  @see spark.components.Grid
 *  @see spark.components.gridClasses.GridColumn
 *  @see spark.skins.spark.DataGridSkin
 *  @see spark.skins.spark.DefaultGridItemRenderer
 *  
 *  @includeExample examples/DataGridSimpleExample.mxml
 *  @includeExample examples/DataGridMasterDetailExample.mxml
 *  @includeExample examples/DataGridTypicalItemExample.mxml
 *  @includeExample examples/DataGridRowHeightExample.mxml
 *  @includeExample examples/DataGridSelectionExample.mxml
 *  @includeExample examples/DataGridInvalidateCellExample.mxml
 *  @includeExample examples/DataGridLockedRowsAndColumnsExample.mxml
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 2.5
 *  @productversion Flex 4.5
 * 
 *  @royalesuppresspublicvarwarning
 */  
public class DataGrid extends SkinnableContainerBase 
    implements IDataProviderEnhance, IFocusManagerComponent, IIMESupport
{
    // include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Placeholder for mixin by DataGridAccImpl.
     */
    mx_internal static var createAccessibilityImplementation:Function;
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function DataGrid()
    {
        super();
        
        //addEventListener(Event.SELECT_ALL, selectAllHandler);
        //addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChangeHandler, false, EventPriority.DEFAULT_HANDLER);        
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  True, when the hover indicator should be updated on a ROLL_OVER event.
     *  If the mouse button is depressed while outside of the grid, the hover 
     *  indicator is not enabled again until MOUSE_UP or ROLL_OUT. 
     */
    private var updateHoverOnRollOver:Boolean = true;
    
    //--------------------------------------------------------------------------
    //
    //  Drag and Drop Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  The point where the mouse down event was received.
     *  Used to track whether a drag operation should be initiated when the user
     *  drags further than a certain threshold. 
     */
    private var mouseDownPoint:Point;
    
    /**
     *  @private
     *  The index of the element the mouse down event was received for. Used to
     *  track which is the "focus item" for a drag and drop operation.
     */
    private var mouseDownRowIndex:int = -1;
    
    /**
     *  @private
     *  The index of the element the mouse down event was received for. Used to
     *  track which is the "focus item" for a drag and drop operation.
     */
    private var mouseDownColumnIndex:int = -1;
    
    /**
     *  @private
     *  The displayObject where the mouse down event was received.
     *  In touch interactionMode, used to track whether this item is 
     *  the one that is moused up on so we can possibly select it. 
     */
    // private var mouseDownObject:DisplayObject;
    
    /**
     *  @private
     *  When dragging is enabled with multiple selection, the selection is not
     *  comitted immediately on mouse down, but we wait to see whether the user
     *  intended to start a drag gesture instead. In that case we postpone
     *  comitting the selection until mouse up.
     */
    private var pendingSelectionOnMouseUp:Boolean = false;

    
    //--------------------------------------------------------------------------
    //
    //  Skin Parts
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private 
     *  IFactory valued skin parts that require special handling, see findSkinParts().
     */
    private static const factorySkinPartNames:Array = [
        "alternatingRowColorsBackground",
        "caretIndicator",
        "columnSeparator",
        "headerColumnSeparator",        
        "hoverIndicator",
        "lockedRowsSeparator",
        "lockedColumnsSeparator",
        "rowBackground",
        "rowSeparator",
        "selectionIndicator"];
    
    //----------------------------------
    //  alternatingRowColorsBackground
    //----------------------------------
    
    [Bindable]
    [SkinPart(required="false", type="mx.core.IVisualElement")]
    
    /**
     *  The IVisualElement class used to render the <code>alternatingRowColors</code> style.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public var alternatingRowColorsBackground:IFactory;
    
    //----------------------------------
    //  caretIndicator
    //----------------------------------
    
    [Bindable]
    [SkinPart(required="false", type="mx.core.IVisualElement")]
    
    /**
     *  The IVisualElement class used to render the grid's caret indicator.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public var caretIndicator:IFactory;
    
    //----------------------------------
    //  columnHeaderGroup
    //----------------------------------
    
    [Bindable]
    [SkinPart(required="false")]
    
    /**
     *  A reference to the GridColumnHeaderGroup object that displays the column headers.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    // public var columnHeaderGroup:GridColumnHeaderGroup;    
    
    //----------------------------------
    //  columnSeparator
    //----------------------------------
    
    [Bindable]
    [SkinPart(required="false", type="mx.core.IVisualElement")]
    
    /**
     *  The IVisualElement class used to render the vertical separator between columns. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public var columnSeparator:IFactory;
    
    //----------------------------------
    //  dropIndicator
    //----------------------------------
    
    [SkinPart(required="false", type="flash.display.DisplayObject")]
    
    /**
     *  The IVisualElement class that defines the appearance of the drop indicator. 
     *  The drop indicator is resized and positioned by the layout to indicate 
     *  in between which grid rows the drop will insert the drag source item.
     * 
     *  <p>This is a dynamic skin part: it's created as needed and then destroyed.</p>
     * 
     *  <p>The DataGrid will set the dropIndicator's height to its 
     *  preferred height bracketed by its minHeight and maxHeight values.
     *  Its width will be unconditionally set to the grid's visible width.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */    
    public var dropIndicator:IFactory; 
    
    //----------------------------------
    //  editorIndicator
    //----------------------------------
    
    [Bindable]
    [SkinPart(required="false", type="mx.core.IVisualElement")]
    
    /**
     *  The IVisualElement class used to render a background behind
     *  item renderers that are being edited. 
     *  Item renderers may only be edited
     *  when the data grid and the column are both editable and the
     *  column sets <code>rendererIsEditable</code> to <code>true</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public var editorIndicator:IFactory;
    
    //----------------------------------
    //  grid
    //----------------------------------
    
    [Bindable]
    [SkinPart(required="false")]
    
    /**
     *  A reference to the Grid control that displays row and columns.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public var grid:Grid;
    
    //----------------------------------
    //  hoverIndicator
    //----------------------------------
    
    [Bindable]
    [SkinPart(required="false", type="mx.core.IVisualElement")]
    
    /**
     *  The IVisualElement class used to provide hover feedback.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public var hoverIndicator:IFactory;
    
    //----------------------------------
    //  lockedColumnsSeparator
    //----------------------------------
    
    [Bindable]
    [SkinPart(required="false", type="mx.core.IVisualElement")]
    
    /**
     *  The IVisualElement class used to render the vertical separator between locked and unlocked columns.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 5.0
     */
    public var lockedColumnsSeparator:IFactory; 
    
    //----------------------------------
    //  lockedRowsSeparator
    //----------------------------------
    
    [Bindable]
    [SkinPart(required="false", type="mx.core.IVisualElement")]
    
    /**
     *  The IVisualElement class used to render the horizontal separator between locked and unlocked rows.
     */
    public var lockedRowsSeparator:IFactory;    
    
    //----------------------------------
    //  rowBackground
    //----------------------------------
    
    [Bindable]
    [SkinPart(required="false", type="mx.core.IVisualElement")]
    
    /**
     *  The IVisualElement class used to render the background of each row.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public var rowBackground:IFactory;        
    
    //----------------------------------
    //  rowSeparator
    //----------------------------------
    
    [Bindable]
    [SkinPart(required="false", type="mx.core.IVisualElement")]
    
    /**
     *  The IVisualElement class used to render the horizontal separator between header rows. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public var rowSeparator:IFactory;
    
    //----------------------------------
    //  scroller
    //----------------------------------
    
    [Bindable]
    [SkinPart(required="false")]
    
    /**
     *  A reference to the Scroller control in the skin class 
     *  that adds scroll bars to the DataGrid control.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public var scroller:Scroller;    
    
    //----------------------------------
    //  selectionIndicator
    //----------------------------------
    
    [Bindable]
    [SkinPart(required="false", type="mx.core.IVisualElement")]
    
    /**
     *  The IVisualElement class used to render selected rows or cells.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public var selectionIndicator:IFactory;
    
    /**
     *  @private
     *  If the alternatingRowColors style is set AND the alternatingRowColorsBackground
     *  skin part has been added AND the grid skin part has been added, then set
     *  grid.rowBackground = alternatingRowColorsBackground here.   Otherwise just
     *  set it to the value of the rowBackground skin part (property).
     */
    private function initializeGridRowBackground():void
    {
        if (!grid)
            return;
        
        if ((getStyle("alternatingRowColors") as Array) && alternatingRowColorsBackground)
            grid.rowBackground = alternatingRowColorsBackground;
        else
            grid.rowBackground = rowBackground;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Skin Part Property Internals
    //
    //-------------------------------------------------------------------------- 
    
    /**
     *  @private
     *  A list of functions to be applied to the grid skin part at partAdded() time.
     *  This list is used to defer making grid selection updates per the set methods for
     *  the selectedIndex, selectedIndices, selectedItem, selectedItems, selectedCell
     *  and selectedCells properties.
     */
    private const deferredGridOperations:Vector.<Function> = new Vector.<Function>();
    
    /**
     *  @private
     *  Defines one bit for each skin part property that's covered by DataGrid.  Currently
     *  there are only grid properties.
     */
    private static const partPropertyBits:Object = {
        columns: uint(1 << 0),
        dataProvider: uint(1 << 1),
        itemRenderer: uint(1 << 2),
        requestedRowCount: uint(1 << 3),
        requestedColumnCount: uint(1 << 4),
        requestedMaxRowCount: uint(1 << 5),
        requestedMinRowCount: uint(1 << 6),
        requestedMinColumnCount: uint(1 << 7),
        rowHeight: uint(1 << 8),
        showDataTips: uint(1 << 9),
        typicalItem: uint(1 << 10),
        variableRowHeight: uint(1 << 11),
        dataTipField: uint(1 << 12),
        dataTipFunction: uint(1 << 13),
        resizableColumns: uint(1 << 14),
        lockedColumnCount: uint(1 << 15),
        lockedRowCount: uint(1 << 16)
    };
    
    /**
     *  @private
     *  If the grid skin part hasn't been added, this var is an object whose properties
     *  temporarily record the values of DataGrid properties that just "cover" grid skin
     *  part properties. 
     * 
     *  If the grid skin part has been added (is non-null), then this var has 
     *  a single is a uint bitmask property called propertyBits that's used
     *  used to track which grid properties have been explicitly set.
     *  
     *  See getPartProperty(), setPartProperty().
     */
    private var gridProperties:Object = {};
    
    /**
     *  @private
     *  The default values of the grid skin part properties covered by DataGrid.
     */
    private static const gridPropertyDefaults:Object = {
        columns: null,
        dataProvider: null,
        itemRenderer: null,
        resizableColumns: true,
        requestedRowCount: int(-1),
        requestedMaxRowCount: int(10),        
        requestedMinRowCount: int(-1),
        requestedColumnCount: int(-1),
        requestedMinColumnCount: int(-1),
        rowHeight: NaN,
        showDataTips: false,
        typicalItem: null,
        variableRowHeight: false,
        dataTipField: null,
        dataTipFunction: null,
        lockedColumnCount: int(0),
        lockedRowCount: int(0)
    };
    
    /** 
     *  @private
     *  A utility method for looking up a skin part property that accounts for the possibility that
     *  the skin part is null.  It's intended to be used in the definition of properties that just
     *  "cover" skin part properties.
     * 
     *  If part is non-null, then return part[propertyName].  Otherwise return the value
     *  of properties[propertyName], or defaults[propertyName] if the specified property's 
     *  value is undefined.
     */
    private static function getPartProperty(part:Object, properties:Object, propertyName:String, defaults:Object):*
    {
        if (part)
            return part[propertyName];
        
        const value:* = properties[propertyName];
        return (value === undefined) ? defaults[propertyName] : value;
    }
    
    /** 
     *  @private
     *  A utility method for setting a skin part property that accounts for the possibility that
     *  the skin part is null.  It's intended to be used in the definition of properties that just
     *  "cover" skin part properties.
     * 
     *  Return true if the property's value was changed.
     * 
     *  If part is non-null, then set part[propertyName], otherwise set properties[propertyName].  
     * 
     *  If part is non-null then we set the bit for this property on the properties.propertyBits, to record
     *  the fact that the DataGrid cover property was explicitly set.
     * 
     *  In either case we treat setting a property to its default value specially: the effect
     *  is as if the property was never set at all.
     */
    private static function setPartProperty(part:Object, properties:Object, propertyName:String, value:*, defaults:Object):Boolean
    {
        if (getPartProperty(part, properties, propertyName, defaults) === value)
            return false;
        
        const defaultValue:* = defaults[propertyName];
        
        if (part)
        {
            part[propertyName] = value;
            if (value === defaultValue)
                properties.propertyBits &= ~partPropertyBits[propertyName];
            else
                properties.propertyBits |= partPropertyBits[propertyName];
        }
        else
        {
            if (value === defaultValue)
                delete properties[propertyName];
            else
                properties[propertyName] = value;
        }
        
        return true;
    }
    
    /**
     *  @private
     *  Return the specified grid property.
     */
    private function getGridProperty(propertyName:String):*
    {
        return getPartProperty(grid, gridProperties, propertyName, gridPropertyDefaults);
    }
    
    /**
     *  @private
     *  Set the specified grid property and return true if the property actually changed.
     */
    private function setGridProperty(propertyName:String, value:*):Boolean
    {
        return setPartProperty(grid, gridProperties, propertyName, value, gridPropertyDefaults);
    }    
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /** 
     *  @private
     *  Maximum time in milliseconds between a click and a double click.
     */ 
    mx_internal var doubleClickTime:Number = 620;
    
    /** 
     *  @private
     *  Key used to start editting a cell.
     */ 
    mx_internal var editKey:uint = Keyboard.F2;
    
    /** 
     *  @private
     *  A cell editor is initiated by a single click on a selected cell. 
     *  If this variable is true then also open an editor when a cell is 
     *  double clicked, otherwise cancel the edit.
     */ 
    mx_internal var editOnDoubleClick:Boolean = false;
    
    /** 
     *  @private
     *  Provides all the logic to start and end item
     *  editor sessions.
     *
     *  Create your own editor by overriding the <code>createEditor()</code> 
     *  method. 
     */ 
    mx_internal var editor:DataGridEditor;
    
    //--------------------------------------------------------------------------
    //
    //  Properties 
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    private function dispatchChangeEvent(type:String):void
    {
        if (hasEventListener(type))
            dispatchEvent(new Event(type));
    }
    
    /**
     *  @private
     */
    private function dispatchFlexEvent(type:String):void
    {
        if (hasEventListener(type))
            dispatchEvent(new FlexEvent(type));
    }
    
    //----------------------------------
    //  columns (delegates to grid.columns)
    //----------------------------------
    
    [Bindable("columnsChanged")]
    [Inspectable(category="General")]
    
    /**
     *  @copy spark.components.Grid#columns
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get columns():IList
    {
        return getGridProperty("columns");
    }
    
    /**
     *  @private
     */
    public function set columns(value:IList):void
    {
        if (setGridProperty("columns", value))
        {
            /*if (columnHeaderGroup)
            {
                columnHeaderGroup.layout.clearVirtualLayoutCache();
                columnHeaderGroup.invalidateSize();
                columnHeaderGroup.invalidateDisplayList();
            }*/
            
            dispatchChangeEvent("columnsChanged");
        }
    }
    
    /**
     *  @private
     */
    private function getColumnAt(columnIndex:int):GridColumn
    {
        const grid:Grid = grid;
        if (!grid || !grid.columns)
            return null;
        
        const columns:IList = grid.columns;
        return ((columnIndex >= 0) && (columnIndex < columns.length)) ? columns.getItemAt(columnIndex) as GridColumn : null;
    }
    
    //----------------------------------
    //  columnsLength
    //---------------------------------- 
    
    /**
     *  Returns the value of <code>columns.length</code> if the columns IList
     *  was specified, otherwise 0.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5*
     */
    public function get columnsLength():int
    {
        const columns:IList = columns;
        return (columns) ? columns.length : 0;
    }    
    
    //----------------------------------
    //  dataProvider (delegates to grid.dataProvider)
    //----------------------------------
    
    [Bindable("dataProviderChanged")]
    [Inspectable(category="Data")]
    
    /**
     *  @copy spark.components.Grid#dataProvider
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get dataProvider():IList
    {
        return getGridProperty("dataProvider");
    }
    
    /**
     *  @private
     */
	public function set dataProvider(value:IList):void
    {
        if (setGridProperty("dataProvider", value))
            dispatchChangeEvent("dataProviderChanged");
    }
    
    //----------------------------------
    //  dataProviderLength
    //---------------------------------- 
    
    /**
     *  Returns the value of <code>dataProvider.length</code> if the dataProvider IList
     *  was specified, otherwise 0.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get dataProviderLength():int
    {
        const dataProvider:IList = dataProvider;
        return (dataProvider) ? dataProvider.length : 0;
    }       
    
    //----------------------------------
    //  dataTipField (delegates to grid.dataTipField)
    //----------------------------------    
    
    [Bindable("dataTipFieldChanged")]
    [Inspectable(category="Data", defaultValue="null")]
    
    /**
     *  @copy spark.components.Grid#dataTipField
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get dataTipField():String
    {
        return getGridProperty("dataTipField");
    }
    
    /**
     *  @private
     */
    public function set dataTipField(value:String):void
    {
        if (setGridProperty("dataTipField", value))
            dispatchChangeEvent("dataTipFieldChanged");
    } 
    
    //----------------------------------
    //  dataTipFunction (delegates to grid.dataTipFunction)
    //----------------------------------    
    
    [Bindable("dataTipFunctionChanged")]
    [Inspectable(category="Data")]
    
    /**
     *  @copy spark.components.Grid#dataTipFunction
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get dataTipFunction():Function
    {
        return getGridProperty("dataTipFunction");
    }
    
    /**
     *  @private
     */
    public function set dataTipFunction(value:Function):void
    {
        if (setGridProperty("dataTipFunction", value))
            dispatchChangeEvent("dataTipFunctionChanged");
    }


    //----------------------------------
    //  doubleClickMode
    //----------------------------------

    [Bindable("doubleClickModeChanged")]
    [Inspectable(category="General", enumeration="cell,grid,row", defaultValue="row")]

    /**
    *  @copy spark.components.Grid#doubleClickMode
    *
    *  @default GridDoubleClickMode.ROW
    * 
    *  @see spark.components.gridClasses.GridDoubleClickMode
    * 
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Flex 4.10
    */
    public function get doubleClickMode():String
    {
        return grid.doubleClickMode;
    }

    /**
    *  @private
    */
    public function set doubleClickMode(newValue:String):void
    {
        if (setGridProperty("doubleClickMode", newValue))
        {
            dispatchChangeEvent("doubleClickModeChanged");
        }
    }


    //----------------------------------
    //  draggableColumns
    //----------------------------------
    
    private var _draggableColumns:Boolean = false;
    
    [Inspectable(category="General", defaultValue="false")]
    [Bindable("draggableColumnsChanged")]    
    
    /**
     * 
     *  @langversion 3.0
     *  @playerversion Flash 1
     *  @playerversion AIR 2.5
     *  @productversion Flex 5.0
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
        if (value == _draggableColumns)
            return;
        
        _draggableColumns = value;
        dispatchChangeEvent("draggableColumnsChanged");        
    }
    
    //----------------------------------
    //  editable
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the editable property.
     */
    private var _editable:Boolean = false;
    
    [Inspectable(category="General", defaultValue="false")]
    
    /**
     *  A flag which enables editing the data items in the DataGrid.
     *  If <code>true</code> and <code>selectionMode</code> is not equal to "none", clicking on 
     *  a cell opens an item editor.
     *  
     *  <p>You can disable editing for individual columns of the DataGrid control using the
     *  GridColumn <code>editable</code> property.
     *  By default, all visible columns are editable.</p>
     * 
     *  <p>You can enable or disable editing per cell (rather than per column) 
     *  by handling the <code>startItemEditorSession</code> event.
     *  In the event handler, add the necessary logic to determine 
     *  if the cell should be editable.</p>  
     * 
     *  @default false
     *  
     *  @see #selectionMode
     *  @see spark.components.gridClasses.GridColumn#editable
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
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
    //  editorActivationMouseEvent
    //----------------------------------
    
    private var _editorActivationMouseEvent:String = GridItemEditorActivationMouseEvent.SINGLE_CLICK_ON_SELECTED_CELL;
    
    [Bindable("editorActivationMouseEventChanged")]
    [Inspectable(category="General", enumeration="doubleClick,none,singleClick,singleClickOnSelectedCell", defaultValue="singleClickOnSelectedCell")]
    
    /**
     *  The type of mouse event that starts an editor session. Must be one of
     *  values in <code>GridItemEditorMouseEvent</code>. This value 
     *  provides a default value for each column of a DataGrid. A different
     *  value can be specified on a grid column to override the default.
     *       
     *  @default "singleClickOnSelectedCell"
     * 
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    public function get editorActivationMouseEvent():String
    {
        return _editorActivationMouseEvent;
    }
    
    /**
     *  @private
     */
    public function set editorActivationMouseEvent(value:String):void
    {
        if (_editorActivationMouseEvent == value)
            return;
        
        _editorActivationMouseEvent = value;
        dispatchChangeEvent("editorActivationMouseEventChanged");
    }
    
    //----------------------------------
    //  editorColumnIndex
    //----------------------------------
    
    /**
     *  The zero-based column index of the cell that is being edited.  
     *  The value is -1 if no cell is being edited.
     * 
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get editorColumnIndex():int
    {
        if (editor)
            return editor.editorColumnIndex;
        
        return -1;
    }
    
    //----------------------------------
    //  editorRowIndex
    //----------------------------------
    
    /**
     *  The zero-based row index of the cell that is being edited.  
     *  The value is -1 if no cell is being edited.
     * 
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get editorRowIndex():int
    {
        if (editor)
            return editor.editorRowIndex;
        
        return -1;
    }
    
    //----------------------------------
    //  enableIME
    //----------------------------------
    
    /**
     *  A flag that indicates whether the IME should
     *  be enabled when the component receives focus.
     *
     *  If the item editor is open, it sets this property 
     *  accordingly.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get enableIME():Boolean
    {
        return false;
    }


    //----------------------------------
    //  isFirstRow
    //----------------------------------

    /**
    *  @copy spark.components.Grid#isFirstRow
    *  If a <code>grid</code> is not assigned, will always return false;
    *
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Flex 4.10
    */
    public function get isFirstRow():Boolean
    {
        if (grid)
        {
            return grid.isFirstRow;
        }
        else
        {
            return false;
        }
    }


    //----------------------------------
    //  isLastRow
    //----------------------------------

    /**
    *  @copy spark.components.Grid#isLastRow
    *  If a <code>grid</code> is not assigned, will always return false;
    *
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Flex 4.10
    */
    public function get isLastRow():Boolean
    {
        if (grid)
        {
            return grid.isLastRow;
        }
        else
        {
            return false;
        }
    }


    //----------------------------------
    //  multiColumnSortingEnabled
    //----------------------------------
    
    private var _multiColumnSortingEnabled:Boolean = false;
    
    [Bindable("multiColumnSortingEnabledChanged")]
    [Inspectable(category="General", defaultValue="false")]
    
    /**
     *  If this property is true and sorting has been enabled, then users can interactively 
     *  specify multi-column sorts by control-clicking in column headers (Command+Click on OSX).  
     *  Sorting is enabled for a column if the DataGrid <code>sortable</code> property is true
     *  and the column's <code>sortable</code> property is true.   Sorting is enabled for
     *  all columns by default, multi-column sorting is not.
     * 
     *  @default false
     * 
     *  @see #sortableColumns
     *  @see spark.components.gridClasses.GridColumn#sortable

     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get multiColumnSortingEnabled():Boolean
    {
        return _multiColumnSortingEnabled;
    }
    
    /**
     *  @private
     */    
    public function set multiColumnSortingEnabled(value:Boolean):void
    {
        if (_multiColumnSortingEnabled == value)
            return;
        
        _multiColumnSortingEnabled = value;
        dispatchChangeEvent("multiColumnSortingEnabledChanged");
    }        
    
    //----------------------------------
    //  gridSelection (private)
    //----------------------------------    
    
    private var _gridSelection:GridSelection = null;
    
    /**
     *  @private
     *  This object becomes the grid's gridSelection property after the grid skin part has been
     *  added.  It should only be referenced by this class when the grid skin part is null. 
     */
    protected function get gridSelection():GridSelection
    {
        if (!_gridSelection)
            _gridSelection = createGridSelection();
        return _gridSelection;
    }
    
    //----------------------------------
    //  imeMode
    //----------------------------------
    
    /**
     *  @private
     */
    private var _imeMode:String = null;
    
    [Inspectable(environment="none")]
    
    /**
     *  The default value for the GridColumn <code>imeMode</code> property, 
     *  which specifies the IME (Input Method Editor) mode.
     *  The IME enables users to enter text in Chinese, Japanese, and Korean.
     *  Flex sets the specified IME mode when the control gets focus,
     *  and sets it back to the previous value when the control loses focus.
     *
     * <p>The flash.system.IMEConversionMode class defines constants for the
     *  valid values for this property.
     *  You can also specify <code>null</code> to specify no IME.</p>
     *
     *  @see flash.system.IMEConversionMode
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get imeMode():String
    {
        return _imeMode;
    }
    
    /**
     *  @private
     */
    public function set imeMode(value:String):void
    {
        _imeMode = value;
    }
    
    //----------------------------------
    //  internalFocusOwner
    //----------------------------------
    
    private static const GRID_FOCUS_OWNER:int = 0;
    private static const HEADER_FOCUS_OWNER:int = 1;
    private static const NO_FOCUS_OWNER:int = -1;
    
    private var _internalFocusOwner:int = -1;
    
    [Bindable("internalFocusOwnerChanged")]
    
    /**
     *  Tracks the internal focus owner when the DataGrid has the focus: one of GRID_FOCUS_OWNER, 
     *  HEADER_FOCUS_OWNER, or NO_FOCUS_OWNER.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5 
     */
    private function get internalFocusOwner():int
    {
        return _internalFocusOwner;
    }
    
    /**
     *  @private
     */
    private function set internalFocusOwner(value:int):void
    {
        if (_internalFocusOwner == value)
            return;
        
        _internalFocusOwner = value;
        
        /*if (columnHeaderGroup)
            columnHeaderGroup.highlightSelectedColumn = (value == HEADER_FOCUS_OWNER);*/
        
        if (grid)
            grid.showCaret = (value == GRID_FOCUS_OWNER); 
        
        dispatchChangeEvent("internalFocusOwnerChanged");
    }     
    
    //----------------------------------
    //  itemEditor
    //----------------------------------
    
    private var _itemEditor:IFactory = null;
    
    [Bindable("itemEditorChanged")]
    
    /**
     *  The default value for the GridColumn <code>itemEditor</code> property, 
     *  which specifies the IGridItemEditor class used to create item editor instances.
     * 
     *  @default null.
     *
     *  @see spark.components.gridClasses.GridColumn#dataField
     *  @see spark.components.gridClasses.IGridItemEditor
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5 
     */
    public function get itemEditor():IFactory
    {
        return _itemEditor;
    }
    
    /**
     *  @private
     */
    public function set itemEditor(value:IFactory):void
    {
        if (_itemEditor == value)
            return;
        
        _itemEditor = value;
        
        dispatchChangeEvent("itemEditorChanged");
    }    
    
    /**
     *  A reference to the currently active instance of the item editor, 
     *  if it exists.
     *
     *  <p>To access the item editor instance and the new item value when an 
     *  item is being edited, you use the <code>itemEditorInstance</code> 
     *  property. The <code>itemEditorInstance</code> property
     *  is not valid until the <code>itemEditorSessionStart</code> event is 
     *  dispatched.</p>
     *
     *  <p>The <code>DataGridColumn.itemEditor</code> property defines the
     *  class of the item editor and, therefore, the data type of the item
     *  editor instance.</p>
     *
     *  <p>Do not set this property in MXML.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get itemEditorInstance():IGridItemEditor
    {
        if (editor)
            return editor.itemEditorInstance;
        
        return null; 
    }
    
    //----------------------------------
    //  itemRenderer (delegates to grid.itemRenderer)
    //----------------------------------    
    
    [Bindable("itemRendererChanged")]
    [Inspectable(category="Data")]
    
    /**
     *  @copy spark.components.Grid#itemRenderer
     *
     *  @default DefaultGridItemRenderer
     *
     *  @see spark.components.gridClasses.GridItemRenderer
     *  @see spark.skins.spark.DefaultGridItemRenderer
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
	public function get itemRenderer():IFactory
    {
        return getGridProperty("itemRenderer");
    }
    
    /**
     *  @private
     */
	public function set itemRenderer(value:IFactory):void
    {
        if (setGridProperty("itemRenderer", value))
            dispatchChangeEvent("itemRendererChanged");
    }
    
    //----------------------------------
    //  lockedColumnCount (delegates to grid.lockedColumnCount)
    //---------------------------------- 
    
    [Bindable("lockedColumnCountChanged")]
    [Inspectable(category="General", defaultValue="0", minValue="0")]
    
    /**
     *  @copy spark.components.Grid#lockedColumnCount
     *
     *  @default 0
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 5.0
     */
    public function get lockedColumnCount():int
    {
        return getGridProperty("lockedColumnCount");
    }
    
    /**
     *  @private
     */
    public function set lockedColumnCount(value:int):void
    {
        if (setGridProperty("lockedColumnCount", value))
            dispatchChangeEvent("lockedColumnCountChanged");
    }
    
    //----------------------------------
    //  lockedRowCount (delegates to grid.lockedRowCount)
    //----------------------------------    
    
    [Bindable("lockedRowCountChanged")]
    [Inspectable(category="General", defaultValue="0", minValue="0")]
    
    /**
     *  @copy spark.components.Grid#lockedRowCount
     *
     *  @default 0
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 5.0
     */
    public function get lockedRowCount():int
    {
        return getGridProperty("lockedRowCount");
    }
    
    /**
     *  @private
     */
    public function set lockedRowCount(value:int):void
    {
        if (setGridProperty("lockedRowCount", value))
            dispatchChangeEvent("lockedRowCountChanged");
    }    
    
    //----------------------------------
    //  preserveSelection (delegates to grid.preserveSelection)
    //----------------------------------
    
    [Inspectable(category="General", defaultValue="true")]
    
    /**
     *  @copy spark.components.Grid#preserveSelection
     *
     *  @default true
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get preserveSelection():Boolean
    {
        if (grid)
            return grid.preserveSelection;
        else
            return gridSelection.preserveSelection;
    }
    
    /**
     *  @private
     */    
    public function set preserveSelection(value:Boolean):void
    {
        if (grid)
            grid.preserveSelection = value;
        else
            gridSelection.preserveSelection = value;
    }
    
    //----------------------------------
    //  requireSelection (delegates to grid.requireSelection)
    //----------------------------------
    
    [Inspectable(category="General", defaultValue="false")]
    
    /**
     *  @copy spark.components.Grid#requireSelection
     *
     *  @default false
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get requireSelection():Boolean
    {
        if (grid)
            return grid.requireSelection;
        else
            return gridSelection.requireSelection;
    }
    
    /**
     *  @private
     */    
    public function set requireSelection(value:Boolean):void
    {
        if (grid)
            grid.requireSelection = value;
        else
            gridSelection.requireSelection = value;
    }
    
    //----------------------------------
    //  requestedRowCount (delegates to grid.requestedRowCount)
    //----------------------------------
    
    [Inspectable(category="General", minValue="-1")]
    
    /**
     *  @copy spark.components.Grid#requestedRowCount
     *
     *  @default -1
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get requestedRowCount():int
    {
        return getGridProperty("requestedRowCount");
    }
    
    /**
     *  @private
     */    
    public function set requestedRowCount(value:int):void
    {
        setGridProperty("requestedRowCount", value);
    }
    
    //----------------------------------
    //  requestedColumnCount (delegates to grid.requestedColumnCount)
    //----------------------------------
    
    [Inspectable(category="General", minValue="-1")]
    
    /**
     *  @copy spark.components.Grid#requestedColumnCount
     *
     *  @default -1
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get requestedColumnCount():int
    {
        return getGridProperty("requestedColumnCount");
    }
    
    /**
     *  @private
     */    
    public function set requestedColumnCount(value:int):void
    {
        setGridProperty("requestedColumnCount", value);
    }
    
    //----------------------------------
    //  requestedMaxRowCount (delegates to grid.requestedMaxRowCount)
    //----------------------------------
    
    [Inspectable(category="General", defaultValue="10", minValue="-1")]
    
    /**
     *  @copy spark.components.Grid#requestedMaxRowCount
     *
     *  @default 10
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get requestedMaxRowCount():int
    {
        return getGridProperty("requestedMaxRowCount");
    }
    
    /**
     *  @private
     */    
    public function set requestedMaxRowCount(value:int):void
    {
        setGridProperty("requestedMaxRowCount", value);
    }    
    
    //----------------------------------
    //  requestedMinRowCount (delegates to grid.requestedMinRowCount)
    //----------------------------------
    
    [Inspectable(category="General", minValue="-1")]
    
    /**
     *  @copy spark.components.Grid#requestedMinRowCount
     *
     *  @default -1
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get requestedMinRowCount():int
    {
        return getGridProperty("requestedMinRowCount");
    }
    
    /**
     *  @private
     */    
    public function set requestedMinRowCount(value:int):void
    {
        setGridProperty("requestedMinRowCount", value);
    }
    
    //----------------------------------
    //  requestedMinColumnCount (delegates to grid.requestedMinColumnCount)
    //----------------------------------
    
    [Inspectable(category="General", minValue="-1")]
    
    /**
     *  @copy spark.components.Grid#requestedMinColumnCount
     *
     *  @default -1
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get requestedMinColumnCount():int
    {
        return getGridProperty("requestedMinColumnCount");
    }
    
    /**
     *  @private
     */    
    public function set requestedMinColumnCount(value:int):void
    {
        setGridProperty("requestedMinColumnCount", value);
    }
    
    //----------------------------------
    //  resizableColumns (delegates to grid.resizableColumns)
    //----------------------------------
    
    [Bindable("resizableColumnsChanged")]
    [Inspectable(category="General", defaultValue="true")]
    
    /**
     *  @copy spark.components.Grid#resizableColumns
     *
     *  @default true
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get resizableColumns():Boolean
    {
        return getGridProperty("resizableColumns");
    }
    
    /**
     *  @private
     */    
    public function set resizableColumns(value:Boolean):void
    {
        if (setGridProperty("resizableColumns", value))
            dispatchChangeEvent("resizableColumnsChanged");
    }        
    
    //----------------------------------
    //  rowHeight (delegates to grid.rowHeight)
    //----------------------------------
    
    [Bindable("rowHeightChanged")]
    [Inspectable(category="General", minValue="0.0")]
    
    /**
     *  @copy spark.components.Grid#rowHeight
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get rowHeight():Number
    {
        return getGridProperty("rowHeight");
    }
    
    /**
     *  @private
     */    
    public function set rowHeight(value:Number):void
    {
        if (setGridProperty("rowHeight", value))
            dispatchChangeEvent("rowHeightChanged");
    }    
    
    //----------------------------------
    //  selectionMode (delegates to grid.selectionMode)
    //----------------------------------    
    
    [Bindable("selectionModeChanged")]
    [Inspectable(category="General", enumeration="none,singleRow,multipleRows,singleCell,multipleCells", defaultValue="singleRow")]
    
    /**
     *  @copy spark.components.Grid#selectionMode
     *
     *  @default GridSelectionMode.SINGLE_ROW
     * 
     *  @see spark.components.gridClasses.GridSelectionMode
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get selectionMode():String
    {
        if (grid)
            return grid.selectionMode;
        else
            return gridSelection.selectionMode;
    }
    
    /**
     *  @private
     */
    public function  set selectionMode(value:String):void
    {
        if (selectionMode == value)
            return;
        
        if (grid)
            grid.selectionMode = value;
        else
            gridSelection.selectionMode = value;
        
        // Show the caret if we have focus and not in grid selection mode of "none".
        if (grid)
            grid.showCaret = (value != GridSelectionMode.NONE) && (this == getFocus()) && (internalFocusOwner == GRID_FOCUS_OWNER);
        
        dispatchChangeEvent("selectionModeChanged");
    }
    
    /**
     *  @private
     */
    mx_internal function isRowSelectionMode():Boolean
    {
        const mode:String = selectionMode;
        return mode == GridSelectionMode.SINGLE_ROW || mode == GridSelectionMode.MULTIPLE_ROWS;
    }
    
    /**
     *  @private
     */
    mx_internal function isCellSelectionMode():Boolean
    {
        const mode:String = selectionMode;        
        return mode == GridSelectionMode.SINGLE_CELL || mode == GridSelectionMode.MULTIPLE_CELLS;
    }
    
    //----------------------------------
    //  showDataTips
    //----------------------------------
    
    [Bindable("showDataTipsChanged")]
    [Inspectable(category="Data", defaultValue="false")]
    
    /**
     *  @copy spark.components.Grid#showDataTips
     * 
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get showDataTips():Boolean
    {
        return getGridProperty("showDataTips");
    }
    
    /**
     *  @private
     */
    public function set showDataTips(value:Boolean):void
    {
        if (setGridProperty("showDataTips", value))
            dispatchChangeEvent("showDataTipsChanged");
    }    
    
    //----------------------------------
    //  sortableColumns
    //----------------------------------
    
    private var _sortableColumns:Boolean = true;
    
    [Bindable("sortableColumnsChanged")]
    [Inspectable(category="General", defaultValue="true")]
    
    /**
     *  Specifies whether the user can interactively sort columns.
     *  If <code>true</code>, the user can sort the data provider by the
     *  data field of a column by clicking on the column's header.
     *  If <code>true</code>, an individual column can set its
     *  <code>sortable</code> property to <code>false</code> to 
     *  prevent the user from sorting by that column.  
     * 
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get sortableColumns():Boolean
    {
        return _sortableColumns;
    }
    
    /**
     *  @private
     */    
    public function set sortableColumns(value:Boolean):void
    {
        if (_sortableColumns == value)
            return;
        
        _sortableColumns = value;
        dispatchChangeEvent("sortableColumnsChanged");
    }        
    
    //----------------------------------
    //  typicalItem (delegates to grid.typicalItem)
    //----------------------------------    
    
    [Bindable("typicalItemChanged")]
    [Inspectable(category="Data")]
    
    /**
     *  @copy spark.components.Grid#typicalItem
     *
     *  @default null
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get typicalItem():Object
    {
        return getGridProperty("typicalItem");
    }
    
    /**
     *  @private
     */
    public function set typicalItem(value:Object):void
    {
        if (setGridProperty("typicalItem", value))
            dispatchChangeEvent("typicalItemChanged");
    }
    
    /**
     *  @copy spark.components.Grid#invalidateTypicalItemRenderer()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4.5
     */
    public function invalidateTypicalItem():void
    {
        if (grid)
            grid.invalidateTypicalItemRenderer();
    }
    
    //----------------------------------
    //  variableRowHeight (delegates to grid.variableRowHeight)
    //----------------------------------
    
    [Bindable("variableRowHeightChanged")]
    [Inspectable(category="General", defaultValue="false")]
    
    /**
     *  @copy spark.components.Grid#variableRowHeight
     * 
     *  @default false
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get variableRowHeight():Boolean
    {
        return getGridProperty("variableRowHeight");
    }
    
    /**
     *  @private
     */    
    public function set variableRowHeight(value:Boolean):void
    {
        if (setGridProperty("variableRowHeight", value))
            dispatchChangeEvent("variableRowHeightChanged");
    }     
    
    //--------------------------------------------------------------------------
    //
    //  Drag and Drop Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  dragEnabled
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the dragEnabled property.
     */
    private var _dragEnabled:Boolean = false;
    
    [Inspectable(defaultValue="false")]
    
    /**
     *  A flag that indicates whether you can drag items out of
     *  this control and drop them on other controls.
     *  If <code>true</code>, dragging is enabled for the control.
     *  If the <code>dropEnabled</code> property is also <code>true</code>,
     *  you can drag items and drop them within this control
     *  to reorder the items.
     * 
     *  <p>Drag and drop is not supported on mobile devices where 
     *  <code>interactionMode</code> is set to <code>touch</code>.</p>
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
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
        if (value == _dragEnabled)
            return;
        _dragEnabled = value;
        
        if (_dragEnabled)
        {
            // addEventListener(DragEvent.DRAG_START, dragStartHandler, false, EventPriority.DEFAULT_HANDLER);
            // addEventListener(DragEvent.DRAG_COMPLETE, dragCompleteHandler, false, EventPriority.DEFAULT_HANDLER);
        }
        else
        {
            // removeEventListener(DragEvent.DRAG_START, dragStartHandler, false);
            // removeEventListener(DragEvent.DRAG_COMPLETE, dragCompleteHandler, false);
        }
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
     *  A flag that indicates whether items can be moved instead
     *  of just copied from the control as part of a drag-and-drop
     *  operation.
     *  If <code>true</code>, and the <code>dragEnabled</code> property
     *  is <code>true</code>, items can be moved.
     *  Often the data provider cannot or should not have items removed
     *  from it, so a MOVE operation should not be allowed during
     *  drag-and-drop.
     * 
     *  <p>Drag and drop is not supported on mobile devices where 
     *  <code>interactionMode</code> is set to <code>touch</code>.</p>
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
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
     *  A flag that indicates whether dragged items can be dropped onto the 
     *  control.
     *
     *  <p>If you set this property to <code>true</code>,
     *  the control accepts all data formats, and assumes that
     *  the dragged data matches the format of the data in the data provider.
     *  If you want to explicitly check the data format of the data
     *  being dragged, you must handle one or more of the drag events,
     *  such as <code>dragEnter</code> and <code>dragOver</code>, 
     *  and call the DragEvent's <code>preventDefault()</code> method 
     *  to customize the way the list class accepts dropped data.</p>
     *
     *  <p>When you set <code>dropEnabled</code> to <code>true</code>, 
     *  Flex automatically calls the <code>showDropFeedback()</code> 
     *  and <code>hideDropFeedback()</code> methods to display the drop
     *  indicator.</p>
     * 
     *  <p>Drag and drop is not supported on mobile devices where 
     *  <code>interactionMode</code> is set to <code>touch</code>.</p>
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
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
        if (value == _dropEnabled)
            return;
        _dropEnabled = value;
        
        if (_dropEnabled)
        {
            /*addEventListener(DragEvent.DRAG_ENTER, dragEnterHandler, false, EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_EXIT, dragExitHandler, false, EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_OVER, dragOverHandler, false, EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_DROP, dragDropHandler, false, EventPriority.DEFAULT_HANDLER);*/
        }
        else
        {
            /*removeEventListener(DragEvent.DRAG_ENTER, dragEnterHandler, false);
            removeEventListener(DragEvent.DRAG_EXIT, dragExitHandler, false);
            removeEventListener(DragEvent.DRAG_OVER, dragOverHandler, false);
            removeEventListener(DragEvent.DRAG_DROP, dragDropHandler, false);*/
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  This component holds the focus and accessibilityImplementation (DataGridAccImpl)
     *  for the DataGrid to enable accessibility when the focus shifts to DataGrid descendants, 
     *  notably item editors.
     * 
     *  DataGridAccImpl/createAccessibilityImplementation() initializes the focusOwner's
     *  accessibilityImplementation, rather than the DataGrid's, so that the MSAA 
     *  representation of descendant components will not be "obscured" by DataGridAccImpl.   
     * 
     *  @see #createChildren(), #setFocus(), #isOurFocus().
     */ 
    mx_internal var focusOwner:UIComponent;
    
    /**
     *  @private
     *  The accessibility implementation depends on the focusOwner's bounds, as in 
     *  DisplayObject.getBounds(), which is defined by the bounds of what has been drawn,
     *  not the focusOwner's width and height properties.
     */ 
    private var focusOwnerWidth:Number = 1;
    private var focusOwnerHeight:Number = 1;
    
    /**
     *  @private
     *  Create the focusOwner - a component that holds the keyboard focus for the DataGrid
     *  for the sake of the accessibility implementation.
     * 
     *  This component fails to add its DataGridAccImpl accessibilityImplementation to
     *  the MSAA if it doesn't render, so we draw one alpha=0.0 pixel here and make it
     *  $visible=true.
     */
    override protected function createChildren():void
    {
        super.createChildren();
        
        focusOwner = new UIComponent();
        /*const g:Graphics = focusOwner.graphics;
        g.clear();
        g.lineStyle(0, 0x000000, 0);
        g.drawRect(0, 0, focusOwnerWidth, focusOwnerHeight);
        $addChild(focusOwner);*/
        focusOwner.tabEnabled = true;
        focusOwner.tabIndex = tabIndex;
        // focusOwner.$visible = true;
    }
    
    /**
     *  @private
     *  Ensure that IDataGridElements are laid out after the grid skin part.
     *  At the moment, DataGrid has only one IDataGridElement, columnHeaderGroup.
     * 
     *  The DataGrid columnHeaderGroup's layout role is unusual, since it depends on
     *  the layout of the grid skin part.
     *  The columnHeaderGroup's column widths, scroll position, and list of visible columns
     *  are defined by the grid.
     *  That means that the grid needs to compute its layout first.
     * 
     *  The Flex LayoutManager orders the per-element work in each of its phases according
     *  to the element's nestLevel. The measure() (validateSize) phase is "bottom up"
     *  with respect to the nestLevel, which means that the deepest nodes in the tree with the
     *  highest nestLevel are measured first.
     *  Similarly the updateDisplayList() (validateDisplayList) phase is "top down" where the nodes
     *  with the lowest nestLevel are validated first. 
     *  To guarantee that the columnHeaderGroup skin part is laid out after the grid skin part,
     *  we need to ensure that its nestLevel is greater than the grid's nestLevel.
     * 
     *  As the DataGrid's skin defines the grid and columnHeaderGroup skin parts, there is no
     *  way for the DataGrid component to constrain their relative locations in the visual element
     *  hierarchy.
     *  However, all ILayoutManagerClients have a nestLevel property, which specifies the element's
     *  depth relative to its SystemManager root.
     *  Thus, we can overcome the limitation by initializing the columnHeaderGroup's nestLevel
     *  to be grid.nestLevel+1, which ensures that the columnHeaderGroup will be validated after
     *  the grid.
     */
    /*override public function set nestLevel(value:int):void
    {
        super.nestLevel = value;
        
        if (grid)
            initializeDataGridElement(columnHeaderGroup);
    }*/
    
    /**
     *  @private
     *  Ensure that the DataGrid appears in the correct tab order, despite the fact that its
     *  focusOwner gets the focus.
     */
    override public function set tabIndex(index:int):void
    {
        super.tabIndex = index;
        if (focusOwner)
            focusOwner.tabIndex = index;
    }
    
    /**
     *  @private
     *  Sync the focusOwner's copy of this value because the we can't cover this case in
     *  DataGridAccImpl/get_accDescription(childID). Currently get_accDescription() is never
     *  called with childID=0.
     */
    /*override public function set accessibilityDescription(value:String):void
    {
        super.accessibilityDescription = value;
        if (focusOwner)
            focusOwner.accessibilityDescription = value;
    }*/
    
    /**
     *  @private
     *  Sync the focusOwner's copy of this value because the we can't cover this case in
     *  DataGridAccImpl/get_accShortcut(childID). Currently get_accShortcut() is never
     *  called with childID=0.
     */
    /*override public function set accessibilityShortcut(value:String):void
    {
        super.accessibilityShortcut = value;
        if (focusOwner)
            focusOwner.accessibilityShortcut = value;
    }*/
    
    /**
     *  @private
     */
    /*override protected function initializeAccessibility():void
    {
        if (DataGrid.createAccessibilityImplementation != null)
            DataGrid.createAccessibilityImplementation(this);
    }*/
    
    /**
     *  @private
     *  Override to set proper width and height on focusOwner object that 
     *  the DataGridAccImpl uses to compute the location of the DataGrid.
     */
    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        
        if (focusOwner && ((focusOwnerWidth != unscaledWidth) || (focusOwnerHeight != unscaledHeight)))
        {
            focusOwnerWidth = unscaledWidth;
            focusOwnerHeight = unscaledHeight;
            /*const g:Graphics = focusOwner.graphics;
            g.clear();
            g.lineStyle(0, 0x000000, 0);
            g.drawRect(0, 0, focusOwnerWidth, focusOwnerHeight);*/        
        }
    }
    
    /**
     *  @private
     */
    override public function setFocus():void
    {
        if (grid)
            focusOwner.setFocus();
    }
    
    /**
     *  @private
     */
    /*override protected function isOurFocus(target:DisplayObject):Boolean
    {
        return (target == focusOwner) || super.isOurFocus(target);
    } */   
    
    /**
     *  @private
     */ 
    override public function styleChanged(styleName:String):void
    {
        super.styleChanged(styleName);
        
        const allStyles:Boolean = (styleName == null || styleName == "styleName");
        
        if (grid)
        {
            /*if (allStyles || styleManager.isSizeInvalidatingStyle(styleName))
            {
                if (grid)
                {
                    grid.invalidateSize();
                    grid.clearGridLayoutCache(true);
                }
                if (columnHeaderGroup)
                {
                    columnHeaderGroup.layout.clearVirtualLayoutCache();
                    columnHeaderGroup.invalidateSize();
                }
            }
            */
            if (allStyles || (styleName == "alternatingRowColors"))
            {
                initializeGridRowBackground();
                if (grid && grid.layout)
                    grid.layout.clearVirtualLayoutCache();               
            }
            
            if (grid)
                grid.invalidateDisplayList();
            
            /*if (columnHeaderGroup)
                columnHeaderGroup.invalidateDisplayList();*/
        }
        
        if (scroller)
        {
            // The scrollPolicy styles are initialized in framework/defaults.css
            // so there's no way to determine if been explicitly set here.  To avoid 
            // preempting explicitly set scroller scrollPolicy styles with the default
            // "auto" value, we only forward the style if it's not "auto".
            
            const vsp:String = getStyle("verticalScrollPolicy");
            if (styleName == "verticalScrollPolicy")
                scroller.setStyle("verticalScrollPolicy", vsp);
            else if (allStyles && vsp && (vsp !== ScrollPolicy.AUTO))
                scroller.setStyle("verticalScrollPolicy", vsp);
            
            const hsp:String = getStyle("horizontalScrollPolicy");
            if (styleName == "horizontalScrollPolicy")
                scroller.setStyle("horizontalScrollPolicy", hsp);
            else if (allStyles && hsp && (hsp !== ScrollPolicy.AUTO))
                scroller.setStyle("horizontalScrollPolicy", hsp);
        }
    }
    
    /**
     *  @private
     *  Used to prevent keyboard events that have been redispatched to the Scroller from being
     *  redispatched a second time when they bubble back up.
     */
    private var scrollerEvent:KeyboardEvent = null;
    
    /**
     *  @private
     *  Build in basic keyboard navigation support in Grid. The focus is on
     *  the DataGrid which means the Scroller doesn't see the Keyboard events
     *  unless the event is dispatched to it.
     */
    /*override protected function keyDownHandler(event:KeyboardEvent):void
    {
        if (!grid || event.isDefaultPrevented())
            return;
        
        // We've seen this event already and dispatched it to the Scroller
        if (event == scrollerEvent)
        {
            scrollerEvent = null;
            event.preventDefault();
            return;
        }
        
        // If the key wasn't targeted to us, then ignore it.
        if (!isOurFocus(DisplayObject(event.target)))
            return;
        
        // Ctrl-A only comes thru on Mac.  On Windows it is a SELECT_ALL
        // event.
        if (event.keyCode == Keyboard.A && event.ctrlKey)
        { 
            selectAllFromKeyboard();
            event.preventDefault();
            return;
        }
        
        // Row selection requires valid row caret, cell selection
        // requires both a valid row and a valid column caret.
        
        if (selectionMode == GridSelectionMode.NONE || 
            grid.caretRowIndex < 0 || 
            grid.caretRowIndex >= dataProviderLength ||
            (isCellSelectionMode() && 
                (grid.caretColumnIndex < 0 || grid.caretColumnIndex >= columnsLength)))
        {
            // We're not going to handle this event, so give the scroller a chance.
            if (scroller && (scrollerEvent != event))
            {
                scrollerEvent = event.clone() as KeyboardEvent;
                scroller.dispatchEvent(scrollerEvent);
            }
            return;
        }

        switch (internalFocusOwner)
        {
            case GRID_FOCUS_OWNER: handleGridKeyEvent(event); break;
            case HEADER_FOCUS_OWNER: handleHeaderKeyEvent(event); break;
        }
    }*/
    
    /**
     *  @private
     *  Handle KeyboardEvents when the internalFocusOwner is the grid.
     */ 
    private function handleGridKeyEvent(event:KeyboardEvent):void
    {
        var op:String;
        		
        if (event.keyCode == Keyboard.SPACE)
        {
            if (event.ctrlKey)
            {
                // Updates the selection.  The caret remains the same and the
                // anchor is updated.
                if (toggleSelection(grid.caretRowIndex, grid.caretColumnIndex))
                {
                    grid.anchorRowIndex = grid.caretRowIndex;
                    grid.anchorColumnIndex = grid.caretColumnIndex;
                    event.preventDefault();                
                }
            }
            else if (event.shiftKey)
            {
                // Extend the selection.  The caret remains the same.
                if (extendSelection(grid.caretRowIndex, grid.caretColumnIndex))
                    event.preventDefault();                
            }
            else
            {
                if (grid.caretRowIndex != -1)
                {
                    if (isRowSelectionMode())
                    {
                        op = selectionMode == GridSelectionMode.SINGLE_ROW ?
                            GridSelectionEventKind.SET_ROW :
                            GridSelectionEventKind.ADD_ROW;
                        
                        // Add the row and leave the caret position unchanged.
                        if (!commitInteractiveSelection(
                            op, grid.caretRowIndex, grid.caretColumnIndex))
                        {
                            return;
                        }
                        event.preventDefault();                
                    }
                    else if (isCellSelectionMode() && grid.caretColumnIndex != -1)
                    {
                        op = selectionMode == GridSelectionMode.SINGLE_CELL ?
                            GridSelectionEventKind.SET_CELL :
                            GridSelectionEventKind.ADD_CELL;
                        
                        // Add the cell and leave the caret position unchanged.
                        if (!commitInteractiveSelection(
                            op, grid.caretRowIndex, grid.caretColumnIndex))
                        {
                            return;
                        }
                        event.preventDefault();                
                    }
                }
            }
            return;
        }
        
        // Was some other navigation key hit?
        adjustSelectionUponNavigation(event);        
    }
    
    /**
     *  @private
     *  Handle KeyboardEvents when the internalFocusOwner is the header.
     */ 
    private function handleHeaderKeyEvent(event:KeyboardEvent):void
    {
        /*if (!columnHeaderGroup)
            return;
        
        const selectedIndex:int = columnHeaderGroup.selectedColumnIndex;
        
        if (selectedIndex == -1)
            return;
        
        if ((event.keyCode == Keyboard.SPACE) || (event.keyCode == Keyboard.ENTER))
        {
            const column:GridColumn = getColumnAt(selectedIndex);
            const isMultiColumnSort:Boolean = event.ctrlKey;
            interactiveSortByColumns(column, isMultiColumnSort); 
            if (!isMultiColumnSort && grid)
                internalFocusOwner = GRID_FOCUS_OWNER;
            return;
        }
        
        if (!NavigationUnit.isNavigationUnit(event.keyCode))
            return;
        
        // swap Keyboard.LEFT and Keyboard.RIGHT for RTL layout
        const navigationUnit:uint = mapKeycodeForLayoutDirection(event);  
        
        const firstVisibleColumnIndex:int = grid.getNextVisibleColumnIndex(-1);
        const lastVisibleColumnIndex:int = grid.getPreviousVisibleColumnIndex(columns.length);
        var newSelectedIndex:int = selectedIndex;

        switch (navigationUnit)
        {
            case NavigationUnit.HOME:
            {
                newSelectedIndex = firstVisibleColumnIndex;
                break;
            }
                
            case NavigationUnit.END:
            {
                newSelectedIndex = lastVisibleColumnIndex;                
                break;
            }
                
            case NavigationUnit.LEFT:
            {
                if (event.ctrlKey && !event.shiftKey)
                {
                    moveColumnPosition(selectedIndex, -1);
                }
                else if (event.ctrlKey && event.shiftKey)
                {
                    changeColumnWidth(selectedIndex, -3);
                }
                else
                {
                    if (selectedIndex <= firstVisibleColumnIndex)
                        newSelectedIndex = firstVisibleColumnIndex;
                    else
                        newSelectedIndex = grid.getPreviousVisibleColumnIndex(selectedIndex);
                }
                break;
            }
                
            case NavigationUnit.RIGHT:
            {
                if (event.ctrlKey && !event.shiftKey)
                {
                    moveColumnPosition(selectedIndex, +1);
                }
                else if (event.ctrlKey && event.shiftKey)
                {
                    changeColumnWidth(selectedIndex, +3);
                }
                else
                {
                    if (selectedIndex >= lastVisibleColumnIndex)
                        newSelectedIndex = lastVisibleColumnIndex;
                    else
                        newSelectedIndex = grid.getNextVisibleColumnIndex(selectedIndex);
                }
                break;
            }
        }

        if (newSelectedIndex != selectedIndex)
        {
            columnHeaderGroup.selectedColumnIndex = newSelectedIndex;
            ensureCellIsVisible(-1, newSelectedIndex);
        }*/
    }
    
    /**
     *  @private
     *  Change the specified column's position by delta, where delta is either +1 or -1.
     */
    private function moveColumnPosition(columnIndex:int, delta:int):void
    {
        const column:GridColumn = getColumnAt(columnIndex);
        if (!column)
            return;
        
        var newColumnIndex:int = -1;
        if (delta == +1)
            newColumnIndex = grid.getNextVisibleColumnIndex(columnIndex);
        else if (delta == -1)
            newColumnIndex = grid.getPreviousVisibleColumnIndex(columnIndex);
        
        if (newColumnIndex != -1)
        {
            columns.removeItemAt(columnIndex);
            columns.addItemAt(column, newColumnIndex);
            // columnHeaderGroup.selectedColumnIndex = newColumnIndex;
            grid.ensureCellIsVisible(-1, newColumnIndex);
        }
    }
    
    /**
     *  @private
     *  Change the specified column's width by delta.
     */
    private function changeColumnWidth(columnIndex:int, delta:Number):void
    {
        const column:GridColumn = getColumnAt(columnIndex);
        if (!column)
            return;
        
        var columnWidth:Number = column.width;
        if (isNaN(columnWidth))
            columnWidth = grid.getColumnWidth(columnIndex);

        columnWidth = Math.max(1, columnWidth + delta);
        if (!isNaN(column.maxWidth))
            columnWidth = Math.min(columnWidth, column.maxWidth);
        if (!isNaN(column.minWidth))
            columnWidth = Math.max(columnWidth, column.minWidth);
        column.width = columnWidth;
    }
    
    /**
     *  @private
     *  If the focusManager is trying to tab forwards from the DataGrid and the internalFocusOwner is
     *  currently the grid, then switch the internal focus to the header and cancel the focusManager's
     *  event.  Similarly, if the focusManager is trying to tab backwards (shift-tab) and the internal
     *  focus is currently on the header, then set the internal focus to the grid and cancel the event.
     */    
    protected function keyFocusChangeHandler(event:FocusEvent):void
    {
        if (event.isDefaultPrevented())
            return;
    
        // In an edit session.  Don't let the TAB switch the internal focus.
        if (editor && editor.editorRowIndex != -1 && editor.editorColumnIndex != -1)
            return;
        
        /*if ((internalFocusOwner == GRID_FOCUS_OWNER) && !event.shiftKey && columnHeaderGroup)
        {
            internalFocusOwner = HEADER_FOCUS_OWNER;
            event.preventDefault();
        }
        else if ((internalFocusOwner == HEADER_FOCUS_OWNER) && event.shiftKey && grid)
        {
            internalFocusOwner = GRID_FOCUS_OWNER;
            event.preventDefault();            
        }
        else 
        {
            internalFocusOwner = (internalFocusOwner == GRID_FOCUS_OWNER) ? HEADER_FOCUS_OWNER : GRID_FOCUS_OWNER;
            // If there's another focusable component, we will lose the focus here
        }*/
    }
    
    /**
     *  @private
     *  New event in FP10 dispatched when the user activates the platform 
     *  specific accelerator key combination for a select all operation.
     *  On Windows this is ctrl-A and on Mac this is cmd-A.
     */
    protected function selectAllHandler(event:Event):void
    {
        // If the select all was not targeted to the DataGrid, then ignore it.
        if (!grid || event.isDefaultPrevented() /*|| 
            !isOurFocus(DisplayObject(event.target))*/)
        {
            return;
        }
        
        selectAllFromKeyboard();
    }
    
    /**
     *  @private
     */
    private function selectAllFromKeyboard():void
    {
        // If there is a caret, leave it in its current position.
        if (selectionMode == GridSelectionMode.MULTIPLE_CELLS || 
            selectionMode == GridSelectionMode.MULTIPLE_ROWS)
        {
            if (commitInteractiveSelection(
                GridSelectionEventKind.SELECT_ALL,
                0, 0, dataProvider.length, columns.length))
            {
                grid.anchorRowIndex = 0;
                grid.anchorColumnIndex = 0;
            }
        }
    }
    
    /**
     *  @private
     *  Call partAdded() for IFactory type skin parts.   By default, partAdded() is not 
     *  called for IFactory type skin part variables, because they're assumed to be 
     *  "dynamic" skin parts, to be created with createDynamicPartInstance().  That's 
     *  not the case with the IFactory valued parts listed in factorySkinPartNames.
     */ 
    /*override protected function findSkinParts():void
    {
        super.findSkinParts();
        
        for each (var partName:String in factorySkinPartNames)
        {
            if ((partName in skin) && skin[partName])
                partAdded(partName, skin[partName]);
        }
    }*/
    
    /**
     *  @private
     */
    private function initializeDataGridElement(elt:IDataGridElement):void
    {
        if (!elt)
            return;
        
        elt.dataGrid = this;
        if (elt.nestLevel <= grid.nestLevel)
        {
            elt.validateNow();
            elt.nestLevel = grid.nestLevel + 1;
        }
    }
    
    /**
     *  @private
     */
    /*override protected function partAdded(partName:String, instance:Object):void
    {
        super.partAdded(partName, instance);
        
        if (instance == grid)
        {
            // Basic Initialization
            
            gridSelection.grid = grid;
            grid.gridSelection = gridSelection;
            grid.dataGrid = this;
            
            // Grid cover Properties
            
            const modifiedGridProperties:Object = gridProperties;  // explicitly set properties
            gridProperties = {propertyBits:0};
            
            for (var propertyName:String in modifiedGridProperties)
            {
                if (propertyName == "propertyBits")
                    continue;
                setGridProperty(propertyName, modifiedGridProperties[propertyName]);
            }
            
            // IFactory valued skin parts => Grid visual element properties
            
            initializeGridRowBackground(); // sets grid.rowBackground if alternatingRowColors set
            grid.columnSeparator = columnSeparator;
            grid.rowSeparator = rowSeparator;
            grid.hoverIndicator = hoverIndicator;
            grid.caretIndicator = caretIndicator;
            grid.selectionIndicator = selectionIndicator;
            grid.lockedColumnsSeparator = lockedColumnsSeparator;
            grid.lockedRowsSeparator = lockedRowsSeparator;
            
            // Event Handlers
            
            grid.addEventListener(GridEvent.GRID_MOUSE_DOWN, grid_mouseDownHandler, false, EventPriority.DEFAULT_HANDLER);
            grid.addEventListener(GridEvent.GRID_MOUSE_UP, grid_mouseUpHandler, false, EventPriority.DEFAULT_HANDLER);
            grid.addEventListener(GridEvent.GRID_ROLL_OVER, grid_rollOverHandler, false, EventPriority.DEFAULT_HANDLER);
            grid.addEventListener(GridEvent.GRID_ROLL_OUT, grid_rollOutHandler, false, EventPriority.DEFAULT_HANDLER);
            grid.addEventListener(GridCaretEvent.CARET_CHANGE, grid_caretChangeHandler);            
            grid.addEventListener(FlexEvent.VALUE_COMMIT, grid_valueCommitHandler);
            grid.addEventListener("invalidateSize", grid_invalidateSizeHandler);            
            grid.addEventListener("invalidateDisplayList", grid_invalidateDisplayListHandler);
            grid.addEventListener("gridViewsChanged", grid_gridViewsChangedHandler);
            
            // Deferred operations (grid selection updates)
            
            for each (var deferredGridOperation:Function in deferredGridOperations)
            deferredGridOperation(grid);
            deferredGridOperations.length = 0;
            
            // IDataGridElements: columnHeaderGroup...
            
            // initializeDataGridElement(columnHeaderGroup);
            
            // Create the data grid editor
            
            editor = createEditor();
            editor.initialize();                               
        }
        
        if (instance == alternatingRowColorsBackground)
            initializeGridRowBackground();
        
        if (grid)
        {
            if (instance == columnSeparator) 
                grid.columnSeparator = columnSeparator;
            
            if (instance == rowSeparator) 
                grid.rowSeparator = rowSeparator;
            
            if (instance == lockedColumnsSeparator) 
                grid.lockedColumnsSeparator = lockedColumnsSeparator;
            
            if (instance == lockedRowsSeparator) 
                grid.lockedRowsSeparator = lockedRowsSeparator;            
            
            if (instance == hoverIndicator) 
                grid.hoverIndicator = hoverIndicator;
            
            if (instance == caretIndicator)
            {                
                grid.caretIndicator = caretIndicator;
                
                // Add a focus listener so we can turn the caret on and off
                // when we get and lose focus.
                addEventListener(FocusEvent.FOCUS_IN, dataGrid_focusHandler);
                addEventListener(FocusEvent.FOCUS_OUT, dataGrid_focusHandler);
                if (grid)
                    grid.showCaret = false;
            }
            
            if (instance == rowBackground)
                grid.rowBackground = rowBackground;
            
            if (instance == selectionIndicator) 
                grid.selectionIndicator = selectionIndicator;
            
        }
        
        if (instance == columnHeaderGroup)
        {
            if (grid)
                initializeDataGridElement(columnHeaderGroup);
            
            columnHeaderGroup.addEventListener(GridEvent.GRID_CLICK, columnHeaderGroup_clickHandler);
            columnHeaderGroup.addEventListener(GridEvent.GRID_ROLL_OVER, columnHeaderGroup_rollOverHandler);
            columnHeaderGroup.addEventListener(GridEvent.GRID_ROLL_OUT, columnHeaderGroup_rollOutHandler);                
            columnHeaderGroup.addEventListener(GridEvent.SEPARATOR_ROLL_OVER, separator_rollOverHandler);
            columnHeaderGroup.addEventListener(GridEvent.SEPARATOR_ROLL_OUT, separator_rollOutHandler);
            columnHeaderGroup.addEventListener(GridEvent.SEPARATOR_MOUSE_DOWN, separator_mouseDownHandler);
            columnHeaderGroup.addEventListener(GridEvent.SEPARATOR_MOUSE_DRAG, separator_mouseDragHandler);
            columnHeaderGroup.addEventListener(GridEvent.SEPARATOR_MOUSE_UP, separator_mouseUpHandler);  
        }
        
        if (instance == scroller)
        {
            // The scrollPolicy styles are initialized in framework/defaults.css
            // so there's no way to determine if been explicitly set here.  To avoid 
            // preempting explicitly set scroller scrollPolicy styles with the default
            // "auto" value, we only forward the style if it's not "auto".
            
            const vsp:String = getStyle("verticalScrollPolicy");
            if (vsp && (vsp !== ScrollPolicy.AUTO))
                scroller.setStyle("verticalScrollPolicy", vsp);
            
            const hsp:String = getStyle("horizontalScrollPolicy");
            if (hsp && (hsp !== ScrollPolicy.AUTO))
                scroller.setStyle("horizontalScrollPolicy", hsp);            
        }
    }*/
    
    /**
     * @private
     */
    /*override protected function partRemoved(partName:String, instance:Object):void
    {
        super.partRemoved(partName, instance);
        
        if (instance == grid)
        {
            // Basic Initialization
            
            gridSelection.grid = null;
            grid.gridSelection = null;
            grid.dataGrid = null;            
            
            // Event Handlers
            grid.removeEventListener("gridViewsChanged", grid_gridViewsChangedHandler);            
            grid.removeEventListener("invalidateSize", grid_invalidateSizeHandler);            
            grid.removeEventListener("invalidateDisplayList", grid_invalidateDisplayListHandler);
            grid.removeEventListener(GridEvent.GRID_MOUSE_DOWN, grid_mouseDownHandler);
            grid.removeEventListener(GridEvent.GRID_MOUSE_UP, grid_mouseUpHandler);
            grid.removeEventListener(GridEvent.GRID_ROLL_OVER, grid_rollOverHandler);
            grid.removeEventListener(GridEvent.GRID_ROLL_OUT, grid_rollOutHandler);            
            grid.removeEventListener(GridCaretEvent.CARET_CHANGE, grid_caretChangeHandler);            
            grid.removeEventListener(FlexEvent.VALUE_COMMIT, grid_valueCommitHandler);
            
            // Cover Properties
            
            const gridPropertyBits:uint = gridProperties.propertyBits;
            gridProperties = {};
            
            for (var propertyName:String in gridPropertyDefaults)
            {
                var propertyBit:uint = partPropertyBits[propertyName];
                if ((propertyBit & gridPropertyBits) == propertyBit)
                    gridProperties[propertyName] = getGridProperty(propertyName);                
            }
            
            // Visual Elements
            
            grid.rowBackground = null;
            grid.columnSeparator = null;
            grid.rowSeparator = null;
            grid.hoverIndicator = null;
            grid.caretIndicator = null;
            grid.selectionIndicator = null;
            
            // IDataGridElements: grid, columnHeaderGroup
            
            if (columnHeaderGroup)
                columnHeaderGroup.dataGrid = null;
            
            // Data grid editor
            if (editor)
            {
                editor.uninitialize();
                editor = null;
            }
            
            if (internalFocusOwner == GRID_FOCUS_OWNER)
                internalFocusOwner = NO_FOCUS_OWNER;
        }
        
        if (grid)
        {
            if (instance == columnSeparator) 
                grid.columnSeparator = null;
            
            if (instance == rowSeparator) 
                grid.rowSeparator = null;
            
            if (instance == lockedColumnsSeparator) 
                grid.lockedColumnsSeparator = null;
            
            if (instance == lockedRowsSeparator) 
                grid.lockedRowsSeparator = null;                
            
            if (instance == hoverIndicator) 
                grid.hoverIndicator = null;
            
            if (instance == caretIndicator)
            {
                grid.caretIndicator = null;
                
                removeEventListener(FocusEvent.FOCUS_IN, dataGrid_focusHandler);
                removeEventListener(FocusEvent.FOCUS_OUT, dataGrid_focusHandler);
            }
            
            if (instance == selectionIndicator) 
                grid.selectionIndicator = null;
            
            if (instance == rowBackground)
                grid.rowBackground = null;
        }
        
        if (instance == columnHeaderGroup)
        {
            columnHeaderGroup.dataGrid = null;
            columnHeaderGroup.removeEventListener(GridEvent.GRID_CLICK, columnHeaderGroup_clickHandler);
            columnHeaderGroup.removeEventListener(GridEvent.GRID_ROLL_OVER, columnHeaderGroup_rollOverHandler);
            columnHeaderGroup.removeEventListener(GridEvent.GRID_ROLL_OUT, columnHeaderGroup_rollOutHandler);               
            columnHeaderGroup.removeEventListener(GridEvent.SEPARATOR_ROLL_OVER, separator_rollOverHandler);
            columnHeaderGroup.removeEventListener(GridEvent.SEPARATOR_ROLL_OUT, separator_rollOutHandler);
            columnHeaderGroup.removeEventListener(GridEvent.SEPARATOR_MOUSE_DOWN, separator_mouseDownHandler);
            columnHeaderGroup.removeEventListener(GridEvent.SEPARATOR_MOUSE_DRAG, separator_mouseDragHandler);
            columnHeaderGroup.removeEventListener(GridEvent.SEPARATOR_MOUSE_UP, separator_mouseUpHandler);
            
            if (internalFocusOwner == HEADER_FOCUS_OWNER)
                internalFocusOwner = NO_FOCUS_OWNER;            
        }
    }*/
    
    //----------------------------------
    //  selectedCell
    //----------------------------------
    
    [Bindable("selectionChange")]
    [Bindable("valueCommit")]
    
    /**
     *  @copy spark.components.Grid#selectedCell
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get selectedCell():CellPosition
    {
        if (grid)
            return grid.selectedCell;
        
        return selectedCells.length ? selectedCells[0] : null;
    }
    
    /**
     *  @private
     */
    public function set selectedCell(value:CellPosition):void
    {
        if (grid)
            grid.selectedCell = value;
        else
        {
            const valueCopy:CellPosition = (value) ? new CellPosition(value.rowIndex, value.columnIndex) : null;
            
            var f:Function = function(g:Grid):void
            {
                g.selectedCell = valueCopy;
            };
            deferredGridOperations.push(f);
        }
    }    
    
    //----------------------------------
    //  selectedCells
    //----------------------------------
    
    [Bindable("selectionChange")]
    [Bindable("valueCommit")]
    
    /**
     *  @copy spark.components.Grid#selectedCells
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get selectedCells():Vector.<CellPosition>
    {
        return grid ? grid.selectedCells : gridSelection.allCells();
    }
    
    /**
     *  @private
     */
    public function set selectedCells(value:Vector.<CellPosition>):void
    {
        if (grid)
            grid.selectedCells = value;
        else
        {
            const valueCopy:Vector.<CellPosition> = (value) ? value.concat() : null;
            var f:Function = function(g:Grid):void
            {
                g.selectedCells = valueCopy;
            };
            deferredGridOperations.push(f);
        }
    }       
    
    //----------------------------------
    //  selectedIndex
    //----------------------------------
    
    [Bindable("selectionChange")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="-1")]
    
    /**
     *  @copy spark.components.Grid#selectedIndex
     *
     *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get selectedIndex():int
    {
        if (grid)
            return grid.selectedIndex;
        
        return (selectedIndices.length > 0) ? selectedIndices[0] : -1;
    }
    
    /**
     *  @private
     */
    public function set selectedIndex(value:int):void
    {
        if (grid)
            grid.selectedIndex = value;
        else
        {
            var f:Function = function(g:Grid):void
            {
                g.selectedIndex = value;
            };
            deferredGridOperations.push(f);
        }
    }
    
    //----------------------------------
    //  selectedIndices
    //----------------------------------
    
    [Bindable("selectionChange")]
    [Bindable("valueCommit")]
    [Inspectable(category="General")]
    
    /**
     *  @copy spark.components.Grid#selectedIndices
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get selectedIndices():Vector.<int>
    {
        return grid ? grid.selectedIndices : gridSelection.allRows();
    }
    
    /**
     *  @private
     */
    public function set selectedIndices(value:Vector.<int>):void
    {
        if (grid)
            grid.selectedIndices = value;
        else
        {
            const valueCopy:Vector.<int> = (value) ? value.concat() : null;
            var f:Function = function(g:Grid):void
            {
                g.selectedIndices = valueCopy;
            };
            deferredGridOperations.push(f);
        }
    }    
    
    //----------------------------------
    //  selectedItem
    //----------------------------------
    
    [Bindable("selectionChange")]
    [Bindable("valueCommit")]
    [Inspectable(category="General", defaultValue="null")]
    
    /**
     *  @copy spark.components.Grid#selectedItem
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get selectedItem():Object
    {
        if (grid)
            return grid.selectedItem;
        
        return (dataProvider && (selectedIndex > 0)) ? 
            dataProvider.getItemAt(selectedIndex) : undefined;
    }
    
    /**
     *  @private
     */
    public function set selectedItem(value:Object):void
    {
        if (grid)
            grid.selectedItem = value;
        else
        {
            var f:Function = function(g:Grid):void
            {
                g.selectedItem = value;
            };
            deferredGridOperations.push(f);
        }
    }    
    
    //----------------------------------
    //  selectedItems
    //----------------------------------
    
    [Bindable("selectionChange")]
    [Bindable("valueCommit")]
    [Inspectable(category="General")]
    
    /**
     *  @copy spark.components.Grid#selectedItems
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get selectedItems():Vector.<Object>
    {
        if (grid)
            return grid.selectedItems;
        
        var items:Vector.<Object> = new Vector.<Object>();
        
        for (var i:int = 0; i < selectedIndices.length; i++)
            items.push(selectedIndices[i]);
        
        return items;
    }
    
    /**
     *  @private
     */
    public function set selectedItems(value:Vector.<Object>):void
    {
        if (grid)
            grid.selectedItems = value;
        else
        {
            const valueCopy:Vector.<Object> = value.concat();
            var f:Function = function(g:Grid):void
            {
                g.selectedItems = valueCopy;
            };
            deferredGridOperations.push(f);
        }
    }      
    
    //----------------------------------
    //  selectionLength
    //----------------------------------
    
    [Bindable("selectionChange")]
    [Bindable("valueCommit")]
    
    /**
     *  @copy spark.components.Grid#selectionLength
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function get selectionLength():int
    {
        return grid ? grid.selectionLength : gridSelection.selectionLength;
    }    
    
    //--------------------------------------------------------------------------
    //
    //  Public Methods
    //
    //--------------------------------------------------------------------------

    /**
    *  @copy spark.components.Grid#findRowIndex()
    *
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Flex 4.10
    */
    public function findRowIndex(field:String, value:String, startingIndex:int = 0, patternType:String = RegExPatterns.EXACT):int
    {
        if (grid)
        {
            return grid.findRowIndex(field, value, startingIndex, patternType);
        }
        else
        {
            return -1;
        }
    }


    /**
    *  @copy spark.components.Grid#findRowIndices()
    *
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Flex 4.10
    */
    public function findRowIndices(field:String, values:Array, patternType:String = RegExPatterns.EXACT):Array
    {
        if (grid)
        {
            return grid.findRowIndices(field, values, patternType);
        }
        else
        {
            return [];
        }
    }


    /**
     *  @copy spark.components.Grid#invalidateCell()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function invalidateCell(rowIndex:int, columnIndex:int):void
    {
        /*if (grid)
            grid.invalidateCell(rowIndex, columnIndex);*/
    }


    /**
    *  @copy spark.components.Grid#moveIndexFindRow()
    *
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Flex 4.10
    *
    */
    public function moveIndexFindRow(field:String, value:String, startingIndex:int = 0, patternType:String = RegExPatterns.EXACT):Boolean
    {
        if (grid)
        {
            return grid.moveIndexFindRow(field, value, startingIndex, patternType);
        }
        else
        {
            return false;
        }
    }


    /**
    *  @copy spark.components.Grid#moveIndexFirstRow()
    *
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Flex 4.10
    */
    public function moveIndexFirstRow():void
    {
        if (grid)
        {
            grid.moveIndexFirstRow();
        }
    }


    /**
    *  @copy spark.components.Grid#moveIndexLastRow()
    *
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Flex 4.10
    */
    public function moveIndexLastRow():void
    {
        if (grid)
        {
            grid.moveIndexLastRow();
        }
    }


    /**
    *  @copy spark.components.Grid#moveIndexNextRow()
    *
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Flex 4.10
    */
    public function moveIndexNextRow():void
    {
        if (grid)
        {
            grid.moveIndexNextRow();
        }
    }


    /**
    *  @copy spark.components.Grid#moveIndexPreviousRow()
    *
    *  @langversion 3.0
    *  @playerversion Flash 11.1
    *  @playerversion AIR 3.4
    *  @productversion Flex 4.10
    */
    public function moveIndexPreviousRow():void
    {
        if (grid)
        {
            grid.moveIndexPreviousRow();
        }
    }


    /**
     *  @copy spark.components.Grid#selectAll()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function selectAll():Boolean
    {
        var selectionChanged:Boolean;
        
        if (grid)
        {
            selectionChanged = grid.selectAll();
        }
        else
        {
            selectionChanged = gridSelection.selectAll();
            if (selectionChanged)
                dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
        }
        
        return selectionChanged;
    }
    
    /**
     *  @copy spark.components.Grid#clearSelection()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function clearSelection():Boolean
    {
        var selectionChanged:Boolean;
        
        if (grid)
        {
            selectionChanged = grid.clearSelection();
        }
        else
        {
            selectionChanged = gridSelection.removeAll();
            if (selectionChanged)
                dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
        }
        
        return selectionChanged;
    }
    
    //----------------------------------
    //  selection for rows
    //----------------------------------    
    
    /**
     *  @copy spark.components.Grid#selectionContainsIndex()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function selectionContainsIndex(rowIndex:int):Boolean 
    {
        if (grid)
            return grid.selectionContainsIndex(rowIndex);
        else
            return gridSelection.containsRow(rowIndex);         
    }
    
    /**
     *  @copy spark.components.Grid#selectionContainsIndices()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function selectionContainsIndices(rowIndices:Vector.<int>):Boolean 
    {
        if (grid)
            return grid.selectionContainsIndices(rowIndices);
        else
            return gridSelection.containsRows(rowIndices);
    }
    
    /**
     *  @copy spark.components.Grid#setSelectedIndex()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function setSelectedIndex(rowIndex:int):Boolean
    {
        var selectionChanged:Boolean;
        
        if (grid)
        {
            selectionChanged = grid.setSelectedIndex(rowIndex);
        }
        else
        {
            selectionChanged = gridSelection.setRow(rowIndex);
            if (selectionChanged)
                dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
        }
        
        return selectionChanged;
    }
    
    /**
     *  @copy spark.components.Grid#addSelectedIndex()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function addSelectedIndex(rowIndex:int):Boolean
    {
        var selectionChanged:Boolean;
        
        if (grid)
        {
            selectionChanged = grid.addSelectedIndex(rowIndex);
        }
        else
        {
            selectionChanged = gridSelection.addRow(rowIndex);
            if (selectionChanged)
                dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
        }
        
        return selectionChanged;
    }
    
    /**
     *  @copy spark.components.Grid#removeSelectedIndex()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function removeSelectedIndex(rowIndex:int):Boolean
    {
        var selectionChanged:Boolean;
        
        if (grid)
        {
            selectionChanged = grid.removeSelectedIndex(rowIndex);
        }
        else
        {
            selectionChanged = gridSelection.removeRow(rowIndex);
            if (selectionChanged)
                dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
        }
        
        return selectionChanged;
    }
    
    /**
     *  @copy spark.components.Grid#selectIndices()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function selectIndices(rowIndex:int, rowCount:int):Boolean
    {
        var selectionChanged:Boolean;
        
        if (grid)
        {
            selectionChanged = grid.selectIndices(rowIndex, rowCount);
        }
        else
        {
            selectionChanged = gridSelection.setRows(rowIndex, rowCount);
            if (selectionChanged)
                dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
        }
        
        return selectionChanged;
    }
    
    //----------------------------------
    //  selection for cells
    //----------------------------------    
    
    /**
     *  @copy spark.components.Grid#selectionContainsCell()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function selectionContainsCell(rowIndex:int, columnIndex:int):Boolean
    {
        if (grid)
            return grid.selectionContainsCell(rowIndex, columnIndex);
        else
            return gridSelection.containsCell(rowIndex, columnIndex);
    }
    
    /**
     *  @copy spark.components.Grid#selectionContainsCellRegion()
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function selectionContainsCellRegion(rowIndex:int, columnIndex:int, 
                                                rowCount:int, columnCount:int):Boolean
    {
        if (grid)
        {
            return grid.selectionContainsCellRegion(
                rowIndex, columnIndex, rowCount, columnCount);
        }
        else
        {
            return gridSelection.containsCellRegion(
                rowIndex, columnIndex, rowCount, columnCount);
        }
    }
    
    /**
     *  @copy spark.components.Grid#setSelectedCell()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function setSelectedCell(rowIndex:int, columnIndex:int):Boolean
    {
        var selectionChanged:Boolean;
        
        if (grid)
        {
            selectionChanged = grid.setSelectedCell(rowIndex, columnIndex);
        }
        else
        {
            selectionChanged = gridSelection.setCell(rowIndex, columnIndex);
            if (selectionChanged)
                dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
        }
        
        return selectionChanged;
    }
    
    /**
     *  @copy spark.components.Grid#addSelectedCell()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function addSelectedCell(rowIndex:int, columnIndex:int):Boolean
    {
        var selectionChanged:Boolean;
        
        if (grid)
        {
            selectionChanged = grid.addSelectedCell(rowIndex, columnIndex);
        }
        else
        {
            selectionChanged = gridSelection.addCell(rowIndex, columnIndex);
            if (selectionChanged)
                dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
        }
        
        return selectionChanged;
    }
    
    /**
     *  @copy spark.components.Grid#removeSelectedCell()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function removeSelectedCell(rowIndex:int, columnIndex:int):Boolean
    {
        var selectionChanged:Boolean;
        
        if (grid)
        {
            selectionChanged = grid.removeSelectedCell(rowIndex, columnIndex);
        }
        else
        {
            selectionChanged = gridSelection.removeCell(rowIndex, columnIndex);
            if (selectionChanged)
                dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
        }
        
        return selectionChanged;
    }
    
    /**
     *  @copy spark.components.Grid#selectCellRegion()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function selectCellRegion(rowIndex:int, columnIndex:int, 
                                     rowCount:uint, columnCount:uint):Boolean
    {
        var selectionChanged:Boolean;
        
        if (grid)
        {
            selectionChanged = grid.selectCellRegion(
                rowIndex, columnIndex, rowCount, columnCount);
        }
        else
        {
            selectionChanged = gridSelection.setCellRegion(
                rowIndex, columnIndex, rowCount, columnCount);
            if (selectionChanged)
                dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
        }
        
        return selectionChanged;
    }    
    
    /**
     *  In response to user input (mouse or keyboard) which changes the 
     *  selection, this method dispatches the <code>selectionChanging</code> event. 
     *  If the event is not canceled, it then commits the selection change, and then 
     *  dispatches the <code>selectionChange</code> event.  
     *  The caret location is not updated.  
     *  To detect if the caret has changed, use the <code>caretChanged</code> event.
     * 
     *  @param selectionEventKind A constant defined by the GridSelectionEventKind class 
     *  that specifies the selection that is being committed.  If not null, this is used to 
     *  generate the <code>selectionChanging</code> event.
     * 
     *  @param rowIndex If <code>selectionEventKind</code> is for a row or a
     *  cell, the 0-based <code>rowIndex</code> of the selection in the 
     *  data provider. 
     *  If <code>selectionEventKind</code> is 
     *  for multiple cells, the 0-based <code>rowIndex</code> of the origin of the
     *  cell region. The default is -1 to indicate this
     *  parameter is not being used.
     * 
     *  @param columnIndex If <code>selectionEventKind</code> is for a single row or 
     *  a single cell, the 0-based <code>columnIndex</code> of the selection. 
     *  If <code>selectionEventKind</code> is for multiple 
     *  cells, the 0-based <code>columnIndex</code> of the origin of the
     *  cell region. The default is -1 to indicate this
     *  parameter is not being used.
     * 
     *  @param rowCount If <code>selectionEventKind</code> is for a cell region, 
     *  the number of rows in the cell region.  The default is -1 to indicate
     *  this parameter is not being used.
     * 
     *  @param columnCount If <code>selectionEventKind</code> is for a cell region, 
     *  the number  of columns in the cell region.  The default is -1 to 
     *  indicate this parameter is not being used.
     *
     *  @return <code>true</code> if the selection was committed or did not change, or 
     *  <code>false</code> if the selection was canceled or could not be committed due to 
     *  an error, such as index out of range or the <code>selectionEventKind</code> is not 
     *  compatible with the <code>selectionMode</code>.
     * 
     *  @see spark.events.GridSelectionEvent#SELECTION_CHANGE
     *  @see spark.events.GridSelectionEvent#SELECTION_CHANGING
     *  @see spark.events.GridSelectionEventKind
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    protected function commitInteractiveSelection(
        selectionEventKind:String,                                         
        rowIndex:int,
        columnIndex:int, 
        rowCount:int = 1, 
        columnCount:int = 1):Boolean
        
    {
        if (!grid)
            return false;
        
        // Assumes selectionEventKind is valid for given selectionMode.  Assumes
        // indices are within range.
        
        var selectionChange:CellRegion = 
            new CellRegion(rowIndex, columnIndex, rowCount, columnCount);
        
        // Step 1: determine if the selection will change if the operation.
        // is committed.  
        if (!doesChangeCurrentSelection(selectionEventKind, selectionChange))
            return true;
        
        // Step 2: dispatch the "changing" event. If preventDefault() is called
        // on this event, the selection change will be cancelled.        
        if (hasEventListener(GridSelectionEvent.SELECTION_CHANGING))
        {
            const changingEvent:GridSelectionEvent = 
                new GridSelectionEvent(GridSelectionEvent.SELECTION_CHANGING, 
                    false, true, 
                    selectionEventKind, selectionChange); 
            
            // The event was cancelled so don't change the selection.
            if (!dispatchEvent(changingEvent))
                return false;
        }
        
        // Step 3: commit the selection change.  Call the gridSelection
        // methods directly so that the caret position is not altered and 
        // a VALUE_COMMIT event is not dispatched.
        
        var changed:Boolean;
        switch (selectionEventKind)
        {
            case GridSelectionEventKind.SET_ROW:
            {
                changed = grid.gridSelection.setRow(rowIndex);
                break;
            }
            case GridSelectionEventKind.ADD_ROW:
            {
                changed = grid.gridSelection.addRow(rowIndex);
                break;
            }
                
            case GridSelectionEventKind.REMOVE_ROW:
            {
                changed = grid.gridSelection.removeRow(rowIndex);
                break;
            }
                
            case GridSelectionEventKind.SET_ROWS:
            {
                changed = grid.gridSelection.setRows(rowIndex, rowCount);
                break;
            }
                
            case GridSelectionEventKind.SET_CELL:
            {
                changed = grid.gridSelection.setCell(rowIndex, columnIndex);
                break;
            }
                
            case GridSelectionEventKind.ADD_CELL:
            {
                changed = grid.gridSelection.addCell(rowIndex, columnIndex);
                break;
            }
                
            case GridSelectionEventKind.REMOVE_CELL:
            {
                changed = grid.gridSelection.removeCell(rowIndex, columnIndex);
                break;
            }
                
            case GridSelectionEventKind.SET_CELL_REGION:
            {
                changed = grid.gridSelection.setCellRegion(
                    rowIndex, columnIndex, 
                    rowCount, columnCount);
                break;
            }
                
            case GridSelectionEventKind.SELECT_ALL:
            {
                changed = grid.gridSelection.selectAll();
                break;
            }
        }
        
        // Selection change failed for some unforseen reason.
        if (!changed)
            return false;
        
        grid.invalidateDisplayListFor("selectionIndicator");
        
        // Step 4: dispatch the "change" event.
        if (hasEventListener(GridSelectionEvent.SELECTION_CHANGE))
        {
            const changeEvent:GridSelectionEvent = 
                new GridSelectionEvent(GridSelectionEvent.SELECTION_CHANGE, 
                    false, true, 
                    selectionEventKind, selectionChange); 
            dispatchEvent(changeEvent);
            // TBD: to trigger bindings on grid selectedCell/Index/Item properties
            if (grid.hasEventListener(GridSelectionEvent.SELECTION_CHANGE))
                grid.dispatchEvent(changeEvent);
        }
        
        // Step 5: dispatch the "valueCommit" event.
        dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
        
        return true;
    }
    
    /**
     *  Updates the grid's caret position.  
     *  If the caret position changes, the <code>grid</code> skin part dispatches a 
     *  <code>caretChange</code> event.
     *
     *  @param newCaretRowIndex The 0-based rowIndex of the new caret position.
     * 
     *  @param newCaretColumnIndex The 0-based columnIndex of the new caret 
     *  position.  If the selectionMode is row-based, this is -1.
     * 
     *  @see spark.events.GridCaretEvent#CARET_CHANGE
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    protected function commitCaretPosition(newCaretRowIndex:int, 
                                           newCaretColumnIndex:int):void
    {
        grid.caretRowIndex = newCaretRowIndex;
        grid.caretColumnIndex = newCaretColumnIndex;
    }
    
    /**
     *  Creates a grid selection object to use to manage selection. Override this method if you have a custom grid 
     *  selection that you want to use in place of the default.
     *
     *  @see spark.components.Grid.createGridSelection
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    mx_internal function createGridSelection():GridSelection
    {
        return new GridSelection();    
    }
    
    //--------------------------------------------------------------------------
    //
    //  Selection Utility Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    protected function selectionContainsOnlyIndex(index:int):Boolean 
    {
        if (grid)
            return grid.selectionContainsIndex(index) && grid.selectionLength == 1;
        else
            return gridSelection.containsRow(index) && gridSelection.selectionLength == 1;
    }
    
    /**
     *  @private
     *  Return true, if the current selection, only contains the rows in
     *  the selection change.
     */
    protected function selectionContainsOnlyIndices(selectionChange:CellRegion):Boolean 
    {
        var selectionLength:int = 
            grid ? grid.selectionLength : gridSelection.selectionLength;
        
        if (selectionChange.rowCount != selectionLength)
            return false;
        
        const bottom:int = 
            selectionChange.rowIndex + selectionChange.rowCount;
        
        for (var rowIndex:int = selectionChange.rowIndex; 
            rowIndex < bottom; 
            rowIndex++)
        {
            if (grid)
            {
                if (!grid.selectionContainsIndex(rowIndex)) 
                    return false;
            }
            else
            {
                if (!gridSelection.containsRow(rowIndex))
                    return false;
            }
        }
        
        return true;        
    }
    
    /**
     *  @private
     */
    private function selectionContainsOnlyCell(rowIndex:int, columnIndex:int):Boolean
    {
        if (grid)
            return grid.selectionContainsCell(rowIndex, columnIndex) && grid.selectionLength == 1;
        else
            return gridSelection.containsCell(rowIndex, columnIndex) && gridSelection.selectionLength == 1;
    }
    
    /**
     *  @private
     */
    private function selectionContainsOnlyCellRegion(rowIndex:int, 
                                                     columnIndex:int, 
                                                     rowCount:int, 
                                                     columnCount:int):Boolean
    {
        if (grid)
        {
            return grid.selectionContainsCellRegion(
                rowIndex, columnIndex, rowCount, columnCount) &&
                grid.selectionLength == rowCount * columnCount;
        }
        else
        {
            return gridSelection.containsCellRegion(
                rowIndex, columnIndex, rowCount, columnCount) &&
                gridSelection.selectionLength == rowCount * columnCount;
        }
    }
    
    //--------------------------------------------------------------------------
    //
    //  Item Editor Methods
    //
    //--------------------------------------------------------------------------
 
	/**
	 *  Returns true if a datagrid cell is editable.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 *  
	 */ 
	protected function isCellEditable(rowIndex:int, columnIndex:int):Boolean
	{
        try
        {
            var dataItem:Object = dataProvider.getItemAt(rowIndex);
            var column:GridColumn = GridColumn(columns.getItemAt(columnIndex));
            var dataField:String = column.dataField;
        }
        catch (e:RangeError)
        {
            return false;
        }


		return isDataEditable(dataItem, dataField);
	}
	
	/**
	 *  Override to make a datagrid cell editable based on the data item.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 *  
	 */ 
	protected function isDataEditable(dataItem:Object, dataField:String):Boolean
	{
		return (dataItem != null);
	}
	
    /**
     *  Starts an editor session on a selected cell in the grid. This method  
     *  by-passes checks of the editable property on the DataGrid and GridColumn
     *  that prevent the user interface from starting an editor session.
     * 
     *  A <code>startItemEditorSession</code> event is dispatched before
     *  an item editor is created. This allows a listener dynamically change 
     *  the item editor for a specified cell. 
     * 
     *  The event can also be cancelled by calling the 
     *  <code>preventDefault()</code> method, to prevent the 
     *  editor session from being created.
     * 
     *  @param rowIndex The zero-based row index of the cell to edit.
     *
     *  @param columnIndex The zero-based column index of the cell to edit.  
     * 
     *  @return <code>true</code> if the editor session was started. 
     *  Returns <code>false</code> if the editor session was cancelled or was
     *  otherwise unable to be started. Note that an editor session cannot be
     *  started in a column that is not visible.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     *  
     */ 
    public function startItemEditorSession(rowIndex:int, columnIndex:int):Boolean
    {
        if (editor && isCellEditable(rowIndex,columnIndex))
            return editor.startItemEditorSession(rowIndex, columnIndex);
        
        return false;
    }
    
    /**
     *  Closes the currently active editor and optionally saves the editor's value
     *  by calling the item editor's <code>save()</code> method.  
     *  If the <code>cancel</code> parameter is <code>true</code>,
     *  then the editor's <code>cancel()</code> method is called instead.
     * 
     *  @param cancel If <code>false</code>, the data in the editor is saved. 
     *  Otherwise the data in the editor is discarded.
     *
     *  @return <code>true</code> if the editor session was saved, 
     *  and <code>false</code> if the save was cancelled.  
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */ 
    public function endItemEditorSession(cancel:Boolean = false):Boolean
    {
        if (editor)
            return editor.endItemEditorSession(cancel);
        
        return false;
    }
    
    /**
     *  Create the data grid editor. Overriding this function will
     *  allow the complete replacement of the data grid editor.
     */ 
    mx_internal function createEditor():DataGridEditor
    {
        return new DataGridEditor(this);    
    }

    //--------------------------------------------------------------------------
    //
    //  Sorting Methods
    //
    //--------------------------------------------------------------------------

    private function ensureComplexFieldsMonitoring(sortFields:Array):void
    {
        if(!(dataProvider is ListCollectionView))
            return;

        for (var i:int = 0; i < sortFields.length; i++)
        {
            var sortField:ISortField = sortFields[i];
            if(sortField is IComplexSortField)
                break;
        }

        /*if(i < sortFields.length)
        {
            if(!ListCollectionView(dataProvider).complexFieldWatcher)
                ListCollectionView(dataProvider).complexFieldWatcher = new ComplexFieldChangeWatcher();
        }
        else
            ListCollectionView(dataProvider).complexFieldWatcher = null;*/
    }

    /**
     *  Sort the DataGrid by one or more columns, and refresh the display.
     *
     *  <p>If the <code>dataProvider</code> is an ICollectionView, then it's <code>sort</code> property is
     *  set to a value based on each column's <code>dataField</code>, <code>sortCompareFunction</code>,
     *  and <code>sortDescending</code> flag.
     *  Then, the data provider's <code>refresh()</code> method is called. </p>
     *
     *  <p>If the <code>dataProvider</code> is not an ICollectionView, then this method has no effect.</p>
     *
     *  <p>If isInteractive is true then a <code>GridSortEvent.SORT_CHANGING</code> is dispatched before the
     *  sort is applied.  Listeners can change modify the event to change the sort or cancel
     *  the event to cancel the sort.   If isInteractive is true and the sort is not cancelled, then a
     *  <code>GridSortEvent.SORT_CHANGE</code> event is dispatched after the dataProvider's sort has been
     *  updated.</p>
     *
     *  <p>If the sort has not be cancelled, the columnHeaderGroup's <code>visibleSortIndicatorIndices</code> is updated.</p>
     *
     *  @param columnIndices The indices of the columns by which to sort the <code>dataProvider</code>.
     *
     *  @param isInteractive If true, <code>GridSortEvent.SORT_CHANGING</code> and
     *  <code>GridSortEvent.SORT_CHANGE</code> events are dispatched.
     *
     *  @return <code>true</code> if the <code>dataProvider</code> was sorted with the provided
     *  column indicies.
     *
     *  @see spark.components.DataGrid#dataProvider
     *  @see spark.components.gridClasses.GridColumn#sortCompareFunction
     *  @see spark.components.gridClasses.GridColumn#sortDescending
     *  @see spark.components.gridClasses.GridColumn#sortField
     *  @see spark.components.GridColumnHeaderGroup#visibleSortIndicatorIndices
     *  @see spark.events.GridSortEvent
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function sortByColumns(columnIndices:Vector.<int>, isInteractive:Boolean=false):Boolean
    {
       const dataProvider:ICollectionView = this.dataProvider as ICollectionView;
        if (!dataProvider)
            return false;

        var sort:ISort = dataProvider.sort;
        if (sort)
            sort.compareFunction = null;
        else
            sort = new Sort();

        var sortFields:Array = createSortFields(columnIndices, sort.fields);
        if (!sortFields || (sortFields.length == 0))
            return false;

        var oldSortFields:Array = (dataProvider.sort) ? dataProvider.sort.fields : null;

        // Dispatch the "changing" event. If preventDefault() is called
        // on this event, the sort operation will be cancelled.  If columnIndices or
        // sortFields are changed, the new values will be used.
        if (isInteractive)
        {
            // This is a shallow copy which means only the pointers to the ISortField objects
            // are copied to the new Array, not the ISortField objects themselves.
            if (oldSortFields)
                oldSortFields = oldSortFields.concat();

            if (hasEventListener(GridSortEvent.SORT_CHANGING))
            {
                const changingEvent:GridSortEvent =
                    new GridSortEvent(GridSortEvent.SORT_CHANGING,
                        false, true,
                        columnIndices,
                        oldSortFields,  /* intended to be read-only but no way to enforce this */
                        sortFields);

                // The event was cancelled so don't sort.
                if (!dispatchEvent(changingEvent))
                    return false;

                // Update the sort columns since they might have changed.
                columnIndices = changingEvent.columnIndices;
                if (!columnIndices)
                    return false;

                // Update the new sort fields since they might have changed.
                sortFields = changingEvent.newSortFields;
                if (!sortFields)
                    return false;
            }
        }

        // Remove each old SortField that's not a member of the new sortFields Array
        // as a "styleClient" of this DataGrid.

        if (oldSortFields)
        {
            for each (var oldSortField:ISortField in oldSortFields)
            {
                var oldASC:IAdvancedStyleClient = oldSortField as IAdvancedStyleClient;
                if (!oldASC || (oldASC.styleParent != this) || (sortFields.indexOf(oldASC) != -1))
                    continue;
                // removeStyleClient(oldASC);
            }
        }

        // Add new SortFields as "styleClients" of this DataGrid so that they
        // inherit this DataGrid's locale style.

        for each (var newSortField:ISortField in sortFields)
        {
            var newASC:IAdvancedStyleClient = newSortField as IAdvancedStyleClient;
            if (!newASC || (newASC.styleParent == this))
                continue;
            // addStyleClient(newASC);
        }

        ensureComplexFieldsMonitoring(sortFields);

        sort.fields = sortFields;

        dataProvider.sort = sort;
        dataProvider.refresh();

        if (isInteractive)
        {
            // Dispatch the "change" event.
            if (hasEventListener(GridSortEvent.SORT_CHANGE))
            {
                const changeEvent:GridSortEvent =
                    new GridSortEvent(GridSortEvent.SORT_CHANGE,
                        false, true,
                        columnIndices,
                        oldSortFields, sortFields);
                dispatchEvent(changeEvent);
            }

            // Update the visible sort indicators.
            /*if (columnHeaderGroup)
                columnHeaderGroup.visibleSortIndicatorIndices = columnIndices;*/
        }

        return true;
    }

    /**
     *  @private
     *  Return an array of ISortFields, one per column.   If a matching sort field is found in 
     *  previousFields then it's used, otherwise a new sort field is created.  Each sort field's 
     *  sortDescending property is set to match its column's sortDescending property.
     */
    private function createSortFields(columnIndices:Vector.<int>, previousFields:Array):Array 
    {
        const fields:Array = []; // return value
        
        for each (var columnIndex:int in columnIndices)
        {
            var col:GridColumn = this.getColumnAt(columnIndex);

            if (!col || (!col.dataField && (col.labelFunction == null) && (col.sortCompareFunction == null)))
                return null;

            var sortField:ISortField = findSortField(col.dataField, previousFields);
            
            if (!sortField)
            {
                //Constructs a new sortField from the columns own sortField property.
                sortField = col.sortField;
            }
            else
            {
                sortField.descending = col.sortDescending;
            }

            fields.push(sortField);
        }
        
        return fields;
    }
    
    /**
     *  @private
     *  Finds a SortField using the provided dataField and returns it.
     *
     *  @param dataField The dataField of the column.
     *  @param fields The array of SortFields to search through.
     */
    private static function findSortField(dataField:String, fields:Array):ISortField
    {
        if (dataField == null)
            return null;
        
        for each (var field:ISortField in fields)
        {
            if (field.name == dataField)
                return field;
        }
        
        return null;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  @return True if there is an anchor position set.
     */    
    private function isAnchorSet():Boolean
    {
        if (!grid)
            return false;
        
        if (isRowSelectionMode())
            return grid.anchorRowIndex != -1;
        else
            return grid.anchorRowIndex != -1 && grid.anchorRowIndex != -1;
    }
    
    /**
     *  @private
     *  Toggle the selection and set the caret to rowIndex/columnIndex.
     * 
     *  @return True if the selection has changed.
     */
    private function toggleSelection(rowIndex:int, columnIndex:int):Boolean
    {
        var kind:String;
        
        if (isRowSelectionMode())
        { 
            if (grid.selectionContainsIndex(rowIndex))
                kind = GridSelectionEventKind.REMOVE_ROW;
            else if (selectionMode == GridSelectionMode.MULTIPLE_ROWS)
                kind = GridSelectionEventKind.ADD_ROW;
            else
                kind = GridSelectionEventKind.SET_ROW;
            
        }
        else if (isCellSelectionMode())
        {
            if (grid.selectionContainsCell(rowIndex, columnIndex))
                kind = GridSelectionEventKind.REMOVE_CELL;
            else if (selectionMode == GridSelectionMode.MULTIPLE_CELLS)
                kind = GridSelectionEventKind.ADD_CELL;
            else
                kind = GridSelectionEventKind.SET_CELL;
        }
        
        var success:Boolean = 
            commitInteractiveSelection(kind, rowIndex, columnIndex);
        
        // Update the caret if the selection was not cancelled.
        if (success)
            commitCaretPosition(rowIndex, columnIndex);
        
        return success;
    }
    
    /**
     *  @private
     *  Extends the selection from the anchor position to the given 'caret'
     *  position and updates the caret position.
     */
    private function extendSelection(caretRowIndex:int, 
                                     caretColumnIndex:int):Boolean
    {
        if (!isAnchorSet())
            return false;
        
        const startRowIndex:int = Math.min(grid.anchorRowIndex, caretRowIndex);
        const endRowIndex:int = Math.max(grid.anchorRowIndex, caretRowIndex);
        var success:Boolean;
        
        if (selectionMode == GridSelectionMode.MULTIPLE_ROWS)
        {
            success = commitInteractiveSelection(
                GridSelectionEventKind.SET_ROWS,
                startRowIndex, -1,
                endRowIndex - startRowIndex + 1, 0);
        }
        else if (selectionMode == GridSelectionMode.SINGLE_ROW)
        {
            // Can't extend the selection so move it to the caret position.
            success = commitInteractiveSelection(
                GridSelectionEventKind.SET_ROW, caretRowIndex, -1, 1, 0);                
        }
        else if (selectionMode == GridSelectionMode.MULTIPLE_CELLS)
        {
            const rowCount:int = endRowIndex - startRowIndex + 1;
            const startColumnIndex:int = 
                Math.min(grid.anchorColumnIndex, caretColumnIndex);
            const endColumnIndex:int = 
                Math.max(grid.anchorColumnIndex, caretColumnIndex); 
            const columnCount:int = endColumnIndex - startColumnIndex + 1;
            
            success = commitInteractiveSelection(
                GridSelectionEventKind.SET_CELL_REGION, 
                startRowIndex, startColumnIndex,
                rowCount, columnCount);
        }            
        else if (selectionMode == GridSelectionMode.SINGLE_CELL)
        {
            // Can't extend the selection so move it to the caret position.
            success = commitInteractiveSelection(
                GridSelectionEventKind.SET_CELL, 
                caretRowIndex, caretColumnIndex, 1, 1);                
        }
        
        // Update the caret.
        if (success)
            commitCaretPosition(caretRowIndex, caretColumnIndex);
        
        return success;
    }
    
    /**
     *  @private
     *  Sets the selection and updates the caret and anchor positions.
     */
    private function setSelectionAnchorCaret(rowIndex:int, columnIndex:int):Boolean
    {
        // click sets the selection and updates the caret and anchor 
        // positions.
        var success:Boolean;
        if (isRowSelectionMode())
        {
            // Select the row.
            success = commitInteractiveSelection(
                GridSelectionEventKind.SET_ROW, 
                rowIndex, columnIndex);
        }
        else if (isCellSelectionMode())
        {
            // Select the cell.
            success = commitInteractiveSelection(
                GridSelectionEventKind.SET_CELL, 
                rowIndex, columnIndex);
        }
        
        // Update the caret and anchor positions unless cancelled.
        if (success)
        {
            commitCaretPosition(rowIndex, columnIndex);
            grid.anchorRowIndex = rowIndex;
            grid.anchorColumnIndex = columnIndex; 
        }    
        
        return success;
    }
    
    /**
     *  @private
     *  Returns the new caret position based on the current caret position and 
     *  the navigationUnit as a Point, where x is the columnIndex and y is the 
     *  rowIndex.  Assures there is a valid caretPosition.
     */
    private function setCaretToNavigationDestination(navigationUnit:uint):CellPosition
    {
        var caretRowIndex:int = grid.caretRowIndex;
        var caretColumnIndex:int = grid.caretColumnIndex;
        
		const rowCount:int = dataProviderLength;
        const columnCount:int = columnsLength;
        
        const gridLayout:GridLayout = grid.layout as GridLayout;
        const centerGridView:GridView = gridLayout.centerGridView;
        const topGridView:GridView = gridLayout.topGridView;
        var caretGridView:GridView;
        
        switch (navigationUnit)
        {
            case NavigationUnit.LEFT: 
            {
                if (isCellSelectionMode())
                {
                    if (grid.caretColumnIndex > 0)
                        caretColumnIndex = grid.getPreviousVisibleColumnIndex(caretColumnIndex);
                }
                break;
            }
                
            case NavigationUnit.RIGHT:
            {
                if (isCellSelectionMode())
                {
                    if (grid.caretColumnIndex + 1 < columnCount)
                        caretColumnIndex = grid.getNextVisibleColumnIndex(caretColumnIndex);
                }
                break;
            } 
                
            case NavigationUnit.UP:
            {
                if (grid.caretRowIndex > 0)
                    caretRowIndex--;
                break; 
            }
                
            case NavigationUnit.DOWN:
            {
                if (grid.caretRowIndex + 1 < rowCount)
                    caretRowIndex++;
                break; 
            }
                
            case NavigationUnit.PAGE_UP:
            {
                // If the caret is below the first visible row, then just move the caret up to
                // the first visible row.   Otherwise scroll up far enough to put the caret row
                // at the top of the view.
                
                caretGridView = ((lockedRowCount > 0) && (caretRowIndex <= lockedRowCount)) ? topGridView : centerGridView;
                const firstVisibleRowIndex:int = caretGridView.gridViewLayout.getFirstFullyVisibleRowIndex();
                
                if (caretRowIndex > firstVisibleRowIndex)
                {
                    caretRowIndex = firstVisibleRowIndex;
                }
                else if (caretRowIndex >= lockedRowCount)
                {
                    // Attempt to synchronously scroll caretRowIndex to bottom of the view 
                    // and then reset the caretRowIndex to whatever row actually ends up at the top.
                    
                    const caretRowBounds:Rectangle = grid.getRowBounds(caretRowIndex);
                    const visibleBounds:Rectangle = centerGridView.gridViewLayout.getVisibleBounds();
                    const pageUpDelta:Number = visibleBounds.bottom - caretRowBounds.bottom;
                    grid.verticalScrollPosition -= pageUpDelta;
                    validateNow();
                    
                    caretRowIndex = centerGridView.gridViewLayout.getFirstFullyVisibleRowIndex();                    
                }
                
                break;
            }
                
            case NavigationUnit.PAGE_DOWN:
            {
                // If the caret is on the last locked row, move to the first unlocked row.  Otherwise:
                // If the caret is above the last visible row, then just move the caret to the last visible row.  
                // Otherwise scroll down far enough to position the caret row at the top of the grid view and 
                // then reset the caret to the new last fully visible row.
                
                caretGridView = ((lockedRowCount > 0) && (caretRowIndex < (lockedRowCount - 1))) ? topGridView : centerGridView;
                const lastVisibleRowIndex:int = caretGridView.gridViewLayout.getLastFullyVisibleRowIndex();
                
                if ((lockedRowCount > 0) && (rowCount > lockedRowCount) && (caretRowIndex == (lockedRowCount - 1)))
                {
                    caretRowIndex = lockedRowCount;
                }
                else if (caretRowIndex < lastVisibleRowIndex)
                {
                    caretRowIndex = lastVisibleRowIndex;
                }
                else if (caretRowIndex >= lockedRowCount)
                {
                    // Attempt to synchronously scroll caretRowIndex to the top of the view 
                    // and then reset the caretRowIndex to whatever row actually ends up at the bottom.
                    
                    grid.verticalScrollPosition = grid.getRowBounds(caretRowIndex).y;
                    validateNow();
                    
                    caretRowIndex = centerGridView.gridViewLayout.getLastFullyVisibleRowIndex();                    
                }
                
                break; 
            }
                
            case NavigationUnit.HOME:
            {
                caretRowIndex = 0;
                caretColumnIndex = isCellSelectionMode() ? grid.getNextVisibleColumnIndex(-1) : -1; 
                break;
            }
                
            case NavigationUnit.END:
            {
                caretRowIndex = rowCount - 1;
                caretColumnIndex = isCellSelectionMode() ? grid.getPreviousVisibleColumnIndex(columnCount) : -1;
                
                // The heights of any rows that have not been rendered yet are
                // estimated.  Force them to draw so the heights are accurate.
                // TBD: is there a better way to do this?
                grid.verticalScrollPosition = grid.contentHeight;
                validateNow();
                if (grid.contentHeight != grid.verticalScrollPosition)
                {
                    grid.verticalScrollPosition = grid.contentHeight;
                    validateNow();
                }
                break;
            }
                
            default: 
            {
                return null;
            }
        }
        
        return new CellPosition(caretRowIndex, caretColumnIndex);
    }
    
    /**
     *  @copy spark.components.Grid#ensureCellIsVisible()
     *
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    public function ensureCellIsVisible(rowIndex:int, columnIndex:int = -1):void
    {
        if (grid)
            grid.ensureCellIsVisible(rowIndex, columnIndex);
    }
    
    /**
     *  @private
     * 
     *  Adjusts the caret and the selection based on what keystroke is used
     *  in combination with a ctrl/cmd key or a shift key.  Returns false
     *  if the selection was not changed.
     */
    protected function adjustSelectionUponNavigation(event:KeyboardEvent):Boolean
    {
        // Some unrecognized key stroke was entered, return. 
        if (!NavigationUnit.isNavigationUnit(event.keyCode))
            return false; 
        
        // If rtl layout, need to swap Keyboard.LEFT and Keyboard.RIGHT.
        var navigationUnit:uint = 0; //mapKeycodeForLayoutDirection(event);
        
        const newPosition:CellPosition = setCaretToNavigationDestination(navigationUnit);
        if (!newPosition)
            return false;
        
        // Cancel so another component doesn't handle this event.
        event.preventDefault(); 
        
        if (event.shiftKey)
        {
            // The shift key-nav key combination extends the selection and 
            // updates the caret.
            extendSelection(newPosition.rowIndex, newPosition.columnIndex);
        }
        else if (event.ctrlKey)
        {
            // If its a ctrl/cmd key-nav key combination, there is nothing
            // more to do then set the caret.
            commitCaretPosition(newPosition.rowIndex, newPosition.columnIndex);
        }
        else
        {
            // Select the current row/cell.
            setSelectionAnchorCaret(newPosition.rowIndex, newPosition.columnIndex);
        }
        
        // Ensure this position is visible.
        ensureCellIsVisible(newPosition.rowIndex, newPosition.columnIndex);
        
        return true;
    }
    
    /**
     *  @private
     * 
     *  Returns true if committing the given selection operation would change
     *  the current selection.
     */
    private function doesChangeCurrentSelection(
        selectionEventKind:String, 
        selectionChange:CellRegion):Boolean
    {
        var changesSelection:Boolean;
        
        const rowIndex:int = selectionChange.rowIndex;
        const columnIndex:int = selectionChange.columnIndex;
        const rowCount:int = selectionChange.rowCount;
        const columnCount:int = selectionChange.columnCount;
        
        switch (selectionEventKind)
        {
            case GridSelectionEventKind.SET_ROW:
            {
                changesSelection = 
                    !selectionContainsOnlyIndex(rowIndex);
                break;
            }
            case GridSelectionEventKind.ADD_ROW:
                
            {
                changesSelection = 
                    !grid.selectionContainsIndex(rowIndex);
                break;
            }
                
            case GridSelectionEventKind.REMOVE_ROW:
            {
                changesSelection = requireSelection ?
                    !selectionContainsOnlyIndex(rowIndex) :
                    grid.selectionContainsIndex(rowIndex);
                break;
            }
                
            case GridSelectionEventKind.SET_ROWS:
            {
                changesSelection = 
                    !selectionContainsOnlyIndices(selectionChange);
                break;
            }
                
            case GridSelectionEventKind.SET_CELL:
            {
                changesSelection = 
                    !selectionContainsOnlyCell(rowIndex, columnIndex);
                break;
            }
                
            case GridSelectionEventKind.ADD_CELL:
            {
                changesSelection = 
                    !grid.selectionContainsCell(rowIndex, columnIndex);
                break;
            }
                
            case GridSelectionEventKind.REMOVE_CELL:
            {
                changesSelection = requireSelection ?
                    !selectionContainsOnlyCell(rowIndex, columnIndex) :                  
                    grid.selectionContainsCell(rowIndex, columnIndex);
                break;
            }
                
            case GridSelectionEventKind.SET_CELL_REGION:
            {
                changesSelection = 
                    !selectionContainsOnlyCellRegion(
                        rowIndex, columnIndex, rowCount, columnCount);
                break;
            }
                
            case GridSelectionEventKind.SELECT_ALL:
            {
                changesSelection = true;
                break;
            }
        }
        
        return changesSelection;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Grid event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Updating the hover is disabled if the mouse button was depressed
     *  while not over the grid.  The common case for this is while 
     *  scrolling.  While the scroll thumb is depressed don't want the 
     *  hover updated if the mouse drifts into the grid.
     */
    protected function grid_rollOverHandler(event:GridEvent):void
    {
        if (event.isDefaultPrevented())
            return;
        
        // The related object is the object that was previously under
        // the pointer.
        if (event.buttonDown && event.relatedObject != grid)
            updateHoverOnRollOver = false;
        
        grid.hoverRowIndex = updateHoverOnRollOver ? event.rowIndex : -1;
        grid.hoverColumnIndex = updateHoverOnRollOver ? event.columnIndex : -1;
        
        // event.updateAfterEvent();        
    }
    
    /**
     *  @private
     *  If the mouse button is depressed while outside of the grid, the hover 
     *  indicator is not enabled again until GRID_MOUSE_UP or GRID_ROLL_OUT. 
     */
    protected function grid_rollOutHandler(event:GridEvent):void
    {
        if (event.isDefaultPrevented())
            return;
        
        grid.hoverRowIndex = -1;
        grid.hoverColumnIndex = -1;
        
        updateHoverOnRollOver = true;
        // event.updateAfterEvent();
    }
    
    /**
     *  @private
     *  If the mouse button is depressed while outside of the grid, the hover 
     *  indicator is not enabled again until GRID_MOUSE_UP or GRID_ROLL_OUT. 
     */
    protected function grid_mouseUpHandler(event:GridEvent):void
    {
        if (event.isDefaultPrevented())
            return;
        
        if (!updateHoverOnRollOver)
        {
            grid.hoverRowIndex = event.rowIndex;
            grid.hoverColumnIndex = event.columnIndex;
            updateHoverOnRollOver = true;
        }

        // removeMouseHandlersForDragStart(event);
    }
    
    /**
     *  @private
     */
    protected function grid_mouseDownHandler(event:GridEvent):void
    {
        if (event.isDefaultPrevented())
            return;
        
        const isCellSelection:Boolean = isCellSelectionMode();
        
        const rowIndex:int = event.rowIndex;
        const columnIndex:int = isCellSelection ? event.columnIndex : -1;
        
        // Clicked on empty place in grid.  Don't change selection or caret
        // position.
        if (rowIndex == -1 || isCellSelection && columnIndex == -1)
            return;

        if (dragEnabled && isRowSelectionMode() && selectionContainsIndex(rowIndex))
        {
            pendingSelectionOnMouseUp = true;
        }
        else
        {
            // adjustSelection(event, rowIndex, columnIndex);
        }

        // If selection is pending on mouse up then we have just moused down on
        // an item, part of an already commited selection.
        // However if we moused down on an item that's not currently selected,
        // we must commit the selection before trying to start dragging since
        // listeners may prevent the item from being selected.
        if (!pendingSelectionOnMouseUp)
            validateProperties();
        
        mouseDownPoint = event.target.localToGlobal(new Point(event.localX, event.localY));
        // mouseDownObject = event.target as DisplayObject;
        mouseDownRowIndex = rowIndex;
        mouseDownColumnIndex = columnIndex;
        
        var listenForDrag:Boolean = dragEnabled &&
            getStyle("interactionMode") == InteractionMode.MOUSE && selectedIndices && 
            this.selectedIndices.indexOf(rowIndex) != -1;
        // Handle any drag gestures that may have been started
        if (listenForDrag)
        {
            // Listen for GRID_MOUSE_DRAG.
            // The user may have clicked on the item renderer close
            // to the edge of the list, and we still want to start a drag
            // operation if they move out of the list.
            // grid.addEventListener(GridEvent.GRID_MOUSE_DRAG, grid_mouseDragHandler);
        }
        
        if (pendingSelectionOnMouseUp || listenForDrag)
        {
            // FIXME (dloverin): When dragging a proxy in an untrusted 
            // child application the cursor does not follow drag proxy.
            
            // FIXME (dloverin): The listener on the sandbox root can be removed when:
            // 1. MouseEventUtil.addDownDragUpListeners() dispatches
            //    a MOUSE_UP_SOMEWHERE.
            // 2. Grid.grid_mouseDownDragUpHandler() changes its parameter from
            //    a MouseEvent to an event so a MOUSE_UP_SOMEWHERE event does 
            //    not cause an RTE. Grid can then handle the MOUSE_UP_SOMEWHERE
            //    event by dispatching a MOUSE_UP or aGRID_MOUSE_UP_SOMEWHERE 
            //    event.
            // systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, sandbox_mouseUpHandler, false, 0, true);
        }
        
    }
    
    private function adjustSelection(event:MouseEvent, rowIndex:int, columnIndex:int):void
    {
        if (event.ctrlKey)
        {
            // ctrl-click toggles the selection and updates caret and anchor.
            if (!toggleSelection(rowIndex, columnIndex))
                return;

            grid.anchorRowIndex = rowIndex;
            grid.anchorColumnIndex = columnIndex;
        }
        else if (event.shiftKey)
        {
            // shift-click extends the selection and updates the caret.
            if  (grid.selectionMode == GridSelectionMode.MULTIPLE_ROWS || grid.selectionMode == GridSelectionMode.MULTIPLE_CELLS)
                extendSelection(rowIndex, columnIndex);
        }
        else
        {
            // click sets the selection and updates the caret and anchor positions.
            setSelectionAnchorCaret(rowIndex, columnIndex);
        }
    }

    /**
     *  @private
     *  Redispatch the grid's "caretChange" event.
     */
    protected function grid_caretChangeHandler(event:GridCaretEvent):void
    {
        if (hasEventListener(GridCaretEvent.CARET_CHANGE))
            dispatchEvent(event);
    }
    
    /**
     *  @private
     *  Redispatch the grid's "valueCommit" event.
     */
    protected function grid_valueCommitHandler(event:FlexEvent):void
    {
        if (hasEventListener(FlexEvent.VALUE_COMMIT))
            dispatchEvent(event);
    }
    
    /**
     *  @private
     */
    private function grid_invalidateDisplayListHandler(event:Event):void
    {
        // invalidate all IDataGridElements
        /*if (columnHeaderGroup && grid.isInvalidateDisplayListReason("horizontalScrollPosition"))
            columnHeaderGroup.invalidateDisplayList();*/
    }
    
    /**
     *  @private
     */
    private function grid_invalidateSizeHandler(event:Event):void
    {
        // invalidate all IDataGridElements
        /*if (columnHeaderGroup)
            columnHeaderGroup.invalidateSize();*/
    }
    
    /**
     *  @private
     */
    private function grid_gridViewsChangedHandler(event:Event):void
    {
        /*if (columnHeaderGroup)
            columnHeaderGroup.configureGridColumnHeaderViews();*/
    }   
    
    //--------------------------------------------------------------------------
    //
    //  Header event handlers
    //
    //--------------------------------------------------------------------------  
    
    private var stretchCursorID:int = 0; //CursorManager.NO_CURSOR;
    private var resizeColumn:GridColumn = null;
    private var resizeAnchorX:Number = NaN;
    private var resizeColumnWidth:Number = NaN;
    private var nextColumn:GridColumn = null;  // RTL layout only
    private var nextColumnWidth:Number = NaN;  // RTL layout only
    
    /**
     *  @private
     *  Flip the specified column's sortDescending flag and and sort the dataProvider.   If 
     *  isMultiColumnSort is true, add the column to the set of columns being sorted (that's
     *  columnHeaderGroup.visibleSortIndicatorIndices) otherwise just sort per the specified column.
     * 
     *  If the sort was possible and was not cancelled (see sortByColumns()) then set the 
     *  columnHeaderGroup's selectedColumnIndex and return true, otherwise return false.
     */
    private function interactiveSortByColumns(column:GridColumn, isMultiColumnSort:Boolean):Boolean
    {
        /*if (!enabled || !sortableColumns || !column || !column.sortable || !columnHeaderGroup)
            return false;
                
        const columnIndex:int = column.columnIndex;
        const currentSortColumnIndices:Vector.<int> = columnHeaderGroup.visibleSortIndicatorIndices;
        const reverseSort:Boolean = currentSortColumnIndices.indexOf(columnIndex) != -1;        
        var sortColumnIndices:Vector.<int>;
        
        if (isMultiColumnSort && multiColumnSortingEnabled)
        {
            sortColumnIndices = currentSortColumnIndices;
            if (!reverseSort)
                sortColumnIndices.push(columnIndex);
        }
        else
        {
            sortColumnIndices = new <int>[columnIndex];
        }
        
        if (reverseSort)
            column.sortDescending = !column.sortDescending;
        
        if (!sortByColumns(sortColumnIndices, true) && reverseSort)
        {
            column.sortDescending = !column.sortDescending;    // sort was cancelled 
            return false;
        }
        
        columnHeaderGroup.selectedColumnIndex = column.columnIndex;*/
        
        return true;
    }
    
    /**
     *  @private
     */
    /*protected function columnHeaderGroup_clickHandler(event:GridEvent):void
    {
       interactiveSortByColumns(event.column, event.ctrlKey);
    }*/
    
    /**
     *  @private
     */
    /*protected function columnHeaderGroup_rollOverHandler(event:GridEvent):void
    {
        if (resizeColumn || !enabled)
            return;
        
        columnHeaderGroup.hoverColumnIndex = event.columnIndex;
    } */   
    
    /**
     *  @private
     */
    /*protected function columnHeaderGroup_rollOutHandler(event:GridEvent):void
    {
        if (!enabled)
            return;
        
        columnHeaderGroup.hoverColumnIndex = -1;       
    }*/
    
    /**
     *  @private
     */
    protected function separator_mouseDownHandler(event:GridEvent):void
    {
        /*const column:GridColumn = event.column;
        if (!enabled || !grid.resizableColumns || !column || !column.resizable)
            return;
        
        resizeColumn = event.column;
        resizeAnchorX = event.localX;
        resizeColumnWidth = grid.getColumnWidth(resizeColumn.columnIndex);
        
        // If we're laying out RTL then dragging to the left - which increases
        // a column's width - and the Grid's width is unconstrained, then only
        // allow the column's width to grow to the extent that the adjacent 
        // (next) column can shrink. 
        
        if (isNaN(explicitWidth) && (layoutDirection == LayoutDirection.RTL))
        {
            const nextColumnIndex:int = grid.getNextVisibleColumnIndex(resizeColumn.columnIndex);
            nextColumn = getColumnAt(nextColumnIndex);
            nextColumnWidth = Math.ceil(grid.getColumnWidth(nextColumnIndex));           
        }
        else
        {
            nextColumn = null;
            nextColumnWidth = NaN;
        }
        
        // Give all of the columns to the left of this one an explicit so that resizing
        // this column doesn't change their width and, consequently, this column's location.
        
        const resizeColumnIndex:int = resizeColumn.columnIndex;
        for (var columnIndex:int = 0; columnIndex < resizeColumnIndex; columnIndex++)
        {
            var gc:GridColumn = getColumnAt(columnIndex);
            if (gc.visible && isNaN(gc.width))
                gc.width = grid.getColumnWidth(columnIndex);
        }*/
    }    
    
    /**
     *  @private
     */
    protected function separator_mouseDragHandler(event:GridEvent):void
    {
        if (!resizeColumn)
            return;
        
        const widthDelta:Number = event.localX - resizeAnchorX;
        const minWidth:Number = isNaN(resizeColumn.minWidth) ? 0 : resizeColumn.minWidth;
        const maxWidth:Number = resizeColumn.maxWidth;
        var newWidth:Number = Math.ceil(resizeColumnWidth + widthDelta);
        
        // Layout is RTL (see sparator_mouseDownHandler). Make sure that the
        // next column's width can shrink as much as the resizeColumn is growing,
        // or vice versa.
        
        if (nextColumn)
        {
            const nextMinWidth:Number = isNaN(nextColumn.minWidth) ? 0 : nextColumn.minWidth;
            
            if (Math.ceil(nextColumnWidth - widthDelta) <= nextMinWidth)
                return;
            if (Math.ceil(resizeColumnWidth + widthDelta) <= minWidth)
                return;
            
            nextColumn.width = nextColumnWidth - widthDelta;
        }
        
        newWidth = Math.max(newWidth, minWidth);
        if (!isNaN(maxWidth))
            newWidth = Math.min(newWidth, maxWidth);
        
        resizeColumn.width = newWidth;
        validateNow();  // smooth out the drag
        // event.updateAfterEvent();
    } 
    
    /**
     *  @private
     */
    protected function separator_mouseUpHandler(event:GridEvent):void
    {
        if (!resizeColumn)
            return;
        
        resizeColumn = null;
        cursorManager.removeCursor(stretchCursorID);        
    }     
    
    /**
     *  @private
     */
    protected function separator_rollOverHandler(event:GridEvent):void
    {
        /*const column:GridColumn = event.column;
        if (resizeColumn || !enabled || !grid.resizableColumns || !column || !column.resizable)
            return;
        
        var stretchCursorClass:Class = getStyle("stretchCursor") as Class;
        if (stretchCursorClass)
            stretchCursorID = cursorManager.setCursor(stretchCursorClass, CursorManagerPriority.HIGH, 0, 0);*/
    }
    
    /**
     *  @private
     */
    protected function separator_rollOutHandler(event:GridEvent):void
    {
        if (!enabled || resizeColumn)
            return;
        
        cursorManager.removeCursor(stretchCursorID);
    }     
    
    //--------------------------------------------------------------------------
    //
    //  DataGrid event handlers
    //
    //--------------------------------------------------------------------------  
    
    /**
     *  @private
     *  The UIComponent's focusInHandler and focusOutHandler draw the
     *  focus.  This handler exists only when there is a caretIndicator part.
     */
    protected function dataGrid_focusHandler(event:FocusEvent):void
    {
        /*if (!grid)
            return;
        
        const isFocusIn:Boolean = event.type == FocusEvent.FOCUS_IN;
        const isFocusOut:Boolean = event.type == FocusEvent.FOCUS_OUT; 
        
        if (isOurFocus(DisplayObject(event.target)))
            grid.showCaret = isFocusIn && (selectionMode != GridSelectionMode.NONE);
        
        if (isFocusIn)
            internalFocusOwner = GRID_FOCUS_OWNER;
        else if (isFocusOut)
            internalFocusOwner = NO_FOCUS_OWNER;*/
    }
    
    //--------------------------------------------------------------------------
    //
    //  Drag methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  The default handler for the <code>dragStart</code> event.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    protected function dragStartHandler(event:DragEvent):void
    {
        if (event.isDefaultPrevented())
            return;
        
        var dragSource:DragSource = new DragSource();
        addDragData(dragSource);
        DragManager.doDrag(this, 
            dragSource, 
            event, 
            createDragIndicator(), 
            0 /*xOffset*/, 
            0 /*yOffset*/, 
            0.5 /*imageAlpha*/, 
            dragMoveEnabled);
    }
    
    /**
     *  @private
     *  Used to sort the selected indices during drag and drop operations.
     */
    private function compareValues(a:int, b:int):int
    {
        return a - b;
    } 
    
    /**
     *  @private
     *  Handles <code>DragEvent.DRAG_COMPLETE</code> events.  This method
     *  removes the items from the data provider.
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    protected function dragCompleteHandler(event:DragEvent):void
    {
        /*if (event.isDefaultPrevented())
            return;
        
        // Remove the dragged items only if they were drag moved to
        // a different list. If the items were drag moved to this
        // list, the reordering was already handles in the 
        // DragEvent.DRAG_DROP listener.
        if (!dragMoveEnabled ||
            event.action != DragManager.MOVE || 
            event.relatedObject == this)
            return;
        
        // Clear the selection, but remember which items were moved
        var movedIndices:Vector.<int> = selectedIndices;
        selectedIndices = new Vector.<int>();
        validateProperties(); // To commit the selection
        
        // Remove the moved items
        movedIndices.sort(compareValues);
        var count:int = movedIndices.length;
        for (var i:int = count - 1; i >= 0; i--)
        {
            dataProvider.removeItemAt(movedIndices[i]);
        }*/
    }
    
    /**
     *  Creates an instance of a class that is used to display the visuals
     *  of the dragged items during a drag and drop operation.
     *  The default <code>DragEvent.DRAG_START</code> handler passes the
     *  instance to the <code>DragManager.doDrag()</code> method.
     *
     *  @return The IFlexDisplayObject representing the drag indicator.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    public function createDragIndicator():IFlexDisplayObject
    {
        var dragIndicator:IFlexDisplayObject;
        var dragIndicatorClass:Class = Class(getStyle("dragIndicatorClass"));
        if (dragIndicatorClass)
        {
            dragIndicator = new dragIndicatorClass();
            if (dragIndicator is IVisualElement)
                IVisualElement(dragIndicator).owner = this;
        }
        
        return dragIndicator;
    }
    
    /**
     *  Adds the selected items to the DragSource object as part of
     *  a drag-and-drop operation.
     *  Override this method to add other data to the drag source.
     * 
     *  @param dragSource The DragSource object to which to add the data.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    public function addDragData(dragSource:DragSource):void
    {
        dragSource.addHandler(copySelectedItemsForDragDrop, "itemsByIndex");
        
        // Calculate the index of the focus item within the vector
        // of ordered items returned for the "itemsByIndex" format.
        var caretIndex:int = 0;
        var draggedIndices:Vector.<int> = selectedIndices;
        var count:int = draggedIndices.length;
        for (var i:int = 0; i < count; i++)
        {
            if (mouseDownRowIndex > draggedIndices[i])
                caretIndex++;
        }
        dragSource.addData(caretIndex, "caretIndex");
    }
    
    /**
     *  @private
     */
    private function copySelectedItemsForDragDrop():Vector.<Object>
    {
        // Copy the vector so that we don't modify the original
        // since selectedIndices returns a reference.
        var draggedIndices:Vector.<int> = selectedIndices.slice(0, selectedIndices.length);
        var result:Vector.<Object> = new Vector.<Object>(draggedIndices.length);
        
        // Sort in the order of the data source
        draggedIndices.sort(compareValues);
        
        // Copy the items
        var count:int = draggedIndices.length;
        for (var i:int = 0; i < count; i++)
            result[i] = dataProvider.getItemAt(draggedIndices[i]);  
        return result;
    }
    
    /**
     *  @private
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
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    protected function grid_mouseDragHandler(event:MouseEvent):void
    {
        /*if (!mouseDownPoint || !dragEnabled)
            return;
        
        var pt:Point = new Point(event.localX, event.localY);
        pt = DisplayObject(event.target).localToGlobal(pt);
        
        const DRAG_THRESHOLD:int = 5;
        
        if (Math.abs(mouseDownPoint.x - pt.x) > DRAG_THRESHOLD ||
            Math.abs(mouseDownPoint.y - pt.y) > DRAG_THRESHOLD)
        {
            var dragEvent:DragEvent = new DragEvent(DragEvent.DRAG_START);
            dragEvent.dragInitiator = this;
            
            var localMouseDownPoint:Point = this.globalToLocal(mouseDownPoint);
            
            dragEvent.localX = localMouseDownPoint.x;
            dragEvent.localY = localMouseDownPoint.y;
            dragEvent.buttonDown = true;
            
            // We're starting a drag operation, remove the handlers
            // that are monitoring the mouse move, we don't need them anymore:
            dispatchEvent(dragEvent);
            
            var gridEvent:GridEvent = new GridEvent(GridEvent.GRID_MOUSE_UP, false, false, event.localX, event.localY,
                event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown, event.delta);
            
            // Finally, remove the mouse handlers
            removeMouseHandlersForDragStart(gridEvent);
        }*/
    }
    
    private function removeMouseHandlersForDragStart(event:MouseEvent):void
    {
        // If dragging failed, but we had a pending selection, commit it here
        /*if (pendingSelectionOnMouseUp && !DragManager.isDragging)
            adjustSelection(event, mouseDownRowIndex, mouseDownColumnIndex);
        
        // Always clean up the flag, even if currently dragging.
        pendingSelectionOnMouseUp = false;
        
        mouseDownPoint = null;
        mouseDownObject = null;
        mouseDownRowIndex = -1;
        mouseDownColumnIndex = -1;
        
        grid.removeEventListener(GridEvent.GRID_MOUSE_DRAG, grid_mouseDragHandler);
        systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE, sandbox_mouseUpHandler, false);*/
    }
    
    /**
     *  @private
     *  Handles <code>SandboxMouseEvent.MOUSE_UP_SOMEWHERE</code> events.
     *
     *  @param event The SandboxMouseEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function sandbox_mouseUpHandler(event:SandboxMouseEvent):void
    {
        /*var sandboxMouseEvent:SandboxMouseEvent = SandboxMouseEvent(event);
        var gridEvent:GridEvent = new GridEvent(GridEvent.GRID_MOUSE_UP, false, false, NaN, NaN, null,
            sandboxMouseEvent.ctrlKey, sandboxMouseEvent.altKey, sandboxMouseEvent.shiftKey, 
            sandboxMouseEvent.buttonDown, 0);
        
        removeMouseHandlersForDragStart(gridEvent);*/
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Drop methods
    //
    //--------------------------------------------------------------------------
    
    /**
    *  @private
    *  Used in drag n drop methods for drop location / drop indicators.
    */
    private var _gridViewLayout:GridViewLayout = null;


    /**
     *  Creates and instance of the dropIndicator class that is used to
     *  display the visuals of the drop location during a drag and drop
     *  operation. The instance is set in the layout's 
     *  <code>dropIndicator</code> property.
     *
     *  <p>If you override the <code>dragEnter</code> event handler, 
     *  and call <code>preventDefault()</code> so that the default handler does not execute, 
     *  call <code>createDropIndicator()</code> to create the drop indicator.</p>
     * 
     *  @return Returns the dropIndicator that was set in the layout.
     *
     *  @see #destroyDropIndicator
     *
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    /*public function createDropIndicator():DisplayObject
    {
        // Do we have a drop indicator already?
        if (_gridViewLayout.dropIndicator)
            return _gridViewLayout.dropIndicator;


        var dropIndicatorInstance:DisplayObject;

        if (dropIndicator)
        {
            dropIndicatorInstance = DisplayObject(createDynamicPartInstance("dropIndicator"));
        }
        else
        {
            var dropIndicatorClass:Class = Class(getStyle("dropIndicatorSkin"));
            if (dropIndicatorClass)
                dropIndicatorInstance = new dropIndicatorClass();
        }

        if (dropIndicatorInstance is IVisualElement)
            IVisualElement(dropIndicatorInstance).owner = this;
        
        // Set it in the layout
        _gridViewLayout.dropIndicator = dropIndicatorInstance;

        return dropIndicatorInstance;
    }*/
    
    /**
     *  Releases the <code>dropIndicator</code> instance that is currently set in the layout.
     *
     *  <p>If you override the <code>dragExit</code> event handler, 
     *  and call <code>preventDefault()</code> so that the default handler does not execute, 
     *  call <code>destroyDropIndicator()</code> to delete the drop indicator.</p>
     *
     *  @return Returns the dropIndicator that was removed. 
     * 
     *  @see #createDropIndicator
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    /*public function destroyDropIndicator():DisplayObject
    {
        var dropIndicatorInstance:DisplayObject = _gridViewLayout.dropIndicator;

        if (!dropIndicatorInstance)
            return null;
        
        // Release the reference from the layout
        _gridViewLayout.dropIndicator = null;
        
        // Release it if it's a dynamic skin part
        var count:int = numDynamicParts("dropIndicator");

        for (var i:int = 0; i < count; i++)
        {
            if (dropIndicatorInstance == getDynamicPartAt("dropIndicator", i))
            {
                // This was a dynamic part, remove it now:
                removeDynamicPartInstance("dropIndicator", dropIndicatorInstance);
                break;
            }
        }

        return dropIndicatorInstance;
    }*/
    
    /**
     *  @private
     *  Handles <code>DragEvent.DRAG_ENTER</code> events.  This method
     *  determines if the DragSource object contains valid elements and uses
     *  the <code>DragManager.showDropFeedback()</code> method to set up the 
     *  UI feedback as well as the layout's <code>showDropIndicator()</code>
     *  method to display the drop indicator and initiate drag scrolling.
     *
     *  @param event The DragEvent object.
     * 
     *  @see spark.layouts.supportClasses.LayoutBase#showDropIndicator
     *  @see spark.layouts.supportClasses.LayoutBase#hideDropIndicator
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    protected function dragEnterHandler(event:DragEvent):void
    {
        /*if (event.isDefaultPrevented())
            return;


        if (!_gridViewLayout)
        {
            //Store a current gridview layout.
            _gridViewLayout = (grid.layout as GridLayout).centerGridView.layout as GridViewLayout;
        }


        var dropLocation:DropLocation = _gridViewLayout.calculateDropLocation(event);

        if (dropLocation)
        {
            DragManager.acceptDragDrop(this);
            
            // Create the dropIndicator instance. The layout will take care of
            // parenting, sizing, positioning and validating the dropIndicator.
            createDropIndicator();
            
            // Show focus
            drawFocusAnyway = true;
            drawFocus(true);
            
            // Notify manager we can drop
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            
            // Show drop indicator
            _gridViewLayout.showDropIndicator(dropLocation);
        }
        else
        {
            DragManager.showFeedback(DragManager.NONE);
        }*/
    }
    
    /**
     *  @private
     *  Handles <code>DragEvent.DRAG_OVER</code> events. This method
     *  determines if the DragSource object contains valid elements and uses
     *  the <code>showDropFeedback()</code> method to set up the UI feedback 
     *  as well as the layout's <code>showDropIndicator()</code> method
     *  to display the drop indicator and initiate drag scrolling.
     *
     *  @param event The DragEvent object.
     *  
     *  @see spark.layouts.supportClasses.LayoutBase#showDropIndicator
     *  @see spark.layouts.supportClasses.LayoutBase#hideDropIndicator
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    protected function dragOverHandler(event:DragEvent):void
    {
        /*if (event.isDefaultPrevented())
            return;


        var dropLocation:DropLocation = _gridViewLayout.calculateDropLocation(event);

        if (dropLocation)
        {
            // Show focus
            drawFocusAnyway = true;
            drawFocus(true);
            
            // Notify manager we can drop
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            
            // Show drop indicator
            _gridViewLayout.showDropIndicator(dropLocation);
        }
        else
        {
            // Hide if previously showing
            _gridViewLayout.hideDropIndicator();
            
            // Hide focus
            drawFocus(false);
            drawFocusAnyway = false;
            
            // Notify manager we can't drop
            DragManager.showFeedback(DragManager.NONE);
        }*/
    }
    
    /**
     *  @private
     *  Handles <code>DragEvent.DRAG_EXIT</code> events. This method hides
     *  the UI feedback by calling the <code>hideDropFeedback()</code> method
     *  and also hides the drop indicator by calling the layout's 
     *  <code>hideDropIndicator()</code> method.
     *
     *  @param event The DragEvent object.
     *  
     *  @see spark.layouts.supportClasses.LayoutBase#showDropIndicator
     *  @see spark.layouts.supportClasses.LayoutBase#hideDropIndicator
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    protected function dragExitHandler(event:DragEvent):void
    {
        /*if (event.isDefaultPrevented())
            return;

        // Hide if previously showing
        _gridViewLayout.hideDropIndicator();
        
        // Hide focus
        drawFocus(false);
        drawFocusAnyway = false;
        
        // Destroy the dropIndicator instance
        destroyDropIndicator();*/
    }

    /**
     *  @private
     *  Handles <code>DragEvent.DRAG_DROP events</code>. This method  hides
     *  the drop feedback by calling the <code>hideDropFeedback()</code> method.
     *
     *  <p>If the action is a <code>COPY</code>, 
     *  then this method makes a deep copy of the object 
     *  by calling the <code>ObjectUtil.copy()</code> method, 
     *  and replaces the copy's <code>uid</code> property (if present) 
     *  with a new value by calling the <code>UIDUtil.createUID()</code> method.</p>
     * 
     *  @param event The DragEvent object.
     *
     *  @see mx.utils.ObjectUtil
     *  @see mx.utils.UIDUtil
     *  
     *  @langversion 3.0
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    protected function dragDropHandler(event:DragEvent):void
    {
        /*if (event.isDefaultPrevented())
            return;


        // Hide the drop indicator
		_gridViewLayout.hideDropIndicator();
        destroyDropIndicator();
        
        // Hide focus
        drawFocus(false);
        drawFocusAnyway = false;
        
        // Get the dropLocation
		var dropLocation:DropLocation = _gridViewLayout.calculateDropLocation(event);

        if (!dropLocation)
            return;
        
        // Find the dropIndex
        var dropIndex:int = dropLocation.dropIndex;
        
        // Make sure the manager has the appropriate action
        DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
        
        var dragSource:DragSource = event.dragSource;
        var items:Vector.<Object> = dragSource.dataForFormat("itemsByIndex") as Vector.<Object>;
        
        var caretIndex:int = -1;
        if (dragSource.hasFormat("caretIndex"))
            caretIndex = event.dragSource.dataForFormat("caretIndex") as int;
        
        // Clear the selection first to avoid extra work while adding and removing items.
        // We will set a new selection further below in the method.
        var indices:Vector.<int> = selectedIndices; 
        clearSelection();
        validateProperties(); // To commit the selection
        
        // If we are reordering the list, remove the items now,
        // adjusting the dropIndex in the mean time.
        // If the items are drag moved to this list from a different list,
        // the drag initiator will remove the items when it receives the
        // DragEvent.DRAG_COMPLETE event.
        if (dragMoveEnabled &&
            event.action == DragManager.MOVE &&
            event.dragInitiator == this)
        {
            // Remove the previously selected items
            indices.sort(compareValues);
            for (var i:int = indices.length - 1; i >= 0; i--)
            {
                if (indices[i] < dropIndex)
                    dropIndex--;
                dataProvider.removeItemAt(indices[i]);
            }
        }
        
        // Drop the items at the dropIndex
        var newSelection:Vector.<int> = new Vector.<int>();
        
        // Update the selection with the index of the caret item
        if (caretIndex != -1)
            newSelection.push(dropIndex + caretIndex);
        
        // Create dataProvider if needed
        if (!dataProvider)
            dataProvider = new ArrayCollection();
        
        var copyItems:Boolean = (event.action == DragManager.COPY);
        for (i = 0; i < items.length; i++)
        {
            // Get the item, clone if needed
            var item:Object = items[i];
            if (copyItems)
                item = copyItemWithUID(item);
            
            // Copy the data
            dataProvider.addItemAt(item, dropIndex + i);
            
            // Update the selection
            if (i != caretIndex)
                newSelection.push(dropIndex + i);
        }
        
        // Set the selection
        selectedIndices = newSelection;
        
        // Scroll the caret index in view
        if (caretIndex != -1)
            ensureCellIsVisible(dropIndex + items.length);*/
    }
    
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
     *  @playerversion Flash 11
     *  @playerversion AIR 3.0
     *  @productversion Flex 5.0
     */
    protected function copyItemWithUID(item:Object):Object
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
    }
}
}