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

package spark.components.gridClasses
{
	/*import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Timer;*/
	
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import mx.events.FocusEvent;
	import mx.events.KeyboardEvent;
	import mx.events.MouseEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
	import mx.core.Keyboard;
	import org.apache.royale.utils.Timer;
	
	
	import mx.core.ClassFactory;
	import mx.core.EventPriority;
	import mx.core.IFactory;
	import mx.core.IIMESupport;
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.events.SandboxMouseEvent;
	import mx.managers.FocusManager;
	import mx.managers.IFocusManager;
	import mx.managers.IFocusManagerComponent;
	import mx.styles.ISimpleStyleClient;
	
	import spark.components.DataGrid;
	import spark.components.Grid;
	import spark.components.gridClasses.GridItemEditorActivationMouseEvent;
	import spark.events.GridEvent;
	import spark.events.GridItemEditorEvent;
	
	use namespace mx_internal;
	
	
	/**
	 *  The DataGridEditor contains all the logic and event handling needed to 
	 *  manage the life cycle of an item editor. 
	 *  A DataGridEditor is owned by a 
	 *  specified DataGrid. The owning DataGrid is responsible for calling
	 *  initialize() to enable editing and uninitialize() when editing is no 
	 *  longer needed.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	public class DataGridEditor
	{
		// include "../../core/Version.as";    
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor
		 * 
		 *  @param dataGrid The owner of this editor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function DataGridEditor(dataGrid:DataGrid)
		{
			_dataGrid = dataGrid;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		/**
		 *  @private
		 *  Timer used to cancel edits if a double click occurs.
		 */
		private var doubleClickTimer:Timer;
		
		/**
		 *  @private
		 *  True if we have received double click event since the last click.
		 */
		private var gotDoubleClickEvent:Boolean;
		
		/**
		 *  @private
		 *  True if we have received a FlexEvent.ENTER.
		 */
		private var gotFlexEnterEvent:Boolean;
		
		/**
		 *  @private
		 */
		private var lastEvent:Event;
		
		/**
		 *  @private
		 *  Position of the last item renderer that was clicked.
		 */
		private var lastItemClickedPosition:Object;
		
		/**
		 *  @private
		 *  Used to make sure the mouse up is on the same item
		 *  renderer as the mouse down.
		 */
		private var lastItemDown:IVisualElement;
		
		/**
		 *  @private
		 *  the last editedItemPosition and the last
		 *  position where editing was attempted if editing
		 *  was cancelled.  
		 */
		private var lastEditedItemPosition:*;
		
		/**
		 *  @private
		 *  Determines if the hasFocusableChildren flags are restored when
		 *  an editor is destroyed. This is set to false when we know we will
		 *  be starting up another editor immeditiately. By not restoring
		 *  the tab children flag we will be saving FocusManager from removing
		 *  and then adding all the focusable children of the data grid.
		 */
		private var restoreFocusableChildren:Boolean = true;
		
		/**
		 *  @private
		 *  Used to restore the value of DataGrid's hasFocusableChildren.
		 */
		private var saveDataGridHasFocusableChildren:Boolean;
		
		/**
		 *  @private
		 *  Used to restore the value of scroller's hasFocusableChildren.
		 */
		private var saveScrollerHasFocusableChildren:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private var _dataGrid:DataGrid;
		
		/**
		 *  Reference to the <code>DataGrid</code> that created the editor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get dataGrid():DataGrid
		{
			return _dataGrid;    
		}
		
		/**
		 *  Convenience property to get the <code>Grid</code> associated with the parent <code>DataGrid</code>.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get grid():Grid
		{
			return _dataGrid.grid;        
		}
		
		//----------------------------------
		//  editedItemPosition
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _editedItemPosition:Object;
		
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
		 *  Sets the edited item position based on the grids <code>rowIndex</code> and <code>columnIndex</code>.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function set editedItemPosition(value:Object):void
		{
			if (!value)
			{
				setEditedItemPosition(null);
				return;
			}
			
			var newValue:Object = {rowIndex: value.rowIndex,
				columnIndex: value.columnIndex};
			
			setEditedItemPosition(newValue);
		}
		
		/**
		 *  @private
		 */
		private function setEditedItemPosition(coord:Object):void
		{
			if (!grid.enabled || !dataGrid.editable)
				return;
			
			if (!grid.dataProvider || grid.dataProvider.length == 0)
				return;
			
			// just give focus back to the itemEditorInstance
			if (itemEditorInstance && coord &&
				itemEditorInstance is IFocusManagerComponent &&
				_editedItemPosition.rowIndex == coord.rowIndex &&
				_editedItemPosition.columnIndex == coord.columnIndex)
			{
				IFocusManagerComponent(itemEditorInstance).setFocus();
				return;
			}
			
			// dispose of any existing editor, saving away its data first
			if (itemEditorInstance)
			{
				if (!dataGrid.endItemEditorSession())
					return;
			}
			
			// store the value
			_editedItemPosition = coord;
			
			// allow setting of undefined to dispose item editor instance
			if (!coord)
				return;
			
			var rowIndex:int = coord.rowIndex;
			var columnIndex:int = coord.columnIndex;
			
			dataGrid.ensureCellIsVisible(rowIndex, columnIndex);
			
			createItemEditor(rowIndex, columnIndex);
			
			if (itemEditorInstance is IInvalidating)
				IInvalidating(itemEditorInstance).validateNow();
			
			var column:GridColumn = dataGrid.columns.getItemAt(columnIndex) as GridColumn;
			if (itemEditorInstance is IIMESupport)
				IIMESupport(itemEditorInstance).imeMode =
					(column.imeMode == null) ? dataGrid.imeMode : column.imeMode;
			
			var fm:IFocusManager = grid.focusManager;
			if (itemEditorInstance is IFocusManagerComponent)
			{
				// Temporarily remove the FOCUS_OUT handler: if we give the editor the focus and
				// it immediately vectors it to a non-editor descendant, like to the mobile soft 
				// keyboard, we don't want to end the editor session.
				
				// itemEditorInstance.removeEventListener(FocusEvent.FOCUS_OUT, editor_focusOutHandler);            
				fm.setFocus(IFocusManagerComponent(itemEditorInstance));
				// itemEditorInstance.addEventListener(FocusEvent.FOCUS_OUT, editor_focusOutHandler);             
			}
			
			lastEditedItemPosition = _editedItemPosition;
			
			// Notify event that a new editor is starting.
			// Don't dispatch life cycle events for item renderers.
			var dataGridEvent:GridItemEditorEvent = null;
			
			if (column.rendererIsEditable == false)
				dataGridEvent = new GridItemEditorEvent(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_START);
			
			if (dataGridEvent)
			{
				dataGridEvent.columnIndex = editedItemPosition.columnIndex;
				dataGridEvent.column = column;
				dataGridEvent.rowIndex = editedItemPosition.rowIndex;
				dataGrid.dispatchEvent(dataGridEvent);
			}
		}
		
		/**
		 *  @private
		 *  true if we're in the endEdit call.  Used to handle
		 *  some timing issues with collection updates
		 */
		private var inEndEdit:Boolean = false;
		
		/**
		 *  A reference to the currently active instance of the item editor, 
		 *  if it exists.
		 *
		 *  <p>To access the item editor instance and the new item value when an 
		 *  item is being edited, you use the <code>itemEditorInstance</code> 
		 *  property. The <code>itemEditorInstance</code> property
		 *  is not valid until after the event listener for
		 *  the <code>itemEditBegin</code> event executes. Therefore, you typically
		 *  only access the <code>itemEditorInstance</code> property from within 
		 *  the event listener for the <code>itemEditEnd</code> event.</p>
		 *
		 *  <p>The <code>DataGridColumn.itemEditor</code> property defines the
		 *  class of the item editor
		 *  and, therefore, the data type of the item editor instance.</p>
		 *
		 *  <p>You do not set this property in MXML.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
         * 
         *  @royalesuppresspublicvarwarning
		 */
		public var itemEditorInstance:IGridItemEditor;
		
		
		/**
		 *  @private
		 */
		private var _editedItemRenderer:IVisualElement;
		
		/**
		 *  A reference to the item renderer
		 *  in the DataGrid control whose item is currently being edited.
		 *
		 *  <p>From within an event listener for the <code>itemEditBegin</code>
		 *  and <code>itemEditEnd</code> events,
		 *  you can access the current value of the item being edited
		 *  using the <code>editedItemRenderer.data</code> property.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get editedItemRenderer():IVisualElement
		{
			return _editedItemRenderer;
		}
		
		//----------------------------------
		//  editorColumnIndex
		//----------------------------------
		
		/**
		 *  The zero-based column index of the cell that is being edited. The 
		 *  value is -1 if no cell is being edited.
		 * 
		 *  @default -1
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 4.5
		 */
		public function get editorColumnIndex():int
		{
			if (editedItemPosition)
				return editedItemPosition.columnIndex;
			
			return -1;
		}
		
		//----------------------------------
		//  editorRowIndex
		//----------------------------------
		
		/**
		 *  The zero-based row index of the cell that is being edited. The 
		 *  value is -1 if no cell is being edited.
		 * 
		 *  @default -1
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 4.5
		 */
		public function get editorRowIndex():int
		{
			if (editedItemPosition)
				return editedItemPosition.rowIndex;
			
			return -1;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Called by the <code>DataGrid</code> after construction to initialize the editor. No
		 *  item editors can be created until after this method is called.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */  
		public function initialize():void
		{
			// add listeners to enable cell editing
			var grid:Grid = dataGrid.grid;
			
			dataGrid.addEventListener(KeyboardEvent.KEY_DOWN, dataGrid_keyboardDownHandler);
			
			// Make sure we get first shot at mouse events before selection is changed. We use 
			// this is test if you are clicking on a selected row or not.
			grid.addEventListener(GridEvent.GRID_MOUSE_DOWN, grid_gridMouseDownHandler, false, 1000);
			grid.addEventListener(GridEvent.GRID_MOUSE_UP, grid_gridMouseUpHandler, false, 1000);
			grid.addEventListener(GridEvent.GRID_DOUBLE_CLICK, grid_gridDoubleClickHandler);
			// grid.addEventListener(MouseEvent.MOUSE_WHEEL, grid_gridMouseWheelHandler, false, 0);
		}
		
		/**
		 *  The method is called to disable item editing on the <code>DataGrid</code>.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */ 
		public function uninitialize():void
		{
			// remove listeners to disable cell editing   
			grid.removeEventListener(KeyboardEvent.KEY_DOWN, dataGrid_keyboardDownHandler);
			grid.removeEventListener(GridEvent.GRID_MOUSE_DOWN, grid_gridMouseDownHandler);
			grid.removeEventListener(GridEvent.GRID_MOUSE_UP, grid_gridMouseUpHandler);
			grid.removeEventListener(GridEvent.GRID_DOUBLE_CLICK, grid_gridDoubleClickHandler);
			//grid.removeEventListener(MouseEvent.MOUSE_WHEEL, grid_gridMouseWheelHandler);
		}
		
		/**
		 *  @private
		 *  
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
		mx_internal function destroyItemEditor():void
		{
			// trace("destroyItemEditor");
			/*if (grid.root)
			grid.systemManager.removeEventListener(Event.DEACTIVATE, deactivateHandler);*/
			
			/*grid.systemManager.getSandboxRoot().
			removeEventListener(MouseEvent.MOUSE_DOWN, sandBoxRoot_mouseDownHandler, true);
			grid.systemManager.getSandboxRoot().
			removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, sandBoxRoot_mouseDownHandler);
			grid.systemManager.removeEventListener(Event.RESIZE, editorAncestorResizeHandler);
			dataGrid.removeEventListener(Event.RESIZE, editorAncestorResizeHandler);*/
			
			if (itemEditorInstance || editedItemRenderer)
			{
				if (itemEditorInstance)
					itemEditorInstance.discard();
				
				var o:IVisualElement = (itemEditorInstance ? 
					itemEditorInstance : editedItemRenderer);
				
				o.removeEventListener(KeyboardEvent.KEY_DOWN, editor_keyDownHandler);
				// o.removeEventListener(FocusEvent.FOCUS_OUT, editor_focusOutHandler);
				// o.removeEventListener(Event.REMOVED_FROM_STAGE, editor_removedFromStageHandler);
				// o.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, editor_keyFocusChangeHandler);
				// addRemoveFlexEventEnterListener(DisplayObject(o), false);
				
				/*if (grid.focusManager)
				grid.focusManager.defaultButtonEnabled = true;*/
				
				// setfocus back to us so something on stage has focus
				dataGrid.setFocus();
				
				// defer focus can cause focusOutHandler to destroy the editor
				// and make itemEditorInstance null
				/*if (itemEditorInstance)
				grid.removeElement(itemEditorInstance);
				else
				grid.invalidateDisplayList();   // force the editorIndicator to be redrawn
				*/
				if (restoreFocusableChildren)
				{
					restoreFocusableChildrenFlags();
				}
				
				itemEditorInstance = null;
				_editedItemRenderer = null;
				_editedItemPosition = null;
			}
		}
		
		/**
		 *  @private
		 * 
		 *  Creates the item editor for the item renderer at the
		 *  <code>editedItemPosition</code> using the editor
		 *  specified by the <code>itemEditor</code> property.
		 *
		 *  <p>This method sets the editor instance as the 
		 *  <code>itemEditorInstance</code> property.</p>
		 *
		 *  @param rowIndex The row index in the data provider of the item to be edited.
		 *  @param columnIndex The column index in the data provider of the item to be edited.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal function createItemEditor(rowIndex:int, columnIndex:int):void
		{
			// check for bad values
			if (columnIndex >= grid.columns.length)
				return;
			
			var col:GridColumn = grid.columns.getItemAt(columnIndex) as GridColumn;
			var item:IGridItemRenderer = null;//grid.getItemRendererAt(rowIndex, columnIndex);
			var cellBounds:Rectangle = grid.getCellBounds(rowIndex,columnIndex);
			var localCellOrigin:Point = cellBounds.topLeft;
			
			_editedItemRenderer = item;
			
			// Need to turn on focusable children flag so focus manager will
			// allow focus into the data grid's children.
			if (restoreFocusableChildren)
				saveDataGridHasFocusableChildren = dataGrid.hasFocusableChildren; 
			dataGrid.hasFocusableChildren = true;
			
			if (dataGrid.scroller)
			{
				//Correct the item edit positioning based on the scroll position.
				localCellOrigin.x -= grid.horizontalScrollPosition;
				localCellOrigin.y -= grid.verticalScrollPosition;
				
				if (restoreFocusableChildren)
					saveScrollerHasFocusableChildren = dataGrid.scroller.hasFocusableChildren; 
				dataGrid.scroller.hasFocusableChildren = true;
			}
			
			restoreFocusableChildren = true;
			
			if (!col.rendererIsEditable)
			{
				// First use the column's itemEditor.
				// If that is unspecified try the dataGrid's itemEditor.
				// If that is unspecified then use the default itemEditor
				// set on the column.
				var itemEditor:IFactory = col.itemEditor;
				if (!itemEditor)
					itemEditor = dataGrid.itemEditor;
				/*if (!itemEditor)
				itemEditor = GridColumn.defaultItemEditorFactory;
				
				if (itemEditor == GridColumn.defaultItemEditorFactory)
				{
				// if it is the default factory, see if someone
				// overrode it with this style
				var c:Class = dataGrid.getStyle("defaultDataGridItemEditor");
				if (c)
				{
				itemEditor = col.itemEditor = new ClassFactory(c);
				}
				}*/
				
				itemEditorInstance = itemEditor.newInstance();
				itemEditorInstance.owner = dataGrid;
				itemEditorInstance.rowIndex = rowIndex;
				itemEditorInstance.column = col;
				itemEditorInstance.hasFocusableChildren = true;
				
				/*if (itemEditorInstance is ISimpleStyleClient)
				ISimpleStyleClient(itemEditorInstance).styleName = item;*/
				
				// Add the editor to the grid before setting the data so that
				// the editor's children will be created.
				// grid.addElement(itemEditorInstance);
				
				itemEditorInstance.data = item.data;
				
				// The editor will overlay the cell, covering the first pixel of the 
				// cell separators. This is done so that a cell editor with borders 
				// will overlay the cell separators. It prevents the cell separators
				// from adding borders to the editor for the common case when the cell
				// separators are only 1 pixel wide.
				itemEditorInstance.width = cellBounds.width + 1;
				itemEditorInstance.height = cellBounds.height + 1;
				itemEditorInstance.setLayoutBoundsPosition(localCellOrigin.x, localCellOrigin.y);
				
				if (itemEditorInstance is IInvalidating)
					IInvalidating(itemEditorInstance).validateNow();
				
				// Allow the user code to make any final adjustments and make the editor visible.
				itemEditorInstance.prepare();
				itemEditorInstance.visible = true;
			}
			else
			{
				setFocusInItemRenderer(item);
			}
			
			if (itemEditorInstance || editedItemRenderer)
			{
				var editor:IEventDispatcher = itemEditorInstance ? itemEditorInstance : editedItemRenderer;
				
				// editor.addEventListener(FocusEvent.FOCUS_OUT, editor_focusOutHandler);
				// editor.addEventListener(Event.REMOVED_FROM_STAGE, editor_removedFromStageHandler);
				// listen for keyStrokes on the itemEditorInstance (which lets the grid supervise for ESC/ENTER)
				editor.addEventListener(KeyboardEvent.KEY_DOWN, editor_keyDownHandler);
				// editor.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, editor_keyFocusChangeHandler, false, 1000);
				// addRemoveFlexEventEnterListener(DisplayObject(editor), true);
				
			}
			
			/*if (grid.focusManager)
			grid.focusManager.defaultButtonEnabled = false;*/
			
			// Invalidate the grid so the editor indicator will be shown.
			grid.invalidateDisplayList();
			
			/*if (grid.root)
			grid.systemManager.addEventListener(Event.DEACTIVATE, deactivateHandler, false, 0, true);*/
			
			// we disappear on any mouse down outside the editor
			/*grid.systemManager.getSandboxRoot().
			addEventListener(MouseEvent.MOUSE_DOWN, sandBoxRoot_mouseDownHandler, true, 0, true);
			grid.systemManager.getSandboxRoot().
			addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE, sandBoxRoot_mouseDownHandler, false, 0, true);
			// we disappear if stage or our grid is resized
			grid.systemManager.addEventListener(Event.RESIZE, editorAncestorResizeHandler);
			grid.addEventListener(Event.RESIZE, editorAncestorResizeHandler);*/        
		}
		
		/**
		 *  @private
		 */ 
		private function setFocusInItemRenderer(item:IGridItemRenderer):void
		{
			// if the item renderer is editable then set focus
			// to the first item that should get focus.
			/*if (grid.focusManager && grid.focusManager is FocusManager)
			{
			var fm:FocusManager = grid.focusManager as FocusManager;
			var o:DisplayObject = item as DisplayObject;
			var firstComponent:DisplayObject = null;
			var found:Boolean = false;
			
			// find the first component to take focus inside the renderer.
			do
			{
			fm.fauxFocus = o;
			o = fm.getNextFocusManagerComponent(false) as DisplayObject;
			if (o == item || 
			item is DisplayObjectContainer && 
			DisplayObjectContainer(item).contains(o))
			{
			found = true;
			break;
			}
			
			// prevent infinite loop
			if (!firstComponent)
			firstComponent = o;
			else if (firstComponent == o)
			break;
			
			} while (o && dataGrid.contains(o));
			
			// if we are moving backward then put focus on the last
			// item in the renderer instead of the first.
			if (found && wasLastEventMovingBackward())
			{
			// put focus on last item in cell editor instead of first.
			var lastItem:DisplayObject = o;
			do
			{
			fm.fauxFocus = o;
			lastItem = o;
			o = fm.getNextFocusManagerComponent(false) as DisplayObject;
			} while (o && DisplayObjectContainer(item).contains(o));
			
			o = lastItem;
			}
			
			fm.fauxFocus = null;
			
			if (found)
			{
			fm.setFocus(IFocusManagerComponent(o));
			
			// Since we may have gotton here with the F2 key show the focus
			// indicator to make it obvious which control has focus.
			fm.showFocus();
			}
			}*/
		}
		
		/**
		 *  @private
		 */
		private function wasLastEventMovingBackward():Boolean
		{
			if (lastEvent)
			{
				// Last event was a key focus change moving backward.
				/*if (lastEvent.type == FocusEvent.KEY_FOCUS_CHANGE &&
				FocusEvent(lastEvent).shiftKey)
				{
				return true;
				}*/
				
				// Last event was Shift+TAB
				if (lastEvent.type == KeyboardEvent.KEY_DOWN && 
					KeyboardEvent(lastEvent).keyCode == Keyboard.TAB &&
					KeyboardEvent(lastEvent).shiftKey)
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 *  Start editing a cell for a specified row and column index.
		 *  
		 *  Dispatches a <code>GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_STARTING
		 *  </code> event. 
		 * 
		 *  @param rowIndex The zero-based row index of the cell to edit.
		 * 
		 *  @param columnIndex The zero-based column index of the cell to edit.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function startItemEditorSession(rowIndex:int, columnIndex:int):Boolean
		{
			
			// validate row and column index
			if (!isValidCellPosition(rowIndex, columnIndex))
				return false;
			
			dataGrid.addEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_STARTING,
				dataGrid_gridItemEditorSessionStartingHandler,
				false, EventPriority.DEFAULT_HANDLER);
			
			var column:GridColumn = grid.columns.getItemAt(columnIndex) as GridColumn;
			
			if (!column || !column.visible)
				return false;
			
			// The START_GRID_ITEM_EDITOR_SESSION event is cancelable
			var dataGridEvent:GridItemEditorEvent = new GridItemEditorEvent(
				GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_STARTING, 
				false, true); 
			dataGridEvent.rowIndex = Math.min(rowIndex, grid.dataProvider.length - 1);
			dataGridEvent.columnIndex = Math.min(columnIndex, grid.columns.length - 1);
			dataGridEvent.column = column;
			
			// Don't send a life cycle event if the cell contains an item renderer.
			var editorStarted:Boolean = false;
			if (column.rendererIsEditable == true)
			{
				dataGrid_gridItemEditorSessionStartingHandler(dataGridEvent);   // start editor session without the option to cancel
				editorStarted = true;
			}
			else 
			{
				editorStarted = dataGrid.dispatchEvent(dataGridEvent);         
			}
			
			if (editorStarted) 
			{
				lastEditedItemPosition = { columnIndex: columnIndex, rowIndex: rowIndex };
				
				dataGrid.grid.caretRowIndex = rowIndex;
				dataGrid.grid.caretColumnIndex = columnIndex;
			}
			
			restoreFocusableChildren = true;
			dataGrid.removeEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_STARTING,
				dataGrid_gridItemEditorSessionStartingHandler);
			
			return editorStarted;
		}
		
		/**
		 *  Closes the currently active editor and optionally saves the editor's value
		 *  by calling the item editor's save() method.  If the cancel parameter is true,
		 *  then the editor's cancel() method is called instead.
		 * 
		 *  @param cancel if true then the data in the editor is discarded, 
		 *  otherwise it's saved.
		 * 
		 *  @return true if the data in the editor was saved, false otherwise.
		 * 
		 *  @see spark.components.IGridItemEditor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */ 
		public function endItemEditorSession(cancel:Boolean = false):Boolean
		{
			if (cancel)
			{
				cancelEdit();
				return false;
			}
			else
			{
				return endEdit();
			}
		}
		
		/**
		 *  @private
		 * 
		 *  Close the item editor without saving the data.
		 */
		mx_internal function cancelEdit():Boolean
		{
			if (itemEditorInstance)
			{
				if (itemEditorInstance.cancel())
				{
					// send the cancel event and tear down the editor.
					dispatchCancelEvent();
					destroyItemEditor();
				}
				else
				{
					return false;
				}
			}
			else if (editedItemRenderer)
			{
				// cancel focus in an item editor by setting focus back to the grid.
				destroyItemEditor();
			}
			
			return true;                   
			
		}
		
		
		/**
		 *  @private
		 * 
		 *  Notify event that the editor session is cancelled.
		 *  This event cannot be cancelled.
		 */
		private function dispatchCancelEvent():void
		{
			var dataGridEvent:GridItemEditorEvent =
				new GridItemEditorEvent(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_CANCEL);
			
			dataGridEvent.columnIndex = editedItemPosition.columnIndex;
			dataGridEvent.column = itemEditorInstance.column;
			dataGridEvent.rowIndex = dataGrid.dataProvider ? dataGrid.dataProvider.getItemIndex(itemEditorInstance.data) : -1;
			dataGrid.dispatchEvent(dataGridEvent);
		}
		
		/**
		 *  @private
		 * 
		 *  When the user finished editing an item, this method is called to close 
		 *  the editor and save the data.
		 *  
		 */
		private function endEdit():Boolean
		{        
			// Focus is inside an item renderer
			if (!itemEditorInstance && editedItemRenderer)
			{
				inEndEdit = true;
				destroyItemEditor();
				inEndEdit = false;
				return true;
			}
			
			// this happens if the renderer is removed asynchronously usually with FDS
			if (!itemEditorInstance)
				return false;
			
			inEndEdit = true;
			
			var itemPosition:Object = editedItemPosition;
			var editedItem:Object = itemEditorInstance.data;
			if (!saveItemEditorSession())
			{
				// The save was cancelled so check if the editor can be cancelled.
				// If it can then dispatch a cancel event.
				if (itemEditorInstance.cancel())
					dispatchCancelEvent();
				
				inEndEdit = false;
				return false;
			}
			
			var dataGridEvent:GridItemEditorEvent =
				new GridItemEditorEvent(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE);
			
			// GRID_ITEM_EDITOR_SESSION_SAVE events are NOT cancelable
			dataGridEvent.columnIndex = itemPosition.columnIndex;
			dataGridEvent.column = dataGrid.columns.getItemAt(itemPosition.columnIndex) as GridColumn;
			dataGridEvent.rowIndex = dataGrid.dataProvider ? dataGrid.dataProvider.getItemIndex(editedItem) : -1;
			dataGrid.dispatchEvent(dataGridEvent);
			
			inEndEdit = false;
			
			return true;
		}
		
		/**
		 *  @private
		 *  Save the editor session. The developer can still cancel out so the 
		 *  data may not be saved.
		 * 
		 *  @return true if the data is saved, false otherwise.
		 */
		private function saveItemEditorSession():Boolean
		{
			var dataSaved:Boolean = false;
			
			if (itemEditorInstance)
			{
				dataSaved = itemEditorInstance.save();
				
				if (dataSaved)
					destroyItemEditor();
			}
			
			return dataSaved;
		}
		
		/**
		 *  @private
		 *  Start an editor session in the next editable cell. 
		 *
		 *  @param rowIndex zero-based row index to start search from, inclusive.
		 *  @param columnIndex zero-based column index to start search from, not inclusive. 
		 *  @param backward - if true move backward column by column and then row by row.
		 *  If false, then move forward column by column, row by row.
		 * 
		 *  @return true if an editor was opened, false otherwise.
		 * 
		 */
		private function openEditorInNextEditableCell(rowIndex:int, columnIndex:int, backward:Boolean):Boolean
		{
			var nextCell:Point = new Point(rowIndex, columnIndex);
			var openedEditor:Boolean = false;
			
			do
			{
				nextCell = getNextEditableCell(nextCell.x, nextCell.y, backward);
				
				if (nextCell)
					openedEditor = dataGrid.startItemEditorSession(nextCell.x, nextCell.y);                
			} while (nextCell && !openedEditor);
			
			return openedEditor;
		}
		
		/**
		 *  @private
		 *  Find the next editable cell. 
		 * 
		 *  @param rowIndex zero-based row index to start search from, inclusive.
		 *  @param columnIndex zero-based column index to start search from, not inclusive. 
		 *  @param backward - if true move backward column by column and then row by row.
		 *  If false, then move forward column by column, row by row.
		 * 
		 *  @return If an editable cell was found then return a Point with the x property
		 *  containing the rowIndex and the y property containing the column index. If no
		 *  editable cell was found then null is returned.
		 */
		private function getNextEditableCell(rowIndex:int, columnIndex:int, backward:Boolean):Point
		{
			// what is the next cell?
			// increment is -1 if we are moving backward and 1 if moving
			// forward.
			const increment:int = backward ? -1 : 1;
			//var rowIndex:int = rowIndex;
			//var columnIndex:int = columnIndex;
			do {
				var nextColumn:int = columnIndex + increment;
				if (nextColumn >= 0 && nextColumn < dataGrid.columns.length)
				{
					columnIndex += increment;    
				}
				else
				{
					// move to next row.
					columnIndex = backward ? dataGrid.grid.columns.length - 1: 0;
					var nextRow:int = rowIndex + increment;
					if (nextRow >= 0 && nextRow < dataGrid.dataProvider.length)
						rowIndex += increment;
					else
						return null;
				}
			} while (!canEditColumn(columnIndex));
			
			return new Point(rowIndex, columnIndex);
		}
		
		
		/**
		 *  @private
		 * 
		 *  @param columnIndex
		 * 
		 *  @return true if the column can be edited, false otherwise.
		 */ 
		private function canEditColumn(columnIndex:int):Boolean
		{
			var column:GridColumn = grid.columns.getItemAt(columnIndex) as GridColumn; 
			return (dataGrid.editable && 
				column.editable &&
				column.visible);
		}
		
		/**
		 *  @private
		 * 
		 *  Test if the cell was selected at the last selection snapshot.
		 */
		private function wasCellPreviouslySelected(rowIndex:int, columnIndex:int):Boolean
		{
			if (dataGrid.isRowSelectionMode())
				return dataGrid.selectionContainsIndex(rowIndex);
			else if (dataGrid.isCellSelectionMode())
				return dataGrid.selectionContainsCell(rowIndex, columnIndex);
			
			return false;
		}
		
		/**
		 *  @private
		 *
		 *  Determine if a cell position is valid.
		 * 
		 *  @return true if valid, false otherwise.  
		 */
		private function isValidCellPosition(rowIndex:int, cellIndex:int):Boolean
		{
			if (rowIndex >= 0 && rowIndex < dataGrid.dataProvider.length &&
				cellIndex >= 0 && cellIndex < dataGrid.columns.length)
			{ 
				return true;
			}
			
			return false;
		}
		
		/**
		 *  @private
		 *  
		 *  Add a FlexEvent.ENTER listener to all child IVisualElements.
		 * 
		 *  @param element add listener to element and its children.
		 *  @param addListener if true add a listener, otherwise remove a listener.
		 */
		/*private function addRemoveFlexEventEnterListener(element:DisplayObject, addListener:Boolean):void
		{
		if (addListener)
		element.addEventListener(FlexEvent.ENTER, editor_enterHandler);
		else
		element.removeEventListener(FlexEvent.ENTER, editor_enterHandler);
		
		if (element is DisplayObjectContainer)
		{
		var container:DisplayObjectContainer = DisplayObjectContainer(element);
		var n:int = container.numChildren;
		for (var i:int = 0; i < n; i++)
		{
		var child:DisplayObject = container.getChildAt(i);
		
		if (child is DisplayObjectContainer)
		{
		addRemoveFlexEventEnterListener(child, addListener);
		}
		else
		{
		if (addListener)
		child.addEventListener(FlexEvent.ENTER, editor_enterHandler);
		else
		child.removeEventListener(FlexEvent.ENTER, editor_enterHandler);
		}
		}
		}
		
		}*/
		
		/**
		 *  @private
		 *  Check if a mouse click occured within the editor.
		 * 
		 *  @param event A MouseEvent or a SandboxMouseEvent
		 * 
		 *  @return true if the target is within the editor, false otherwise.
		 */ 
		private function editorOwnsClick(event:Event):Boolean
		{
			if (event is MouseEvent)
			{
				/*var target:IUIComponent = getIUIComponent(DisplayObject(event.target));
				if (target)
				return editorOwns(target);*/
			}
			
			return false;
		}
		
		/**
		 *  @private
		 *  Check if a child is contained within the editor using the owns() method.
		 *  The editor can be either editedItemRenderer or itemEditorInstance.
		 * 
		 *  @param child child to test.
		 *  @return true if the child is owned by the editor.
		 */ 
		/*private function editorOwns(child:IUIComponent):Boolean
		{
		return (itemEditorInstance &&
		(itemEditorInstance == child || 
		IUIComponent(itemEditorInstance).owns(DisplayObject(child))) ||
		(editedItemRenderer &&
		(editedItemRenderer == child || 
		IUIComponent(editedItemRenderer).owns(DisplayObject(child)))));
		}*/
		
		/**
		 *  @private
		 *  The IUIComponent related to a given object. If the object is not a IUIComponent
		 *  then work up the display list until we find a IUIComponent. 
		 *  @param  displayObject The object to get a IUIComponet from.
		 *  @return returns the displayObject if it is a display object or its 
		 *  closest parent that is a display object. 
		 */ 
		/*private function getIUIComponent(displayObject:DisplayObject):IUIComponent
		{
		if (displayObject is IUIComponent)
		return IUIComponent(displayObject);
		
		var current:DisplayObject = displayObject.parent;
		while (current)
		{
		if (current is IUIComponent)
		return IUIComponent(current);
		
		current = current.parent;
		}
		
		return null;
		}*/
		
		/**
		 *  @private
		 * 
		 *  Restore the focusable children flags.
		 */ 
		private function restoreFocusableChildrenFlags():void
		{
			dataGrid.hasFocusableChildren = saveDataGridHasFocusableChildren;
			
			if (dataGrid.scroller)
				dataGrid.scroller.hasFocusableChildren = saveScrollerHasFocusableChildren;
			
		}
		
		/**
		 *  @private
		 * 
		 *  Get the effective mouse event that activates an editor.
		 *  If the column has a setting, then use it. Otherwise use the setting on
		 *  the data grid.
		 */ 
		private function getEditorActivationMouseEvent(columnIndex:int):String
		{
			var editorActivationMouseEvent:String = null;
			
			if (columnIndex >= 0 && columnIndex < dataGrid.columns.length)
			{
				var column:GridColumn = grid.columns.getItemAt(columnIndex) as GridColumn; 
				editorActivationMouseEvent = column.editorActivationMouseEvent;    
			}
			
			if (!editorActivationMouseEvent)
				editorActivationMouseEvent = dataGrid.editorActivationMouseEvent;
			
			return editorActivationMouseEvent;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 * 
		 *  Default handler for the startItemEditorSession event.
		 * 
		 */
		private function dataGrid_gridItemEditorSessionStartingHandler(event:GridItemEditorEvent):void
		{
			// trace("itemEditorItemEditBeginningHandler");
			if (!event.isDefaultPrevented())
			{
				setEditedItemPosition({columnIndex: event.column.columnIndex, rowIndex: event.rowIndex});
			}
			else if (!itemEditorInstance)
			{
				_editedItemPosition = null;
				
				// return focus to the grid w/o selecting an item
				dataGrid.setFocus();
			}
		}
		
		/**
		 *  @private
		 * 
		 *  Handle the F2 key to start editing a cell.
		 */
		private function dataGrid_keyboardDownHandler(event:KeyboardEvent):void
		{
			if (!dataGrid.editable || dataGrid.selectionMode == GridSelectionMode.NONE)
				return;
			
			if (event.isDefaultPrevented())
				return;
			
			// lastEvent = event;
			
			if (event.keyCode == dataGrid.editKey)
			{
				// ignore F2 if we are already editing a cell or the column is not
				// editable
				if (itemEditorInstance)
					return;
				
				// Edit the last column edited. If no last column then try to 
				// edit the first column.
				var nextCell:Point = null;
				if (dataGrid.isRowSelectionMode())
				{
					var lastColumn:int = lastEditedItemPosition ? lastEditedItemPosition.columnIndex : 0;
					openEditorInNextEditableCell(dataGrid.grid.caretRowIndex, 
						lastColumn - 1,
						false);
					return;
				}
				else if (canEditColumn(grid.caretColumnIndex))
				{
					dataGrid.startItemEditorSession(grid.caretRowIndex, grid.caretColumnIndex);                
				}
			}            
		}
		
		/**
		 *  @private
		 * 
		 */
		private function grid_gridMouseDownHandler(event:GridEvent):void
		{
			//trace("grid_gridMouseDownHandler");
			gotDoubleClickEvent = false;
			
			// check if the mouse was clicked outside of the editor. If it was
			// then end the editing session.
			/*if (!dataGrid.editable || editorOwnsClick(event))
			return;*/
			
			if (!isValidCellPosition(event.rowIndex, event.columnIndex))
				return;
			
			// lastEvent = event;
			
			const rowIndex:int = event.rowIndex;
			const columnIndex:int = event.columnIndex;
			
			//trace("grid_gridMouseDownHandler: (rowIndex, columnIndex) = (" + rowIndex + "," + columnIndex + ")");
			
			// item editor handling
			var r:IGridItemRenderer = event.itemRenderer;
			
			lastItemDown = null;
			
			// if selection is being modified with shift or ctrl keys then
			// don't start up an editor session.
			if (event.shiftKey || event.ctrlKey)
				return;
			
			// if an editor is already up, close it without starting a new editor.
			if (itemEditorInstance)
			{
				// if the user clicks outside the cell but we can't save the data,
				// say, because the data was invalid, then cancel the save.
				if (!inEndEdit && !dataGrid.endItemEditorSession())
				{
					dataGrid.endItemEditorSession(true);
				}
				return;
			}
			
			var editorActivationMouseEvent:String = getEditorActivationMouseEvent(columnIndex);
			if (editorActivationMouseEvent != GridItemEditorActivationMouseEvent.SINGLE_CLICK && 
				editorActivationMouseEvent != GridItemEditorActivationMouseEvent.SINGLE_CLICK_ON_SELECTED_CELL)
			{
				return;     // not allowed to start editor on a single click
			}
			
			// Don't open and editor if the click was not on a previously selected 
			// cell, unless that cell is an item renderer. We don't want to stop 
			// the item renderer from getting focus so start an edit session.
			const column:GridColumn = dataGrid.columns.getItemAt(columnIndex) as GridColumn;
			if (r && 
				(column.rendererIsEditable || 
					(wasCellPreviouslySelected(rowIndex, columnIndex) && 
						editorActivationMouseEvent == GridItemEditorActivationMouseEvent.SINGLE_CLICK_ON_SELECTED_CELL) ||
					editorActivationMouseEvent == GridItemEditorActivationMouseEvent.SINGLE_CLICK))
			{
				//trace("cell was previously selected: (" + rowIndex + "," + columnIndex + ")");  
				lastItemDown = r;
			}
			
		}
		
		/**
		 *  @private
		 * 
		 *  If clicked on a the same cell as mouse down then start editing the cell.
		 */
		private function grid_gridMouseUpHandler(event:GridEvent):void
		{
			//trace("grid_gridMouseUpHandler");
			
			if (!dataGrid.editable)
				return;
			
			if (!isValidCellPosition(event.rowIndex, event.columnIndex))
				return;
			
			// lastEvent = event;
			
			const eventRowIndex:int = event.rowIndex;
			const eventColumnIndex:int = event.columnIndex;
			
			// Only start an edit if the row is the only selected row.
			// Only start editing when one row is selected.
			if (dataGrid.selectionLength != 1)
				return;
			
			const rowIndex:int = eventRowIndex;
			var columnIndex:int = eventColumnIndex;
			
			var editorActivationMouseEvent:String = getEditorActivationMouseEvent(columnIndex);
			if (editorActivationMouseEvent != GridItemEditorActivationMouseEvent.SINGLE_CLICK && 
				editorActivationMouseEvent != GridItemEditorActivationMouseEvent.SINGLE_CLICK_ON_SELECTED_CELL)
			{
				return;     // not allowed to start editor on a single click
			}
			
			var r:IVisualElement = event.itemRenderer;
			//trace("grid_gridMouseUpHandler: itemRenderer = " + event.itemRenderer);  
			if (r && r != editedItemRenderer && 
				lastItemDown && lastItemDown == r)
			{
				if (columnIndex >= 0)
				{
					if (grid.columns.getItemAt(columnIndex).editable)
					{
						// Check if clicking again on the same item
						if (doubleClickTimer)
						{
							if (rowIndex == lastItemClickedPosition.rowIndex &&
								columnIndex == lastItemClickedPosition.columnIndex)
							{
								// Clicked on the same item again and we 
								// already have a timer. Wait on the existing timer.
								lastItemDown == null;
								return;
							}
							else 
							{
								// Clicked on a different item. Stop the timer and start a new one
								doubleClickTimer.stop();
								doubleClickTimer = null;
							}
						}
						
						lastItemClickedPosition = { columnIndex: columnIndex, rowIndex: rowIndex};
						
						// If double click is not enabled or we want a double click to open an
						// editor, then open the editor directly now. Otherwise start a timer
						// and wait to see if a double click comes in that will cancel the edit.
						/*if (dataGrid.editOnDoubleClick || 
						InteractiveObject(lastItemDown).doubleClickEnabled == false)
						{
						// we don't need to wait on the time since editing double click is ok.
						dataGrid.startItemEditorSession(rowIndex, columnIndex);
						}
						else 
						{
						doubleClickTimer = new Timer(dataGrid.doubleClickTime, 1);
						doubleClickTimer.addEventListener(TimerEvent.TIMER, doubleClickTimerHandler);
						doubleClickTimer.start();                        
						}*/
					}
				}
			}
			
			lastItemDown = null;            
		}
		
		
		/**
		 *  Grid MouseWheel event handler.  Used to end the itemeditor when scrolling on the grid.
		 *  Default action is to save the edited contents.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 11.8
		 *  @playerversion AIR 3.8
		 *  @productversion Flex 4.11
		 */
		protected function grid_gridMouseWheelHandler(event:MouseEvent):void
		{
			endEdit();
		}
		
		
		/**
		 *  @private
		 * 
		 *  If clicked on a the same cell as mouse down then start editing the cell.
		 */
		private function grid_gridDoubleClickHandler(event:GridEvent):void
		{
			//trace("grid_gridDoubleClickHandler: got double click");
			
			if (!dataGrid.editable)
				return;
			
			if (!isValidCellPosition(event.rowIndex, event.columnIndex))
				return;
			
			// lastEvent = event;
			
			gotDoubleClickEvent = true;
			
			// If double-click editing is enabled then start up and editor session.
			var editorActivationMouseEvent:String = getEditorActivationMouseEvent(event.columnIndex);
			if (editorActivationMouseEvent == GridItemEditorActivationMouseEvent.DOUBLE_CLICK)
				dataGrid.startItemEditorSession(event.rowIndex, event.columnIndex);
			
		}
		
		/**
		 *  @private
		 * 
		 *  Timer for double click events.
		 */
		/*private function doubleClickTimerHandler(event:TimerEvent):void
		{
		//trace("doubleClickTimerHandler");
		
		doubleClickTimer.removeEventListener(TimerEvent.TIMER, doubleClickTimerHandler);
		doubleClickTimer = null;
		
		if (!gotDoubleClickEvent)
		{
		dataGrid.startItemEditorSession(lastItemClickedPosition.rowIndex, lastItemClickedPosition.columnIndex);
		}
		
		gotDoubleClickEvent = false;
		}*/
		
		
		/**
		 *  @private
		 */
		private function deactivateHandler(event:Event):void
		{
			// If stage losing activation, set focus to DG close the editor and set
			// focus back to the dataGrid.
			if (itemEditorInstance || editedItemRenderer)
			{
				// If we can't save the data, say, because the data was invalid, 
				// then cancel the save.
				if (!inEndEdit && !dataGrid.endItemEditorSession())
				{
					dataGrid.endItemEditorSession(true);
				}
				dataGrid.setFocus();
			}
		}
		
		/**
		 *  @private
		 *  Closes the itemEditorInstance if the focus is outside of the data grid.
		 */
		private function editor_removedFromStageHandler(event:Event):void
		{
			if (itemEditorInstance || editedItemRenderer)
			{
				// If we can't save the data, say, because the data was invalid, 
				// then cancel the save.
				if (!inEndEdit && !dataGrid.endItemEditorSession())
				{
					dataGrid.endItemEditorSession(true);
				}
			}
		}
		
		/**
		 *  @private
		 *  Closes the itemEditorInstance if the focus is outside of the data grid.
		 */
		private function editor_focusOutHandler(event:FocusEvent):void
		{/*
			//trace("editor_focusOutHandler " + event.relatedObject);
			
			// If the focus goes to a component that is owned by the editor, 
			// then don't end the editor session.
			if (event.relatedObject)
			{
			var component:IUIComponent = getIUIComponent(event.relatedObject);
			if (component && editorOwns(component))
			return;                
			}
			
			// ignore textfields losing focus on mousedowns
			if (!event.relatedObject)
				return;
			
			if (itemEditorInstance || editedItemRenderer)
			{
				// If we can't save the data, say, because the data was invalid, 
				// then cancel the save.
				if (!inEndEdit && !dataGrid.endItemEditorSession())
				{
					dataGrid.endItemEditorSession(true);
				}
			}        
		*/}
		
		/**
		 *  @private
		 *  Special case for TextArea control. See editor_keyDownHandler.
		 *  ColorPicker also dispatches the "enter" event so keep the
		 *  parameter of type Event, not FlexEvent.
		 */
		private function editor_enterHandler(event:Event):void
		{
			//trace("FlexEvent" );
			if (event is FlexEvent)
				gotFlexEnterEvent = true;
		}
		
		/**
		 *  @private
		 * 
		 *  Handle keys on the editor to stop the editing session.
		 */
		private function editor_keyDownHandler(event:KeyboardEvent):void
		{/*
			//trace("keyboard event = " + event);
			if (event.isDefaultPrevented())
			{
				// Special case the ENTER key since TextArea cancels the ENTER when it 
				// doesn't use it but instead it dispatches an FlexEvent.ENTER.
				// The problem is the ENTER event does not have the control and 
				// shift key flags we need.
				if (!(event.charCode == Keyboard.ENTER && gotFlexEnterEvent))
				{
					gotFlexEnterEvent = false;
					return;
				}
			}
			
			gotFlexEnterEvent = false;
			
			// ESC just kills the editor, no new data
			if (event.keyCode == Keyboard.ESCAPE)
			{
				cancelEdit();
			}
			else if (event.ctrlKey && event.charCode == 46)
			{   // Check for Ctrl-.
				cancelEdit();
			}
			else if (event.charCode == Keyboard.ENTER && event.keyCode != 229)
			{
				if (!_editedItemPosition)
					return;
				
				// If the ctrl or ctrl and shift keys are down then set a flag to 
				// avoid changing the focusable children flag becaue 
				// need to be redone when starting up the editor again.
				if (event.ctrlKey || (event.ctrlKey && event.shiftKey))
					restoreFocusableChildren = false;
				
				// Enter closes the editor.
				// The 229 keyCode is for IME compatability. When entering an IME expression,
				// the enter key is down, but the keyCode is 229 instead of the enter key code.
				// Thanks to Yukari for this little trick...
				if (dataGrid.endItemEditorSession())
				{
					if (grid.focusManager)
					grid.focusManager.defaultButtonEnabled = false;
					
					if (event.ctrlKey || (event.ctrlKey && event.shiftKey))
					{
						var lastRow:int = lastEditedItemPosition ? lastEditedItemPosition.rowIndex : 0;
						var lastColumn:int = lastEditedItemPosition ? lastEditedItemPosition.columnIndex : 0;
						
						if (event.shiftKey)
							lastRow -= 1;
						else
							lastRow += 1;
						
						// If we have a valid next row, then start another editor.
						if (lastRow >= 0 && lastRow < dataGrid.dataProvider.length)
						{
							if (!openEditorInNextEditableCell(lastRow, lastColumn - 1, false))
							{
								// We didn't start an editor so restore the data grid's
								// focusable chidlren flags.
								restoreFocusableChildren = true;
								restoreFocusableChildrenFlags();
							}
						}                        
					}
				}
			}
			
			// Prevent the DataGrid from processing any keystrokes that were 
			// received by the editor. We don't cancel the keystokes here 
			// because on AIR that cancels text input into the text field.
			// We need to let the copy/cut/past combinations pass through
			// because they need to reach the NativeApplication in order to
			// be correctly processed by the item editors.
			// Note on Mac OS ctrlKey covers ctrl and command keys
			if (!event.ctrlKey) 
			{
				event.stopPropagation();
			}
		*/}
		
		/**
		 *  @private
		 *  handle focus changes generated from keyboard keys.
		 */
		private function editor_keyFocusChangeHandler(event:FocusEvent):void
		{/*
			// if we tabbed out of the edit then prevent the tab and
			// save the edit. Next start up a new edit session in the
			// next cell.
			//trace("editor_editor_keyFocusChangeHandler");
			lastEvent = event;
			
			if (itemEditorInstance || editedItemRenderer)
			{
			if (event.isDefaultPrevented())
			return;
			
			var nextObject:IFocusManagerComponent = grid.focusManager.getNextFocusManagerComponent(event.shiftKey);
			if (nextObject == itemEditorInstance ||
			(itemEditorInstance && !DisplayObjectContainer(itemEditorInstance).contains(DisplayObject(nextObject))) ||
			(!itemEditorInstance && 
			(nextObject == editedItemRenderer ||
			(editedItemRenderer && !DisplayObjectContainer(editedItemRenderer).contains(DisplayObject(nextObject))))))
			{
			event.preventDefault();
			
			restoreFocusableChildren = false;
			dataGrid.endItemEditorSession();
			
			if (!openEditorInNextEditableCell(lastEditedItemPosition.rowIndex,
			lastEditedItemPosition.columnIndex,
			event.shiftKey))
			{
			// We didn't start an editor so restore the data grid's
			// focusable chidlren flags.
			restoreFocusableChildren = true;
			restoreFocusableChildrenFlags();                    
			}
			}
			}*/
		}
		
		/**
		 *  @private
		 */
		private function editorAncestorResizeHandler(event:Event):void
		{
			// If we can't save the data, say, because the data was invalid, 
			// then cancel the save.
			if (!dataGrid.endItemEditorSession())
			{
				dataGrid.endItemEditorSession(true);
			}
		}
		
		/**
		 *  @private
		 */
		private function sandBoxRoot_mouseDownHandler(event:Event):void
		{
			if (editorOwnsClick(event))
			{
				return;
			}
			
			// If clicked on the scroll bars then keep the editor up
			/*if (dataGrid.scroller && 
			dataGrid.scroller.contains(DisplayObject(event.target)) &&
			!grid.contains(DisplayObject(event.target)))
			{
			return;
			}*/
			
			// If we can't save the data, say, because the data was invalid, 
			// then cancel the save.
			if (!inEndEdit && !dataGrid.endItemEditorSession())
			{
				dataGrid.endItemEditorSession(true);
			}
			
			// If the item editor was destroyed then set focus back to the grid 
			// so grid logic will deal if focus doesn't end up somewhere else. 
			if (!itemEditorInstance)
				dataGrid.setFocus();
		}
		
	}
}
