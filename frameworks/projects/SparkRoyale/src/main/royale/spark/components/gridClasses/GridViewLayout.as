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
	// import flash.events.Event;
	// import flash.geom.Rectangle;
	// import flash.utils.Dictionary;
	// import flash.utils.getTimer;
	
	import org.apache.royale.events.Event;
	import org.apache.royale.geom.Rectangle;
	
	import mx.collections.IList;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.IInvalidating;
	//import mx.core.IUITextField;
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.core.Singleton;
	import mx.core.mx_internal;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;
	import mx.managers.ILayoutManagerClient;
	// import mx.managers.LayoutManager;
	
	import spark.collections.SubListView;
	import spark.components.DataGrid;
	import spark.components.Grid;
	import spark.components.supportClasses.GroupBase;
	import spark.core.IGraphicElement;
	import spark.layouts.supportClasses.DropLocation;
	import spark.layouts.supportClasses.LayoutBase;
	
	use namespace mx_internal;
	
	[ExcludeClass]
	
	/**
	 *  @private
	 *  A virtual two dimensional layout for the Grid class.   This is not a general purpose layout,
	 *  it's only intended to be use with GridView.
	 */
	public class GridViewLayout extends LayoutBase
	{
		// include "../../core/Version.as";    
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//-------------------------------------------------------------------------- 
		
		/**
		 *  @private
		 *  The following variables define the visible part of the grid, where each item
		 *  renderer typically displays dataProvider[rowIndex][columns[columnIndex]].dataField.
		 *  The index vectors are sorted in increasing order but their items may not be
		 *  sequential. 
		 */
		private var visibleRowIndices:Vector.<int> = new Vector.<int>(0);
		private var visibleColumnIndices:Vector.<int> = new Vector.<int>(0); 
		
		/**
		 *  @private
		 *  The previous values of the corresponding variables.   Set by layoutItemRenderers()
		 *  and only valid during updateDisplayList(), for a complete relayout.
		 */
		private var oldVisibleRowIndices:Vector.<int> = new Vector.<int>(0);
		private var oldVisibleColumnIndices:Vector.<int> = new Vector.<int>(0);
		
		/** 
		 *  TODO (hmuller): document how do these vectors relate to visibleRow,ColumnIndices
		 */
		private var visibleRowBackgrounds:Vector.<IVisualElement> = new Vector.<IVisualElement>(0);
		private var visibleRowSeparators:Vector.<IVisualElement> = new Vector.<IVisualElement>(0);
		private var visibleColumnSeparators:Vector.<IVisualElement> = new Vector.<IVisualElement>(0);
		private var visibleItemRenderers:Vector.<IGridItemRenderer> = new Vector.<IGridItemRenderer>(0);
		
		/**
		 *  @private
		 *  TODO (hmuller): provide documentation
		 */
		private var hoverIndicator:IVisualElement = null;
		private var caretIndicator:IVisualElement = null;
		private var editorIndicator:IVisualElement = null;
		
		/**
		 *  @private
		 *  The bounding rectangle for all of the visible item renderers.  Note that this
		 *  rectangle may be larger than the scrollRect, since the first/last rows/columns
		 *  of item renderers may only be partially visible.   See scrollPositionChanged().
		 */
		private const visibleItemRenderersBounds:org.apache.royale.geom.Rectangle = new org.apache.royale.geom.Rectangle();
		
		/**
		 *  @private
		 *  The viewport's bounding rectangle; often smaller then visibleItemRenderersBounds.
		 *  Initialized by updateDisplayList with the current scrollPosition, and grid.width,Height.
		 */
		private const visibleGridBounds:org.apache.royale.geom.Rectangle = new org.apache.royale.geom.Rectangle();
		
		/**
		 *  @private
		 *  The elements available for reuse.  Maps from an IFactory to a list of the elements 
		 *  that have been allocated by that factory and then freed.   The list is represented 
		 *  by a Vector.<IVisualElement>.
		 * 
		 *  Updated by allocateGridElement().
		 */
		// private const freeElementMap:Dictionary = new Dictionary();
		
		/**
		 *  @private
		 *  Records the IFactory used to allocate a Element so that free(Element) can find it again.
		 * 
		 *  Updated by createGridElement().
		 */
		// private const elementToFactoryMap:Dictionary = new Dictionary();
		
		/**
		 *  @private
		 *  Used by scrollPositionChanged() to determine which scroll position properties changed.
		 */    
		private var oldVerticalScrollPosition:Number = 0;
		private var oldHorizontalScrollPosition:Number = 0;
		
		//--------------------------------------------------------------------------
		//
		//  Class methods and properties
		//
		//-------------------------------------------------------------------------- 
		
		/**
		 *  @private
		 *  The static embeddedFontsRegistryExists property is initialized lazily. 
		 */
		private static var  _embeddedFontRegistryExists:Boolean = false;
		private static var embeddedFontRegistryExistsInitialized:Boolean = false;
		
		/**
		 *  @private
		 *  True if an embedded font registry singleton exists.
		 */
		private static function get embeddedFontRegistryExists():Boolean
		{
			if (!embeddedFontRegistryExistsInitialized)
			{
				embeddedFontRegistryExistsInitialized = true;
				try
				{
					_embeddedFontRegistryExists = Singleton.getInstance("mx.core::IEmbeddedFontRegistry") != null;
				}
				catch (e:Error)
				{
					_embeddedFontRegistryExists = false;
				}
			}
			
			return _embeddedFontRegistryExists;
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
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.4
		 *  @productversion Flex 4.5
		 */    
		public function GridViewLayout()
		{
			super();
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
				dispatchEvent(new Event(type));
		}    
		
		//----------------------------------
		//  columnsView
		//----------------------------------	
		
		private var _columnsView:SubListView = null;
		
		[Bindable("columnsViewChanged")]
		
		/**
		 *  @default null
		 */
		public function get columnsView():SubListView
		{
			return _columnsView;
		}
		
		/**
		 *  @private
		 */
		public function set columnsView(value:SubListView):void
		{
			if (value == _columnsView)
				return;
			
			_columnsView = value;
			dispatchChangeEvent("columnsViewChanged");
		}
		
		//----------------------------------
		//  dataProviderView
		//----------------------------------
		
		private var _dataProviderView:SubListView = null;
		
		[Bindable("dataProviderViewChanged")]
		
		/**
		 *  @default null
		 */
		public function get dataProviderView():SubListView
		{
			return _dataProviderView;
		}
		
		/**
		 *  @private
		 */
		public function set dataProviderView(value:SubListView):void
		{
			if (value == _dataProviderView)
				return;
			
			_dataProviderView = value;
			dispatchChangeEvent("dataProviderViewChanged");
		}    
		
		//----------------------------------
		//  grid
		//----------------------------------
		
		private var _grid:Grid = null;
		
		/**
		 *  @private
		 */
		public function get grid():Grid
		{
			return _grid;
		}
		
		/**
		 *  The Grid parent of this layout's target.   This property is set by the Grid when the 
		 *  target GridView is added/removed from the Grid.
		 * 
		 */
		public function set grid(value:Grid):void
		{
			if (_grid == value)
				return;
			
			if (_grid)
			{
				_grid.removeEventListener("dataProviderChanged", grid_dataProviderChangedHandler);
				_grid.removeEventListener("columnsChanged", grid_columnsChangedHandler);            
			}
			
			_grid = value;
			
			if (_grid)
			{
				dataProviderView = new SubListView(grid.dataProvider);
				columnsView = new SubListView(grid.columns);
				gridDimensionsView = new GridDimensionsView(grid.gridDimensions);
				
				_grid.addEventListener("dataProviderChanged", grid_dataProviderChangedHandler);
				_grid.addEventListener("columnsChanged", grid_columnsChangedHandler);
			}
			else 
			{
				dataProviderView = null;
				columnsView = null;
				gridDimensionsView = null;
			}
		}
		
		/** 
		 *  @private
		 *  Called when the Grid's dataProvider property is set - not when the dataProvider itself changes.
		 */
		private function grid_dataProviderChangedHandler(ignored:Event):void
		{
			dataProviderView = new SubListView(grid.dataProvider);
			dataProviderView.startIndex = viewRowIndex;
			dataProviderView.count = viewRowCount;
		}
		
		/** 
		 *  @private
		 *  Called when the Grid's column property is set - not when columns are added/removed (etc).
		 */
		private function grid_columnsChangedHandler(ignored:Event):void
		{
			columnsView = new SubListView(grid.columns);
			columnsView.startIndex = viewColumnIndex;
			columnsView.count = viewColumnCount;
		}      
		
		//----------------------------------
		//  gridDimensionsView
		//----------------------------------
		
		private var _gridDimensionsView:GridDimensionsView = null;
		
		[Bindable("gridDimensionsViewChanged")]
		
		/**
		 *  @default null
		 */
		public function get gridDimensionsView():GridDimensionsView
		{
			return _gridDimensionsView;
		}
		
		/**
		 *  @private
		 */
		public function set gridDimensionsView(value:GridDimensionsView):void
		{
			if (value == _gridDimensionsView)
				return;
			
			_gridDimensionsView = value;
			dispatchChangeEvent("gridDimensionsViewChanged");
		}
		
		//----------------------------------
		//  horizontalScrollingLocked
		//----------------------------------
		
		private var _horizontalScrollingLocked:Boolean = false;
		
		[Bindable("horizontalScrollingLockedChanged")]
		
		/**
		 *  @default false
		 */
		public function get horizontalScrollingLocked():Boolean
		{
			return _horizontalScrollingLocked;
		}
		
		/**
		 *  @private
		 */
		public function set horizontalScrollingLocked(value:Boolean):void
		{
			if (value == _horizontalScrollingLocked)
				return;
			
			_horizontalScrollingLocked = value;
			dispatchChangeEvent("horizontalScrollingLockedChanged");
		}
		
		//----------------------------------
		//  requestedColumnCount
		//----------------------------------
		
		private var _requestedColumnCount:int = 0;
		
		[Bindable("requestedColumnCountChanged")]
		
		/**
		 *  @default 0
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
			if (value == _requestedColumnCount)
				return;
			
			_requestedColumnCount = value;
			dispatchChangeEvent("requestedColumnCountChanged");
		}    
		
		//----------------------------------
		//  requestedRowCount
		//----------------------------------
		
		private var _requestedRowCount:int = 0;
		
		[Bindable("requestedRowCountChanged")]
		
		/**
		 *  @default 0
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
			if (value == _requestedRowCount)
				return;
			
			_requestedRowCount = value;
			dispatchChangeEvent("requestedRowCountChanged");
		}
		
		//----------------------------------
		//  useVirtualLayout (override)
		//----------------------------------
		
		/**
		 *  GridLayout only supports virtual layout, the value of this property can not be changed.
		 *  
		 *  @return true.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		override public function get useVirtualLayout():Boolean
		{
			return true;
		}
		
		/**
		 *  @private
		 */
		override public function set useVirtualLayout(value:Boolean):void
		{
		} 
		
		//----------------------------------
		//  verticalScrollingLocked
		//----------------------------------
		
		private var _verticalScrollingLocked:Boolean = false;
		
		[Bindable("verticalScrollingLockedChanged")]
		
		/**
		 *  @default false
		 */
		public function get verticalScrollingLocked():Boolean
		{
			return _verticalScrollingLocked;
		}
		
		/**
		 *  @private
		 */
		public function set verticalScrollingLocked(value:Boolean):void
		{
			if (value == _verticalScrollingLocked)
				return;
			
			_verticalScrollingLocked = value;
			dispatchChangeEvent("verticalScrollingLockedChanged");
		}       
		
		//----------------------------------
		//  viewColumnCount
		//----------------------------------	
		
		/**
		 *  The number of columns displayed by the target GridView.
		 * 
		 *  @default -1
		 */	
		public function get viewColumnCount():int
		{
			return gridDimensionsView.viewColumnCount;
		}
		
		/**
		 *  @private
		 */
		public function set viewColumnCount(value:int):void
		{
			gridDimensionsView.viewColumnCount = value;
			columnsView.count = value;	
		}	
		
		//----------------------------------
		//  viewColumnIndex
		//----------------------------------
		
		/**
		 *  The column index origin of the grid region displayed by the target GridView.
		 * 
		 *  @default 0
		 */
		public function get viewColumnIndex():int
		{
			return gridDimensionsView.viewColumnIndex;
		}
		
		/**
		 *  @private
		 */
		public function set viewColumnIndex(value:int):void
		{
			gridDimensionsView.viewColumnIndex = value;
			columnsView.startIndex = value;
		}
		
		//----------------------------------
		//  viewRowCount
		//----------------------------------
		
		/**
		 *  The number of rows displayed by the target GridView.
		 * 
		 *  @default -1
		 */	
		public function get viewRowCount():int
		{
			return gridDimensionsView.viewRowCount;
		}
		
		/**
		 *  @private
		 */
		public function set viewRowCount(value:int):void
		{
			gridDimensionsView.viewRowCount = value;
			dataProviderView.count = value;	
		}		
		
		//----------------------------------
		//  viewRowIndex
		//----------------------------------
		
		/**
		 *  The row index origin of the grid region displayed by the target GridView.
		 * 
		 *  @default 0
		 */
		public function get viewRowIndex():int
		{
			return gridDimensionsView.viewRowIndex;
		}
		
		/**
		 *  @private
		 */
		public function set viewRowIndex(value:int):void
		{
			gridDimensionsView.viewRowIndex = value;
			dataProviderView.startIndex = value;
		}    
		
		//--------------------------------------------------------------------------
		//
		//  Method Overrides
		//
		//-------------------------------------------------------------------------- 
		
		/**
		 *  Returns the index where a new item should be inserted if
		 *  the user releases the mouse at the specified coordinates
		 *  while completing a drag and drop gesture.
		 * 
		 *  Called by the <code>calculatedDropLocation()</code> method.
		 *
		 *  @param x The x coordinate of the drag and drop gesture, in 
		 *  local coordinates.
		 * 
		 *  @param y The y coordinate of the drag and drop gesture, in  
		 *  the drop target's local coordinates.
		 *
		 *  @return The drop index or -1 if the drop operation is not available
		 *  at the specified coordinates.
		 * 
		 *  @see #calculateDropLocation()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 11
		 *  @playerversion AIR 3.0
		 *  @productversion Flex 5.0
		 */
		override protected function calculateDropIndex(x:Number, y:Number):int
		{
			var rowIndex:int = gridDimensionsView.getRowIndexAt(x, y);
			if (rowIndex == -1)
			{
				rowIndex = gridDimensionsView.rowCount;
			}
			else
			{
				// If we are closer to the next row then drop on the next row.
				var bounds:Rectangle = gridDimensionsView.getRowBounds(rowIndex);
				if (y > (bounds.y + (bounds.height / 2)))
					rowIndex++;
			}
			
			return rowIndex + gridDimensionsView.viewRowIndex;
		}
		
		/**
		 *  Calculates the bounds for the drop indicator that provides visual feedback
		 *  to the user of where the items will be inserted at the end of a drag and drop
		 *  gesture.
		 * 
		 *  Called by the <code>showDropIndicator()</code> method.
		 * 
		 *  @param dropLocation A valid DropLocation object previously returned 
		 *  by the <code>calculateDropLocation()</code> method.
		 * 
		 *  @return The bounds for the drop indicator or null.
		 * 
		 *  @see spark.layouts.supportClasses.DropLocation
		 *  @see #calculateDropIndex()
		 *  @see #calculateDragScrollDelta()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 11
		 *  @playerversion AIR 3.0
		 *  @productversion Flex 5.0
		 */
		override protected function calculateDropIndicatorBounds(dropLocation:DropLocation):Rectangle
		{
			var rowIndex:int = gridDimensionsView.getRowIndexAt(dropLocation.dropPoint.x, dropLocation.dropPoint.y); 
			if (rowIndex == -1)
			{
				// If the last row is visible then put the drop indicator below the last row.
				if (grid.dataProvider && isCellVisible(grid.dataProvider.length - 1, -1))
					rowIndex = grid.dataProvider.length - 1;
				else
					return null;
			}
			
			var bounds:Rectangle = gridDimensionsView.getRowBounds(rowIndex);
			
			// If we are closer to the next row then put the drop indicator on 
			// the next row.
			// TODO (dloverin): TBD how the drop indicator should be sized when
			// rowGap is implemented.
			// NOTE: The bounds indicator for the MX DataGrid start at the top of 
			// the cell. The top of the drag indicator was moved up by two pixels
			// so it could be seen when the indicator bounds are below the last row.
			// The issue is there may not be any space below the last row and the drop
			// indicator would not be visible if it started at the top of the next cell.
			if (dropLocation.dropPoint.y > (bounds.top + bounds.height / 2))
				return new Rectangle(2, bounds.bottom - 2, bounds.width -4, 4);
			
			return new Rectangle(2, Math.max(0, bounds.y - 2), bounds.width - 4, 4);
		}
		
		/**
		 *  @private
		 *  Clear everything.
		 */
		override public function clearVirtualLayoutCache():void
		{
			freeGridElements(visibleRowBackgrounds);
			freeGridElements(visibleRowSeparators);
			visibleRowIndices.length = 0;
			
			freeGridElements(visibleColumnSeparators);        
			visibleColumnIndices.length = 0;
			
			freeItemRenderers(visibleItemRenderers);
			
			clearSelectionIndicators();
			
			freeGridElement(hoverIndicator);
			hoverIndicator = null;
			
			freeGridElement(caretIndicator);
			caretIndicator = null;
			
			freeGridElement(editorIndicator);
			editorIndicator = null;
			
			visibleItemRenderersBounds.setEmpty();
			visibleGridBounds.setEmpty();
		}      
		
		/**
		 *  @private
		 *  This version of the method uses gridDimensions to calcuate the bounds
		 *  of the specified cell.   The index is the cell's position in the row-major
		 *  layout. 
		 */
		override public function getElementBounds(index:int):Rectangle
		{
			const columnsLength:int = gridDimensionsView.columnCount;
			if (columnsLength == -1)
				return null;
			
			const rowIndex:int = index / columnsLength;
			const columnIndex:int = index - (rowIndex * columnsLength);
			return gridDimensionsView.getCellBounds(rowIndex, columnIndex); 
		}
		
		/**
		 *  @private
		 */    
		override protected function getElementBoundsAboveScrollRect(scrollRect:Rectangle):Rectangle
		{
			const y:int = Math.max(0, scrollRect.top - 1);
			const rowIndex:int = gridDimensionsView.getRowIndexAt(scrollRect.x, y);
			return gridDimensionsView.getRowBounds(rowIndex);
		}
		
		/**
		 *  @private
		 */    
		override protected function getElementBoundsBelowScrollRect(scrollRect:Rectangle):Rectangle
		{
			const rowCount:int = gridDimensionsView.rowCount;
			const maxY:int = Math.max(0, gridDimensionsView.getContentHeight(rowCount) - 1); 
			const y:int = Math.min(maxY, scrollRect.bottom + 1);
			const rowIndex:int = gridDimensionsView.getRowIndexAt(scrollRect.x, y);
			return gridDimensionsView.getRowBounds(rowIndex);
		}
		
		/**
		 *  @private
		 */    
		override protected function getElementBoundsLeftOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			const x:int = Math.max(0, scrollRect.left - 1);
			const columnIndex:int = gridDimensionsView.getColumnIndexAt(x, scrollRect.y);
			return gridDimensionsView.getColumnBounds(columnIndex);
		}
		
		/**
		 *  @private
		 */    
		override protected function getElementBoundsRightOfScrollRect(scrollRect:Rectangle):Rectangle
		{
			const columnCount:int = gridDimensionsView.columnCount;
			const maxX:int = Math.max(0, gridDimensionsView.getContentWidth(columnCount) - 1); 
			const x:int = Math.min(maxX, scrollRect.right + 1);
			const columnIndex:int = gridDimensionsView.getColumnIndexAt(x, scrollRect.y);
			return gridDimensionsView.getColumnBounds(columnIndex);
		}
		
		/**
		 *  @private
		 */
		override protected function scrollPositionChanged():void
		{
			if (!grid)
				return;
			
			grid.hoverRowIndex = -1;
			grid.hoverColumnIndex = -1;
			
			super.scrollPositionChanged();  // sets GridView's scrollRect
			
			const hspChanged:Boolean = oldHorizontalScrollPosition != horizontalScrollPosition;
			const vspChanged:Boolean = oldVerticalScrollPosition != verticalScrollPosition;
			
			oldHorizontalScrollPosition = horizontalScrollPosition;
			oldVerticalScrollPosition = verticalScrollPosition;
			
			// Only invalidate if we're clipping and rows and/or columns covered
			// by the scrollR changes.  If so, the visible row/column indicies need
			// to be updated.
			
			var invalidate:Boolean = false;
			
			if (visibleRowIndices.length == 0 || visibleColumnIndices.length == 0)
				invalidate = true;
			
			if (!invalidate && vspChanged)
			{
				const oldFirstRowIndex:int = visibleRowIndices[0];
				const oldLastRowIndex:int = visibleRowIndices[visibleRowIndices.length - 1];
				
				const newFirstRowIndex:int = 
					gridDimensionsView.getRowIndexAt(horizontalScrollPosition, verticalScrollPosition);
				const newLastRowIndex:int = 
					gridDimensionsView.getRowIndexAt(horizontalScrollPosition, verticalScrollPosition + target.height);
				
				if (oldFirstRowIndex != newFirstRowIndex || oldLastRowIndex != newLastRowIndex)
					invalidate = true;
			}
			
			if (!invalidate && hspChanged)
			{
				const oldFirstColIndex:int = visibleColumnIndices[0];			
				const oldLastColIndex:int = visibleColumnIndices[visibleColumnIndices.length - 1];
				
				const newFirstColIndex:int = 
					gridDimensionsView.getColumnIndexAt(horizontalScrollPosition, verticalScrollPosition);
				const newLastColIndex:int = 
					gridDimensionsView.getColumnIndexAt(horizontalScrollPosition + target.width, verticalScrollPosition);
				
				if (oldFirstColIndex != newFirstColIndex || oldLastColIndex != newLastColIndex)
					invalidate = true;
			}
			
			if (invalidate)
			{
				var reason:String = "none";
				if (vspChanged && hspChanged)
					reason = "bothScrollPositions";
				else if (vspChanged)
					reason = "verticalScrollPosition";
				else if (hspChanged)
					reason = "horizontalScrollPosition";
				
				grid.invalidateDisplayListFor(reason);
			}
		}
		
		/**
		 *  @private
		 *  Computes new values for the grid's measuredWidth,Height and 
		 *  measuredMinWidth,Height properties.  
		 * 
		 *  If grid.requestedRowCount is GTE 0, then measuredHeight is estimated 
		 *  content height for as many rows.  Otherwise the measuredHeight is the estimated 
		 *  content height for all rows.  The measuredWidth calculation is similar.  The 
		 *  measuredMinWidth,Height properties are also similar however if the corresponding 
		 *  requestedMin property isn't specified, then the measuredMin size is the same 
		 *  as the measured size.
		 */
		override public function measure():void
		{
			const gridView:GridView = target as GridView;  // TBD: requestedRowCount should be a local property...
			const grid:Grid = this.grid;
			
			if (!gridView || !grid)
				return;
			
			updateTypicalCellSizes();
			
			var measuredRowCount:int = requestedRowCount;
			if (measuredRowCount == -1)
			{
				measuredRowCount = gridDimensionsView.rowCount;
				if (grid.requestedMaxRowCount != -1)
					measuredRowCount = Math.min(grid.requestedMaxRowCount, measuredRowCount);
				if (grid.requestedMinRowCount != -1)
					measuredRowCount = Math.max(grid.requestedMinRowCount, measuredRowCount);                
			}
			
			var measuredColumnCount:int = requestedColumnCount;
			if (measuredColumnCount == -1)
			{
				measuredColumnCount = getColumnsLength();
				if (grid.requestedMinColumnCount != -1)
					measuredColumnCount = Math.max(grid.requestedMinColumnCount, measuredColumnCount);
			}
			
			var measuredWidth:Number = gridDimensionsView.getTypicalContentWidth(measuredColumnCount);
			var measuredHeight:Number = gridDimensionsView.getTypicalContentHeight(measuredRowCount);
			var measuredMinWidth:Number = gridDimensionsView.getTypicalContentWidth(grid.requestedMinColumnCount);
			var measuredMinHeight:Number = gridDimensionsView.getTypicalContentHeight(grid.requestedMinRowCount);
			
			// Use Math.ceil() to make sure that if the content partially occupies
			// the last pixel, we'll count it as if the whole pixel is occupied.
			
			target.measuredWidth = Math.ceil(measuredWidth);    
			target.measuredHeight = Math.ceil(measuredHeight);
			target.measuredMinWidth = Math.ceil(measuredMinWidth);    
			target.measuredMinHeight = Math.ceil(measuredMinHeight);
			
			//trace("measure", target.measuredWidth, target.measuredHeight);
		}
		
		/**
		 *  @private
		 */
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			const grid:Grid = this.grid;
			if (!grid)
				return;
			
			//trace("updateDisplayList", unscaledWidth, unscaledHeight);
			
			// Find the index of the last GridColumn.visible==true column
			
			const columnsLength:int = gridDimensionsView.columnCount;
			const lastVisibleColumnIndex:int = (columnsLength > 0) ? getPreviousVisibleColumnIndex(columnsLength) : -1;
			if (lastVisibleColumnIndex < 0)
				return;
			
			// Layers
			
			const backgroundLayer:GridLayer = getLayer("backgroundLayer");
			const selectionLayer:GridLayer = getLayer("selectionLayer");    
			const editorIndicatorLayer:GridLayer = getLayer("editorIndicatorLayer");
			const rendererLayer:GridLayer = getLayer("rendererLayer");
			const overlayLayer:GridLayer = getLayer("overlayLayer"); 
			
			// Relayout everything if the scroll position changed or if no 
			// "invalidateDisplayList reason" was specified.  See
			// Grid/invalidateDisplayListFor(reason)
			
			const completeLayoutNeeded:Boolean = 
				grid.isInvalidateDisplayListReason("verticalScrollPosition") ||
				grid.isInvalidateDisplayListReason("horizontalScrollPosition");
			
			
			// Layout the columns and item renderers; compute new values for visibleRowIndices et al.
			
			if (completeLayoutNeeded)
			{
				oldVisibleRowIndices = visibleRowIndices;
				oldVisibleColumnIndices = visibleColumnIndices;
				
				// Determine the x/y position of the visible content.  Note that the 
				// actual scroll positions may be negative.
				
				const scrollX:Number = Math.max(0, horizontalScrollPosition);
				const scrollY:Number = Math.max(0, verticalScrollPosition);
				
				visibleGridBounds.x = scrollX;
				visibleGridBounds.y = scrollY;
				visibleGridBounds.width = unscaledWidth;
				visibleGridBounds.height = unscaledHeight;
				
				layoutColumns(scrollX, scrollY, unscaledWidth);
				layoutItemRenderers(rendererLayer, scrollX, scrollY, unscaledWidth, unscaledHeight);
				
				// Update the content size.  Make sure that if the content spans partially 
				// over a pixel to the right/bottom, the content size includes the whole pixel.
				
				const columnCount:int = getColumnsLength();
				const rowCount:int = gridDimensionsView.rowCount;
				
				const contentWidth:Number = Math.ceil(gridDimensionsView.getContentWidth(columnCount));
				const contentHeight:Number = Math.ceil(gridDimensionsView.getContentHeight(rowCount));
				target.setContentSize(contentWidth, contentHeight);
				
				// If the grid's contentHeight is smaller than than the available height 
				// (unscaledHeight) then pad the visible rows
				
				var paddedRowCount:int = rowCount;
				if ((scrollY == 0) && (contentHeight < unscaledHeight))
				{
					const unusedHeight:Number = unscaledHeight - gridDimensionsView.getContentHeight(rowCount);
					paddedRowCount += Math.ceil(unusedHeight / gridDimensionsView.defaultRowHeight);
				}
				
				for (var rowIndex:int = rowCount; rowIndex < paddedRowCount; rowIndex++)
					visibleRowIndices.push(rowIndex);
				
				// Layout the row backgrounds
				
				visibleRowBackgrounds = layoutLinearElements(grid.rowBackground, backgroundLayer,
					visibleRowBackgrounds, oldVisibleRowIndices, visibleRowIndices, layoutRowBackground);
				
				// Layout the row and column separators. 
				
				const lastRowIndex:int = paddedRowCount - 1;
				
				visibleRowSeparators = layoutLinearElements(grid.rowSeparator, overlayLayer, 
					visibleRowSeparators, oldVisibleRowIndices, visibleRowIndices, layoutRowSeparator, lastRowIndex);
				
				visibleColumnSeparators = layoutLinearElements(grid.columnSeparator, overlayLayer, 
					visibleColumnSeparators, oldVisibleColumnIndices, visibleColumnIndices, layoutColumnSeparator, lastVisibleColumnIndex);
				
				
				// The old visible row,column indices are no longer needed
				
				oldVisibleRowIndices.length = 0;
				oldVisibleColumnIndices.length = 0;            
			}
			
			// Layout the hoverIndicator, caretIndicator, and selectionIndicators
			
			if (completeLayoutNeeded || grid.isInvalidateDisplayListReason("hoverIndicator"))
				layoutHoverIndicator(backgroundLayer);
			
			if (completeLayoutNeeded || grid.isInvalidateDisplayListReason("selectionIndicator"))
				layoutSelectionIndicators(selectionLayer);
			
			if (completeLayoutNeeded || grid.isInvalidateDisplayListReason("caretIndicator"))
				layoutCaretIndicator(overlayLayer);
			
			if (completeLayoutNeeded || grid.isInvalidateDisplayListReason("editorIndicator"))
				layoutEditorIndicator(editorIndicatorLayer);
			
			if (!completeLayoutNeeded)
				updateVisibleItemRenderers();
			
			// To avoid flashing, force all of the layers to render now
			
			target.validateNow();
		}
		
		/** 
		 *  @private
		 *  Reset the selected, showsCaret, and hovered properties for all visible item renderers.
		 *  Run the prepare() method for renderers that have changed.
		 * 
		 *  This method is only called when the item renderers are not updated as part of a general
		 *  redisplay, by layoutItemRenderers(). 
		 */
		private function updateVisibleItemRenderers():void
		{
			const grid:Grid = grid;  // avoid get method cost
			const rowSelectionMode:Boolean = isRowSelectionMode();
			const cellSelectionMode:Boolean = isCellSelectionMode();
			
			if (!rowSelectionMode && !cellSelectionMode)
				return;
			
			for each (var renderer:IGridItemRenderer in visibleItemRenderers)            
			{
				var rowIndex:int = renderer.rowIndex;  // TBD: need grid-relative row,column indices here
				var columnIndex:int = renderer.columnIndex;
				
				var oldSelected:Boolean  = renderer.selected;
				var oldShowsCaret:Boolean = renderer.showsCaret;
				var oldHovered:Boolean = renderer.hovered;
				
				// The following initializations should match what's done in initializeItemRenderer()
				if (rowSelectionMode)
				{                
					renderer.selected = grid.selectionContainsIndex(rowIndex);
					renderer.showsCaret = grid.caretRowIndex == rowIndex;
					renderer.hovered = grid.hoverRowIndex == rowIndex;
				}
				else if (cellSelectionMode)
				{
					renderer.selected = grid.selectionContainsCell(rowIndex, columnIndex);
					renderer.showsCaret = (grid.caretRowIndex == rowIndex) && (grid.caretColumnIndex == columnIndex);
					renderer.hovered = (grid.hoverRowIndex == rowIndex) && (grid.hoverColumnIndex == columnIndex);                    
				}
				
				if ((oldSelected != renderer.selected) || 
					(oldShowsCaret != renderer.showsCaret) || 
					(oldHovered != renderer.hovered))
					renderer.prepare(true);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Target GridView Access
		//
		//--------------------------------------------------------------------------
		
		private function gridRowIndexToViewIndex(gridRowIndex:int):int
		{
			return (gridRowIndex == -1) ? -1 : gridRowIndex - viewRowIndex;
		}
		
		private function gridColumnIndexToViewIndex(gridColumnIndex:int):int
		{
			return (gridColumnIndex == -1) ? -1 : gridColumnIndex - viewColumnIndex;
		}    
		
		private function getLayer(name:String):GridLayer
		{
			return target.getChildByName(name) as GridLayer;
			
		}
		
		/**
		 *  @private
		 */
		private function getGridColumn(columnIndex:int):GridColumn
		{
			const columnsView:IList = columnsView;
			if ((columnsView == null) || (columnIndex >= columnsView.length) || (columnIndex < 0))
				return null;
			
			return columnsView.getItemAt(columnIndex) as GridColumn;
		}
		
		/**
		 *  @private
		 */
		private function getColumnsLength():int
		{
			return (columnsView) ? columnsView.length : 0;
		}
		
		
		/**
		 *  @private
		 *  Returns the index of the next Grid.visible==true column
		 *  after index. Returns -1 if there are no more visible columns.
		 * 
		 *  To find the first GridColumn.visible==true column index, use
		 *  getNextVisibleColumnIndex(-1).
		 */
		private function getNextVisibleColumnIndex(index:int=-1):int
		{
			if (index < -1)
				return -1;
			
			const columns:IList = columnsView;        
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
		 *  before index.  Returns -1 if there are no more visible columns.
		 * 
		 *  To find the last GridColumn.visible==true column index, use
		 *  getPreviousVisibleColumnIndex(columns.length).
		 */
		private function getPreviousVisibleColumnIndex(index:int):int
		{
			const columns:IList = columnsView;
			if (!columns || (index > columns.length))
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
		private function getDataProviderItem(rowIndex:int):Object
		{
			const dataProviderView:IList = this.dataProviderView;
			
			if ((dataProviderView == null) || (rowIndex >= dataProviderView.length) || (rowIndex < 0))
				return null;
			
			return dataProviderView.getItemAt(rowIndex);
		}
		
		
		/**
		 *  @private
		 */
		private function getDataProviderLength():int 
		{
			const dataProviderView:IList = this.dataProviderView;
			
			return (dataProviderView) ? dataProviderView.length : -1;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Updating the GridDimensions' typicalCell sizes and columnWidths
		//
		//-------------------------------------------------------------------------- 
		
		/**
		 *  @private
		 *  Return width clamped to the column's minWidth and maxWidth properties.
		 */
		private static function clampColumnWidth(width:Number, column:GridColumn):Number
		{
			const minColumnWidth:Number = column.minWidth;
			const maxColumnWidth:Number = column.maxWidth;
			
			if (!isNaN(minColumnWidth))
				width = Math.max(width, minColumnWidth);
			if (!isNaN(maxColumnWidth))
				width = Math.min(width, maxColumnWidth);
			
			return width;
		}
		
		/**
		 *  @private
		 *  Use the specified GridColumn's itemRenderer (IFactory) to create a temporary
		 *  item renderer.   The returned item renderer must be freed, with freeGridElement(),
		 *  and removed from the rendererLayer after it's used.
		 */
		private function createTypicalItemRenderer(columnIndex:int):IGridItemRenderer
		{
			const rendererLayer:GridLayer = getLayer("rendererLayer");
			if (!rendererLayer)
				return null;
			
			var typicalItem:Object = grid.typicalItem;
			if (typicalItem == null)
				typicalItem = getDataProviderItem(0);
			
			const column:GridColumn = getGridColumn(columnIndex);
			const factory:IFactory = itemToRenderer(column, typicalItem);
			const renderer:IGridItemRenderer = allocateGridElement(factory) as IGridItemRenderer;
			
			// rendererLayer.addElement(renderer);
			
			initializeItemRenderer(renderer, 0 /* rowIndex */, columnIndex, grid.typicalItem, false);
			
			// If the column's width isn't specified, then use the renderer's explicit
			// width, if any.   If that isn't specified, then use 4096, to avoid wrapping.
			
			var columnWidth:Number = column.width;
			
			if (isNaN(columnWidth))
			{
				// Sadly, IUIComponent, UITextField, and UIFTETextField all have an 
				// explicitWidth property but do not share a common type.  
				if ("explicitWidth" in renderer)
					columnWidth = Object(renderer).explicitWidth;
			}
			
			// The default width of a UI[FTE]TextField is 100.  If autoWrap is true, and
			// multiline is true, the measured text will wrap if it is wider than
			// the TextField's width. This is not what we want when measuring the 
			// width of typicalItem columns that lack an explicit column width.
			
			if (isNaN(columnWidth))
				columnWidth = 4096;
			
			layoutItemRenderer(renderer, 0, 0, columnWidth, NaN);
			
			return renderer;
		}
		
		/**
		 *  @private
		 *  Update the typicalCellWidth,Height for all of the columns starting 
		 *  with x coordinate startX and column startIndex that fit within the 
		 *  specified width.  Typical sizes are only updated if the current 
		 *  typical cell size is NaN. 
		 * 
		 *  The typicalCellWidth for GridColumns with an explicit width, is just 
		 *  the explicit width.  Otherwise an item renderer is created for the column 
		 *  and the item renderer's preferred bounds become the typical cell size.   
		 */
		private function updateVisibleTypicalCellSizes(width:Number, scrollX:Number, firstVisibleColumnIndex:int):void
		{
			const rendererLayer:GridLayer = getLayer("rendererLayer");
			if (!rendererLayer)
				return;        
			
			const columnCount:int = getColumnsLength();
			const startCellX:Number = gridDimensionsView.getCellX(0 /* rowIndex */, firstVisibleColumnIndex);
			const columnGap:int = gridDimensionsView.columnGap;
			
			var columnIndex : int;
			var column : GridColumn;
			var totalWidthCoef : Number = 0;
			var contentFreeSpace : Number = grid.contentWidth;
			var gridFreeSpace : Number = grid.width;
			for (columnIndex = 0; (columnIndex < columnCount); columnIndex++) 
			{
				column = getGridColumn(columnIndex);
				if (isNaN(column.width) && column.visible) 
				{
					totalWidthCoef += column.percentWidth;
				} 
				else 
				{
					if (!isNaN(column.width) && column.visible) 
					{
						contentFreeSpace -= column.width;
						gridFreeSpace -= column.width;
					}
				}
			}
			var freeSpace : Number = gridFreeSpace < 0 ? contentFreeSpace : gridFreeSpace;
			var unusedFreeSpace : Number = freeSpace;
			
			for (columnIndex = firstVisibleColumnIndex;
				(width > 0) && (columnIndex >= 0) && (columnIndex < columnCount);
				columnIndex = getNextVisibleColumnIndex(columnIndex))
			{
				var cellHeight:Number = gridDimensionsView.getTypicalCellHeight(columnIndex);
				var cellWidth:Number = gridDimensionsView.getTypicalCellWidth(columnIndex);
				
				column = getGridColumn(columnIndex);
				if (!isNaN(column.width))
				{
					cellWidth = column.width;
					gridDimensionsView.setTypicalCellWidth(columnIndex, cellWidth);
				} 
				else 
				{
					if (totalWidthCoef > 0) 
					{
						cellWidth = Math.round(column.percentWidth / totalWidthCoef * (freeSpace > 0 ? freeSpace : 0));
						if (cellWidth < column.minWidth) 
						{
							cellWidth = column.minWidth;
							unusedFreeSpace -= cellWidth;
						} 
						else 
						{
							if (cellWidth > unusedFreeSpace) 
							{
								cellWidth = unusedFreeSpace;
								unusedFreeSpace = 0;
							} 
							else 
							{
								unusedFreeSpace -= cellWidth;
							}
						}
						gridDimensionsView.setTypicalCellWidth(columnIndex, cellWidth);
					}
				}
				
				if (isNaN(cellWidth) || isNaN(cellHeight))
				{
					var renderer:IGridItemRenderer = createTypicalItemRenderer(columnIndex);
					if (isNaN(cellWidth))
					{
						cellWidth = clampColumnWidth(renderer.getPreferredBoundsWidth(), column);
						gridDimensionsView.setTypicalCellWidth(columnIndex, cellWidth);
					}
					if (isNaN(cellHeight))
					{
						cellHeight = renderer.getPreferredBoundsHeight();
						gridDimensionsView.setTypicalCellHeight(columnIndex, cellHeight);
					}
					
					// rendererLayer.removeElement(renderer);                
					freeGridElement(renderer);
				}
				
				if (columnIndex == firstVisibleColumnIndex)
					width -= startCellX + cellWidth - scrollX;
				else
					width -= cellWidth + columnGap;
			}
		}
		
		/**
		 *  @private
		 *  Used by the measure() method to initialize the GridDimensions typical width,height of 
		 *  requestedColumnCount columns, and the typical width of *all* columns with an explicit width.
		 */
		private function updateTypicalCellSizes():void
		{
			const rendererLayer:GridLayer = getLayer("rendererLayer");
			if (!rendererLayer)
				return;  
			
			const columnCount:int = getColumnsLength();
			const requestedColumnCount:int = grid.requestedColumnCount;  // TBD GridView...
			var measuredColumnCount:int = 0;
			
			var columnIndex : int;
			var column : GridColumn;
			var totalWidthCoef : Number = 0;
			var contentFreeSpace : Number = grid.contentWidth;
			var gridFreeSpace : Number = grid.width;
			for (columnIndex = 0; (columnIndex < columnCount); columnIndex++) 
			{
				column = getGridColumn(columnIndex);
				if (isNaN(column.width) && column.visible) 
				{
					totalWidthCoef += column.percentWidth;
				} 
				else 
				{
					if (!isNaN(column.width) && column.visible) 
					{
						contentFreeSpace -= column.width;
						gridFreeSpace -= column.width;
					}
				}
			}
			var freeSpace : Number = gridFreeSpace < 0 ? contentFreeSpace : gridFreeSpace;
			var unusedFreeSpace : Number = freeSpace;
			
			for (columnIndex = 0; (columnIndex < columnCount); columnIndex++)
			{
				var cellHeight:Number = gridDimensionsView.getTypicalCellHeight(columnIndex);
				var cellWidth:Number = gridDimensionsView.getTypicalCellWidth(columnIndex);
				
				column = getGridColumn(columnIndex);
				
				// GridColumn.visible==false columns have a typical size of (0,0)
				// to distinguish them from the GridColumn.visible==true columns
				// that aren't in view yet.
				
				if (!column.visible)
				{
					gridDimensionsView.setTypicalCellWidth(columnIndex, 0);
					gridDimensionsView.setTypicalCellHeight(columnIndex, 0);
					continue;
				}
				
				if (!isNaN(column.width))
				{
					cellWidth = column.width;
					gridDimensionsView.setTypicalCellWidth(columnIndex, cellWidth);
				} 
				else 
				{
					if (totalWidthCoef > 0) 
					{
						cellWidth = Math.round(column.percentWidth / totalWidthCoef * (freeSpace > 0 ? freeSpace : 0));
						if (cellWidth < column.minWidth) 
						{
							cellWidth = column.minWidth;
							unusedFreeSpace -= cellWidth;
						} 
						else 
						{
							if (cellWidth > unusedFreeSpace) 
							{
								cellWidth = unusedFreeSpace;
								unusedFreeSpace = 0;
							} 
							else 
							{
								unusedFreeSpace -= cellWidth;
							}
						}
						gridDimensionsView.setTypicalCellWidth(columnIndex, cellWidth);
					}
				}
				
				var needTypicalRenderer:Boolean = (requestedColumnCount == -1) || (measuredColumnCount < requestedColumnCount);
				if (needTypicalRenderer && (isNaN(cellWidth) || isNaN(cellHeight)))
				{
					var renderer:IGridItemRenderer = createTypicalItemRenderer(columnIndex);
					if (isNaN(cellWidth))
					{
						cellWidth = clampColumnWidth(renderer.getPreferredBoundsWidth(), column);
						gridDimensionsView.setTypicalCellWidth(columnIndex, cellWidth);
					}
					if (isNaN(cellHeight))
					{
						cellHeight = renderer.getPreferredBoundsHeight();
						gridDimensionsView.setTypicalCellHeight(columnIndex, cellHeight);
					}
					
					// rendererLayer.removeElement(renderer);
					freeGridElement(renderer);
				}
				measuredColumnCount++;
			}
			
		}
		
		/**
		 *  @private
		 *  Update the column widths for the columns visible beginning at scrollX, that will fit
		 *  within the specified width, or for all columns if width is NaN.  The width of 
		 *  GridColumns that lack an explicit width is the preferred width of an item renderer 
		 *  for the grid's typicalItem. 
		 * 
		 *  If width is specified and all columns are visible, then we'll increase the widths
		 *  of GridDimensions columns for GridColumns without an explicit width so that all of
		 *  the available space is consumed.
		 */
		private function layoutColumns(scrollX:Number, scrollY:Number, width:Number):void
		{
			var columnCount:int = gridDimensionsView.columnCount;
			if (columnCount <= 0)
				return;
			
			// Update the GridDimensions typicalCellWidth,Height values as needed.
			
			const firstVisibleColumnIndex:int = gridDimensionsView.getColumnIndexAt(scrollX, scrollY);
			updateVisibleTypicalCellSizes(width, scrollX, firstVisibleColumnIndex);
			
			// Set the GridDimensions columnWidth for no more than columnCount columns.
			
			const columnGap:int = gridDimensionsView.columnGap;
			const startCellX:Number = gridDimensionsView.getCellX(0 /* rowIndex */, firstVisibleColumnIndex);
			var availableWidth:Number = width;
			var flexibleColumnCount:uint = 0;
			
			for (var columnIndex:int = firstVisibleColumnIndex;
				(availableWidth > 0) && (columnIndex >= 0) && (columnIndex < columnCount);
				columnIndex = getNextVisibleColumnIndex(columnIndex))
			{
				var columnWidth:Number = gridDimensionsView.getTypicalCellWidth(columnIndex);
				var gridColumn:GridColumn = getGridColumn(columnIndex);
				
				if (isNaN(gridColumn.width)) // if this column's width wasn't explicitly specified
				{
					flexibleColumnCount += 1;
					columnWidth = clampColumnWidth(columnWidth, gridColumn);
				}
				else
					columnWidth = gridColumn.width;
				
				gridDimensionsView.setColumnWidth(columnIndex, columnWidth);  // store the column width
				
				if (columnIndex == firstVisibleColumnIndex)
					availableWidth -= startCellX + columnWidth - scrollX;
				else
					availableWidth -= columnWidth + columnGap;
			}
			
			// If we haven't scrolled horizontally, and there's space left over, widen 
			// the columns whose GridColumn width isn't set explicitly, to fill the extra space.
			
			if ((scrollX != 0) || (availableWidth < 1.0) || (flexibleColumnCount == 0))
				return;
			
			const columnWidthDelta:Number = Math.ceil(availableWidth / flexibleColumnCount);
			
			for (columnIndex = firstVisibleColumnIndex;
				(columnIndex >= 0) && (columnIndex < columnCount) && (availableWidth >= 1.0);
				columnIndex = getNextVisibleColumnIndex(columnIndex))
			{
				gridColumn = getGridColumn(columnIndex);
				
				if (isNaN(gridColumn.width)) // if this column's width wasn't explicitly specified 
				{
					var oldColumnWidth:Number = gridDimensionsView.getColumnWidth(columnIndex);
					columnWidth = oldColumnWidth + Math.min(availableWidth, columnWidthDelta);
					columnWidth = clampColumnWidth(columnWidth, gridColumn);
					gridDimensionsView.setColumnWidth(columnIndex, columnWidth);  // store the column width
					availableWidth -= (columnWidth - oldColumnWidth);
				}
			}    
		}
		
		//--------------------------------------------------------------------------
		//
		//  Item Renderer Management and Layout
		//
		//--------------------------------------------------------------------------    
		
		// private const gridItemRendererClassFactories:Dictionary = new Dictionary(true);
		
		/**
		 *  @private
		 *  Return the item renderer for the specified column and dataProvider item,
		 *  essentially column.itemToRenderer(dataItem). 
		 * 
		 *  If this app might have embedded fonts then item renderers must be created with the Grid's
		 *  module factory.  To enable that, we wrap the real item renderer ClassFactory with 
		 *  a GridItemRendererClassFactory.  Wrapped factories are cached in 
		 *  the gridItemRendererClassFactories Dictionary.
		 */
		private function itemToRenderer(column:GridColumn, dataItem:Object):IFactory
		{
			var factory:IFactory = column.itemToRenderer(dataItem);
			var rendererClassFactory:IFactory = null;
			
			if (embeddedFontRegistryExists && (factory is ClassFactory))
			{
				// rendererClassFactory = gridItemRendererClassFactories[factory];
				if (!rendererClassFactory)
				{
					// rendererClassFactory = new GridItemRendererClassFactory(grid, ClassFactory(factory));
					// gridItemRendererClassFactories[factory] = rendererClassFactory;
				}
			}
			
			return (rendererClassFactory) ? rendererClassFactory : factory;
		}
		
		private function layoutItemRenderers(rendererLayer:GridLayer, scrollX:Number, scrollY:Number, width:Number, height:Number):void
		{
			if (!rendererLayer)
				return;
			
			var rowIndex:int;
			var colIndex:int;
			
			const rowCount:int = gridDimensionsView.rowCount;
			const colCount:int = getColumnsLength();
			const rowGap:int = gridDimensionsView.rowGap;
			const colGap:int = gridDimensionsView.columnGap;
			
			// Compute the row,column index and bounds of the upper left "start" cell
			
			const startColIndex:int = gridDimensionsView.getColumnIndexAt(scrollX, scrollY);
			const startRowIndex:int = gridDimensionsView.getRowIndexAt(scrollX, scrollY);
			const startCellX:Number = gridDimensionsView.getCellX(startRowIndex, startColIndex); 
			const startCellY:Number = gridDimensionsView.getCellY(startRowIndex, startColIndex); 
			
			// Compute newVisibleColumns
			
			const newVisibleColumnIndices:Vector.<int> = new Vector.<int>();
			var availableWidth:Number = width;
			var column:GridColumn;
			
			for (colIndex = startColIndex; 
				(availableWidth > 0) && (colIndex >= 0) && (colIndex < colCount);
				colIndex = getNextVisibleColumnIndex(colIndex))
			{
				newVisibleColumnIndices.push(colIndex);
				var columnWidth:Number = gridDimensionsView.getColumnWidth(colIndex);
				if (colIndex == startColIndex)
					availableWidth -= startCellX + columnWidth - scrollX;
				else
					availableWidth -= columnWidth + colGap;
			}
			
			// compute newVisibleRowIndices, newVisibleItemRenderers, layout item renderers
			
			const newVisibleRowIndices:Vector.<int> = new Vector.<int>();
			const newVisibleItemRenderers:Vector.<IGridItemRenderer> = new Vector.<IGridItemRenderer>();
			
			var cellX:Number = startCellX;
			var cellY:Number = startCellY;
			var availableHeight:Number = height;
			
			for (rowIndex = startRowIndex; (availableHeight > 0) && (rowIndex >= 0) && (rowIndex < rowCount); rowIndex++)
			{
				newVisibleRowIndices.push(rowIndex);
				
				var rowHeight:Number = gridDimensionsView.getRowHeight(rowIndex);
				for each (colIndex in newVisibleColumnIndices)
				{
					var renderer:IGridItemRenderer = takeVisibleItemRenderer(rowIndex, colIndex);
					if (!renderer)
					{       
						var dataItem:Object = getDataProviderItem(rowIndex);
						column = getGridColumn(colIndex);
						var factory:IFactory = itemToRenderer(column, dataItem);
						renderer = allocateGridElement(factory) as IGridItemRenderer;
					}
					/*if (renderer.parent != rendererLayer)
						rendererLayer.addElement(renderer);*/
					newVisibleItemRenderers.push(renderer);
					
					initializeItemRenderer(renderer, rowIndex, colIndex);
					
					var colWidth:Number = gridDimensionsView.getColumnWidth(colIndex);
					layoutItemRenderer(renderer, cellX, cellY, colWidth, rowHeight);                
					
					var preferredRowHeight:Number = renderer.getPreferredBoundsHeight();
					gridDimensionsView.setCellHeight(rowIndex, colIndex, preferredRowHeight);
					cellX += colWidth + colGap;
				}
				
				// If gridDimensions.rowHeight is now larger, we need to make another
				// pass to fix up the item renderer heights. 
				
				const finalRowHeight:Number = gridDimensionsView.getRowHeight(rowIndex);
				if (rowHeight != finalRowHeight)
				{
					const visibleColumnsLength:int = newVisibleColumnIndices.length;
					rowHeight = finalRowHeight;
					for each (colIndex in newVisibleColumnIndices)
					{
						var rowOffset:int = newVisibleRowIndices.indexOf(rowIndex);
						var colOffset:int = newVisibleColumnIndices.indexOf(colIndex);                    
						var index:int = (rowOffset * visibleColumnsLength) + colOffset;
						renderer = newVisibleItemRenderers[index];                    
						
						// We're using layoutBoundsX,Y,Width instead of x,y.width because
						// the IUITextField item renderers pad their x,y,width,height properties 
						var rendererX:Number = renderer.getLayoutBoundsX();
						var rendererY:Number = renderer.getLayoutBoundsY();
						var rendererWidth:Number = renderer.getLayoutBoundsWidth();
						
						layoutItemRenderer(renderer, rendererX, rendererY, rendererWidth, rowHeight);
						gridDimensionsView.setCellHeight(rowIndex, colIndex, renderer.getPreferredBoundsHeight());
					}
				} 
				
				cellX = startCellX;
				cellY += rowHeight + rowGap;
				
				if (rowIndex == startRowIndex)
					availableHeight -= startCellY + rowHeight - scrollY;
				else
					availableHeight -= rowHeight + rowGap;            
			}
			
			// Free renderers that aren't in use
			
			for each (var oldRenderer:IGridItemRenderer in visibleItemRenderers)
			freeItemRenderer(oldRenderer);
			
			// Update visibleItemRenderersBounds
			
			if ((newVisibleRowIndices.length > 0) && (newVisibleColumnIndices.length > 0))
			{
				const lastRowIndex:int = newVisibleRowIndices[newVisibleRowIndices.length - 1];
				const lastColIndex:int = newVisibleColumnIndices[newVisibleColumnIndices.length - 1];
				const lastCellR:Rectangle = gridDimensionsView.getCellBounds(lastRowIndex, lastColIndex);
				
				visibleItemRenderersBounds.x = startCellX;
				visibleItemRenderersBounds.y = startCellY; 
				visibleItemRenderersBounds.width = lastCellR.x + lastCellR.width - startCellX;
				visibleItemRenderersBounds.height = lastCellR.y + lastCellR.height - startCellY;
			}
			else
			{
				visibleItemRenderersBounds.setEmpty();
			}
			
			// Update visibleItemRenderers et al
			
			visibleItemRenderers = newVisibleItemRenderers;
			visibleRowIndices = newVisibleRowIndices;
			visibleColumnIndices = newVisibleColumnIndices;
		}
		
		/**
		 *  Reinitialize and layout the visible renderer at rowIndex, columnIndex.  If the cell's preferred 
		 *  height changes and the Grid has been configured with variableRowHeight=true, the entire grid is 
		 *  invalidated.
		 * 
		 *  <p>If row,columnIndex do not correspond to a visible cell, nothing is done.</p>
		 * 
		 *  @param rowIndex The 0-based row index of the cell that changed.
		 *  @param columnIndex The 0-based column index of the cell that changed.
		 */
		public function invalidateCell(rowIndex:int, columnIndex:int):void
		{
			const renderer:IGridItemRenderer = getVisibleItemRenderer(rowIndex, columnIndex);
			if (!renderer)
				return;
			
			// If the renderer at rowIndex,columnIndex is going to have to be replaced, because
			// this columns itemRendererFunction now returns a different (IFactory) value, punt.
			
			if (itemRendererFunctionValueChanged(renderer))
			{
				renderer.grid.invalidateDisplayList();
				return;
			}
			
			initializeItemRenderer(renderer, rowIndex, columnIndex);
			
			// We're using layoutBoundsX,Y,Width,Height instead of x,y,width,height because
			// the IUITextField item renderers pad their x,y,width,height properties 
			
			const rendererX:Number = renderer.getLayoutBoundsX();
			const rendererY:Number = renderer.getLayoutBoundsY();
			const rendererWidth:Number = renderer.getLayoutBoundsWidth();
			const rendererHeight:Number = renderer.getLayoutBoundsHeight();
			
			layoutItemRenderer(renderer, rendererX, rendererY, rendererWidth, rendererHeight);
			
			// If the renderer's preferredHeight has changed and variableRowHeight=true, then
			// the row's height may have changed, which implies we need to layout -everything-.
			// Warning: the unconditional getPreferredBoundsHeight() call also serves to 
			// force DefaultGridItemRenderer and UITextFieldGridItemRenderer to validate;
			// similar to what happens in layoutItemRenderers() and updateTypicalCellSizes()
			
			const preferredRendererHeight:Number = renderer.getPreferredBoundsHeight();
			if (gridDimensionsView.variableRowHeight && (rendererHeight != preferredRendererHeight))
				grid.invalidateDisplayList();
		}
		
		/**
		 *  @private
		 *  Return true if the specified item renderer was defined by an itemRendererFunction whose
		 *  value has changed.
		 */
		private function itemRendererFunctionValueChanged(renderer:IGridItemRenderer):Boolean
		{
			/*const column:GridColumn = renderer.column;
			if (!column || (column.itemRendererFunction === null))
				return false;
			
			const factory:IFactory = itemToRenderer(column, renderer.data);
			return factory !== elementToFactoryMap[renderer];*/
			return false;
		}
		
		/**
		 *  @private
		 */
		private function getVisibleItemRendererIndex(rowIndex:int, columnIndex:int):int
		{
			if ((visibleRowIndices == null) || (visibleColumnIndices == null))
				return -1;
			
			// TODO (hmuller) - binary search would be faster than indexOf()
			
			const rowOffset:int = visibleRowIndices.indexOf(rowIndex);
			const colOffset:int = visibleColumnIndices.indexOf(columnIndex);
			if ((rowOffset == -1) || (colOffset == -1))
				return -1;
			
			const index:int = (rowOffset * visibleColumnIndices.length) + colOffset;
			return index;
		}
		
		/**
		 *  Return the visible item renderer at the specified GridView row,columnIndex.
		 */
		public function getVisibleItemRenderer(rowIndex:int, columnIndex:int):IGridItemRenderer
		{
			const index:int = getVisibleItemRendererIndex(rowIndex, columnIndex);
			if (index == -1 || index >= visibleItemRenderers.length)
				return null;
			
			const renderer:IGridItemRenderer = visibleItemRenderers[index];
			return renderer;        
		}
		
		/**
		 *  @private
		 */
		private function takeVisibleItemRenderer(rowIndex:int, columnIndex:int):IGridItemRenderer
		{
			const index:int = getVisibleItemRendererIndex(rowIndex, columnIndex);
			if (index == -1 || index >= visibleItemRenderers.length)
				return null;
			
			const renderer:IGridItemRenderer = visibleItemRenderers[index];
			visibleItemRenderers[index] = null;
			
			// If the renderer at rowIndex,columnIndex is going to have to be replaced, because
			// this column's itemRendererFunction now returns a different (IFactory) value, then 
			// get rid of the old one and return null.
			
			if (renderer && itemRendererFunctionValueChanged(renderer))
			{
				freeItemRenderer(renderer);
				return null;
			}
			
			return renderer;
		}
		
		/**
		 *  @private
		 */
		private function initializeItemRenderer(
			renderer:IGridItemRenderer, 
			rowIndex:int, columnIndex:int,
			dataItem:Object=null,
			visible:Boolean=true):void
		{
			renderer.visible = visible;
			
			const gridColumn:GridColumn = getGridColumn(columnIndex);
			if (gridColumn)
			{
				renderer.rowIndex = rowIndex;
				// renderer.column = gridColumn;
				if (dataItem == null)
					dataItem = getDataProviderItem(rowIndex);
				
				renderer.label = gridColumn.itemToLabel(dataItem);
				
				// The following code must be kept in sync with updateVisibleItemRenderers()
				if (isRowSelectionMode())
				{
					renderer.selected = grid.selectionContainsIndex(rowIndex);
					renderer.showsCaret = grid.caretRowIndex == rowIndex;
					renderer.hovered = grid.hoverRowIndex == rowIndex;
				}
				else if (isCellSelectionMode())
				{
					renderer.selected = grid.selectionContainsCell(rowIndex, columnIndex);
					renderer.showsCaret = (grid.caretRowIndex == rowIndex) && (grid.caretColumnIndex == columnIndex);
					renderer.hovered = (grid.hoverRowIndex == rowIndex) && (grid.hoverColumnIndex == columnIndex);
				}
				
				renderer.data = dataItem;
				
				if (grid.dataGrid)
					renderer.owner = grid.dataGrid;
				
				renderer.prepare(!createdGridElement);             
			}
		}
		
		private function freeItemRenderer(renderer:IGridItemRenderer):void
		{
			if (!renderer)
				return;
			
			freeGridElement(renderer);
			renderer.discard(true);          
		}
		
		private function freeItemRenderers(renderers:Vector.<IGridItemRenderer>):void
		{
			for each (var renderer:IGridItemRenderer in renderers)
			freeItemRenderer(renderer);
			renderers.length = 0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Linear elements: row,column separators, backgrounds 
		//
		//-------------------------------------------------------------------------- 
		
		/**
		 *  @private
		 *  Common code for laying out the rowBackround, rowSeparator, columnSeparator visual elements.
		 * 
		 *  For row,columnSeparators, lastIndex identifies the element in the new layout for which 
		 *  no separator is drawn.  If the previous layout - oldVisibleIndices - included the lastIndex,
		 *  it needs to be freed, even though it exists in the new layout (newVisibleIndices).   See
		 *  freeLinearElements().
		 */
		private function layoutLinearElements(
			factory:IFactory,
			layer:GridLayer, 
			oldVisibleElements:Vector.<IVisualElement>,
			oldVisibleIndices:Vector.<int>,
			newVisibleIndices:Vector.<int>,
			layoutFunction:Function,
			lastIndex:int = -1):Vector.<IVisualElement>
		{
			if (!layer)
				return new Vector.<IVisualElement>(0);
			
			// If a factory changed, free the old visual elements and set oldVisibleElements.length=0
			
			discardGridElementsIfFactoryChanged(factory, layer, oldVisibleElements);
			
			if (factory == null)
				return new Vector.<IVisualElement>(0);
			
			// Free and clear oldVisibleElements that are no long visible
			
			freeLinearElements(oldVisibleElements, oldVisibleIndices, newVisibleIndices, lastIndex);
			
			// Create, layout, and return newVisibleElements
			
			const newVisibleElementCount:uint = newVisibleIndices.length;
			const newVisibleElements:Vector.<IVisualElement> = new Vector.<IVisualElement>(newVisibleElementCount);
			
			for (var index:int = 0; index < newVisibleElementCount; index++) 
			{
				var newEltIndex:int = newVisibleIndices[index];
				if (newEltIndex == lastIndex)
				{
					newVisibleElements.length = index;
					break;
				}
				
				// If an element already exists for visibleIndex then use it, otherwise create one
				
				var eltOffset:int = oldVisibleIndices.indexOf(newEltIndex);
				var elt:IVisualElement = (eltOffset != -1 && eltOffset < oldVisibleElements.length) ? oldVisibleElements[eltOffset] : null;
				if (elt == null)
					elt = allocateGridElement(factory);
				
				// Initialize the element, and then delegate to the layout function
				
				newVisibleElements[index] = elt;
				
				// layer.addElement(elt);
				
				elt.visible = true;
				
				layoutFunction(elt, newEltIndex);
			}
			
			return newVisibleElements;
		}
		
		private function layoutCellElements(
			factory:IFactory,
			layer:GridLayer,
			oldVisibleElements:Vector.<IVisualElement>,
			oldVisibleRowIndices:Vector.<int>, oldVisibleColumnIndices:Vector.<int>,
			newVisibleRowIndices:Vector.<int>, newVisibleColumnIndices:Vector.<int>,
			layoutFunction:Function):Vector.<IVisualElement>
		{
			if (!layer)
				return new Vector.<IVisualElement>(0);
			
			// If a factory changed, discard the old visual elements.
			
			if (discardGridElementsIfFactoryChanged(factory, layer, oldVisibleElements))
			{
				oldVisibleRowIndices.length = 0;
				oldVisibleColumnIndices.length = 0;
			}
			
			if (factory == null)
				return new Vector.<IVisualElement>(0);
			
			// Create, layout, and return newVisibleElements
			
			const newVisibleElementCount:uint = newVisibleRowIndices.length;
			const newVisibleElements:Vector.<IVisualElement> = new Vector.<IVisualElement>(newVisibleElementCount);
			
			// Free and clear oldVisibleElements that are no long visible.
			
			freeCellElements(oldVisibleElements, newVisibleElements,
				oldVisibleRowIndices, newVisibleRowIndices,
				oldVisibleColumnIndices, newVisibleColumnIndices);
			
			for (var index:int = 0; index < newVisibleElementCount; index++) 
			{
				var newEltRowIndex:int = newVisibleRowIndices[index];
				var newEltColumnIndex:int = newVisibleColumnIndices[index];
				
				// If an element already exists for visibleIndex then use it, 
				// otherwise create one.
				
				var elt:IVisualElement = newVisibleElements[index];
				if (elt === null)
				{
					// Initialize the element, and then delegate to the layout 
					// function.
					elt = allocateGridElement(factory);
					newVisibleElements[index] = elt;
				}
				
				// layer.addElement(elt);
				
				elt.visible = true;
				
				layoutFunction(elt, newEltRowIndex, newEltColumnIndex);
			}
			
			return newVisibleElements;
		}
		
		/** 
		 *  @private
		 *  If the factory has changed, or is now null, remove and free all the old
		 *  visual elements, if there were any.
		 * 
		 *  @returns True if at least one visual element was removed.
		 */
		private function discardGridElementsIfFactoryChanged(
			factory:IFactory,
			layer:GridLayer,
			oldVisibleElements:Vector.<IVisualElement>):Boolean    
		{
			/*if ((oldVisibleElements.length) > 0 && (factory != elementToFactoryMap[oldVisibleElements[0]]))
			{
				for each (var oldElt:IVisualElement in oldVisibleElements)
				{
					layer.removeElement(oldElt);
					freeGridElement(oldElt);
				}
				oldVisibleElements.length = 0;
				return true;
			}*/
			
			return false;
		}
		
		/** 
		 *  @private
		 *  Free each member of elements if the corresponding member of oldIndices doesn't 
		 *  appear in newIndices.  Both vectors of indices must have been sorted in increasing
		 *  order.  When an element is freed, the corresponding member of the vector parameter
		 *  is set to null.
		 * 
		 *  This method is [supposed to be a] somewhat more efficient implementation of the following:
		 * 
		 *  for (var i:int = 0; i < elements.length; i++)
		 *     {
		 *     if ((oldIndices[i] == lastIndex) || (newIndices.indexOf(oldIndices[i]) == -1))
		 *         freeGridElement(elements[i]);
		 *         elements[i] = null;
		 *     }
		 *  
		 *  The lastIndex parameter is used to handle row and column separators, where the last
		 *  element is left out since separators only appear in between elements.  If the lastIndex
		 *  appears in oldIndices, we're not going to need the old element.
		 */
		private function freeLinearElements (
			elements:Vector.<IVisualElement>, 
			oldIndices:Vector.<int>, 
			newIndices:Vector.<int>, 
			lastIndex:int):void
		{
			// TODO(hmuller): rewrite this, should be one pass (no indexOf)
			for (var i:int = 0; i < elements.length; i++)
			{
				const offset:int = newIndices.indexOf(oldIndices[i]);
				if ((oldIndices[i] == lastIndex) || (offset == -1))
				{
					const elt:IVisualElement = elements[i];
					if (elt)
					{
						freeGridElement(elt);
						elements[i] = null;
					}
				}
			}
		}      
		
		private function freeCellElements (
			elements:Vector.<IVisualElement>, newElements:Vector.<IVisualElement>, 
			oldRowIndices:Vector.<int>, newRowIndices:Vector.<int>,
			oldColumnIndices:Vector.<int>, newColumnIndices:Vector.<int>):void
		{
			var freeElement:Boolean = true;
			
			// assumes newRowIndices.length == newColumnIndices.length
			const numNewCells:int = newRowIndices.length;
			var newIndex:int = 0;
			
			for (var i:int = 0; i < elements.length; i++)
			{
				const elt:IVisualElement = elements[i];
				if (elt == null)
					continue;
				
				// assumes oldIndices.length == elements.length
				const oldRowIndex:int = oldRowIndices[i];
				const oldColumnIndex:int = oldColumnIndices[i];
				
				for ( ; newIndex < numNewCells; newIndex++)
				{
					const newRowIndex:int = newRowIndices[newIndex];
					const newColumnIndex:int = newColumnIndices[newIndex];
					
					if (newRowIndex == oldRowIndex)
					{
						if (newColumnIndex == oldColumnIndex)
						{
							// Same cell still selected so reuse the selection.
							// Save it in the correct place in newElements.  That 
							// way we know its location based on 
							// newRowIndices[newIndex], newColumnIndices[newIndex].
							newElements[newIndex] = elt;
							freeElement = false;
							break;
						}
						else if (newColumnIndex > oldColumnIndex)
						{
							// not found
							break;
						}
					}
					else if (newRowIndex > oldRowIndex)
					{
						// not found
						break;
					}
				}
				
				if (freeElement)
					freeGridElement(elt);
				
				freeElement = true;
			}
			
			elements.length = 0;
		}      
		
		private function layoutRowBackground(rowBackground:IVisualElement, rowIndex:int):void
		{
			const rowCount:int = gridDimensionsView.rowCount;
			const bounds:Rectangle = (rowIndex < rowCount) 
				? gridDimensionsView.getRowBounds(rowIndex)
				: gridDimensionsView.getPadRowBounds(rowIndex);
			
			if (!bounds)
				return;
			
			if  ((rowIndex < rowCount) && (bounds.width == 0)) // implies no columns
				bounds.width = visibleGridBounds.width;
			
			// Initialize this visual element
			intializeGridVisualElement(rowBackground, rowIndex);
			
			layoutGridElementR(rowBackground, bounds);
		}
		
		private function layoutRowSeparator(separator:IVisualElement, rowIndex:int):void
		{
			// Initialize this visual element
			intializeGridVisualElement(separator, rowIndex);
			
			const height:Number = separator.getPreferredBoundsHeight();
			const rowCount:int = gridDimensionsView.rowCount;
			const bounds:Rectangle = (rowIndex < rowCount) 
				? gridDimensionsView.getRowBounds(rowIndex)
				: gridDimensionsView.getPadRowBounds(rowIndex);
			
			if (!bounds)
				return;
			
			const x:Number = bounds.x;
			const width:Number =  Math.max(bounds.width, visibleGridBounds.right);
			const y:Number = bounds.bottom; // TODO (klin): should center on gap here.
			layoutGridElement(separator, x, y, width, height);
		}
		
		private function layoutColumnSeparator(separator:IVisualElement, columnIndex:int):void
		{
			// Initialize this visual element
			intializeGridVisualElement(separator, -1, columnIndex);
			
			const r:Rectangle = visibleItemRenderersBounds;
			const width:Number = separator.getPreferredBoundsWidth();
			const height:Number = Math.max(r.height, visibleGridBounds.height); 
			const x:Number = gridDimensionsView.getCellX(0, columnIndex) + gridDimensionsView.getColumnWidth(columnIndex); // TODO (klin): should center on gap here.
			const y:Number = r.y;
			layoutGridElement(separator, x, y, width, height);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Selection Indicators
		//
		//--------------------------------------------------------------------------
		
		private var visibleSelectionIndicators:Vector.<IVisualElement> = new Vector.<IVisualElement>(0);
		private var visibleRowSelectionIndices:Vector.<int> = new Vector.<int>(0);    
		private var visibleColumnSelectionIndices:Vector.<int> = new Vector.<int>(0);
		
		private function isRowSelectionMode():Boolean
		{
			const mode:String = grid.selectionMode;
			return (mode == GridSelectionMode.SINGLE_ROW) || (mode == GridSelectionMode.MULTIPLE_ROWS);
		}
		
		private function isCellSelectionMode():Boolean
		{
			const mode:String = grid.selectionMode;        
			return mode == (GridSelectionMode.SINGLE_CELL) || (mode == GridSelectionMode.MULTIPLE_CELLS);
		}     
		
		private function layoutSelectionIndicators(layer:GridLayer):void
		{
			const selectionIndicatorFactory:IFactory = grid.selectionIndicator;
			const viewRowIndex:int = viewRowIndex;
			const viewColumnIndex:int = viewColumnIndex;
			
			// layout and update visibleSelectionIndicators,Indices
			
			if (isRowSelectionMode())
			{
				// Selection is row-based so if there are existing cell selections, 
				// free them since they can't be reused.
				if (visibleColumnSelectionIndices.length > 0)
					clearSelectionIndicators();
				
				var oldVisibleRowSelectionIndices:Vector.<int> = visibleRowSelectionIndices;
				
				// Load this up with the currently selected rows.
				visibleRowSelectionIndices = new Vector.<int>();
				
				for each (var rowIndex:int in visibleRowIndices)
				{
					if (grid.selectionContainsIndex(rowIndex + viewRowIndex))
					{
						visibleRowSelectionIndices.push(rowIndex);
					}
				}
				
				// Display the row selections.
				visibleSelectionIndicators = layoutLinearElements(
					selectionIndicatorFactory,
					layer,
					visibleSelectionIndicators, 
					oldVisibleRowSelectionIndices, 
					visibleRowSelectionIndices, 
					layoutRowSelectionIndicator);
				
				return;
			}
			
			// Selection is not row-based so if there are existing row selections, 
			// free them since they can't be reused.
			if (visibleRowSelectionIndices.length > 0 && visibleColumnSelectionIndices.length == 0)
			{
				clearSelectionIndicators();
			}
			
			if (isCellSelectionMode())
			{
				oldVisibleRowSelectionIndices = visibleRowSelectionIndices;
				const oldVisibleColumnSelectionIndices:Vector.<int> = visibleColumnSelectionIndices;
				
				// Load up the vectors with the row/column of each selected cell.
				visibleRowSelectionIndices = new Vector.<int>();
				visibleColumnSelectionIndices = new Vector.<int>();
				for each (rowIndex in visibleRowIndices)
				{
					for each (var columnIndex:int in visibleColumnIndices)
					{
						if (grid.selectionContainsCell(rowIndex + viewRowIndex, columnIndex + viewColumnIndex))
						{
							visibleRowSelectionIndices.push(rowIndex);
							visibleColumnSelectionIndices.push(columnIndex);
						}
					}
				} 
				
				// Display the cell selections.
				visibleSelectionIndicators = layoutCellElements(
					selectionIndicatorFactory,
					layer,
					visibleSelectionIndicators, 
					oldVisibleRowSelectionIndices, oldVisibleColumnSelectionIndices,
					visibleRowSelectionIndices, visibleColumnSelectionIndices,
					layoutCellSelectionIndicator);
				
				return;
			}
			
			// No selection.
			
			// If there are existing cell selections, 
			// free them since there is no selection.
			if (visibleColumnSelectionIndices.length > 0)
				clearSelectionIndicators();
		}
		
		private function layoutRowSelectionIndicator(indicator:IVisualElement, rowIndex:int):void
		{
			// Initialize this visual element
			intializeGridVisualElement(indicator, rowIndex);
			layoutGridElementR(indicator, gridDimensionsView.getRowBounds(rowIndex));
		}    
		
		private function layoutCellSelectionIndicator(indicator:IVisualElement, 
													  rowIndex:int,
													  columnIndex:int):void
		{
			// Initialize this visual element
			intializeGridVisualElement(indicator, rowIndex, columnIndex);
			layoutGridElementR(indicator, gridDimensionsView.getCellBounds(rowIndex, columnIndex));
		}    
		
		private function clearSelectionIndicators():void
		{
			freeGridElements(visibleSelectionIndicators);
			visibleRowSelectionIndices.length = 0;
			visibleColumnSelectionIndices.length = 0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Indicators: hover, caret
		//
		//--------------------------------------------------------------------------
		
		private function layoutIndicator(
			layer:GridLayer,
			indicatorFactory:IFactory,
			indicator:IVisualElement, 
			rowIndex:int,
			columnIndex:int):IVisualElement
		{/*
			if (!layer)
				return null;
			
			// If the indicatorFactory has changed for the specified non-null indicator, 
			// then free the old indicator.
			
			if (indicator && (indicatorFactory != elementToFactoryMap[indicator]))
			{
				removeGridElement(indicator);
				indicator = null;
				if (indicatorFactory == null)
					return null;
			}
			
			if (rowIndex == -1 || grid.selectionMode == GridSelectionMode.NONE ||
				(isCellSelectionMode() && (getNextVisibleColumnIndex(columnIndex - 1) != columnIndex)))
			{
				if (indicator)
					indicator.visible = false;
				return indicator;
			}
			
			if (!indicator && indicatorFactory)
				indicator = createGridElement(indicatorFactory);
			
			if (indicator)
			{
				const bounds:Rectangle = isRowSelectionMode() ? 
					gridDimensionsView.getRowBounds(rowIndex) :
					gridDimensionsView.getCellBounds(rowIndex, columnIndex);
				
				intializeGridVisualElement(indicator, rowIndex, columnIndex);
				
				// TODO (klin): Remove this special case for the caret overlapping separators
				// when we implement column/row gaps.
				if (indicatorFactory == grid.caretIndicator && bounds)
				{
					// increase width and height by 1 to cover separator.
					const columnsLength:int = getColumnsLength();                
					if (isCellSelectionMode() && (columnIndex < columnsLength - 1))
						bounds.width += 1;
					
					//if ((rowIndex < grid.dataProvider.length - 1) || (visibleRowIndices.length > grid.dataProvider.length))
					//    bounds.height += 1;
					const dataProviderLength:int = getDataProviderLength();
					if ((rowIndex < dataProviderLength) || (visibleRowIndices.length > dataProviderLength))
						bounds.height += 1;                
				}
				
				layoutGridElementR(indicator, bounds);
				layer.addElement(indicator);
				indicator.visible = true;
			}*/
			
			return indicator;
		}
		
		private function layoutHoverIndicator(layer:GridLayer):void
		{
			const rowIndex:int = gridRowIndexToViewIndex(grid.hoverRowIndex);
			const columnIndex:int = gridColumnIndexToViewIndex(grid.hoverColumnIndex);
			const factory:IFactory = grid.hoverIndicator;
			hoverIndicator = layoutIndicator(layer, factory, hoverIndicator, rowIndex, columnIndex); 
		}
		
		private function layoutCaretIndicator(layer:GridLayer):void
		{
			const rowIndex:int = gridRowIndexToViewIndex(grid.caretRowIndex);
			const columnIndex:int = gridColumnIndexToViewIndex(grid.caretColumnIndex);
			const factory:IFactory = grid.caretIndicator; 
			caretIndicator = layoutIndicator(layer, factory, caretIndicator, rowIndex, columnIndex);  
			
			// Hide caret based on the showCaret property. Don't show caret if its 
			// already hidden by layoutIndicator() because it has an invalid position.
			
			if (caretIndicator && !grid.showCaret)
				caretIndicator.visible = grid.showCaret;
		}
		
		private function layoutEditorIndicator(layer:GridLayer):void
		{
			/*const dataGrid:DataGrid = grid.dataGrid;
			if (!dataGrid)
				return;
			
			const rowIndex:int = gridRowIndexToViewIndex(dataGrid.editorRowIndex);
			const columnIndex:int = gridColumnIndexToViewIndex(dataGrid.editorColumnIndex);
			var indicatorFactory:IFactory = dataGrid.editorIndicator;
			
			// If the indicatorFactory has changed for the specified non-null indicator, 
			// then free the old indicator.
			
			if (editorIndicator && (indicatorFactory != elementToFactoryMap[editorIndicator]))
			{
				removeGridElement(editorIndicator);
				editorIndicator = null;
				if (indicatorFactory == null)
					return;
			}
			
			if (rowIndex == -1 || columnIndex == -1)
			{
				if (editorIndicator)
					editorIndicator.visible = false;
				return;
			}
			
			if (!editorIndicator && indicatorFactory)
				editorIndicator = createGridElement(indicatorFactory);
			
			if (editorIndicator)
			{
				const bounds:Rectangle = gridDimensionsView.getCellBounds(rowIndex, columnIndex);
				
				// Initialize this visual element
				intializeGridVisualElement(editorIndicator, rowIndex, columnIndex);
				
				layoutGridElementR(editorIndicator, bounds);
				layer.addElement(editorIndicator);
				editorIndicator.visible = true;
			}*/
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  CollectionEvent handling: dataProvider, columns
		//
		//--------------------------------------------------------------------------     
		
		public function dataProviderCollectionChanged(event:CollectionEvent):void
		{
			switch (event.kind)
			{
				case CollectionEventKind.ADD:
				{
					dataProviderCollectionAdd(event);
					break;
				}
					
				case CollectionEventKind.REMOVE: 
				{
					dataProviderCollectionRemove(event);
					break;
				}
					
				case CollectionEventKind.MOVE:
				{
					// TBD(hmuller)
					break;
				}
					
				case CollectionEventKind.REFRESH:
				case CollectionEventKind.RESET:
				{
					dataProviderCollectionReset(event);
					break;
				}
					
				case CollectionEventKind.UPDATE:
				{
					dataProviderCollectionUpdate(event);
					break;
				}
					
				case CollectionEventKind.REPLACE:
				{
					break;
				}
			}
		}
		
		/**
		 *  @private
		 *  Called in response to one or more items having been inserted into the 
		 *  grid's dataProvider.  Ensure that visibleRowIndices and visibleRowSelectionIndices 
		 *  correspond to the same, potentially shifted, dataProvider items.
		 */
		private function dataProviderCollectionAdd(event:CollectionEvent):void
		{
			const insertIndex:int = event.location - viewRowIndex;
			const insertLength:int = event.items.length;
			incrementIndicesGTE(visibleRowIndices, insertIndex, insertLength);
			incrementIndicesGTE(visibleRowSelectionIndices, insertIndex, insertLength);
		}
		
		/**
		 *  @private
		 *  Called in response to one or more items having been removed from the 
		 *  grid's dataProvider.  
		 */
		private function dataProviderCollectionRemove(event:CollectionEvent):void
		{
			const eventItemsLength:uint = event.items.length;
			const firstRemoveIndex:int = event.location - viewRowIndex;
			const lastRemoveIndex:int = firstRemoveIndex + eventItemsLength - 1;
			
			// Compute the range of visibleRowIndices elements affected by the remove event.
			// And while we're at it, decrement the visibleRowIndices "to the right of" the  
			// deleted items.
			
			var firstVisibleOffset:int = -1; // remove visibleRowIndices[firstVisibleOffset] 
			var lastVisibleOffset:int = -1;  // ... through visibleRowIndices[lastVisibleOffset]
			
			for (var offset:int = 0; offset < visibleRowIndices.length; offset++)
			{
				var rowIndex:int = visibleRowIndices[offset];
				if ((rowIndex >= firstRemoveIndex) && (rowIndex <= lastRemoveIndex))
				{
					if (firstVisibleOffset == -1)
						firstVisibleOffset = lastVisibleOffset = offset;
					else
						lastVisibleOffset = offset;
				}
				else if (rowIndex > lastRemoveIndex)
				{
					visibleRowIndices[offset] = rowIndex - eventItemsLength;
				}
			}
			
			// Remove the elements of visibleRowBackgrounds, visibleRowSeparators, visibleRowIndices,  
			// and visibleItemRenderers in the range firstVisibleOffset, lastVisibleOffset.
			
			if ((firstVisibleOffset != -1) && (lastVisibleOffset != -1))
			{
				const removeCount:int = (lastVisibleOffset - firstVisibleOffset) + 1; 
				visibleRowIndices.splice(firstVisibleOffset, removeCount);
				
				if (lastVisibleOffset < visibleRowBackgrounds.length)
					freeGridElements(visibleRowBackgrounds.splice(firstVisibleOffset, removeCount));
				
				if (lastVisibleOffset < visibleRowSeparators.length)
					freeGridElements(visibleRowSeparators.splice(firstVisibleOffset, removeCount));
				
				const visibleColCount:int = visibleColumnIndices.length;
				const firstRendererOffset:int = firstVisibleOffset * visibleColCount;
				freeItemRenderers(visibleItemRenderers.splice(firstRendererOffset, removeCount * visibleColCount));
			}
		}    
		
		/**
		 *  @private
		 *  Increment the elements of indices that are >= insertIndex by delta.
		 */
		private function incrementIndicesGTE(indices:Vector.<int>, insertIndex:int, delta:int):void
		{
			const indicesLength:int = indices.length;
			for (var i:int = 0; i < indicesLength; i++)
			{
				var index:int = indices[i];
				if (index >= insertIndex)
				{
					indices[i] = index + delta;
				}
			}
		}
		
		/**
		 *  @private
		 *  Called in response to a refresh/reset CollectionEvent.  Clear everything.
		 */
		private function dataProviderCollectionReset(event:CollectionEvent):void
		{
			clearVirtualLayoutCache();
		}
		
		/**
		 *  @private
		 *  Called in response to an item being updated in the dataProvider. Checks
		 *  to see if the item is visible and invalidates the grid if it is. Otherwise, 
		 *  do nothing.
		 */
		private function dataProviderCollectionUpdate(event:CollectionEvent):void
		{
			var data:Object;
			const itemsLength:int = event.items.length;
			const itemRenderersLength:int = visibleItemRenderers.length;
			
			for (var i:int = 0; i < itemsLength; i++)
			{
				data = PropertyChangeEvent(event.items[i]).source;
				
				for (var j:int = 0; j < itemRenderersLength; j++)
				{
					var renderer:IGridItemRenderer = visibleItemRenderers[j] as IGridItemRenderer;
					if (renderer && renderer.data == data)
					{
						this.freeItemRenderer(renderer);
						visibleItemRenderers[j] = null;
					}
				}
			}
		}
		
		/**
		 * @private
		 * This handler runs AFTER the GridDimension object has been updated.
		 */
		public function columnsCollectionChanged(event:CollectionEvent):void
		{
			switch (event.kind)
			{
				case CollectionEventKind.UPDATE:
				{
					clearVirtualLayoutCache();
					break;
				}
					
				default:
				{
					clearVirtualLayoutCache();
					if (grid)
						grid.setContentSize(0, 0);
					break;
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Grid Elements
		//
		//-------------------------------------------------------------------------- 
		
		/**
		 *  @private
		 *  Let the allocateGridElement() caller know if the returned element was 
		 *  created or recycled.
		 */
		private var createdGridElement:Boolean = false;
		
		private function createGridElement(factory:IFactory):IVisualElement
		{
			createdGridElement = true;
			const element:IVisualElement = factory.newInstance() as IVisualElement;
			// elementToFactoryMap[element] = factory;
			return element;
		}
		
		/** 
		 *  @private
		 *  Return an element the factory-specific free-list, or create a new element,
		 *  with createGridElement, if a free element isn't available.
		 */
		private function allocateGridElement(factory:IFactory):IVisualElement
		{
			createdGridElement = false;
			/*const elements:Vector.<IVisualElement> = freeElementMap[factory] as Vector.<IVisualElement>;
			if (elements)
			{
				const element:IVisualElement = elements.pop();
				if (elements.length == 0)
					delete freeElementMap[factory];
				if (element)
					return element;
			}*/
			
			return createGridElement(factory);
		}
		
		/**
		 *  @private
		 *  Move the specified element to the free list after hiding it.  Return true if the 
		 *  element was added to the free list (freeElements).   Note that we do not remove
		 *  the element from its parent.
		 */
		private function freeGridElement(element:IVisualElement):Boolean
		{
			/*if (!element)
				return false;
			
			element.visible = false;
			
			const factory:IFactory = elementToFactoryMap[element]; 
			if (!factory)
				return false;
			
			// Add the renderer to the freeElementMap
			
			var freeElements:Vector.<IVisualElement> = freeElementMap[factory];
			if (!freeElements)
			{
				freeElements = new Vector.<IVisualElement>();
				freeElementMap[factory] = freeElements;            
			}
			freeElements.push(element);*/
			
			return true;
		}
		
		private function freeGridElements(elements:Vector.<IVisualElement>):void
		{
			for each (var elt:IVisualElement in elements)
			freeGridElement(elt);
			elements.length = 0;
		}
		
		/** 
		 *  @private
		 *  Remove the element from the elementToFactory map and from the per-factory free list and, finally,
		 *  from its container.   On the off chance that someone is monitoring the visible property,
		 *  we set that to false, just for good measure.
		 */
		private function removeGridElement(element:IVisualElement):void
		{
			/*const factory:IFactory = elementToFactoryMap[element];
			const freeElements:Vector.<IVisualElement> = (factory) ? freeElementMap[factory] : null;
			if (freeElements)
			{
				const index:int = freeElements.indexOf(element);
				if (index != -1)
					freeElements.splice(index, 1);
				if (freeElements.length == 0)
					delete freeElementMap[factory];  
			}
			
			delete elementToFactoryMap[element];
			
			element.visible = false;
			const parent:IVisualElementContainer = element.parent as IVisualElementContainer;
			if (parent)
				parent.removeElement(element);*/
		}
		
		/**
		 *  @private
		 */ 
		private function layoutItemRenderer(renderer:IGridItemRenderer, x:Number, y:Number, width:Number, height:Number):void
		{
			if (!isNaN(width) || !isNaN(height))
			{
				if (renderer is ILayoutManagerClient) 
				{
					const validateClientRenderer:ILayoutManagerClient = renderer as ILayoutManagerClient;                
					// LayoutManager.getInstance().validateClient(validateClientRenderer, true); // true => skip validateDisplayList()
				}
				else if (renderer is IGraphicElement)
				{
					const graphicElementRenderer:IGraphicElement = renderer as IGraphicElement;                
					graphicElementRenderer.validateProperties();
					graphicElementRenderer.validateSize();
				}
				
				renderer.setLayoutBoundsSize(width, height);            
			}
			
			if ((renderer is IInvalidating) && !(renderer is IGraphicElement))
			{
				const validateNowRenderer:IInvalidating = renderer as IInvalidating;
				validateNowRenderer.validateNow();            
			}
			
			renderer.setLayoutBoundsPosition(x, y);
		}
		
		private function layoutGridElementR(elt:IVisualElement, bounds:Rectangle):void
		{
			if (bounds)
				layoutGridElement(elt, bounds.x, bounds.y, bounds.width, bounds.height);
		}
		
		private static const MAX_ELEMENT_SIZE:Number = 8192;
		private static const ELEMENT_EDGE_PAD:Number = 512;
		
		
		/**
		 *  @private
		 *  Set the visual element's layoutBounds size and position.
		 *  
		 *  Attempting to render graphics whose size is larger than MAX_ELEMENT_SIZE can cause the 
		 *  Flash Player to fail.  We reduce the size of visual elements here and preserve
		 *  the visibility of edges.   For example if the element's left edge is not showing,
		 *  then we ensure that it's no more than ELEMENT_EDGE_PAD to the left of the left edge of
		 *  the scrollRect (that's the horizontalScrollPosition).   The unfortunate assumption here
		 *  is that shrinking the size of a visual element in this way will not affect the appearance
		 *  of the part of the element that overlaps the scrollRect.
		 */
		private function layoutGridElement(elt:IVisualElement, x:Number, y:Number, width:Number, height:Number):void
		{   
			if (width > MAX_ELEMENT_SIZE)
			{
				const scrollX:Number = Math.max(0, horizontalScrollPosition);
				const gridWidth:Number = target.getLayoutBoundsWidth();
				
				const newX:Number = Math.max(x, scrollX - ELEMENT_EDGE_PAD);
				const newRight:Number = Math.min(x + width, scrollX + gridWidth + ELEMENT_EDGE_PAD);
				
				x = newX;
				width = newRight - newX;
			}
			
			if (height > MAX_ELEMENT_SIZE)
			{
				const scrollY:Number = Math.max(0, verticalScrollPosition);
				const gridHeight:Number = target.getLayoutBoundsHeight();
				
				const newY:Number = Math.max(y, scrollY - ELEMENT_EDGE_PAD);
				const newBottom:Number = Math.min(y + height, scrollY + gridHeight + ELEMENT_EDGE_PAD);
				
				y = newY;
				height = newBottom - newY;
			}
			
			elt.setLayoutBoundsSize(width, height);
			elt.setLayoutBoundsPosition(x, y);
		}
		
		/**
		 *  @private
		 *  Calls <code>prepareGridVisualElement()</code> on the element if it is an
		 *  IGridVisualElement.
		 */
		private function intializeGridVisualElement(elt:IVisualElement, rowIndex:int = -1, columnIndex:int = -1):void
		{
			const gridVisualElement:IGridVisualElement = elt as IGridVisualElement;
			if (gridVisualElement)
			{
				gridVisualElement.prepareGridVisualElement(grid, rowIndex, columnIndex);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public API Exported for Grid Cover Methods
		//
		//  The methods in this section return indices and coordinates relative to 
		//  the Grid, not this layout's target GridView.  Incoming parameters are 
		//  similarly Grid-relative.
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Returns the Grid-relative bounds of the visible part of the target GridView.
		 */
		public function getVisibleBounds():Rectangle
		{
			const x:Number = gridDimensionsView.viewOriginX + target.horizontalScrollPosition;
			const y:Number = gridDimensionsView.viewOriginY + target.verticalScrollPosition;
			return new Rectangle(x, y, target.width, target.height);
		}
		
		/**
		 *  @copy spark.components.Grid#getVisibleRowIndices()
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */ 
		public function getVisibleRowIndices():Vector.<int>
		{
			const indexOffset:int = viewRowIndex;
			const indices:Vector.<int> = visibleRowIndices.concat();
			for (var i:int = 0; i < indices.length; i++)
				indices[i] += indexOffset;
			return indices;
		}
		
		/**
		 *  @copy spark.components.Grid#getVisibleColumnIndices()
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */ 
		public function getVisibleColumnIndices():Vector.<int>
		{
			const indexOffset:int = viewColumnIndex;
			const indices:Vector.<int> = visibleColumnIndices.concat();
			for (var i:int = 0; i < indices.length; i++)
				indices[i] += indexOffset;
			return indices;        
		}
		
		/**
		 *  Return the Grid-relative index of the first fully visible row: if the first rowIndex 
		 *  element of visibleRowIndices hasn't been completely scrolled into view, then return 
		 *  the second element.
		 * 
		 *  If no rows are visible, return -1.  If only one row is visible, return its index.
		 */
		public function getFirstFullyVisibleRowIndex():int
		{
			const visibleRowIndicesLength:int = visibleRowIndices.length;
			if (visibleRowIndicesLength == 0)
				return -1;
			
			// If the first visible row's Y origin is "above" ther current verticalScrollPosition,
			// and there is a second visible row, then use the second one.
			
			const rowIndex:int = visibleRowIndices[0];
			const rowY:Number = gridDimensionsView.getCellY(rowIndex, -1);
			const useSecondVisibleRow:Boolean = (rowY < verticalScrollPosition) && (visibleRowIndicesLength > 1);
			return viewRowIndex + (useSecondVisibleRow ? visibleRowIndices[1] : rowIndex);
		}
		
		/**
		 *  Return the Grid-relative index of the last fully visible row: if the last rowIndex 
		 *  element of visibleRowIndices hasn't been completely scrolled into view, then return the 
		 *  second to last element.
		 * 
		 *  If no rows are visible, return -1.  If only one row is visible, return its index.
		 */
		public function getLastFullyVisibleRowIndex():int
		{
			const visibleRowIndicesLength:int = visibleRowIndices.length;
			if (visibleRowIndicesLength == 0)
				return -1;
			
			const rowIndex:int = visibleRowIndices[visibleRowIndicesLength - 1];
			const rowY:Number = gridDimensionsView.getCellY(rowIndex, -1) + gridDimensionsView.getRowHeight(rowIndex);
			const scrollY:Number = verticalScrollPosition + target.getLayoutBoundsHeight();
			const useSecondVisibleRow:Boolean = (rowY > scrollY) && (visibleRowIndicesLength > 1);
			return viewRowIndex + (useSecondVisibleRow ? visibleRowIndices[visibleRowIndicesLength - 2] : rowIndex);        
		}
		
		/**
		 *  @copy spark.components.Grid#getItemRendererAt()
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */
		public function getItemRendererAt(rowIndex:int, columnIndex:int):IGridItemRenderer
		{
			rowIndex = gridRowIndexToViewIndex(rowIndex);
			columnIndex = gridColumnIndexToViewIndex(columnIndex);
			
			const visibleItemRenderer:IGridItemRenderer = getVisibleItemRenderer(rowIndex, columnIndex);
			if (visibleItemRenderer)
				return visibleItemRenderer;
			
			const rendererLayer:GridLayer = getLayer("rendererLayer");
			if (!rendererLayer)
				return null;
			
			// Create an item renderer.
			var dataItem:Object = getDataProviderItem(rowIndex);
			var column:GridColumn = getGridColumn(columnIndex);
			
			// Invalid row or column.
			if (dataItem == null || column == null)
				return null;
			
			// column is GridColumn.visible==false
			if (!column.visible)
				return null;
			
			const factory:IFactory = itemToRenderer(column, dataItem);
			const renderer:IGridItemRenderer = factory.newInstance() as IGridItemRenderer;
			createdGridElement = true;  // initializeItemRenderer() depends on this
			
			// rendererLayer.addElement(renderer);
			
			initializeItemRenderer(renderer, rowIndex, columnIndex, dataItem, false);
			
			// The width/height may change later if the cell becomes visible.
			var bounds:Rectangle = gridDimensionsView.getCellBounds(rowIndex, columnIndex);
			if (bounds == null)
				return null;
			layoutItemRenderer(renderer, bounds.x, bounds.y, bounds.width, bounds.height);
			
			// rendererLayer.removeElement(renderer);
			renderer.visible = false;
			
			return renderer;
		}
		
		/**
		 *  @copy spark.components.Grid#isCellVisible()
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 2.0
		 *  @productversion Flex 4.5
		 */ 
		public function isCellVisible(rowIndex:int, columnIndex:int):Boolean
		{
			if (rowIndex == -1 && columnIndex == -1)
				return false;
			
			rowIndex = gridRowIndexToViewIndex(rowIndex);
			columnIndex = gridColumnIndexToViewIndex(columnIndex);
			
			return ((rowIndex == -1) || (visibleRowIndices.indexOf(rowIndex) != -1)) && 
				((columnIndex == -1) || (visibleColumnIndices.indexOf(columnIndex) != -1));
		}
	}
}

// import flash.utils.getQualifiedClassName;

import mx.core.ClassFactory;
import mx.core.IFactory;
import mx.core.IFlexModuleFactory;

import spark.components.Grid;

/**
 *  @private
 *  A wrapper class for item renderers that creates the renderer instance with the grid's
 *  module factory.  
 * 
 *  This is necessary for applications that use embedded fonts.   The module factory creates
 *  the renderer instance in the correct "font context" in the same way as ContextualClassFactory
 *  does.   More about this in the  ContextualClassFactory  ASDoc.
 */
class GridItemRendererClassFactory extends ClassFactory
{
	public var grid:Grid;
	public var factory:ClassFactory;
	
	public function GridItemRendererClassFactory(grid:Grid, factory:ClassFactory)
	{
		super(factory.generator);
		this.grid = grid;
		this.factory = factory;
	}
	
	/*override public function newInstance():*
	{
		const factoryGenerator:Class = factory.generator;
		const moduleFactory:IFlexModuleFactory = grid.moduleFactory;
		const instance:Object = 
			(moduleFactory) ? moduleFactory.create(getQualifiedClassName(factoryGenerator)) : new factoryGenerator();
		
		const factoryProperties:Object = factory.properties;
		if (factoryProperties)
		{
			for (var p:String in factoryProperties)
				instance[p] = factoryProperties[p];
		}
		
		return instance;
	}*/
}
