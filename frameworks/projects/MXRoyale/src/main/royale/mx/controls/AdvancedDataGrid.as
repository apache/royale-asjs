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
    /* import flash.display.DisplayObject;
    import flash.display.Graphics;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.ui.Keyboard;
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
*/
    import mx.collections.ArrayCollection;
    import mx.collections.CursorBookmark;
    import mx.collections.HierarchicalCollectionView;
    import mx.collections.HierarchicalData;
    import mx.collections.ICollectionView;
    import mx.collections.IGroupingCollection;
    import mx.collections.IGroupingCollection2;
    import mx.collections.IHierarchicalCollectionView;
    import mx.collections.IHierarchicalCollectionViewCursor;
    import mx.collections.IHierarchicalData;
    import mx.collections.IViewCursor;
    import mx.collections.ISort;
    import mx.collections.Sort;
    import mx.collections.SortField;
    import mx.controls.beads.AdvancedDataGridSortBead;
    import mx.controls.beads.AdvancedDataGridView;
    import mx.controls.beads.DataGridLinesBeadForICollectionView;
    import mx.controls.beads.DataGridColumnResizeBead;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.controls.listClasses.AdvancedListBase;
    import mx.core.mx_internal;
    import mx.events.AdvancedDataGridEvent;
    import mx.events.CollectionEvent;
    import mx.events.CollectionEventKind;
    
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IDataGrid;
    import org.apache.royale.core.IDataGridModel;
    import org.apache.royale.core.IDataGridPresentationModel;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.Event;
    import org.apache.royale.html.DataGridButtonBar;

use namespace mx_internal;
//--------------------------------------
//  Events
//--------------------------------------

/**
*  Dispatched when a branch of the navigation tree is closed or collapsed.
*
*  @eventType mx.events.AdvancedDataGridEvent.ITEM_CLOSE
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Event(name="itemClose", type="mx.events.AdvancedDataGridEvent")]

/**
*  Dispatched when a branch of the navigation tree is opened or expanded.
*
*  @eventType mx.events.AdvancedDataGridEvent.ITEM_OPEN
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Event(name="itemOpen", type="mx.events.AdvancedDataGridEvent")]

/**
*  Dispatched when a tree branch open or close operation is initiated.
*
*  @eventType mx.events.AdvancedDataGridEvent.ITEM_OPENING
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Event(name="itemOpening", type="mx.events.AdvancedDataGridEvent")]

/**
*  Dispatched when the user drags a column outside of its column group.
*  TheAdvancedDataGrid control does not provide a default event handler for this event.
*
*  @eventType mx.events.AdvancedDataGridEvent.HEADER_DRAG_OUTSIDE
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Event(name="headerDragOutside", type="mx.events.AdvancedDataGridEvent")]

/**
*  Dispatched when the user drops a column outside of its column group.
*  TheAdvancedDataGrid control doesn't provide a default handler for this event.
*
*  @eventType mx.events.AdvancedDataGridEvent.HEADER_DROP_OUTSIDE
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Event(name="headerDropOutside", type="mx.events.AdvancedDataGridEvent")]

/**
 *  Dispatched when the user releases the mouse button on a column header
 *  to request the control to sort
 *  the grid contents based on the contents of the column.
 *  Only dispatched if the column is sortable and the data provider supports 
 *  sorting. The AdvancedDataGrid control has a default handler for this event that implements
 *  a single-column sort.  Multiple-column sort can be implemented by calling the 
 *  <code>preventDefault()</code> method to prevent the single column sort and setting 
 *  the <code>sort</code> property of the data provider.
 * <p>
 * <b>Note</b>: The sort arrows are defined by the default event handler for
 * the <code>headerRelease</code> event. If you call the <code>preventDefault()</code> method
 * in your event handler, the arrows are not drawn.
 * </p>
 *
 *  @eventType mx.events.AdvancedDataGridEvent.HEADER_RELEASE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
[Event(name="headerRelease", type="mx.events.AdvancedDataGridEvent")]

/**
 *  Dispatched when the user releases the mouse button while over an item 
 *  renderer, tabs to the AdvancedDataGrid control or within the AdvancedDataGrid control, 
 *  or in any other way attempts to edit an item.
 *
 *  @eventType mx.events.AdvancedDataGridEvent.ITEM_EDIT_BEGINNING
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
[Event(name="itemEditBeginning", type="mx.events.AdvancedDataGridEvent")]

/**
 *  Dispatched when an item editing session ends for any reason.
 *
 *  @eventType mx.events.AdvancedDataGridEvent.ITEM_EDIT_END
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
[Event(name="itemEditEnd", type="mx.events.AdvancedDataGridEvent")]


/**
 *  Dispatched when an item editing session ends for any reason.
 *
 *  @eventType  mx.events.AdvancedDataGridEvent.ITEM_EDIT_BEGIN
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
[Event(name="itemEditBegin", type="mx.events.AdvancedDataGridEvent")]

//--------------------------------------
//  Styles
//--------------------------------------

//include "../styles/metadata/PaddingStyles.as";

/**
*  Colors for rows in an alternating pattern.
*  Value can be an Array of two of more colors.
*  For the AdvancedDataGrid controls, 
*  all items in a row have the same background color, 
*  and each row's background color is determined from the Array of colors.
*  Used only if the <code>backgroundColor</code> property is not specified.
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
*  Array of colors used for the rows of each level of the navigation tree 
*  of the AdvancedDataGrid control, in descending order.
*
*  @default undefined
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="depthColors", type="Array", arrayType="uint", format="Color", inherit="yes")]

/**
*  The default icon for a leaf node of the navigation tree.
*
*  The default value is <code>TreeNodeIcon</code> in the assets.swf file.
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="defaultLeafIcon", type="Class", format="EmbeddedFile", inherit="no")]

/**
*  The icon that is displayed next to an open branch node of the navigation tree.
*
*  The default value is <code>TreeDisclosureOpen</code> in the assets.swf file.
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="disclosureOpenIcon", type="Class", format="EmbeddedFile", inherit="no")]

/**
*  The icon that is displayed next to a closed branch node of the navigation tree.
*
*  The default value is <code>TreeDisclosureClosed</code> in the assets.swf file.
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="disclosureClosedIcon", type="Class", format="EmbeddedFile", inherit="no")]

/**
*  Specifies the folder open icon for a branch node of the navigation tree.
*
*  The default value is <code>TreeFolderOpen</code> in the assets.swf file.
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="folderOpenIcon", type="Class", format="EmbeddedFile", inherit="no")]

/**
*  Specifies the folder closed icon for a branch node of the navigation tree.
*
*  The default value is <code>TreeFolderClosed</code> in the assets.swf file.
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="folderClosedIcon", type="Class", format="EmbeddedFile", inherit="no")]

/**
*  The indentation for each node of the navigation tree, in pixels.
*
*  @default 17
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="indentation", type="Number", inherit="no")]

/**
*  Length of an open or close transition for the navigation tree, in milliseconds.
*
*  @default 250
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="openDuration", type="Number", format="Time", inherit="no")]

/**
*  Easing function to control component tweening.
*
*  <p>The default value is <code>undefined</code>.</p>
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="openEasingFunction", type="Function", inherit="no")]

/**
*  The skin that defines the appearance of the separators between the text
*  and icon parts of a header in a AdvancedDataGrid control.
*
*  @default undefined
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//Style(name="headerSortSeparatorSkin", type="Class", inherit="no")]

/**
*  The class to use as the skin that defines the appearance of the 
*  separators between column headers of different depth in a AdvancedDataGrid control.
*
*  @default undefined
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="headerHorizontalSeparatorSkin", type="Class", inherit="no")]

/**
*  The disabled color of a list item.
*
*  @default 0xDDDDDD
*
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="selectionDisabledColor", type="uint", format="Color", inherit="yes")]

/**
*  Reference to an <code>easingFunction</code> function used for controlling programmatic tweening.
*
*  <p>The default value is <code>undefined</code>.</p>
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="selectionEasingFunction", type="Function", inherit="no")]

/**
*  Color of the text when the user rolls over a row.
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
*  Color of the text when the user selects a row.
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
*  The font family used by the AdvancedDataGridSortItemRenderer class 
*  to render the sort icon in the column header.
*
*  @default Verdana
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="sortFontFamily", type="String", inherit="yes")]

/**
*  The font size used by the AdvancedDataGridSortItemRenderer class 
*  to render the sort icon in the column header.
*
*  @default 10
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="sortFontSize", type="Number", format="Length", inherit="yes")]

/**
*  The font style used by the AdvancedDataGridSortItemRenderer class 
*  to render the sort icon in the column header.
*
*  @default normal
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="sortFontStyle", type="String", enumeration="normal,italic", inherit="yes")]

/**
*  The font weight used by the AdvancedDataGridSortItemRenderer class 
*  to render the sort icon in the column header.
*
*  @default normal
*  
*  @langversion 3.0
*  @playerversion Flash 9
*  @playerversion AIR 1.1
*  @productversion Royale 0.9.4
*/
//[Style(name="sortFontWeight", type="String", enumeration="normal,bold", inherit="yes")]

/*************************************************************************
* 
* End of Tree Events, Styles and Metadata
* 
*************************************************************************/

/* [AccessibilityClass(implementation="mx.accessibility.AdvancedDataGridAccImpl")]

[ResourceBundle("datamanagement")] */
/**
*  The AdvancedDataGrid control expands on the functionality of the standard DataGrid control 
*  to add data visualization features to your Apache Flex application. 
*  These features provide greater control of data display, data aggregation, and data formatting.
*
 *  The <code>AdvancedDataGrid</code> control is like a List control except that it can show 
 *  more than one column of data,
 *  making it suited for showing objects with multiple properties.
 *  <p>
 *  The AdvancedDataGrid control provides the following features:
 *  <ul>
 *  <li>Columns of different widths or identical fixed widths.</li>
 *  <li>Columns that the user can resize at run time. </li>
 *  <li>Columns that the user can reorder at run time. </li>
 *  <li>Optional customizable column headers.</li>
 *  <li>Ability to use a custom item renderer for any column to display data 
 *  other than text.</li>
 *  <li>Support for sorting the data by clicking on a column.</li>
 *  </ul>
 *  </p>
 *  The AdvancedDataGrid control is intended for viewing data, and not as a
 *  layout tool like an HTML table.
 *  The mx.containers package provides those layout tools.
 *  
 *  @mxml
 *  <p>
 *  The <code>&lt;mx:AdvancedDataGrid&gt;</code> tag inherits all of the tag attributes
 *  of its superclass, except for <code>labelField</code>, <code>iconField</code>,
 *  and <code>iconFunction</code>, and adds the following tag attributes:
 *  </p>
 *  <pre>
 *  &lt;mx:AdvancedDataGrid
 *    <b>Properties</b>
 *    displayDisclosureIcon="true|false"
 *    displayItemsExpanded="false|true"
 *    groupedColumns="[]"
 *    groupIconFunction="null"
 *    groupItemRenderer="AdvancedDataGridGroupItemRenderer"
 *    groupLabelFunction="null"
 *    groupRowHeight="-1"
 *    itemIcons="undefined"
 *    lockedColumnCount="0"
 *    lockedRowCount="0"
 *    rendererProviders="[]"
 *    selectedCells="null"
 *    treeColumn="null"
 *     
 *    <b>Styles</b>
 *    alternatingItemColors="undefined"
 *    defaultLeafIcon="TreeNodeIcon"
 *    depthColors="undefined"
 *    disclosureClosedIcon="TreeDisclosureClosed"
 *    disclosureOpenIcon="TreeDisclosureOpen"
 *    folderClosedIcon="TreeFolderClosed"
 *    folderOpenIcon="TreeFolderOpen"
 *    headerHorizontalSeparatorSkin="undefined"
 *    indentation="17"
 *    openDuration="250"
 *    openEasingFunction="undefined"
 *    paddingLeft="2"
 *    paddingRight="0"
 *    selectionDisabledColor="#DDDDDD"
 *    selectionEasingFunction="undefined"
 *    sortFontFamily="Verdana"
 *    sortFontSize="10"
 *    sortFontStyle="normal"
 *    sortFontWeight="normal"
 *    textRollOverColor="#2B333C"
 *    textSelectedColor="#2B333C"
 *     
 *    <b>Events</b>
 *    headerDragOutside="<i>No default</i>"
 *    headerDropOutside="<i>No default</i>"
 *    itemClose="<i>No default</i>"
 *    itemOpen="<i>No default</i>"
 *    itemOpening="<i>No default</i>" 
 *  /&gt;
 *   
 *  <b><i>The following AdvancedDataGrid code sample specifies the column order:</i></b>
 *  &lt;mx:AdvancedDataGrid&gt;
 *    &lt;mx:dataProvider&gt;
 *        &lt;mx:Object Artist="Pavement" Price="11.99"
 *          Album="Slanted and Enchanted"/&gt;
 *        &lt;mx:Object Artist="Pavement"
 *          Album="Brighten the Corners" Price="11.99"/&gt;
 *    &lt;/mx:dataProvider&gt;
 *    &lt;mx:columns&gt;
 *        &lt;mx:AdvancedDataGridColumn dataField="Album"/&gt;
 *        &lt;mx:AdvancedDataGridColumn dataField="Price"/&gt;
 *    &lt;/mx:columns&gt;
 *  &lt;/mx:AdvancedDataGrid&gt;
 *  </pre>
 *  </p>
 *
 *  @see mx.controls.advancedDataGridClasses.AdvancedDataGridItemRenderer
 *  @see mx.controls.advancedDataGridClasses.AdvancedDataGridColumn
 *  @see mx.controls.advancedDataGridClasses.AdvancedDataGridDragProxy
 *  @see mx.events.AdvancedDataGridEvent
 *  @see mx.controls.DataGrid
 *
 *  @includeExample examples/AdvancedDataGridExample.mxml 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.4
 */
public class AdvancedDataGrid extends AdvancedListBase implements IDataGrid
{ //extends  AdvancedDataGridBaseEx
   // include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class mixins
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Placeholder for mixin by AdvancedDataGridAccImpl.
     */
    //mx_internal static var createAccessibilityImplementation:Function;

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     * Indicates mouse is over the text part of the header.
     * Used as a return value by mouseEventToHeaderPart.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // public static const HEADER_TEXT_PART:String = "headerTextPart";

    /**
     * Indicates that the mouse is over the header part of the header.
     * Used as a return value by 
     * the <code>AdvancedDataGridHeaderRenderer.mouseEventToHeaderPart</code> method.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // public static const HEADER_ICON_PART:String = "headerIconPart";
    
    /**
     *  @private
     */
   /*  private static var resourceManager:IResourceManager =
                                ResourceManager.getInstance(); */
    
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
    public function AdvancedDataGrid()
    {
        super();
        
        typeNames = "AdvancedDataGrid";
        
        /* rendererDescriptionMap = new Dictionary(true);

        groupItemRenderer = new ClassFactory(AdvancedDataGridGroupItemRenderer);

        // Added Listener from Tree
        addEventListener(AdvancedDataGridEvent.ITEM_OPENING, expandItemHandler,
                         false, EventPriority.DEFAULT_HANDLER);

        addEventListener(FlexEvent.UPDATE_COMPLETE, updateCompleteHandler); */
        
        addBead(new DataGridLinesBeadForICollectionView());
        addBead(new DataGridColumnResizeBead());
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
	 *  Maps renders to row and column spanning info.
	 * 
     *  @see mx.controls.advancedDataGridClasses.AdvancedDataGridRendererDescription
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //protected var rendererDescriptionMap:Dictionary;
    
    /**
     *  @private
     */
   // private var isMeasuringHeader:Boolean;

    /**
     *  @private
     *  Keep track of styles of the individual item renderers when custom
     *  row/column formatting i.e. grid and column styleFunctions are applied.
     */
   // private var oldStyles:Dictionary;

    // Cell Selection variables
    /**
     *  @private
     *  The first AdvancedDataGridBaseSelectionData in a link list of
     *  AdvancedDataGridBaseSelectionData. This represents the item that was
     *  most recently selected.  AdvancedDataGridBaseSelectionData instances are
     *  linked together and keep track of the order the user selects an item.
     *  This order is reflected in selectedCells.
     */
   // mx_internal var firstCellSelectionData:AdvancedDataGridBaseSelectionData;

    /**
     *  A hash table of AdvancedDataGridBaseSelectionData objects that track
     *  which items are currently selected.  The table is indexed by the UID of
     *  the items and then the column number.
     *
     *  @see mx.controls.advancedDataGridClasses.AdvancedDataGridBaseSelectionData
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //mx_internal var cellSelectionData:Object = {};
	
	/**
	 *  Map of selections keyes by x,y and referred to by modified isCellAlreadySelected()
	 *  and addToSelectedCells()
	 *  
	 *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
	 */
	//mx_internal var cellSelections:Object = {};

    /**
     *  A hash table of selection indicators.  This table allows the component
     *  to quickly find and remove the indicators when the set of selected
     *  items is cleared.  The table is indexed by the item's UID and column number.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    //mx_internal var cellSelectionIndicators:Object = {};

    /**
     *  A hash table of data provider item renderers currently in view. The
     *  table is indexed by the data provider item's UID and column number and is
     *  used to quickly get the renderer used to display a particular item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    // Parallel data structure to visibleData in listItems.
    //protected var visibleCellRenderers:Object = {};

    /**
     *  The column of the selected cell.
     *
     *  Used in conjunction with <code>selectedIndex</code> property to determine 
     *  the column and row indices of the selected cell.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
  //  protected var selectedColumnIndex:int = -1;

    /**
     *  The column index of the item that is currently rolled over or under the cursor.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   // protected var highlightColumnIndex:int = -1;

    /**
     *  The column name of the item under the caret.
     *
     *  Used in conjunction with the <code>caretIndex</code> property to determine 
     *  the column/row indices of the cell where the caret is located.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
  //  protected var caretColumnIndex:int = -1;

    /**
     *  The column index of the current anchor.
     *
     *  Use this property in conjunction with the <code>ListBase.anchorIndex</code> property
     *  to determine the column and row
     *  indices of the cell where the anchor is located.
     *
     *  @see mx.controls.listClasses.ListBase#anchorIndex
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
  //  protected var anchorColumnIndex:int = -1;

    /**
     *  A hash table of selection tweens.  This allows the component to
     *  quickly find and clean up any tweens in progress if the set
     *  of selected items is cleared.  The table is indexed by the item's UID
     *  and column number.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
  //  protected var cellSelectionTweens:Object = {};

    /**
     *  Flag to indicate that selectedCells has changed
     *  
     *  @private
     */
   private var selectedCellsChanged:Boolean = false;

    /**
     *  Temporary storage for selectedCells
     *  
     *  @private
     */
    private var _temporary_selectedCells:Array = null;

    /**
     * Storage of sortInfos, used for the multi column sorting UI.
     *  
     *  @private
     */
  //  private var visualSortInfo:Dictionary = new Dictionary();

    /**
     * Flag to check if design view data is set, so that openNodes can also be changed.
     *  
     *  @private
     */
  //  private var designViewDataFlag:Boolean = false;

    /**
     *  @private
     */
   // private var lastColumnWidth:Number = NaN;

    /**
     *  @private
     */
   // protected var movingSelectionLayer:Sprite;

    /**
     *  @private
     */
   // private var headerSelected:Boolean = true;

  

    /**
     *  @private
     */
  //  private var lockedColumnCountChanged:Boolean = false;

    /**
     *  @private
     */
   // private var headerItemsList:Array;

    /**
     *  @private
     */
  //  private var headerDraggedOutside:Boolean = false;

    /**
     *  @private
     */
  //  private var dropInfo:AdvancedDataGridEvent;

    /**
     *  @private
     */
 //   private var lastHeaderInfos:Array;

    /**
     *  @private
     */
 //   private var horizontalSeparators:Array;

    /**
     *  @private
     */
  //  private var horizontalLockedSeparators:Array;

    /**
     *  @private
     */
   // private var numSeparators:int = 0;
    
   // private var groupedColumnsChanged:Boolean=false;
    
   // private var columnsChanged:Boolean = false;
    
  /*   private var designViewDataFlatType:String = "flat";*/
    private var designViewDataTreeType:String = "tree";
  /*  private var designViewDataTypeChanged:Boolean = false;
    
    mx_internal var columnsToInfo:Dictionary = new Dictionary(); */

    /**
     *  @private
     *  Needed for Accessibility to know if column grouping is present or not.
     */
    /* mx_internal var columnGrouping:Boolean = false; */
    
    /**
     *  @private
     *  Item is currently in the process of opening
     */
    /* private var opening:Boolean; */

    /**
     *  The tween object that animates rows
     * 
     *  Users can add event listeners to this Object to get
     *  notified when the tween starts, updates and ends.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected var tween:Object; */

    /**
     *  @private
     */
    /* private var maskList:Array; */

    /**
     *  @private
     */
    /* private var _userMaxHorizontalScrollPosition:Number = 0; */

    /**
     *  @private
     */
    /* private var eventAfterTween:Object; */
    
    /**
     *  Storage for the Group item renderer in case of item opening/closing events
     *  @private
     */
    /* private var eventItemRenderer:IListItemRenderer; */

    /**
     *  @private
     */
    /* private var oldLength:int = -1; */

    /**
     *  @private
     */
    // private var expandedItem:Object;

    /**
     *  @private
     */
    // private var bSelectedItemRemoved:Boolean = false;

    /**
     *  @private
     *  Storage for the groupLabelField property.
     * 	@royalesuppresspublicvarwarning 
     */
    public var groupLabelField:String;

    /**
     *  @private
     */
    // private var lastUserInteraction:Event;

    /**
     *  @private
     *  automation delegate access
     */
    // mx_internal var _dropData:Object;

    /**
     *  @private
     */
    // mx_internal var isOpening:Boolean = false;

    /**
     *  @private
     *  used by opening tween
     *  rowIndex is the row below the row that was picked
     *  and is the first one that will actually change
     */
    // private var rowIndex:int;

    /**
     *  @private
     *  Number of rows that are or will be tweened
     */
    // private var rowsTweened:int;

    /**
     *  @private
     */
    // private var rowList:Array;
    
    /**
     *  @private
     *  variable to hold the IHierarchicalCollectionView instance provided by the user.
     */
    private var hierarchicalCollectionInstance:IHierarchicalCollectionView;

    /**
     *  @private
     */
    // mx_internal var collectionLength:int;
    
    /**
     *  @private
     */
    private var dataProviderChanged:Boolean = false;
    
    /**
     *  @private
     *  Storage variable for the original dataProvider
     */
    mx_internal var _rootModel:IHierarchicalData;
    
    /**
     *  @private
     *  Storage variable for changes to displayItemsExpanded.
     */
    // private var displayItemsExpandedChanged:Boolean = false;
    
    //--------------------------------------------------------------------------
    //
    //  Overridden properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  dataProvider
    //----------------------------------

    /* [Bindable("collectionChange")]
    [Inspectable(category="Data", defaultValue="null")] */

    /**
     *  @private
     */
    /* override public function get dataProvider():Object
    {
        if(super.dataProvider)
            return super.dataProvider;

        return null;
    } */
    
    /**
     *  
     *  @private
     */
    override public function set dataProvider(value:Object):void
    {
        /*
         if (itemEditorInstance)
            endEdit(AdvancedDataGridEventReason.OTHER);

        if (isCellSelectionMode())
        {
            clearCellSelectionData();
        }
        */
        
        if (_rootModel)
            _rootModel.removeEventListener(
                CollectionEvent.COLLECTION_CHANGE, 
                collectionChangeHandler);
        
        if (value is IHierarchicalData)
        {
            _rootModel = value as IHierarchicalData;
        }
        else if (value is IHierarchicalCollectionView)
        {
            // if the dataProvider is IHierarchicalCollectionView,
            // set it to super.dataProvider in commitProperties()
            _rootModel = IHierarchicalCollectionView(value).source;
            hierarchicalCollectionInstance = IHierarchicalCollectionView(value);
        }
        else
        {
            _rootModel = null;
            hierarchicalCollectionInstance = null;
            super.dataProvider = value;
        }

        if (_rootModel)
           _rootModel.addEventListener(
           CollectionEvent.COLLECTION_CHANGE, 
           collectionChangeHandler);

        //flag for processing in commitProps
        dataProviderChanged = true;
        invalidateProperties(); 
        commitProperties();
    }
    
    //----------------------------------
    //  lockedRowCount
    //----------------------------------
    
    /**
     *  The index of the first row in the control that scrolls.
     *  Rows above this one remain fixed in view.
     * 
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* override public function get lockedRowCount():int
    {
        // if dataProvider is hierarchical, return 0
        // because lockedRowCount has no effect in a hierarchical display
        if (_rootModel is IHierarchicalData)
            return 0;

        return super.lockedRowCount;
    } */
    
    //----------------------------------
    //  lockedColumnCount
    //----------------------------------
    private var _lockedColumnCountVal:int;
    
    /**
     *  The index of the first column in the control that scrolls. 
     *  Columns to the left of this one remain fixed in view. 
     *
     *  <p>When using column groups, a column group is considered to be a single column.
     *  For example, if you set this property to 2, and the left-most two column groups 
     *  contain two and three children, respectively, then you have effectively locked the 
     *  first five columns of the control.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
     public function set lockedColumnCount(value:int):void
     {
        _lockedColumnCountVal = value;
        /* lockedColumnCountChanged = true;

        invalidateProperties(); */
     } 
    
     public function get lockedColumnCount():int
     {
	return _lockedColumnCountVal
     }
    
    //----------------------------------
    //  columns
    //----------------------------------
    
    /**
     *  @private
     */
   /*  private var _columnsValue:Array;
	
	[Inspectable(category="General", arrayType="mx.controls.advancedDataGridClasses.AdvancedDataGridColumn")] */
    /**
     *  @private
     */
    /* override  public function set columns(value:Array):void
    {
        _columnsValue = value;
         columnsChanged = true;
        generatedColumns = false;

        invalidateProperties(); 
    } */
    
    //----------------------------------
    //  verticalScrollPosition
    //----------------------------------
    
    /**
     *  @private
     *  Sets verticalScrollPosition and draw vertical lines again
     *  if rendererProviders are used.
     */
    /*override public function set verticalScrollPosition(value:Number):void
    {       
         var oldAnchorColumnIndex:int   = anchorColumnIndex;
        var oldCaretColumnIndex:int    = caretColumnIndex;
        var oldSelectedColumnIndex:int = selectedColumnIndex;
	
        super.verticalScrollPosition = value;
	
        anchorColumnIndex   = oldAnchorColumnIndex;
        caretColumnIndex    = oldCaretColumnIndex;
        selectedColumnIndex = oldSelectedColumnIndex;

        // draw the vertically lines afresh if Custom Row Renderers are used
        // i.e., update the vertical lines if items are spanning columns
        if (rendererProviders.length != 0)
          drawVerticalSeparators();
         
        // draw the horizontal lines afresh if groupRowHeight is not -1
        // and its not equal to rowHeight
        if (!variableRowHeight && groupRowHeight != -1 && groupRowHeight != rowHeight)
            drawHorizontalSeparators();

        // Display cells set in selectionMode which are not yet visible
        if (cellsWaitingToBeDisplayed)
            processCellsWaitingToBeDisplayed(); 
    }
    */
    //----------------------------------
    //  horizontalScrollPosition
    //----------------------------------
    
    /**
     *  @private
     */
    /* override public function set horizontalScrollPosition(value:Number):void
    {
        var oldAnchorColumnIndex:int   = anchorColumnIndex;
        var oldCaretColumnIndex:int    = caretColumnIndex;
        var oldSelectedColumnIndex:int = selectedColumnIndex;

        super.horizontalScrollPosition = value;

        anchorColumnIndex   = oldAnchorColumnIndex;
        caretColumnIndex    = oldCaretColumnIndex;
        selectedColumnIndex = oldSelectedColumnIndex;

        // Display cells set in selectionMode which are not yet visible
        if (cellsWaitingToBeDisplayed)
            processCellsWaitingToBeDisplayed();
    } */

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    // groupedColumns
    //----------------------------------
    
    /**
     *  @private
     */
    private var _groupedColumns:Array;

    /**
     *  An Array that defines the hierarchy of AdvancedDataGridColumn instances when performing column grouping.
     *  If you specify both the <code>columns</code> and <code>groupedColumns</code> properties, 
     *  the control uses the <code>groupedColumns</code> property and ignores 
     *  the <code>columns</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function get groupedColumns():Array
    {
        return _groupedColumns;
    }
    
    public function set groupedColumns(value:Array):void
    {
        //Validate 
       /*  if(validateGroupedColumns(value))
        {
            if(_groupedColumns)
            {
                var n:int = _groupedColumns.length;
                for ( var i:int = 0; i < n; i++)
                {
                    if(_groupedColumns[i] is AdvancedDataGridColumnGroup)
                        columnGroupRendererChanged(AdvancedDataGridColumnGroup(_groupedColumns[i]));
                }
            }
            
            _groupedColumns = value;
            groupedColumnsChanged = true;
            invalidateProperties();
        } */
    }

    //
    // Cell Selection properties
    //
    //----------------------------------
    // selectedCells
    //----------------------------------

    /**
     *  @private
     */
    protected var _selectedCells:Array = [];

    [Inspectable(category="Data", arrayType="Object")]
    /**
     *  Contains an Array of cell locations as row and column indices.
     *  Changing the value of the <code>selectionMode</code> property 
     *  sets this property to <code>null</code>.
     *
     *  <p>Note that these row and column indices are absolute values,
     *  irrespective of the display. This is explained by a typical
     *  <code>selectedCells</code> property setting as follows:</p>
     *
     *  <pre>
     *  selectedCells = [ { rowIndex : r1, columnIndex : c1 },
     *                    { rowIndex : r2, columnIndex : c2 },
     *                    ... ]</pre>
     *
     *  <p>Then, dataProvider[r1], columns[c1], dataProvider[r2], columns[c2],
     *  etc. will always be valid.</p>
     *
     *  <p>If you want to programmatically change the set of selected cells, you
     *  must get this Array, make modifications to the cells and order of
     *  cells in the Array, and then assign the new array to the <code>selectedCells</code> 
     *  property. This is because the AdvancedDataGrid control returns a new
     *  copy of the Array of selectedCells and therefore does not notice the
     *  changes.</p>
     *
     *  <p>The value of the <code>selectionMode</code> property determines the data in 
     *  the <code>rowIndex</code> and <code>columnIndex</code> properties, as the following table describes:</p>
     *
     *  <table class="innertable">
     *    <tr>
     *      <th><code>selectionMode</code></th>
     *      <th>Value of <code>rowIndex</code> and <code>columnIndex</code> properties</th>
     *    </tr>
     *    <tr>
     *      <td>none</td>
     *      <td>No selection allowed in the control, and <code>selectedCells</code> is null. </td>
     *    </tr>
     *    <tr>
     *      <td><code>singleRow</code>  </td>
     *      <td>Click any cell in the row to select the row. After the selection, 
     *       <code>selectedCells</code> contains a single Object:
     *       <p>[{rowIndex:selectedRowIndex, columnIndex: -1}]</p></td>
     *    </tr>
     *    <tr>
     *      <td><code>multipleRows</code></td>
     *      <td>Click any cell in the row to select the row.
     *       While holding down the Control key, click any cell in another row 
     *       to select the row for discontiguous selection.
     *       While holding down the Shift key, click any cell in another row to select multiple, contiguous rows.
     *       After the selection, <code>selectedCells</code> contains one Object for each selected row: 
     *       <p>[   {rowIndex: selectedRowIndex1, columnIndex: -1}, 
     *           {rowIndex: selectedRowIndex2, columnIndex: -1}, 
     *           ... 
     *           {rowIndex: selectedRowIndexN, columnIndex: -1} 
     *       ] </p></td>
     *    </tr>
     *    <tr>
     *      <td><code>singleCell</code></td>
     *      <td>Click any cell to select the cell.
     *       After the selection, <code>selectedCells</code> contains a single Object:
     *       <p>[{rowIndex: selectedRowIndex, columnIndex:selectedColIndex}] </p></td>
     *    </tr>
     *    <tr>
     *      <td><code>multipleCells</code></td>
     *      <td>Click any cell to select the cell.
     *       While holding down the Control key, click any cell to select the cell multiple discontiguous selection.
     *       While holding down the Shift key, click any cell to select multiple, contiguous cells.
     *       After the selection, <code>selectedCells</code> contains one Object for each selected cell:
     *       <p>[   {rowIndex: selectedRowIndex1, columnIndex: selectedColIndex1}, 
     *           {rowIndex: selectedRowIndex2, columnIndex: selectedColIndex2},
     *           ... 
     *           {rowIndex: selectedRowIndexN, columnIndex: selectedColIndexN} 
     *      ] </p></td>
     *    </tr>
     *  </table>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function get selectedCells():Array
    {
        if (_selectedCells)
            return _selectedCells.slice(); // make a copy
        else
            return null;
    } 

    /**
     *  @private
     */
     public function set selectedCells(value:Array):void
    {
        // clear selectedCells
      //  clearSelectedCells();
        
        _temporary_selectedCells = value;
	//syncCellSelections(value);
        selectedCellsChanged = true;
        invalidateProperties();
        invalidateDisplayList();
    } 

    //--------------------------------------------------------------------------
    // Flex Builder design view functionality
    //--------------------------------------------------------------------------
    
    //----------------------------------
    // designViewDataType
    //----------------------------------
    
    private var _designViewDataType:String = designViewDataTreeType;

    [Inspectable(enumeration="flat,tree", defaultValue="tree")]
    /**
     *  Flag from Flex Builder on what kind of data is needed to display
     *  in Design View.
     *
     *  Unfortunately, this can't be mx_internal because we need to set it
     *  from the AdvancedDataGridInserter.java class
     *
     *  @private
     */
    public function get designViewDataType():String
    {
        return _designViewDataType;
    }

    /**
     *  @private
     */
    public function set designViewDataType(value:String):void
    {
        _designViewDataType = value;
       // designViewDataTypeChanged = true;
    }
    
    //----------------------------------
    // dataType
    //----------------------------------

    /**
     *  What kind of data is being displayed? "tree" or "flat"?
     *
     *  @private
     */
    /* mx_internal function get dataType():String
    {
        if (dataProvider)
            return (dataProvider is IHierarchicalCollectionView)
                        ? designViewDataTreeType : designViewDataFlatType;
        else
            return designViewDataTreeType;
    } */

    //----------------------------------
    //  groupIconFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for groupIconFunction property.
     */
    /* private var _groupIconFunction:Function;

    [Bindable("groupIconFunctionChanged")]
    [Inspectable(category="Data")] */

    /**
     *  A user-supplied callback function to run on each group item 
     *  to determine its branch icon in the navigation tree. 
     *  You can specify icons by using the <code>itemIcons</code> or <code>setItemIcon</code> properties 
     *  if you have predetermined icons for data items. 
     *  Use this callback function to determine the icon dynamically after examining the data.
     *  
     *  <p>The <code>groupIconFunction</code> takes the item in the data provider 
     *  and its depth and returns a Class defining the icon, or <code>null</code> property 
     *  to use the default icon.
     *  The callback function must have the following signature:</p>
     * 
     *  <pre>
     *    groupIconFunction(item:Object,depth:int):Class</pre>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get groupIconFunction():Function
    {
        return _groupIconFunction;
    } */

    /**
     *  @private
     */
   /*  public function set groupIconFunction(value:Function):void
    {
        _groupIconFunction = value;

        itemsSizeChanged = true;
        invalidateDisplayList();

        dispatchEvent(new Event("groupIconFunctionChanged"));
    } */

    //----------------------------------
    //  groupItemRenderer
    //----------------------------------

    /**
     *  @private
     *  Storage for the groupItemRenderer property.
     */
    /* private var _groupItemRenderer:IFactory;

    [Inspectable(category="Data")] */

    /**
     *  Specifies the item renderer used to display the branch nodes 
     *  in the navigation tree that correspond to groups. 
     *  By default, it is an instance of the AdvancedDataGridGroupItemRenderer class. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get groupItemRenderer():IFactory
    {
        return _groupItemRenderer;
    } */

    /**
     *  @private
     */
    /* public function set groupItemRenderer(value:IFactory):void
    {
        _groupItemRenderer = value;

        invalidateSize();
        invalidateDisplayList();

        itemsSizeChanged = true;
        rendererChanged = true;

        dispatchEvent(new Event("itemRendererChanged"));
    } */

    //----------------------------------
    //  groupLabelFunction
    //----------------------------------

    /**
     *  @private
     *  Storage for groupLabelFunction property.
     */
   /*  private var _groupLabelFunction:Function;

    [Bindable("groupLabelFunctionChanged")]
    [Inspectable(category="Data")] */

    /**
     *  A callback function to run on each item to determine its label
     *  in the navigation tree.  
     *  By default, the control looks for a property named <code>label</code> 
     *  on each data provider item and displays it.
     *  However, some data sets do not have a <code>label</code> property,
     *  or have another property that can be used for displaying.
     *  An example is a data set that has lastName and firstName fields
     *  but you want to display full names.
     *
     *  <p>You can supply a <code>groupLabelFunction</code> that finds the 
     *  appropriate fields and returns a displayable string. The 
     *  <code>groupLabelFunction</code> is also good for handling formatting and 
     *  localization. </p>
     *
     *  <p>The method signature for the AdvancedDataGrid 
     *  and AdvancedDataGridColumn classes is:</p>
     *  <pre>
     *  myGroupLabelFunction(item:Object, column:AdvancedDataGridColumn):String</pre>
     * 
     *  <p>Where <code>item</code> contains the AdvancedDataGrid item object, and
     *  <code>column</code> specifies the AdvancedDataGrid column. 
     *  The function returns a String containing the label. </p>
     *
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get groupLabelFunction():Function
    {
        return _groupLabelFunction;
    } */

    /**
     *  @private
     */
    /* public function set groupLabelFunction(value:Function):void
    {
        _groupLabelFunction = value;

        itemsSizeChanged = true;
        invalidateDisplayList();

        dispatchEvent(new Event("groupLabelFunctionChanged"));
    } */
    
    //----------------------------------
    //  groupRowHeight
    //----------------------------------

    /**
     *  @private
     *  Storage for groupNodeHeight property.
     */
   /*  private var _groupRowHeight:Number = -1;
    
    [Inspectable(category="Data")] */

    /**
     *  The height of the grouped row, in pixels.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get groupRowHeight():Number
    {
        return _groupRowHeight;
    } */

    /**
     *  @private
     */
    /* public function set groupRowHeight(value:Number):void
    {
        _groupRowHeight = value;

        invalidateSize();
        invalidateDisplayList();

        itemsSizeChanged = true;

    } */

    //----------------------------------
    //  rendererProviders
    //----------------------------------

    /**
     *  @private
     *  Storage for rendererProvider property.
     */
    // private var _rendererProviders:Array = []; /* of AdvancedDataGridRendererProvider */

    /**
     *  Array of AdvancedDataGridRendererProvider instances. 
     *  You can use several renderer providers to specify custom item renderers
     *  used for particular data, at a particular depth of the navigation tree, 
     *  or with column spanning or row spanning.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get rendererProviders():Array
    {
        return _rendererProviders;
    } */

    /**
     *  @private
     */
    /* public function set rendererProviders(value:Array):void
    {
        _rendererProviders = value;

        invalidateSize();
        invalidateDisplayList();

        itemsSizeChanged = true;
        rendererChanged = true;
    } */
    
    //----------------------------------
    //  itemIcons
    //----------------------------------
    
    // [Inspectable(category="Data")]
    /**
     *  An object that specifies the icons for the items.
     *  Each entry in the object has a field name that is the item UID
     *  and a value that is an object with the following format:
     *  <pre>
     *  {iconID: <i>Class</i>, iconID2: <i>Class</i>}
     *  </pre>
     *  The <code>iconID</code> field value is the class of the icon for
     *  a closed or leaf item and the <code>iconID2</code> is the class
     *  of the icon for an open item.
     *
     *  <p>This property is intended to allow initialization of item icons.
     *  Changes to this array after initialization are not detected
     *  automatically.
     *  Use the <code>setItemIcon()</code> method to change icons dynamically.</p>
     *
     *  @see #setItemIcon()
     *  @default undefined
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    // public var itemIcons:Object;
    
    //----------------------------------
    //  firstVisibleItem
    //----------------------------------

    // [Bindable("firstVisibleItemChanged")]

    /**
     *  The data provider element that corresponds to the 
     *  item that is currently displayed in the top row of the AdvancedDataGrid control.
     *  For example, based on how the branches have been opened, closed, and scrolled,
     *  the top row might be the ninth item in the list of
     *  currently viewable items, which represents
     *  some great-grandchild of the root node.
     *  Setting this property is analogous to setting the <code>verticalScrollPosition</code> of the List control.
     *
     *  <p>If the item is not currently viewable (for example, because it
     *  is under a nonexpanded item), setting this property has no effect.</p>
     *
     *  <p>The default value is the first item in the AdvancedDataGrid control.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get firstVisibleItem():Object
    {
        return listItems[0][0].data;
    } */

    /**
     *  @private
     */
    /* public function set firstVisibleItem(value:Object):void
    {
        var pos:int = getItemIndex(value);
        if (pos < 0)
            return;

        verticalScrollPosition = Math.min(maxVerticalScrollPosition, pos);

        dispatchEvent(new Event("firstVisibleItemChanged"));
    } */
    
    //----------------------------------
    //  hierarchicalCollectionView
    //----------------------------------

    /**
     *  @private
     */
    private var _hierarchicalCollectionView:IHierarchicalCollectionView = 
            new HierarchicalCollectionView();

    [Inspectable(category="Data")]

    /**
     *  The IHierarchicalCollectionView instance used by the control.
     * 
     *  <p>The default value is an internal instance of the
     *  HierarchicalCollectionView class.</p>
     *
     *  @see mx.collections.IHierarchicalCollectionView 
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function set hierarchicalCollectionView(value:IHierarchicalCollectionView):void
    {
        _hierarchicalCollectionView = value;
        
        // set the dataProvider using the new IHierarchicalCollectionView
        dataProviderChanged = true;
        invalidateProperties();
    }

    /**
     * @private
     */
    public function get hierarchicalCollectionView():IHierarchicalCollectionView
    {
        return IHierarchicalCollectionView(_hierarchicalCollectionView);
    }
    
    //----------------------------------
    //  displayDisclosureIcon
    //----------------------------------
    
    /**
     *  @private
     *  Indicates that disclosure icons will be shown or not.
     */
    /* private var _displayDisclosureIcon:Boolean = true;

    [Inspectable(category="General")] */
    /**
     *  Controls the creation and visibility of disclosure icons
     *  in the navigation tree.
     *  If <code>false</code>, disclosure icons are not displayed.
     *  
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get displayDisclosureIcon():Boolean
    {
        return _displayDisclosureIcon;
    } */

    /* public function set displayDisclosureIcon(value:Boolean):void
    {
        if (value != _displayDisclosureIcon)
        {
            _displayDisclosureIcon = value;

            itemsSizeChanged = true;
            invalidateDisplayList();
        }
    } */
    
    //----------------------------------
    //  displayItemsExpanded
    //----------------------------------
    
    /**
     *  @private
     *  Indicates that items will be shown expanded or not.
     */
    /* private var _displayItemsExpanded:Boolean = false;

    [Inspectable(category="General", enumeration="true,false", defaultValue="false")] */
    /**
     *  If <code>true</code>, expand the navigation tree to show all items.
     *  If a new branch is added, it will be shown expanded.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get displayItemsExpanded():Boolean
    {
        return _displayItemsExpanded;
    } */

   /*  public function set displayItemsExpanded(value:Boolean):void
    {
        if (value != _displayItemsExpanded)
        {
            _displayItemsExpanded = value;

            if (_displayItemsExpanded)
            {
                displayItemsExpandedChanged = true;
                invalidateProperties();
            }
        }
    } */
    
    //----------------------------------
    //  treeColumn
    //----------------------------------

    /**
     *  @private
     *  Storage for the treeColumn property.
     */
    /* private var _treeColumn:AdvancedDataGridColumn = null;

    [Inspectable(category="General")] */
    /**
     *  The column in which the tree is displayed.
     *  Set this property to the value of the <code>id</code> property of an
     *  AdvancedDataGridColumn instance, as the following example shows:
     *
     *  <pre>
     *    &lt;mx:AdvancedDataGrid 
     *       width="100%" height="100%"
     *       treeColumn="{rep}"&gt; 
     *       &lt;mx:dataProvider&gt;
     *          &lt;mx:HierarchicalData source="{dpHierarchy}" 
     *              childrenField="categories"/&gt;
     *       &lt;/mx:dataProvider&gt;
     *       &lt;mx:columns&gt;
     *          &lt;mx:AdvancedDataGridColumn dataField="Region"/&gt;
     *          &lt;mx:AdvancedDataGridColumn id="rep" 
     *              dataField="Territory_Rep"
     *              headerText="Territory Rep"/&gt;
     *          &lt;mx:AdvancedDataGridColumn dataField="Actual"/&gt;
     *          &lt;mx:AdvancedDataGridColumn dataField="Estimate"/&gt;
     *       &lt;/mx:columns&gt;
     *    &lt;/mx:AdvancedDataGrid&gt;</pre>
     *  
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function get treeColumn():AdvancedDataGridColumn
    {
        if (_treeColumn)
            return _treeColumn;
        
        return null;
    } */

    /**
     *  @private
     */
    /* public function set treeColumn(value:AdvancedDataGridColumn):void
    {
        if (value != _treeColumn)
        {
            _treeColumn = value;

            purgeItemRenderers();
            freeItemRenderersTable = new Dictionary(false);
            itemsSizeChanged = true;
            invalidateDisplayList();
        }
    } */
    
    //----------------------------------
    //  treeColumnIndex
    //----------------------------------
    
    /**
     *  The tree column number.
     *  
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function get treeColumnIndex():int
    {
        if (_treeColumn)
            return _treeColumn.colNum;
        
        return 0;
    } */
    
    //----------------------------------
    //  movingColumnIndex
    //----------------------------------
    
    // private var _movingColumnIndex:int;
    
    /**
     *  For Automation
     *  returns the index of the moving column, in the orderedHeadersList array.
     *  Essentialy the order in which column comes if traversed in a DFS manner
     *  @private
     */
    /* mx_internal function get movingColumnIndex():int
    {
        return _movingColumnIndex;

    } */
    /**
     *  Given the index, finds the corresponding column and set it as movingColumn
     *  @private
     */
    /* mx_internal function set movingColumnIndex(index:int):void
    {
        _movingColumnIndex = index;
        if (index >= 0 && orderedHeadersList
           && index < orderedHeadersList.length && orderedHeadersList[index])
            movingColumn = orderedHeadersList[index].column;
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Overridden Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    /* override protected function initializeAccessibility():void
    {
        if (AdvancedDataGrid.createAccessibilityImplementation != null)
            AdvancedDataGrid.createAccessibilityImplementation(this);
    } */
    
    /**
    *  @private
    */
    /* override protected function makeRowsAndColumns(left:Number, top:Number,
                                                   right:Number, bottom:Number,
                                                   firstCol:int, firstRow:int,
                                                   byCount:Boolean = false, rowsNeeded:uint = 0):Point
    {
        if (!visibleColumns || visibleColumns.length == 0)
            visibleCellRenderers = {};

        return super.makeRowsAndColumns(left, top, right, bottom, firstCol,
                                        firstRow, byCount, rowsNeeded);
    } */

   /**
    *  @inheritDoc
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Royale 0.9.4
    */
    /* override protected function finishKeySelection():void
    {
        if (isCellSelectionMode())
            finishCellKeySelection();
        else
            super.finishKeySelection();
    } */

    /**
     *  Updates the set of selected items given that the item renderer provided
     *  was clicked by the mouse and the keyboard modifiers are in the given
     *  state. This method also updates the display of the item renderers based
     *  on their updated selected state.
     *
     *  @param item The item renderer that was clicked.
     *
     *  @param shiftKey <code>true</code> if the Shift key was held down when
     *  the mouse was clicked.
     *
     *  @param ctrlKey <code>true</code> if the Control key was held down when
     *  the mouse was clicked.
     *
     *  @param transition <code>true</code> if the graphics for the selected 
     *  state should be faded in using an effect.
     *
     *  @return <code>true</code> if the set of selected items changed.
     *  Clicking an already selected item doesn't always change the set
     *  of selected items.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* override protected function selectItem(item:IListItemRenderer,
                                           shiftKey:Boolean, ctrlKey:Boolean,
                                           transition:Boolean = true):Boolean
    {

        if (isCellSelectionMode() && !selectedHeaderInfo)
            return selectCellItem(item, shiftKey, ctrlKey, transition);

        return super.selectItem(item, shiftKey, ctrlKey, transition);
    } */

   /**
    *  @private
    */
    /* override protected function drawVisibleItem(uid:String,
                                                selected:Boolean = false,
                                                highlighted:Boolean = false,
                                                caret:Boolean = false,
                                                transition:Boolean = false):void
    {
        if (isCellSelectionMode())
        {
            if (visibleCellRenderers[uid])
            {
                var n:int = _columns.length;
                for (var i:int = 0; i < n; i++)
                {
                    var bSelectCell:Boolean = cellSelectionData
                        && cellSelectionData[uid]
                        && cellSelectionData[uid][i];

                    var bHighlightCell:Boolean = highlightUID == uid
                        && highlightColumnIndex == i;

                    var bCaretCell:Boolean = caretUID == uid
                        && caretColumnIndex == i;

                    drawCellItem(visibleCellRenderers[uid][i],
                                 bSelectCell,
                                 bHighlightCell,
                                 bCaretCell);
                }
            }
        }

        super.drawVisibleItem(uid, selected, highlighted, caret, transition);
    } */

   /**
    *  @private
    */
    /* override protected function setVisibleDataItem(uid:String, item:IListItemRenderer):void
    {
        if (isCellSelectionMode())
        {
            if (uid)
            {
                if (!visibleCellRenderers[uid])
                    visibleCellRenderers[uid]  = {};
                visibleCellRenderers[uid]
                    [indexToColNum(currentColNum)] = item;
            }
        }

        super.setVisibleDataItem(uid, item);
    } */
    
    /**
     *  @private
     *
     */
    /* override protected function addRendererToContentArea(item:IListItemRenderer, column:AdvancedDataGridColumn):void
    {
        //Creating a header
        if(columnGrouping && item.data is AdvancedDataGridColumn)
        {
            var headerInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(item.data as AdvancedDataGridColumn);

            if(headerInfo && (headerInfo.columnSpan + headerInfo.actualColNum) <= lockedColumnCount)
                listContent.addChild(DisplayObject(item));
            else
                listSubContent.addChild(DisplayObject(item));
        }
        else
        {
            super.addRendererToContentArea(item, column);
        }
    } */
    
    /**
     *  @private
     *
     */
    /* override protected function mouseEventToItemRenderer(event:MouseEvent):IListItemRenderer
    {
        if(!columnGrouping)
        {
            return super.mouseEventToItemRenderer(event);
        }
        else
        {
            var r:IListItemRenderer;

            if (event.target == highlightIndicator || event.target == listContent)
            {
                var pt:Point = new Point(event.stageX, event.stageY);
                pt = listContent.globalToLocal(pt);

                var ww:Number = 0;

                // For headerItems
                r = findHeaderRenderer(pt);
            }

            if (!r)
                r = super.mouseEventToItemRenderer(event);

            // To handle case when mouse is at the border of the header item
            // renderer. Ignoring prevents flickering of the highlight of the
            // header because of infinite loop of mouseOver and mouseOut events.
            if (event.target == listContent && isHeaderItemRenderer(r))
                return null;

            return r == itemEditorInstance ? null : r;

        }
    } */

    /**
     *  @private
     * 
     */
    /* override protected function hasHeaderItemsCreated(index:int=-1):Boolean
    {
        if(!columnGrouping)
            return super.hasHeaderItemsCreated(index);

        if(index == -1)
            return (visibleHeaderInfos && visibleHeaderInfos[0].headerItem);

        var headerInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(getOptimumColumns()[index]);
        return (headerInfo && headerInfo.headerItem);
    } */

    /**
     *  @private
     * 
     */
    /* override protected function purgeHeaderRenderers():void
    {
        if(!columnGrouping)
        {
            super.purgeHeaderRenderers();
        }
        else
        {
            if(headerItemsList && headerItemsList.length)
            {
                while (headerItemsList.length)
                {
                    var item:IListItemRenderer = headerItemsList.pop();
                    addHeaderToFreeItemRenderers(item, item.data as AdvancedDataGridColumn);
                }
            }
        }
    } */

    /**
     *  @private
     */
    /* override protected function createHeaders(left:Number, top:Number):void
    {       
        if (!columnGrouping)
        {
            var creatingHeaders:Boolean = false;
            if (horizontalScrollPolicy != ScrollPolicy.OFF && getOptimumColumns()!= visibleColumns)
            {
                if (!headerItems[0] || !headerItems[0][0] || (top < headerItems[0][0].y + headerItems[0][0].height)) 
                    creatingHeaders = true;
            }

            super.createHeaders(left, top);
            
            if (creatingHeaders)
            {
                creatingHeaders = false;
                
                var residualWidth:Number = getLastColumnResidualWidth();
                
                var lastColIndex:int = displayableColumns.length - 1;
                var lastCol:AdvancedDataGridColumn = displayableColumns[lastColIndex];
                var w:Number = (isNaN(lastCol.explicitWidth) ? lastCol.preferredWidth : lastCol.explicitWidth);

                var item:IListItemRenderer = headerItems[0][lastColIndex];
                if (item)
                {
                    item.explicitWidth = w + residualWidth;
                    UIComponentGlobals.layoutManager.validateClient(item, true);
                    item.setActualSize(w + residualWidth, item.height);
                }
            }
            
        }
        else
        {
            if(visibleHeaderInfos && (!visibleHeaderInfos[0].headerItem || (top < visibleHeaderInfos[0].headerItem.y + visibleHeaderInfos[0].headerItem.height)))
            {
                //Creating new header items..need to purge old ones.
                purgeHeaderRenderers();
                headerItemsList = [];
                lastColumnWidth = NaN;

                //Just create the headerItems!! no measuring, Nothing
                createHeaderItems(visibleHeaderInfos);
                headerRowInfo = [];

                //Calculate the heights of each header rows
                measureHeaderHeights(visibleHeaderInfos,0);

                //Set heights of all headerItems
                var visibleHeaderInfo:AdvancedDataGridHeaderInfo;
                var padding:int = cachedPaddingTop + cachedPaddingBottom;
                var currentItemHeight:Number=0;

                var n:int = orderedHeadersList.length;
                for (var i:int = 0; i < n; i++)
                {
                    visibleHeaderInfo = orderedHeadersList[i];
                    if(visibleHeaderInfo.visible)
                    {

                        currentItemHeight = headerRowInfo[visibleHeaderInfo.depth].height - padding;
                        
                        if(visibleHeaderInfo.visibleChildren)
                            currentItemHeight -= headerRowInfo[visibleHeaderInfo.depth+1].height;

                        if(horizontalScrollPolicy != ScrollPolicy.OFF && !isNaN(lastColumnWidth) 
                           && visibleHeaderInfo.column == displayableColumns[displayableColumns.length-1])
                            visibleHeaderInfo.headerItem.setActualSize(lastColumnWidth, currentItemHeight);
                        else
                            visibleHeaderInfo.headerItem.setActualSize(visibleHeaderInfo.column.width, currentItemHeight);

                        visibleHeaderInfo.headerItem.visible = headerVisible;
                    }
                }

                lastColumnWidth = NaN;

                //Done with measuring, we know the dimensions for each header now. Just layout them at their proper place
                layoutHeaders(visibleHeaderInfos, left, top,0);

                currentItemTop = headerVisible ? headerRowInfo[0].height : 0;
                _headerHeight = !_explicitHeaderHeight ?  headerRowInfo[0].height : _headerHeight;
            }
        }
    } */

    /**
     *  Returns the item renderer for a specific item in a column.
     *
     *  @param c The AdvancedDataGridColumn instance for the column.
     *
     *  @param itemData The item in the column.
     *
     *  @return The IListItemRenderer defining the item renderer.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* override mx_internal function getRenderer(c:AdvancedDataGridColumn, itemData:Object, forDragProxy:Boolean = false):IListItemRenderer
    {
        var renderer:IListItemRenderer;
        var factory:IFactory;

        var adgDescription:AdvancedDataGridRendererDescription;

        if (rendererProviders.length != 0)
            adgDescription = getRendererDescription(itemData,c,forDragProxy);

        if (adgDescription && adgDescription.renderer)
        {
            if (freeItemRenderersTable[c]
                    && freeItemRenderersTable[c][adgDescription.renderer]
                    && freeItemRenderersTable[c][adgDescription.renderer].length)
            {
                renderer = freeItemRenderersTable[c][adgDescription.renderer].pop();
            }
           else
            {
                renderer = adgDescription.renderer.newInstance();
                itemRendererToFactoryMap[renderer] = adgDescription.renderer;
            }
            rendererDescriptionMap[renderer] = adgDescription;

            return renderer;
        }

        return super.getRenderer(c, itemData, forDragProxy);
    } */

    /**
     *  @private
     *  This grid just returns the column size,
     *  but could handle column spanning.
     */
    /* override mx_internal function getWidthOfItem(item:IListItemRenderer,
                                                 col:AdvancedDataGridColumn, visibleColumnIndex:int):Number
    {
        var ww:Number = 0;
        var adgDescription:AdvancedDataGridRendererDescription = rendererDescriptionMap[item] as AdvancedDataGridRendererDescription;
        if (adgDescription && adgDescription.renderer)
        {
            var i:int;
            var end:int;
            // set the width of the item according to the number of columns it is spaning
            if (adgDescription.columnSpan == 0)
            {
                end = _columns.length;
                if (visibleColumnIndex < lockedColumnCount)
                    end = lockedColumnCount;

                var tmpWidth:Number = 0;
                for (i = visibleColumnIndex; i < end ;i++)
                {
                    tmpWidth += AdvancedDataGridColumn(_columns[i]).width;
                }
                ww = tmpWidth;
            }
            else
            {
                ww = 0;
                end = visibleColumnIndex+adgDescription.columnSpan;
                if (visibleColumnIndex < lockedColumnCount && end > lockedColumnCount)
                    end = lockedColumnCount;
                if (end > displayableColumns.length)
                    end = displayableColumns.length;

                var optimumColumns:Array = getOptimumColumns();
                for (i = visibleColumnIndex; i < end ; i++)
                {
                    ww += super.getWidthOfItem(item,optimumColumns[i], visibleColumnIndex);
                }
            }

            var lastColIndex:int = displayableColumns.length - 1;
            if(horizontalScrollPolicy != ScrollPolicy.OFF 
               && lastColIndex >= visibleColumnIndex && lastColIndex < end)
            {
                // Find the extra width we need to add..
                var residualWidth:Number = getLastColumnResidualWidth();
                var lastCol:AdvancedDataGridColumn = displayableColumns[lastColIndex];
                // subtract the width which got added above in the loop
                ww -= lastCol.width;
                // Add the corrected width
                ww += (isNaN(lastCol.explicitWidth) ? 
                       lastCol.preferredWidth : 
                       lastCol.explicitWidth) + getLastColumnResidualWidth();
            }
            return ww ;
        }
        else if(horizontalScrollPolicy != ScrollPolicy.OFF
                && col == displayableColumns[displayableColumns.length-1])
        {
            return (isNaN(col.explicitWidth) ? col.preferredWidth : col.explicitWidth) + getLastColumnResidualWidth();
        }
        else
        {
            return super.getWidthOfItem(item, col, visibleColumnIndex);
        }
    } */
    
    /**
     *  @private
     *  Creates the header seperators taking into 
     *  account the different depths of the two headers 
     *  on the two sides of the seperator
     */
    /* override protected function createHeaderSeparators(n:int, separators:Array, headerLines:UIComponent):void
    {
        if(!columnGrouping)
        {
            super.createHeaderSeparators(n, separators, headerLines);
        }
        else
        {
            var separatorAffordance:Number = 3;

            var optimumColumns:Array = getOptimumColumns();

            var offset:int = (lockedColumnCount > 0 && separators != lockedSeparators) ? lockedColumnCount - 1 : 0;
            for (var i:int = 0; i < n; i++)
            {
                var headerItemIndex:int = i + offset; 
                var sep:UIComponent = getSeparator(i, separators, headerLines);
                var sepSkin:IFlexDisplayObject = IFlexDisplayObject(sep.getChildAt(0));

                var leftHeaderInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(optimumColumns[headerItemIndex]);

                var leftHeaderItem:IListItemRenderer = leftHeaderInfo.headerItem;
                if(!leftHeaderInfo || !leftHeaderInfo.visible || !(leftHeaderItem ))
                {
                    sep.visible = false;
                    continue;
                }
                
                sep.visible = true;
                var posX:Number;
                posX = leftHeaderItem.x +
                    optimumColumns[headerItemIndex].width - Math.round(sep.measuredWidth / 2 + 0.5);
            
                if (i > 0)
                {
                    posX = Math.max(posX,
                                    separators[i - 1].x + Math.round(sep.measuredWidth / 2 + 0.5));
                }
                sep.x = posX;

                //Column on the other side of the seperator
                var rightHeaderInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(optimumColumns[headerItemIndex+1]);

                var lineHeight:Number;
                //Based on what is on left and right of the seperator
                //We need to find out the height of the separator
                var leftParent:AdvancedDataGridHeaderInfo = leftHeaderInfo;
                var rightParent:AdvancedDataGridHeaderInfo = rightHeaderInfo;
                var padding:int = cachedPaddingBottom+cachedPaddingTop;
                while(leftParent!=rightParent && leftParent.parent!=null && rightParent.parent!=null)
                {
                    if(leftParent.depth > rightParent.depth)
                    {
                        leftParent = leftParent.parent;
                    }
                    else if(leftParent.depth < rightParent.depth)
                    {
                        rightParent = rightParent.parent;
                    }
                    else
                    {
                        leftParent = leftParent.parent;
                        rightParent = rightParent.parent;
                    }
                }

                sep.y = 0;
                lineHeight = leftHeaderItem.y + leftHeaderItem.height + padding;
                //Two columns have the same ancestor, may not be parent!!
                if(leftParent == rightParent && leftParent)
                {
                    sep.y = leftParent.headerItem.y + leftParent.headerItem.height + cachedPaddingBottom;
                    lineHeight = leftHeaderItem.y + leftHeaderItem.height - leftParent.headerItem.y - leftParent.headerItem.height;
                }

                sepSkin.setActualSize(sepSkin.measuredWidth,lineHeight);

                // Draw invisible background for separator affordance
                sep.graphics.clear();
                sep.graphics.beginFill(0xFFFFFF, 0);
                sep.graphics.drawRect(-separatorAffordance, 0, sepSkin.measuredWidth + separatorAffordance , lineHeight);
                sep.graphics.endFill();
            }
        }
    } */

    /**
     *  Setup Renderers
     *  Make renderer and populate <code>listItems</code> with them.
     *  @private
     */
    /* override protected function setupRenderer(itemData:Object,uid:String,insertItems:Boolean = false):void
    {
        var savedColNum:int = currentColNum;

        super.setupRenderer(itemData, uid, insertItems);
        
        if (rendererProviders.length == 0)
            return;

        var itemCount:int = listItems[currentRowNum].length;
        // count of the items which will be invisible due to the previous item's column span
        var count:int = 0;
        var optimumColumns:Array = getOptimumColumns();
        for(var i:int = 0; i < itemCount; ++i)
        {
            var item:IListItemRenderer = listItems[currentRowNum][i];
            var adgDescription:AdvancedDataGridRendererDescription = rendererDescriptionMap[item];
            if (adgDescription && adgDescription.renderer)
            {
                // set count to the max of the column span of the previous renderer and the present renderer
                if (adgDescription.columnSpan == 0)
                    count = Math.max(count-1, optimumColumns.length - i);
                else
                    count = Math.max(count-1, adgDescription.columnSpan - 1);
            }
            else if (count > 0)
            {
                // make the item invisible if there is already an item that is spaning onto it
                item.visible = false;
                count--;
            }
        }
    } */

    /**
     * @private 
     */
    /* override protected function updateDisplayOfItemRenderer(r:IListItemRenderer):void
    {
        applyUserStylesForItemRenderer(r);
        super.updateDisplayOfItemRenderer(r);
    }
	*/
    /**
     *  Draws a vertical line between columns. 
     *  This implementation draws a line
     *  directly into the given Sprite.  The Sprite has been cleared
     *  before lines are drawn into it.
     *
     *  @param s A Sprite that contains a DisplayObject
     *  that contains the graphics for that row.
     *
     *  @param columnIndex The column's index in the set of displayed columns.  
     *  The left most visible column has a column index of 0.
     *
     *  @param color The color for the indicator.
     * 
     *  @param x The x position for the background
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* override protected function drawVerticalLine(s:Sprite, colIndex:int, color:uint, x:Number):void
    {
        //draw our vertical lines
        var g:Graphics = s.graphics;
        if (lockedColumnCount > 0 && colIndex == lockedColumnCount - 1)
            g.lineStyle(1, 0, 100);
        else
            g.lineStyle(1, color, 100);

        var tempY:Number = 0;
        if(headerVisible)
        {
            tempY = headerRowInfo[0].height;
        }

        // check if custom renderers are used
        if (rendererProviders.length != 0)
        {
            var item:IListItemRenderer;
            var n:int = listItems.length;
            for (var i:int = 0; i < n; i++)
            {
                // if listItem has any item, update tempY
                if (listItems[i].length != 0)
                {
                    item = listItems[i][colIndex] as IListItemRenderer;
                    tempY = rowInfo[i].y + rowInfo[i].height;
                    // check for item and its width
                    if (item.visible)
                    {
                        if ((item.x +item.width) <= x)
                        {
                            g.moveTo(x, rowInfo[i].y);
                            g.lineTo(x, tempY);
                        }
                    }
                    else
                    {
                        // check for the item renderers in the previous columns in the same row
                        for (var j:int= colIndex - 1; j >= 0; j--)
                        {
                            item = listItems[i][j] as IListItemRenderer;
                            if (item.visible)
                            {
                                if ((item.x +item.width) <= x)
                                {
                                    g.moveTo(x, rowInfo[i].y);
                                    g.lineTo(x, tempY);
                                    break;
                                }
                                else
                                {
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }

        // draw line from tempY to listContent's height
        g.moveTo(x, tempY);
        g.lineTo(x, listContent.height);
    } */

    /**
     *  Get the appropriate renderer factory for a column, 
     *  using the default renderer if none specified
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* override mx_internal function columnItemRendererFactory(c:AdvancedDataGridColumn, forHeader:Boolean, itemData:Object):IFactory
    {
        var factory:IFactory;
        if (!forHeader)
        {
            if (_rootModel is  IHierarchicalData && c.colNum == treeColumnIndex)
            {
                if (!isBranch(itemData) && c.itemRenderer)
                {
                    factory = c.itemRenderer;
                }
                else if (groupItemRenderer)
                {
                    factory = groupItemRenderer;
                }
            }
        }
        if (!factory)
        {
            factory = super.columnItemRendererFactory(c, forHeader, itemData);
        }

        return factory;
    } */

    /**
     *  @private
     */
    /* override protected function getNumColumns():int
    {
        if(columnGrouping)
        {
            var optimumColumns:Array = getOptimumColumns();
            if(!optimumColumns)
                return 0;
            return optimumColumns.length;
        }
        else
        {
            return super.getNumColumns();
        }
    } */

    /**
     *  @private
     */
    /* override protected function getPossibleDropPositions(c:AdvancedDataGridColumn):Array
    {
        if(columnGrouping && c!=null)
        {
            var headerInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(c);
            if(headerInfo && headerInfo.parent && headerInfo.parent.visibleChildren && headerInfo.parent.visibleChildren.length > 0)
                return headerInfo.parent.visibleChildren;
            else
                return visibleHeaderInfos;
        }
        else
        {
            return super.getPossibleDropPositions(c);
        }
    } */

    /**
     *  @private
     */
    /* override mx_internal function getHeaderInfo(col:AdvancedDataGridColumn):AdvancedDataGridHeaderInfo
    {
        if(columnGrouping)
            return columnsToInfo[itemToUID(col)];
        else
            return super.getHeaderInfo(col);
    } */

    /**
     *  @private
     */
    /* override mx_internal function getHeaderInfoAt(colIndex:int):AdvancedDataGridHeaderInfo
    {
        if(columnGrouping)
            return columnsToInfo[itemToUID(_columns[colIndex])];
        else
            return super.getHeaderInfoAt(colIndex);
    } */

    /**
     *  @private
     */
    /* override protected function createChildren():void
    {
        super.createChildren();

        // This invisible layer, which is a child of listSubContent
        // catches mouse events for all items
        // and is where we put selection highlighting by default.
        if (!movingSelectionLayer)
        {
            movingSelectionLayer = new FlexSprite();
            movingSelectionLayer.name = "movingSelectionLayer";
            movingSelectionLayer.mouseEnabled = false;
            listSubContent.addChild(movingSelectionLayer);

            // trace("movingSelectionLayer parent set to " + movingSelectionLayer.parent);

            var g:Graphics = movingSelectionLayer.graphics;
            g.beginFill(0, 0); // 0 alpha means transparent
            g.drawRect(0, 0, 10, 10);
            g.endFill();
        }
    } */

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        if (dataProviderChanged)
        {
            var tmpCollection:Object;
            //reset flags 

            dataProviderChanged = false;

            if (hierarchicalCollectionInstance)
            {
                super.dataProvider = hierarchicalCollectionInstance;
            }
            // at this point _rootModel may be null so we dont need to continue
            else if (_rootModel is IHierarchicalData)
            {   
                //wrap userdata in a HierarchicalCollection and pass that collection to the List
                hierarchicalCollectionView.source = _rootModel;
                super.dataProvider = hierarchicalCollectionView;
            }
        }

        // if the data is grouped, get the groupLabelField.
        if (_rootModel is IGroupingCollection && IGroupingCollection(_rootModel).grouping)
            groupLabelField = IGroupingCollection(_rootModel).grouping.label;
		
		if (_rootModel is IGroupingCollection2 && IGroupingCollection2(_rootModel).grouping)
			groupLabelField = IGroupingCollection2(_rootModel).grouping.label;

        /*
        if (groupedColumnsChanged || columnsChanged)
        {
            anchorColumnIndex    = -1;
            highlightColumnIndex = -1;
            selectedColumnIndex  = -1;
        }

        // This code should always come after the hierarchicalData code above
        // because if no columns array has been defined, columns are generated 
        // based on the dataProvider. Thus setting of columns by dataProvider
        // falls in the same cycle of commitProperties and if moved above will 
        // not get picked unless a second call to commitProperties come
        if (groupedColumnsChanged)
        {
            columnGrouping = true;
            columnsChanged = false;

            removeOldHeaders();

            columnsToInfo = new Dictionary();
            headerInfos = initializeHeaderInfo(_groupedColumns);

            headerInfoInitialized = true;

            // In case a new set of groupedColumns have been specified
            // its possible the effective value of lockedColumnCount
            // changes
            if(lockedColumnCount > 0)
                lockedColumnCountChanged = true;

            super.columns = getLeafColumns(_groupedColumns.slice(0));
        }
        else if (columnsChanged)
        {
            columnGrouping = false;
            columnsChanged = false;

            removeOldHeaders();
			
			columnsToInfo = new Dictionary();
			headerInfos = initializeHeaderInfo(_columnsValue);
			
			headerInfoInitialized = true;

            super.columns = _columnsValue;
        }

        if (displayItemsExpandedChanged)
        {
            // if displayItemsExpanded is set to true, then expand all the items.
            if (displayItemsExpanded)
                expandAll();
        }
        */
        
        super.commitProperties();
        
        /*
        // lockedColumnCount set code should always come after groupedColumns set code
        // and super.commitProperties because in case of column grouping the actual value 
        // of lockedColumnCount is dependent on groupedColumns and visibleHeaderInfos
        // So if both are set in the same cycle then lockedColumnCount may miss the 
        // actual value
        if(lockedColumnCountChanged)
        {
            if(columnGrouping)
                super.lockedColumnCount = getAdjustedLockedCount(_lockedColumnCountVal);
            else
                super.lockedColumnCount = _lockedColumnCountVal;
        }

        if(groupedColumnsChanged)
        {
            groupedColumnsChanged = false;
            headerInfoInitialized = false;
        }

        if (selectedCellsChanged)
        {
            setSelectedCells(_temporary_selectedCells);
            selectedCellsChanged = false;
            _temporary_selectedCells = null;
        }

        // If column becomes hidden, invalidate anchor, highlight and selected indices.
        {
            if (anchorColumnIndex != -1 && _columns[anchorColumnIndex].visible == false)
                anchorColumnIndex = -1;
            if (highlightColumnIndex != -1 && _columns[highlightColumnIndex].visible == false)
                highlightColumnIndex = -1;
            if (selectedColumnIndex != -1 && _columns[selectedColumnIndex].visible == false)
                selectedColumnIndex = -1;
        }
        */
    }
    
    /**
     *  @private
     */
    /* override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void    
    {
        // Kill any animation before resizing;
        // tween is null if there is no Tween underway.
        if (tween)
            tween.endTween();

        // Display cells set in selectionMode which are not yet visible
        if (cellsWaitingToBeDisplayed)
            processCellsWaitingToBeDisplayed();

        super.updateDisplayList(unscaledWidth, unscaledHeight);

        if (headerVisible && columnGrouping)
            drawHeaderHorizontalSeparators();
        else
            clearHeaderHorizontalSeparators();

        //update collection length
        if (collection)
            collectionLength = collection.length;     

        // Keyboard access to header
        if (columnGrouping && selectedHeaderInfo)
        {
            selectColumnGroupHeader(selectedHeaderInfo);
        }
        else if(!columnGrouping && headerIndex != -1)
        {
            selectedHeaderInfo = getHeaderInfo(_columns[headerIndex]);
            selectColumnHeader(headerIndex);
        }
		
		// redraw the border
		layoutChrome(unscaledWidth, unscaledHeight);
    } */

    /**
     *  @private
     */
    /* override public function calculateDropIndex(event:DragEvent = null):int
    {
        if (event)
        {
            if (_rootModel is IHierarchicalData)
            {
                if (event)
                    updateDropData(event);

                return _dropData.rowIndex;
            }
        }

        return super.calculateDropIndex(event);
    } */

    /**
     *  @private
     */
    /* override protected function drawRowBackgrounds():void
    {
        var colors:Array;
        colors = getStyle("depthColors");
        
        if (!(_rootModel is IHierarchicalData) || !colors)
        {
            super.drawRowBackgrounds();
            return;
        }
        
        var rowBGs:Sprite = Sprite(listContent.getChildByName("rowBGs"));
        if (!rowBGs)
        {
            rowBGs = new FlexSprite();
            rowBGs.mouseEnabled = false;
            rowBGs.name = "rowBGs";
            listContent.addChildAt(rowBGs, 0);
        }

        var color:*;
        var depthColors:Boolean = false;
		var n:int = listItems.length;

        if (colors)
            depthColors = true;
        else
		{
			var colorsStyle:Object = getStyle("alternatingItemColors");
			if (colorsStyle)
				colors = (colorsStyle is Array) ? (colorsStyle as Array) : [colorsStyle];

		}

        color = getStyle("backgroundColor");
		if (color === undefined)
			color = 0xFFFFFF;
        if (!colors || colors.length == 0)
		{
			while (rowBGs.numChildren > n)
			{
				rowBGs.removeChildAt(rowBGs.numChildren - 1);
			}
			return;
		}

        styleManager.getColorNames(colors);

        var curRow:int = 0;

        var i:int = 0;
        var actualRow:int = verticalScrollPosition;

        while (curRow < n)
        {
            if (depthColors)
            {
                try {
                    if (listItems[curRow][0])
                    {
                        var d:int = getItemDepth(listItems[curRow][0].data, curRow);
                        drawRowBackground(rowBGs, i++, rowInfo[curRow].y, rowInfo[curRow].height, colors[d - 1], actualRow);
                    }
                    else
                    {
                        drawRowBackground(rowBGs, i++, rowInfo[curRow].y, rowInfo[curRow].height, uint(color), actualRow);
                    }
                }
                catch (e:Error)
                {
                    //trace("[Tree] caught exception in drawRowBackground");
                }
            }
            else
            {
                drawRowBackground(rowBGs, i++, rowInfo[curRow].y, rowInfo[curRow].height, colors[actualRow % colors.length], actualRow);
            }
            curRow++;
            actualRow++;
        }

        while (rowBGs.numChildren > i)
        {
            rowBGs.removeChildAt(rowBGs.numChildren - 1);
        }
    } */

    /**
     *  @private
     */
    /* override protected function isDraggingAllowed(draggedColumn:AdvancedDataGridColumn):Boolean
    {
        if (!draggedColumn.draggable)
            return false;
        
        if(columnGrouping)
        {
            var parentInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(draggedColumn).parent;
            
            //Parent doesn't allow its children to be draggable
            if(parentInfo && (parentInfo.column as AdvancedDataGridColumnGroup).childrenDragEnabled == false)
                return false;
        }
        return true;
    } */

    /**
     *  @private
     */
    /* override protected function columnDraggingMouseUpHandler(event:Event):void
    {
        if(!columnGrouping)
        {
            super.columnDraggingMouseUpHandler(event);
            return;
        }
        
        if (!movingColumn)
            return;

        var headerInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(movingColumn);
        
        var origIndex:int = headerInfo.index;//movingColumn.colNum;
        var dropPositions:Array = getPossibleDropPositions(movingColumn);
        var n:int = dropPositions.length;
        
        if (dropColumnIndex >= 0)
        {
            if (dropColumnIndex >= n)
                dropColumnIndex = n - 1;
            else if (origIndex < dropColumnIndex)
                dropColumnIndex--;
            
            //dropColumnIndex is actually the index into the group w.r.t to the displayableColumns, 
            //We need to get the corresponding actual index
            dropColumnIndex = dropPositions[dropColumnIndex].index;
        }

        // Shift columns.
        shiftColumns(origIndex, dropColumnIndex, event);
        unsetColumnDragParameters();

    } */

    /**
     *  @private
     */
    /* override protected function dragEnterHandler(event:DragEvent):void
    {
        // Drag-and-drop not supported for cells
        if (isCellSelectionMode())
            return;

        if (!(_rootModel is IHierarchicalData) && 
			(event.dragSource.hasFormat("items") || event.dragSource.hasFormat("itemsByIndex")))
        {
            super.dragEnterHandler(event);
            return;
        }

        if (event.isDefaultPrevented())
            return;
		
		lastDragEvent = event;

        if ((!_rootModel || _rootModel is IHierarchicalData) && event.dragSource.hasFormat("treeDataGridItems"))
        {
            DragManager.acceptDragDrop(this);
            DragManager.showFeedback(event.ctrlKey ?
                                     DragManager.COPY :
                                     DragManager.MOVE);
            showDropFeedback(event);
            return;
        }
        hideDropFeedback(event);
        DragManager.showFeedback(DragManager.NONE);
    } */

    /**
     *  @private
     */
    /* override protected function dragOverHandler(event:DragEvent):void
    {
        // Drag-and-drop not supported for cells
        if (isCellSelectionMode())
            return;

        if (!(_rootModel is IHierarchicalData) && 
			(event.dragSource.hasFormat("items") || event.dragSource.hasFormat("itemsByIndex")))
        {
            super.dragOverHandler(event);
            return;
        }

        if (event.isDefaultPrevented())
            return;
		
		lastDragEvent = event;

        if ((!_rootModel || _rootModel is IHierarchicalData) && event.dragSource.hasFormat("treeDataGridItems"))
        {
            DragManager.showFeedback(event.ctrlKey ?
                                     DragManager.COPY :
                                     DragManager.MOVE);
            showDropFeedback(event);
            return;
        }
        hideDropFeedback(event);
        DragManager.showFeedback(DragManager.NONE);
    } */

    /**
     *  Handler for the <code>DragEvent.DRAG_DROP</code> event.  
     *  This method  hides
     *  the drop feedback by calling the <code>hideDropFeedback()</code> method.
     * 
     *  By default, only the <code>DragManager.MOVE</code> drag action is supported. 
     *  To support the <code>DragManager.COPY</code> 
     *  drag action, you must write an event handler for the 
     *  <code>DragEvent.DRAG_DROP</code> event that 
     *  implements the copy of the AdvancedDataGrid data based on its structure.  
     *
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* override protected function dragDropHandler(event:DragEvent):void
    {
        // Drag-and-drop not supported for cells
        if (isCellSelectionMode())
            return;

        if (!(_rootModel is IHierarchicalData) && 
			(event.dragSource.hasFormat("items") || event.dragSource.hasFormat("itemsByIndex")))
        {
            super.dragDropHandler(event);
            return;
        }

        if (event.isDefaultPrevented())
            return;

        hideDropFeedback(event);

        if ((!_rootModel || _rootModel is IHierarchicalData) && event.dragSource.hasFormat("treeDataGridItems"))
        {
            //we only support MOVE by default
            if (event.action == DragManager.MOVE && dragMoveEnabled)
            {
                var items:Array = event.dragSource.dataForFormat("treeDataGridItems") as Array;
                //Are we dropping on ourselves?
                if (event.dragInitiator == this)
                {
                    // If we're dropping onto ourselves or a child of a descendant then dont actually drop

                    calculateDropIndex(event);

                    // If we did start this drag op then we need to remove first
                    var index:int;
                    var parent:*;
                    var parentItem:*;
                    //get ancestors of the drop target item
                    var dropParentStack:Array = getParentStack(_dropData.parent);
                    dropParentStack.unshift(_dropData.parent); //optimize stack method
                    var n:int = items.length;
                    for (var i:int = 0; i < n; i++) 
                    { 
                        parent = getParentItem(items[i]);
                        index = getChildIndexInParent(parent, items[i]);
                        //check ancestors of the dropTarget if the item matches, we're invalid
                        for each (parentItem in dropParentStack)
                        { 
                            //we dont want to drop into one of our own sets of children
                            if (items[i] == parentItem)
                                return;
                        }
                        //we remove before we add due to the behavior 
                        //of structures with parent pointers like e4x
                        removeChildItem(parent, items[i], index);
                        //is the removed item before the drop location?
                        if (parent == _dropData.parent && index < _dropData.index) 
                        {
                            addChildItem(_dropData.parent, items[i], (_dropData.index - i - 1));
                        }
                        else 
                        {
                            addChildItem(_dropData.parent, items[i], _dropData.index);
                        }
                    }
                }
            }
        }
		lastDragEvent = null;
    } */

    /**
     *  Handler for the <code>DragEvent.DRAG_COMPLETE</code> event.
     * 
     *  By default, only the <code>DragManager.MOVE</code> drag action is supported. 
     *  To support the <code>DragManager.COPY</code> 
     *  drag action, you must write an event handler for the 
     *  <code>DragEvent.DRAG_DROP</code> event that 
     *  implements the copy of the AdvancedDataGrid data based on its structure.  
     * 
     *  @param event The DragEvent object.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* override protected function dragCompleteHandler(event:DragEvent):void
    {
        // Drag-and-drop not supported for cells
        if (isCellSelectionMode())
            return;

        if (!(_rootModel is IHierarchicalData) && 
			(event.dragSource.hasFormat("items") || event.dragSource.hasFormat("itemsByIndex")))
        {
            super.dragCompleteHandler(event);
            return;
        }

        isPressed = false;

        if (event.isDefaultPrevented())
            return;
		
		resetDragScrolling();

        if ((!_rootModel || _rootModel is IHierarchicalData) && event.dragSource.hasFormat("treeDataGridItems"))
        {
            var items:Array;
            //we only support MOVE by default
            if (event.action == DragManager.MOVE && dragMoveEnabled)
            {
                if (event.relatedObject != this)
                {
                    //if we dropped on another component 
                    //then we need to remove from ourself first
                    items = event.dragSource.dataForFormat("treeDataGridItems") as Array;
                    var parent:*;
                    var index:int;
                    //do the remove
                    var n:int = items.length;
                    for (var i:int=0; i < n; i++)
                    {
                        parent = getParentItem(items[i]);
                        index = getChildIndexInParent(parent, items[i]);
                        removeChildItem(parent, items[i], index);
                    }
                    addItemsToTarget(event, items);
                }
                clearSelected(false);
            }
            else if (event.action == DragManager.COPY)
            {
                if (event.relatedObject != this)
                {
                    items = event.dragSource.dataForFormat("treeDataGridItems") as Array;
                    addItemsToTarget(event, items);
                }
                clearSelected(false);
            }
            
        }
		lastDragEvent = null;
    } */
    
    /**
     *  @private
     *  Initialized the headerInfos structure w.r.t to the columns 
     *  configuration
     */
    /* override protected function initializeHeaderInfo(columns:Array):Array
    {
        if (!columnGrouping)
            return super.initializeHeaderInfo(columns);
        else
            return initializeGroupedHeaderInfo(columns, null,0,null);
    } */
    
    /**
     *  @private
     */
    /* override protected function createDisplayableColumns():void
    {
        if (!columnGrouping)
        {
            super.createDisplayableColumns();
        }
        else
        {
            var i:int;
            var n:int;
            
            displayableColumns = [];
            n = _columns.length;
            for (i = 0; i < n; i++)
            {
                if(getHeaderInfo(_columns[i]).visible)
                    displayableColumns.push(_columns[i]);
            }
        }
    } */

    /**
     *  @private
     */
    /* override protected function updateVisibleHeaders():Array
    {
        if (!columnGrouping)
            return super.updateVisibleHeaders();
        else
            return updateVisibleHeaderInfos(headerInfos).infos;
    } */
    
    /**
     *  @private
     */
    /* override protected function updateHeaderSearchList():void
    {
        orderedHeadersList = [];
        updateHeadersList(visibleHeaderInfos);
    } */

    /**
     *  @private
     */
    /* override protected function calculateHeaderHeight():Number
    {
        if (!columnGrouping)
            return super.calculateHeaderHeight();
            
        // first measure the header
        isMeasuringHeader = true;
        createHeaders(0, 0);
        isMeasuringHeader = false;
        
        return headerHeight;
    } */

    /**
     *  @private
     *  Position indicator bar that shows where an item will be placed in the list.
     */
    /* override public function showDropFeedback(event:DragEvent):void
    {
        if (!(_rootModel is IHierarchicalData))
        {
            super.showDropFeedback(event);
            return;
        }

        super.showDropFeedback(event);
        // Adjust for indent
        var vm:EdgeMetrics = viewMetrics;
        var offset:int = 0;
        updateDropData(event);
        var indent:int = 0;
        var depth:int;
        if (_dropData.parent)
        {
            offset = getItemIndex(iterator.current);
            depth = getItemDepth(_dropData.parent, Math.abs(offset - getItemIndex(_dropData.parent)));
            indent = (depth + 1) * getStyle("indentation");
        }
        else 
        {
            indent = getStyle("indentation");
        }
        if (indent < 0)
            indent = 0;
        //position drop indicator
        dropIndicator.width = listContent.width - indent;
        dropIndicator.x = indent + vm.left + 2;
        if (_dropData.emptyFolder)
        {
            dropIndicator.y += _dropData.rowHeight / 2;
        }
    } */

    /**
     *  @private
     */
    /* override protected function addDragData(ds:Object):void    // actually a DragSource
    {
        if (_rootModel is IHierarchicalData)
            ds.addHandler(collapseSelectedItems, "treeDataGridItems");
        else
            super.addDragData(ds);
    } */

    /**
     *  @private
     *  Set the itemEditor instance position according to the indentation of the item it is representing.
     */
    /* override protected function layoutItemEditor():void
    {
        if (_rootModel is IHierarchicalData)
        {
            var indent:int = rowMap[editedItemRenderer.name].indent;
            itemEditorInstance.move(itemEditorInstance.x + indent, itemEditorInstance.y);
            itemEditorInstance.setActualSize(itemEditorInstance.width - indent, itemEditorInstance.height);
        }
    } */

    /**
     *  @private
     */
    /* override protected function selectColumnHeader(columnNumber:int):void
    {
        if(!columnGrouping || selectedHeaderInfo == null)
            super.selectColumnHeader(columnNumber);
        else
            selectColumnGroupHeader(selectedHeaderInfo);
    } */

    /**
     *  @private
     */
    /* override public function createItemEditor(colIndex:int, rowIndex:int):void
    {
        // TODO - Check for the item renderer instead of the column number
        if (_rootModel is IHierarchicalData && colIndex == treeColumnIndex)
        {
            var col:AdvancedDataGridColumn = displayableColumns[colIndex];
            if (col.editorXOffset == 0 || col.editorWidthOffset == 0)
            {
                col.editorXOffset = 12;
                col.editorWidthOffset = -12;
            }
        }
        super.createItemEditor(colIndex, rowIndex);
    } */

    /**
     *  @private
     */
    /* override protected function adjustAfterRemove(items:Array, location:int, emitEvent:Boolean):Boolean
    {
        var requiresValueCommit:Boolean = emitEvent;

        if (isCellSelectionMode())
        {
            var n:int = items.length;
            for (var i:int = 0; i < n; i++)
            {
                var uid:String = UIDUtil.getUID(items[i]);

                if (cellSelectionData[uid])
                {
                    for (var p:String in cellSelectionData[uid])
                    {
                        removeCellIndicators(uid, int(p));
                        removeCellSelectionData(uid, int(p));
                        requiresValueCommit = true;
                    }
                }
            }
        }
        else // if (isRowSelectionMode())
        {
            var indicesLength:int = selectedItems.length;
            var length:int = items.length;

            if (_selectedIndex > location)
            {
                _selectedIndex -= length;
                requiresValueCommit = true;
            }

            if (bSelectedItemRemoved && indicesLength < 1)
            {
                _selectedIndex = getItemIndex(expandedItem);
                requiresValueCommit = true;
                bSelectionChanged = true;
                bSelectedIndexChanged = true;
                invalidateDisplayList();
            }
        }

        return requiresValueCommit;
    } */

    /**
     *  @private
     */
    /* override protected function makeListData(data:Object, uid:String, 
                                             rowNum:int, columnNum:int, column:AdvancedDataGridColumn):BaseListData
    {
        var label:String ;
        var advancedDataGridListData:AdvancedDataGridListData;
        if(data is AdvancedDataGridColumnGroup) 
        {
            return new AdvancedDataGridListData((column.headerText != null) ? column.headerText : "", 
                                                data.dataField, -1, uid, this, rowNum);
        }
        else if (!(data is AdvancedDataGridColumn))
        { 
            if (groupItemRenderer && isBranch(data) && column.colNum == treeColumnIndex)
            {
                // Checking for a groupLabelFunction or a groupLabelField property to be present
                if (groupLabelFunction != null)
                    label = groupLabelFunction(data, column);
                else if (groupLabelField != null && data.hasOwnProperty(groupLabelField))
                    label = data[groupLabelField];

                if (label)
                    advancedDataGridListData = new AdvancedDataGridListData(label, column.dataField, 
                                                                            columnNum, uid, this, rowNum);
            }
        }

        if (!advancedDataGridListData)
            advancedDataGridListData = 
                super.makeListData(data, uid, rowNum,columnNum,column) as AdvancedDataGridListData;

        if (iterator && iterator is IHierarchicalCollectionViewCursor && columnNum == treeColumnIndex
                        && !(data is AdvancedDataGridColumn))
            initListData(data, advancedDataGridListData);
        else
            //item needs to be set, otherwise it will flicker the display when a node is expanded or collapsed
            advancedDataGridListData.item = data;

        return advancedDataGridListData;
    } */

    /**
     *  @private
     */
    /* override public function itemToIcon(item:Object):Class
    {
        if (item == null)
        {
            return null;
        }

        var icon:*;
        var open:Boolean = isItemOpen(item);
        var branch:Boolean = isBranch(item);
        var uid:String = itemToUID(item);

        //first lets check the component
        var iconClass:Class =
            itemIcons && itemIcons[uid] ?
            itemIcons[uid][open ? "iconID2" : "iconID"] :
            null;

        if (iconClass)
        {
            return iconClass;
        }
        else if (iconFunction != null)
        {
            return iconFunction(item);
        }
        else if (branch)
        {
            return getStyle(open ? "folderOpenIcon" : "folderClosedIcon");
        }
        else
            //let's check the item itself
        {
            if (item is XML)
            {
                try
                {
                    if (item[iconField].length() != 0)
                        icon = String(item[iconField]);
                }
                catch(e:Error)
                {
                }
            }
            else if (item is Object)
            {
                try
                {
                    if (iconField && item[iconField])
                        icon = item[iconField];
                    else if (item.icon)
                        icon = item.icon;
                }
                catch (e:Error)
                {
                }
            }
        }

        //set default leaf icon if nothing else was found
        if (icon == null)
            icon = getStyle("defaultLeafIcon");

        //convert to the correct type and class
        if (icon is Class)
        {
            return icon;
        }
        else if (icon is String)
        {
            iconClass = Class(systemManager.getDefinitionByName(String(icon)));
            if (iconClass)
                return iconClass;

            return document[icon];
        }
        else
        {
            return Class(icon);
        }

    } */
        
    /**
     *   Checks to see if item is visible in the list
     *  @private
     */
    /* override public function isItemVisible(item:Object):Boolean
    {
        //first check visible data
        if (visibleData[itemToUID(item)])
            return true;

        //then check parent items
        var parentItem:Object = getParentItem(item);
        if (parentItem)
        {
            var uid:String = itemToUID(parentItem);
            if (visibleData[uid] && IHierarchicalCollectionView(collection).openNodes[uid])
            {
                return true;
            }
        }
        return false;
    } */
    
    /**
     *  @private
     */
    /* override protected function isDataEditable(data:Object):Boolean
    {
        if (_rootModel && (_rootModel is IGroupingCollection || _rootModel is IGroupingCollection2))
        {
            // group header
            if (_rootModel.hasChildren(data))
                return editable.indexOf("group") != -1;

            // summary data
            if (data is SummaryObject)
                return editable.indexOf("summary") != -1;
        }

        // any item renderer
        return editable.indexOf("item") != -1;
    } */
    
    /**
     *  @private
     *
     *  see ListBase.as
     */
    /* override mx_internal function addClipMask(layoutChanged:Boolean):void
    {    
        var vm:EdgeMetrics = viewMetrics;
        var bHScrollBar:Boolean 
        if (horizontalScrollBar && horizontalScrollBar.visible)
            vm.bottom -= horizontalScrollBar.minHeight;

        if (verticalScrollBar && verticalScrollBar.visible)
            vm.right -= verticalScrollBar.minWidth;

        if(verticalScrollBar && verticalScrollBar.visible && horizontalScrollBar && horizontalScrollBar.visible)
            vm.right += verticalScrollBar.minWidth;
        
        listContent.scrollRect = new Rectangle(
            0, 0,
            unscaledWidth - vm.left - vm.right,
            listContent.height);
    } */
    
    /* override mx_internal function shiftColumns(oldIndex:int, newIndex:int,
                                               trigger:Event = null):void
    {
        if (newIndex >= 0 && oldIndex != newIndex)
        {
            if(!columnGrouping)
            {
                super.shiftColumns(oldIndex, newIndex, trigger);
            }
            else
            {
                var headerInfo:AdvancedDataGridHeaderInfo =  getHeaderInfo(movingColumn);
                //needed for automation, which uses movingColumnIndex
                updateMovingColumnIndex();
                var groupInfos:Array = headerInfo.parent ? headerInfo.parent.children : headerInfos;
                var groupColumns:Array = headerInfo.parent == null ? groupedColumns : (headerInfo.parent.column as AdvancedDataGridColumnGroup).children;
                
                var k:int;
                var queue:Array = [];
                var pointer:int = 0;
                var i:int;
                var increment:int;
                if (newIndex >= 0 && oldIndex != newIndex)
                {
                    var incr:int = oldIndex < newIndex ? 1 : -1;
                    for (i = oldIndex; i != newIndex; i += incr)
                    {
                        var j:int = i + incr;
                        var c:AdvancedDataGridColumn = groupColumns[i];
                        groupColumns[i] = groupColumns[j];
                        groupColumns[j] = c;

                        groupInfos[i].actualColNum +=  groupInfos[j].columnSpan * incr;
                        groupInfos[j].actualColNum -=  groupInfos[i].columnSpan * incr;

                        //If the columns being dragged or shifted is a Column Group then actualColNum
                        //need to be modified for all the descendants of the column group.
                        if (groupInfos[i].children && groupInfos[i].children.length > 0)
                        {
                            increment = groupInfos[j].columnSpan * incr;
                            for( k = 0; k < groupInfos[i].children.length; k++)
                            {
                                queue.push(groupInfos[i].children[k]);
                            }
                            while (queue[pointer])
                            {
                                headerInfo = queue[pointer++];
                                headerInfo.actualColNum +=  increment;
                                if(headerInfo && headerInfo.children)
                                {
                                    for( k = 0; k < headerInfo.children.length; k++)
                                    {
                                        queue.push(headerInfo.children[k]);
                                    }
                                }  
                            }
                        }
                        if (groupInfos[j].children && groupInfos[j].children.length > 0)
                        {
                            queue = [];
                            pointer = 0;
                            increment = groupInfos[i].columnSpan * incr;
                            for( k = 0; k < groupInfos[j].children.length; k++)
                            {
                                queue.push(groupInfos[j].children[k]);
                            }
                            while (queue[pointer])
                            {
                                headerInfo = queue[pointer++]
                                    headerInfo.actualColNum -=  increment;
                                if(headerInfo && headerInfo.children)
                                    for( k = 0; k < headerInfo.children.length; k++)
                                        queue.push(headerInfo.children[k]);  
                            }
                        }

                        var cInfo:AdvancedDataGridHeaderInfo = groupInfos[i];
                        groupInfos[i] = groupInfos[j];
                        groupInfos[j] = cInfo;
                        groupInfos[i].index -=incr;
                        groupInfos[j].index += incr;

                    }

                    var newColumns:Array = getLeafColumns(groupedColumns);
                    _columns = [];
                    var n:int = newColumns.length;
                    for (i = 0; i < n; i++)
                    {
                        _columns[i] = newColumns[i];
                        _columns[i].colNum = i;

                    }
                    visibleHeaderInfos = updateVisibleHeaders();
                    updateHeaderSearchList();
                    
                    createDisplayableColumns();
                    //In case of column grouping a shifting of columns may lead to
                    //change in the effective layout owing to a bigger or
                    //smaller group shifted in from locked area to unlocked area
                    //or vice versa
                    var newLockedColCount:int =  getAdjustedLockedCount(_lockedColumnCountVal);
                    if (lockedColumnCount != newLockedColCount)
                    {
                        lockedColumnCountChanged = true;
                        super.lockedColumnCount = newLockedColCount;
                    }
                    columnsInvalid = true;
                    itemsSizeChanged = true;
                    invalidateDisplayList();
                    var icEvent:IndexChangedEvent =
                        new IndexChangedEvent(IndexChangedEvent.HEADER_SHIFT);
                    icEvent.oldIndex = oldIndex;
                    icEvent.newIndex = newIndex;
                    icEvent.triggerEvent = trigger;
                    dispatchEvent(icEvent);
                }
            }
            if (isCellSelectionMode())
                clearSelectedCells();
        }
    } */
    
    public function columnsInvalid():void
    {
        dispatchEvent(new Event("columnsInvalid"));
    }
    
    /**
     *  @private
     *  Fetch sort information for the given column.
     */
    /* override public function getFieldSortInfo(column:AdvancedDataGridColumn):SortInfo
    {
        if (!sortExpertMode && visualSortInfo[column.colNum])
            return visualSortInfo[column.colNum];

         var headerInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(column);

         if (columnGrouping && column && collection && collection.sort
             && headerInfo.internalLabelFunction != null)
         {

            var n:int = collection.sort.fields.length;
            for (var i:int = 0; i < n; i++)
            {
                var uid:String = itemToUID(column);
                if( uid &&  collection.sort.fields[i].name == uid)
                    return new SortInfo(i + 1, collection.sort.fields[i].descending);
            }
        }
        else
        {
            return super.getFieldSortInfo(column);
        }

        return null;
    } */
    
    /**
     *  @private
     */
    /* override protected function unselectColumnHeader(columnNumber:int,
                                                     completely:Boolean=false):void
    {
        var s:Sprite = Sprite( selectionLayer.getChildByName("headerKeyboardSelection") );

        //If not found, then see if there is a child in the movingSelectionLayer
        if(!s)
            s = Sprite(movingSelectionLayer.getChildByName("headerKeyboardSelection"));

        if (s)
            s.parent.removeChild(s);

        selectedHeaderInfo = null;

        if (completely)
        {
            caretIndex = 0;
            isPressed = false;

            if (isCellSelectionMode())
            {
                caretColumnIndex = columnNumber;
                selectItem(listItems[caretIndex][absoluteToVisibleColumnIndex(columnNumber)],
                           false, false);
            }
            else
            {
                selectItem(listItems[caretIndex][0], false, false);
            }
        }
    } */
    
    /**
     *  @private
     */
    /* override public function styleChanged(styleProp:String):void
    {
        super.styleChanged(styleProp);

        if (styleProp == "sortFontFamily"
            || styleProp == "sortFontSize"
            || styleProp == "sortFontStyle"
			|| styleProp == "sortFontWeight"
			|| styleProp == "layoutDirection")
        {
            itemsSizeChanged = true;
            rendererChanged = true;
            invalidateProperties();
            invalidateDisplayList();
        }
    } */
    
    /**
     *  @private
     */
    /* override protected function removeIndicators(uid:String):void
    {
        if (isCellSelectionMode())
        {
			var keys:Array = [];
			for (var p:String in cellSelectionIndicators[uid]) {
				keys.push(p);	
			}
			
			for each (p in keys) {
				removeCellIndicators(uid, int(p));
			}

            delete visibleCellRenderers[uid];
        }

        super.removeIndicators(uid);
    } */
    
    /**
     *  Moves the cell and row selection indicators up or down by the given offset
     *  as the control scrolls its display.
     *  This assumes all the selection indicators in this row are at
     *  the same y position.
     *
     *  @param uid The UID of the row.
     *
     *  @param The scroll offset.
     *
     *  @param absolute <code>true</code> if <code>offset</code> contains the new scroll position,
     *  and <code>false</code> if it contains a value relative to the current scroll position.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* override protected function moveIndicators(uid:String, offset:int, absolute:Boolean):void
    {
        if (!uid)
            return;
        
        if (!absolute && offset == 0)
            return;

         if (isCellSelectionMode())
         {
            if (cellSelectionIndicators[uid])
            {
                for (var p:String in cellSelectionIndicators[uid])
                {
                    if (absolute)
                        cellSelectionIndicators[uid][p].y = offset;
                    else
                        cellSelectionIndicators[uid][p].y += offset;
                }
            }
        }
        else
        {
            // Functionality in AdvancedListBase, so we can't assume that it
            // checks for isRowSelectionMode as in ADGBase, otherwise usually
            // we would call the super version directly, and not in an 'else'
            // clause.
            super.moveIndicators(uid, offset, absolute);
        }
    } */
    
    /**
     *  @private
     */
    /* override mx_internal function clearHighlight(item:IListItemRenderer):void
    {
        if (isCellSelectionMode())
        {
            var uid:String = itemToUID(item.data);
            var c:AdvancedDataGridColumn = columnMap[item.name];
            if (c)
            {
                var columnIndex:int = c.colNum;

                drawCellItem(item,
                             cellSelectionData[uid]
                             && cellSelectionData[uid][columnIndex],
                             false,
                             caretUID == uid
                             && caretColumnIndex == columnIndex);
            }
        }

        super.clearHighlight(item);
    } */
    
    /**
     * @private
     */
    /* override protected function selectData(uid:String, data:Object,
                            index:int, selectedBookmark:CursorBookmark):void
    {
        if (isCellSelectionMode())
        {
            var columnIndex:int = selectedColumnIndex;
            if (!cellSelectionData[uid] || !cellSelectionData[uid][columnIndex])
            {
                if (cellSelectionIndicators[uid] && cellSelectionIndicators[uid][columnIndex])
                {
                    selectCellItem(cellSelectionData[uid][columnIndex], false, false);
                }
                else
                {
                    clearSelectedCells();
                    addCellSelectionData(uid, columnIndex,
                             new AdvancedDataGridBaseSelectionData(data,
                                                       index, columnIndex, false) );
                    selectedColumnIndex = caretColumnIndex = anchorColumnIndex = columnIndex;
                    _selectedIndex      = caretIndex       = anchorIndex       = index;
                    caretBookmark       = anchorBookmark   = selectedBookmark;
                }
            }
        }
        else
        {
            super.selectData(uid, data, index, selectedBookmark);
        }
    } */

    /**
     * @private
     * Clear all the selected data.
     */
    /* override protected function clearAllSelection():void
    {
        if (isCellSelectionMode())
        {
            clearSelectedCells();
            clearCellIndicators();
        }

        super.clearAllSelection();
    } */
    
    /**
     *  @private
     */
    /* override protected function itemRendererToIndices(item:IListItemRenderer):Point
    {
        // We do not support this method for headers as headerItems are separate from the
        // listItems. On the other hand, DataGrid supports this fine since headers are
        // listItems[0].
        if (isHeaderItemRenderer(item))
            return null;

        var pt:Point = super.itemRendererToIndices(item);

        // When optimumColumns is displayableColumns, then pt.x already points
        // to the correct column number, so we don't need to add
        // horizontalScrollPosition, so undo what the 'super' version does.
        if (pt && getOptimumColumns() != visibleColumns && pt.x >= lockedColumnCount)
            pt.x -= horizontalScrollPosition;
        return pt;
    } */

    /**
     *  @private
     */
    /* override protected function getOptimumColumns():Array
    {
        if (rendererProviders.length > 0 && horizontalScrollPolicy != ScrollPolicy.OFF || columnGrouping)
            return displayableColumns;

        return super.getOptimumColumns();
    } */
    
    /**
     *  @private
     */
    /* override protected function getRowHeight(itemData:Object = null):Number
    {
        if (groupRowHeight > 0 && dataProvider is IHierarchicalCollectionView && _rootModel.hasChildren(itemData))
            return groupRowHeight;
        else
            return super.getRowHeight();
    } */
    
    /**
     *  @private
     */
    /* override mx_internal function getMeasuringRenderer(c:AdvancedDataGridColumn, forHeader:Boolean, data:Object):IListItemRenderer
    {
        if (!forHeader)
        {
            var adgDescription:AdvancedDataGridRendererDescription;
    
            if (rendererProviders.length != 0)
            {
                adgDescription = getRendererDescription(data,c,false);
    
                if (adgDescription && adgDescription.renderer)
                {
                    var factory:IFactory = adgDescription.renderer;
                    var item:IListItemRenderer = measuringObjects[factory];

                    if (!item)
                    {
                        item = adgDescription.renderer.newInstance();
                        item.visible = false;
                        item.styleName = c;
                        listContent.addChild(DisplayObject(item));
                        measuringObjects[factory] = item;
                    }
    
                    return item;
                }
            }
        }

        return super.getMeasuringRenderer(c, forHeader, data);
    } */

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Returns <code>true</code> if the specified item is a branch item. The AdvancedDataGrid 
     *  control delegates to the IDataDescriptor to determine if an item is a branch.
     *  @param item Item to inspect.
     *  @return True if a branch, false if not.
     *
     */
    /* protected function isBranch(item:Object):Boolean
    {
        if (_rootModel && item != null)
            return _rootModel.canHaveChildren(item);
        return false;
    } */

    /**
     *  @private
     *  wraps calls to the descriptor 
     *  mx_internal for automation delegate access
     */
    /* mx_internal function getChildren(item:Object, view:Object):ICollectionView
    {
        //get the collection of children
        var children:ICollectionView = IHierarchicalCollectionView(collection).getChildren(item);
        return children;
    } */

    /**
     *  Determines the number of parents from root to the specified item.
     *  Method starts with the Cursor.current item and will seek forward
     *  to a specific offset, returning the cursor to its original position.
     *
     *  @private
     */
    /* mx_internal function getItemDepth(item:Object, offset:int):int
    {
        //first test for a match (most cases)
        if (!collection)
            return 0;

        if (!iterator)
            iterator = collection.createCursor();

        return getDepth(item);
    } */

    /**
     *  @private
     *  Utility method to get the depth of the item.
     */
    public function getDepth(item:Object):int  //private
    {
        // if data is hierarchical, calculate its depth
        if (_rootModel is IHierarchicalData && collection is IHierarchicalCollectionView)
            return IHierarchicalCollectionView(dataProvider).getNodeDepth(item);

        return -1;
    }

    /**
     *  @private
     *  Utility method to see if item has children.
     */
    public function hasChildren(item:Object):Boolean  //private
    {
        if (!_rootModel) return false;
        
        return _rootModel.hasChildren(item);
    }
    
    /**
     *  Sets the associated icon in the navigation tree for the item.  
     *  Calling this method overrides the
     *  <code>iconField</code> and <code>iconFunction</code> properties for
     *  this item if it is a leaf item. Branch items don't use the
     *  <code>iconField</code> and <code>iconFunction</code> properties.
     *  They use the <code>folderOpenIcon</code> and <code>folderClosedIcon</code> properties.
     *
     *  @param item An Object defining the item in the navigation tree. 
     *  This Object contains the data provider element for the item. 
     * 
     *  @param iconID The closed (or leaf) icon.
     * 
     *  @param iconID2 The open icon.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function setItemIcon(item:Object, iconID:Class, iconID2:Class):void
    {
        if (!itemIcons)
            itemIcons = {};

        if (!iconID2)
            iconID2 = iconID;

        itemIcons[itemToUID(item)] = { iconID: iconID, iconID2: iconID2 };

        itemsSizeChanged = true;
        invalidateDisplayList();
    } */

    /**
     *  @private
     *  Gets the number of visible items from a starting item.
     */
    /* private function getVisibleChildrenCount(item:Object):int
    {
        var count:int = 0;

        if (item == null)
            return count;

        var uid:String = itemToUID(item);
        var children:Object;
        if (IHierarchicalCollectionView(collection).openNodes[uid] && 
            _rootModel.canHaveChildren(item) &&
            _rootModel.hasChildren(item))
        {
            children = getChildren(item, iterator.view);
        }
        if (children != null)
        {
            var n:int = children.length;
            for (var i:int = 0; i < n; i++)
            {
                count++;

                uid = itemToUID(children[i]);
                if (IHierarchicalCollectionView(collection).openNodes[uid])
                    count += getVisibleChildrenCount(children[i]);
            }
        }
        return count;
    } */

    /**
     *  Returns <code>true</code> if the specified branch node is open.
     *
     *  @param item Branch node to inspect.
     *  This Object contains the data provider element for the branch node. 
     *
     *  @return <code>true</code> if open, and <code>false</code> if not.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function isItemOpen(item:Object):Boolean
    {
        if (!(collection is IHierarchicalCollectionView)) return false;
        
        var uid:String = itemToUID(item);
        return IHierarchicalCollectionView(collection).openNodes[uid] != null;
    }

    /**
     *  Open a node
     *
     *  @param item Branch node to open.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function openNode(item:Object):void
    {
        IHierarchicalCollectionView(collection).openNode(item);
        // sent from strand to notify DataGridView    
        var event:CollectionEvent = new CollectionEvent(
            CollectionEvent.COLLECTION_CHANGE,
            false, 
            true,
            CollectionEventKind.REFRESH);
        dispatchEvent(event);
    }

    /**
     *  Open a node
     *
     *  @param item Branch node to open.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function closeNode(item:Object):void
    {
        IHierarchicalCollectionView(collection).closeNode(item);
        // sent from strand to notify DataGridView    
        var event:CollectionEvent = new CollectionEvent(
            CollectionEvent.COLLECTION_CHANGE,
            false, 
            true,
            CollectionEventKind.REFRESH);
        dispatchEvent(event);
    }
    
    /**
     *  @private
     */
    /* private function makeMask():DisplayObject
    {
        var tmpMask:Shape = new FlexShape();
        tmpMask.name = "mask";

        var g:Graphics = tmpMask.graphics;
        g.beginFill(0xFFFFFF);
        g.moveTo(0,0);
        g.lineTo(0,10);
        g.lineTo(10,10);
        g.lineTo(10,0);
        g.lineTo(0,0);
        g.endFill();

        listContent.addChild(tmpMask);
        return tmpMask;
    } */

    /**
     *  Opens or closes a branch node of the navigation tree.
     *  When a branch item opens, it restores the open and closed states
     *  of its child branches if they were already opened.
     * 
     *  <p>If you set the <code>dataProvider</code> property and then immediately call 
     *  the <code>expandItem()</code> method, you may not see the correct behavior. 
     *  You should either wait for the component to validate
     *  or call <code>validateNow()</code>.</p>
     *
     *  @param item An Object defining the branch node. This Object contains the 
     *  data provider element for the branch node. 
     *
     *  @param open Specify <code>true</code> to open the branch node, 
     *  and <code>false</code> to close it.
     *
     *  @param animate Specify <code>true</code> to animate the transition. (Note:
     *  If a branch has over 20 children, to improve performance 
     *  it does not animate the first time it opens.)
     *
     *  @param dispatchEvent Specifies whether the control dispatches an <code>open</code> event
     *  after the open animation is complete (<code>true</code>), or not (<code>false</code>).
     *
     *  @param cause The event, if any, that initiated the item action.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function expandItem(item:Object, open:Boolean,
                               animate:Boolean = false,
                               dispatchEvent:Boolean = false,    
                               cause:Event = null):void
    {
        //if the iterator is null, that indicates we have not been 
        //validated yet, so we will not continue. 
        if (iterator == null)
            return;

        if (cause) 
            lastUserInteraction = cause;

        expandedItem = item;

        listContent.allowItemSizeChangeNotification = false;
        listSubContent.allowItemSizeChangeNotification = false;

        var i:int;
        var n:int;
        var bSelected:Boolean = false;
        var bHighlight:Boolean = false;
        var bCaret:Boolean = false;
        var newRowIndex:int;
        var rowData:BaseListData;

        var tmpMask:DisplayObject;

        var uid:String = itemToUID(item);
        // if this can't be opened, or shouldn't be, don't!
        if (!isBranch(item) || (isItemOpen(item)==open) || isOpening)
            return;

        if (itemEditorInstance)
            endEdit(ListEventReason.OTHER);

        //we'll use the last recorded length not necessarily the current one
        oldLength = collectionLength;

        var bookmark:CursorBookmark = iterator.bookmark;

        // sent to update the length in the collection     
        var event:CollectionEvent = new CollectionEvent(
            CollectionEvent.COLLECTION_CHANGE,
            false, 
            true,
            CollectionEventKind.mx_internal::EXPAND);
        event.items = [item];

        // update the list of openNodes
        if (open)
        {
            IHierarchicalCollectionView(collection).openNode(item);
            rowsTweened = Math.abs(oldLength - collection.length);
        }
        else
        {
            IHierarchicalCollectionView(collection).closeNode(item);
            //how many rows to move? 
            rowsTweened = Math.abs(oldLength - collection.length);  
        }

        // will it affect the displayList?
        if (isItemVisible(item))
        {
            // is the item on screen?
            if (visibleData[uid])
            {
                //find the rowindex of the row after the open thats opening/closing
                n = listItems.length;
                for (rowIndex = 0; rowIndex < n; rowIndex++)
                {
                    if (rowInfo[rowIndex].uid == uid)
                    {
                        rowIndex++;
                        // rowIndex is set to the row after the one opening/closing
                        // because that is the first row to change
                        break;
                    }
                }
            }
        }
        //if we're opening or closing a node that is not visible,
        //we still need to dispatch the correct collectionChange events
        //so that scroll position and selection properties update correctly.
        else
        {
            var eventArr:Array = open ? 
                buildUpCollectionEvents(true) : buildUpCollectionEvents(false);
            n = eventArr.length;
            for (i = 0; i < n; i++)
            {
                collection.dispatchEvent(eventArr[i]);
            }
            
            // This item is not visible but we need to dispatch the appropiate event
            if (dispatchEvent)
            {
                dispatchAdvancedDataGridEvent(open ? AdvancedDataGridEvent.ITEM_OPEN : AdvancedDataGridEvent.ITEM_CLOSE,
                                              item,
                                              visibleData[itemToUID(item)],
                                              lastUserInteraction);
                lastUserInteraction = null;
            }
            
            return;
        }

        var rC:int = listItems.length;
        var tmpRowInfo:Object;
        var col:int = treeColumnIndex;
        // we will cap this with as many rows as can be displayed later
        var rowsToMove:int = rowsTweened;
        var dur:Number = getStyle("openDuration");
        if (animate && rowIndex < rC && rowsToMove > 0 && rowsToMove < 20 && dur!=0)
        {
            // Kill any previous animation. tween is undefined if there is no Tween underway.
            if (tween)
                tween.endTween();


            var renderer:IListItemRenderer = listItems[rowIndex - 1][col];
            if (renderer is IDropInListItemRenderer)
            {
                // this is done to refresh the items with their disclosure/folder icons state updated with the new one
                // If this is removed then the disclosure/folder icons will change their state after the
                // tween is over.
                var di:IDropInListItemRenderer = IDropInListItemRenderer(renderer);
                var advancedDataGridListData:AdvancedDataGridListData = AdvancedDataGridListData(di.listData);
                advancedDataGridListData = AdvancedDataGridListData(
                        makeListData(advancedDataGridListData.item, advancedDataGridListData.uid, 
                        advancedDataGridListData.rowIndex,col,visibleColumns[col]));
                
                di.listData = advancedDataGridListData;
                renderer.data = renderer.data;  // this forces eval of new listData
            }

            // animate the opening
            opening = open;
            isOpening = true;

            maskList = [];
            rowList = [];

            // ignoring padding left
            //var paddingLeft:Number = getStyle("paddingLeft");
            var paddingLeft:Number = 0;
            var xx:Number = paddingLeft;
            var ww:Number = 0;
            var yy:Number = 0;
            var hh:Number = 0;

            // don't tween anymore than the amount of space we have
            var delta:int = rowIndex;
            var maxDist:Number = 0;
            var c:AdvancedDataGridColumn;
            var optimumColumns:Array = getOptimumColumns();
            if (open)
            {
                newRowIndex = rowIndex;
                // don't tween anymore than the amount of space we have
                maxDist = listContent.height - rowInfo[rowIndex].y;
                iterator.seek(CursorBookmark.CURRENT, delta);
                var data:Object;

                // create the rows now so we know how much to move
                for (i = 0; i < rowsToMove && yy < maxDist; i++)
                {
                    data = iterator.current;
                    xx = paddingLeft;

                    currentRowNum = rowIndex + i;
                    hh = 0;
                    currentColNum = 0;
                    uid = itemToUID(data);

                    // create renderers
                    setupRenderer(data,uid,true);

                    bSelected = (selectedData[uid] != null)
                                || (cellSelectionData[uid] &&
                                cellSelectionData[uid][currentColNum]);
                    bHighlight = highlightUID == uid;
                    bCaret = caretUID == uid;

                    // layout renderers created above
                    currentItemTop = yy;
                    hh = layoutRow(true,xx,hh);

                    tmpRowInfo = new ListRowInfo(yy, hh, uid, data);
                    yy += hh;
                    rowInfo.splice(rowIndex + i, 0, tmpRowInfo);

                    iterator.moveNext();
                }
                rowsTweened = i;
                // position the new rows;
                var referenceRowInfo:ListRowInfo = rowInfo[rowIndex + rowsTweened];
                for (i = 0; i < rowsTweened; i++)
                {
                    xx = paddingLeft;
                    rowInfo[rowIndex + i].y -= yy - referenceRowInfo.y;
                    for (col = 0; col < optimumColumns.length; ++col)
                    {
                        renderer = listItems[rowIndex + i][col];
                        renderer.move(renderer.x, renderer.y - (yy - referenceRowInfo.y));
                        tmpMask = makeMask();
                        if (col < lockedColumnCount)
                            tmpMask.x = xx;
                        else
                            tmpMask.x = getAdjustedXPos(xx);
                        tmpMask.y = referenceRowInfo.y;
                        tmpMask.width = renderer.width;
                        tmpMask.height = yy;
                        listItems[rowIndex + i][col].mask = tmpMask;
                        xx += optimumColumns[col].width;
                    }
                }
            }
            else // closing up rows
            {
                var more:Boolean = true;
                var valid:Boolean = true;
                var startY:Number = yy = rowInfo[listItems.length - 1].y + rowInfo[listItems.length - 1].height;

                // figure out how much space was consumed by the rows that are going away
                for (i = rowIndex; i < rowIndex + rowsToMove && i < rC; i++)
                {
                    maxDist += rowInfo[i].height;
                    xx = paddingLeft;
                    var tempArray:Array = []; 
                    for (col = 0; col < optimumColumns.length; ++col)
                    {
                        // retain a reference to the rows going away
                        tempArray.push({item: listItems[i][col]});
                        tmpMask = makeMask();
                        if (col < lockedColumnCount)
                            tmpMask.x = xx;
                        else
                            tmpMask.x = getAdjustedXPos(xx);
                        tmpMask.y = listItems[rowIndex][col].y;
                        // changed rowIndex to i because we want to create the mask for the entire renderer's width
                        //tmpMask.width = listItems[rowIndex][col].width;
                        tmpMask.width = listItems[i][col].width;
                        tmpMask.height = maxDist;
                        listItems[i][col].mask = tmpMask;
                        xx += optimumColumns[col].width;
                    }
                    if (tempArray.length != 0)
                        rowList.push(tempArray);
                }
                rowsToMove = i - rowIndex;
                // remove the rows going away
                rowInfo.splice(rowIndex, rowsToMove);
                listItems.splice(rowIndex, rowsToMove);

                iterator.seek(CursorBookmark.CURRENT, listItems.length);
                more = (iterator != null && !iterator.afterLast && iteratorValid);

                maxDist += yy;
                // create the rows now so we know how much to move
                for (i = 0; i < rowsToMove && yy < maxDist; i++)
                {
                    //reset item specific values
                    uid = null;
                    data = null;
                    renderer = null;

                    valid = more;
                    data = more ? iterator.current : null;

                    xx = paddingLeft;

                    if(valid)
                    {
                        currentRowNum = rC - rowsToMove + i;
                        currentColNum = 0;
                        uid = itemToUID(data);
                        setupRenderer(data,uid,true);

                        bSelected = selectedData[uid] != null;
                        bHighlight = highlightUID == uid;
                        bCaret = caretUID == uid;

                        currentItemTop = yy;
                        hh = layoutRow(true,xx,hh);
                    }
                    else
                    {
                        // if we've run out of data, we dont make renderers
                        // and we inherit the previous row's height or rowHeight
                        // if it is the first row.
                        // EXCEPT when variable row height is on since the row 
                        // above us might be bigger then we are.  So we'll get
                        // this row out of the rowList and check it. 

                        /* if (!variableRowHeight)
                           {
                           hh = rowIndex + i > 0 ? rowInfo[rowIndex + i - 1].height : rowHeight;
                           }
                           else 
                           {
                           if (rowList[i]) 
                           {
                           hh = Math.ceil(rowList[i].item.getExplicitOrMeasuredHeight() +
                           cachedPaddingTop + cachedPaddingBottom);
                           }
                           else 
                           {
                           //default
                           hh = rowHeight;
                           }
                           } *//*
                        hh = rowHeight;
                    }
                    tmpRowInfo = new ListRowInfo(yy, hh, uid, data);
                    rowInfo.push(tmpRowInfo);
                    yy += hh;

                    if (more)
                        more = iterator.moveNext();
                }

                //make indicator masks for rows
                var maskY:Number = rowList[0][0].item.y - getStyle("paddingTop");
                var maskX:Number = rowList[0][0].item.x - getStyle("paddingLeft");
                for (i = 0; i < rowList.length; i++)
                {
                    var lastColumn:int = rowList[i].length -1;
                    var indicator:Object = selectionIndicators[itemToUID(rowList[i][lastColumn].item.data)];
                    if (indicator)
                    {
                        tmpMask = makeMask();
                        tmpMask.x = maskX;
                        tmpMask.y = maskY; 
                        tmpMask.width = rowList[i][lastColumn].item.x +
                            rowList[i][lastColumn].item.width + 
                            getStyle("paddingLeft") + 
                            getStyle("paddingRight");  
                        tmpMask.height = rowList[i][lastColumn].item.y + 
                            rowList[i][lastColumn].item.height +
                            getStyle("paddingTop") + 
                            getStyle("paddingBottom") - 
                            maskY;
                        selectionIndicators[itemToUID(rowList[i][lastColumn].item.data)].mask = tmpMask;
                    }
                }

                //make indicator masks for cells
                var cellMaskY:Number = rowList[0][0].item.y - getStyle("paddingTop");
                var cellMaskX:Number = rowList[0][0].item.x - getStyle("paddingLeft");
                for (var cellRow:int = 0; cellRow < rowList.length; cellRow++)
                    for (var cellColumn:int = 0; cellColumn < rowList[cellRow].length; cellColumn++)
                    {
                        var cellLastColumn:int = rowList[cellRow].length -1;
                        var cellUID:String = itemToUID(rowList[cellRow][cellColumn].item.data);

                        if (cellUID in cellSelectionIndicators)
                        {
                            var cellIndicator:Object = cellSelectionIndicators[cellUID]
                                                                              [cellColumn];
                            if (cellIndicator)
                            {
                                tmpMask = makeMask();
                                tmpMask.x = maskX;
                                tmpMask.y = maskY;
                                tmpMask.width = rowList[cellRow][cellLastColumn].item.x +
                                    rowList[cellRow][cellLastColumn].item.width +
                                    getStyle("paddingLeft") +
                                    getStyle("paddingRight");
                                tmpMask.height = rowList[cellRow][cellLastColumn].item.y +
                                    rowList[cellRow][cellLastColumn].item.height +
                                    getStyle("paddingTop") +
                                    getStyle("paddingBottom") -
                                    maskY;
                                cellIndicator.mask = tmpMask;
                            }
                        }
                    }
            }
            // restore the iterator
            iterator.seek(bookmark, 0);

            rC = rowList.length;
            for (i = 0; i < rC; i++)
            {
                for (col = 0; col < rowList[i].length; col++)
                {
                    rowList[i][col].itemOldY = rowList[i][col].item.y;
                }
            }
            rC = listItems.length;
            for (i = rowIndex; i < rC; i++)
            {
                if (listItems[i].length)
                {
                    rowInfo[i].itemOldY = listItems[i][0].y;
                }
                rowInfo[i].oldY = rowInfo[i].y;
            }
            // slow down the tween if there's lots of rows to tween
            dur = dur * Math.max(rowsToMove / 5, 1);

            if (dispatchEvent)
                eventAfterTween = item;

            tween = new Tween(this, 0, (open) ? yy : startY - yy, dur, 5);
            var oE:Function = getStyle("openEasingFunction") as Function;
            if (oE != null)
                tween.easingFunction = oE;

            // Block all layout, responses from web service, and other background
            // processing until the tween finishes executing.
            UIComponent.suspendBackgroundProcessing();
            // force drawing in case there's new rows
            UIComponentGlobals.layoutManager.validateNow();
        }
        else
        {
            // not to be animated
            if (dispatchEvent)
            {
                // in case when eventItemRenderer is null,
                // instead of taking item renderer from visibleData, we should take it from listItems for
                // the correct value.
                var itemRenderer:IListItemRenderer = eventItemRenderer ? eventItemRenderer : visibleData[itemToUID(item)];
                dispatchAdvancedDataGridEvent(open ? AdvancedDataGridEvent.ITEM_OPEN : AdvancedDataGridEvent.ITEM_CLOSE,
                                              item,
                                              itemRenderer,
                                              lastUserInteraction);
                lastUserInteraction = null;
                eventItemRenderer = null;
            }
            itemsSizeChanged = true;
            invalidateDisplayList();
        }

        // If we're wordwrapping, no need to adjust maxHorizontalScrollPosition.
        // Also check if _userMaxHorizontalScrollPosition is greater than 0.
        if (!wordWrap && initialized)
        {
            super.maxHorizontalScrollPosition =
                _userMaxHorizontalScrollPosition > 0 ?
                _userMaxHorizontalScrollPosition + getIndent() :
                super.maxHorizontalScrollPosition;
        }
        //restore ItemSizeChangeNotification flag
        listContent.allowItemSizeChangeNotification = variableRowHeight;
        listSubContent.allowItemSizeChangeNotification = variableRowHeight;
    } */

    /**
     *  @private
     */
    /* mx_internal function onTweenUpdate(value:Object):void
    {
        var renderer:IFlexDisplayObject;
        var n:int;
        var m:int;
        var i:int;
        var j:int;
        var deltaY:Number;
        var lastY:Number;
        var columnIndexString:String;
        var cellSelectionUID:String;

        n = listItems.length;
        var s:Sprite;
        for (i = rowIndex; i < n; i++)
        {
            //move items that are staying
            if (listItems[i].length)
            {
                m = listItems[i].length;
                for (j = 0; j < m; ++j)
                {
                    renderer = IFlexDisplayObject(listItems[i][j]);
                    lastY = renderer.y;
                    renderer.move(renderer.x, rowInfo[i].itemOldY + value);
                    deltaY = renderer.y - lastY;
                }
            }
            //move selection graphics of the items that are staying visible
            rowInfo[i].y += deltaY;

            s = selectionIndicators[rowInfo[i].uid];
            if (s)
                s.y += deltaY;

            // Cell movement
            if (isCellSelectionMode())
            {
                cellSelectionUID = rowInfo[i].uid;
                if (cellSelectionIndicators[cellSelectionUID])
                {
                    for (columnIndexString in cellSelectionIndicators[cellSelectionUID])
                    {
                        cellSelectionIndicators[cellSelectionUID][columnIndexString].y += deltaY;
                    }
                }
            }
        }

        //move the items that are going away.
        n = rowList.length;
        for (i = 0; i < n; i++)
        {
            var doOnce:Boolean = true ;
            m = rowList[i].length;
            for (j = 0; j < m; j++)
            {
                s = null;
                renderer = IFlexDisplayObject(rowList[i][j].item);

                // Row movement
                if (rowMap[renderer.name] != null)
                {
                    s = selectionIndicators[BaseListData(rowMap[renderer.name]).uid];
                }

                lastY = renderer.y;
                renderer.move(renderer.x, rowList[i][j].itemOldY + value);
                deltaY = renderer.y - lastY;

                //move selection graphic for items that are going away
                if (doOnce && s)
                {
                    s.y += deltaY;
                    doOnce = false;
                }
            }

            // Cell movement
            if (isCellSelectionMode())
            {
                cellSelectionUID = BaseListData(rowMap[renderer.name]).uid;
                if (cellSelectionIndicators[cellSelectionUID])
                {
                    for (columnIndexString in cellSelectionIndicators[cellSelectionUID])
                    {
                        cellSelectionIndicators[cellSelectionUID][columnIndexString].y += deltaY;
                    }
                }
            }
        }
    } */

    /**
     *  @private
     */
    /* mx_internal function onTweenEnd(value:Object):void
    {
        UIComponent.resumeBackgroundProcessing();

        onTweenUpdate(value);

        var i:int;
        var j:int;
        var n:int;
        var m:int;
        var renderer:*;
        var dilir:IDropInListItemRenderer;
        var rC:int = listItems.length;
        var itemUID:*;
        var indicator:Object;
        var cellColumnString:String;
        isOpening = false;

        //dispatch collectionChange ADD or REMOVE events that correlate 
        //to the nodes that were expanded or collapsed
        if (collection)
        {
            var eventArr:Array = opening ? 
                buildUpCollectionEvents(true) : buildUpCollectionEvents(false);
            n = eventArr.length;
            for (i = 0; i < n; i++)
            {
                collection.dispatchEvent(eventArr[i]);
            }
        }

        if (opening)
        {
            var firstDeletedRow:int = -1;
            for (i = rowIndex; i < rC; i++)
            {
                if (listItems[i].length)
                {
                    for (j =0; j < listItems[i].length; ++j)
                    {
                        renderer = listItems[i][j];
                        var mask:DisplayObject = renderer.mask;
                        if (mask)
                        {
                            listContent.removeChild(mask);
                            renderer.mask = null;
                        }
                        rowMap[renderer.name].rowIndex = i;
                        if (renderer is IDropInListItemRenderer)
                        {
                            dilir = IDropInListItemRenderer(renderer);
                            if (dilir.listData)
                            {
                                dilir.listData.rowIndex = i;
                                dilir.listData = dilir.listData; // call the setter
                            }
                        }
                        if (renderer.y > listContent.height)
                        {
                            addToFreeItemRenderers(renderer);
                            itemUID = itemToUID(renderer.data);

                            // row mask
                            if (selectionIndicators[itemUID])
                            {
                                //remove indicators mask
                                indicator = selectionIndicators[itemUID];
                                if (indicator)
                                {
                                    mask = indicator.mask;
                                    if (mask)
                                    {
                                        listContent.removeChild(mask);
                                        indicator.mask = null;
                                    }
                                }
                                removeIndicators(itemUID);
                            }

                            // cell mask
                            if (isCellSelectionMode())
                            {
                                if (cellSelectionIndicators[itemUID])
                                {
                                    for (cellColumnString in cellSelectionIndicators[itemUID])
                                    {
                                        //remove indicators mask
                                        indicator =
                                            cellSelectionIndicators[itemUID][cellColumnString];
                                        if (indicator)
                                        {
                                            mask = indicator.mask;
                                            if (mask)
                                            {
                                                listContent.removeChild(mask);
                                                indicator.mask = null;
                                            }
                                        }
                                    }
                                    removeCellIndicators(itemUID, int(cellColumnString));
                                }
                            }

                            delete rowMap[renderer.name];
                            if (firstDeletedRow < 0)
                                firstDeletedRow = i;
                        }
                    }
                }
                else
                {
                    if (rowInfo[i].y >= listContent.height)
                    {
                        if (firstDeletedRow < 0)
                            firstDeletedRow = i;
                    }
                }
            }
            if (firstDeletedRow >= 0)
            {
                rowInfo.splice(firstDeletedRow);
                listItems.splice(firstDeletedRow);
            }
        }
        else //closing
        {
            n = rowList.length;
            for (i = 0; i < n; i++)
            {
                m = rowList[i].length;
                for (j = 0; j < m; j++)
                {
                    mask = rowList[i][j].item.mask;
                    if (mask)
                    {
                        listContent.removeChild(mask);
                        rowList[i][j].item.mask = null;
                    }
                    addToFreeItemRenderers(rowList[i][j].item);
                    //kill graphic and graphic mask if necessary
                    itemUID = itemToUID(rowList[i][j].item.data);

                    // row mask
                    if (selectionIndicators[itemUID])
                    {
                        //remove indicators mask
                        indicator = selectionIndicators[itemUID];
                        if (indicator)
                        {
                            mask = indicator.mask;
                            if (mask)
                            {
                                listContent.removeChild(mask);
                                indicator.mask = null;
                            }
                        }
                        removeIndicators(itemUID);
                    }

                    // cell mask
                    if (isCellSelectionMode())
                    {
                        if (cellSelectionIndicators[itemUID])
                        {
                            for (cellColumnString in cellSelectionIndicators[itemUID])
                            {
                                //remove indicators mask
                                indicator = cellSelectionIndicators[itemUID][cellColumnString];
                                if (indicator)
                                {
                                    mask = indicator.mask;
                                    if (mask)
                                    {
                                        listContent.removeChild(mask);
                                        indicator.mask = null;
                                    }
                                }
                                removeCellIndicators(itemUID, int(cellColumnString));
                            }
                        }
                    }

                    delete rowMap[rowList[i][j].item.name];
                }
            }
            for (i = rowIndex; i < rC; i++)
            {
                if (listItems[i].length)
                {
                    m = listItems[i].length;
                    for (j =0; j < m; ++j)
                    {
                        renderer = listItems[i][j];
                        rowMap[renderer.name].rowIndex = i;
                        if (renderer is IDropInListItemRenderer)
                        {
                            dilir = IDropInListItemRenderer(renderer);
                            if (dilir.listData)
                            {
                                dilir.listData.rowIndex = i;
                                dilir.listData = dilir.listData; // call the setter
                            }
                        }
                    }
                }
            }
        }

        //should we dispatch an AdvancedDataGrid event?
        if (eventAfterTween)
        {
            // in case when eventItemRenderer is null,
            // instead of taking item renderer from visibleData, we should take it from listItems for
            // the correct value.
            var itemRenderer:IListItemRenderer = eventItemRenderer ? eventItemRenderer : visibleData[itemToUID(eventAfterTween)];
            dispatchAdvancedDataGridEvent((isItemOpen(eventAfterTween)
                                           ? AdvancedDataGridEvent.ITEM_OPEN
                                           : AdvancedDataGridEvent.ITEM_CLOSE),
                                          eventAfterTween,
                                          itemRenderer,
                                          lastUserInteraction);
            lastUserInteraction = null;
            eventAfterTween = false;
            itemRenderer = null;
        }
        //invalidate
        itemsSizeChanged = true;
        invalidateDisplayList();
        // Get rid of the tween, so this onTweenEnd doesn't get called more than once.
        tween = null;
        // check for scrollbars
        configureScrollBars();  
    } */

    /**
     *  @private
     * 
     *  Helper function that builds up the collectionChange ADD or 
     *  REMOVE events that correlate to the nodes that were expanded 
     *  or collapsed. 
     */
    /* private function buildUpCollectionEvents(open:Boolean):Array
    {
        var ce:CollectionEvent;
        var item:Object;
        var parentArray:Array;
        var rowsAdded:Array = [];
        var rowsRemoved:Array = [];
        var retVal:Array = [];

        var itemIndex:int = getItemIndex(expandedItem);

        if (open)
        {
            var children:ICollectionView = getChildren(expandedItem, iterator.view);
            if (!children)
                return [];
            var cursor:IViewCursor = children.createCursor();
            var push:Boolean = true;
            while (!cursor.afterLast)
            {
                rowsAdded.push(item);
                try
                {
                    cursor.moveNext();
                }
                catch (e:ItemPendingError)
                {
                    // should not come here
                    break;
                }
            }
        }
        else 
        {
            var stack:Array = [];
            var i:int;
            stack = getOpenChildrenStack(expandedItem, stack);
            var n:int = stack.length;
            while (i < n)
            {
                var m:int = selectedItems.length;
                for (var j:int = 0; j < m; j++)
                {
                    if (selectedItems[j] == stack[i])
                    {
                        bSelectedItemRemoved = true;
                    }
                }
                rowsRemoved.push(stack[i]);
                i++;
            }
        }
        if (rowsAdded.length > 0)
        {
            ce = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            ce.kind = CollectionEventKind.ADD;
            ce.location = itemIndex + 1;
            ce.items = rowsAdded;
            retVal.push(ce);
        }
        if (rowsRemoved.length > 0)
        {
            ce = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            ce.kind = CollectionEventKind.REMOVE;
            ce.location = itemIndex;
            ce.items = rowsRemoved;
            retVal.push(ce);
        }
        return retVal;
    } */

    /**
     *  @private
     *  Go through the open items and figure out which is deepest.
     */
    /* private function getIndent():Number
    {
        var depth:Number = 0;
        for (var p:String in IHierarchicalCollectionView(collection).openNodes)
        {
            // add one since its children are actually indented
            depth = Math.max(getItemDepth(IHierarchicalCollectionView(collection).openNodes[p], 0), depth);
        }
        return depth * getStyle("indentation");
    } */

    /**
     *  @private
     */
    /* private function getItemIndex(item:Object):int
    {
        var cursor:IViewCursor = collection.createCursor();
        var i:int = 0;
        do
        {
            if (cursor.current === item)
                break;
            i++;
        }
        while (cursor.moveNext());
        return i;
    } */

    /**
     *  @private
     */
    /* private function getIndexItem(index:int):Object
    {
        var cursor:IViewCursor = collection.createCursor();
        var i:int = index;
        while (cursor.moveNext())
        {
            if (i == 0)
                return cursor.current;
            i--;
        }
        return null;
    } */

    /**
     *  Opens or closes all the nodes of the navigation tree below the specified item.
     * 
     *  <p>If you set the <code>dataProvider</code> property and then immediately call
     *  the <code>expandChildrenOf()</code> method, you may not see the correct behavior. 
     *  You should either wait for the component to validate,
     *  or call the <code>validateNow()</code> method before calling <code>expandChildrenOf()</code>.</p>
     *  
     *  @param item An Object defining the branch node. This Object contains the 
     *  data provider element for the branch node. 
     *
     *  @param open Specify <code>true</code> to open the items, 
     *  and <code>false</code> to close them.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function expandChildrenOf(item:Object, open:Boolean):void
    {
        //if the iterator is null, that indicates we have not been 
        //validated yet, so we will not continue. 
        if (iterator == null)
            return;

        // if it is not a branch item there's nothing to do
        if (isBranch(item))
        {
            dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,
                                          item,   //item
                                          null,   //renderer
                                          null,   //trigger
                                          open,   //opening
                                          false,  //animate
                                          true);  //dispatch

            var i:int = 0;
            var childItems:Object
            if (item != null &&
                _rootModel.canHaveChildren(item) &&
                _rootModel.hasChildren(item))
            {
                childItems = getChildren(item, iterator.view);
            }
            if (childItems)
            {
                var cursor:IViewCursor = childItems.createCursor();
                while (!cursor.afterLast)
                {
                    if (isBranch(cursor.current))
                        expandChildrenOf(cursor.current, open);
                    cursor.moveNext();
                }
            }
        }
    } */

    /**
     *  Returns the parent of a child item. This method returns a value
     *  only if the item was or is currently visible. Top-level items have a 
     *  parent with the value <code>null</code>. 
     * 
     *  @param item An Object defining the child item. This Object contains the 
     *  data provider element for the child. 
     * 
     *  @return The parent of the item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function getParentItem(item:Object):*
    {
        if (item == null)
            return null;
        if (item && collection)
            return IHierarchicalCollectionView(collection).getParentItem(item);
        return null;
    } */

    /**
     *  @private
     *  Returns the stack of parents from a child item. 
     */
    /* private function getParentStack(item:Object):Array
    {
        var stack:Array = [];
        if (item == null)
            return stack;

        var parent:* = getParentItem(item);
        while (parent)
        {
            stack.push(parent);
            parent = getParentItem(parent);
        }
        return stack;       
    } */

    /**
     *  @private
     *  Returns a stack of all open descendants of an item. 
     */
    /* private function getOpenChildrenStack(item:Object, stack:Array):Array
    {
        var curr:Object;
        if (item == null)
            return stack;

        var children:ICollectionView = getChildren(item, iterator.view);
        
        if (!children)
            return [];

        var cursor:IViewCursor = children.createCursor();
        while (!cursor.afterLast)
        {
            curr = cursor.current;
            stack.push(curr);
            if (isBranch(curr) && isItemOpen(curr))
            {
                getOpenChildrenStack(curr, stack);
            }
            try
            {
                cursor.moveNext();
            }
            catch(e:ItemPendingError)
            {
                break;
            }
        }
        return stack;       
    } */

    /**
     *  @private
     *  Finds the index distance between a parent and child
     */
    /* private function getChildIndexInParent(parent:Object, child:Object):int
    {
        var index:int = 0;
        if (!parent)
        {
            var cursor:IViewCursor = ICollectionView(iterator.view).createCursor();
            while (!cursor.afterLast)
            {
                if (child === cursor.current)
                    break;
                index++;
                cursor.moveNext();
            }
        }
        else
        {
            if (parent != null && 
                _rootModel.canHaveChildren(parent) &&
                _rootModel.hasChildren(parent))
            {
                var children:ICollectionView = getChildren(parent, iterator.view);
                if (children.contains(child))
                {
                    var n:int = children.length;
                    for (; index < n; index++)
                    {
                        if (child === children[index])
                            break;
                    }
                }
                else 
                {
                    //throw new Error("Parent item does not contain specified child: " + itemToUID(child));
                }
            }
        }
        return index;
    } */

    /**
     *  @private
     *  Collapses those items in the selected items array that have
     *  parent nodes already selected. 
     */
    /* private function collapseSelectedItems():Array
    {
        var collection:ArrayCollection = new ArrayCollection(selectedItems);
        
        for (var i:int = 0; i < selectedItems.length; i++)
        {
            var item:Object = selectedItems[i];
            var stack:Array = getParentStack(item);
            for (var j:int = 0; j < stack.length; j++)
            {
                if (collection.contains(stack[j]))
                {
                    //item's parent is included in the selected item set
                    var index:int = collection.getItemIndex(item);
                    var removed:Object = collection.removeItemAt(index);
                    break;
                }
            }
        }
        return collection.source;
    } */

    /**
     *  Initializes an AdvancedDataGridListData object that is used by the AdvancedDataGrid item renderer.
     * 
     *  @param item The item to be rendered.
     *  This Object contains the data provider element for the item. 
     * 
     *  @param adgListData The AdvancedDataGridListDataItem to use in rendering the item.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function initListData(item:Object, adgListData:AdvancedDataGridListData):void
    {
        if (item == null)
            return;

        var open:Boolean = isItemOpen(item);
        var branch:Boolean = isBranch(item);
        var uid:String = itemToUID(item);

        // this is hidden by non-branches but kept so we know how wide it is so things align
        if (displayDisclosureIcon)
            adgListData.disclosureIcon = getStyle(open ? "disclosureOpenIcon" :
                                                  "disclosureClosedIcon");
        adgListData.open = open;
        adgListData.hasChildren = _rootModel.hasChildren(item);
        // set the depth as 1 if the item is pending
        if (itemPending)
            adgListData.depth = 1;
        else
            adgListData.depth = getItemDepth(item, adgListData.rowIndex);
        
        adgListData.indent = (adgListData.depth - 1) * getStyle("indentation");
        adgListData.item = item;
        if (groupIconFunction != null && isBranch(item))
        {
            if (groupIconFunction(item, adgListData.depth) != null)
                adgListData.icon = groupIconFunction(item, adgListData.depth);
            else
                adgListData.icon = itemToIcon(item);
        }
        else
            adgListData.icon = itemToIcon(item);
    } */

    /**
     *  @private
     *  Delegates to the Descriptor to add a child to a parent
     */
    /* mx_internal function addChildItem(parent:Object, child:Object, index:Number):Boolean
    {
        return IHierarchicalCollectionView(dataProvider).addChildAt(parent, child, index);
    } */

    /**
     *  @private
     *  Delegates to the Descriptor to remove a child from a parent
     */
    /* mx_internal function removeChildItem(parent:Object, child:Object, index:Number):Boolean
    {
        return IHierarchicalCollectionView(dataProvider).removeChildAt(parent, index);
    } */

    /**
     *  @private
     */
    /* mx_internal function dispatchAdvancedDataGridEvent(type:String,
                                                       item:Object,
                                                       renderer:IListItemRenderer,
                                                       trigger:Event = null,
                                                       opening:Boolean = true, 
                                                       animate:Boolean = true,
                                                       dispatch:Boolean = true):void
    {
        var event:AdvancedDataGridEvent;

        // Create expanding event.
        if (type == AdvancedDataGridEvent.ITEM_OPENING)
        {
            event = new AdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,
                                              false, true);
            event.opening = opening;
            event.animate = animate;
            event.dispatchEvent = dispatch;
        }

        // Create all other events.
        if (!event) 
            event = new AdvancedDataGridEvent(type);

        // Common values.
        event.item = item;
        event.itemRenderer = renderer;
        event.triggerEvent = trigger;

        // Send it off.
        dispatchEvent(event);
    } */

    /**
     *  Generate sample data based on number of columns and their dataFields,
     *  so that the designer can see how the data will look like.
     *  
     *  @private
     */
    /* private function setDesignViewData():void
    {
        designViewDataFlag = true;

        var sampleDataProvider:Array = [];
        // The sample data is going to be just integers in ascending order.
        var counter:int = 1;
        // Number of rows to display.
        const numberOfRows:int = 10;

        if (!_columns || _columns.length == 0)
            return;

        var i:int;
        var sampleDataRow:Object;
        var j:int;
        var m:int;
        var col:AdvancedDataGridColumn;

        if (designViewDataType == designViewDataFlatType)
        {
            for (i = 0; i < numberOfRows; i++)
            {
                sampleDataRow = {};
                
                m = _columns.length;
                for (j = 0; j < m; j++)
                {
                    col = _columns[j];
                    if (col.dataField != null)
                    {
                        sampleDataRow[col.dataField] = counter;
                    }
                    counter++;
                }

                sampleDataProvider.push(sampleDataRow);
            }

            dataProvider = sampleDataProvider;
        }
        else if (designViewDataType == designViewDataTreeType)
        {
            var branchName:String = _columns[0].dataField || "";
            var branchCounter:int = 1;

            for (i = 0; i < numberOfRows; i++)
            {
                var childrenString:String = "children";
                sampleDataRow = {};
                sampleDataRow[childrenString] = [{}];
                sampleDataRow[branchName] = resourceManager.getString("datamanagement", "Branch", [branchCounter]);
                
                m = _columns.length;
                for (j = 0; j < m; j++)
                {
                    col = _columns[j];
                    if (col.dataField != null)
                    {
                        sampleDataRow[childrenString][0][col.dataField] = counter;
                    }
                    counter++;
                }

                sampleDataProvider.push(sampleDataRow);
                branchCounter++;
            }

            dataProvider = new HierarchicalData(sampleDataProvider);
        }
    } */

    /**
     * Set sort in design view to showcase multi column sorting.
     *  
     *  @private
     */
    /* private function setDesignViewSort():void
    {
        if (collection == null)
            return;
        
        var sort:Sort = new Sort();
        sort.fields = [];
        var oddDescending:Boolean = false;
        
        var n:int = _columns.length;
        for (var i:int = 0; i < n; i++)
        {
            sort.fields.push(
                    new SortField(columns[i].dataField,
                                  false,
                                  oddDescending,
                                  false)
                    );

            oddDescending = !oddDescending;
        }

        if (collection)
            collection.sort = sort;
    } */

    /**
     *  @private
     */
    /* public function setDesignView():void
    {
        designViewDataType = dataType;
        designViewDataTypeChanged = true;
        invalidateProperties();
    } */

    /**
     *  Process cells (set in selectedCells) which are not yet displayed
     *  in case we have scrolled to the view where it can be displayed.
     *
     *  @private
     */
    /* protected function processCellsWaitingToBeDisplayed():void
    {
        var pendingCellsDisplayed:Array = [];
        var n:int = pendingCellSelection.length;
        var i:int;
        for (i = 0; i < n; i++)
        {
            var visibleCoords:Object = absoluteToVisibleIndices(
                                            pendingCellSelection[i].rowIndex,
                                            pendingCellSelection[i].columnIndex);
            var visibleRowIndex:int = visibleCoords.rowIndex;
            var visibleColIndex:int = visibleCoords.columnIndex;

            var listItem:IListItemRenderer;
            if (listItems[visibleRowIndex] && listItems[visibleRowIndex][visibleColIndex])
            {
                listItem = listItems[visibleRowIndex][visibleColIndex];
                selectCellItem(listItem, false, true);
                pendingCellsDisplayed.push(i);
            }
        }

        // Make sure we remove in reverse order, from things at the end to
        // the start so that we remove correctly. For example, if we have to
        // remove the first and third entries, then we have to make sure we
        // remove third and then first to maintain correctness.
        pendingCellsDisplayed.sort(Array.NUMERIC | Array.DESCENDING);
        n = pendingCellsDisplayed.length;
        for (i = 0; i < n; i++)
        {
            pendingCellSelection.removeItemAt(pendingCellsDisplayed[i]);
        }

        if (pendingCellSelection.length == 0)
            cellsWaitingToBeDisplayed = false;
    } */

    /**
     *  Expands all the nodes of the navigation tree in the control.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function expandAll():void
    {
        if (dataProvider is IHierarchicalCollectionView && iterator)
        {
            // move to the first item
            iterator.seek(CursorBookmark.FIRST);
            while(!iterator.afterLast)
            {
                var item:Object = iterator.current;
                // open the item if its a branch item and its not already open
                if (isBranch(item) && !isItemOpen(item))
                {
                    IHierarchicalCollectionView(collection).openNode(item); // open node
                    
                    // dispatch ITEM_OPEN event
                    var itemRenderer:IListItemRenderer = visibleData[itemToUID(item)];
                    dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPEN,
                                                  item,
                                                  itemRenderer,
                                                  null);
                }
                iterator.moveNext();
            }
            itemsSizeChanged = true;
            invalidateDisplayList();
            // seek to the correct position
            iterator.seek(CursorBookmark.FIRST, verticalScrollPosition);
        }
    } */

    /**
     *  Collapses all the nodes of the navigation tree.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* public function collapseAll():void
    {
        if (dataProvider is IHierarchicalCollectionView && iterator)
        {
            // clear the selected items
            clearSelected();
            
            //dispatch events
            for each (var item:* in IHierarchicalCollectionView(collection).openNodes)
            {
                dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_CLOSE,
                                              item,
                                              visibleData[itemToUID(item)]);
            }
            
            var oldValue:int = verticalScrollPosition;
            verticalScrollPosition = 0;
            
            IHierarchicalCollectionView(collection).openNodes = {};
            
            // set the verticalScrollPosition to a valid value and seek to that position
            verticalScrollPosition = 
                    oldValue >= collection.length ? collection.length - 1 : oldValue;
                    
            iterator.seek(CursorBookmark.FIRST, verticalScrollPosition);
        }
    } */
    
    /**
     *  @private
     * 
     *  Get the renderer and column span for custom renderer
     *
     */
    /* mx_internal function getRendererDescription(itemData:Object,c:AdvancedDataGridColumn, forDragProxy:Boolean = false):AdvancedDataGridRendererDescription
    {
        var adgDescription:AdvancedDataGridRendererDescription = new AdvancedDataGridRendererDescription();
        var index:int = 0;
        var depth:int = 0;
        if (rendererProviders.length !=0)
        {
            if (forDragProxy)
                index = getItemIndex(itemData);
                
            depth = getItemDepth(itemData,index);
        }
        
        var n:int = rendererProviders.length;
        for (var i:int = 0; i < n; i++)
        {
            IAdvancedDataGridRendererProvider(rendererProviders[i]).describeRendererForItem(itemData,depth,c,adgDescription);
            if (adgDescription.renderer)
                return adgDescription;
        }
        return adgDescription;
    }

    override protected function findHeaderRenderer(pt:Point):IListItemRenderer
    {
        var headerItem:IListItemRenderer;
        var xMatched:Boolean = false;
        var array:Array = visibleHeaderInfos;
        var x:Number;

        while (!xMatched)
        {
            var n:int = array ? array.length : 0;
            for (var i:int = 0; i < n; i++)
            {
                headerItem = array[i]["headerItem"];
				
				if (headerItem == null)
					continue;
				
                x = headerItem.x;

                if (array[i].actualColNum >= lockedColumnCount)
                    x = getAdjustedXPos(headerItem.x);

                if (pt.x >= x && pt.x < (x + headerItem.getExplicitOrMeasuredWidth()))
                {
                    xMatched = true;

                    if (pt.y >headerItem.y - cachedPaddingTop && 
                        pt.y <= headerItem.y + headerItem.height + cachedPaddingBottom)
                        return headerItem;
                    else if (array[i].visibleChildren && array[i].visibleChildren.length > 0)
                        array = array[i].visibleChildren;
                    else
                        return null;
                    break;
                }

            }
			// There is no point of keep looping over if x is not within range
            if (!xMatched)
                return null;
            xMatched = false;
        }
        return null;
    } */
    
    /**
     *  @private
     */
    /* private function getLastColumnResidualWidth():Number
    {
        var n:int = displayableColumns.length-1;
        var displayWidth:int = unscaledWidth - viewMetrics.right - viewMetrics.left;
        var totalWidth:Number = 0;
        var i:int;
        var numLockCols:int = Math.max(0, lockedColumnCount);

        //Find the scrollable width i.e displayWidth - { sum of width of locked columns}
        if (numLockCols > 0 && numLockCols < visibleColumns.length)
        {
            for (i = 0; i < numLockCols; i++)
            {
                displayWidth -= displayableColumns[i].width;
            }
        }

        // Starting from the right most column in the displayableColumns array
        // find out how many columns we will be able to 
        // accumulate and how much width they will take
        // when horizontal scroll bar is at the rightmost end
        if (n>=0)
        {
            totalWidth = (isNaN(displayableColumns[n].explicitWidth) ? displayableColumns[n].preferredWidth : displayableColumns[n].explicitWidth); 
        }

        for (i = n-1; i >= numLockCols; i--)
        {
            if (totalWidth + displayableColumns[i].width <= displayWidth)
                totalWidth += displayableColumns[i].width;
            else
                break;
        }

        // The residual width is the width which should be added to 
        // the last column apriori, so that in future when we have horizontally
        // scrolled to the right most position we don't need to create larger
        // items for that column
        return displayWidth - totalWidth;
    } */

    /**
     *  @private
     */
    /* private function createHeaderItems(subHeaderInfos:Array):Number
    {
        var i:int;
        var c:AdvancedDataGridColumn;
        var rowData:AdvancedDataGridListData;
        var item:IListItemRenderer;
        var childrenWidth:Number;
        var w:Number = 0;

        var n:int = subHeaderInfos.length;
        for (i = 0; i < n; i++)
        {
            if(subHeaderInfos[i].visibleChildren)
                childrenWidth = createHeaderItems(subHeaderInfos[i].visibleChildren);
            
            c = subHeaderInfos[i].column;

            //When we have reached the last column little extra work
            //to see the future i.e when display will be scrolled horizontally
            // at extreme right position
            if (horizontalScrollPolicy != ScrollPolicy.OFF 
               && c == displayableColumns[displayableColumns.length-1])
                lastColumnWidth = (isNaN(c.explicitWidth) ? c.preferredWidth : c.explicitWidth) + getLastColumnResidualWidth();

            item = getHeaderRenderer(c);
            // passing rowNum as -1 for headers
            rowData = AdvancedDataGridListData(makeListData(c, uid, -1, c.colNum, c));
            rowMap[item.name] = rowData;
            if (item is IDropInListItemRenderer)
                IDropInListItemRenderer(item).listData = rowData;
            item.data = c;
            item.styleName = c;
            if (!isMeasuringHeader)
                addRendererToContentArea(item, c);

            headerItemsList.push(item);
            
            subHeaderInfos[i].headerItem = item;
            
            // set prefW so we can compute prefH
            if (subHeaderInfos[i].visibleChildren)
            {
                item.explicitWidth = childrenWidth;
                c.width = childrenWidth;
            }
            else if (!isNaN(lastColumnWidth)&& c == displayableColumns[displayableColumns.length-1])
            {
                item.explicitWidth = lastColumnWidth;
            }
            else
            {
                item.explicitWidth = c.width;
            }

            UIComponentGlobals.layoutManager.validateClient(item, true);
            
            // but size it regardless of what prefW is
            if (!isNaN(lastColumnWidth) && c == displayableColumns[displayableColumns.length-1])
                w += lastColumnWidth;
            else
                w += c.width;
        }
        return w;
    } */

    /**
     *  @private
     */
    /* private function measureHeaderHeights(subHeaderInfos:Array, depth:uint):Number
    {
        var i:int;
        var maxRowHeight:Number=0;
        var padding:int = cachedPaddingTop + cachedPaddingBottom;

        var n:int = subHeaderInfos.length;
        for ( i = 0; i < n; i++)
        {
            var currentGroupHeight:Number = _explicitHeaderHeight ?
                _headerHeight : subHeaderInfos[i].headerItem.getExplicitOrMeasuredHeight()+padding;
            
            if (subHeaderInfos[i].visibleChildren)
                currentGroupHeight += measureHeaderHeights(subHeaderInfos[i].visibleChildren, depth+1);
            maxRowHeight = Math.max(maxRowHeight, currentGroupHeight);
        }
        if (!headerRowInfo[depth])
            headerRowInfo[depth] = new ListRowInfo(0,0, uid);
        
        headerRowInfo[depth].height = Math.max(headerRowInfo[depth].height, maxRowHeight);
        return headerRowInfo[depth].height;
    } */

    /**
     *  @private
     */
    /* private function layoutHeaders(subHeaderInfos:Array, rowX:Number, rowY:Number, depth:int):void
    {
        var i:int;
        var w:Number = rowX;
        var padding:int = cachedPaddingTop + cachedPaddingBottom;
        headerRowInfo[depth].y = rowY;

        var n:int = subHeaderInfos.length;
        for (i = 0; i < n; i++)
        {
            subHeaderInfos[i].headerItem.move(w, rowY+cachedPaddingTop);

            var currentItemHeight:Number = subHeaderInfos[i].headerItem.height;
            
            if (subHeaderInfos[i].visibleChildren)
                layoutHeaders(subHeaderInfos[i].visibleChildren, w, rowY + currentItemHeight + padding, depth+1);
            
            w += subHeaderInfos[i].headerItem.getExplicitOrMeasuredWidth();
        }
    } */
    
    /**
     *  Applies styles from the AdvancedDatagrid control to an item renderer.
     *  The item renderer should implement the IStyleClient and IDataRenderer interfaces,
     *  and be a subclass of the DisplayObject class.
     *
     *  @param givenItemRenderer The item renderer.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function applyUserStylesForItemRenderer(givenItemRenderer:IListItemRenderer):void
    {
        if (!givenItemRenderer)
            return;

        if (!
            (
                // It should support all the following interfaces/inheritances
                givenItemRenderer is IStyleClient
                && givenItemRenderer is IDataRenderer
                && givenItemRenderer is DisplayObject
                )
            )
        {
            return;
        }

        var itemRenderer:IStyleClient = givenItemRenderer as IStyleClient;

        var column:AdvancedDataGridColumn = columnMap[DisplayObject(itemRenderer).name];

        // 0. Make sure we have a dictionary
        if (!oldStyles)
        {
            oldStyles = new Dictionary(true); // use weakKeys
        }

        // 1. Reset to the default i.e. "old" styles
        var styleName:String;
        if (oldStyles[itemRenderer])
        {
            for (styleName in oldStyles[itemRenderer])
            {
                itemRenderer.setStyle(styleName, oldStyles[itemRenderer][styleName]);
            }
            delete oldStyles[itemRenderer];
        }

        // 2. Call the grid's styleFunction
        var newStyles:Object;
        if (styleFunction != null)
        {
            newStyles = styleFunction(IDataRenderer(itemRenderer).data, column);
            if (newStyles)
            {
                for (styleName in newStyles)
                {
                    if (!oldStyles[itemRenderer])
                    {
                        oldStyles[itemRenderer] = {};
                    }

                    oldStyles[itemRenderer][styleName] = itemRenderer.getStyle(styleName);
                    itemRenderer.setStyle(styleName, newStyles[styleName]);
                }
            }
        }

        // 3. Call the column's styleFunction
        if (column && column.styleFunction != null)
        {
            newStyles = column.styleFunction(IDataRenderer(itemRenderer).data, column);
            if (newStyles)
            {
                for (styleName in newStyles)
                {
                    // Don't store the "old" value for this styleName if grid.styleFunction has
                    // already stored it
                    if (!oldStyles[itemRenderer])
                    {
                        oldStyles[itemRenderer] = {};
                    }
                    if (!oldStyles[itemRenderer][styleName])
                    {
                        oldStyles[itemRenderer][styleName] = itemRenderer.getStyle(styleName);
                    }
                    itemRenderer.setStyle(styleName, newStyles[styleName]);
                }
            }
        }
    } */
    
    /**
     *  @private
     */
    /* private function removeOldHeaders():void
    {
        var item:IListItemRenderer;
        if (columnGrouping)
        {
            //In case column grouping was not there previously then there will be items in headerItems
            // We need to remove them
            if (headerItems && headerItems.length)
            {
                while (headerItems.length)
                {
                    var headerRow:Array = headerItems.pop();
                    while (headerRow.length)
                    {
                        item = IListItemRenderer(headerRow.pop());
                        item.parent.removeChild(DisplayObject(item));
                    }
                }
            }
        }
        else
        {
            //In case column grouping was there previously then there will be items in headerItemsList
            // We need to remove them
            if (headerItemsList && headerItemsList.length)
            {
                while (headerItemsList.length)
                {
                    item = headerItemsList.pop();
                    item.parent.removeChild(DisplayObject(item));
                }
            }
            //there may be items in freeItemRenderersTable also. We need to remove them as well
            if (_groupedColumns)
            {
                var n:int = _groupedColumns.length;
                for ( var i:int = 0; i < n; i++)
                {
                    if (_groupedColumns[i] is AdvancedDataGridColumnGroup)
                        columnGroupRendererChanged(AdvancedDataGridColumnGroup(_groupedColumns[i]));
                }
            }
        }
    } */

    /**
     *  @private
     */
    /* private function columnGroupRendererChanged(c:AdvancedDataGridColumnGroup):void
    {
        var n:int = c.children ? c.children.length : 0;
        if (n > 0)
        {
            columnRendererChanged(c);
            for( var i:int = 0; i < n; i++)
            {
                if (c.children[i] is AdvancedDataGridColumnGroup)
                    columnGroupRendererChanged(c.children[i]);
            }
        }
        
    } */
    
    /**
     *  @private
     */
    /* private function addItemsToTarget(event:DragEvent, items:Array):void
    {
        // add items only if the target component is AdvancedDataGrid
        /* if (!(event.relatedObject is AdvancedDataGrid))
            return; *//*
            
        var className:String  = getQualifiedClassName(event.relatedObject);
        var classType:Class = getDefinitionByName(className) as Class; 
        var o:Object = new classType();
        if (!(o is AdvancedDataGrid))
            return; 
            
        //then do the add on the target control
        var targetADG:Object = event.relatedObject;
        if (!targetADG.collection)
        { 
            // Empty tree. Use the first item to create a dataprovider
            var item:Object = items.shift();
            targetADG.dataProvider = new HierarchicalData(item);
            targetADG.validateNow();
        }
        else if (targetADG.collection.length == 0)
        {
            //Empty dataProvider. Add the first item in.  
            var obj:Object = items.shift();
            targetADG.addChildItem(targetADG._dropData.parent, 
                                   obj, targetADG._dropData.index);
        }
    
        var n:int = items.length;
        for (var i:int = n - 1; i >= 0; i--)
        {
            targetADG.addChildItem(targetADG._dropData.parent, 
                                   items[i], 
                                   targetADG._dropData.index);
        }
    } */
    
    /**
     *  @private
     *
     *  validate the groupedColumns and verify that same column object is not
     *  used twice
     */
    /* private function validateGroupedColumns(groupedColumns:Array):Boolean
    {
        var dict:Dictionary = new Dictionary();
        var queue:Array = [];
        var valid:Boolean = true;
        
        var n:int = groupedColumns.length;
        for (var i:int = 0; i < n; i++)
        {
            queue.push(groupedColumns[i]);
        }
        
        while (queue.length > 0 && valid)
        {
            var c:AdvancedDataGridColumn = queue.shift();;
            var uid:String = itemToUID(c);
            if (dict[uid]!=null)
            {
                valid = false;
                throw new Error(resourceManager.getString(
                                    "datamanagement", "repeatColumnsNotAllowed"));
            }
            else
            {
                dict[uid] = c;
                if (c is AdvancedDataGridColumnGroup)
                {
                    var cGroup:AdvancedDataGridColumnGroup = AdvancedDataGridColumnGroup(c);
                    if (cGroup.children)
                    {
                        n = cGroup.children.length;
                        for (i = 0; i < n; i++)
                        {
                            queue.push(cGroup.children[i]);
                        }
                    }  
                }
            }
        }

        return valid;
    } */

    /**
     *  @private
     */
    /* private function getLeafColumns(groupedColumns:Array):Array
    {
        var i:int=0; 
        while (i < groupedColumns.length)
        {
            if (groupedColumns[i] is AdvancedDataGridColumnGroup && groupedColumns[i].children && groupedColumns[i].children.length >0)
            {
                var prefix:Array = groupedColumns.slice(0,i);
                var postfix:Array = groupedColumns.slice(i+1);
                prefix = prefix.concat(getLeafColumns(groupedColumns[i].children));
                groupedColumns = prefix.concat(postfix);
                i = prefix.length;
            }
            else
            {
                i++;
            }
        }
        return groupedColumns;
    } */

    /**
     *  @private
     */
    /* private function initializeGroupedHeaderInfo(groupedColumns:Array, parent:AdvancedDataGridHeaderInfo, depth:int, parentInternalLabelFunction:Function=null):Array
    {
        var headerInfos:Array = [];
        
        var n:int = groupedColumns.length;
        for (var i:int = 0; i < n; i++ )
        {
            var headerInfo:AdvancedDataGridHeaderInfo = new AdvancedDataGridHeaderInfo(groupedColumns[i], 
                                                                                       parent, i, depth) ;
            var uid:String = itemToUID(groupedColumns[i]);
            columnsToInfo[uid] = headerInfo;
            groupedColumns[i].owner = this;
            
            //Parent has a dataField/labelFunction already, child can extract data via this internalLabelFunction only
            headerInfo.internalLabelFunction = parentInternalLabelFunction;
            
            //In case this header was selected through keyboard navigation
            if (selectedHeaderInfo && selectedHeaderInfo.column == groupedColumns[i])
                selectedHeaderInfo = headerInfo;
            
            if (groupedColumns[i] is AdvancedDataGridColumnGroup && groupedColumns[i].children && groupedColumns[i].children.length > 0)
            {
                //If this column has a dataField/labelFunction, children columns will get data through an internalLabelFunction
                if (groupedColumns[i].dataField || groupedColumns[i].labelFunction || parentInternalLabelFunction != null)
                {
                    var childInternalLabelFunction:Function;
                    
                    if (parentInternalLabelFunction == null)
                        childInternalLabelFunction = (function(data:Object, c:AdvancedDataGridColumn):*
                        { 
                            var parentInfo:AdvancedDataGridHeaderInfo  = getHeaderInfo(c).parent;
                            var parentColumn:AdvancedDataGridColumnGroup = parentInfo.column as AdvancedDataGridColumnGroup;
                            
                            return parentColumn.itemToData(data);
                        });
                    else
                        childInternalLabelFunction = (
                            function(data:Object, c:AdvancedDataGridColumn):*
                        { 
                            var parentInfo:AdvancedDataGridHeaderInfo  = getHeaderInfo(c).parent;
                            var parentColumn:AdvancedDataGridColumnGroup = parentInfo.column as AdvancedDataGridColumnGroup;
                            
                            var dataFromParent:* = parentInfo.internalLabelFunction(data, parentInfo.column);
                            
                            return parentColumn.itemToData(dataFromParent);
                        });
                }
                headerInfo.children = initializeGroupedHeaderInfo(groupedColumns[i].children, headerInfo, depth+1, childInternalLabelFunction);
            }
            
            headerInfos.push(headerInfo);
        }
        return headerInfos;
    } */
    
    /**
     *  @private
     */
    /* protected function updateVisibleHeaderInfos(headerInfos:Array = null, parentVisible:Boolean = true, actualColNum:int = 0):Object
    {
        var n:int = headerInfos ? headerInfos.length : 0;
        var i:int;
        var k:int = 0;
        var visibleHeaderInfos:Array;
        var totalColumnSpan:int = 0;

        for (i = 0; i < n; i++)
        {
            var headerInfo:AdvancedDataGridHeaderInfo = headerInfos[i];

            //If parent is not visible we don't want any of the child to be visible
            if(!parentVisible)
                headerInfo.visible = false;
            else
                headerInfo.visible = headerInfo.column.visible;
            
            if(headerInfos[i].visible == false)
            {
                headerInfo.visibleIndex = NaN;
                headerInfo.actualColNum = NaN;
                headerInfo.columnSpan = 0;
                //Need to tell set visible = false to all the children
                updateVisibleHeaderInfos(headerInfo.children, false);
            }
            else
            {
                if (headerInfos[i].children && headerInfos[i].children.length > 0)
                {
                    var children:Object = updateVisibleHeaderInfos(headerInfos[i].children, true, actualColNum);

                    headerInfo.visibleChildren = children.infos;

                    //If there aren't any visibleChildren then we don't want parent either
                    if (headerInfo.visibleChildren == null)
                    {
                        headerInfo.visible = false;
                        headerInfo.actualColNum = NaN;
                        headerInfo.columnSpan = 0;
                    }
                    else
                    {
                        if (!visibleHeaderInfos)
                            visibleHeaderInfos = [];

                        visibleHeaderInfos.push(headerInfo);
                        headerInfo.visibleIndex = k++;
                        headerInfo.actualColNum = actualColNum;
                        headerInfo.columnSpan = children.colSpan;
                    }
                }
                else
                {
                    //No children and..it is visible we want this!!
                    if (!visibleHeaderInfos)
                        visibleHeaderInfos = [];

                    headerInfo.visibleIndex = k++;
                    visibleHeaderInfos.push(headerInfo);
                    headerInfo.actualColNum = actualColNum;
                    headerInfo.columnSpan = 1;
                }
            }

            totalColumnSpan += headerInfo.columnSpan;
            actualColNum += headerInfo.columnSpan;
        }
        return {infos:visibleHeaderInfos, colSpan:totalColumnSpan};
    }
     */
    /**
     *  @private
     */
    /* private function updateHeadersList(headerInfos:Array):void
    {
        var n:int = headerInfos ? headerInfos.length : 0;
        var totalColumnSpan:int = 0;

        for( var i:int = 0; i < n; i++)
        {
            var headerInfo:AdvancedDataGridHeaderInfo = headerInfos[i];
            orderedHeadersList.push(headerInfo);

            if(headerInfo.visibleChildren && headerInfo.visibleChildren.length > 0)
                updateHeadersList(headerInfo.visibleChildren);
        }
    } */

    /**
     *  @private
     */
    /* private function updateDropData(event:DragEvent):void
    {
        var rowCount:int = rowInfo.length;
        var rowNum:int = 0;
        // we need to take care of headerHeight
        var yy:int = rowInfo[rowNum].height + (headerVisible ? headerHeight :0);
        var pt:Point = globalToLocal(new Point(event.stageX, event.stageY));
        while (rowInfo[rowNum] && pt.y >= yy)
        {
            if (rowNum != rowInfo.length-1)
            {
                rowNum++;
                yy += rowInfo[rowNum].height;
            }
            else
            {
                // now we're past all rows.  adding a pixel or two should be enough.
                // at this point yOffset doesn't really matter b/c we're past all elements
                // but might as well try to keep it somewhat correct
                yy += rowInfo[rowNum].height;
                rowNum++;
            }
        }
        var lastRowY:Number = rowNum < rowInfo.length ? rowInfo[rowNum].y : (rowInfo[rowNum-1].y + rowInfo[rowNum-1].height);
        var yOffset:Number = pt.y - lastRowY;
        var rowHeight:Number = rowNum < rowInfo.length ? rowInfo[rowNum].height : rowInfo[rowNum-1].height;  //rowInfo[rowNum].height;
        rowNum += verticalScrollPosition;

        var parent:Object;
        var index:int;
        var emptyFolder:Boolean = false;
        var numItems:int = collection ? collection.length : 0;

        var topItem:Object = (rowNum > _verticalScrollPosition && rowNum <= numItems) ?
                             listItems[rowNum - _verticalScrollPosition - 1][0].data : null;
        var bottomItem:Object = (rowNum - verticalScrollPosition < rowInfo.length && rowNum < numItems) ? 
                                listItems[rowNum - _verticalScrollPosition][0].data  : null;

        var topParent:Object = collection ? getParentItem(topItem) : null;
        var bottomParent:Object = collection ? getParentItem(bottomItem) : null;

        // check their relationship
        if (yOffset > rowHeight * .5 && 
            isItemOpen(bottomItem) &&
            _rootModel.canHaveChildren(bottomItem) &&
            !_rootModel.hasChildren(bottomItem))
        {
            // we'll get here if we're dropping into an empty folder.
            // we have to be in the lower 50% of the row, otherwise
            // we're "between" rows.
            parent = bottomItem;
            index = 0;
            emptyFolder = true;
        }
        else if (!topItem && !rowNum == rowCount)
        {
            parent = collection ? getParentItem(bottomItem) : null;
            index =  bottomItem ? getChildIndexInParent(parent, bottomItem) : 0;
            rowNum = 0;
        }
        else if (bottomItem && bottomParent == topItem)
        {
            // we're dropping in the first item of a folder, that's an easy one
            parent = topItem;
            index = 0;
        }
        else if (topItem && bottomItem && topParent == bottomParent)
        {
            parent = collection ? getParentItem(topItem) : null;
            index = iterator ? getChildIndexInParent(parent, bottomItem) : 0;
        }
        else
        {
            //we're dropping at the end of a folder.  Pay attention to the position.
            if (topItem && (yOffset < (rowHeight * .5)))
            {
                // ok, we're on the top half of the bottomItem.
                parent = topParent;
                index = getChildIndexInParent(parent, topItem) + 1; // insert after
            }
            else if (!bottomItem)
            {
                parent = null;
                if ((rowNum - verticalScrollPosition) == 0)
                    index = 0;
                else if (collection)
                    index = collection.length;
                else index = 0;
            }
            else
            {
                parent = bottomParent;
                index = getChildIndexInParent(parent, bottomItem);
            }
        }
        _dropData = { parent: parent, index: index, localX: event.localX, localY: event.localY, 
                      emptyFolder: emptyFolder, rowHeight: rowHeight, rowIndex: rowNum };
    } */
    
    /**
     *  @private
     */
    /* protected function selectColumnGroupHeader(headerInfo:AdvancedDataGridHeaderInfo):void
    {
        var r:IListItemRenderer = headerInfo.headerItem;
        
        var parentLayer:Sprite;
        var otherLayer:Sprite;

        var s:Sprite;
        
        if (headerInfo.actualColNum < lockedColumnCount)
        {
            parentLayer = selectionLayer;
            otherLayer = movingSelectionLayer;
        }
        else
        {
            parentLayer = movingSelectionLayer;
            otherLayer = selectionLayer;
        }

        s = Sprite(parentLayer.getChildByName("headerKeyboardSelection"));
        if (!s)
            s = Sprite(otherLayer.getChildByName("headerKeyboardSelection"));

        if (! s)
        {
            s = new FlexSprite();
            s.name = "headerKeyboardSelection";
        }

        if (s.parent != parentLayer)
            parentLayer.addChild(s);
        
        var g:Graphics = s.graphics;
        g.clear();
        g.beginFill( (isPressed || isKeyPressed) ? getStyle("selectionColor") : getStyle("rollOverColor") );
        g.drawRect(0, 0, r.width, r.height+cachedPaddingTop+cachedPaddingBottom - 0.5);
        g.endFill();

        s.x = r.x;
        s.y = r.y - cachedPaddingTop;

        // Make sure other selection is removed
        caretIndex = -1;
        isPressed = false;
        selectItem(headerInfo.headerItem, false, false);

    } */
    
    /**
     *  @private
     */
   /*  private function scrollColumnGroupIfNeeded(h1:AdvancedDataGridHeaderInfo, h2:AdvancedDataGridHeaderInfo):void
    {
        if (!isColumnFullyVisible(displayableColumns[h2.actualColNum].colNum))
            scrollToViewColumn(displayableColumns[h2.actualColNum].colNum, displayableColumns[h1.actualColNum].colNum);
    } */
    
    /**
     *  @private
     */
   /*  protected function clearHeaderHorizontalSeparators():void
    {
        if (!horizontalSeparators)
            return;

        var lines:Sprite = Sprite(listSubContent.getChildByName("lines"));
        var headerHorizontalLines:Sprite = Sprite(lines.getChildByName("headerHorizontalLines"));
        while (headerHorizontalLines.numChildren)
        {
            headerHorizontalLines.removeChildAt(headerHorizontalLines.numChildren - 1);
            horizontalSeparators.pop();
        }

        var lockedContent:Sprite = getLockedContent();
        var lockedHeaderHorizontalLines:Sprite = Sprite(lockedContent.getChildByName("lockedHeaderheaderHorizontalLines"));
        if (lockedHeaderHorizontalLines)
        {
            while (lockedHeaderHorizontalLines.numChildren)
            {
                lockedHeaderHorizontalLines.removeChildAt(lockedHeaderHorizontalLines.numChildren - 1);
                horizontalLockedSeparators.pop();
            }
        }
    } */

    /**
     *  @private
     */
    /* protected function drawHeaderHorizontalSeparators():void
    {
        if (!horizontalSeparators)
        {
            horizontalSeparators = [];
            horizontalLockedSeparators = [];
        }
        var childIndex:int;
        var lines:Sprite = Sprite(listSubContent.getChildByName("lines"));
        var headerHorizontalLines:UIComponent = UIComponent(lines.getChildByName("headerHorizontalLines"));

        if (!headerHorizontalLines)
        {
            headerHorizontalLines = new UIComponent();
            headerHorizontalLines.name = "headerHorizontalLines";
            lines.addChild(headerHorizontalLines);  

        }
        if (lines.numChildren > 1)
        {
            var vHeaderLines:UIComponent = UIComponent(lines.getChildByName("header"));
            //Push the horizontal header lines behind vertical lines
            // Otherwise they look little dirty
            if (vHeaderLines)
            {
                childIndex = lines.getChildIndex(vHeaderLines);
                if (childIndex+1 < lines.numChildren)
                    lines.setChildIndex(headerHorizontalLines, childIndex+1);
            }
        }

        numSeparators = 0;
        var unlockedHeaderInfos:Array;
        var lockedHeaderInfos:Array

        if(visibleHeaderInfos)
        {
            if(!isNaN(_lockedColumnCountVal) && _lockedColumnCountVal > 0)
            {
                lockedHeaderInfos = visibleHeaderInfos.slice(0, _lockedColumnCountVal);
                unlockedHeaderInfos = visibleHeaderInfos.slice(_lockedColumnCountVal);
            }
            else
            {
                unlockedHeaderInfos = visibleHeaderInfos;
            }
            
            //Draw horizontal header separators in the unlocked area
            createHeaderHorizontalSeparators(unlockedHeaderInfos, horizontalSeparators, headerHorizontalLines);
        }
        //Remove extra separators created from the unlocked area
        while (headerHorizontalLines.numChildren > numSeparators)
        {
            headerHorizontalLines.removeChildAt(headerHorizontalLines.numChildren - 1);
            horizontalSeparators.pop();
        }

        var lockedHeaderHorizontalLines:UIComponent ;

        numSeparators = 0;
        if (lockedColumnCount > 0)
        {
            var lockedContent:Sprite = getLockedContent();
            lockedHeaderHorizontalLines = UIComponent(lockedContent.getChildByName("lockedHeaderHorizontalLines"));

            if (!lockedHeaderHorizontalLines)
            {
                lockedHeaderHorizontalLines = new UIComponent();
                lockedHeaderHorizontalLines.name = "lockedHeaderHorizontalLines";
                lockedContent.addChild(lockedHeaderHorizontalLines);
            }

            if (lockedContent.numChildren > 1)
            {
                var lockedHeaderLines:UIComponent = UIComponent(lockedContent.getChildByName("lockedHeaderLines"));

                //Push the horizontal header lines behind vertical lines
                // Otherwise they look little dirty
                if (lockedHeaderLines)
                {
                    childIndex = lockedContent.getChildIndex(lockedHeaderLines);
                        if (childIndex+1 < lines.numChildren)
                          lockedContent.setChildIndex(lockedHeaderHorizontalLines, childIndex+1);
                }
            }
            createHeaderHorizontalSeparators(lockedHeaderInfos, horizontalLockedSeparators, lockedHeaderHorizontalLines);
        }
        
        //Remove extra horizontal separators from the locked area
        if (lockedHeaderHorizontalLines)
            while (lockedHeaderHorizontalLines.numChildren > numSeparators)
            {
                lockedHeaderHorizontalLines.removeChildAt(lockedHeaderHorizontalLines.numChildren - 1);
                horizontalLockedSeparators.pop();
            }
    } */

    /**
     *  @private
     */
    /* private function getLockedContent():Sprite
    {
        var locked:Sprite = Sprite(listContent.getChildByName("lockedContent"));
        if (!locked)
        {
            locked = new UIComponent();
            locked.name = "lockedContent";
            locked.cacheAsBitmap = true;
            locked.mouseEnabled = false;
            listContent.addChild(locked);
        }
        listContent.setChildIndex(locked, listContent.numChildren - 1);

        return locked;
    } */

    /**
     *  @private
     */
    /* protected function createHeaderHorizontalSeparators(subHeaderInfos:Array, seperators:Array, headerLines:UIComponent):void
    {
        var n:int = subHeaderInfos.length;
        for (var i:int = 0; i < n; i++)
        {
            if(subHeaderInfos[i].visible && subHeaderInfos[i].visibleChildren && subHeaderInfos[i].visibleChildren.length > 0)
            {
                var sep:UIComponent = getHorizontalSeparator(numSeparators, seperators, headerLines);
                var sepSkin:IFlexDisplayObject = IFlexDisplayObject(sep.getChildAt(0));

                if (!subHeaderInfos[i].headerItem)
                    sep.visible = false;

                numSeparators++;

                sep.visible = true;
                var w:Number = subHeaderInfos[i].column.width;
                sepSkin.setActualSize(w, 2);

                sep.x = subHeaderInfos[i].headerItem.x;
                var depth:int = subHeaderInfos[i].depth;
                sep.y = headerRowInfo[depth].y + (headerRowInfo[depth].height - headerRowInfo[depth+1].height) -  2;
                createHeaderHorizontalSeparators(subHeaderInfos[i].children, seperators, headerLines);
            }
        }
        
    } */

    /**
     *  @private
     */
    /* protected function getHorizontalSeparator(i:int, seperators:Array, headerLines:UIComponent):UIComponent
    {
        var sep:UIComponent;
        var sepSkin:IFlexDisplayObject;

        var headerSeparatorClass:Class =
            getStyle("headerHorizontalSeparatorSkin");

        if (i < headerLines.numChildren)
        {
            sep = UIComponent(headerLines.getChildAt(i));
            sepSkin = IFlexDisplayObject(sep.getChildAt(0));
        }
        else
        {
            sep = new UIComponent();
            headerLines.addChild(sep);
        }
        
        if (sepSkin)
        {
            if (sepSkin is headerSeparatorClass)
            {
                sepSkin = IFlexDisplayObject(sep.getChildAt(0));
            }
            else
            {
                //Remove the skin, because headerHorizontalSeparatorSkin style has 
                //changed now and this skin is of no use
                sep.removeChildAt(0);
                sepSkin = null;
            }
        }
        
        if (!sepSkin)
        {
            sepSkin = new headerSeparatorClass();
            if (sepSkin is ISimpleStyleClient)
                ISimpleStyleClient(sepSkin).styleName = this;
            sep.addChild(DisplayObject(sepSkin));
        }

        seperators.push(sep);
        return sep;
    } */
    
    /**
     *  @private
     */
    /* private function updateMovingColumnIndex():void
    {
        movingColumnIndex = -1;
        if(movingColumn)
        {
            var n:int = orderedHeadersList ? orderedHeadersList.length : 0;
            for ( var i:int = 0; i < n; i++)
            {
                if(orderedHeadersList[i].column == movingColumn)
                 {
                     movingColumnIndex = i;
                     break;
                 }
            }
        }
    } */
    
    /**
     *  @private
     */
    /* protected function finishCellKeySelection():void
    {
        var uid:String;
        var rowCount:int   = listItems.length;
        var partialRow:int = (rowInfo[rowCount-1].y + rowInfo[rowCount-1].height >
                              listContent.height) ? 1 : 0;

        var listItem:IListItemRenderer;
        var bSelChanged:Boolean = false;

        var columnIndex:int = caretColumnIndex;

        // Move selection
        if (bSelectItem && caretIndex - verticalScrollPosition >= 0)
        {
            if (caretIndex - verticalScrollPosition > listItems.length-1)
                caretIndex = listItems.length - 1 + verticalScrollPosition;
            
            var visibleCoords:Object = absoluteToVisibleIndices(caretIndex, caretColumnIndex);
            var visibleRowIndex:int = visibleCoords.rowIndex;
            var visibleColIndex:int = visibleCoords.columnIndex;
            if (visibleRowIndex >= 0 && visibleColIndex >= 0)
                listItem = listItems[visibleRowIndex][visibleColIndex];

            // if column spanning is used and the item is invisible,
            // then find the item which is spanning across this column
            while (listItem && !listItem.visible)
            {
                if (listItems[visibleRowIndex] && listItems[visibleRowIndex][visibleColIndex - 1])
                {
                    listItem = listItems[visibleRowIndex][visibleColIndex];
                    visibleColIndex--;
                    columnIndex--;
                }
                else
                {
                    break;
                }
            }
            
            if (listItem)
            {
                uid = itemToUID(listItem.data);
                if (visibleCellRenderers[uid])
                    listItem = visibleCellRenderers[uid][columnIndex];

                if (bShiftKey)
                {
                    selectCellItem(listItem, bShiftKey, bCtrlKey);
                    bSelChanged = true;
                }
                else if (bCtrlKey)
                {
                    if (lastKey == Keyboard.SPACE)
                    {
                        selectCellItem(listItem, bShiftKey, bCtrlKey, true);
                    }
                    else
                    {
                        drawCellItem(listItem,
                                     cellSelectionData[uid]
                                     && cellSelectionData[uid][columnIndex] != null,
                                     uid == highlightUID && caretColumnIndex == highlightColumnIndex,
                                     true);
                        bSelChanged = true;
                    }
                }
                else
                {
                    var oldCaretIndex:int   = caretIndex;

                    clearSelectedCells();

                    caretIndex     = oldCaretIndex;
                    anchorIndex    = caretIndex;
                    _selectedIndex = caretIndex;

                    selectedColumnIndex = caretColumnIndex;
                    anchorColumnIndex   = caretColumnIndex;

                    selectCellItem(listItem, bShiftKey, bCtrlKey, false);
                    bSelChanged = true;
                }
            }
        }

        // Move caret
        if (!bSelectItem && caretColumnIndex - horizontalScrollPosition >= 0)
        {
            if (caretColumnIndex - horizontalScrollPosition > _columns.length - 1)
                caretColumnIndex = _columns.length - 1 + horizontalScrollPosition;

            if (caretIndex - verticalScrollPosition >= 0)
            {
                var caretCoords:Object = absoluteToVisibleIndices(caretIndex, caretColumnIndex);
                listItem = listItems[caretCoords.rowIndex][caretCoords.columnIndex];
            }

            if (listItem)
            {
                uid = itemToUID(listItem.data);
                if (visibleCellRenderers[uid])
                    listItem = visibleCellRenderers[uid][columnIndex];

                if (bShiftKey)
                {
                    selectCellItem(listItem, bShiftKey, bCtrlKey);
                    bSelChanged = true;
                }
                else if (bCtrlKey)
                {
                    drawCellItem(listItem,
                                 cellSelectionData[uid]
                                 && cellSelectionData[uid][columnIndex] != null,
                                 uid == highlightUID && caretColumnIndex == highlightColumnIndex,
                                 true);
                }
                else
                {
                    oldCaretIndex  = caretIndex;

                    clearSelectedCells();

                    caretIndex     = oldCaretIndex;
                    anchorIndex    = caretIndex;
                    _selectedIndex = caretIndex;

                    selectCellItem(listItem, bShiftKey, bCtrlKey, false);
                    bSelChanged = true;
                }
            }
        }

        if (bSelChanged)
        {
            var evt:ListEvent = new ListEvent(ListEvent.CHANGE);
            evt.itemRenderer = listItem;

            var pt:Point = itemRendererToIndices(listItem);
            if (pt)
            {
                evt.rowIndex = pt.y;
                evt.columnIndex = displayToAbsoluteColumnIndex(pt.x);
            }
            dispatchEvent(evt);
        }
    } */
    
    /**
     *  Updates the list of selected cells, assuming that the specified item renderer was
     *  clicked by the mouse, and the keyboard modifiers are in the specified state. 
     *
     *  <p>This method also updates the display of the item renderers based on their updated
     *  selected state.</p>
     *
     *  @param item The item renderer for the cell.
     *
     *  @param shiftKey <code>true</code> to specify that the Shift key is pressed, 
     *  and <code>false</code> if not.
     *
     *  @param ctrlKey <code>true</code> to specify that the Control key is pressed, 
     *  and <code>false</code> if not.
     *
     *  @param transition Specify <code>true</code> to animate the transition.
     *
     *  @return Returns <code>true</code> if the operation succeeded.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function selectCellItem(item:IListItemRenderer,
                                      shiftKey:Boolean,
                                      ctrlKey:Boolean,
                                      transition:Boolean = true):Boolean
    {
        if (!selectable || !item || !itemRendererToIndices(item))
            return false;

        if (isHeaderItemRenderer(item))
            return false;

        // We'll start by assuming that the selection has not changed.
        var selectionChange:Boolean    = false;
        var placeHolder:CursorBookmark = iterator.bookmark;

        var pt:Point                   = itemRendererToIndices(item);
        if (pt.x < 0)
            return false;
        var index:int                  = pt.y;
        var columnIndex:int            = displayToAbsoluteColumnIndex(pt.x);

        var uid:String                 = itemToUID(item.data);
        var data:Object                = item.data;

        if (selectionMode == SINGLE_CELL
            || (selectionMode == MULTIPLE_CELLS && !ctrlKey && !shiftKey))
        {
            // We want to know if 0, 1 or more items are selected
            var numSelected:int = 0;
            if (selectionMode == MULTIPLE_CELLS)
            {
                var curSelectionData:AdvancedDataGridBaseSelectionData
                    = firstCellSelectionData;
                if (curSelectionData != null)
                {
                    numSelected++;
                    if (curSelectionData.nextSelectionData)
                        numSelected++;
                }
            }

            // allow unselecting via ctrl-click
            if (ctrlKey && cellSelectionData[uid] && cellSelectionData[uid][columnIndex])
            {
                selectionChange = true;

                var oldCaretIndex:int       = caretIndex;
                var oldCaretColumnIndex:int = caretColumnIndex;

                clearSelectedCells();

                caretIndex       = oldCaretIndex;
                caretColumnIndex = oldCaretColumnIndex;
            }
            // Plain old click, ignore if same item is selected unless number of
            // selected items is going to change
            else if ((_selectedIndex != index || selectedColumnIndex != columnIndex)
                || (selectionMode == MULTIPLE_CELLS && numSelected != 1)
                || (selectionMode == SINGLE_CELL))
            {
                selectionChange = true;

                clearSelectedCells();

                // Add new cell to cellSelectionData
                addCellSelectionData(uid, columnIndex,
                                     new AdvancedDataGridBaseSelectionData(item.data,
                                                                           index, columnIndex, false) );

                // Insert new cell's location at head position
                // of outside-facing selectedCells
                addToSelectedCells(index, columnIndex);

                // Draw the cell as selected, check if it is already highlighted
                drawCellItem(item, true,
                             uid == highlightUID && columnIndex == highlightColumnIndex,
                             true, transition);

                // Update index, cell
                selectedColumnIndex = columnIndex;
                _selectedIndex      = pt.y;
                iterator.seek(CursorBookmark.CURRENT, _selectedIndex - verticalScrollPosition);

                // Update caret and anchor
                anchorColumnIndex = caretColumnIndex = selectedColumnIndex;
                anchorIndex       = caretIndex       = _selectedIndex;
                anchorBookmark    = caretBookmark    = iterator.bookmark;

                // Reset iterator to top of visible rows
                iterator.seek(placeHolder, 0);
            }
        }
        else if (shiftKey && selectionMode == MULTIPLE_CELLS)
        {
            if (anchorBookmark)
            {
                var oldAnchorBookmark:CursorBookmark = anchorBookmark;
                var oldAnchorIndex:int               = anchorIndex;
                var oldAnchorColumnIndex:int         = anchorColumnIndex;

                clearSelectedCells();

                caretIndex        = index;
                caretColumnIndex  = columnIndex;
                caretBookmark     = iterator.bookmark;

                anchorIndex       = oldAnchorIndex;
                anchorBookmark    = oldAnchorBookmark;
                anchorColumnIndex = oldAnchorColumnIndex;

                try
                {
                    iterator.seek(anchorBookmark, 0);
                }
                catch (e:ItemPendingError)
                {
                    e.addResponder(new ItemResponder(
                                       cellSelectionPendingResultHandler,
                                       cellSelectionPendingFailureHandler,
                                       new AdvancedDataGridBaseSelectionPending(
                                           index,
                                           anchorIndex,
                                           columnIndex,
                                           anchorColumnIndex,
                                           item.data,
                                           transition,
                                           placeHolder,
                                           CursorBookmark.CURRENT,
                                           0) ) );
                    iteratorValid = false;
                }

                shiftCellSelectionLoop(index, anchorIndex, columnIndex, anchorColumnIndex,
                                       item.data, transition, placeHolder);

                selectionChange = true;
            }
        }
        else if (ctrlKey && selectionMode == MULTIPLE_CELLS)
        {
            if (cellSelectionData[uid] && cellSelectionData[uid][columnIndex])
            {
                removeCellSelectionData(uid, columnIndex);
                drawCellItem(visibleCellRenderers[uid][columnIndex], // item
                             false, // selected
                             uid == highlightUID && columnIndex == highlightColumnIndex, // highlighted
                             true, // caret
                             transition); // transition
                removeFromSelectedCells(index, columnIndex);
            }
            else
            {
                addCellSelectionData(uid, columnIndex,
                                     new AdvancedDataGridBaseSelectionData(
                                         item.data,
                                         index,
                                         columnIndex,
                                         false) );

                drawCellItem(visibleCellRenderers[uid][columnIndex], // item
                             true, // selected
                             uid == highlightUID && columnIndex == highlightColumnIndex, // highlighted
                             true, // caret
                             transition); // transition

                addToSelectedCells(index, columnIndex);

                _selectedIndex      = index;
                selectedColumnIndex = columnIndex;
                // Setting this causes unexpected behavior in the UI because
                // it does a call of updateDisplayList on its own, and we can't
                // set it directly since it's a private variable in ListBase
                // selectedItem       = item.data;
            }

            iterator.seek(CursorBookmark.CURRENT, index - verticalScrollPosition);

            caretIndex       = index;
            caretColumnIndex = columnIndex;
            caretBookmark    = iterator.bookmark;

            anchorIndex       = index;
            anchorColumnIndex = columnIndex;
            anchorBookmark    = iterator.bookmark;

            iterator.seek(placeHolder, 0);

            selectionChange = true;
        }

        return selectionChange;
    } */

    /**
     *  @private
     *  Handle shift-selection of cells.
     *
     */
    /* private function shiftCellSelectionLoop(stopIndex:int,
                                            anchorIndex:int,
                                            stopColumnIndex:int,
                                            anchorColumnIndex:int,
                                            stopData:Object,
                                            transition:Boolean,
                                            placeHolder:CursorBookmark):void
    {
        var incr:Boolean       = (anchorIndex < stopIndex);
        var columnIncr:Boolean = (anchorColumnIndex < stopColumnIndex);
        var data:Object;
        var uid:String;
        var index:int = anchorIndex;

        try
        {
            // loop for rows
            do
            {
                data = iterator.current;
                uid  = itemToUID(data);
                var columnIndex:int = anchorColumnIndex;

                // loop for columns
                while (true)
                {
					addCellSelectionData(uid,
						columnIndex,
						new AdvancedDataGridBaseSelectionData(
							data,
							index,
							columnIndex,
							false)
					);
					addToSelectedCells(index, columnIndex);
					
                    if (visibleCellRenderers[uid]
                        && visibleCellRenderers[uid][columnIndex]
                        && visibleCellRenderers[uid][columnIndex].visible)
                        // Checking visibility to handle column spanning
                    {
                        drawCellItem(visibleCellRenderers[uid][columnIndex],
                                     true,
                                     uid == highlightUID && columnIndex == highlightColumnIndex,
                                     false,
                                     transition);
                    }

                    if (columnIndex != stopColumnIndex && columnIndex != -1)
                    {
                        if (columnIncr)
                            columnIndex = viewDisplayableColumnAtOffset(columnIndex, +1, -1, false);
                        else
                            columnIndex = viewDisplayableColumnAtOffset(columnIndex, -1, -1, false);
                    }
                    else
                    {
                        break;
                    }
                }

                if (data == stopData)
                {
                    if (visibleCellRenderers[uid]
                        && visibleCellRenderers[uid][columnIndex])
                    {
                        drawCellItem(visibleCellRenderers[uid][columnIndex],
                                     true,
                                     uid == highlightUID && columnIndex == highlightColumnIndex,
                                     true,
                                     transition);
                    }

                    break;
                }

                if (incr)
                    index++;
                else
                    index--;
            }
            while (incr ? iterator.moveNext() : iterator.movePrevious());
        }
        catch (e:ItemPendingError)
        {
            e.addResponder(new ItemResponder(
                               cellSelectionPendingResultHandler,
                               cellSelectionPendingFailureHandler,
                               new AdvancedDataGridBaseSelectionPending(
                                   index,
                                   anchorIndex,
                                   columnIndex,
                                   anchorColumnIndex,
                                   data,
                                   transition,
                                   placeHolder,
                                   CursorBookmark.CURRENT,
                                   0) ) );

            iteratorValid = false;
        }

        try
        {
            iterator.seek(placeHolder, 0);
            iteratorValid = true;
        }
        catch (e2:ItemPendingError)
        {
            lastSeekPending = new ListBaseSeekPending(placeHolder, 0);

            e2.addResponder(new ItemResponder(
                                seekPendingResultHandler,
                                seekPendingFailureHandler,
                                lastSeekPending));
        }
    } */

    /**
     *  @private
     */
    /* private function cellSelectionPendingResultHandler(data:Object,
                                                       info:AdvancedDataGridBaseSelectionPending):void
    {
        iterator.seek(info.bookmark, info.offset);
        shiftCellSelectionLoop(info.index, info.anchorIndex, info.columnIndex,
                               info.anchorColumnIndex, info.stopData,
                               info.transition, info.placeHolder);
    } */

    /**
     *  @private
     */
    /* private function cellSelectionPendingFailureHandler(data:Object,
                                                        info:AdvancedDataGridBaseSelectionPending):void
    {
    } */

    /**
     *  Determines if cell is highlighted.
     *
     *  @param data The data provider item.
     *  @param columnIndex index of column.
     *
     *  @return <code>true</code> if the cell item is highlighted.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
	/* public function isCellItemHighlighted(data:Object, columnIndex:int): Boolean
	{
		if (data == null)
			return false;
		if (isCellItemSelected(data, columnIndex))
			return false;
		return highlightUID == data && highlightColumnIndex == columnIndex;
	} */	

	/**
	 *  Determines if cell is selected.
	 *
     *  @param data The data provider item.
     *  @param columnIndex index of column.
     *
     *  @return <code>true</code> if the cell item is selected.
     * 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
	/* public function isCellItemSelected(data:Object, columnIndex:int): Boolean
	{
		if (data == null)
			return false;
		return cellSelectionData[data] && cellSelectionData[data][columnIndex];
	}	 */
	
    /**
     *  @private
     *  Check if a cell is already present in selecedCells.
     */
    /* private function isCellAlreadySelected(rowIndex:int, columnIndex:int):Boolean
    {
        if (!_selectedCells || !_selectedCells.length)
            return false;

		return cellSelections[[rowIndex, columnIndex]] != null;
    } */

    /**
     *  Helper function to add a row/column location to the selectedCells array
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* mx_internal function addToSelectedCells(rowIndex:int, columnIndex:int):void
    {
		if (isCellAlreadySelected(rowIndex, columnIndex))
			return;
		
        var newCell:Object = {   rowIndex    : rowIndex,
                                 columnIndex : columnIndex };

        var newSelectedCells:Array = _selectedCells;
        if (!newSelectedCells)
            newSelectedCells = [];
        newSelectedCells.unshift(newCell);
        _selectedCells = newSelectedCells;
		cellSelections[[rowIndex,columnIndex]] = newCell;
    } */

    /**
     *  Helper function to remove a row/column location to the selectedCells array
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* mx_internal function removeFromSelectedCells(rowIndex:int, columnIndex:int):void
    {
        var cellToRemove:int = -1;

        if (_selectedCells)
        {
            var n:int = _selectedCells.length;
            for (var i:int = 0; i < n; i++)
            {
                // Skip the cell that we want to remove
                if (_selectedCells[i].rowIndex == rowIndex
                    && _selectedCells[i].columnIndex == columnIndex)
                {
                    cellToRemove = i;
                    break;
                }
            }

            if (cellToRemove != -1)
                _selectedCells.splice(cellToRemove, 1);
        }
    } */

    /**
     *  Adds cell selection information to the control, as if you used the mouse to select the cell.
     *
     *  @param uid The UID of the selected cell.
     *
     *  @param columnIndex The column index of the selected cell.
     *
     *  @param selectionData An AdvancedDataGridBaseSelectionData instance defining the 
     *  information about the selected cell.
     * 
     *  @see mx.controls.advancedDataGridClasses.AdvancedDataGridBaseSelectionData
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function addCellSelectionData(uid:String,
                                            columnIndex:int,
                                            selectionData:AdvancedDataGridBaseSelectionData):void
    {
        if (firstCellSelectionData != null)
            firstCellSelectionData.prevSelectionData = selectionData;

        selectionData.nextSelectionData = firstCellSelectionData;
        firstCellSelectionData          = selectionData;

        if (!cellSelectionData[uid])
            cellSelectionData[uid] = [];

        cellSelectionData[uid][columnIndex] = selectionData;
    } */

    /**
     *  Removes cell selection information from the control.
     *
     *  @param uid The UID of the selected cell.
     *
     *  @param columnIndex The column index of the selected cell.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function removeCellSelectionData(uid:String, columnIndex:int):void
    {
        if (!cellSelectionData[uid])
            return;

        var curSelectionData:AdvancedDataGridBaseSelectionData
            = cellSelectionData[uid][columnIndex];

        if (firstCellSelectionData == curSelectionData)
            firstCellSelectionData = curSelectionData.nextSelectionData;

        if (curSelectionData.prevSelectionData != null)
            curSelectionData.prevSelectionData.nextSelectionData
                = curSelectionData.nextSelectionData;

        if (curSelectionData.nextSelectionData != null)
            curSelectionData.nextSelectionData.prevSelectionData
                = curSelectionData.prevSelectionData;

        delete cellSelectionData[uid][columnIndex];

        // Remove uid if there are no columns for that uid in cellSelectionData
        if (!atLeastOneProperty(cellSelectionData[uid]))
            delete cellSelectionData[uid];
    } */

    /**
     *  Returns <code>true</code> if the Object has at least one property,
     *  which means that the dictionary has at least one key.
     *
     *  @param o The Object to inspect.
     *
     *  @return <code>true</code> if the Object has at least one property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function atLeastOneProperty(o:Object):Boolean
    {
        for (var p:String in o) // substitute for an "object.length" property
            return true;

        for each (var variable:XML in describeType(data).variable)
            return true;

        return false;
    } */

    /**
     *  Clears the <code>selectedCells</code> property.
     *
     *  @param transition Specify <code>true</code> to animate the transition.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function clearSelectedCells(transition:Boolean = false):void
    {
        for (var p:String in visibleCellRenderers)
        {
            for (var q:String in cellSelectionData[p])
            {
				var item:IListItemRenderer;
				var visibleRenderer:Object = visibleCellRenderers[p];
				if (visibleRenderer)
					item = visibleRenderer[q];
                if (item)
				{
					// IMPORTANT! Clear the selection before drawCellItem() is called -> IInvalidating(item).validateNow() 
					cellSelectionData[p][q] = null; 
                    drawCellItem(item, false,
                                 p == highlightUID
                                 && highlightColumnIndex == int(q),
                                 false,
                                 transition);
				}
            }
        }

        _selectedCells = [];
		cellSelections = {};

        clearCellSelectionData();

        _selectedIndex = -1;
        selectedItem   = null;

        caretIndex  = -1;
        anchorIndex = -1;

        caretBookmark  = null;
        anchorBookmark = null;
		
		clearPendingCells();
    } */

    /**
     *  @private
     *  Remove entries in pendingCellSelection.
     */
    /* protected function clearPendingCells():void
    {
        cellsWaitingToBeDisplayed = false;
        pendingCellSelection.removeAll();
    } */

    /**
     *  Clears information on cell selection.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function clearCellSelectionData():void
    {
        cellSelectionData = {};
        firstCellSelectionData = null;
    } */

    /**
     *  @private
     */
    /* protected function addIndicatorToSelectionLayer(o:Sprite, columnIndex:int):void
    {
        if (columnIndex < lockedColumnCount)
        {
            if (o.parent != selectionLayer)
                selectionLayer.addChild(DisplayObject(o));
            else
                o.parent.setChildIndex(DisplayObject(o),
                                       o.parent.numChildren - 1);
        }
        else
        {
            if (o.parent != movingSelectionLayer)
                movingSelectionLayer.addChild(DisplayObject(o));
            else
                o.parent.setChildIndex(DisplayObject(o),
                                       o.parent.numChildren - 1);
        }
    } */

    /**
     *  @private
     *  Draw a cell item renderer based on whether it is/is not selected,
     *  highlighted and the caret is positioned on the cell.
     *
     */
    /* protected function drawCellItem(item:IListItemRenderer,
                                    selected:Boolean    = false,
                                    highlighted:Boolean = false,
                                    caret:Boolean       = false,
                                    transition:Boolean  = false):void
    {
        if (!item || isHeaderItemRenderer(item))
            return;

        var pt:Point = itemRendererToIndices(item);
        if (!pt)
            return;

        var index:int       = pt.y;
        var columnIndex:int = displayToAbsoluteColumnIndex(pt.x);

        var rowData:BaseListData = rowMap[item.name];

        var o:Sprite;
        var g:Graphics;

        var itemXPos:Number = item.x;
//         if (columnIndex > lockedColumnCount)
//             itemXPos = getAdjustedXPos(itemXPos);

        if (highlighted
            && (!highlightItemRenderer
                || (highlightUID != rowData.uid && columnIndex != highlightColumnIndex)))
        {
            if (!highlightIndicator)
            {
                o = new SpriteAsset();
                highlightIndicator = o;
            }

            o = highlightIndicator;

            addIndicatorToSelectionLayer(o, pt.x);

            drawHighlightIndicator(
                o,                                  // sprite
                itemXPos,                             // x
                rowInfo[rowData.rowIndex].y,        // y
                item.width,                         // width
                rowInfo[rowData.rowIndex].height,   // height
                getStyle("rollOverColor"),          // color
                item);                              // IListItemRenderer

            highlightItemRenderer = item;
            highlightUID          = rowData.uid;
            highlightColumnIndex  = columnIndex;
        }
        else if (!highlighted
                 && highlightItemRenderer
                 && (rowData && highlightUID == rowData.uid && highlightColumnIndex == columnIndex))
        {
            if (highlightIndicator)
                Sprite(highlightIndicator).graphics.clear();
            lastHighlightItemRenderer = highlightItemRenderer;
            highlightItemRenderer     = null;
            highlightUID              = null;
            highlightColumnIndex      = -1;
        }

        if (selected)
        {
            if (!cellSelectionIndicators[rowData.uid])
                cellSelectionIndicators[rowData.uid] = {};

            var newIndicator:Boolean = false;

            if (!cellSelectionIndicators[rowData.uid][columnIndex])
            {
                o = new SpriteAsset();
                o.mouseEnabled = false;
                cellSelectionIndicators[rowData.uid][columnIndex] = o;
                newIndicator = true;
            }
            o = cellSelectionIndicators[rowData.uid][columnIndex];
            addIndicatorToSelectionLayer(o, pt.x);
            
                drawSelectionIndicator(
                    o,                                      // sprite
                    itemXPos,                               // x
                    rowInfo[rowData.rowIndex].y,            // y
                    item.width,                             // width
                    rowInfo[rowData.rowIndex].height,       // height
                    enabled ?                               // color
                    getStyle("selectionColor") :
                    getStyle("selectionDisabledColor"),
                    item);                                  // IListItemRenderer

            if (newIndicator)
                if (transition)
                    applyCellSelectionEffect(o, rowData.uid, columnIndex, item);
        }
        else if (!selected)
        {
			if (rowData)
			{
				var rowIndicators:Object = cellSelectionIndicators[rowData.uid];
				if (rowIndicators && rowIndicators[columnIndex])
				{
					o = rowIndicators[columnIndex];
					if (o.parent)
						o.parent.removeChild(o);
					
					delete rowIndicators[columnIndex];
					if (!atLeastOneProperty(rowIndicators))
						delete cellSelectionIndicators[rowData.uid];
				}
			}
        }

        if (caret)
        {
            // Only draw the caret if there has been keyboard navigation.
            if (showCaret)
            {
                if (!caretIndicator)
                {
                    o = new SpriteAsset();
                    o.mouseEnabled = false;
                    caretIndicator = o;
                }
                o = caretIndicator;

                addIndicatorToSelectionLayer(o, pt.x);

                drawCaretIndicator(
                    o,                                  // sprite
                    itemXPos,                           // x
                    rowInfo[rowData.rowIndex].y,        // y
                    item.width,                         // width
                    rowInfo[rowData.rowIndex].height,   // height
                    getStyle("selectionColor"),         // color
                    item);                              // IListItemRenderer

                caretItemRenderer = item;
                caretUID          = rowData.uid;
                caretColumnIndex  = columnIndex;
            }
        }
        else if (!caret && caretItemRenderer
                 && caretUID == rowData.uid
                 && caretColumnIndex == columnIndex)
        {
            if (caretIndicator)
                Sprite(caretIndicator).graphics.clear();

            caretItemRenderer = null;
            caretUID          = null;
        }

        if (item is IFlexDisplayObject)
        {
            if (item is IInvalidating)
            {
                IInvalidating(item).invalidateDisplayList();
                IInvalidating(item).validateNow();
            }
        }
        else if (item is IUITextField)
        {
            IUITextField(item).validateNow();
        }

        var rowIndex:int = rowMap[item.name].rowIndex;
        var optimumColumns:Array = getOptimumColumns();
        var n:int = optimumColumns.length;
        for (var i:int = 0; i < n; i++)        
        {
            var r:IListItemRenderer = listItems[rowIndex][i];
            updateDisplayOfItemRenderer(r);
        }
    } */

    /**
     *  Sets up the effect for applying the selection indicator.
     *  The default is a basic alpha tween.
     *
     *  @param indicator A Sprite that contains the graphics depicting selection.
     * 
     *  @param uid The UID of the item being selected which can be used to index
     *  into a table and track more than one selection effect.
     *
     *  @param columnIndex The column index of the selected cell.
     *
     *  @param itemRenderer The item renderer that is being shown as selected.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* protected function applyCellSelectionEffect(indicator:Sprite,
                                                uid:String,
                                                columnIndex:int,
                                                itemRenderer:IListItemRenderer):void
    {
        var selectionDuration:Number = getStyle("selectionDuration");

        if (selectionDuration != 0)
        {
            indicator.alpha = 0;

            if (!cellSelectionTweens[uid])
                cellSelectionTweens[uid] = [];

            cellSelectionTweens[uid][columnIndex] =
                new Tween(indicator, 0, 1, selectionDuration, 5);

            cellSelectionTweens[uid][columnIndex].addEventListener(
                TweenEvent.TWEEN_UPDATE,
                selectionTween_updateHandler);

            cellSelectionTweens[uid][columnIndex].addEventListener(
                TweenEvent.TWEEN_END,
                selectionTween_endHandler);

            cellSelectionTweens[uid][columnIndex].setTweenHandlers(
                onSelectionTweenUpdate,
                onSelectionTweenUpdate);

            var selectionEasingFunction:Function =
                getStyle("selectionEasingFunction") as Function;
            if (selectionEasingFunction != null)
                cellSelectionTweens[uid][columnIndex].easingFunction
                    = selectionEasingFunction;
        }
    } */
    
    /**
     *  @private
     */
    /* protected function removeCellIndicators(uid:String, columnIndex:int):void
    {
        if (cellSelectionTweens[uid] && cellSelectionTweens[uid][columnIndex])
        {
            cellSelectionTweens[uid][columnIndex].removeEventListener(
                TweenEvent.TWEEN_UPDATE, selectionTween_updateHandler);

            cellSelectionTweens[uid][columnIndex].removeEventListener(
                TweenEvent.TWEEN_END, selectionTween_endHandler);

            if (cellSelectionIndicators[uid][columnIndex].alpha < 1)
                Tween.removeTween(cellSelectionTweens[uid][columnIndex]);

            delete cellSelectionTweens[uid][columnIndex];
            if (!atLeastOneProperty(cellSelectionTweens[uid]))
                delete cellSelectionTweens[uid];
        }

        // toss associated graphics if needed

        if (cellSelectionIndicators[uid] && cellSelectionIndicators[uid][columnIndex])
        {
            cellSelectionIndicators[uid][columnIndex].parent.removeChild(cellSelectionIndicators[uid][columnIndex]);
            delete cellSelectionIndicators[uid][columnIndex];
            if (!atLeastOneProperty(cellSelectionIndicators[uid]))
                delete cellSelectionIndicators[uid];
        }

        if (uid == highlightUID && columnIndex == highlightColumnIndex)
        {
            lastHighlightItemRenderer = highlightItemRenderer;
            highlightItemRenderer = null;
            highlightUID = null;
            if (highlightIndicator)
                Sprite(highlightIndicator).graphics.clear();
        }

        if (uid == caretUID && columnIndex == caretColumnIndex)
        {
            caretItemRenderer = null;
            caretUID = null;
            if (caretIndicator)
                Sprite(caretIndicator).graphics.clear();
        }
    } */
    
    /**
     *  @inheritDoc mx.controls.listClasses.ListBase#clearIndicators()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    /* override protected function clearIndicators():void
    {
        if (isCellSelectionMode())
            clearCellIndicators();

        super.clearIndicators();
    } */

    /**
     *  @private
     */
    /* protected function clearCellIndicators():void
    {
		for (var p:String in cellSelectionIndicators)
		{
			var keys:Array = [];
			for (var q:String in cellSelectionIndicators[p]) {
				keys.push(q);	
			}
			
			for each (q in keys)
			{
				removeCellIndicators(p, int(q));
			}
		}

        cellSelectionTweens     = {};
        cellSelectionIndicators = {};
        visibleCellRenderers    = {};
    } */
    
    /**
     * @private
     * Set selectedCells and update display accordingly.
     */
   /*  mx_internal function setSelectedCells(value:Array):void
    {
        var isFirstCell:Boolean = true;
        var n:int = value.length;
        for (var i:int = 0; i < n; i++)
        {
			var cell:Object = value[i];
            if (isCellAlreadySelected(cell.rowIndex, cell.columnIndex))
                continue;

            var visibleCoords:Object = absoluteToVisibleIndices(value[i].rowIndex,
                                            value[i].columnIndex);
            var visibleRowIndex:int = visibleCoords.rowIndex;
            var visibleColIndex:int = visibleCoords.columnIndex;

            var listItem:IListItemRenderer;
            if (listItems[visibleRowIndex] && listItems[visibleRowIndex][visibleColIndex])
            {
                listItem = listItems[visibleRowIndex][visibleColIndex];
            }
            else
            {
                addToSelectedCells(value[i].rowIndex, value[i].columnIndex);
                pendingCellSelection.addItem(value[i]);
                cellsWaitingToBeDisplayed = true;
                continue;
            }

            if (isFirstCell)
            {
                // Replaces selectedCells with only this cell location
                selectCellItem(listItem, false, false);
                isFirstCell = false;
            }
            else
            {
                // Add to selectedCells
                selectCellItem(listItem, false, true); // ctrl-key => multiple selection
            }
        }
    } */
    
    /**
     *  @private
     *  Update the selectedCells array based on the changes in non-cell
     *  selection modes.
     */
    /* protected function updateSelectedCells():void
    {
        switch(selectionMode)
        {
            case NONE:
            {
                if (_selectedCells)
                    _selectedCells = null;
                break;
            }
    
            case SINGLE_ROW:
            {
                // When in row selection mode, selectedCells is updated
                // along with selectedItems, selectedIndices as well
                _selectedCells = [
                {
                    rowIndex : selectedIndex,
                    columnIndex : -1
                }
                    ];
                break;
            }
    
            case MULTIPLE_ROWS:
            {
                // When in row selection mode, selectedCells is updated
                // along with selectedItems, selectedIndices as well
                _selectedCells = selectedIndices.map(rowToCell);
                break;
            }
        }
		syncCellSelections(_selectedCells);
    } */
	
	/**
	 *  @private
	 */
	/* private function syncCellSelections(cells:Array):void
	{
		if (!cells)
		{
			cellSelections = null;
		}
		else
		{
			cellSelections = {};
			for each (var cell:Object in cells)
			{
				cellSelections[[cell.rowIndex, cell.columnIndex]] = cell;
			}
		}
	} */

    /**
     *  @private
     */
   /*  private function rowToCell(item:*, index:int, array:Array):Object
    {
        return {
            rowIndex : item,
                columnIndex : -1
                };
    } */

     /**
     *  @private
     */
   /* private function getAdjustedLockedCount(index:int):int
    {
        if(visibleHeaderInfos)
        {
            index = Math.min(index, visibleHeaderInfos.length);
            if(visibleHeaderInfos[ index - 1])
                return visibleHeaderInfos[index-1].actualColNum + visibleHeaderInfos[index-1].columnSpan;
       }
        return 0;
    } */
   
   /**
    * Get the length of the header items. Length calculation is different
	* in case grouped columns are specified.
	*  @private
	*/
   /* override protected function getHeaderItemsLength():int
   {
	   if (!columnGrouping)
		   return super.getHeaderItemsLength();
	   
	   if (headerItemsList)
		   return headerItemsList.length;
	   
	   return 0;
   } */

    //--------------------------------------------------------------------------
    //
    //  Overridden event handlers
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     *  Catches any events from the model. Optimized for editing one item.
     *  Creates columns when there are none. Inherited from list.
     *  @param eventObj
     */
    override protected function collectionChangeHandler(event:Event):void
    {
        /*
        if (event is CollectionEvent)
        {   
            var ceEvent:CollectionEvent = CollectionEvent(event);
			
            if (ceEvent.kind == CollectionEventKind.RESET)
            {
                // if the data is grouped, update the groupLabelField.
                if (_rootModel is IGroupingCollection && IGroupingCollection(_rootModel).grouping)
                    groupLabelField = IGroupingCollection(_rootModel).grouping.label;
				
				if (_rootModel is IGroupingCollection2 && IGroupingCollection2(_rootModel).grouping)
					groupLabelField = IGroupingCollection2(_rootModel).grouping.label;
                
                // if collection is reset, then expand the items if displayItemsExpanded is true
                if (displayItemsExpanded)
                    expandAll();
            }
            if (ceEvent.kind == CollectionEventKind.REFRESH)
            {
                // if collection is reset, then expand the items if displayItemsExpanded is true
                if (displayItemsExpanded)
                    expandAll();
            }
        }*/

        super.collectionChangeHandler(event);

        /*
        if (event is CollectionEvent)
        {
            var ce:CollectionEvent = CollectionEvent(event);
            if (ce.kind == CollectionEventKind.ADD)
            {
                if (displayItemsExpanded)
                {
                    // when children are added, display them expanded
                    var n:int = ce.items.length;
                    for (var i:int = 0; i < n; i++)
                    {
                        expandChildrenOf(ce.items[i],true);
                    }
                }
            }
        }*/
    }
    
    /**
     *  @private
     */
    /* override protected function headerNavigationHandler(event:KeyboardEvent):void
    {
       // If rtl layout, need to swap LEFT and RIGHT so correct action
       // is done.
       var keyCode:uint = mapKeycodeForLayoutDirection(event);
	   
       if (!columnGrouping || headerIndex == -1 || selectedHeaderInfo == null)
       {
          super.headerNavigationHandler(event);
       }
       else
       {
          if (headerIndex == -1 || selectedHeaderInfo == null)
             return;

          var newSelectedHeaderInfo:AdvancedDataGridHeaderInfo;
          var siblings:Array;
          if (keyCode == Keyboard.UP)
          {
             if (selectedHeaderInfo.parent != null)
             {
                newSelectedHeaderInfo = selectedHeaderInfo.parent;
                unselectColumnHeader(headerIndex);
                
                selectedHeaderInfo = newSelectedHeaderInfo;
                headerIndex = newSelectedHeaderInfo.index;
                selectColumnGroupHeader(newSelectedHeaderInfo);
             }
             
          }
          else if (keyCode == Keyboard.DOWN)
          {
             //Check if we are a leaf-header
             if (selectedHeaderInfo.visibleChildren == null || selectedHeaderInfo.visibleChildren.length == 0)
             {
                unselectColumnHeader(selectedHeaderInfo.column.colNum, true);
                headerIndex = -1;
             }
             else
             {
                 newSelectedHeaderInfo = selectedHeaderInfo.visibleChildren[0];
                 unselectColumnHeader(headerIndex);
                 
                 selectedHeaderInfo = newSelectedHeaderInfo;
                 headerIndex = 0;
                 selectColumnGroupHeader(newSelectedHeaderInfo);
             }
          }
          else if (keyCode == Keyboard.LEFT)
          {
             siblings = (selectedHeaderInfo.parent !=null)? selectedHeaderInfo.parent.visibleChildren : visibleHeaderInfos;
             if (selectedHeaderInfo.visibleIndex > 0)
             {
                 newSelectedHeaderInfo = siblings[selectedHeaderInfo.visibleIndex-1];
                 scrollColumnGroupIfNeeded(selectedHeaderInfo, newSelectedHeaderInfo);

                 unselectColumnHeader(headerIndex);
                 selectedHeaderInfo = newSelectedHeaderInfo;
                 headerIndex = newSelectedHeaderInfo.visibleIndex;
                 selectColumnGroupHeader(newSelectedHeaderInfo);
             }
          }
          else if (keyCode == Keyboard.RIGHT)
          {
             siblings = (selectedHeaderInfo.parent !=null)? selectedHeaderInfo.parent.visibleChildren : visibleHeaderInfos;
             if (selectedHeaderInfo.visibleIndex < siblings.length - 1)
             {
                newSelectedHeaderInfo = siblings[selectedHeaderInfo.visibleIndex+1];
                scrollColumnGroupIfNeeded(selectedHeaderInfo, newSelectedHeaderInfo);

                unselectColumnHeader(headerIndex);

                selectedHeaderInfo = newSelectedHeaderInfo;
                headerIndex = newSelectedHeaderInfo.visibleIndex;
                selectColumnGroupHeader(newSelectedHeaderInfo);
             }
          }
          else if (keyCode == Keyboard.SPACE)
          {
              if (sortableColumns && 
                  selectedHeaderInfo.column.colNum != -1 && !isNaN(selectedHeaderInfo.column.colNum)
                  && _columns[selectedHeaderInfo.column.colNum].sortable)
              {
                  isKeyPressed = true;
                  selectColumnHeader(selectedHeaderInfo.column.colNum);
                  
                  var advancedDataGridEvent:AdvancedDataGridEvent =
                      new AdvancedDataGridEvent(AdvancedDataGridEvent.SORT, false, true);
                  
                  advancedDataGridEvent.multiColumnSort      = event.ctrlKey;
                  advancedDataGridEvent.removeColumnFromSort = event.shiftKey;
                  advancedDataGridEvent.columnIndex     = selectedHeaderInfo.column.colNum;//headerIndex;
                  advancedDataGridEvent.dataField       = selectedHeaderInfo.column.dataField;
                  
                  dispatchEvent(advancedDataGridEvent);
              }
          }
          // horizontal scrolling when focus is on header
          else if ( event.shiftKey
                  && (keyCode == Keyboard.PAGE_UP
                     || keyCode == Keyboard.PAGE_DOWN) )
          {
             moveSelectionHorizontally(keyCode, event.shiftKey, event.ctrlKey);
          }
        
          // don't we allow vertical scrolling when focus is on the header?
          // if the focus is on header and we hit page-down/page-up no action would be taken
          // is this fine?
        
          event.stopPropagation();
       }
    } */

    /**
     *  @private
     */
    /* override protected function keyDownHandler(event:KeyboardEvent):void
    {
        // If tab pressed in editor, it'll skip here and go to the keyFocusChangeHandler.
        if (itemEditorInstance || event.target != event.currentTarget)
            return;

        if (isOpening)
        {
            event.stopImmediatePropagation();
            return;
        }

        if (_rootModel is IHierarchicalData) // tree model/view
        {
            // If tree navigation couldn't handle the event, continue looking for a handler.
            if (treeNavigationHandler(event))
                return;
        }

        if (isCellSelectionMode() && headerIndex == -1 && event.keyCode != Keyboard.ESCAPE)
            cellNavigationHandler(event);
        else
            super.keyDownHandler(event);

        if (isRowSelectionMode())
            updateSelectedCells();
    } */

    /**
     *  @private
     */
    /* override protected function keyUpHandler(event:KeyboardEvent):void
    {
        if (isKeyPressed && columnGrouping)
        {
            isKeyPressed = false;
            if (selectedHeaderInfo != null)
                selectColumnHeader(selectedHeaderInfo.column.colNum);
        }
        else
        {
            super.keyUpHandler(event);
        }
    } */

    /**
     *  @private
     */
    /* override protected function editorKeyDownHandler(event:KeyboardEvent):void
    {
        if (event.keyCode == Keyboard.F2)
        {
            // Save data and close editor
            endEdit(AdvancedDataGridEventReason.OTHER);
            setFocus();
            invalidateDisplayList();
        }

        super.editorKeyDownHandler(event);
    } */
    
    /**
     *  @private
     */
    /* override protected function mouseOutHandler(event:MouseEvent):void
    {
        // To handle case when mouse is at the border of the header item
        // renderer. Ignoring prevents flickering of the highlight of the
        // header because of infinite loop of mouseOver and mouseOut events.
        if (event.target == listContent.getChildByName("headerBG"))
            return;

        if (tween)
            return;
		
		if (!visibleColumns || !visibleColumns.length)
			return;

        // mouse-out should remove the "proposed" numeric sort icon
        if (!sortExpertMode)
        {
            var item:IListItemRenderer = mouseEventToItemRenderer(event);
            if (item && item is IDropInListItemRenderer
                    && isHeaderItemRenderer(item))
            {
                var colNum:int = IDropInListItemRenderer(item).listData.columnIndex;
                delete visualSortInfo[colNum];
                delete visualSortInfo["HEADERPART" + colNum];
                invalidateRenderer(item);
            }
        }

        super.mouseOutHandler(event);
    } */

    /**
     *  @private
     */
    /* override protected function mouseOverHandler(event:MouseEvent):void
    {
        if (tween)
            return;

        if (movingColumn)
            return;

        if (!enabled || !selectable)
            return;

        var item:IListItemRenderer = mouseEventToItemRenderer(event);

        if (!sortExpertMode)
        {
            // Mouseover should display a "proposed" numeric sort icon
            var dropInItem:IDropInListItemRenderer;
            if (item)
                dropInItem = item as IDropInListItemRenderer;
            else
                // we're no longer hovering over any headers, so remove the proposed sorts
                visualSortInfo = new Dictionary();

            var colNum:int;
            if (dropInItem && dropInItem.listData)
                colNum = dropInItem.listData.columnIndex;
            if (dropInItem
                    && isHeaderItemRenderer(item)
                    && sortableColumns
                    && colNum != -1
                    && _columns[colNum].sortable
                    && Object(item).hasOwnProperty("mouseEventToHeaderPart") )
            {
                var headerPart:String = Object(item).mouseEventToHeaderPart(event);

                if (!visualSortInfo[colNum] || visualSortInfo["HEADERPART" + colNum] != headerPart)
                {
                    if (headerPart == HEADER_TEXT_PART)
                    {
                        visualSortInfo[colNum] = new SortInfo(1, false, SortInfo.PROPOSEDSORT);
                        invalidateRenderer(item);
                        visualSortInfo["HEADERPART" + colNum] = headerPart;
                    }
                    else if (headerPart == HEADER_ICON_PART)
                    {
                        var sequenceNumber:int;
                        var descending:Boolean;
                        var sortInfo:SortInfo = getFieldSortInfo(_columns[colNum]);
                        if (sortInfo)
                        {
                            sequenceNumber = sortInfo.sequenceNumber;
                            // we want to show the proposed sort
                            // which will always be opposite of the present sort
                            descending     = !sortInfo.descending;
                        }
                        else if (collection && collection.sort && collection.sort.fields
                                && collection.sort.fields.length)
                        {
                            sequenceNumber = collection.sort.fields.length + 1;
                            descending     = false;
                        }
                        else
                        {
                            sequenceNumber = 1;
                            descending = false;
                        }

                        visualSortInfo[colNum] = new SortInfo(sequenceNumber, descending,
                                                                SortInfo.PROPOSEDSORT);
                        invalidateRenderer(item);
                        visualSortInfo["HEADERPART" + colNum] = headerPart;
                    }
                }
            }
        }

        if (item && !isHeaderItemRenderer(item) && isCellSelectionMode())
        {
            // Copied from ListBase.mouseOverHandler()
            var evt:ListEvent;

            var pt:Point = itemRendererToIndices(item);
            if (!pt)
                return;
            isPressed = event.buttonDown;
            var columnIndex:int = displayToAbsoluteColumnIndex(pt.x);

            if (!isPressed || allowDragSelection)
            {
                if (getStyle("useRollOver") && (item.data != null))
                {
                    if (allowDragSelection)
                        bSelectOnRelease = true;

                    var uid:String = itemToUID(item.data);

                    if (visibleCellRenderers[uid])
                        drawCellItem(visibleCellRenderers[uid][columnIndex],
                                     cellSelectionData[uid] &&
                                     cellSelectionData[uid][columnIndex],
                                     true,
                                     uid == caretUID && columnIndex == caretColumnIndex);

                    if (pt) // during tweens, we may get null
                    {
                        evt = new ListEvent(ListEvent.ITEM_ROLL_OVER);
                        evt.columnIndex = pt.x;
                        evt.rowIndex = pt.y;
                        evt.itemRenderer = item;
                        dispatchEvent(evt);
                    }
                }
            }
            else
            {
                if (DragManager.isDragging)
                    return;

                if ((/* dragScrollingInterval != 0 && */ /* allowDragSelection) || menuSelectionMode)
                {
                    if (selectCellItem(item, event.shiftKey, event.ctrlKey))
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
        }
        else
        {
            super.mouseOverHandler(event);
        }
    } */

    /**
     *  @private
     */
    /* override protected function sortHandler(event:AdvancedDataGridEvent):void
    {
        if (event.isDefaultPrevented())
            return;

        if (!sortableColumns
            || isNaN(event.columnIndex) 
            || event.columnIndex == -1 
            || !_columns[event.columnIndex].sortable)
            return;

        if(columnGrouping)
        {
            var columnNumber:int  = event.columnIndex;
            //In case it is a column number, skip, we can't sort a column group
            if(isNaN(columnNumber) ||  columnNumber == -1)
                return;

            var headerInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(_columns[columnNumber]);
            //If this is a leaf column and doesn't get data directly from the data row, but through internalLabelFunction
            if(headerInfo.internalLabelFunction != null)
                event.dataField = null;
        }

        // If navigating header via keyboard, and you mouse click on some
        // other header to sort it, then move the keyboard navigation focus
        // to that column header.
        if (columnGrouping && selectedHeaderInfo != null)
            selectedHeaderInfo = getHeaderInfo(_columns[event.columnIndex]);

        super.sortHandler(event);

        if (isRowSelectionMode())
            updateSelectedCells();
    } */

    /**
     *  @private
     */
    /* override protected function headerReleaseHandler(event:AdvancedDataGridEvent):void
    {
        if (event.isDefaultPrevented())
            return;

        if (itemEditorInstance)
            endEdit(AdvancedDataGridEventReason.OTHER);

        if (sortExpertMode)
        {
            super.headerReleaseHandler(event);
            return;
        }

        var adgEvent:AdvancedDataGridEvent =
            new AdvancedDataGridEvent(AdvancedDataGridEvent.SORT, false, true);

        adgEvent.columnIndex     = event.columnIndex;
        adgEvent.dataField       = event.dataField;
        adgEvent.triggerEvent    = event.triggerEvent;
        adgEvent.multiColumnSort = false;

        if (!collection || !collection.sort || !collection.sort.fields
            || !collection.sort.fields.length) // first sort
        {
            dispatchEvent(adgEvent);
            return;
        }

        if (event.headerPart == HEADER_TEXT_PART)
        {
            dispatchEvent(adgEvent);
        }
        else if (event.headerPart == HEADER_ICON_PART)
        {
            adgEvent.multiColumnSort = true;
            dispatchEvent(adgEvent);
        }
    } */

    /**
     *  @private
     *  Blocks mouse events on items that are tweening away and are invalid for input
     */
    /* override protected function mouseClickHandler(event:MouseEvent):void
    {
        if (!tween && visibleColumns && visibleColumns.length > 0)
            super.mouseClickHandler(event);
    } */

    /**
     *  @private
     *  Blocks mouse events on items that are tweening away and are invalid for input
     */
    /* override protected function mouseDoubleClickHandler(event:MouseEvent):void
    {
        if (!tween && visibleColumns && visibleColumns.length > 0)
            super.mouseDoubleClickHandler(event);
    } */
    
    /**
     *  @private
     */
    /* override protected function mouseDownHandler(event:MouseEvent):void
    {
        if (!tween && visibleColumns && visibleColumns.length > 0)
        {
            super.mouseDownHandler(event);
            updateSelectedCells();
        }
    } */
    
    /**
     *  @private
     *  Blocks mouse events on items that are tweening away and are invalid for input
     */
    /* override protected function mouseUpHandler(event:MouseEvent):void
    {
        if (!tween && visibleColumns && visibleColumns.length > 0)
            super.mouseUpHandler(event);
    } */

    /**
     *  @private
     *  Blocks mouse wheel handling while tween is running
     */
    /* override protected function mouseWheelHandler(event:MouseEvent):void
    {
        if (!tween && visibleColumns && visibleColumns.length > 0)
            super.mouseWheelHandler(event);
    } */
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    /* mx_internal function expandItemHandler(event:AdvancedDataGridEvent):void
    {
        if (event.isDefaultPrevented())
            return;

        if (event.type == AdvancedDataGridEvent.ITEM_OPENING)
        {
            // store the item renderer
            // it is needed while dispatching ITEM_OPEN/ ITEM_CLOSE event
            eventItemRenderer = event.itemRenderer;
            expandItem(event.item, event.opening, event.animate, event.dispatchEvent, event.triggerEvent);
        }
    } */
    
    /**
     * @private
     */
   /*  private function updateCompleteHandler(event:FlexEvent):void
    {
        // Are we running inside Flex Builder design view? Then set hard-coded data.
        if (UIComponentGlobals.designTime)
        {
            if (!dataProvider ||
                    ((dataProvider is ArrayCollection && !ArrayCollection(dataProvider).length) || 
                    (dataProvider is IHierarchicalCollectionView && !IHierarchicalCollectionView(dataProvider).length)))
            {
                setDesignViewData();
            }

            if (designViewDataType == designViewDataTreeType
                    && dataProvider
                    && dataProvider is IHierarchicalCollectionView
                    && (designViewDataFlag
                        || !atLeastOneProperty(IHierarchicalCollectionView(collection).openNodes))
                    )
                    // set if openNodes is empty
            {
                // Open the first branch so that the designer can see
                // how leaf nodes look like as well
                IHierarchicalCollectionView(collection).openNodes
                    = IHierarchicalCollectionView(dataProvider).createCursor().current;
                invalidateProperties();
                invalidateDisplayList();
                designViewDataFlag = false;
            }

            if (designViewDataTypeChanged)
            {
                designViewDataTypeChanged = false; // Make sure we do this to avoid infinite loop
                setDesignViewSort();
            }
        }
    } */
    
    /**
     *  Handler for keyboard navigation for the navigation tree.
     *
     *  @param event The keyboard event.
     *
     *  @return <code>true</code> if the keyboard navigation is handled correctly.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
   /*  protected function treeNavigationHandler(event:KeyboardEvent):Boolean
    {
        var evt:ListEvent;
        var pt:Point;

        // In cell selection mode, caretColumnIndex is valid.
        // In row selection mode, caretColumnIndex is -1, so we should use 0 since the
        // branch node item renderer is in the zeroeth column always.
        var visibleCoords:Object = absoluteToVisibleIndices(caretIndex, 
                                        caretColumnIndex != -1 ? caretColumnIndex : 0);
        var visibleRowIndex:int = visibleCoords.rowIndex;
        var visibleColIndex:int = visibleCoords.columnIndex;
        var item:Object;
        if (listItems[visibleRowIndex] && listItems[visibleRowIndex][visibleColIndex])
            item = listItems[visibleRowIndex][visibleColIndex].data;
        if (!item)
            return false;
            
        var treeItemRenderer:IListItemRenderer;
        
        // get the item renderer to be passed in the ITEM_OPENING events
        if (listItems[visibleRowIndex])
            treeItemRenderer = listItems[visibleRowIndex][treeColumnIndex];
		
		// If rtl layout, need to swap LEFT and RIGHT so correct action
		// is done.
		var keyCode:uint = mapKeycodeForLayoutDirection(event);

        if (event.ctrlKey && event.shiftKey && keyCode == Keyboard.SPACE)
        {
            // if user has moved the caret cursor from the selected item
            // move the cursor back to selected item
            if (caretIndex != selectedIndex)
            {
                // erase the caret
                var renderer:IListItemRenderer = indexToItemRenderer(caretIndex);
                if (renderer)
                    drawItem(renderer);
                caretIndex = selectedIndex;
            }

            // Spacebar toggles the current open/closed status. No effect for leaf items.
            if (isBranch(item))
            {
                var o:Boolean = !isItemOpen(item);
                dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,
                                              item,   //item
                                              treeItemRenderer,   //renderer
                                              event,  //trigger
                                              o,      //opening
                                              true,   //animate
                                              true);  //dispatch
            }
            event.stopImmediatePropagation();
        }
        else if (event.ctrlKey && event.shiftKey && keyCode == Keyboard.LEFT)
        {
            // Left Arrow closes an open item. Otherwise selects the parent item.
            if (isItemOpen(item))
            {
                dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,
                                              item,   //item
                                              treeItemRenderer,   //renderer
                                              event,  //trigger
                                              false,  //opening
                                              true,   //animate
                                              true)   //dispatch
                    }
            else
            {
                selectedItem = getParentItem(item);
                evt = new ListEvent(ListEvent.CHANGE);
                evt.itemRenderer = indexToItemRenderer(selectedIndex);
                pt = itemRendererToIndices(evt.itemRenderer);
                if (pt)
                {
                    evt.rowIndex = pt.y;
                    evt.columnIndex = pt.x;
                }
                dispatchEvent(evt);
                var dI:int = getItemIndex(selectedItem);
                if (dI != caretIndex)
                {
                    caretIndex = selectedIndex;
                }
                if (dI < _verticalScrollPosition)
                {
                    verticalScrollPosition = dI;
                }

            }
            event.stopImmediatePropagation();
        }
        else if (event.ctrlKey && event.shiftKey && keyCode == Keyboard.RIGHT)
        {
            // Right Arrow has no effect on leaf items. Closed branch items are opened. 
            //Opened branch items select the first child.
            if (isBranch(item)) 
            {
                if (isItemOpen(item))
                {
                    if (item)
                    {
                        var children:ICollectionView = getChildren(item, iterator.view);
                        if (children)
                        {
                            var cursor:IViewCursor  = children.createCursor();
                            selectedItem = cursor.current;
                        }
                    }
                    else
                    {
                        selectedItem = null;
                    }
                    if (caretIndex != selectedIndex)
                        caretIndex = getItemIndex(selectedItem);
                    evt = new ListEvent(ListEvent.CHANGE);
                    evt.itemRenderer = indexToItemRenderer(selectedIndex);
                    pt = itemRendererToIndices(evt.itemRenderer);
                    if (pt)
                    {
                        evt.rowIndex = pt.y;
                        evt.columnIndex = pt.x;
                    }
                    dispatchEvent(evt);
                }
                else
                {
                    dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,
                                                  item,   //item
                                                  treeItemRenderer,   //renderer
                                                  event,  //trigger
                                                  true,   //opening
                                                  true,   //animate
                                                  true);  //dispatch
                }

            }
            event.stopImmediatePropagation();
        }
        else if (keyCode == Keyboard.NUMPAD_MULTIPLY)
        {
            expandChildrenOf(item, !isItemOpen(item));
        }
        else if (keyCode == Keyboard.NUMPAD_ADD)
        {
            if (isBranch(item))
            {
                if (!isItemOpen(item))
                {
                    dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,
                                                  item,   //item
                                                  treeItemRenderer,   //renderer
                                                  event,  //trigger
                                                  true,   //opening
                                                  true,   //animate
                                                  true);   //dispatch
                }
            }
        }
        else if (keyCode == Keyboard.NUMPAD_SUBTRACT)
        {
            if (isItemOpen(item))
            {
                dispatchAdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_OPENING,
                                              item, //item
                                              treeItemRenderer,   //renderer
                                              event,  //trigger
                                              false,  //opening
                                              true,   //animate
                                              true);   //dispatch
            }
        }
        else
        {
            return false;
        }

        return true;
    } */
    
    /**
     *  @private
     *  Handle keyboard navigation in cell selection mode
     *  i.e. selectionMode == SINGLE_CELL || selectionMode == MULTIPLE_CELLS
     */
    /* protected function cellNavigationHandler(event:KeyboardEvent):void
    {
		// If rtl layout, need to swap LEFT and RIGHT so correct action
		// is done.
		var keyCode:uint = mapKeycodeForLayoutDirection(event);
		
        // Can't use a straight-forward Object/Dictionary
        // because they don't allow integer keys.
        const validKeys:Array = [
            Keyboard.UP,
            Keyboard.DOWN,
            Keyboard.LEFT,
            Keyboard.RIGHT,
            Keyboard.SPACE,
            Keyboard.HOME,
            Keyboard.END,
            Keyboard.PAGE_UP,
            Keyboard.PAGE_DOWN,
            Keyboard.F2
            ];

        var isValidKey:Boolean = false;
        var n:int = validKeys.length;
        for (var i:int = 0; i < n; i++)
        {
            if (keyCode == validKeys[i])
            {
                isValidKey = true;
                break;
            }
        }

        if (!isValidKey)
        {
            // Handles single-character type-ahead lookup for data in the rows.
            if (findKey(keyCode))
                event.stopPropagation();

            return;
        }

        var bUpdateHorizontalScrollPosition:Boolean = false;
        var bUpdateVerticalScrollPosition:Boolean   = false;
        var newVerticalScrollPosition:Number;
        var newHorizontalScrollPosition:Number;
        var maxPosition:int;

        var rowCount:int = listItems.length;
        if (rowCount == 0)
            return;

        var partialRow:int = 0;
        if (rowInfo[rowCount - 1].y +
            rowInfo[rowCount - 1].height > listContent.height)
        {
            partialRow++;
        }

        showCaret   = true;
        bSelectItem = false;

        var newCaretColumnIndex:int;

        switch (keyCode)
        {
            case Keyboard.UP:
            {
                if (caretIndex == 0 && selectedIndex == 0 && headerVisible
                    && !event.ctrlKey && !event.shiftKey) // move to header
                {
                    var oldCaretColumnIndex:int = caretColumnIndex;
                    clearSelectedCells();
                    moveFocusToHeader(oldCaretColumnIndex);
                }
                else if (caretIndex > 0)
                {
                    // if the first column of the column span is hidden from view,
                    // then we move to the first visible column
                    if (visibleColumns.length > 0 && visibleColumns[0].colNum > caretColumnIndex)
                        caretColumnIndex = visibleColumns[0].colNum;
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
                    // When focus is on ADG and down arrow is pressed, focus
                    // should go to the first visible cell
                    if (caretIndex == 0)
                        caretColumnIndex = 0;
                     // if the first column of the column span is hidden from view,
                    // then we move to the first visible column
                    else if (visibleColumns.length > 0 && visibleColumns[0].colNum > caretColumnIndex)
                        caretColumnIndex = visibleColumns[0].colNum;

                    bUpdateVerticalScrollPosition = true;
                    bSelectItem = true;
                }
                else if ( (caretIndex == collection.length - 1) && partialRow )
                {
                    if (verticalScrollPosition < maxVerticalScrollPosition)
                        newVerticalScrollPosition = verticalScrollPosition + 1;
                }
                break;
            }

            case Keyboard.LEFT:
            {
                newCaretColumnIndex =
                    viewDisplayableColumnAtOffset(caretColumnIndex, -1, caretIndex);
                if (newCaretColumnIndex != -1)
                {
                    caretColumnIndex = newCaretColumnIndex;
                    bSelectItem = true;
                }
                break;
            }

            case Keyboard.RIGHT:
            {
                newCaretColumnIndex =
                    viewDisplayableColumnAtOffset(caretColumnIndex, +1, caretIndex);
                if (newCaretColumnIndex != -1)
                {
                    caretColumnIndex = newCaretColumnIndex;
                    bSelectItem = true;
                }
                break;
            }

            case Keyboard.SPACE:
            {
                // ctrl-space selects (and unselects) item
                bSelectItem = event.ctrlKey;
                break;
            }

            case Keyboard.HOME:
            case Keyboard.END:
            case Keyboard.PAGE_UP:
            case Keyboard.PAGE_DOWN:
            {
                moveSelectionVertically(keyCode, event.shiftKey, event.ctrlKey);
                break;
            }

            case Keyboard.F2:
            {
                if (caretColumnIndex != -1)
                {
                    var newData:Object = rowNumberToData(caretIndex);
                    if (newData && isDataEditable(newData) && displayableColumns[caretColumnIndex].editable)
                    {
                        // Open editor
                        var advancedDataGridEvent:AdvancedDataGridEvent
                                = new AdvancedDataGridEvent(
                                        AdvancedDataGridEvent.ITEM_EDIT_BEGINNING,
                                                        false, true);
                        // ITEM_EDIT events are cancelable
                        advancedDataGridEvent.columnIndex = caretColumnIndex;
                        advancedDataGridEvent.dataField = _columns[caretColumnIndex].dataField;
                        advancedDataGridEvent.rowIndex = caretIndex;

                        var visibleCoords:Object
                            = absoluteToVisibleIndices(caretIndex, caretColumnIndex);
                        var visibleRowIndex:int = visibleCoords.rowIndex;
                        var visibleColIndex:int = visibleCoords.columnIndex;
                        advancedDataGridEvent.itemRenderer
                            = listItems[visibleRowIndex][visibleColIndex];
                        dispatchEvent(advancedDataGridEvent);
                    }
                }
                break;
            }
        }

        event.stopPropagation();

        if (bUpdateVerticalScrollPosition)
        {
            if (caretIndex < lockedRowCount)
            {
                newVerticalScrollPosition = 0;
            }
            else if (caretIndex < verticalScrollPosition + lockedRowCount)
            {
                newVerticalScrollPosition = caretIndex - lockedRowCount;
            }
            else if (caretIndex >= verticalScrollPosition + rowCount - partialRow)
            {
                newVerticalScrollPosition = Math.min(maxVerticalScrollPosition,
                                                     caretIndex - rowCount + partialRow + 1);
            }

            if (!isNaN(newVerticalScrollPosition))
            {
                if (verticalScrollPosition != newVerticalScrollPosition)
                {
                    var se:ScrollEvent     = new ScrollEvent(ScrollEvent.SCROLL);
                    se.detail              = ScrollEventDetail.THUMB_POSITION;
                    se.direction           = ScrollEventDirection.VERTICAL;
                    se.delta               = newVerticalScrollPosition - verticalScrollPosition;
                    se.position            = newVerticalScrollPosition;
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
        }

        bShiftKey = event.shiftKey;
        bCtrlKey  = event.ctrlKey;
        lastKey   = keyCode;

        finishCellKeySelection();
    }    */
	
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
        return IDataGridModel(model).columns;
    }
    /**
     * @royaleignorecoercion org.apache.royale.core.IDataGridModel
     */
    public function set columns(value:Array):void
    {
        IDataGridModel(model).columns = value;
        for each (var col:DataGridColumn in value)
        {
            col.owner = this;
        }
    }

	//----------------------------------
    //  selectionMode  copied from AdvancedDataGridBase
    //----------------------------------
    
    /**
     *  @private
     */
    protected var _selectionMode:String = "singleRow"; 	// SINGLE_ROW;

    [Inspectable(category="General",
        enumeration="none,singleRow,multipleRows,singleCell,multipleCells",
        defaultValue="singleRow")]
    /**
     *  The selection mode of the control. Possible values are:
     *  <code>MULTIPLE_CELLS</code>, <code>MULTIPLE_ROWS</code>, <code>NONE</code>, 
     *  <code>SINGLE_CELL</code>, and <code>SINGLE_ROW</code>.
     *  Changing the value of this property 
     *  sets the <code>selectedCells</code> property to null.
     *
     *  <p>You must set the <code>allowMultipleSelection</code> property to <code>true</code> 
     *  to select more than one item in the control at the same time.</p> 
     *
     *  <p>Information about the selected cells is written to the <code>selectedCells</code> property.</p>
     *
     *  @default SINGLE_ROW
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function get selectionMode():String
    {
        return _selectionMode;
    }

    public function set selectionMode(value:String):void
    {
        /* setSelectionMode(value);
        itemsSizeChanged = true;
        invalidateDisplayList(); */
    }
	
	//----------------------------------
    //  sortableColumns copied from AdvancedDataGridBaseEx
    //----------------------------------

    private var _sortableColumns:Boolean = true;
    
    // [Inspectable(category="General")]

    /**
     *  A flag that indicates whether the user can sort the data provider items
     *  by clicking on a column header cell.
     *  If <code>true</code>, the user can sort the data provider items by
     *  clicking on a column header cell. 
     *  The <code>AdvancedDataGridColumn.dataField</code> property of the column
     *  or the <code>AdvancedDataGridColumn.sortCompareFunction</code> property 
     *  of the column is used as the sort field.  
     *  If a column is clicked more than once, 
     *  the sort alternates between ascending and descending order.
     *  If <code>true</code>, individual columns can be made to not respond
     *  to a click on a header by setting the column's <code>sortable</code>
     *  property to <code>false</code>.
     *
     *  <p>When a user releases the mouse button over a header cell, the AdvancedDataGrid
     *  control dispatches a <code>headerRelease</code> event if both
     *  this property and the column's sortable property are <code>true</code>.  
     *  If no handler calls the <code>preventDefault()</code> method on the event, the 
     *  AdvancedDataGrid sorts using that column's <code>AdvancedDataGridColumn.dataField</code> or  
     *  <code>AdvancedDataGridColumn.sortCompareFunction</code> properties.</p>
     * 
     *  @default true
     *
     *  @see mx.controls.advancedDataGridClasses.AdvancedDataGridColumn#dataField
     *  @see mx.controls.advancedDataGridClasses.AdvancedDataGridColumn#sortCompareFunction
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
	 */
    public function get sortableColumns():Boolean
    {
        return _sortableColumns;
    }
    public function set sortableColumns(value:Boolean):void
    {
        _sortableColumns = value;
    }
	
    //----------------------------------
    //  sortExpertMode copied from AdvancedDataGridBaseEx
    //----------------------------------

    // Type of sorting UI displayed
    private var _sortExpertMode:Boolean = false;

    /**
     *  By default, the <code>sortExpertMode</code> property is set to <code>false</code>, 
     *  which means you click in the header area of a column to sort the rows of 
     *  the AdvancedDataGrid control by that column. 
     *  You then click in the multiple-column sort area of the header to sort by additional columns. 
     *  If you set the <code>sortExpertMode</code> property to <code>true</code>, 
     *  you use the Control key to select every column after the first column to perform sort.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    [Inspectable(enumeration="true,false", defaultValue="false")]
    public function get sortExpertMode():Boolean
    {
        return _sortExpertMode;
    }

    /**
     *  @private
     */
    public function set sortExpertMode(value:Boolean):void
    {
        _sortExpertMode = value;

       /*  invalidateHeaders();
        invalidateProperties();
        invalidateDisplayList(); */
    }
	
	
	//----------------------------------
    //  headerHeight copied from AdvancedDataGridBase
    //----------------------------------

    /**
     *  @private
     *  Storage for the headerHeight property.
     */
    /* mx_internal */ private var _headerHeight:Number = 22;

    [Bindable("resize")]
    //[Inspectable(category="General", defaultValue="22")]

    /**
     *  The height of the header cell of the column, in pixels.
     *  If set explicitly, that height will be used for all of
     *  the headers.  If not set explicitly, 
     *  the height will based on style settings and the header
     *  renderer.  
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
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

        invalidateDisplayList(); */
    }
	//----------------------------------
    //  headerWordWrap copied from AdvancedDataGridBase
    //----------------------------------

    /**
     *  @private
     *  Storage for the headerWordWrap property.
     */
    private var _headerWordWrap:Boolean;

    // [Inspectable(category="General")]

    /**
     *  If <code>true</code>, specifies that text in the header is
     *  wrapped if it does not fit on one line.
     *  
     *  If the <code>headerWordWrap</code> property is set in AdvancedDataGridColumn,
     *  this property will not have any effect.
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function get headerWordWrap():Boolean
    {
        return _headerWordWrap;
    }

    /**
     *  @private
     */
    public function set headerWordWrap(value:Boolean):void
    {        
        if (value == _headerWordWrap)
            return;

        _headerWordWrap = value;

        /* itemsSizeChanged = true;

        invalidateDisplayList();

        dispatchEvent(new Event("headerWordWrapChanged")); */
    }
	//----------------------------------
    //  draggableColumns copied from AdvancedDataGridBaseEx
    //----------------------------------

    /**
     *  @private
     *  Storage for the draggableColumns property.
     */
    private var _draggableColumns:Boolean = true;

    [Inspectable(defaultValue="true")]

    /**
     *  Indicates whether you are allowed to reorder columns.
     *  If <code>true</code>, you can reorder the columns
     *  of the AdvancedDataGrid control by dragging the header cells.
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
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
	    
	public function get HeaderStyleName():Object
    {
        trace("HeaderStyleName not implemented");
        return 0;
    }
	
	
    public function set HeaderStyleName(value:Object):void
    {
        trace("HeaderStyleName not implemented");
    }

	
	//----------------------------------
    //  resizableColumns copied from AdvancedDataGridBaseEx
    //----------------------------------

    private var _resizableColumns:Boolean = true;
    
   // [Inspectable(category="General")]

    /**
     *  A flag that indicates whether the user can change the size of the
     *  columns.
     *  If <code>true</code>, the user can stretch or shrink the columns of 
     *  the AdvancedDataGrid control by dragging the grid lines between the header cells.
     *  If <code>true</code>, individual columns must also have their 
     *  <code>resizeable</code> properties set to <code>false</code> to 
     *  prevent the user from resizing a particular column.  
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.4
     */
    public function get resizableColumns():Boolean
    {
        return _resizableColumns;
    }
    public function set resizableColumns(value:Boolean):void
    {
        _resizableColumns = value;
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
    public function get presentationModel():IBead
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
   
    public function destroyItemEditor():void
	{
	
	}
	
    override public function addedToParent():void
    {
        super.addedToParent();
        
        addBead(new AdvancedDataGridSortBead());            
        addEventListener(AdvancedDataGridEvent.SORT, sortHandler);
    }
    
    protected function sortHandler(event:AdvancedDataGridEvent):void
    {
        var oldSort:ISort = collection.sort;
        
        var sort:Sort = new Sort();
        var sortField:SortField = new SortField();
        sortField.name = event.dataField;
        var column:DataGridColumn = columns[event.columnIndex] as DataGridColumn;
        if (oldSort && oldSort.fields[0].name == sortField.name)
            column.sortDescending = !column.sortDescending;
        sortField.descending = column.sortDescending;
        
        sort.fields = [ sortField ];
        collection.sort = sort;
        collection.refresh();
        // force redraw of column headers
        ((view as AdvancedDataGridView).header as DataGridButtonBar).model.dispatchEvent(new Event("dataProviderChanged"));
    }
    

}

}
