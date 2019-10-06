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
	// import flash.geom.Rectangle;
	import org.apache.royale.geom.Rectangle;
	
	[ExcludeClass]
	
	/**
	 *  A "view" of a rectangular region within a GridDimensions object.   The origin of the region
	 *  is specified by viewRowIndex,viewColumnIndex and the size of the region by viewRowCount and
	 *  viewColumnCount.
	 * 
	 *  Unless otherwise specified, all of the methods defined here have GridDimensionsView-relative 
	 *  parameters and similarly return values relative to the GridView's viewRow,ColumnIndex origin.
	 *  
	 *  All of the methods and properties defined here just delegate to GridDimensions 
	 *  methods with the same names and semantics.
	 * 
	 *  This class is internal to the Grid implementation.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 11
	 *  @playerversion AIR 3
	 *  @productversion Flex 5.0
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public class GridDimensionsView
	{
		public var gridDimensions:GridDimensions = null;
		public var viewRowIndex:int = 0;
		public var viewColumnIndex:int = 0;
		public var viewRowCount:int = -1;
		public var viewColumnCount:int = -1;
		
		public function GridDimensionsView(gridDimensions:GridDimensions = null, 
										   viewRowIndex:int = 0, viewColumnIndex:int = 0, viewRowCount:int = -1, viewColumnCount:int = -1)
		{
			super();
			this.gridDimensions = gridDimensions;
			this.viewRowIndex = viewRowIndex;
			this.viewColumnIndex = viewColumnIndex;
			this.viewRowCount = viewRowCount;
			this.viewColumnCount = viewColumnCount;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------	
		
		public function get rowCount():int
		{
			const nRows:int = gridDimensions.rowCount;
			return (viewRowCount == -1) ? nRows - viewRowIndex : viewRowCount;
		}
		
		public function get columnCount():int
		{
			const nColumns:int = gridDimensions.columnCount;
			return (viewColumnCount == -1) ? nColumns - viewColumnIndex : viewColumnCount;
		}
		
		public function get rowGap():Number
		{
			return gridDimensions.rowGap;
		}
		
		public function get columnGap():Number
		{
			return gridDimensions.columnGap;
		} 
		
		public function get defaultRowHeight():Number
		{
			return gridDimensions.defaultRowHeight;
		}
		
		public function get defaultColumnWidth():Number
		{
			return gridDimensions.defaultColumnWidth;
		}
		
		public function get variableRowHeight():Boolean
		{
			return gridDimensions.variableRowHeight;
		}
		
		public function get minRowHeight():Number
		{
			return gridDimensions.minRowHeight;
		}
		
		public function get maxRowHeight():Number
		{
			return gridDimensions.maxRowHeight;
		} 
		
		/** 
		 *  Return the Grid X coordinate of the GridDimensionView's viewRow,ColumnIndex origin.
		 */
		public function get viewOriginX():Number
		{
			return gridDimensions.getCellX(viewRowIndex, viewColumnIndex);       
		}
		
		/** 
		 *  Return the Grid Y coordinate of the GridDimensionView's viewRow,ColumnIndex origin.
		 */    
		public function get viewOriginY():Number
		{
			return gridDimensions.getCellY(viewRowIndex, viewColumnIndex);         
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function getRowHeight(row:int):Number
		{
			return gridDimensions.getRowHeight(row + viewRowIndex);
		}
		
		public function setRowHeight(row:int, height:Number):void
		{
			gridDimensions.setRowHeight(row + viewRowIndex, height);
		}
		
		public function getColumnWidth(col:int):Number
		{    
			return gridDimensions.getColumnWidth(col + viewColumnIndex);
		}
		
		public function setColumnWidth(col:int, width:Number):void
		{
			gridDimensions.setColumnWidth(col + viewColumnIndex, width);
		}
		
		public function getCellHeight(row:int, col:int):Number
		{
			return gridDimensions.getCellHeight(row + viewRowIndex, col + viewColumnIndex);
		}
		
		public function setCellHeight(row:int, col:int, height:Number):void
		{
			gridDimensions.setCellHeight(row + viewRowIndex, col + viewColumnIndex, height);
		}
		
		public function getCellBounds(row:int, col:int):Rectangle
		{
			const bounds:Rectangle = gridDimensions.getCellBounds(row + viewRowIndex, col + viewColumnIndex);
			if (!bounds)
				return null;
			
			bounds.x -= viewOriginX;
			bounds.y -= viewOriginY;
			return bounds;
		}
		
		public function getCellX(row:int, col:int):Number
		{
			return gridDimensions.getCellX(row + viewRowIndex, col + viewColumnIndex) - viewOriginX;
		}
		
		public function getCellY(row:int, col:int):Number
		{
			return gridDimensions.getCellY(row + viewRowIndex, col + viewColumnIndex) - viewOriginY;
		}
		
		public function getRowBounds(row:int):Rectangle
		{
			const bounds:Rectangle = gridDimensions.getRowBounds(row + viewRowIndex);
			if (!bounds)
				return null;
			
			bounds.x -= viewOriginX;
			bounds.y -= viewOriginY;
			return bounds;
		}
		
		public function getPadRowBounds(row:int):Rectangle
		{
			const bounds:Rectangle = gridDimensions.getPadRowBounds(row + viewRowIndex);
			if (!bounds)
				return null;
			
			bounds.x -= viewOriginX;
			bounds.y -= viewOriginY;
			return bounds;
		}
		
		public function getColumnBounds(col:int):Rectangle
		{
			const bounds:Rectangle = gridDimensions.getColumnBounds(col + viewColumnIndex);
			if (!bounds)
				return null;
			
			bounds.x -= viewOriginX;
			bounds.y -= viewOriginY;
			return bounds;
		}
		
		public function getRowIndexAt(viewX:Number, viewY:Number):int
		{
			const rowIndex:int = gridDimensions.getRowIndexAt(viewX + viewOriginX, viewY + viewOriginY) - viewRowIndex;
			return rowIndex >= 0 ? rowIndex : -1;
		}
		
		public function getColumnIndexAt(localX:Number, localY:Number):int
		{
			const columnIndex:int = gridDimensions.getColumnIndexAt(localX + viewOriginX, localY + viewOriginY) - viewColumnIndex;
			return columnIndex >= 0 ? columnIndex : -1;
		}
		
		public function getContentWidth(columnCountOverride:int = -1, startColumnIndex:int = 0):Number
		{
			const nColumns:int = (columnCount== -1) ? viewColumnCount : columnCountOverride;        
			return gridDimensions.getContentWidth(nColumns, viewColumnIndex + startColumnIndex);
		}
		
		public function getContentHeight(rowCountOverride:int = -1, startRowIndex:int = 0):Number
		{
			const nRows:int = (rowCount== -1) ? viewRowCount : rowCountOverride;
			return gridDimensions.getContentHeight(nRows, viewRowIndex + startRowIndex);
		}
		
		public function getTypicalContentWidth(columnCountOverride:int = -1, startColumnIndex:int = 0):Number
		{
			const nColumns:int = (columnCount== -1) ? viewColumnCount : columnCountOverride;        
			return gridDimensions.getTypicalContentWidth(nColumns, viewColumnIndex + startColumnIndex);
		}
		
		public function getTypicalContentHeight(rowCountOverride:int = -1, startRowIndex:int = 0):Number
		{
			const nRows:int = (rowCount== -1) ? viewRowCount : rowCountOverride;        
			return gridDimensions.getTypicalContentHeight(nRows, viewRowIndex + startRowIndex);
		}
		
		public function getTypicalCellWidth(columnIndex:int):Number
		{
			return gridDimensions.getTypicalCellWidth(columnIndex + viewColumnIndex);
		}
		
		public function setTypicalCellWidth(columnIndex:int, value:Number):void
		{
			gridDimensions.setTypicalCellWidth(columnIndex + viewColumnIndex, value);
		}
		
		public function getTypicalCellHeight(columnIndex:int):Number
		{
			return gridDimensions.getTypicalCellHeight(columnIndex + viewColumnIndex);
		}
		
		public function setTypicalCellHeight(columnIndex:int, value:Number):void
		{
			gridDimensions.setTypicalCellHeight(columnIndex + viewColumnIndex, value);
		}
		
		public function toString():String
		{
			return "GridDimensionsView " + 
				viewRowIndex + "," + viewColumnIndex + " " + viewRowCount + "X" + viewColumnCount + " " + 
				gridDimensions.toString();
		}
	}
}