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
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	*/
	import mx.events.MouseEvent;
	import org.apache.royale.geom.Point;
	import org.apache.royale.geom.Rectangle;
	
	//import mx.controls.DataGrid;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.IFactory;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.core.UIComponentGlobals;
	import mx.core.mx_internal;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.FlexEvent;
	import mx.events.PropertyChangeEvent;
	import mx.graphics.SolidColorStroke;
	import mx.utils.ObjectUtil;
	
	// import spark.collections.SubListView;
	import spark.components.gridClasses.CellPosition;
	import spark.components.gridClasses.GridDoubleClickMode;
	import spark.components.gridClasses.GridColumn;
	import spark.components.gridClasses.GridDimensions;
	// import spark.components.gridClasses.GridDimensionsView;
	import spark.components.gridClasses.GridLayout;
	import spark.components.gridClasses.GridSelection;
	import spark.components.gridClasses.GridSelectionMode;
	import spark.components.gridClasses.GridView;
	// import spark.components.gridClasses.GridViewLayout;
	import spark.components.gridClasses.IDataGridElement;
	import spark.components.gridClasses.IGridItemRenderer;
	import spark.components.supportClasses.GroupBase;
	import spark.components.supportClasses.IDataProviderEnhance;
	import spark.components.supportClasses.RegExPatterns;
	import spark.events.GridCaretEvent;
	import spark.events.GridEvent;
	import spark.layouts.VerticalLayout;
	import spark.layouts.supportClasses.LayoutBase;
	import spark.primitives.Line;
	import spark.primitives.Rect;
	// import spark.utils.MouseEventUtil;
	
	use namespace mx_internal;
	
	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the mouse button is pressed over a Grid cell.
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
	 *  Dispatched after a <code>gridMouseDown</code> event 
	 *  if the mouse moves before the button is released.
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
	 *  Dispatched when the mouse button is released over a Grid cell.
	 *  During a drag operation, it is also dispatched after a 
	 *  <code>gridMouseDown</code> event 
	 *  when the mouse button is released, even if the mouse is no longer 
	 *  in the Grid.
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
	 *  Dispatched when the mouse enters a grid cell.
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
	 *  Dispatched when the mouse leaves a grid cell.
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
	 *  Dispatched when the mouse is clicked over a cell
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
	 *  Dispatched when the mouse is double-clicked over a cell
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
	 *  Dispatched after the caret changes.  
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
	 *  The Grid control displays a list of data items called
	 *  its <i>data provider</i> in a scrollable table or "grid", one item per row.
	 *  Each of the grid's columns, defined by a GridColumn object,
	 *  displays a value based on the item for the corresponding row.
	 *  The grid's data provider is mutable, meaning its items can be added or
	 *  removed, or changed.  
	 *  Similarly, the list of columns is mutable.
	 * 
	 *  <p>The Grid component is intended to be used as a DataGrid skin part, or
	 *  as an element of other custom composite components.  
	 *  Therefore, it is not skinnable, it does not include a scroller or scrollbars, 
	 *  and it does not provide default mouse or keyboard event handling.</p>
	 * 
	 *  <p>Each visible Grid <i>cell</i> is displayed by a GridItemRenderer
	 *  instance created by using the <code>itemRenderer</code> property.  
	 *  specify an item renderer for each column.
	 *  Before it is displayed, each item renderer instance is configured 
	 *  with the value of the data provider item for that row.
	 *  Item renderers are created as needed and then, to keep creation
	 *  overhead to a minimum, pooled and recycled.</p>
	 *
	 *  <p>The Grid control supports a doubleClick event, according the <code>doubleClickMode</code>
	 *  property.</p>
	 * 
	 *  <p>The Grid control supports selection, according the <code>selectionMode</code>
	 *  property.  The set of selected row or cell indices can be modified or
	 *  queried programatically using the selection methods, such as 
	 *  <code>setSelectedIndex</code> or <code>selectionContainsIndex()</code>.</p>
	 * 
	 *  <p>The Grid control displays hover, caret, and selection indicators based  
	 *  on the <code>selectionMode</code> property and the corresponding 
	 *  row index and column index properties, such as 
	 *  <code>hoverRowIndex</code> and <code>columnRowIndex</code>.   
	 *  An indicator can be any visual element.  
	 *  Indicators that implement IGridVisualElement can configure themselves 
	 *  according to the row and column in which they are used.</p>
	 * 
	 *  <p>The Grid control supports smooth scrolling.  
	 *  Their vertical and horizontal scroll positions define the pixel origin 
	 *  of the visible part of the grid and the grid's layout only displays 
	 *  as many cell item renderers as are needed to fill the available space.</p>
	 *
	 *  <p>The Grid control supports variable height rows that automatically compute 
	 *  their height based on the item renderers' contents.  
	 *  This support is called grid <i>virtualization</i>
	 *  because the mapping from (pixel) scroll positions to row and column indices
	 *  is typically based on incomplete information about the preferred sizes 
	 *  for grid cells.  
	 *  The Grid caches the computed heights of rows that have been
	 *  scrolled into view and estimates the rest based on a single 
	 *  <code>typicalItem</code>.</p>
	 * 
	 *  <p>Transitions in DataGrid item renderers aren't supported. The GridItemRenderer class 
	 *  has disabled its <code>transitions</code> property so setting it will have no effect.</p>
	 *
	 *  @mxml <p>The <code>&lt;s:Grid&gt;</code> tag inherits all of the tag 
	 *  attributes of its superclass and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;s:Grid 
	 *    <strong>Properties</strong>
	 *  /&gt;
	 *  </pre>
	 *
	 *  @see DataGrid
	 *  @see spark.components.gridClasses.GridColumn
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 2.5
	 *  @productversion Flex 4.5
	 */
	public class Grid extends Group implements IDataGridElement, IDataProviderEnhance
	{
		// include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  A list of functions to be called at commitProperties() time, after the dataProvider
		 *  has been set.  This list is used to defer making grid selection updates per the 
		 *  set methods for the selectedIndex, selectedIndices, selectedItem, selectedItems, 
		 *  selectedCell and selectedCells properties.
		 */
		private const deferredOperations:Vector.<Function> = new Vector.<Function>();
		
		/**
		 *  @private
		 *  Cache the dataItem that goes with the caretRowIndex so we can find the
		 *  rowIndex of the caret after a collection refresh event.
		 */    
		private var caretSelectedItem:Object = null;
		private var updateCaretForDataProviderChanged:Boolean = false;
		private var updateCaretForDataProviderChangeLastEvent:CollectionEvent;
		
		/**
		 *  @private
		 *  True while updateDisplayList is running.  Use to disable invalidateSize(),
		 *  invalidateDisplayList() here and in the GridLayer class.
		 */
		mx_internal var inUpdateDisplayList:Boolean = false;  
		
		/**
		 *  @private
		 *  True while doing a drag operation with the mouse.
		 */
		private var dragInProgress:Boolean = false;
		
		/**
		 *  @private
		 *  True if the columns were generated rather than explicitly set.
		 */
		private var generatedColumns:Boolean = false;
		
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
		public function Grid()
		{
			super();
			/*
			layout = new GridLayout();
			
			MouseEventUtil.addDownDragUpListeners(this, 
				grid_mouseDownDragUpHandler, 
				grid_mouseDownDragUpHandler, 
				grid_mouseDownDragUpHandler);
			
			addEventListener(MouseEvent.MOUSE_UP, grid_mouseUpHandler);
			addEventListener(MouseEvent.MOUSE_MOVE, grid_mouseMoveHandler);
			addEventListener(MouseEvent.ROLL_OUT, grid_mouseRollOutHandler);   
			*/
		}
		
		/**
		 *  @private
		 *  Return the GridView which contains the specified cell.   If rowIndex == -1,
		 *  then return the topmost GridView that contains the specified column and 
		 *  if columnIndex == -1 then return the leftmost GridView that contains the specified row. 
		 */
		private function getGridViewAt(rowIndex:int, columnIndex:int):GridView
		{
			if ((rowIndex < 0) && (columnIndex < 0))
				return null;
			
			const gridLayout:GridLayout = layout as GridLayout;
			
			if ((rowIndex >= lockedRowCount) || (rowIndex == -1))
			{
				if ((columnIndex >= lockedColumnCount) || (columnIndex == -1))
					return gridLayout.centerGridView;
				
				return gridLayout.leftGridView;
			}
			
			return (columnIndex < lockedColumnCount) ? gridLayout.topLeftGridView : gridLayout.topGridView;
		}
		
		
		
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
			/*dispatchEvent(new Event(type))*/;
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
		//  anchorColumnIndex
		//----------------------------------
		
		private var _anchorColumnIndex:int = 0;
		
		/**
		 *  @private
		 *  True if either anchorColumnIndex or anchorRowIndex changes.
		 */
		private var anchorChanged:Boolean = false;
		
		[Bindable("anchorColumnIndexChanged")]
		
		/**
		 *  The column index of the <i>anchor</i> for the next shift selection.
		 *  The anchor is the item most recently selected. 
		 *  It defines the anchor item when selecting multiple items in the grid. 
		 *  When you select multiple items, the set of items extends from 
		 *  the anchor to the caret item.
		 *
		 *  <p>Grid event handlers should use this property to record the
		 *  location of the most recent unshifted mouse down or keyboard
		 *  event that defines one end of the next potential shift
		 *  selection.  
		 *  The caret index defines the other end.</p>
		 * 
		 *  @default 0
		 * 
		 *  @see spark.components.Grid#caretRowIndex
		 *  @see spark.components.Grid#caretColumnIndex
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5 
		 */
		public function get anchorColumnIndex():int
		{
			return _anchorColumnIndex;
		}
		
		/**
		 *  @private
		 */
		public function set anchorColumnIndex(value:int):void
		{
			if (_anchorColumnIndex == value || 
				selectionMode == GridSelectionMode.SINGLE_ROW || 
				selectionMode == GridSelectionMode.MULTIPLE_ROWS)
			{
				return;
			}
			
			_anchorColumnIndex = value;
			
			anchorChanged = true;
			invalidateProperties();
			
			dispatchChangeEvent("anchorColumnIndexChanged");
		}
		
		//----------------------------------
		//  anchorRowIndex
		//----------------------------------
		
		private var _anchorRowIndex:int = 0; 
		
		[Bindable("anchorRowIndexChanged")]
		
		/**
		 *  The row index of the <i>anchor</i> for the next shift selection.
		 *  The anchor is the item most recently selected. 
		 *  It defines the anchor item when selecting multiple items in the grid. 
		 *  When you select multiple items, the set of items extends from 
		 *  the anchor to the caret item.
		 *
		 *  <p>Grid event handlers should use this property to record the
		 *  location of the most recent unshifted mouse down or keyboard
		 *  event that defines one end of the next potential shift
		 *  selection.  
		 *  The caret index defines the other end.</p>
		 * 
		 *  @default 0
		 *
		 *  @see spark.components.Grid#caretRowIndex
		 *  @see spark.components.Grid#caretColumnIndex
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5 
		 */
		public function get anchorRowIndex():int
		{
			return _anchorRowIndex;
		}
		
		/**
		 *  @private
		 */
		public function set anchorRowIndex(value:int):void
		{
			if (_anchorRowIndex == value)
				return;
			
			_anchorRowIndex = value;
			
			anchorChanged = true;
			invalidateProperties();
			
			dispatchChangeEvent("anchorRowIndexChanged");
		}
		
		//----------------------------------
		//  caretIndicator
		//----------------------------------
		
		private var _caretIndicator:IFactory = null;
		
		[Bindable("caretIndicatorChanged")]
		
		/**
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_ROW</code> or
		 *  <code>GridSelectionMode.MULTIPLE_ROWS</code>, 
		 *  a single visual element displayed for the caret row, 
		 *  If <code>selectionMode</code> is
		 *  <code>GridSelectionMode.SINGLE_CELL</code> or
		 *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, the
		 *  visual element displayed for the caret cell.
		 *  
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get caretIndicator():IFactory
		{
			return _caretIndicator;
		}
		
		/**
		 *  @private
		 */
		public function set caretIndicator(value:IFactory):void
		{
			if (_caretIndicator == value)
				return;
			
			_caretIndicator = value;
			invalidateDisplayListFor("caretIndicator");
			dispatchChangeEvent("caretIndicatorChanged");
		}    
		
		//----------------------------------
		//  caretColumnIndex
		//----------------------------------
		
		private var _caretColumnIndex:int = -1;
		private var _oldCaretColumnIndex:int = -1;
		private var caretChanged:Boolean = false;
		
		[Bindable("caretColumnIndexChanged")]
		
		/**
		 *  If <code>showCaretIndicator</code> is <code>true</code>,
		 *  the column index of the <code>caretIndicator</code>.
		 
		 *  <p>If <code>selectionMode</code> is
		 *  <code>GridSelectionMode.SINGLE_ROW</code> or
		 *  <code>GridSelectionMode.MULTIPLE_ROWS</code> then the indicator
		 *  occupies the entire row and <code>caretColumnIndex</code> is ignored.  
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_CELL</code> or
		 *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, then the 
		 *  <code>caretIndicator</code> occupies the specified cell.</p>
		 * 
		 *  <p>Setting <code>caretColumnIndex</code> to -1 means that the column 
		 *  index is undefined and a cell caret is not shown.</p>
		 *  
		 *  @default -1
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5 
		 */
		public function get caretColumnIndex():int
		{
			return _caretColumnIndex;
		}
		
		/**
		 *  @private
		 */
		public function set caretColumnIndex(value:int):void
		{
			if (_caretColumnIndex == value || value < -1)
				return;
			
			_caretColumnIndex = value;
			
			caretChanged = true;
			invalidateProperties();
			
			// Unconditionally invalidate because renderers may depend on
			// caretColumnIndex even when the caretIndicator doesn't exist.
			invalidateDisplayListFor("caretIndicator");         
			dispatchChangeEvent("caretColumnIndexChanged");
		}
		
		//----------------------------------
		//  caretRowIndex
		//----------------------------------
		
		private var _caretRowIndex:int = -1;
		private var _oldCaretRowIndex:int = -1;
		
		[Bindable("caretRowIndexChanged")]
		
		/**
		 *  If <code>showCaretIndicator</code> is <code>true</code>,   
		 *  the row index of the <code>caretIndicator</code>.
		 *  If <code>selectionMode</code> is
		 *  <code>GridSelectionMode.SINGLE_ROW</code> or
		 *  <code>GridSelectionMode.MULTIPLE_ROWS</code> then the indicator
		 *  occupies the entire row and the <code>caretColumnIndex</code> 
		 *  property is ignored.  
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_CELL</code> or
		 *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, then the <code>caretIndicator</code>
		 *  occupies the specified cell.
		 * 
		 *  <p>Setting <code>caretRowIndex</code> to -1 means that the row index 
		 *  is undefined and the caret will not be shown.</p>
		 * 
		 *  @default -1
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5 
		 */
		public function get caretRowIndex():int
		{
			return _caretRowIndex;
		}
		
		/**
		 *  @private
		 */
		public function set caretRowIndex(value:int):void
		{
			if (_caretRowIndex == value || value < -1)
				return;
			
			_caretRowIndex = value;
			
			caretChanged = true;
			invalidateProperties();
			
			// Unconditionally invalidate because renderers may depend on
			// caretRowIndex even when the caretIndicator doesn't exist.
			invalidateDisplayListFor("caretIndicator");         
			dispatchChangeEvent("caretRowIndexChanged");
		}
		
		//----------------------------------
		//  clipAndEnableScrolling (private override)
		//----------------------------------
		
		private var _clipAndEnableScrolling:Boolean = false;
		
		/**
		 *  @private
		 */
		override public function get clipAndEnableScrolling():Boolean 
		{
			return _clipAndEnableScrolling;
		}
		
		/**
		 *  @private
		 */
		override public function set clipAndEnableScrolling(value:Boolean):void 
		{
			if (value == _clipAndEnableScrolling)
				return;
			
			_clipAndEnableScrolling = value;
			/*
			const gridLayout:GridLayout = layout as GridLayout;
			const topGridView:GridView = gridLayout.topGridView;        
			const leftGridView:GridView = gridLayout.leftGridView;
			const centerGridView:GridView = gridLayout.centerGridView;		
			
			if (topGridView) topGridView.clipAndEnableScrolling = value;
			if (leftGridView) leftGridView.clipAndEnableScrolling = value;
			if (centerGridView) centerGridView.clipAndEnableScrolling = value;
			*/
		}
		
		
		//----------------------------------
		//  contentHeight (private get override)
		//---------------------------------- 
		
		/**
		 *  @private
		 */
		override public function get contentHeight():Number 
		{
			return Math.ceil(gridDimensions.getContentHeight());
		}
		
		//----------------------------------
		//  contentWidth (private get override)
		//---------------------------------- 
		
		/**
		 *  @private
		 */    
		override public function get contentWidth():Number 
		{
			return Math.ceil(gridDimensions.getContentWidth());
		}
		
		//----------------------------------
		//  horizontalScrollPosition (private override)
		//----------------------------------
		
		private var _horizontalScrollPosition:Number = 0;
		
		[Bindable]
		[Inspectable(minValue="0.0")] 
		
		/**
		 *  @copy spark.core.IViewport#horizontalScrollPosition
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override public function get horizontalScrollPosition():Number 
		{
			return _horizontalScrollPosition;
		}
		
		/**
		 *  @private
		 */
		/*override*/ 
		public function set horizontalScrollPosition(value:Number):void 
		{
			if (_horizontalScrollPosition == value)
				return;
			/*
			const gridLayout:GridLayout = layout as GridLayout;
			const topGridView:GridView = gridLayout.topGridView;        
			const centerGridView:GridView = gridLayout.centerGridView;	
			
			if (centerGridView)
			{
				const gridViewLayout:GridViewLayout = centerGridView.gridViewLayout;
				const gridMaxHSP:Number = contentWidth - width;
				const centerContentWidth:Number = Math.ceil(gridViewLayout.gridDimensionsView.getContentWidth());
				const centerMaxHSP:Number = centerContentWidth - centerGridView.width;
				const hsp:Number = (gridMaxHSP > 0) ? (centerMaxHSP / gridMaxHSP) * value : 0;
				
				centerGridView.horizontalScrollPosition = hsp;
				
				if (topGridView)
					topGridView.horizontalScrollPosition = hsp;
			}
			*/
			_horizontalScrollPosition = value;
			
		}
		
		
		//----------------------------------
		//  isFirstRow
		//----------------------------------
		
		/**
		 *  Returns if the selectedIndex is equal to the first row.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 11.1
		 *  @playerversion AIR 3.4
		 *  @productversion Flex 4.10
		 */
		public function get isFirstRow():Boolean
		{
			if (dataProvider && dataProvider.length > 0)
			{
				if (selectedIndex == 0)
				{
					return true;
				}
				else
				{
					return false;
				}
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
		 *  Returns if the selectedIndex is equal to the last row.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 11.1
		 *  @playerversion AIR 3.4
		 *  @productversion Flex 4.10
		 */
		public function get isLastRow():Boolean
		{
			if (dataProvider && dataProvider.length > 0)
			{
				if (selectedIndex == dataProvider.length - 1)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		
		
		//----------------------------------
		//  verticalScrollPosition (private override)
		//----------------------------------
		
		private var _verticalScrollPosition:Number = 0;
		
		[Bindable]
		[Inspectable(minValue="0.0")] 
		
		/**
		 *  @copy spark.core.IViewport#verticalScrollPosition
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		override public function get verticalScrollPosition():Number 
		{
			return _verticalScrollPosition;
		}
		
		/**
		 *  @private
		 */
		/* override */ 
		public function set verticalScrollPosition(value:Number):void 
		{
			if (_verticalScrollPosition == value)
				return;
			/*
			const gridLayout:GridLayout = layout as GridLayout;
			const leftGridView:GridView = gridLayout.leftGridView;
			const centerGridView:GridView = gridLayout.centerGridView;	
			
			if (centerGridView)
			{
				const gridViewLayout:GridViewLayout = centerGridView.gridViewLayout;
				const gridMaxVSP:Number = contentHeight - height;
				const centerContentHeight:Number = Math.ceil(gridViewLayout.gridDimensionsView.getContentHeight());
				const centerMaxVSP:Number = centerContentHeight - centerGridView.height;
				const vsp:Number = (gridMaxVSP > 0) ? (centerMaxVSP / gridMaxVSP) * value : 0;
				
				centerGridView.verticalScrollPosition = vsp;
				
				if (leftGridView)
					leftGridView.verticalScrollPosition = vsp;
			}
			*/
			_verticalScrollPosition = value;
			
		}
		
		//----------------------------------
		//  hoverIndicator
		//----------------------------------
		
		private var _hoverIndicator:IFactory = null;
		
		[Bindable("hoverIndicatorChanged")]
		
		/**
		 *  If <code>selectionMode</code> is
		 *  <code>GridSelectionMode.SINGLE_ROW</code> or
		 *  <code>GridSelectionMode.MULTIPLE_ROWS</code>. 
		 *  a single visual element displayed for the row under the mouse.
		 *  If <code>selectionMode</code> is
		 *  <code>GridSelectionMode.SINGLE_CELL</code> or
		 *  <code>GridSelectionMode.MULTIPLE_CELLS</code>,
		 *  the visual element for the cell.
		 * 
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get hoverIndicator():IFactory
		{
			return _hoverIndicator;
		}
		
		/**
		 *  @private
		 */
		public function set hoverIndicator(value:IFactory):void
		{
			if (_hoverIndicator == value)
				return;
			
			_hoverIndicator = value;
			invalidateDisplayListFor("hoverIndicator");
			dispatchChangeEvent("hoverIndicatorChanged");
		}    
		
		//----------------------------------
		//  hoverColumnIndex 
		//----------------------------------
		
		private var _hoverColumnIndex:int = -1;
		
		[Bindable("hoverColumnIndexChanged")]
		
		/**
		 *  If <code>showHoverIndicator</code> is <code>true</code>,  
		 *  Specifies column index of the <code>hoverIndicator</code>.
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_ROW</code> or
		 *  <code>GridSelectionMode.MULTIPLE_ROWS</code>, then the indicator
		 *  occupies the entire row and <code>hoverColumnIndex</code> is ignored. 
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_CELL</code> or
		 *  <code>GridSelectionMode.MULTIPLE_CELLS</code> then the <code>hoverIndicator</code>
		 *  occupies the specified cell.
		 *  
		 *  <p>Setting <code>hoverColumnIndex</code> to -1 (the default) means 
		 *  that the column index is undefined and a cell hover indicator is not displayed.</p>
		 * 
		 *  @default -1
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5 
		 */
		public function get hoverColumnIndex():int
		{
			return _hoverColumnIndex;
		}
		
		/**
		 *  @private
		 */
		public function set hoverColumnIndex(value:int):void
		{
			if (_hoverColumnIndex == value)
				return;
			
			_hoverColumnIndex = value;
			
			// Unconditionally invalidate because renderers may depend on
			// hoverColumnIndex even when the hoverIndicator doesn't exist.
			invalidateDisplayListFor("hoverIndicator");
			dispatchChangeEvent("hoverColumnIndexChanged");
		}
		
		//----------------------------------
		//  hoverRowIndex
		//----------------------------------
		
		private var _hoverRowIndex:int = -1;
		
		[Bindable("hoverRowIndexChanged")]
		
		/**
		 *  If <code>showHoverIndicator</code> is <code>true</code>,  
		 *  specifies the column index of the <code>hoverIndicator</code>.
		 *  If <code>selectionMode</code> is
		 *  <code>GridSelectionMode.SINGLE_ROW</code> or
		 *  <code>GridSelectionMode.MULTIPLE_ROWS</code>, then the indicator
		 *  occupies the entire row and <code>hoverColumnIndex</code> is ignored.   
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_CELL</code> or
		 *  <code>GridSelectionMode.MULTIPLE_CELLS</code> then the <code>hoverIndicator</code>
		 *  occupies the specified cell.
		 * 
		 *  <p>Setting <code>hoverRowIndex</code> to -1,the default, means that 
		 *  the row index is undefined and a hover indicator is not displayed.</p>
		 * 
		 *  @default -1
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5 
		 */
		public function get hoverRowIndex():int
		{
			return _hoverRowIndex;
		}
		
		/**
		 *  @private
		 */
		public function set hoverRowIndex(value:int):void
		{
			if (_hoverRowIndex == value)
				return;
			
			_hoverRowIndex = value;
			
			// Unconditionally invalidate because renderers may depend on
			// hoverRowIndex even when the hoverIndicator doesn't exist.
			invalidateDisplayListFor("hoverIndicator");           
			dispatchChangeEvent("hoverRowIndexChanged");
		}
		
		//----------------------------------
		//  columns
		//----------------------------------    
		
		private var _columns:IList = null;
		private var columnsChanged:Boolean = false;
		
		[Bindable("columnsChanged")]
		[Inspectable(category="General")]
		
		/**
		 *  The list of GridColumn objectss displayed by this grid.  
		 *  Each column selects different data provider item properties 
		 *  to display.
		 *  
		 *  <p>GridColumn objects can only appear in the <code>columns</code> 
		 *  for a single Grid control.</p> 
		 *  
		 *  @default null
		 * 
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5 
		 */
		public function get columns():IList
		{
			return _columns;
		}
		
		/**
		 *  @private
		 */
		public function set columns(value:IList):void
		{
			if (_columns == value)
				return;
			
			// Remove the old column listener, and set each column's grid=null, columnIndex=-1.
			
			const oldColumns:IList = _columns;
			if (oldColumns)
			{
				oldColumns.removeEventListener(CollectionEvent.COLLECTION_CHANGE, columns_collectionChangeHandler);
				for (var index:int = 0; index < oldColumns.length; index++)
				{
					
					var oldColumn:GridColumn = GridColumn(oldColumns.getItemAt(index));
					oldColumn.setGrid(null);
					oldColumn.setColumnIndex(-1);
					
				}
			}
			
			_columns = value; 
			
			// Add the new columns listener, and set their grid,columnIndex properties.
			// The listener is a local method, so creating a weak reference to it (last 
			// addEventListener parameter) is safe, since the listener's lifetime is the 
			// same as this object.        
			
			const newColumns:IList = _columns;
			if (newColumns)
			{
				newColumns.addEventListener(CollectionEvent.COLLECTION_CHANGE, columns_collectionChangeHandler, false, 0); //, true);
				for (index = 0; index < newColumns.length; index++)
				{
					
					var newColumn:GridColumn = GridColumn(newColumns.getItemAt(index));
					newColumn.setGrid(this);
					newColumn.setColumnIndex(index);
					
				}
			}
			
			columnsChanged = true;
			generatedColumns = false;        
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			
			dispatchChangeEvent("columnsChanged");             
		}
		
		/**
		 *  @private
		 */
		private function getColumnsLength():uint
		{
			const columns:IList = columns;
			return (columns) ? columns.length : 0;
		}
		
		/**
		 *  @private
		 *  This method is similar to mx.controls.DataGrid/ls().
		 */
		private function generateColumns():IList
		{
			var item:Object = typicalItem;
			if (!item && dataProvider && (dataProvider.length > 0))
				item = dataProvider.getItemAt(0);
			
			var itemColumns:IList = null;
			if (item)
			{
				itemColumns = new ArrayList();
				const classInfo:Object = ObjectUtil.getClassInfo(item, ["uid", "mx_internal_uid"]);
				if (classInfo)
				{
					for each (var property:QName in classInfo.properties)
					{
						
						var column:GridColumn = new GridColumn();
						column.dataField = property.localName;
						itemColumns.addItem(column);
						
					}
				}
			}
			
			return itemColumns;
		}
		
		//----------------------------------
		//  dataProvider
		//----------------------------------
		
		private var _dataProvider:IList = null;
		private var dataProviderChanged:Boolean;
		
		[Bindable("dataProviderChanged")]
		[Inspectable(category="Data")]
		
		/**
		 *  A list of data items that correspond to the rows in the grid.   
		 *  Each grid column is associated with a property of the 
		 *  data items to display that property in the grid <i>cells</i>.
		 * 
		 *  @default null
		 * 
		 *  @see spark.components.Grid#columns
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5 
		 */
		public function get dataProvider():IList
		{
			return _dataProvider;
		}
		
		/**
		 *  @private
		 */
		public function set dataProvider(value:IList):void
		{
			if (_dataProvider == value)
				return;
			
			const oldDataProvider:IList = dataProvider;
			if (oldDataProvider)
				oldDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler);
			
			_dataProvider = value;
			
			// The listener is a local method, so creating a weak reference to it (last addEventListener 
			// parameter) is safe, since the listener's lifetime is the same as this object.
			
			const newDataProvider:IList = dataProvider;
			if (newDataProvider)
				newDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataProvider_collectionChangeHandler, false, 0); //, true);        
			
			dataProviderChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			
			dispatchChangeEvent("dataProviderChanged");
		}
		
		//----------------------------------
		//  dataTipField
		//----------------------------------
		
		private var _dataTipField:String = null;
		
		[Bindable("dataTipFieldChanged")]
		[Inspectable(category="Data", defaultValue="null")]
		
		/**
		 *  @copy spark.components.gridClasses.GridColumn#dataTipField
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
			return _dataTipField;
		}
		
		/**
		 *  @private
		 */
		public function set dataTipField(value:String):void
		{
			if (_dataTipField == value)
				return;
			
			_dataTipField = value;
			invalidateDisplayList();
			dispatchChangeEvent("dataTipFieldChanged");
		}
		
		//----------------------------------
		//  dataTipFunction
		//----------------------------------
		
		private var _dataTipFunction:Function = null;
		
		[Bindable("dataTipFunctionChanged")]
		[Inspectable(category="Data")]
		
		/**
		 *  @copy spark.components.gridClasses.GridColumn#dataTipFunction
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
			return _dataTipFunction;
		}
		
		/**
		 *  @private
		 */
		public function set dataTipFunction(value:Function):void
		{
			if (_dataTipFunction == value)
				return;
			
			_dataTipFunction = value;
			invalidateDisplayList();        
			dispatchChangeEvent("dataTipFunctionChanged");
		}    
		
		
		//----------------------------------
		//  doubleClickMode
		//----------------------------------
		private var _doubleClickMode:String = GridDoubleClickMode.ROW;
		
		[Bindable("doubleClickModeChanged")]
		[Inspectable(category="General", enumeration="cell,grid,row", defaultValue="row")]
		
		/**
		 *  The doubleClick mode of the control.  Possible values are:
		 *  <code>GridDoubleClickMode.CELL</code>, 
		 *  <code>GridDoubleClickMode.GRID</code>, 
		 *  <code>GridDoubleClickMode.ROW</code>, 
		 * 
		 *  <p>Changing the doubleClickMode changes the double click
		 *  criteria for firing the doubleClick event</p>
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
			return _doubleClickMode;
		}
		
		/**
		 *  @private
		 */
		public function set doubleClickMode(newValue:String):void
		{
			if (newValue == _doubleClickMode)
			{
				return;
			}
			
			switch(newValue)
			{
				case GridDoubleClickMode.CELL:
				case GridDoubleClickMode.GRID:
				case GridDoubleClickMode.ROW:
				{
					_doubleClickMode = newValue;
					
					dispatchChangeEvent("doubleClickModeChanged");
					
					break;
				}
			}
		}
		
		
		//----------------------------------
		//  gridDimensions (mx_internal)
		//----------------------------------
		
		private var _gridDimensions:GridDimensions = null;
		
		mx_internal function get gridDimensions():GridDimensions
		{
			if (!_gridDimensions)
				_gridDimensions = new GridDimensions();
			
			return _gridDimensions;
		}
		
		//----------------------------------
		//  itemRenderer
		//----------------------------------
		
		private var _itemRenderer:IFactory = null;
		private var itemRendererChanged:Boolean = false;
		
		[Bindable("itemRendererChanged")]
		[Inspectable(category="Data")]
		
		/**
		 *  The item renderer that's used for columns that do not specify one.
		 * 
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5 
		 */
		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}
		
		/**
		 *  @private
		 */
		public function set itemRenderer(value:IFactory):void
		{
			if (_itemRenderer == value)
				return;
			
			_itemRenderer = value;
			
			itemRendererChanged = true;
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			
			dispatchChangeEvent("itemRendererChanged");
		}    
		
		//----------------------------------
		//  columnSeparator
		//----------------------------------
		
		private var _columnSeparator:IFactory = null;
		
		[Bindable("columnSeparatorChanged")]
		
		/**
		 *  A visual element displayed between each column.
		 * 
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get columnSeparator():IFactory
		{
			return _columnSeparator;
		}
		
		/**
		 *  @private
		 */
		public function set columnSeparator(value:IFactory):void
		{
			if (_columnSeparator == value)
				return;
			
			_columnSeparator = value;
			invalidateDisplayList();
			dispatchChangeEvent("columnSeparatorChanged");
		}    
		
		//----------------------------------
		//  gridSelection (mx_internal)
		//----------------------------------
		
		/**
		 *  @private
		 */
		
		private var _gridSelection:GridSelection;
		mx_internal function get gridSelection():GridSelection
		{
			if (!_gridSelection)
				_gridSelection = createGridSelection();
			
			return _gridSelection;
		}
		
		/**
		 *  @private
		 *  If this Grid is serving as a DataGrid skin part, then this property is created 
		 *  by DataGrid/partAdded() and then set here.   It is only set once, unless that 
		 *  "grid" part is removed, at which point it's set to null.
		 */
		
		mx_internal function set gridSelection(value:GridSelection):void
		{
			_gridSelection = value;
		}
		
		//----------------------------------
		//  dataGrid
		//----------------------------------
		
		private var _dataGrid:DataGrid = null;
		
		[Bindable("dataGridChanged")]
		
		/**
		 *  The DataGrid control for which this Grid is used as the grid skin part.
		 * 
		 *  @default null
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
		 *  @private
		 */
		public function set dataGrid(value:DataGrid):void
		{
			if (_dataGrid == value)
				return;
			
			_dataGrid = value;
			dispatchChangeEvent("dataGridChanged");
		}
		
		//----------------------------------
		//  lockedColumnCount
		//----------------------------------
		
		private var _lockedColumnCount:int = 0;
		
		[Bindable("lockedColumnCountChanged")]
		[Inspectable(category="General", defaultValue="0", minValue="0")]	
		
		/**
		 *  The first lockedColumnCount columns are "locked", i.e. they do not scroll horizontally. 
		 *  If lockedColumnCount is zero (the default) then changes to the horizontalScrollPosition
		 *  affect all columns.
		 * 
		 *  <p>The locked columns are displayed in the topGridView and, if lockedRowCount is also
		 *  greater than zero, the topLeftGridView.  The locked columns are separated from the remaining 
		 *  columns by a lockedColumnSeparator.</p>
		 * 
		 *  @default 0
		 * 
		 *  @see spark.components.gridClasses.GridColumn#topGridView 
		 *  @see spark.components.gridClasses.GridColumn#topLeftGridView
		 * 	@see spark.components.gridClasses.GridColumn#lockedColumnSeparator
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 5.0
		 */
		public function get lockedColumnCount():int
		{
			return _lockedColumnCount;
		}
		
		/**
		 *  @private
		 */
		public function set lockedColumnCount(value:int):void
		{
			if (_lockedColumnCount == value)
				return;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			
			_lockedColumnCount = value;
			dispatchChangeEvent("lockedColumnCountChanged");
		}
		
		//----------------------------------
		//  lockedColumnsSeparator
		//----------------------------------
		
		private var _lockedColumnsSeparator:IFactory = null;
		
		[Bindable("lockedColumnsSeparatorChanged")]
		
		/**
		 *  A visual element displayed between the locked and unlocked columns.  The factory value of this
		 *  property is used to create the lockedColumnsSeparatorElement.
		 * 
		 *  @see spark.components.Grid#lockedRowsSeparatorElement	
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 5.0
		 * 
		 *  @default null
		 */
		public function get lockedColumnsSeparator():IFactory
		{
			return _lockedColumnsSeparator;
		}
		
		/**
		 *  @private
		 */
		public function set lockedColumnsSeparator(value:IFactory):void
		{
			if (_lockedColumnsSeparator == value)
				return;
			
			_lockedColumnsSeparator = value;
			invalidateDisplayList();
			dispatchChangeEvent("lockedColumnsSeparatorChanged");
		} 
		
		//----------------------------------
		//  lockedRowCount
		//----------------------------------
		
		private var _lockedRowCount:int = 0;
		
		[Bindable("lockedRowCountChanged")]
		[Inspectable(category="General", defaultValue="0", minValue="0")]	
		
		/**
		 *  The first lockedRowCount rows are "locked", i.e. they do not scroll vertically. 
		 *  If lockedRowCount is zero (the default) then changes to the verticalScrollPosition
		 *  affect all rows.
		 * 
		 *  <p>The locked rows are displayed in the leftGridView and, if lockedColumnCount is also
		 *  greater than zero, the topLeftGridView.  The locked rows are separated from the remaining 
		 *  rows by a lockedRowSeparator.</p>
		 * 
		 *  @default 0
		 * 
		 *  @see spark.components.gridClasses.GridColumn#leftGridView 
		 *  @see spark.components.gridClasses.GridColumn#topLeftGridView
		 * 	@see spark.components.gridClasses.GridColumn#lockedRowSeparator
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 5.0
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
			if (_lockedRowCount == value)
				return;
			
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
			
			_lockedRowCount = value;
			dispatchChangeEvent("lockedRowCountChanged");
		}
		
		//----------------------------------
		//  lockedRowsSeparator
		//----------------------------------
		
		private var _lockedRowsSeparator:IFactory = null;
		
		[Bindable("lockedRowsSeparatorChanged")]
		
		/**
		 *  A visual element displayed between the locked and unlocked rows.   The factory value of this
		 *  property is used to create the lockedRowsSeparatorElement.
		 * 
		 *  @default null
		 * 
		 *  @see spark.components.Grid#lockedRowsSeparatorElement
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 5.0
		 */
		public function get lockedRowsSeparator():IFactory
		{
			return _lockedRowsSeparator;
		}
		
		/**
		 *  @private
		 */
		public function set lockedRowsSeparator(value:IFactory):void
		{
			if (_lockedRowsSeparator == value)
				return;
			
			_lockedRowsSeparator = value;
			invalidateDisplayList();
			dispatchChangeEvent("lockedRowsSeparatorChanged");
		}	
		
		//----------------------------------
		//  preserveSelection (delegates to gridSelection.preserveSelection)
		//----------------------------------
		
		[Inspectable(category="General", defaultValue="true")]
		
		/**
		 *  If <code>true</code>, the selection is preserved when the data provider 
		 *  refreshes its collection. 
		 *  Because this refresh requires each item in the selection to be saved, 
		 *  this action is not desirable if the selection is large.
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
			return gridSelection.preserveSelection;
		}
		
		/**
		 *  @private
		 */    
		public function set preserveSelection(value:Boolean):void
		{
			gridSelection.preserveSelection = value;
		}
		
		//----------------------------------
		//  requestedMaxRowCount
		//----------------------------------
		
		private var _requestedMaxRowCount:int = 10;
		
		[Inspectable(category="General", defaultValue="10", minValue="-1")]
		
		/**
		 *  The measured height of the grid is large enough to display 
		 *  no more than <code>requestedMaxRowCount</code> rows.
		 * 
		 *  <p>This property has no effect if any of the following are true;
		 *  <ul>
		 *      <li><code>requestedRowCount</code> is set.</li>
		 *      <li>The actual size of the grid has been explicitly set.</li>
		 *  </ul>
		 *  </p>
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
			return _requestedMaxRowCount;
		}
		
		/**
		 *  @private
		 */
		public function set requestedMaxRowCount(value:int):void
		{
			if (_requestedMaxRowCount == value)
				return;
			
			_requestedMaxRowCount = value;
			invalidateSize();
		}      
		
		//----------------------------------
		//  requestedMinRowCount
		//----------------------------------
		
		private var _requestedMinRowCount:int = -1;
		
		[Inspectable(category="General", minValue="-1")]
		
		/**
		 *  The measured height of this grid is large enough to display 
		 *  at least <code>requestedMinRowCount</code> rows.
		 * 
		 *  <p>This property has no effect if any of the following are true;
		 *  <ul>
		 *      <li><code>requestedRowCount</code> is set.</li>
		 *      <li>The actual size of the grid has been explicitly set.</li>
		 *  </ul>
		 *  </p>
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
			return _requestedMinRowCount;
		}
		
		/**
		 *  @private
		 */
		public function set requestedMinRowCount(value:int):void
		{
			if (_requestedMinRowCount == value)
				return;
			
			_requestedMinRowCount = value;
			invalidateSize();
		}    
		
		//----------------------------------
		//  requestedRowCount
		//----------------------------------
		
		private var _requestedRowCount:int = -1;
		
		[Inspectable(category="General", minValue="-1")]
		
		/**
		 *  The measured height of this grid is large enough to display 
		 *  the first <code>requestedRowCount</code> rows. 
		 * 
		 *  <p>If <code>requestedRowCount</code> is -1, then the measured
		 *  size will be big enough for all of the layout elements.</p>
		 * 
		 *  <p>If the actual size of the grid has been explicitly set,
		 *  then this property has no effect.</p>
		 * 
		 *  @default -1
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4
		 */
		public function get requestedRowCount():int
		{
			return _requestedRowCount;
		}
		
		/**
		 *  @private
		 */
		public function set requestedRowCount(value:int):void
		{
			if (_requestedRowCount == value)
				return;
			
			_requestedRowCount = value;
			invalidateSize();
		}
		
		//----------------------------------
		//  requestedMinColumnCount
		//----------------------------------
		
		private var _requestedMinColumnCount:int = -1;
		
		[Inspectable(category="General", minValue="-1")]
		
		/**
		 *  The measured width of this grid is large enough to display 
		 *  at least <code>requestedMinColumnCount</code> columns.
		 * 
		 *  <p>This property has no effect if any of the following are true;
		 *  <ul>
		 *      <li><code>requestedColumnCount</code> is set.</li>
		 *      <li>The actual size of the grid has been explicitly set.</li>
		 *      <li>The grid is inside a Scroller component.</li>
		 *  </ul>
		 *  </p>
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
			return _requestedMinColumnCount;
		}
		
		/**
		 *  @private
		 */
		public function set requestedMinColumnCount(value:int):void
		{
			if (_requestedMinColumnCount == value)
				return;
			
			_requestedMinColumnCount = value;
			invalidateSize();
		}   
		
		//----------------------------------
		//  requestedColumnCount
		//----------------------------------
		
		private var _requestedColumnCount:int = -1;
		
		[Inspectable(category="General", minValue="-1")]
		
		/**
		 *  The measured width of this grid is large enough to display 
		 *  the first <code>requestedColumnCount</code> columns. 
		 *  If <code>requestedColumnCount</code> is -1, then the measured
		 *  width is big enough for all of the columns.
		 * 
		 *  <p>If the actual size of the grid has been explicitly set,
		 *  then this property has no effect.</p>
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
			return _requestedColumnCount;
		}
		
		/**
		 *  @private
		 */
		public function set requestedColumnCount(value:int):void
		{
			if (_requestedColumnCount == value)
				return;
			
			_requestedColumnCount = value;
			invalidateSize();
		}    
		
		//----------------------------------
		//  requireSelection
		//----------------------------------
		
		[Inspectable(category="General", defaultValue="false")]
		
		/**
		 *  If <code>true</code> and the <code>selectionMode</code> property is not 
		 *  <code>GridSelectionMode.NONE</code>, an item must always be selected 
		 *  in the grid.
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
			return gridSelection.requireSelection;
		}
		
		/**
		 *  @private
		 */    
		public function set requireSelection(value:Boolean):void
		{
			gridSelection.requireSelection = value;
			
			if (value)
				invalidateDisplayListFor("selectionIndicator");
		}
		
		//----------------------------------
		//  resizableColumns
		//----------------------------------
		
		private var _resizableColumns:Boolean = true;
		
		[Bindable("resizableColumnsChanged")]
		[Inspectable(category="General", defaultValue="true")]
		
		/**
		 *  Indicates whether the user can change the size of the columns.
		 *  If <code>true</code>, the user can stretch or shrink the columns of 
		 *  the DataGrid control by dragging the grid lines between the header cells.
		 *  If <code>true</code>, individual columns must also have their 
		 *  <code>resizable</code> properties set to <code>false</code> to 
		 *  prevent the user from resizing a particular column.  
		 *
		 *  @default true
		 *    
		 *  @see spark.components.gridClasses.GridColumn
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get resizableColumns():Boolean
		{
			return _resizableColumns;
		}
		
		/**
		 *  @private
		 */        
		public function set resizableColumns(value:Boolean):void
		{
			if (value == resizableColumns)
				return;
			
			_resizableColumns = value;        
			dispatchChangeEvent("resizableColumnsChanged");            
		}
		
		//----------------------------------
		//  rowBackground
		//----------------------------------
		
		private var _rowBackground:IFactory = null;
		
		[Bindable("rowBackgroundChanged")]
		
		/**
		 *  A visual element that's displays the background for each row.  
		 * 
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get rowBackground():IFactory
		{
			return _rowBackground;
		}
		
		/**
		 *  @private
		 */
		public function set rowBackground(value:IFactory):void
		{
			if (_rowBackground == value)
				return;
			
			_rowBackground = value;
			invalidateDisplayList();
			dispatchChangeEvent("rowBackgroundChanged");
		}
		
		//----------------------------------
		//  rowHeight
		//----------------------------------
		
		private var _rowHeight:Number = NaN;
		private var rowHeightChanged:Boolean;
		
		[Bindable("rowHeightChanged")]
		[Inspectable(category="General", minValue="0.0")]
		
		/**
		 *  If <code>variableRowHeight</code> is <code>false</code>, then 
		 *  this property specifies the actual height of each row, in pixels.
		 * 
		 *  <p>If <code>variableRowHeight</code> is <code>true</code>, 
		 *  the value of this property is used as the estimated
		 *  height for rows that haven't been scrolled into view yet, rather
		 *  than the preferred height of renderers configured with the <code>typicalItem</code>.
		 *  Similarly, when the Grid pads its display with empty rows, this property
		 *  specifies the empty rows' height.</p>
		 * 
		 *  <p>If <code>variableRowHeight</code> is <code>false</code>, 
		 *  the default value of this property is the maximum preferred height
		 *  of the per-column renderers created for the <code>typicalItem</code>.</p>
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get rowHeight():Number
		{
			return _rowHeight;
		}
		
		/**
		 *  @private
		 */
		public function set rowHeight(value:Number):void
		{
			if (_rowHeight == value)
				return;
			
			_rowHeight = value;
			rowHeightChanged = true;        
			invalidateProperties();
			
			dispatchChangeEvent("rowHeightChanged");            
		}
		
		/**
		 *  @private
		 */	
		private function setFixedRowHeight(value:Number):void
		{
			if (_rowHeight == value)
				return;
			
			_rowHeight = value;
			dispatchChangeEvent("rowHeightChanged");		
		}
		
		//----------------------------------
		//  rowSeparator
		//----------------------------------
		
		private var _rowSeparator:IFactory = null;
		
		[Bindable("rowSeparatorChanged")]
		
		/**
		 *  A visual element that's displayed in between each row.
		 * 
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get rowSeparator():IFactory
		{
			return _rowSeparator;
		}
		
		/**
		 *  @private
		 */
		public function set rowSeparator(value:IFactory):void
		{
			if (_rowSeparator == value)
				return;
			
			_rowSeparator = value;
			invalidateDisplayList();
			dispatchChangeEvent("rowSeparatorChanged");
		}    
		
		//----------------------------------
		//  selectedCell
		//----------------------------------
		
		[Bindable("selectionChange")]
		[Bindable("valueCommit")]
		
		/**
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_CELL</code> 
		 *  or <code>GridSelectionMode.MULTIPLE_CELLS</code>, returns the first
		 *  selected cell starting at row 0 column 0 and progressing through each
		 *  column in a row before moving to the next row.
		 * 
		 *  <p>When the user changes the selection by interacting with the 
		 *  control, the control dispatches the <code>selectionChange</code> 
		 *  event. When the user changes the selection programmatically, the 
		 *  control dispatches the <code>valueCommit</code> event.</p>
		 * 
		 *  <p> This property is intended to be used to initialize or bind to the
		 *  selection in MXML markup.  The <code>setSelectedCell()</code> method 
		 *  should be used for programatic selection updates, for example 
		 *  when writing a keyboard or mouse event handler. </p> 
		 *
		 *  @default null
		 * 
		 *  @return CellPosition of the first selected cell or null if there is
		 *  no cell selection.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get selectedCell():CellPosition
		{
			var selectedCells:Vector.<CellPosition> = gridSelection.allCells();
			return selectedCells.length ? selectedCells[0] : null;
		}
		
		/**
		 *  @private
		 */
		public function set selectedCell(value:CellPosition):void
		{
			const rowIndex:int = (value) ? value.rowIndex : -1;
			const columnIndex:int = (value) ? value.columnIndex : -1;
			
			// Defer the selection change if we haven't been initialized
			
			if (!initialized)
			{
				// Append a deferred operation function that selects the specified cell
				
				var f:Function = function():void
				{
					if ((rowIndex != -1) && (columnIndex != -1))
						setSelectedCell(rowIndex, columnIndex);
					else
						clearSelection();
				}
				
				deferredOperations.push(f);  // function f() to be called by commitProperties()
				invalidateProperties();
			}
			else
			{
				if ((rowIndex != -1) && (columnIndex != -1))
					setSelectedCell(rowIndex, columnIndex);
				else
					clearSelection();            
			}
		}        
		
		//----------------------------------
		//  selectedCells
		//----------------------------------
		
		[Bindable("selectionChange")]
		[Bindable("valueCommit")]
		
		/**
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_CELL</code> 
		 *  or <code>GridSelectionMode.MULTIPLE_CELLS</code>, returns a Vector
		 *  of CellPosition objects representing the positions of the selected
		 *  cells in the grid.
		 * 
		 *  <p>When the user changes the selection by interacting with the 
		 *  control, the control dispatches the <code>selectionChange</code> 
		 *  event. When the user changes the selection programmatically, the 
		 *  control dispatches the <code>valueCommit</code> event.</p>
		 * 
		 *  <p> This property is intended to be used to initialize or bind to the
		 *  selection in MXML markup.  The <code>setSelectedCell()</code> method 
		 *  should be used for programatic selection updates, for example when 
		 *  writing a keyboard or mouse event handler. </p> 
		 * 
		 *  <p>The default value is an empty <code>Vector.&lt;CellPosition&gt;</code></p>
		 * 
		 *  @return Vector of CellPosition objects where each element represents
		 *  a selected cell.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get selectedCells():Vector.<CellPosition>
		{
			return gridSelection.allCells();
		}
		
		/**
		 *  @private
		 */
		public function set selectedCells(value:Vector.<CellPosition>):void
		{
			// Defensively deep-copy the incoming value; tolerate value=null
			
			var valueCopy:Vector.<CellPosition> = new Vector.<CellPosition>(0);
			if (value)
			{
				for each (var cell:CellPosition in value)
				valueCopy.push(new CellPosition(cell.rowIndex, cell.columnIndex));
			}
			
			// Defer the selection change if we haven't been initialized
			
			if (!initialized)
			{        
				// Append a deferred operation function that selects the specified cells
				
				var f:Function = function():void
				{
					doSetSelectedCells(valueCopy);
				}
				deferredOperations.push(f);  // function f() to be called by commitProperties()
				invalidateProperties();
			}
			else
			{
				doSetSelectedCells(valueCopy);
			}
		}          
		
		//----------------------------------
		//  selectedIndex
		//----------------------------------
		
		[Bindable("selectionChange")]
		[Bindable("valueCommit")]
		[Inspectable(category="General", defaultValue="-1")]
		
		/**
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_ROW</code> 
		 *  or <code>GridSelectionMode.MULTIPLE_ROWS</code>, returns the
		 *  rowIndex of the first selected row. 
		 * 
		 *  <p>When the user changes the selection by interacting with the 
		 *  control, the control dispatches the <code>selectionChange</code> 
		 *  event. When the user changes the selection programmatically, the 
		 *  control dispatches the <code>valueCommit</code> event.</p>
		 * 
		 *  <p> This property is intended to be used to initialize or bind to the
		 *  selection in MXML markup.  The <code>setSelectedCell()</code> method should be used
		 *  for programatic selection updates, for example when writing a keyboard
		 *  or mouse event handler. </p> 
		 *
		 *  @default -1
		 * 
		 *  @return rowIndex of first selected row or -1 if there are no
		 *  selected rows.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get selectedIndex():int
		{
			var selectedRows:Vector.<int> = gridSelection.allRows();
			return (selectedRows.length > 0) ? selectedRows[0] : -1;
		}
		
		/**
		 *  @private
		 */
		public function set selectedIndex(value:int):void
		{
			// Defer the selection change if we haven't been initialized
			
			if (!initialized)
			{        
				// Append a deferred operation function that selects the specified index
				
				var f:Function = function():void
				{
					if (value != -1)
						setSelectedIndex(value);
					else
						clearSelection();
				}
				deferredOperations.push(f);  // function f() to be called by commitProperties()
				invalidateProperties();
			}
			else
			{
				if (value != -1)
					setSelectedIndex(value);
				else
					clearSelection();
			}
		}
		
		//----------------------------------
		//  selectedIndices
		//----------------------------------
		
		[Bindable("selectionChange")]
		[Bindable("valueCommit")]
		[Inspectable(category="General")]
		
		/**
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_ROW</code> 
		 *  or <code>GridSelectionMode.MULTIPLE_ROWS</code>, returns a Vector of 
		 *  the selected rows indices.  For all other selection modes, this 
		 *  method has no effect.
		 * 
		 *  <p>When the user changes the selection by interacting with the 
		 *  control, the control dispatches the <code>selectionChange</code> 
		 *  event. When the user changes the selection programmatically, the 
		 *  control dispatches the <code>valueCommit</code> event.</p>
		 * 
		 *  <p> This property is intended to be used to initialize or bind to the
		 *  selection in MXML markup.  The setSelectedCell() method should be used
		 *  for programatic selection updates, for example when writing a keyboard
		 *  or mouse event handler. </p> > 
		 *
		 *  <p>The default value is an empty <code>Vector.&lt;int&gt;</code></p>
		 * 
		 *  @return Vector of ints where each element is the index in 
		 *  data provider of the selected row.
		 *  
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get selectedIndices():Vector.<int>
		{
			return gridSelection.allRows();
		}
		
		/**
		 *  @private
		 */
		public function set selectedIndices(value:Vector.<int>):void
		{
			// Defensively copy the incoming value; tolerate value=null
			
			const valueCopy:Vector.<int> = (value) ? value.concat() : new Vector.<int>(0);
			
			// Defer the selection change if we haven't been initialized
			
			if (!initialized)
			{        
				// Append a deferred operation function that selects the specified indices
				
				var f:Function = function():void
				{
					doSetSelectedIndices(valueCopy);
				};
				deferredOperations.push(f);  // function f() to be called by commitProperties()
				invalidateProperties();
			}
			else
			{
				doSetSelectedIndices(valueCopy);
			}
		}        
		
		//----------------------------------
		//  selectedItem
		//----------------------------------
		
		[Bindable("selectionChange")]
		[Bindable("valueCommit")]
		[Inspectable(category="General", defaultValue="null")]
		
		/**
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_ROW</code> 
		 *  or <code>GridSelectionMode.MULTIPLE_ROWS</code>, returns the 
		 *  item in the the data provider that is currently selected or
		 *  <code>undefined</code> if no rows are selected.  
		 * 
		 *  <p>When the user changes the selection by interacting with the 
		 *  control, the control dispatches the <code>selectionChange</code> 
		 *  event. When the user changes the selection programmatically, the 
		 *  control dispatches the <code>valueCommit</code> event.</p>
		 * 
		 *  <p> This property is intended to be used to initialize or bind to the
		 *  selection in MXML markup.  The <code>setSelectedCell()</code> method should be used
		 *  for programatic selection updates, for example when writing a keyboard
		 *  or mouse event handler. </p> 
		 *  
		 *  @default null
		 * 
		 *  @return Vector of data provider items.
		 *  
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get selectedItem():Object
		{
			var rowIndex:int = selectedIndex;
			if (rowIndex == -1)
				return undefined;
			
			return getDataProviderItem(rowIndex);           
		}
		
		/**
		 *  @private
		 */
		public function set selectedItem(value:Object):void
		{
			// Defer the selection change if we haven't been initialized
			
			if (!initialized)
			{        
				// Append a deferred operation function that selects the specified item
				
				var f:Function = function():void
				{
					if (!dataProvider)
						return;
					
					const rowIndex:int = dataProvider.getItemIndex(value);
					if (rowIndex == -1)
						clearSelection();
					else
						setSelectedIndex(rowIndex);
				}
				deferredOperations.push(f);  // function f() to be called by commitProperties()
				invalidateProperties();
			}
			else
			{
				if (!dataProvider)
					return;
				
				const rowIndex:int = dataProvider.getItemIndex(value);
				if (rowIndex == -1)
					clearSelection();
				else
					setSelectedIndex(rowIndex);            
			}
		}        
		
		//----------------------------------
		//  selectedItems
		//----------------------------------
		
		[Bindable("selectionChange")]
		[Bindable("valueCommit")]
		[Inspectable(category="General")]
		
		/**
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_ROW</code> 
		 *  or <code>GridSelectionMode.MULTIPLE_ROWS</code>, returns a Vector of 
		 *  the dataProvider items that are currently selected.
		 * 
		 *  <p>When the user changes the selection by interacting with the 
		 *  control, the control dispatches the <code>selectionChange</code> 
		 *  event. When the user changes the selection programmatically, the 
		 *  control dispatches the <code>valueCommit</code> event.</p>
		 * 
		 *  <p> This property is intended to be used to initialize or bind to the
		 *  selection in MXML markup.  The setSelectedCell() method should be used
		 *  for programatic selection updates, for example when writing a keyboard
		 *  or mouse event handler. </p> 
		 *  
		 *  <p>The default value is an empty <code>Vector.&lt;Object&gt;</code></p>
		 * 
		 *  @return Vector of data provider items.
		 *  
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get selectedItems():Vector.<Object>
		{
			var rowIndices:Vector.<int> = selectedIndices;
			if (rowIndices.length == 0)
				return undefined;
			
			var items:Vector.<Object> = new Vector.<Object>();
			
			for each (var rowIndex:int in rowIndices)        
			items.push(dataProvider.getItemAt(rowIndex));
			
			return items;
		}
		
		/**
		 *  @private
		 */
		public function set selectedItems(value:Vector.<Object>):void
		{
			// Defensively copy the incoming value; tolerate value=null
			
			const valueCopy:Vector.<Object> = (value) ? value.concat() : new Vector.<Object>(0);
			
			// Defer the selection change if we haven't been initialized
			
			if (!initialized)
			{        
				// Append a deferred operation function that selects the specified items        
				
				var f:Function = function():void
				{
					doSetSelectedItems(valueCopy);
				}
				deferredOperations.push(f);  // function f() to be called by commitProperties()
				invalidateProperties();
			}
			else
			{
				doSetSelectedItems(valueCopy);
			}
		}        
		
		//----------------------------------
		//  selectionIndicator
		//----------------------------------
		
		private var _selectionIndicator:IFactory = null;
		
		[Bindable("selectionIndicatorChanged")]
		
		/**
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_ROW</code> or
		 *  <code>GridSelectionMode.MULTIPLE_ROWS</code>, 
		 *  a visual element that's displayed for each selected row, 
		 *  If <code>selectionMode</code> is
		 *  <code>GridSelectionMode.SINGLE_CELL</code> or
		 *  <code>GridSelectionMode.MULTIPLE_CELLS</code>,
		 *  a visual element displayed for each selected cell.
		 *  
		 *  @default null
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get selectionIndicator():IFactory
		{
			return _selectionIndicator;
		}
		
		/**
		 *  @private
		 */
		public function set selectionIndicator(value:IFactory):void
		{
			if (_selectionIndicator == value)
				return;
			
			_selectionIndicator = value;
			invalidateDisplayListFor("selectionIndicator");
			dispatchChangeEvent("selectionIndicatorChanged");
		}    
		
		//----------------------------------
		//  selectionLength (delegates to gridSelection.selectionLength)
		//----------------------------------
		
		[Bindable("selectionChange")]
		[Bindable("valueCommit")]
		
		/**
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_ROW</code> 
		 *  or <code>GridSelectionMode.MULTIPLE_ROWS</code>, 
		 *  returns the number of selected rows. 
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_CELLS</code> 
		 *  or <code>GridSelectionMode.MULTIPLE_CELLS</code>, 
		 *  returns the number of selected cells.
		 * 
		 *  @default 0
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function get selectionLength():int
		{
			return gridSelection.selectionLength;   
		}
		
		//----------------------------------
		//  selectionMode (delegates to gridSelection.selectionMode)
		//----------------------------------
		
		[Bindable("selectionModeChanged")]
		[Inspectable(category="General", enumeration="none,singleRow,multipleRows,singleCell,multipleCells", defaultValue="singleRow")]
		
		/**
		 *  The selection mode of the control.  Possible values are:
		 *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, 
		 *  <code>GridSelectionMode.MULTIPLE_ROWS</code>, 
		 *  <code>GridSelectionMode.NONE</code>, 
		 *  <code>GridSelectionMode.SINGLE_CELL</code>, and 
		 *  <code>GridSelectionMode.SINGLE_ROW</code>.
		 * 
		 *  <p>Changing the selectionMode causes the current selection to be 
		 *  cleared and the caretRowIndex and caretColumnIndex to be set to -1.</p>
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
			return gridSelection.selectionMode;
		}
		
		/**
		 *  @private
		 */
		public function set selectionMode(value:String):void
		{
			if (selectionMode == value)
				return;
			
			gridSelection.selectionMode = value;
			if (selectionMode != value) // value wasn't a valid GridSelectionMode constant
				return;
			
			initializeAnchorPosition();
			if (!requireSelection)
				initializeCaretPosition();
			
			invalidateDisplayListFor("selectionIndicator");
			
			dispatchChangeEvent("selectionModeChanged");
		}
		
		//----------------------------------
		//  showCaret
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _showCaret:Boolean = false;
		
		[Bindable("showCaretChanged")]    
		
		/**
		 *  Determines if the caret is visible.
		 *  TBD: when is this property automatically set?
		 */
		public function get showCaret():Boolean
		{
			return _showCaret;
		}
		
		/**
		 *  @private
		 */
		public function set showCaret(value:Boolean):void
		{
			if (_showCaret == value)
				return;
			
			_showCaret = value;
			invalidateDisplayListFor("caretIndicator");        
			dispatchChangeEvent("showCaretChanged");       
		}    
		
		//----------------------------------
		//  showDataTips
		//----------------------------------
		
		private var _showDataTips:Boolean = false;
		
		[Bindable("showDataTipsChanged")]
		[Inspectable(category="Data", defaultValue="false")]
		
		/**
		 *  If <code>true</code> then a dataTip is displayed for all visible cells.  
		 *  If <code>false</code>, the default,
		 *  then a dataTip is only displayed if the column's 
		 *  <code>showDataTips</code> property is <code>true</code>.
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
			invalidateDisplayList();
			dispatchChangeEvent("showDataTipsChanged");
		}
		
		//----------------------------------
		//  typicalItem
		//----------------------------------
		
		private var _typicalItem:Object = null;
		private var typicalItemChanged:Boolean = false;
		
		[Bindable("typicalItemChanged")]
		[Inspectable(category="Data")]
		
		/**
		 *  The grid's layout ensures that columns whose width is not specified are wide
		 *  enough to display an item renderer for this default data provider item.  
		 *  If a typical item is not specified, then the first data provider item is used.
		 * 
		 *  <p>Restriction: if the <code>typicalItem</code> is an IVisualItem, it must not 
		 *  also be a member of the data provider.</p>
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
			return _typicalItem;
		}
		
		/**
		 *  @private
		 */
		public function set typicalItem(value:Object):void
		{
			if (_typicalItem == value)
				return;
			
			_typicalItem = value;
			invalidateTypicalItemRenderer();
			dispatchChangeEvent("typicalItemChanged");
		}
		
		/**
		 *  Clears cached column width data that had been based on the 
		 *  <code>typicalItem</code> property, and requests a new layout pass.   
		 *  Call this method if some aspect of the <code>typicalItem</code> 
		 *  has changed that should be reflected by the Grid's layout.  
		 * 
		 *  <p>This method is called automatically if the <code>typicalItem</code> 
		 *  is changed directly. That means if the property is set to a new value 
		 *  that is not "==" to current value.</p>
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4.5 
		 */
		public function invalidateTypicalItemRenderer():void
		{
			typicalItemChanged = true;       
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}
		
		//----------------------------------
		//  variableRowHeight
		//----------------------------------
		
		private var _variableRowHeight:Boolean = false;
		private var variableRowHeightChanged:Boolean = false;
		
		[Bindable("variableRowHeightChanged")]
		[Inspectable(category="General", defaultValue="false")]
		
		/**
		 *  If <code>true</code>, each row's height is the maximum of 
		 *  preferred heights of the cells displayed so far.
		 * 
		 *  <p>If <code>false</code>, the height of each row is just 
		 *  the value of the <code>rowHeight</code> property.
		 *  If <code>rowHeight</code> isn't specified, then the height of 
		 *  each row is defined by the <code>typicalItem</code> property.</p>
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
			return _variableRowHeight;
		}
		
		/**
		 *  @private
		 */        
		public function set variableRowHeight(value:Boolean):void
		{
			if (value == variableRowHeight)
				return;
			
			_variableRowHeight = value;        
			variableRowHeightChanged = true;        
			invalidateProperties();
			
			dispatchChangeEvent("variableRowHeightChanged");            
		}
		
		//----------------------------------
		//  gridView
		//----------------------------------
		
		private var _gridView:IFactory = null;
		
		[Bindable("gridViewChanged")]
		
		/**
		 *  Used to initialize this grid's gridViews: centerGridView, leftGridView, topGridView, topLeftGridView. 
		 *  GridViews are created as needed, depending on the values of lockedRowCount and lockedColumnCount.
		 * 
		 *  @default null.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 5.0
		 */
		public function get gridView():IFactory
		{
			return _gridView;
		}
		
		/**
		 *  @private
		 */        
		public function set gridView(value:IFactory):void
		{
			if (value == _gridView)
				return;
			
			_gridView = value;
			invalidateProperties();
			
			// TBD clear everything
			
			dispatchChangeEvent("gridViewChanged");            
		}
		
		//--------------------------------------------------------------------------
		//
		//  GridSelection Cover Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  If <code>selectionMode</code> is 
		 *  <code>GridSelectionMode.MULTIPLE_ROWS</code>, selects all rows and
		 *  removes the caret or if <code>selectionMode</code> is 
		 *  <code>GridSelectionMode.MULTIPLE_CELLS</code> selects all cells  
		 *  and removes the caret.  For all other selection modes, this method 
		 *  has no effect.
		 *
		 *  <p>If items are added to the <code>dataProvider</code> or 
		 *  <code>columns</code> are added after this method is called, the
		 *  new rows or cells in the new column will be selected.</p>
		 * 
		 *  <p>This implicit "selectAll" mode ends when any of the following occur:
		 *  <ul>
		 *    <li>selection is cleared using <code>clearSelection</code></li>
		 *    <li>selection reset using one of <code>setSelectedCell</code>, 
		 *    <code>setSelectedCells</code>, <code>setSelectedIndex</code>, 
		 *    <code>selectIndices</code></li>
		 *    <li><code>dataProvider</code> is refreshed and <code>preserveSelection</code> is false</li>
		 *    <li><code>dataProvider</code> is reset</li>
		 *    <li><code>columns</code> is refreshed, 
		 *    <code>preserveSelection</code> is <code>false</code> and 
		 *    <code>selectionMode</code> is 
		 *    <code>GridSelectionMode.MULTIPLE_CELLS</code></li>
		 *    <li><code>columns</code> is reset and <code>selectionMode</code> is 
		 *    <code>GridSelectionMode.MULTIPLE_CELLS</code></li> 
		 *  </ul></p>
		 * 
		 *  @return <code>true</code> if the selection changed.
		 *    
		 *  @see spark.components.Grid#clearSelection
		 *  @see spark.components.Grid#selectIndices
		 *  @see spark.components.Grid#setSelectedCell
		 *  @see spark.components.Grid#setSelectedCells
		 *  @see spark.components.Grid#setSelectedIndex
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function selectAll():Boolean
		{           
			// Need to apply pending dataProvider and column changes so selection
			// isn't reset after it is set here.
			/*if (invalidatePropertiesFlag)
				UIComponentGlobals.layoutManager.validateClient(this, false);*/
			
			const selectionChanged:Boolean = gridSelection.selectAll();
			if (selectionChanged)
			{               
				initializeCaretPosition();               
				invalidateDisplayListFor("selectionIndicator");
				dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
			}
			
			return selectionChanged;
		}
		
		/**
		 *  Removes all of the selected rows and cells, if <code>selectionMode</code>  
		 *  is not <code>GridSelectionMode.NONE</code>.  Removes the caret and
		 *  sets the anchor to the initial item.
		 *
		 *  @return <code>true</code> if the selection changed.
		 *  <code>false</code> if there was nothing previously selected.
		 *    
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function clearSelection():Boolean
		{
			// Need to apply pending dataProvider and column changes so selection
			// isn't reset after it is set here.
			/*if (invalidatePropertiesFlag)
				UIComponentGlobals.layoutManager.validateClient(this, false);*/
			
			const selectionChanged:Boolean = gridSelection.removeAll();
			if (selectionChanged)
			{
				invalidateDisplayListFor("selectionIndicator");
				dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
			}
			
			// Remove caret and reset the anchor.
			initializeCaretPosition();
			initializeAnchorPosition();
			
			return selectionChanged;
		}
		
		//----------------------------------
		//  selection for rows
		//----------------------------------    
		
		/**
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_ROW</code>
		 *  or <code>GridSelectionMode.MULTIPLE_ROWS</code>, returns <code>true</code> 
		 *  if the row at <code>index</code> is in the current selection.
		 * 
		 *  <p>The <code>rowIndex</code> is the index in the data provider
		 *  of the item containing the selected cell.</p>
		 *
		 *  @param rowIndex The 0-based row index of the row.
		 * 
		 *  @return <code>true</code> if the selection contains the row.
		 *    
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function selectionContainsIndex(rowIndex:int):Boolean 
		{
			return gridSelection.containsRow(rowIndex);
		}
		
		/**
		 *  If <code>selectionMode</code> is 
		 *  <code>GridSelectionMode.MULTIPLE_ROWS</code>, returns <code>true</code> 
		 *  if the rows in <code>indices</code> are in the current selection.
		 * 
		 *  @param rowIndices Vector of 0-based row indices to include in selection. 
		 * 
		 *  @return <code>true</code> if the current selection contains these rows.
		 *    
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function selectionContainsIndices(rowIndices:Vector.<int>):Boolean 
		{
			return gridSelection.containsRows(rowIndices);
		}
		
		/**
		 *  If <code>selectionMode</code>
		 *  is <code>GridSelectionMode.SINGLE_ROW</code> or 
		 *  <code>GridSelectionMode.MULTIPLE_ROWS</code>, sets the selection and 
		 *  the caret position to this row.
		 *  For all other selection modes, this method has no effect.
		 * 
		 *  <p>The <code>rowIndex</code> is the index in the data provider
		 *  of the item containing the selected cell.</p>
		 *
		 *  @param rowIndex The 0-based row index of the cell.
		 *
		 *  @return <code>true</code> if if no errors.
		 *  <code>false</code> if <code>index</code> is invalid, or
		 *  the <code>selectionMode</code> is invalid. 
		 *    
		 *  @see spark.components.Grid#caretColumnIndex
		 *  @see spark.components.Grid#caretRowIndex
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function setSelectedIndex(rowIndex:int):Boolean
		{
			// Need to apply pending dataProvider and column changes so selection
			// isn't reset after it is set here.
			/*if (invalidatePropertiesFlag)
				UIComponentGlobals.layoutManager.validateClient(this, false);*/
			
			const selectionChanged:Boolean = gridSelection.setRow(rowIndex);
			if (selectionChanged)
			{
				caretRowIndex = rowIndex;
				caretColumnIndex = -1;
				
				invalidateDisplayListFor("selectionIndicator");
				dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
			}
			
			return selectionChanged;
		}
		
		/**
		 *  If <code>selectionMode</code>
		 *  is <code>GridSelectionMode.MULTIPLE_ROWS</code>, adds this row to
		 *  the selection and sets the caret position to this row.
		 *  For all other selection modes, this method has no effect.
		 * 
		 *  <p>The <code>rowIndex</code> is the index in the data provider 
		 *  of the item containing the selected cell.</p>
		 *
		 *  @param rowIndex The 0-based row index of the cell.
		 *
		 *  @return <code>true</code> if no errors.
		 *  <code>false</code> if <code>index</code> is invalid or
		 *  the <code>selectionMode</code> is invalid. 
		 *    
		 *  @see spark.components.Grid#caretColumnIndex
		 *  @see spark.components.Grid#caretRowIndex
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function addSelectedIndex(rowIndex:int):Boolean
		{
			// Need to apply pending dataProvider and column changes so selection
			// isn't reset after it is set here.
			/*if (invalidatePropertiesFlag)
				UIComponentGlobals.layoutManager.validateClient(this, false);*/
			
			const selectionChanged:Boolean = gridSelection.addRow(rowIndex);
			if (selectionChanged)
			{
				caretRowIndex = rowIndex;
				caretColumnIndex = -1;                
				
				invalidateDisplayListFor("selectionIndicator");
				dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
			}
			
			return selectionChanged;
		}
		
		/**
		 *  If <code>selectionMode</code>
		 *  is <code>GridSelectionMode.SINGLE_ROW</code> or 
		 *  <code>GridSelectionMode.MULTIPLE_ROWS</code>, removes this row
		 *  from the selection and sets the caret position to this row.
		 *  For all other selection modes, this method has no effect.
		 * 
		 *  <p>The <code>rowIndex</code> is the index in the data provider 
		 *  of the item containing the selected cell.</p>
		 *
		 *  @param rowIndex The 0-based row index of the cell.
		 *
		 *  @return <code>true</code> if no errors.
		 *  <code>false</code> if <code>index</code> is invalid or
		 *  the <code>selectionMode</code> is invalid. 
		 *       
		 *  @see spark.components.Grid#caretColumnIndex
		 *  @see spark.components.Grid#caretRowIndex
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function removeSelectedIndex(rowIndex:int):Boolean
		{
			// Need to apply pending dataProvider and column changes so selection
			// isn't reset after it is set here.
			/*if (invalidatePropertiesFlag)
				UIComponentGlobals.layoutManager.validateClient(this, false);*/
			
			const selectionChanged:Boolean = gridSelection.removeRow(rowIndex);
			if (selectionChanged)
			{
				caretRowIndex = rowIndex;
				caretColumnIndex = -1;
				
				invalidateDisplayListFor("selectionIndicator");
				dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
			}
			
			return selectionChanged;
		}
		
		/**
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.MULTIPLE_ROWS</code>,
		 *  sets the selection to the specfied rows and the caret position to
		 *  <code>endRowIndex</code>.
		 *  For all other selection modes, this method has no effect.
		 * 
		 *  <p>Each index represents an item in the data provider  
		 *  to include in the selection.</p>
		 *
		 *  @param rowIndex 0-based row index of the first row in the selection.
		 * 
		 *  @param rowCount Number of rows in the selection.
		 * 
		 *  @return <code>true</code> if no errors.
		 *  <code>false</code> if any of the indices are invalid, 
		 *  if <code>startRowIndex</code> is not less than or equal to 
		 *  <code>endRowIndex</code>, or the <code>selectionMode</code> is invalid. 
		 *    
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function selectIndices(rowIndex:int, rowCount:int):Boolean
		{
			// Need to apply pending dataProvider and column changes so selection
			// isn't reset after it is set here.
			/*if (invalidatePropertiesFlag)
				UIComponentGlobals.layoutManager.validateClient(this, false);*/
			
			const selectionChanged:Boolean = gridSelection.setRows(rowIndex, rowCount);
			if (selectionChanged)
			{
				caretRowIndex = rowIndex + rowCount - 1;
				caretColumnIndex = -1;
				
				invalidateDisplayListFor("selectionIndicator");
				dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
			}
			
			return selectionChanged;
		}
		
		//----------------------------------
		//  selection for cells
		//----------------------------------    
		
		/**
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.SINGLE_CELL</code>
		 *  or <code>GridSelectionMode.MULTIPLE_CELLS</code>, returns <code>true</code> 
		 *  if the cell is in the current selection.
		 * 
		 *  <p>The <code>rowIndex</code> must be between 0 and the
		 *  length of the data provider.  The <code>columnIndex</code>
		 *  must be between 0 and the length of <code>columns</code>. </p>
		 *
		 *  @param rowIndex The 0-based row index of the cell.
		 *
		 *  @param columnIndex The 0-based column index of the cell.
		 *  
		 *  @return <code>true</code> if the current selection contains the cell.
		 * 
		 *  @see spark.components.Grid#columns
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function selectionContainsCell(rowIndex:int, columnIndex:int):Boolean
		{
			return gridSelection.containsCell(rowIndex, columnIndex);
		}
		
		/**
		 *  If <code>selectionMode</code> is 
		 *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, returns <code>true</code> 
		 *  if the cells in the cell region are in the current selection.
		 * 
		 *  <p>The <code>rowIndex</code> must be between 0 and the
		 *  length of the data provider.  The <code>columnIndex</code>
		 *  must be between 0 and the length of <code>columns</code>. </p>
		 *
		 *  @param rowIndex The 0-based row index of the cell.
		 *
		 *  @param columnIndex The 0-based column index of the cell.
		 *  
		 *  @param rowCount Number of rows, starting at <code>rowIndex</code> to 
		 *  include in the cell region.
		 *
		 *  @param columnCount Number of columns, starting at 
		 *  <code>columnIndex</code> to include in the cell region.
		 * 
		 *  @return <code>true</code> if the current selection contains all 
		 *  the cells in the cell region.
		 * 
		 *  @see spark.components.Grid#columns
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function selectionContainsCellRegion(rowIndex:int, columnIndex:int, 
													rowCount:int, columnCount:int):Boolean
		{
			return gridSelection.containsCellRegion(rowIndex, columnIndex, 
				rowCount, columnCount);
		}
		
		/**
		 *  If <code>selectionMode</code>
		 *  is <code>GridSelectionMode.SINGLE_CELL</code> or 
		 *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, sets the selection
		 *  and the caret position to this cell.
		 *  For all other selection modes, this method has no effect.
		 * 
		 *  <p>The <code>rowIndex</code> is the index in the data provider 
		 *  of the item containing the selected cell.  The <code>columnIndex</code>
		 *  is the index in <code>columns</code> of the column containing the
		 *  selected cell.</p>
		 *
		 *  @param rowIndex The 0-based row index of the cell.
		 *
		 *  @param columnIndex The 0-based column index of the cell.
		 * 
		 *  @return <code>true</code> if no errors.
		 *  <code>false</code> if <code>rowIndex</code> 
		 *  or <code>columnIndex</code> is invalid or the <code>selectionMode</code> 
		 *  is invalid.     
		 *  
		 *  @see spark.components.Grid#caretColumnIndex
		 *  @see spark.components.Grid#caretRowIndex
		 *  @see spark.components.Grid#columns
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function setSelectedCell(rowIndex:int, columnIndex:int):Boolean
		{
			// Need to apply pending dataProvider and column changes so selection
			// isn't reset after it is set here.
			/*if (invalidatePropertiesFlag)
				UIComponentGlobals.layoutManager.validateClient(this, false);*/
			
			const selectionChanged:Boolean = gridSelection.setCell(rowIndex, columnIndex);
			if (selectionChanged)
			{
				caretRowIndex = rowIndex;
				caretColumnIndex = columnIndex;
				
				invalidateDisplayListFor("selectionIndicator");
				dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
			}
			
			return selectionChanged;
		}
		
		/**
		 *  If <code>selectionMode</code>
		 *  is <code>GridSelectionMode.SINGLE_CELL</code> or
		 *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, adds the cell to
		 *  the selection and sets the caret position to the cell.
		 *  For all other selection modes, this method has no effect.
		 * 
		 *  <p>The <code>rowIndex</code> is the index in the data provider 
		 *  of the item containing the selected cell.  The <code>columnIndex</code>
		 *  is the index in <code>columns</code> of the column containing the
		 *  selected cell.</p>
		 *
		 *  @param rowIndex The 0-based row index of the cell.
		 *
		 *  @param columnIndex The 0-based column index of the cell.
		 * 
		 *  @return <code>true</code> if no errors.
		 *  <code>false</code> if <code>rowIndex</code> 
		 *  or <code>columnIndex</code> is invalid, or the <code>selectionMode</code> 
		 *  is invalid.     
		 *  
		 *  @see spark.components.Grid#caretColumnIndex
		 *  @see spark.components.Grid#caretRowIndex
		 *  @see spark.components.Grid#columns
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function addSelectedCell(rowIndex:int, columnIndex:int):Boolean
		{
			// Need to apply pending dataProvider and column changes so selection
			// isn't reset after it is set here.
			/*if (invalidatePropertiesFlag)
				UIComponentGlobals.layoutManager.validateClient(this, false);*/
			
			const selectionChanged:Boolean = gridSelection.addCell(rowIndex, columnIndex);
			if (selectionChanged)
			{
				caretRowIndex = rowIndex;
				caretColumnIndex = columnIndex;
				
				invalidateDisplayListFor("selectionIndicator");
				dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
			}
			
			return selectionChanged;
		}
		
		/**
		 *  If <code>selectionMode</code>
		 *  is <code>GridSelectionMode.SINGLE_CELL</code> or
		 *  <code>GridSelectionMode.MULTIPLE_CELLS</code>, removes the cell
		 *  from the selection and sets the caret position to the cell.
		 *  For all other selection modes, this method has no effect.
		 * 
		 *  <p>The <code>rowIndex</code> is the index in the data provider 
		 *  of the item containing the selected cell.  The <code>columnIndex</code>
		 *  is the index in <code>columns</code> of the column containing the
		 *  selected cell.</p>
		 *
		 *  @param rowIndex The 0-based row index of the cell.
		 *
		 *  @param columnIndex The 0-based column index of the cell.
		 * 
		 *  @return <code>true</code> if no errors.
		 *  <code>false</code> if <code>rowIndex</code> 
		 *  or <code>columnIndex</code> is invalid or the <code>selectionMode</code> 
		 *  is invalid.     
		 *  
		 *  @see spark.components.Grid#caretColumnIndex
		 *  @see spark.components.Grid#caretRowIndex
		 *  @see spark.components.Grid#columns
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function removeSelectedCell(rowIndex:int, columnIndex:int):Boolean
		{
			// Need to apply pending dataProvider and column changes so selection
			// isn't reset after it is set here.
			/*if (invalidatePropertiesFlag)
				UIComponentGlobals.layoutManager.validateClient(this, false);*/
			
			const selectionChanged:Boolean = gridSelection.removeCell(rowIndex, columnIndex);
			if (selectionChanged)
			{
				caretRowIndex = rowIndex;
				caretColumnIndex = columnIndex;
				
				invalidateDisplayListFor("selectionIndicator");
				dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
			}
			
			return selectionChanged;
		}
		
		/** 
		 *  If <code>selectionMode</code> is <code>GridSelectionMode.MULTIPLE_CELLS</code>,
		 *  sets the selection to all the cells in the cell region and the
		 *  caret position to the last cell in the cell region.
		 *  For all other selection modes, this method has no effect.
		 * 
		 *  <p>The <code>rowIndex</code> is the index in the data provider 
		 *  of the item containing the origin of the cell region.  
		 *  The <code>columnIndex</code>
		 *  is the index in <code>columns</code> of the column containing the
		 *  origin of the cell region.</p>
		 *
		 *  <p>This method has no effect if the cell region is not wholly
		 *  contained within the grid.</p>
		 * 
		 *  @param rowIndex The 0-based row index of the origin of the cell region.
		 *
		 *  @param columnIndex The 0-based column index of the origin of the cell 
		 *  region.
		 *  
		 *  @param rowCount Number of rows, starting at <code>rowIndex</code> to 
		 *  include in the cell region.
		 *
		 *  @param columnCount Number of columns, starting at 
		 *  <code>columnIndex</code> to include in the cell region.
		 * 
		 *  @return <code>true</code> if no errors.
		 *  <code>false</code> if the cell region is invalid or 
		 *  the <code>selectionMode</code> is invalid.     
		 *  
		 *  @see spark.components.Grid#caretColumnIndex
		 *  @see spark.components.Grid#caretRowIndex
		 *  @see spark.components.Grid#columns
		 *  @see spark.components.Grid#dataProvider
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function selectCellRegion(rowIndex:int, columnIndex:int, 
										 rowCount:uint, columnCount:uint):Boolean
		{
			// Need to apply pending dataProvider and column changes so selection
			// isn't reset after it is set here.
			/*if (invalidatePropertiesFlag)
				UIComponentGlobals.layoutManager.validateClient(this, false);*/
			
			const selectionChanged:Boolean = gridSelection.setCellRegion(
				rowIndex, columnIndex, 
				rowCount, columnCount);
			if (selectionChanged)
			{
				caretRowIndex = rowIndex + rowCount - 1;
				caretColumnIndex = columnIndex + columnCount - 1;
				
				invalidateDisplayListFor("selectionIndicator");
				dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
			}
			
			return selectionChanged;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Selection API Helper Methods
		//
		//-------------------------------------------------------------------------- 
		
		/**
		 * For performance reasons, make sure validateClient, anchor and caret updates,
		 * and selectionIndicator and VALUE_COMMIT updates are only done once.
		 */
		private function doSetSelectedCells(valueCopy:Vector.<CellPosition>):void
		{
			// Need to apply pending dataProvider and column changes so selection
			// isn't reset after it is set here.
			/*if (invalidatePropertiesFlag)
				UIComponentGlobals.layoutManager.validateClient(this, false);*/
			
			gridSelection.removeAll();
			for each (var cell:CellPosition in valueCopy)
			{
				gridSelection.addCell(cell.rowIndex, cell.columnIndex);
			}
			
			doFinalizeSetSelection(cell ? cell.rowIndex : -1, 
				cell ? cell.columnIndex : -1);
		}
		
		/**
		 * For performance reasons, make sure validateClient, anchor and caret updates,
		 * and selectionIndicator and VALUE_COMMIT updates are only done once.
		 */
		private function doSetSelectedIndices(valueCopy:Vector.<int>):void
		{
			// Need to apply pending dataProvider and column changes so selection
			// isn't reset after it is set here.
			/*if (invalidatePropertiesFlag)
				UIComponentGlobals.layoutManager.validateClient(this, false);*/
			
			var newRowIndex:int = -1;
			gridSelection.removeAll();
			for each (newRowIndex in valueCopy)
			{
				gridSelection.addRow(newRowIndex);
			}
			
			doFinalizeSetSelection(newRowIndex, -1);
		}
		
		/**
		 * For performance reasons, make sure validateClient, anchor and caret updates,
		 * and selectionIndicator and VALUE_COMMIT updates are only done once.
		 */
		private function doSetSelectedItems(valueCopy:Vector.<Object>):void
		{
			if (!dataProvider)
				return;
			
			// Need to apply pending dataProvider and column changes so selection
			// isn't reset after it is set here.
			/*if (invalidatePropertiesFlag)
				UIComponentGlobals.layoutManager.validateClient(this, false);*/
			
			var newRowIndex:int = -1;        
			gridSelection.removeAll();
			for each (var item:Object in valueCopy)
			{
				newRowIndex = dataProvider.getItemIndex(item);
				gridSelection.addRow(newRowIndex);
			}
			
			doFinalizeSetSelection(newRowIndex, -1);
		}
		
		/**
		 * Finished selection operations so update the anchor, caret, selection indicators and
		 * trigger the selection bindings.
		 */
		private function doFinalizeSetSelection(rowIndex:int, columnIndex:int):void
		{
			initializeAnchorPosition();       
			caretRowIndex = rowIndex
			caretColumnIndex = columnIndex
			
			invalidateDisplayListFor("selectionIndicator");
			dispatchFlexEvent(FlexEvent.VALUE_COMMIT);      
		}
		
		//--------------------------------------------------------------------------
		//
		//  GridViewLayout Cover Methods, Properties
		//
		//-------------------------------------------------------------------------- 
		
		/** 
		 *  @private
		 *  Update the scroll position so that the virtual Grid element at the specified
		 *  index is visible.   Note that getScrollPositionDeltaToElement() is only 
		 *  approximate when variableRowHeight=true, so calling this method once will
		 *  not necessarily scroll far enough to expose the specified element.
		 * 
		 *  @returns True if either the horizontalScrollPosition or verticalScrollPosition changed.
		 */
		
		private function scrollToIndex(view:GridView, elementIndex:int, scrollHorizontally:Boolean, scrollVertically:Boolean):Boolean
		{
		/*	var spDelta:Point = view.gridViewLayout.getScrollPositionDeltaToElement(elementIndex);
			
			// The cell is completely visible or the specified index is no longer valid so punt.
			
			if (!spDelta)
				return false; 
			
			// If the required scroll is locked then punt
			
			if ((spDelta.y != 0) && view.gridViewLayout.verticalScrollingLocked)
				return false;
			
			if ((spDelta.x != 0) && view.gridViewLayout.horizontalScrollingLocked)
				return false;
			
			// Update the scroll positions
			
			var scrollChanged:Boolean = false;
			
			if (scrollHorizontally)
			{
				horizontalScrollPosition += spDelta.x;
				scrollChanged = spDelta.x != 0;
			}
			
			if (scrollVertically)
			{
				verticalScrollPosition += spDelta.y;
				scrollChanged = scrollChanged || spDelta.y != 0;
			}
			
			return scrollChanged;*/ return false;
		}
		
		
		/**
		 *  If necessary, set the <code>verticalScrollPosition</code> and 
		 *  <code>horizontalScrollPosition</code> properties so that the 
		 *  specified cell is completely visible. 
		 *  If <code>rowIndex</code> is -1 and <code>columnIndex</code> is specified, 
		 *  then just adjust the <code>horizontalScrollPosition</code>
		 *  so that the specified column is visible. 
		 *  If <code>columnIndex</code> is -1 and <code>rowIndex</code>
		 *  is specified, then just adjust the <code>verticalScrollPosition</code> 
		 *  so that the specified row is visible.
		 * 
		 *  @param rowIndex The 0-based row index of the item renderer's cell, or -1 to specify a column.
		 *  
		 *  @param columnIndex The 0-based column index of the item renderer's cell, or -1 to specify a row.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function ensureCellIsVisible(rowIndex:int = -1, columnIndex:int = -1):void
		{
			
			const columns:IList = this.columns;
			
			// Check that each index is within range.
			if (!columns || columnIndex < -1 || columnIndex >= columns.length || 
				!dataProvider || rowIndex < -1 || rowIndex >= dataProvider.length || 
				(columnIndex == -1 && rowIndex == -1))
				return;
			
			// Check to see if any columns are visible or specified column is visible.
			
			if ((columnIndex == -1 && getNextVisibleColumnIndex(-1) == -1) || 
				(columnIndex != -1 && !(GridColumn(columns.getItemAt(columnIndex)).visible)))
				return;
			
			const scrollHorizontally:Boolean = columnIndex != -1;
			const scrollVertically:Boolean = rowIndex != -1;
			
			// If the row, column, or cell is locked, then there's nothing to do.
			
			if ((columnIndex < lockedColumnCount) && (rowIndex < lockedRowCount))
				return;
			
			if (!scrollVertically && (columnIndex < lockedColumnCount)) 
				return;
			
			if (!scrollHorizontally && (rowIndex < lockedRowCount))
				return;        
			
			// If called after the layout cache is cleared, need to rebuild the cache
			// before accessing visible rows/columns and attempting to scroll.
			//if (getVisibleRowIndices().length == 0 || getVisibleColumnIndices().length == 0)
			//	validateNow();
			
			// When not scrolling horizontally, columnIndex can just be 0.
			if (!scrollHorizontally)
				columnIndex = 0;
			
			// Find the GridView the specified cell is contained by and punt if it's not visible
			
			const cellGridView:GridView = getGridViewAt(rowIndex, columnIndex);	
			if (!cellGridView || 
				(cellGridView.getLayoutBoundsX() >= getLayoutBoundsWidth()) || 
				(cellGridView.getLayoutBoundsY() >= getLayoutBoundsHeight()))
				return;
			
			// If the row index isn't specified, use the first one that's visible.
			if (!scrollVertically)
			{
				// const visibleRowIndices:Vector.<int> = cellGridView.gridViewLayout.getVisibleRowIndices();
				// rowIndex = (visibleRowIndices.length > 0) ?  visibleRowIndices[0] : 0;
			}
			
			// A cell's index as defined by LayoutBase it's just its position
			// in the row-major linear ordering of the grid's cells.
			/*
			const gridViewLayout:GridViewLayout = cellGridView.gridViewLayout;
			const cellViewRowIndex:int = rowIndex - gridViewLayout.viewRowIndex;
			const cellViewColumnIndex:int  = columnIndex - gridViewLayout.viewColumnIndex;
			const cellElementIndex:int = (cellViewRowIndex * gridViewLayout.columnsView.length) + cellViewColumnIndex;
			
			var scrollChanged:Boolean = false;
			var firstScroll:Boolean = true;
			
			// Iterate until we've scrolled elementIndex at least partially into view.
			do
			{
				scrollChanged = scrollToIndex(cellGridView, cellElementIndex, scrollHorizontally, scrollVertically);
				
				// Fixed row heights, and we're only scrolling vertically.
				if (!variableRowHeight && !scrollHorizontally)
					return;
				
				// Bail. This could indicate there is a bug but it avoids an infinite loop.
				// scrollToIndex() then validateNow() then scrollToIndex() again and
				// no changes in scroll position.
				if (!firstScroll && !scrollChanged)
					return;
				
				validateNow();
				
				firstScroll = false;
			}
			while (!isCellVisible(scrollVertically ? rowIndex : -1, scrollHorizontally ? columnIndex : -1));
			
			// At this point we've only ensured that the requested cell is at least 
			// partially visible.  Ensure that it's completely visible.
			
			scrollToIndex(cellGridView, cellElementIndex, scrollHorizontally, scrollVertically);
			*/
		}        
		
		/**
		 *  Return the data provider indices and padding indices of the 
		 *  currently visible rows.  
		 *  Indices which are greater than or equal to the 
		 *  <code>dataProvider</code> length represent padding rows.
		 *  Note that the item renderers for the first and last rows 
		 *  may only be partially visible. 
		 *  The returned vector's contents are in the order they're displayed.
		 * 
		 *  @return A vector of the visible row indices.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */ 
		/*
		public function getVisibleRowIndices():Vector.<int>
		{
			const gridLayout:GridLayout = layout as GridLayout;
			const topGridView:GridView = gridLayout.topGridView;        
			const centerGridView:GridView = gridLayout.centerGridView;
			
			if (!centerGridView)
				return new Vector.<int>(0);
			
			// const centerRowIndices:Vector.<int> = centerGridView.gridViewLayout.getVisibleRowIndices();
			// if (!topGridView)
			//	return centerRowIndices;
			
			const topRowIndices:Vector.<int> = topGridView.gridViewLayout.getVisibleRowIndices();
			return topRowIndices.concat(centerRowIndices);
		}
		*/
		/**
		 *  Return the indices of the currently visible columns.  Note that the 
		 *  item renderers for the first and last columns may only be partially visible.  
		 *  The returned vector's contents are in the order they're displayed.
		 * 
		 *  <p>The following example function uses this method to compute a vector of 
		 *  visible GridColumn objects.</p>
		 *  <pre>
		 *  function getVisibleColumns():Vector.&lt;GridColumn&gt;
		 *  {
		 *      var visibleColumns = new Vector.&lt;GridColumn&gt;;
		 *      for each (var columnIndex:int in grid.getVisibleColumnIndices())
		 *          visibleColumns.push(grid.columns.getItemAt(columnIndex));
		 *      return visibleColumns;
		 *  }
		 *  </pre> 
		 * 
		 *  @return A vector of the visible column indices.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */ 
		/*		
		public function getVisibleColumnIndices():Vector.<int>
		{
			const gridLayout:GridLayout = layout as GridLayout;
			const leftGridView:GridView = gridLayout.leftGridView;        
			const centerGridView:GridView = gridLayout.centerGridView;
			
			//const centerColumnIndices:Vector.<int> = centerGridView.gridViewLayout.getVisibleColumnIndices();
			//if (!leftGridView)
			//	return centerColumnIndices;
			
			const leftColumnIndices:Vector.<int> = leftGridView.gridViewLayout.getVisibleColumnIndices();
			return leftColumnIndices.concat(centerColumnIndices);
		}
		*/
		/**
		 *  Returns the current pixel bounds of the specified cell, or null if no such cell exists.
		 *  Cell bounds are reported in grid coordinates.
		 * 
		 *  <p>If all of the columns for the the specfied row and all of the rows preceeding 
		 *  it have not yet been scrolled into view, the returned bounds may only be an approximation, 
		 *  based on all of the columns' <code>typicalItem</code>s.</p>
		 * 
		 *  @param rowIndex The 0-based index of the row.
		 *
		 *  @param columnIndex The 0-based index of the column. 
		 *
		 *  @return A <code>Rectangle</code> that represents the cell's pixel bounds, or null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */ 
		public function getCellBounds(rowIndex:int, columnIndex:int):Rectangle
		{
			return gridDimensions.getCellBounds(rowIndex, columnIndex);
		}
		
		/**
		 *  Returns the current pixel bounds of the specified row, or null if no such row exists.
		 *  Row bounds are reported in grid coordinates.
		 *
		 *  <p>If all of the columns for the the specfied row and all of the rows preceeding 
		 *  it have not yet been scrolled into view, the returned bounds may only be an approximation, 
		 *  based on all of the columns' <code>typicalItem</code>s.</p>
		 * 
		 *  @param rowIndex The 0-based index of the row.
		 * 
		 *  @return A <code>Rectangle</code> that represents the row's pixel bounds, or null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function getRowBounds(rowIndex:int):Rectangle
		{
			return gridDimensions.getRowBounds(rowIndex);      
		}
		
		/**
		 *  Returns the current pixel bounds of the specified column, or null if no such column exists.
		 *  Column bounds are reported in grid coordinates.
		 * 
		 *  <p>If all of the cells in the specified column have not yet been scrolled into view, the 
		 *  returned bounds may only be an approximation, based on the column's <code>typicalItem</code>.</p>
		 *  
		 *  @param columnIndex The 0-based index of the column. 
		 *
		 *  @return A <code>Rectangle</code> that represents the column's pixel bounds, or null.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function getColumnBounds(columnIndex:int):Rectangle
		{
			return gridDimensions.getColumnBounds(columnIndex);
		}
		
		/**
		 *  Returns the row index corresponding to the specified grid coordinates,
		 *  or -1 if the coordinates are out of bounds. 
		 * 
		 *  <p>If all of the columns or rows for the grid have not yet been scrolled
		 *  into view, the returned index may only be an approximation, 
		 *  based on all of the columns' <code>typicalItem</code>s.</p>
		 *  
		 *  @param x The x coordinate.
		 * 
		 *  @param y The y coordinate.
		 *
		 *  @return The index of the row corresponding to the specified coordinates.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function getRowIndexAt(x:Number, y:Number):int
		{
			return gridDimensions.getRowIndexAt(x, y);
		}
		
		/**
		 *  Returns the column index corresponding to the specified grid coordinates,
		 *  or -1 if the coordinates are out of bounds. 
		 * 
		 *  <p>If all of the columns or rows for the grid have not yet been scrolled
		 *  into view, the returned index may only be an approximation, 
		 *  based on all of the columns' <code>typicalItem</code>s.</p>
		 *  
		 *  @param x The pixel's x coordinate relative to the grid.
		 *
		 *  @param y The pixel's y coordinate relative to the grid.
		 *
		 *  @return The index of the column, or -1 if the coordinates are out of bounds. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function getColumnIndexAt(x:Number, y:Number):int
		{
			return gridDimensions.getColumnIndexAt(x, y); 
		}
		
		/**
		 *  Return the width of the specified column.  If the cell's entire bounds
		 *  aren't needed, this method is more efficient than <code>getColumnBounds().width</code>.
		 * 
		 *  <p>If the specified column's width property isn't defined, then the returned value 
		 *  may only be an approximation.  The actual column width is only computed after the column
		 *  has been scrolled into view.</p>
		 * 
		 *  @param columnIndex The 0-based index of the column. 
		 *  @return The width of the specified column.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		
		public function getColumnWidth(columnIndex:int):Number
		{
			const column:GridColumn = getGridColumn(columnIndex);
			return (column && !isNaN(column.width)) ? column.width : gridDimensions.getColumnWidth(columnIndex);
		}
		
		/**
		 *  Return the row and column indices of the cell that overlaps the pixel at the 
		 *  specified grid coordinate.
		 *  If no such cell exists, null is returned.
		 * 
		 *  <p>The example function below uses this method to compute the value of the 
		 *  <code>dataField</code> for a grid cell.</p> 
		 *  <pre>
		 *  function getCellData(x:Number, y:Number):Object
		 *  {
		 *      var cell:CellPosition = getCellAt(x, y);
		 *      if (!cell)
		 *          return null;
		 *      var GridColumn:column = grid.columns.getItemAt(cell.columnIndex);
		 *      return grid.dataProvider.getItemAt(cell.rowIndex)[column.dataField];
		 *  }
		 *  </pre> 
		 * 
		 *  @param x The pixel's x coordinate relative to the grid.
		 *
		 *  @param y The pixel's y coordinate relative to the grid.
		 *
		 *  @return The cell position, or null. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function getCellAt(x:Number, y:Number):CellPosition
		{
			const rowIndex:int = gridDimensions.getRowIndexAt(x, y);
			const columnIndex:int = gridDimensions.getColumnIndexAt(x, y);
			if ((rowIndex == -1) || (columnIndex == -1))
				return null;
			return new CellPosition(rowIndex, columnIndex);
		}
		
		/**
		 *  Returns a vector of CellPosition objects whose 
		 *  <code>rowIndex</code> and <code>columnIndex</code> properties specify the 
		 *  row and column indices of the cells that overlap the specified grid region.  
		 *  If no such cells exist, an empty vector is returned.
		 *  
		 *  @param x The x coordinate of the pixel at the origin of the region, relative to the grid.
		 * 
		 *  @param x The x coordinate of the pixel at the origin of the region, relative to the grid. 
		 * 
		 *  @param w The width of the region, in pixels. 
		 * 
		 *  @param h The height of the region, in pixels. 
		 *  
		 *  @return A vector of objects like <code>Vector.&lt;Object&gt;([{rowIndex:0, columnIndex:0}, ...])</code>. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function getCellsAt(x:Number, y:Number, w:Number, h:Number):Vector.<CellPosition>
		{ 
			var cells:Vector.<CellPosition> = new Vector.<CellPosition>;
			
			if (w <= 0 || h <= 0)
				return cells;
			
			// Get the row/column indexes of the corners of the region.
			var topLeft:CellPosition = getCellAt(x, y);
			var bottomRight:CellPosition = getCellAt(x + w, y + h);
			if (!topLeft || !bottomRight)
				return cells;
			
			for (var rowIndex:int = topLeft.rowIndex; 
				rowIndex <= bottomRight.rowIndex; rowIndex++)
			{
				for (var columnIndex:int = topLeft.columnIndex; 
					columnIndex <= bottomRight.columnIndex; columnIndex++)
				{
					cells.push(new CellPosition(rowIndex, columnIndex));
				}
			}
			
			return cells;
		}
		
		/**
		 *  Return the X coordinate of the specified cell's origin.  If the cell's entire bounds
		 *  aren't needed, this method is more efficient than <code>getCellBounds().x</code>.
		 * 
		 *  <p>If all of the columns for the the specfied row and all of the rows preceeding 
		 *  it have not yet been scrolled into view, the returned value may only be an approximation, 
		 *  based on all of the columns' <code>typicalItem</code>s.</p>
		 * 
		 *  @param rowIndex The 0-based index of the row.
		 *  @param columnIndex The 0-based index of the column. 
		 *  @return The x coordindate of the specified cell's origin.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function getCellX(rowIndex:int, columnIndex:int):Number
		{ 
			return gridDimensions.getCellX(rowIndex, columnIndex);
		}
		
		/**
		 *  Return the Y coordinate of the specified cell's origin.  If the cell's entire bounds
		 *  aren't needed, this method is more efficient than <code>getCellBounds().y</code>.
		 * 
		 *  <p>If all of the columns for the the specfied row and all of the rows preceeding 
		 *  it have not yet been scrolled into view, the returned value may only be an approximation, 
		 *  based on all of the columns' <code>typicalItem</code>s.</p>
		 * 
		 *  @param rowIndex The 0-based index of the row.
		 *  @param columnIndex The 0-based index of the column. 
		 *  @return The y coordindate of the specified cell's origin.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		public function getCellY(rowIndex:int, columnIndex:int):Number
		{ 
			return gridDimensions.getCellY(rowIndex, columnIndex);
		}      
		
		/**
		 *  If the requested item renderer is visible, returns a reference to 
		 *  the item renderer currently displayed at the specified cell.  
		 *  Note that once the returned item renderer is no longer visible it may be 
		 *  recycled and its properties reset.  
		 * 
		 *  <p>If the requested item renderer is not visible. then 
		 *  each time this method is called, a new item renderer is created.  
		 *  The new item renderer is not visible</p>
		 * 
		 *  <p>If the specified column does not have an explicit width, then the width
		 *  of this cell is based on the <code>typicalItem</code>.  
		 *  If a <code>typicalItem</code> was not specified or has not been measured yet, 
		 *  then the item renderer's width defaults to <code>150</code>.</p>
		 * 
		 *  <p>If the grid property <code>variableRowHeight</code> is 
		 *  <code>true</code> (the default) and an overall row height hasn't been 
		 *  cached for the specified row, then the item renderer's height is based 
		 *  on the <code>typicalItem</code>.  
		 *  If the <code>typicalItem</code> was not 
		 *  specified or has not been measured yet, then the item renderer's height 
		 *  defaults to its preferred height.</p>
		 *  
		 *  @param rowIndex The 0-based row index of the item renderer's cell.
		 * 
		 *  @param columnIndex The 0-based column index of the item renderer's cell.
		 * 
		 *  @return The item renderer or null if the cell location is invalid.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		/*
		public function getItemRendererAt(rowIndex:int, columnIndex:int):IGridItemRenderer
		{
			const view:GridView = getGridViewAt(rowIndex, columnIndex);
			if (!view)
				return null;
			
			return view.gridViewLayout.getItemRendererAt(rowIndex, columnIndex);
		}    
		*/
		/**
		 *  Returns <code>true</code> if the specified cell is at least partially visible. 
		 *  If <code>columnIndex == -1</code>, then return 
		 *  <code>true</code> if the specified row is at least partially visible. 
		 *  If <code>rowIndex == -1</code>, then return <code>true</code> 
		 *  if the specified column is at least partially visible. 
		 *  If both <code>columnIndex</code> and <code>rowIndex</code> are -1, 
		 *  then return <code>false</code>.
		 *  
		 *  @param rowIndex The 0-based row index of the item renderer's cell.
		 * 
		 *  @param columnIndex The 0-based column index of the item renderer's cell.
		 * 
		 *  @return True if the specified cell (or row if columnIndex == -1) is at least partially visible
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */        
		public function isCellVisible(rowIndex:int = -1, columnIndex:int = -1):Boolean
		{
			const view:GridView = getGridViewAt(rowIndex, columnIndex);
			return view ;//&& view.gridViewLayout.isCellVisible(rowIndex, columnIndex);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Tracking Grid invalidateDisplayList() "reasons", invalid cells
		//
		//-------------------------------------------------------------------------- 
		
		/**
		 *  @private
		 *  Low cost "list" of invalidateDisplayList() reasons.
		 */
		private var invalidateDisplayListReasonsMask:uint = 0;
		
		/**
		 *  @private
		 *  This flag makes it possible to defer clearing the invalidateDisplayListReasonsMask
		 *  until after the Grid's subtree has been redisplayed.   It's set by updateDisplayList()
		 *  and not cleared until the next invalidateDisplayListFor() call, on the assumption
		 *  that the Grid subtree's updateDisplayList() methods will not reset any Grid properties
		 *  (that call invalidateDisplayListFor()).
		 */
		private var clearInvalidateDisplayListReasons:Boolean = false;
		
		/**
		 *  @private
		 *  Table that maps from reason names to bit fields.
		 */
		private static const invalidateDisplayListReasonBits:Object = {
			verticalScrollPosition: uint(1 << 0),
			horizontalScrollPosition: uint(1 << 1),
			bothScrollPositions: (uint(1 << 0) | uint(1 << 1)),
			hoverIndicator: uint(1 << 2),
			caretIndicator: uint(1 << 3),
			selectionIndicator: uint(1 << 4),
			editorIndicator: uint(1 << 5),
			none: uint(~0)
		};
		
		/**
		 *  @private
		 *  Set the bit that corresponds to reason.  Only used by invalidateDisplayListFor().
		 */
		private function setInvalidateDisplayListReason(reason:String):void
		{
			if (clearInvalidateDisplayListReasons)
			{
				invalidateDisplayListReasonsMask = 0;
				clearInvalidateDisplayListReasons = false;
			}
			
			invalidateDisplayListReasonsMask |= invalidateDisplayListReasonBits[reason];
		}
		
		/**
		 *  @private
		 *  Return true if invalidateDisplayListFor() was called with the specified reason
		 *  since the last updateDisplayList() pass.
		 */
		mx_internal function isInvalidateDisplayListReason(reason:String):Boolean
		{
			const bit:uint = invalidateDisplayListReasonBits[reason];
			return (invalidateDisplayListReasonsMask & bit) == bit;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Method Overrides
		//
		//--------------------------------------------------------------------------  
		
		/**
		 *  @private
		 */
		/*override*/ 
		public function getHorizontalScrollPositionDelta(navigationUnit:uint):Number
		{
			const gridLayout:GridLayout = layout as GridLayout;
			const centerGridView:GridView = gridLayout.centerGridView;			
			return (centerGridView) ? 0 /*centerGridView.getHorizontalScrollPositionDelta(navigationUnit)*/ : 0;     
		}
		
		/**
		 *  @private
		 */
		/*override*/ 
		public function getVerticalScrollPositionDelta(navigationUnit:uint):Number
		{
			const gridLayout:GridLayout = layout as GridLayout;
			const centerGridView:GridView = gridLayout.centerGridView;			
			return (centerGridView) ? 0 /*centerGridView.getVerticalScrollPositionDelta(navigationUnit)*/ : 0;     
		}
		
		
		/**
		 *  @private
		 *  During virtual layout updateDisplayList() eagerly validates lazily
		 *  created (or recycled) IRs.   We don't want changes to those IRs to
		 *  invalidate the size of the grid.
		 * 
		 *  This method also dispatches an invalidateSize event that's used 
		 *  by the DataGrid to invalidate IDataGridElements.
		 */
		override public function invalidateSize():void
		{
			if (!inUpdateDisplayList)
			{
				super.invalidateSize();
				
				for each (var view:GridView in allGridViews)
				{
					if (!view)
						continue;
					view.invalidateSize();    
				}
				
				dispatchChangeEvent("invalidateSize");            
			}
		}
		
		/**
		 *  @private
		 *  During virtual layout updateDisplayList() eagerly validates lazily
		 *  created (or recycled) IRs.  Calls to invalidateDisplayList() eventually
		 *  short-circuit but doing so early saves a few percent.
		 * 
		 *  This method also dispatches an invalidateDisplayList event that's used 
		 *  by the DataGrid to invalidate IDataGridElements.
		 */
		override public function invalidateDisplayList():void
		{
			if (!inUpdateDisplayList)
			{
				setInvalidateDisplayListReason("none");            
				super.invalidateDisplayList();
				
				for each (var view:GridView in allGridViews)
				{
					if (!view)
						continue;
					view.invalidateDisplayList();    
				}
				
				dispatchChangeEvent("invalidateDisplayList");
			}
		}
		
		private function get allGridViews():Array
		{
			const gridLayout:GridLayout = layout as GridLayout;
			return gridLayout ? [gridLayout.topLeftGridView, gridLayout.topGridView, gridLayout.leftGridView, gridLayout.centerGridView] : [];
		}
		
		private function createGridView():GridView
		{
			const elt:GridView = gridView.newInstance() as GridView;
			addElement(elt);
			return elt;
		}
		
		private function configureGridView(gv:GridView, viewRowIndex:int, viewColumnIndex:int, viewRowCount:int, viewColumnCount:int):void
		{
			/*
			const gridViewLayout:GridViewLayout = gv.gridViewLayout;
			gridViewLayout.grid = this;
			gridViewLayout.viewRowIndex = viewRowIndex;
			gridViewLayout.viewColumnIndex = viewColumnIndex;
			gridViewLayout.viewRowCount = viewRowCount;
			gridViewLayout.viewColumnCount = viewColumnCount;
			*/
		}
		
		/**
		 *  Create and/or configure this Grid's GridViews.  We're assuming that the
		 *  Grid's viewFactory, columns and dataProvider are specified.
		 * 
		 *  If GridViews are added or removed, a "gridViewsChanged" event is dispatched.
		 */
		private function configureGridViews():void
		{
			const columnCount:int = columns.length;
			const rowCount:int = (dataProvider) ? dataProvider.length : 0;
			
			lockedColumnCount = Math.min(lockedColumnCount, columnCount);
			lockedRowCount = Math.min(lockedRowCount, rowCount);
			
			const centerRowCount:int = Math.max(0, rowCount - lockedRowCount);
			const centerColumnCount:int = Math.max(0, columnCount - lockedColumnCount); 
			
			const gridLayout:GridLayout = layout as GridLayout;
			var topLeftGridView:GridView = gridLayout.topLeftGridView;    
			var topGridView:GridView = gridLayout.topGridView;        
			var leftGridView:GridView = gridLayout.leftGridView;
			var centerGridView:GridView = gridLayout.centerGridView;
			var lockedRowsSeparatorElement:IVisualElement = gridLayout.lockedRowsSeparatorElement;
			var lockedColumnsSeparatorElement:IVisualElement = gridLayout.lockedColumnsSeparatorElement;
			
			var gridViewsChanged:Boolean = false;
			
			// Unconditionally create and configure the "center" GridView
			
			if (centerGridView == null)
			{
				gridLayout.centerGridView = centerGridView = createGridView();
				gridViewsChanged = true;
			}
			
			configureGridView(centerGridView, lockedRowCount, lockedColumnCount, -1, -1);
			
			// centerGridView.gridViewLayout.requestedRowCount = requestedRowCount - lockedRowCount;
			// centerGridView.gridViewLayout.requestedColumnCount = requestedColumnCount - lockedColumnCount; 
			
			// Remove or create/configure the topLeftGridView
			
			if ((lockedRowCount > 0) && (lockedColumnCount > 0))
			{
				if (!topLeftGridView)
				{
					gridLayout.topLeftGridView = topLeftGridView = createGridView();
					// topLeftGridView.gridViewLayout.verticalScrollingLocked = true;
					// topLeftGridView.gridViewLayout.horizontalScrollingLocked = true;
					gridViewsChanged = true;
				}
				
			}
			else if (topLeftGridView)
			{
				removeElement(topLeftGridView);
				gridLayout.topLeftGridView = topLeftGridView = null;
				gridViewsChanged = true;
			}
			
			if (topLeftGridView)
				configureGridView(topLeftGridView, 0, 0, lockedRowCount, lockedColumnCount);
			
			// Remove or create/configure the topGridView
			
			if (lockedRowCount > 0)
			{
				if (!topGridView)
				{
					gridLayout.topGridView = topGridView = createGridView();
					// topGridView.gridViewLayout.verticalScrollingLocked = true;
					gridViewsChanged = true;
				}
				
				if (lockedRowsSeparator && !lockedRowsSeparatorElement)
				{
					gridLayout.lockedRowsSeparatorElement = lockedRowsSeparatorElement /*= lockedRowsSeparator.newInstance() as IVisualElement*/;
					// addElement(lockedRowsSeparatorElement);
				}
			}
			else
			{
				if (topGridView)
				{
					removeElement(topGridView);
					gridLayout.topGridView = topGridView = null;
					gridViewsChanged = true;
				}
				
				if (lockedRowsSeparatorElement)
				{
					// removeElement(lockedRowsSeparatorElement);
					gridLayout.lockedRowsSeparatorElement = lockedRowsSeparatorElement = null;
				}
			}
			
			if (topGridView)
				configureGridView(topGridView, 0, lockedColumnCount, lockedRowCount, centerColumnCount);
			
			// Remove or create/configure the leftGridView
			
			if (lockedColumnCount > 0)
			{
				if (!leftGridView)
				{
					gridLayout.leftGridView = leftGridView = createGridView();
					// leftGridView.gridViewLayout.horizontalScrollingLocked = true;
					gridViewsChanged = true;
				}
				
				if (lockedColumnsSeparator && !lockedColumnsSeparatorElement)
				{
					gridLayout.lockedColumnsSeparatorElement = lockedColumnsSeparatorElement/* = lockedColumnsSeparator.newInstance() as IVisualElement*/;
					// addElement(lockedColumnsSeparatorElement);
				}
			}
			else
			{
				if (leftGridView)
				{
					removeElement(leftGridView);
					gridLayout.leftGridView = leftGridView = null;
					gridViewsChanged = true;
				}
				
				if (lockedColumnsSeparatorElement)
				{
					// removeElement(lockedColumnsSeparatorElement);
					gridLayout.lockedColumnsSeparatorElement = lockedColumnsSeparatorElement = null;
				}
			}
			
			if (leftGridView)
				configureGridView(leftGridView, lockedRowCount, 0, centerRowCount, lockedColumnCount);
			
			if (gridViewsChanged)
				dispatchChangeEvent("gridViewsChanged");
		}
		
		/**
		 *  @private
		 */
		override protected function commitProperties():void
		{
			// rowHeight and variableRowHeight can be set in either order
			if (variableRowHeightChanged || rowHeightChanged)
			{
				if (rowHeightChanged)
					gridDimensions.defaultRowHeight = _rowHeight;
				gridDimensions.variableRowHeight = variableRowHeight;
				
				if ((!variableRowHeight && rowHeightChanged) || variableRowHeightChanged)
				{
					clearGridLayoutCache(false);
					invalidateSize();
					invalidateDisplayList();
				}
				
				rowHeightChanged = false;
				variableRowHeightChanged = false;
			}
			
			// item renderer changed or typical item changed
			if (itemRendererChanged || typicalItemChanged)
			{
				clearGridLayoutCache(true);
				itemRendererChanged = false;
			}
			
			// Try to generate columns if there aren't any or there are generated
			// ones which need to be regenerated because the typicalItem or 
			// dataProvider changed.
			if (!columns || (generatedColumns && 
				(typicalItemChanged || (!typicalItem && dataProviderChanged))))
			{
				const oldColumns:IList = columns;
				columns = generateColumns();
				generatedColumns = (columns != null);
				columnsChanged = columns != oldColumns;
			}
			typicalItemChanged = false;
			
			// If the dataProvider or columns change, reset the selection and 
			// the grid dimensions.  This has to be done here rather than in the 
			// setters because the gridSelection and gridDimensions might not 
			// be set yet, depending on the order they are initialized when the 
			// grid skin part is added to the data grid.
			
			if (dataProviderChanged || columnsChanged)
			{
				
				// Remove the current selection and, if requireSelection, make
				// sure the selection is reset to row 0 or cell 0,0.
				if (gridSelection)
				{
					var savedRequireSelection:Boolean = gridSelection.requireSelection;
					gridSelection.requireSelection = false;
					gridSelection.removeAll();
					gridSelection.requireSelection = savedRequireSelection;
				} 
				
				// make sure we have the right number of columns.
				if (columnsChanged)
					gridDimensions.columnCount = _columns ? _columns.length : 0;
				
				// Keep typical item size cache only when the typical item is still valid
				// and the columns haven't changed.
				if (typicalItem != null && !columnsChanged)
					clearGridLayoutCache(false);
				else
					clearGridLayoutCache(true);
				
				if (!caretChanged)
					initializeCaretPosition();
				
				if (!anchorChanged)
					initializeAnchorPosition();
				
				dataProviderChanged = false;
				columnsChanged = false;
			}
			
			anchorChanged = false;
			
			// Create or reconfigure the Grid's GridViews
			
			if (gridView && columns)
				configureGridViews();
			
			// Deferred selection operations
			
			if (dataProvider)
			{
				for each (var deferredOperation:Function in deferredOperations)
				deferredOperation();
				deferredOperations.length = 0;                
			}
			
			// Only want one event if both caretRowIndex and caretColumnIndex changed
			
			if (caretChanged)
			{
				// Validate values now.  Need to let caret be set in the same
				// update as the dp and/or columns.  -1 is a valid value.            
				if (_dataProvider && caretRowIndex >= _dataProvider.length)
					_caretRowIndex = _dataProvider.length - 1;
				if (_columns && caretColumnIndex >= _columns.length)
					_caretColumnIndex = getPreviousVisibleColumnIndex(_columns.length - 1);
				
				caretSelectedItem = 
					_dataProvider && _caretRowIndex >= 0 ?
					_dataProvider.getItemAt(_caretRowIndex) : null;
				
				dispatchCaretChangeEvent();
				
				// Last reported values.
				_oldCaretRowIndex = _caretRowIndex;
				_oldCaretColumnIndex = _caretColumnIndex;
				
				caretChanged = false;        
			}
			
			if (updateCaretForDataProviderChanged)
			{
				updateCaretForDataProviderChanged = false;
				updateCaretForDataProviderChange(updateCaretForDataProviderChangeLastEvent);
				updateCaretForDataProviderChangeLastEvent = null;
			}
		}
		
		
		/**
		 *  @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			inUpdateDisplayList = true;
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			inUpdateDisplayList = false;
			
			clearInvalidateDisplayListReasons = true;
			
			if (!variableRowHeight)
				setFixedRowHeight(gridDimensions.getRowHeight(0));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------      
		
		/**
		 *  @private
		 *  This version of invlaidateDisplayList() stores the "reason" for the invalidate
		 *  request so that GridLayout/updateDisplayList() can do its job more efficiently.
		 *  GridLayout tests the accumulated invalidateDisplayList reasons with 
		 *  isInvalidateDisplayListReason() and they're automatically cleared by 
		 *  updateDisplayList() here.
		 * 
		 *  Note that if invalidateDisplayList() is called directly, all possible 
		 *  invalidateDispayList reasons are implicitly specified, in other words if
		 *  no reason is specified then they all are (see invalidateDisplayListReasonBits.none).
		 *  That way, callers need not be aware of this internal API.
		 * 
		 *  Also: most reason="selectionIndicator" calls also change the caret index which
		 *  in turn adds reason="caretIndicator" to the invalidateDisplayList reasons, if the
		 *  caret index actually changed.
		 */
		mx_internal function invalidateDisplayListFor(reason:String):void
		{
			if (!inUpdateDisplayList)
			{
				setInvalidateDisplayListReason(reason);          
				super.invalidateDisplayList();
				
				// Minor optimization: if the reason for this invalidation is a 
				// scroll, don't invalidate GridViews that can't change. 
				
				const vspReason:Boolean = reason == "verticalScrollPosition";
				const hspReason:Boolean = reason == "horizontalScrollPosition";
				const bothReason:Boolean = reason == "bothScrollPositions";
				
				const gridLayout:GridLayout = layout as GridLayout;
				const topLeftGridView:GridView = gridLayout.topLeftGridView;    
				const topGridView:GridView = gridLayout.topGridView;        
				const leftGridView:GridView = gridLayout.leftGridView;
				const centerGridView:GridView = gridLayout.centerGridView;			
				
				if (topLeftGridView && !vspReason && !hspReason && !bothReason)
					topLeftGridView.invalidateDisplayList();
				
				if (topGridView && !vspReason)
					topGridView.invalidateDisplayList();
				
				if (leftGridView && !hspReason)
					leftGridView.invalidateDisplayList();			
				
				if (centerGridView)  
					centerGridView.invalidateDisplayList();
				
				dispatchChangeEvent("invalidateDisplayList");
			}
		}
		
		/**
		 *  If the specified cell is visible, it is redisplayed.  
		 *  If <code>variableRowHeight=true</code>, 
		 *  then doing so may cause the height of the corresponding row to change.
		 * 
		 *  <p>If columnIndex is -1, then the entire row is invalidated.  
		 *  Similarly if <code>rowIndex is -1</code>, then the entire column is invalidated.</p>
		 * 
		 *  <p>This method should be called when there is a change to any aspect of 
		 *  the data provider item at <code>rowIndex</code> that might have some 
		 *  impact on the way the  specified cell is displayed. 
		 *  Calling this method is similar to calling the
		 *  <code>dataProvider.itemUpdated()</code> method, which advises the Grid that all rows
		 *  displaying the specified item should be redisplayed.  
		 *  Using this method can be relatively efficient, since it narrows 
		 *  the scope of the change to a single cell.</p>
		 * 
		 *  @param rowIndex The 0-based row index of the cell that changed, or -1.
		 *
		 *  @param columnIndex The 0-based column index of the cell that changed or -1.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */
		/*public function invalidateCell(rowIndex:int, columnIndex:int):void
		{
			if ((rowIndex == -1) && (columnIndex == -1))
			{
				invalidateDisplayList();
				return;
			}
			
			const view:GridView = getGridViewAt(rowIndex, columnIndex);
			if (!dataProvider || !view)
				return;
			
			
			const gridLayout:GridViewLayout = view.gridViewLayout;
			const dataProviderLength:int = dataProvider.length;
			if (!gridLayout || (rowIndex >= dataProvider.length))
				return;
			
			if (!isCellVisible(rowIndex, columnIndex))
				return;
			
			if (invalidateDisplayListFlag || invalidateSizeFlag)
				return;        
			
			if ((rowIndex >= 0) && (columnIndex >= 0))
			{
				gridLayout.invalidateCell(rowIndex, columnIndex);
			}
			else if (rowIndex >= 0)  // invalidate a row
			{
				const visibleColumnIndices:Vector.<int> = getVisibleColumnIndices();
				for each (var visibleColumnIndex:int in visibleColumnIndices)
				{
					gridLayout.invalidateCell(rowIndex, visibleColumnIndex);
					
					// If invalidating the cell caused the entire grid to be invalid, punt 
					if (invalidateDisplayListFlag || invalidateSizeFlag)
						break;                
				}
			}
			else if (columnIndex >= 0)  // invalidate a column
			{
				const visibleRowIndices:Vector.<int> = getVisibleRowIndices();
				for each (var visibleRowIndex:int in visibleRowIndices)
				{
					// If there are any padding rows, skip them.
					if (visibleRowIndex >= dataProviderLength)
						break;
					
					gridLayout.invalidateCell(visibleRowIndex, columnIndex);
					
					// If invalidating the cell caused the entire grid to be invalid, punt 
					if (invalidateDisplayListFlag || invalidateSizeFlag)
						break;
				}
			}
			
		}*/
		
		/**
		 *  Creates a grid selection object to use to manage selection. Override this method if you have a custom grid 
		 *  selection that you want to use in place of the default and this grid is not a skin part for DataGrid.  
		 *  This method is not used when this grid is a skin part for DataGrid.
		 *
		 *  @see spark.components.DataGrid.createGridSelection
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
		
		
		/**
		 *  This will search through a dataprovider checking the given field and for the given value and return the index for the match.
		 *  It can start the find from a given startingIndex;
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 11.1
		 *  @playerversion AIR 3.4
		 *  @productversion Flex 4.10
		 */
		public function findRowIndex(field:String, value:String, startingIndex:int = 0, patternType:String = RegExPatterns.EXACT):int
		{
			var pattern:RegExp; 
			var currentObject:Object = null;
			var dataProviderTotal:int = 0;
			var loopingIndex:int = startingIndex;
			
			
			pattern = RegExPatterns.createRegExp(value, patternType);
			
			
			if (dataProvider && dataProvider.length > 0)
			{
				dataProviderTotal = dataProvider.length;
				
				if (startingIndex >= dataProviderTotal)
				{
					return -1;
				}
				
				
				for (loopingIndex; loopingIndex < dataProviderTotal; loopingIndex++)
				{
					currentObject = dataProvider.getItemAt(loopingIndex);
					
					if (currentObject.hasOwnProperty(field) == true && pattern.test(currentObject[field]) == true)
					{
						return loopingIndex;
					}
				}
				
			}
			
			return -1;
		}
		
		
		/**
		 *  This will search through a dataprovider checking the given field and for the given values and return an array of indices that matched.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 11.1
		 *  @playerversion AIR 3.4
		 *  @productversion Flex 4.10
		 */
		public function findRowIndices(field:String, values:Array, patternType:String = RegExPatterns.EXACT):Array
		{
			var currentObject:Object = null;
			var regexList:Array = [];
			var matchedIndices:Array = [];
			var dataProviderTotal:uint = 0;
			var valuesTotal:uint = 0;
			var loopingDataProviderIndex:uint = 0;
			var loopingValuesIndex:uint = 0;
			
			
			if (dataProvider != null && dataProvider.length > 0 && values != null && values.length > 0)
			{
				dataProviderTotal = dataProvider.length;
				valuesTotal = values.length;
				
				
				//Set the regex patterns in an array once.
				for (loopingValuesIndex = 0; loopingValuesIndex < valuesTotal; loopingValuesIndex++)
				{
					regexList.push(RegExPatterns.createRegExp(values[loopingValuesIndex], patternType));
				}
				
				
				//Loop through dataprovider
				for (loopingDataProviderIndex; loopingDataProviderIndex < dataProviderTotal; loopingDataProviderIndex++)
				{
					currentObject = dataProvider.getItemAt(loopingDataProviderIndex);
					
					if (currentObject.hasOwnProperty(field) == false)
					{
						continue;
					}
					
					//Loop through regex patterns from the values array.
					for (loopingValuesIndex = 0; loopingValuesIndex < valuesTotal; loopingValuesIndex++)
					{
						if (regexList[loopingValuesIndex].test(currentObject[field]) == true)
						{
							matchedIndices.push(loopingDataProviderIndex);
							
							break;
						}
					}
				}
				
			}
			
			
			return matchedIndices;
		}
		
		
		/**
		 *  This will search through a dataprovider checking the given field and will set the selectedIndex to a matching value.
		 *  It can start the search from the startingIndex;
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 11.1
		 *  @playerversion AIR 3.4
		 *  @productversion Flex 4.10
		 *
		 */
		public function moveIndexFindRow(field:String, value:String, startingIndex:int = 0, patternType:String = RegExPatterns.EXACT):Boolean
		{
			var indexFound:int = -1;
			
			indexFound = findRowIndex(field, value, startingIndex, patternType);
			
			if (indexFound != -1)
			{
				selectedIndex = indexFound;
				
				return true;
			}
			
			return false;
		}
		
		
		/**
		 *  Changes the selectedIndex to the first row of the dataProvider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 11.1
		 *  @playerversion AIR 3.4
		 *  @productversion Flex 4.10
		 */
		public function moveIndexFirstRow():void
		{
			if (dataProvider && dataProvider.length > 0)
			{
				selectedIndex = 0;
			}
		}
		
		
		/**
		 *  Changes the selectedIndex to the last row of the dataProvider.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 11.1
		 *  @playerversion AIR 3.4
		 *  @productversion Flex 4.10
		 */
		public function moveIndexLastRow():void
		{
			if (dataProvider && dataProvider.length > 0)
			{
				selectedIndex = dataProvider.length - 1;
			}
		}
		
		
		/**
		 *  Changes the selectedIndex to the next row of the dataProvider.  If there isn't a current selectedIndex, it silently returns.
		 *  If the selectedIndex is on the first row, it does not wrap around.  However the <code>isFirstRow</code> property returns true.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 11.1
		 *  @playerversion AIR 3.4
		 *  @productversion Flex 4.10
		 */
		public function moveIndexNextRow():void
		{
			if (dataProvider && dataProvider.length > 0 && selectedIndex >= 0)
			{
				if (isLastRow == false)
				{
					selectedIndex += 1;
				}
			}
		}
		
		
		/**
		 *  Changes the selectedIndex to the previous row of the dataProvider.  If there isn't a current selectedIndex, it silently returns.
		 *  If the selectedIndex is on the last row, it does not wrap around.  However the <code>isLastRow</code> property returns true.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 11.1
		 *  @playerversion AIR 3.4
		 *  @productversion Flex 4.10
		 */
		public function moveIndexPreviousRow():void
		{
			if (dataProvider && dataProvider.length > 0 && selectedIndex >= 0)
			{
				if (isFirstRow == false)
				{
					selectedIndex -= 1;
				}
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Internal Grid Access
		//
		//--------------------------------------------------------------------------      
		
		/**
		 *  @private
		 */
		
		private function getGridColumn(columnIndex:int):GridColumn
		{
			const columns:IList = columns;
			if ((columns == null) || (columnIndex < 0) || (columnIndex >= columns.length))
				return null;
			
			return columns.getItemAt(columnIndex) as GridColumn;
		}
		
		/**
		 *  @private
		 */
		mx_internal function getDataProviderItem(rowIndex:int):Object
		{
			const dataProvider:IList = dataProvider;
			if ((dataProvider == null) || (rowIndex >= dataProvider.length))
				return null;
			
			return dataProvider.getItemAt(rowIndex);
		}
		
		/**
		 *  @private
		 */
		
		private function getVisibleItemRenderer(rowIndex:int, columnIndex:int):IGridItemRenderer
		{
			const view:GridView = getGridViewAt(rowIndex, columnIndex);
			if (!view)
				return null;
			
			/*const gridViewLayout:GridViewLayout = view.gridViewLayout;
			const viewRowIndex:int = rowIndex - gridViewLayout.viewRowIndex;
			const viewColumnIndex:int = columnIndex - gridViewLayout.viewColumnIndex;*/
			return null; // gridViewLayout.getVisibleItemRenderer(viewRowIndex, viewColumnIndex);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  GridEvents
		//
		//--------------------------------------------------------------------------  
		
		private var rollRowIndex:int = -1;
		private var rollColumnIndex:int = -1;
		private var mouseDownRowIndex:int = -1;
		private var mouseDownColumnIndex:int = -1;
		private var lastClickedColumnIndex:int = -1;
		private var lastClickedRowIndex:int = -1;
		private var lastClickTime:Number;
		
		// default max time between clicks for a double click is 480ms.
		mx_internal var DOUBLE_CLICK_TIME:Number = 480;
		
		/** 
		 *  @private
		 *  Return the GridView whose bounds contain the MouseEvent, or null.  Note that the 
		 *  comparison is based strictly on the event's location and the GridViews' bounds.
		 *  The event's target can be anything.
		 */
		private function mouseEventGridView(event:MouseEvent):GridView
		{
			const gridLayout:GridLayout = layout as GridLayout;
			
			const centerGridView:GridView = gridLayout.centerGridView;
			if (centerGridView && centerGridView.containsMouseEvent(event))
				return centerGridView;
			
			const leftGridView:GridView = gridLayout.leftGridView;
			if (leftGridView && leftGridView.containsMouseEvent(event))
				return leftGridView;
			
			const topGridView:GridView = gridLayout.topGridView;
			if (topGridView && topGridView.containsMouseEvent(event))
				return topGridView;
			
			const topLeftGridView:GridView = gridLayout.topLeftGridView;
			if (topLeftGridView && topLeftGridView.containsMouseEvent(event))
				return topLeftGridView;
			
			return null;
		}
		
		/** 
		 *  @private
		 *  Return the Grid-relative row,column (gridCP) and X,Y location (gridXY) of the MouseEvent.
		 */    
		private function eventToGridLocations(event:MouseEvent, gridCP:CellPosition, gridXY:Point):void
		{
			const stageXY:Point = new Point(event.stageX, event.stageY);
			const localXY:Point = globalToLocal(stageXY);
			gridXY.x = localXY.x;  // event may not have targeted the Grid
			gridXY.y = localXY.y;
			
			const view:GridView = mouseEventGridView(event);
			if (view)
			{
				const viewXY:Point = view.globalToLocal(stageXY);
				/*
				const gridViewLayout:GridViewLayout = view.gridViewLayout;
				const gdv:GridDimensionsView = gridViewLayout.gridDimensionsView;
				
				
				gridCP.rowIndex = gdv.getRowIndexAt(viewXY.x, viewXY.y) + gridViewLayout.viewRowIndex;
				gridCP.columnIndex = gdv.getColumnIndexAt(viewXY.x, viewXY.y) + gridViewLayout.viewColumnIndex;
				
				gridXY.x = viewXY.x + gdv.viewOriginX;
				gridXY.y = viewXY.y + gdv.viewOriginY;
				*/
			}
			else
			{
				gridCP.rowIndex = -1;
				gridCP.columnIndex = -1;
			}
		}
		
		/**
		 *  @private
		 *  This method is called when a MOUSE_DOWN event occurs within the grid and 
		 *  for all subsequent MOUSE_MOVE events until the button is released (even if the 
		 *  mouse leaves the grid).  The last event in such a "down drag up" gesture is 
		 *  always a MOUSE_UP.  By default this method dispatches GRID_MOUSE_DOWN, 
		 *  GRID_MOUSE_DRAG, or a GRID_MOUSE_UP event in response to the the corresponding
		 *  mouse event.  The GridEvent's rowIndex, columnIndex, column, item, and itemRenderer 
		 *  properties correspond to the grid cell under the mouse.  
		 * 
		 *  @param event A MOUSE_DOWN, MOUSE_MOVE, or MOUSE_UP MouseEvent from a down/move/up gesture initiated within the grid.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */    
		protected function grid_mouseDownDragUpHandler(event:MouseEvent):void
		{
			const eventGridCP:CellPosition = new CellPosition();
			const eventGridXY:Point = new Point();
			eventToGridLocations(event, eventGridCP, eventGridXY);
			
			const eventRowIndex:int = eventGridCP.rowIndex;
			const eventColumnIndex:int = eventGridCP.columnIndex;
			
			var gridEventType:String;
			switch(event.type)
			{
				case MouseEvent.MOUSE_MOVE: 
				{
					gridEventType = GridEvent.GRID_MOUSE_DRAG; 
					break;
				}
				case MouseEvent.MOUSE_UP: 
				{
					gridEventType = GridEvent.GRID_MOUSE_UP;
					break;
				}
				case MouseEvent.MOUSE_DOWN:
				{
					gridEventType = GridEvent.GRID_MOUSE_DOWN;
					mouseDownRowIndex = eventRowIndex;
					mouseDownColumnIndex = eventColumnIndex;
					dragInProgress = true;
					break;
				}
			}
			
			dispatchGridEvent(event, gridEventType, eventGridXY, eventRowIndex, eventColumnIndex);
			if (gridEventType == GridEvent.GRID_MOUSE_UP)
				dispatchGridClickEvents(event, eventGridXY, eventRowIndex, eventColumnIndex);        
		}
		
		/**
		 *  @private
		 *  This method is called whenever a MOUSE_MOVE event occurs within the grid
		 *  without the button pressed.  By default it dispatches a GRID_ROLL_OVER for the
		 *  first MOUSE_MOVE GridEvent whose location is within a grid cell, and a 
		 *  GRID_ROLL_OUT GridEvent when the mouse leaves a cell.  Listeners are guaranteed
		 *  to receive a GRID_ROLL_OUT event for every GRID_ROLL_OVER event.
		 * 
		 *  @param event A MOUSE_MOVE MouseEvent within the grid, without the button pressed.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */    
		protected function grid_mouseMoveHandler(event:MouseEvent):void
		{
			const eventGridCP:CellPosition = new CellPosition();
			const eventGridXY:Point = new Point();
			eventToGridLocations(event, eventGridCP, eventGridXY);
			
			const eventRowIndex:int = eventGridCP.rowIndex;
			const eventColumnIndex:int = eventGridCP.columnIndex;
			
			if ((eventRowIndex != rollRowIndex) || (eventColumnIndex != rollColumnIndex))
			{
				if ((rollRowIndex != -1) || (rollColumnIndex != -1))
					dispatchGridEvent(event, GridEvent.GRID_ROLL_OUT, eventGridXY, rollRowIndex, rollColumnIndex);
				if ((eventRowIndex != -1) && (eventColumnIndex != -1))
					dispatchGridEvent(event, GridEvent.GRID_ROLL_OVER, eventGridXY, eventRowIndex, eventColumnIndex);
				rollRowIndex = eventRowIndex;
				rollColumnIndex = eventColumnIndex;
			}
		}
		
		/**
		 *  @private
		 *  This method is called whenever a ROLL_OUT occurs on the grid.
		 *  By default it dispatches a GRID_ROLL_OUT event.
		 * 
		 *  @param event A ROLL_OUT MouseEvent from the grid.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */       
		protected function grid_mouseRollOutHandler(event:MouseEvent):void
		{
			if ((rollRowIndex != -1) || (rollColumnIndex != -1))
			{
				const eventStageXY:Point = new Point(event.stageX, event.stageY);
				const eventGridXY:Point = globalToLocal(eventStageXY);      
				
				dispatchGridEvent(event, GridEvent.GRID_ROLL_OUT, eventGridXY, rollRowIndex, rollColumnIndex);
				rollRowIndex = -1;
				rollColumnIndex = -1;
			}
		}
		
		/**
		 *  @private
		 *  This method is called whenever a GRID_MOUSE_UP occurs on the grid.
		 *  By default it dispatches a GRID_MOUSE_UP event.
		 * 
		 *  @param event A GRID_MOUSE_UP MouseEvent from the grid.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.5
		 *  @productversion Flex 4.5
		 */       
		protected function grid_mouseUpHandler(event:MouseEvent):void 
		{
			if (dragInProgress)
			{
				// drag handler has already dispatched a mouse up event, don't do so again here
				dragInProgress = false;
				return;
			}
			
			const eventGridCP:CellPosition = new CellPosition();
			const eventGridXY:Point = new Point();
			eventToGridLocations(event, eventGridCP, eventGridXY);
			
			const eventRowIndex:int = eventGridCP.rowIndex;
			const eventColumnIndex:int = eventGridCP.columnIndex;        
			
			dispatchGridEvent(event, GridEvent.GRID_MOUSE_UP, eventGridXY, eventRowIndex, eventColumnIndex);
			dispatchGridClickEvents(event, eventGridXY, eventRowIndex, eventColumnIndex);
		}
		
		/**
		 *  @private
		 *  This method is called after we dispatch a GRID_MOUSE_UP.
		 *  It determines whether to dispatch a GRID_CLICK or GRID_DOUBLE_CLICK
		 *  event following a GRID_MOUSE_UP.
		 * 
		 *  A GRID_CLICK event is dispatched when the mouse up event happens in
		 *  the same cell as the mouse down event.
		 * 
		 *  A GRID_DOUBLE_CLICK event is dispatched in place of the GRID_CLICK
		 *  event when the last click event happened within DOUBLE_CLICK_TIME.
		 */       
		private function dispatchGridClickEvents(mouseEvent:MouseEvent, gridXY:Point, rowIndex:int, columnIndex:int):void
		{
			const dispatchGridClick:Boolean = ((rowIndex == mouseDownRowIndex) && (columnIndex == mouseDownColumnIndex));
			const newClickTime:Number = 0;// getTimer();
			var isDoubleClick:Boolean = false;
			
			// In the case that we dispatched a click last time, check if we
			// should dispatch a double click this time.  The type of check will be based on the double click mode.
			if (doubleClickEnabled && dispatchGridClick && !isNaN(lastClickTime) &&
				(newClickTime - lastClickTime <= DOUBLE_CLICK_TIME))
			{
				switch(_doubleClickMode)
				{
					case GridDoubleClickMode.CELL:
					{
						if (rowIndex != -1 && columnIndex != -1 && rowIndex == lastClickedRowIndex && columnIndex == lastClickedColumnIndex)
						{
							isDoubleClick = true;
						}
						
						break;
					}
						
					case GridDoubleClickMode.GRID:
					{
						isDoubleClick = true;
						
						break;
					}
						
					case GridDoubleClickMode.ROW:
					{
						if (rowIndex != -1 && rowIndex == lastClickedRowIndex)
						{
							isDoubleClick = true;
						}
						
						break;
					}
				}
				
				if (isDoubleClick == true)
				{
					dispatchGridEvent(mouseEvent, GridEvent.GRID_DOUBLE_CLICK, gridXY, rowIndex, columnIndex);
					lastClickTime = NaN;
					lastClickedColumnIndex = -1;
					lastClickedRowIndex = -1;
					isDoubleClick = false;
					
					return;
				}
			}
			
			// Otherwise, just dispatch the click event.
			if (dispatchGridClick)
			{
				dispatchGridEvent(mouseEvent, GridEvent.GRID_CLICK, gridXY, rowIndex, columnIndex);
				lastClickTime = newClickTime;
				lastClickedColumnIndex = columnIndex;
				lastClickedRowIndex = rowIndex;
				isDoubleClick = false;
			}
		}
		
		/**
		 *  @private
		 */
		private function dispatchGridEvent(mouseEvent:MouseEvent, type:String, gridXY:Point, rowIndex:int, columnIndex:int):void
		{
			
			const column:GridColumn = columnIndex >= 0 ? getGridColumn(columnIndex) : null;
			const item:Object = rowIndex >= 0 ? getDataProviderItem(rowIndex) : null;
			const itemRenderer:IGridItemRenderer = getVisibleItemRenderer(rowIndex, columnIndex);
			const bubbles:Boolean = mouseEvent.bubbles;
			const cancelable:Boolean = mouseEvent.cancelable;
			// const relatedObject:InteractiveObject = mouseEvent.relatedObject;
			const ctrlKey:Boolean = mouseEvent.ctrlKey;
			const altKey:Boolean = mouseEvent.altKey;
			const shiftKey:Boolean = mouseEvent.shiftKey;
			const buttonDown:Boolean = mouseEvent.buttonDown;
			const delta:int = mouseEvent.delta;        
			
			/*const event:GridEvent = new GridEvent(
				type, bubbles, cancelable, 
				gridXY.x, gridXY.y, 
				relatedObject, ctrlKey, altKey, shiftKey, buttonDown, delta,
				rowIndex, columnIndex, column, item, itemRenderer);
			dispatchEvent(event);*/
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  IList listeners: columns, dataProvider
		//
		//--------------------------------------------------------------------------  
		
		/**
		 *  @private
		 *  Update caretRowIndex if necessary.  This method should only be called when 
		 *  caretRowIndex is valid, i.e. != -1.
		 */
		private function updateCaretForDataProviderChange(event:CollectionEvent):void
		{
			const oldCaretRowIndex:int = caretRowIndex;
			const location:int = event.location;
			const itemsLength:int = event.items ? event.items.length : 0;                
			var newCaretRowIndex:int; 
			
			switch (event.kind)
			{
				case CollectionEventKind.ADD:
					if (oldCaretRowIndex >= location)
						caretRowIndex += event.items.length;
					break;
				
				case CollectionEventKind.REMOVE:
					if (oldCaretRowIndex >= location)
					{
						// ToDo(cframpto):  If the caret is on an item that is deleted, rather than
						// removing the caret, which is what we do now, it is preferable
						// to have the caret "stick" to the same position.  There is some complexity 
						// to picking a row/cell based on what’s currently visible or partially 
						// visible – after – the delete operation.
						if (oldCaretRowIndex < (location + itemsLength))
							caretRowIndex = -1; 
						else
							caretRowIndex -= itemsLength;    
					}
					
					break;
				
				case CollectionEventKind.MOVE:
				{
					const oldLocation:int = event.oldLocation;
					if ((oldCaretRowIndex >= oldLocation) && (oldCaretRowIndex < (oldLocation + itemsLength)))
					{
						caretRowIndex += location - oldLocation;
						ensureCellIsVisible(caretRowIndex, -1);
					}
				}
					break;                        
				
				case CollectionEventKind.REPLACE:
				case CollectionEventKind.UPDATE:
					break;
				
				case CollectionEventKind.REFRESH:
				{
					newCaretRowIndex = 
						caretSelectedItem ?
						_dataProvider.getItemIndex(caretSelectedItem) : -1; 
					
					// Caret sticks to item if possible and ensure it is totally 
					// visible by scrolling vertically if necessary.
					if (newCaretRowIndex != -1)
					{
						caretRowIndex = newCaretRowIndex;
						ensureCellIsVisible(caretRowIndex, -1);
					}
					else
					{
						// No caret.  Maintain the existing scroll position if
						// within the current data.
						
						var oldVsp:int = verticalScrollPosition;
						
						validateNow();
						
						// If variable row heights the height is 
						// approximate so the scroll position may not be
						// in exactly the same place.
						
						const cHeight:Number = Math.ceil(gridDimensions.getContentHeight());
						const maximum:int = Math.max(cHeight - height, 0);
						verticalScrollPosition = (oldVsp > maximum) ? maximum : oldVsp;                        
					}
					break;
				}
					
				case CollectionEventKind.RESET:
				{
					newCaretRowIndex = 
						caretSelectedItem ?
						_dataProvider.getItemIndex(caretSelectedItem) : -1; 
					
					// Caret sticks to item if possible and ensure it is totally 
					// visible by scrolling vertically if necessary.
					if (newCaretRowIndex != -1)
					{
						caretRowIndex = newCaretRowIndex;
						ensureCellIsVisible(caretRowIndex, -1);
					}
						
						// No caret item so reset caret and vsp.
					else 
					{
						caretRowIndex = _dataProvider.length > 0 ? 0 : -1;
						// we need to call validateSize() to force computing maxTypicalCellHeight  or verticalScrollPosition will fail
						GridLayout(layout).centerGridView.validateSize();
						verticalScrollPosition = 0;
					}
					
					break;
				}
			}   
			
		}
		
		/**
		 *  @private
		 *  Update caretColumnIndex if necessary.  This method should only be 
		 *  called when caretColumnIndex is valid, i.e. != -1.
		 */
		private function updateCaretForColumnsChange(event:CollectionEvent):void
		{
			const oldCaretColumnIndex:int = caretColumnIndex;
			const location:int = event.location;
			const itemsLength:int = event.items ? event.items.length : 0;
			
			switch (event.kind)
			{
				case CollectionEventKind.ADD:
					if (oldCaretColumnIndex >= location)
						caretColumnIndex += itemsLength;
					break;
				
				case CollectionEventKind.REMOVE:
					if (oldCaretColumnIndex >= location)
					{
						if (oldCaretColumnIndex < (location + itemsLength))
							caretColumnIndex = _columns.length > 0 ? 0 : -1; 
						else
							caretColumnIndex -= itemsLength;    
					}                   
					break;
				
				case CollectionEventKind.MOVE:
					const oldLocation:int = event.oldLocation;
					if ((oldCaretColumnIndex >= oldLocation) && (oldCaretColumnIndex < (oldLocation + itemsLength)))
						caretColumnIndex += location - oldLocation;
					break;                        
				
				case CollectionEventKind.REPLACE:
					break;
				
				case CollectionEventKind.UPDATE:
					// column may have changed visiblity which matters if cell 
					// selection mode.
					var pe:PropertyChangeEvent;
					
					if (selectionMode == GridSelectionMode.SINGLE_CELL || 
						selectionMode == GridSelectionMode.MULTIPLE_CELLS)
					{
						for (var i:int = 0; i < itemsLength; i++)
						{
							pe = event.items[i] as PropertyChangeEvent;
							if (pe && pe.property == "visible")
							{	
								
								const column:GridColumn = pe.source as GridColumn;
								if (!column || column.visible)
									continue;
								
								if (column.columnIndex == caretColumnIndex)
									initializeCaretPosition(true);  // column only
								if (column.columnIndex == anchorColumnIndex)
									initializeAnchorPosition(true);  // column only
								
							}
						}
					}
					break;
				
				case CollectionEventKind.REFRESH:
				case CollectionEventKind.RESET:
					initializeCaretPosition(true);  // column only
					horizontalScrollPosition = 0;
					break;
			}            
		}
		
		/**
		 *  @private
		 *  Update hoverRowIndex if necessary.  This method should only be called when 
		 *  hoverRowIndex is valid, i.e. != -1.
		 */
		private function updateHoverForDataProviderChange(event:CollectionEvent):void
		{
			const oldHoverRowIndex:int = hoverRowIndex;
			const location:int = event.location;
			
			switch (event.kind)
			{
				case CollectionEventKind.ADD:
				case CollectionEventKind.REMOVE:
				case CollectionEventKind.REPLACE:
				case CollectionEventKind.UPDATE:
				case CollectionEventKind.MOVE:
					if (oldHoverRowIndex >= location)
						hoverRowIndex = gridDimensions.getRowIndexAt(mouseX, mouseY);
					break;
				
				case CollectionEventKind.REFRESH:
				case CollectionEventKind.RESET:
					hoverRowIndex = gridDimensions.getRowIndexAt(mouseX, mouseY);
					break;
			}                        
		}
		
		/**
		 *  @private
		 *  Update hoverColumnIndex if necessary.  This method should only be called when 
		 *  hoverColumnIndex is valid, i.e. != -1.
		 */
		private function updateHoverForColumnsChange(event:CollectionEvent):void
		{
			switch (event.kind)
			{
				case CollectionEventKind.ADD:
				case CollectionEventKind.REMOVE:
				case CollectionEventKind.REPLACE:
				case CollectionEventKind.UPDATE:
				case CollectionEventKind.MOVE:
					if (hoverColumnIndex >= event.location)
						hoverColumnIndex = gridDimensions.getColumnIndexAt(mouseX, mouseY);
					break;
				
				case CollectionEventKind.REFRESH:
				case CollectionEventKind.RESET:
					hoverColumnIndex = gridDimensions.getColumnIndexAt(mouseX, mouseY);
					break;
			}
		}
		
		/**
		 *  @private
		 */
		private function dataProvider_collectionChangeHandler(event:CollectionEvent):void
		{
			var selectionChanged:Boolean = false;
			
			
			// If no columns exist, we should try to generate them.
			if (!columns && dataProvider.length > 0)
			{
				columns = generateColumns();
				generatedColumns = (columns != null);
				this.gridDimensions.columnCount = generatedColumns ? columns.length : 0;
			}
			
			const gridDimensions:GridDimensions = this.gridDimensions;
			if (gridDimensions)
			{
				gridDimensions.dataProviderCollectionChanged(event);
				gridDimensions.rowCount = dataProvider.length;
			}
			
			for each (var view:GridView in allGridViews)
			{
				if (!view)
					continue;
				// view.gridViewLayout.dataProviderCollectionChanged(event);      
			}
			
			if (gridSelection)
				selectionChanged = gridSelection.dataProviderCollectionChanged(event);            
			
			if (gridDimensions && hoverRowIndex != -1)
				updateHoverForDataProviderChange(event);
			
			// The data has changed so need to do this here so the grid dimensions
			// will be accurate if setting the caret requires scrolling.
			invalidateSize();
			invalidateDisplayList();
			
			if (caretRowIndex != -1)  {
				if (event.kind == CollectionEventKind.RESET){
					// defer for reset events 
					updateCaretForDataProviderChanged = true;
					updateCaretForDataProviderChangeLastEvent = event;
					invalidateProperties();
				}
				else {
					updateCaretForDataProviderChange(event);
				}         
			}
			
			
			// Trigger bindings to selectedIndex/selectedCell/selectedItem and the plurals of those.
			if (selectionChanged)
				dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
		}
		
		/**
		 *  @private
		 */
		private function columns_collectionChangeHandler(event:CollectionEvent):void
		{
			
			var column:GridColumn;
			var columnIndex:int = event.location;
			var i:int;
			var selectionChanged:Boolean = false;
			
			switch (event.kind)
			{
				case CollectionEventKind.ADD: 
				{
					// Note: multiple columns may be added.
					while (columnIndex < columns.length)
					{
						column = GridColumn(columns.getItemAt(columnIndex));
						column.setGrid(this);
						column.setColumnIndex(columnIndex);
						columnIndex++;
					}                  
					break;
				}
					
				case CollectionEventKind.MOVE:
				{
					// All columns between the old and new locations need to 
					// have their index updated.
					columnIndex = Math.min(event.oldLocation, event.location);
					var maxIndex:int = Math.max(event.oldLocation, event.location);
					while (columnIndex <= maxIndex)
					{
						column = GridColumn(columns.getItemAt(columnIndex));
						column.setColumnIndex(columnIndex);
						columnIndex++;
					}                
					break;
				}
					
				case CollectionEventKind.REPLACE:
				{
					var items:Array = event.items;                   
					var length:int = items.length;
					for (i = 0; i < length; i++)
					{
						if (items[i].oldValue is GridColumn)
						{
							column = GridColumn(items[i].oldValue);
							column.setGrid(null);
							column.setColumnIndex(-1);
						}
						if (items[i].newValue is GridColumn)
						{
							column = GridColumn(items[i].newValue);
							column.setGrid(this);
							column.setColumnIndex(columnIndex);
						}
					}
					break;
				}
					
				case CollectionEventKind.UPDATE:
				{
					break;
				}
					
				case CollectionEventKind.REFRESH:
				{
					for (columnIndex = 0; columnIndex < columns.length; columnIndex++)
					{
						column = GridColumn(columns.getItemAt(columnIndex));
						column.setColumnIndex(columnIndex);
					}                
					break;
				}
					
				case CollectionEventKind.REMOVE:
				{
					// Note: multiple columns may be removed.
					var count:int = event.items.length;
					
					for (i = 0; i < count; i++)
					{
						column = GridColumn(event.items[i]);
						column.setGrid(null);
						column.setColumnIndex(-1);
					}
					
					// Renumber the columns which follow the removed columns.
					while (columnIndex < columns.length)
					{
						column = GridColumn(columns.getItemAt(columnIndex));
						column.setColumnIndex(columnIndex);
						columnIndex++;
					}                  
					
					break;
				}
					
				case CollectionEventKind.RESET:
				{
					for (columnIndex = 0; columnIndex < columns.length; columnIndex++)
					{
						column = GridColumn(columns.getItemAt(columnIndex));
						column.setGrid(this);
						column.setColumnIndex(columnIndex);
					}                     
					break;
				}                                
			}
			
			if (gridDimensions)
				gridDimensions.columnsCollectionChanged(event);
			
			for each (var view:GridView in allGridViews)
			{
				if (!view)
					continue;
				// view.gridViewLayout.columnsCollectionChanged(event);      
			}
			
			
			if (gridSelection)
				selectionChanged = gridSelection.columnsCollectionChanged(event);
			
			if (caretColumnIndex != -1)
				updateCaretForColumnsChange(event);                
			
			if (gridDimensions && hoverColumnIndex != -1)
				updateHoverForColumnsChange(event); 
			
			invalidateSize();
			invalidateDisplayList(); 
			
			// Trigger bindings to selectedCell/selectedItem and the plurals of those.
			if (selectionChanged)
				dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
			
		} 
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------  
		
		/**
		 *  @private
		 *  Clears the layout's renderers and cached sizes. Also clears
		 *  the typical item's size if clearTypicalSizes is true.
		 */
		mx_internal function clearGridLayoutCache(clearTypicalSizes:Boolean):void
		{
			for each (var view:GridView in allGridViews)
			{
				if (!view)
					continue;
				// view.gridViewLayout.clearVirtualLayoutCache();
			}
			
			const gridDimensions:GridDimensions = this.gridDimensions;
			if (gridDimensions)
			{
				if (clearTypicalSizes)
				{
					gridDimensions.clearTypicalCellWidthsAndHeights();
					gridDimensions.clearColumns(0, gridDimensions.columnCount);
				}
				
				gridDimensions.clearHeights();
				
				// Reset row count because dataProvider length may have changed.
				gridDimensions.rowCount = _dataProvider ? _dataProvider.length : 0;
			}
			
			// Reset content size so scroller's viewport can be resized.  There
			// is loop-prevention logic in the scroller which may not allow the
			// width/height to be reduced if there are automatic scrollbars.
			// See ScrollerLayout/measure().
			setContentSize(0, 0);
		}
		
		/**
		 *  @private
		 *  Returns the index of the next GridColumn.visible==true column
		 *  after index.
		 *  Returns -1 if there are no more visible columns.
		 *  To find the first GridColumn.visible==true column index, use
		 *  getNextVisibleColumnIndex(-1).
		 */
		mx_internal function getNextVisibleColumnIndex(index:int=-1):int
		{
			if (index < -1)
				return -1;
			
			const columns:IList = this.columns;
			const columnsLength:int = (columns) ? columns.length : 0;
			
			for (var i:int = index + 1; i < columnsLength; i++)
			{
				
				var column:GridColumn = columns.getItemAt(i) as GridColumn;
				if (column && column.visible)
					return i;
				
			}
			
			return -1;
		}
		
		/**
		 *  @private
		 *  Returns the index of the previous GridColumn.visible==true column
		 *  before index.
		 *  Returns -1 if there are no more visible columns.
		 *  To find the last GridColumn.visible==true column index, use
		 *  getPreviousVisibleColumnIndex(columns.length).
		 */
		mx_internal function getPreviousVisibleColumnIndex(index:int):int
		{
			const columns:IList = this.columns;
			if (!columns || index > columns.length)
				return -1;
			
			for (var i:int = index - 1; i >= 0; i--)
			{
				
				var column:GridColumn = columns.getItemAt(i) as GridColumn;
				if (column && column.visible)
					return i;
				
			}
			
			return -1;
		}
		
		/**
		 *  @private
		 */
		private function initializeAnchorPosition(columnOnly:Boolean=false):void
		{
			if (!columnOnly)
				anchorRowIndex = _dataProvider && _dataProvider.length > 0 ? 0 : -1; 
			
			// First visible column, or -1, if there are no columns or none are visible.
			anchorColumnIndex = getNextVisibleColumnIndex(); 
		}
		
		/**
		 *  @private
		 */
		private function initializeCaretPosition(columnOnly:Boolean=false):void
		{
			if (!columnOnly)
				caretRowIndex = _dataProvider && _dataProvider.length > 0 ? 0 : -1;
			
			// First visible column, or -1, if there are no columns or none are visible.
			caretColumnIndex = getNextVisibleColumnIndex();
		}
		
		/**
		 *  @private
		 *  The caret change has already been comitted.  Dispatch the "caretChange"
		 *  event.
		 */
		private function dispatchCaretChangeEvent():void
		{
			if (hasEventListener(GridCaretEvent.CARET_CHANGE))
			{
				const caretChangeEvent:GridCaretEvent = 
					new GridCaretEvent(GridCaretEvent.CARET_CHANGE);
				caretChangeEvent.oldRowIndex = _oldCaretRowIndex;
				caretChangeEvent.oldColumnIndex = _oldCaretColumnIndex;
				caretChangeEvent.newRowIndex = _caretRowIndex;
				caretChangeEvent.newColumnIndex = _caretColumnIndex;
				dispatchEvent(caretChangeEvent);
			}
		}
		
		
		/**
		 *  @private
		 *  Renders a background for the container, if necessary.  It is used to fill in
		 *  a transparent background fill as necessary to support the _mouseEnabledWhereTransparent flag.  It 
		 *  is also used in ItemRenderers when handleBackgroundColor is set to true.
		 *  We assume for now that we are the first layer to be rendered into the graphics
		 *  context.
		 * 
		 *  This is mostly copied from GroupBase, but always chooses the virtualLayout path.  The Grid's
		 *  layout has useVirtualLayout=false but the Grid's GridView always has useVirtualLayout=true
		 *  which causes the GroupBase logic to go down the wrong path.  It also always positions at 0,0
		 *  because the grid itself doesn't scroll, it scrols the layers
		 */
		/*override*/ 
		mx_internal function drawBackground():void
		{
			/*
			if (!mouseEnabledWhereTransparent || !hasMouseListeners)
				return;
			
			var w:Number = (resizeMode == ResizeMode.SCALE) ? measuredWidth : unscaledWidth;
			var h:Number = (resizeMode == ResizeMode.SCALE) ? measuredHeight : unscaledHeight;
			
			if (isNaN(w) || isNaN(h))
				return;
			
			graphics.clear();
			graphics.beginFill(0xFFFFFF, 0);
			
			graphics.drawRect(0, 0, w, h);
			
			graphics.endFill();
			*/
		}
	
		public function set nestLevel(value:int):void 
		{
			
		}
		
		public function get nestLevel():int {
			return 0;
		}
		
		public function set processedDescriptors(value:Boolean):void {
			
		}
		
		public function get processedDescriptors():Boolean {
			return false;
		}
		
		public function set updateCompletePendingFlag(value:Boolean):void {
			
		}
		
		public  function get updateCompletePendingFlag():Boolean {
			return false;
		}
		
		private var _invalidatePropertiesFlag:Boolean = false;
		
		public function get invalidatePropertiesFlag():Boolean {
			return _invalidatePropertiesFlag;
		}
		
		public function set invalidatePropertiesFlag(value:Boolean):void {
			_invalidatePropertiesFlag = value;
		}
		
	}

}