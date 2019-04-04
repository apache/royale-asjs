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
package org.apache.royale.textLayout.elements {
	import org.apache.royale.textLayout.compose.ITextFlowTableBlock;
	import org.apache.royale.textLayout.compose.TextFlowTableBlock;
	import org.apache.royale.textLayout.events.ModelChange;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;

	import org.apache.royale.utils.ObjectMap;
	import org.apache.royale.textLayout.elements.ITableCellElement;
	
	/** 
	 * The TableElement class is used for grouping together items into a table. 
	 * A TableElement's children must be of type TableRowElement, TableColElement, TableColGroupElement, TableBodyElement.
	 * 
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 */
	public class TableElement extends TableFormattedElement implements ITableElement
	{
		
		private var _computedWidth:Number;
		
		public var x:Number;
		public var y:Number;
		
		private var columns:Vector.<ITableColElement> = new Vector.<ITableColElement>();
		private var rows:Vector.<ITableRowElement> = new Vector.<ITableRowElement>();
//		private var damagedColumns:Vector.<TableColElement> = new Vector.<TableColElement>();
//		private var damageRows:Vector.<ITableRowElement> = new Vector.<ITableRowElement>();
		private var _hasCellDamage:Boolean = true;
		
		private var _headerRowCount:uint = 0;
		private var _footerRowCount:uint = 0;
		private var _tableRowsComputed:Boolean;
		
		private var _headerRows:Vector.< Vector.<ITableCellElement> >;
		private var _footerRows:Vector.< Vector.<ITableCellElement> >;
		private var _bodyRows:Vector.< Vector.<ITableCellElement> >;
		private var _composedRowIndex:uint = 0;
		
		private var _tableBlocks:Vector.<ITextFlowTableBlock>;
		private var _tableBlockIndex:uint = 0;
		private var _tableBlockDict:ObjectMap;
		
		private var _leaf:TableLeafElement;
		
		public function TableElement()
		{
			super();
		}
		
		override public function get className():String
		{
			return "TableElement";
		}
		
		/** @private */
		override protected function get abstract():Boolean
		{ return false; }
		
		/** @private */
		public override function get defaultTypeName():String
		{ return "table"; }
		
		/** @private */
		public override function canOwnFlowElement(elem:IFlowElement):Boolean
		{
			return (elem is ITableCellElement) || (elem is ITableRowElement) || (elem is ITableColElement);// || (elem is TableBodyElement) || (elem is TableColGroupElement);
		}
		
		/** @private if its in a numbered list expand the damage to all list items - causes the numbers to be regenerated */
		public override function modelChanged(changeType:String, elem:IFlowElement, changeStart:int, changeLen:int, needNormalize:Boolean = true, bumpGeneration:Boolean = true):void
		{
            /*
			if (changeType==ModelChange.ELEMENT_ADDED) {
				
			}
			else if (changeType==ModelChange.ELEMENT_REMOVAL) {
				if (headerRowCount > 0 || footerRowCount > 0) {
					
				}
			}
			*/
			super.modelChanged(changeType,elem,changeStart,changeLen,needNormalize,bumpGeneration);
		}
		
		override public function set cellSpacing(cellSpacingValue:*):void
		{
			
			markCellsDamaged();
			hasCellDamage = true;
			normalizeCells();
			
			super.cellSpacing = cellSpacingValue;
		}
		
		public function get numRows():int
		{
			return rows.length;
		}
		
		public function get numColumns():int
		{
			return columns.length;
		}
		
		/**
		 * Total number of cells
		 **/
		public function get numCells():int
		{
			return getCells().length;
		}
		
		/**
		 * Total number of rows in the table. If set to a value lower than
		 * the current number of rows the rows at the end of the table are removed. 
		 * If the set to a value greater than the current number of rows additional
		 * rows are added to the table. 
		 **/
		public function set numRows(value:int):void
		{
			while(value < numRows){
				rows.pop();
			}
			var num:int = numRows;
			for(var i:int = num;i<value;i++) {
				var row:ITableRowElement = createRowElement(i, defaultRowFormat);
				rows.push(row);
			}
		}

		/**
		 * Total number of columns in the table. If set to a value lower than
		 * the current number of columns the columns at the end of the table are removed. 
		 * If the set to a value greater than the current number of columns additional
		 * columns are added to the table. 
		 **/
		public function set numColumns(value:int):void
		{
			while(value < numColumns){
				columns.pop();
			}
			var num:int = numColumns;
			for(var i:int = num;i<value;i++) {
				var column:TableColElement = createColumnElement(i, defaultColumnFormat);
				columns.push(column);
			}
		}
		private var _defaultRowFormat:ITextLayoutFormat;

		/**
		 * Gets the row format for new rows. 
		 **/
		public function get defaultRowFormat():ITextLayoutFormat
		{
			if(!_defaultRowFormat)
				_defaultRowFormat = new TextLayoutFormat(computedFormat);
			return _defaultRowFormat;
		}

		public function set defaultRowFormat(value:ITextLayoutFormat):void
		{
			_defaultRowFormat = value;
		}
		
		private var _defaultColumnFormat:ITextLayoutFormat;

		/**
		 * Gets the column format for new columns. 
		 **/
		public function get defaultColumnFormat():ITextLayoutFormat
		{
			if(!_defaultColumnFormat)
				_defaultColumnFormat = new TextLayoutFormat(computedFormat);
			return _defaultColumnFormat;
		}

		public function set defaultColumnFormat(value:ITextLayoutFormat):void
		{
			_defaultColumnFormat = value;
		}
		
		/**
		 * Adds a table cell element to the table. 
		 * @inheritDoc
		 **/
		override public function addChild(child:IFlowElement):IFlowElement
		{
			
			if (child is TableFormattedElement) {
				TableFormattedElement(child).table = this;
			}
			
			super.addChild(child);
			
			return child;
		}
		
		/**
		 * Removes a table cell element from the table. 
		 * @inheritDoc
		 **/
		override public function removeChild(child:IFlowElement):IFlowElement
		{
			super.removeChild(child);
			
			if (child is TableFormattedElement) {
				TableFormattedElement(child).table = null;
			}
			
			return child;
		}
		
		/**
		 * Add a row at the end of the table. You would use this if you want to add a row
		 * without changing the table cells. 
		 * @see addRowAt
		 * @see insertRow
		 * @see insertRowAt
		 **/
		public function addRow(format:ITextLayoutFormat=null):void{
			addRowAt(rows.length,format);
		}
		
		/**
		 * Add a row at the index specified. 
		 * @see addRow
		 * @see insertRow
		 * @see insertRowAt
		 **/
		public function addRowAt(idx:int, format:ITextLayoutFormat=null):void{
			if(idx < 0 || idx > rows.length)
				throw RangeError(GlobalSettings.resourceStringFunction("badPropertyValue"));
			
			var row:ITableRowElement = createRowElement(idx, format);
			rows.splice(idx, 0, row);
			row.composedHeight = row.computedFormat.minCellHeight;
			row.isMaxHeight = row.computedFormat.minCellHeight == row.computedFormat.maxCellHeight;
			row.setParentAndRelativeStartOnly(this, 1);
		}

		/**
		 * Adds a column. You would use this if you want to add a column without changing the table cells. 
		 * The cells would reflow, so a cell in row 2 might move up to row 1.
		 * @see addColumnAt
		 * @see insertColumn
		 * @see insertColumnAt
		 **/
		public function addColumn(format:ITextLayoutFormat=null):void{
			addColumnAt(columns.length,format);
		}
		
		/**
		 * Adds a column at the index specified. 
		 * @see addColumn
		 * @see insertColumn
		 * @see insertColumnAt
		 **/
		public function addColumnAt(idx:int, format:ITextLayoutFormat=null):void{
			if(idx < 0 || idx > columns.length)
				throw RangeError(GlobalSettings.resourceStringFunction("badPropertyValue"));
			if(!format) {
				format = defaultColumnFormat;
			}
			var column:TableColElement = createColumnElement(idx, format);
			
			columns.splice(idx, 0, column);
		}

		/**
		 * Returns the column at the index specified or null if the index is out of range. 
		 **/
		public function getColumnAt(columnIndex:int):ITableColElement
		{
			if ( columnIndex < 0 || columnIndex >= numColumns )
				return null;
			return columns[columnIndex];
		}
		
		/**
		 * Returns the row at the index specified or null if the index is out of range. 
		 **/
		public function getRowAt(rowIndex:int):ITableRowElement
		{
			if ( rowIndex < 0 || rowIndex >= numRows )
				return null;
			return rows[rowIndex];
		}
		
		/**
		 * Return the index of the row provided or -1 if the row is not found. 
		 **/
		public function getRowIndex(row:ITableRowElement):int
		{
			for(var i:int=0;i<rows.length;i++)
			{
				if(rows[i] == row)
					return i;
			}
			return -1;
		}
		
		/**
		 * Returns a vector of the cells for the row specified. 
		 **/
		public function getCellsForRow(row:ITableRowElement):Vector.<ITableCellElement>{
			
			return getCellsForRowAt(row.rowIndex);
		}
		
		/**
		 * Returns a vector of the cells for the row specified. 
		 **/
		public function getCellsForRowArray(row:ITableRowElement):Array {
			
			return getCellsForRowAtArray(row.rowIndex);
		}
		
		/**
		 * Returns a vector of the cells for the row at the specified index. 
		 **/
		public function getCellsForRowAt(index:int):Vector.<ITableCellElement>{
			var cells:Vector.<ITableCellElement> = new Vector.<ITableCellElement>();
			
			if (index < 0) {
				return cells;
			}
			
			for each(var cell:ITableCellElement in mxmlChildren){
				if (cell.rowIndex == index) {
					cells.push(cell);
				}
			}
			
			return cells;
		}
		
		/**
		 * Returns an array of the cells for the row specified. 
		 **/
		public function getCellsForRowAtArray(index:int):Array {
			var cells:Array = [];
			
			if (index < 0) {
				return cells;
			}
			
			for each(var cell:ITableCellElement in mxmlChildren){
				if (cell.rowIndex == index) {
					cells.push(cell);
				}
			}
			
			return cells;
		}
		
		/**
		 * Returns a Vector of the TableCellElements for the column specified. 
		 **/
		public function getCellsForColumn(column:ITableColElement):Vector.<ITableCellElement> {
			if(columns.indexOf(column) < 0)
				return null;
			
			return getCellsForColumnAt(column.colIndex);
		}
		
		/**
		 * Returns a Vector of the TableCellElements for the column at the specified index. 
		 **/
		public function getCellsForColumnAt(index:int):Vector.<ITableCellElement> {
			var cells:Vector.<ITableCellElement> = new Vector.<ITableCellElement>();
			
			if (index < 0) {
				return cells;
			}
			
			for each(var cell:ITableCellElement in mxmlChildren){
				if (cell.colIndex == index) {
					cells.push(cell);
				}
			}
			
			return cells;
		}
		
		/**
		 * Convenience method for checking if table has merged cells
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableCellElement
		 */
		public function hasMergedCells():Boolean
		{
			var cell:ITableCellElement;
			var child:*;
			if(mxmlChildren == null)
				return false;
			for each(child in mxmlChildren)
			{
				cell = child as ITableCellElement;
				if( cell && (cell.columnSpan > 1 || cell.rowSpan > 1) )
					return true;
			}
			return false;
		}
		
		/**
		 * Inserts a column at the end of the table. If a column is not provided one is created. 
		 * 
		 * @see addColumn
		 * @see addColumnAt
		 * @see insertColumnAt
		 **/
		public function insertColumn(column:TableColElement=null,cells:Array = null):Boolean{
			return insertColumnAt(numColumns,column,cells);
		}
		
		/**
		 * Inserts a column at the column specified. If the column is not provided it
		 * creates a new column containing the cells supplied or creates the cells
		 * based on the number of rows in the table. 
		 * @see addColumn
		 * @see addColumnAt
		 * @see insertColumn
		 **/
		public function insertColumnAt(idx:int,column:TableColElement=null,cells:Array = null):Boolean{
			
			if (idx < 0 || idx > columns.length) {
				throw RangeError(GlobalSettings.resourceStringFunction("badPropertyValue"));
			}
			
			if (!column) {
				column = createColumnElement(idx, defaultColumnFormat);
			}
			
			columns.splice(idx,0,column);
			
			var blockedCoords:Vector.<CellCoords> = getBlockedCoords(-1,idx);
			var cellIdx:int = getCellIndex(0,idx);
			if(cellIdx < 0)
				cellIdx = numChildren;
			var rowIdx:int = 0;
			
			if (cells==null) cells = []; 
			
			while(cells.length < numRows){
				cells.push(ElementHelper.getTableCell());
			}
			
			for each(var cell:ITableCellElement in cells){
				while(blockedCoords.length && blockedCoords[0].row == rowIdx){
					rowIdx++;
					blockedCoords.shift();
				}
				cellIdx = getCellIndex(rowIdx,idx);
				if(cellIdx < 0)
				{
					cellIdx = getCellIndex(rowIdx,idx-1);
					cellIdx++;
				}
				
				if(rowIdx < numRows){
					addChildAt(cellIdx,cell);
				}
				rowIdx++;
			}


			return true;
		}
		
		/**
		 * Inserts a row at the end of the table. If a row is not provided one is created. 
		 * @see insertRowAt
		 **/
		public function insertRow(row:ITableRowElement=null,cells:Array = null):Boolean{
			return insertRowAt(numRows,row,cells);
		}
		
		/**
		 * Inserts a row at the index specified. If the row is not provided it
		 * creates a new row containing the cells supplied or creates the cells
		 * based on the number of columns in the table. 
		 **/
		public function insertRowAt(idx:int,row:ITableRowElement=null,cells:Array = null):Boolean{
			if (idx < 0 || idx > rows.length) {
				throw RangeError(GlobalSettings.resourceStringFunction("badPropertyValue"));
			}
			
			if (!row) {
				row = createRowElement(idx, defaultRowFormat);
			}
			
			rows.splice(idx,0,row);
			row.composedHeight = row.computedFormat.minCellHeight;
			row.isMaxHeight = row.computedFormat.minCellHeight == row.computedFormat.maxCellHeight;

			var cellIdx:int = getCellIndex(idx,0);
			if(cellIdx < 0)
				cellIdx = numChildren;

			var colIdx:int = 0;
			
			if (cells==null) cells = [];
			
			var cell:ITableCellElement;
			// create more cells while tracking occupied columns of merged cells
			var occupiedColumns:int = 0;
			for each(cell in cells)
				occupiedColumns += cell.columnSpan;

			while(occupiedColumns < numColumns)
			{
				cells.push(ElementHelper.getTableCell());
				occupiedColumns++;
			}
			
			for each(cell in cells)
			{
				if(colIdx < numColumns)
				{
					addChildAt(cellIdx++,cell);
					cell.damage();
				}
				colIdx += (cell.columnSpan-1);
			}
			return true;
		}
		
		/**
		 * Removes the row
		 **/
		public function removeRow(row:ITableRowElement):ITableRowElement {
			var i:int = rows.indexOf(row);
			if(i < 0)
				return null;
			return removeRowAt(i);
		}
		
		/**
		 * Removes the row and the cells it contains.
		 **/
		public function removeRowWithContent(row:ITableRowElement):Array
		{
			var i:int = rows.indexOf(row);
			if(i < 0)
				return null;
			return removeRowWithContentAt(i);
		}
		
		/**
		 * Removes the row at the index specified.
		 * @see removeRowWithContentAt
		 **/
		public function removeRowAt(idx:int):ITableRowElement {
			if(idx < 0 || idx > rows.length - 1)
				return null;
			
			var row:ITableRowElement = ITableRowElement(rows.splice(idx,1)[0]);
			normalizeCells();
			hasCellDamage = true;
			return row;
			
		}
		
		/**
		 * Removes the row at the index specified and the cells it contains.
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableCellElement
		 **/
		public function removeRowWithContentAt(idx:int):Array
		{

			var removedCells:Array = [];
			
			if(mxmlChildren){
				for (var i:int = mxmlChildren.length-1;i>=0;i--){
					var child:* = mxmlChildren[i];
					if(!(child is ITableCellElement))
						continue;
					var cell:ITableCellElement = child as ITableCellElement;
					if(cell.rowIndex == idx){
						removedCells.unshift(removeChild(cell));
					}
				}
			}
			
			removeRowAt(idx);
			return removedCells;
		}
		
		/**
		 * Removes all the rows and the cells.
		 **/
		public function removeAllRowsWithContent():void
		{
			var rowCount:int;
//			var cellCount:int;
			
			if (numRows>-1) {
				rowCount = numRows-1;
				
				for (;rowCount>-1;) {
					removeRowWithContentAt(rowCount--);
				}
				
			}
		}
		
		/**
		 * Removes all the rows. Does not remove the cells.
		 * @see removeAllRowsWithContent
		 **/
		public function removeAllRows():void
		{
			var rowCount:int;
//			var cellCount:int;
			
			if (numRows>-1) {
				rowCount = numRows;
				
				for (var i:int; i < rowCount; i++) {
					removeRowAt(i);
				}
				
			}
		}
		
		/**
		 * Removes the column
		 **/
		public function removeColumn(column:ITableColElement):ITableColElement {
			var i:int = columns.indexOf(column);
			if(i < 0)
				return null;
			return removeColumnAt(i);
		}
		
		/**
		 * Removes the column and the cells it contains.
		 **/
		public function removeColumnWithContent(column:ITableColElement):Array
		{
			var i:int = columns.indexOf(column);
			if(i < 0)
				return null;
			return removeColumnWithContentAt(i);
		}

		/**
		 * Removes the column at the index specified
		 **/
		public function removeColumnAt(idx:int):ITableColElement {
			if(idx < 0 || idx > columns.length - 1)
				return null;
			
			var col:ITableColElement = columns.splice(idx,1)[0];
			normalizeCells();
			hasCellDamage = true;
			return col;
		}
		
		/**
		 * Removes the column at the index specified and the cells it contains. 
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableCellElement
		 **/
		public function removeColumnWithContentAt(idx:int):Array
		{
			
			var removedCells:Array = [];
			if(mxmlChildren){
				for (var i:int = mxmlChildren.length-1;i>=0;i--){
					var child:* = mxmlChildren[i];
					if(!(child is ITableCellElement))
						continue;
					var cell:ITableCellElement = child as ITableCellElement;
					if(cell.colIndex == idx){
						removedCells.unshift(removeChild(cell));
					}
				}
			}
			removeColumnAt(idx);

			return removedCells;
		}
		
		/**
		 * Remove all cells
		 * @inheritDoc
		 **/
		override public function removed():void
		{
			hasCellDamage = true;
			//removeAllRowsWithContent();
		}
		
		/**
		 * @private
		 * Gets table coordinates which represents the space occupied by cells spanning rows or columns
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableCellElement
		 **/
		private function getBlockedCoords(inRow:int = -1, inColumn:int = -1):Vector.<CellCoords>{
			var coords:Vector.<CellCoords> = new Vector.<CellCoords>();
			var curColumn:int = 0;
			if(mxmlChildren) {
				for each(var child:* in mxmlChildren){
					var cell:ITableCellElement = child as ITableCellElement;
					if (cell==null) continue;
					if(cell.columnSpan == 1 && cell.rowSpan == 1)
						continue;
					var curRow:int = cell.rowIndex;
					if(inRow >= 0 && curRow != inRow)
						continue;
					if(inColumn >= 0 && inColumn != curColumn)
						continue;
					curColumn = cell.colIndex;
					var endRow:int = curRow + cell.rowSpan - 1;
					var endColumn:int = curColumn + cell.columnSpan -1;
					for(var rowIdx:int = curRow;rowIdx <= endRow;rowIdx++){
						for(var colIdx:int = curColumn;colIdx <=endColumn;colIdx++){
							if(rowIdx == curRow && colIdx == curColumn){
								continue;
							}
							coords.push( new CellCoords(colIdx, rowIdx) );
						}
					}

				}
			}
			return coords;
		}
		
		/**
         * @suppress {uselessCode}
		 * Sets the row and column indices of the cells in the table to match their logical position as described by the table columns and rows
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableCellElement
		 **/
		public function normalizeCells():void
		{
			this.numColumns;this.numRows;
			var i:int;
			var blockedCoords:Vector.<CellCoords> = new Vector.<CellCoords>();
			
			if (!mxmlChildren) {
				return;
			}
			
			var curRow:int = 0;
			var curColumn:int = 0;
			
			for each(var child:* in mxmlChildren) {
				
				if (!(child is ITableCellElement)) {
					continue;
				}
				
				var cell:ITableCellElement = child as ITableCellElement;
				
				if (cell.rowIndex != curRow || cell.colIndex != curColumn) {
					cell.rowIndex = curRow;
					cell.colIndex = curColumn;
					cell.damage();
				}
				
				// add blocked coords if the cell spans rows or columns
				var endRow:int = curRow + cell.rowSpan - 1;
				var endColumn:int = curColumn + cell.columnSpan -1;
				
				for(var rowIdx:int = curRow;rowIdx <= endRow;rowIdx++){
					for(var colIdx:int = curColumn;colIdx <=endColumn;colIdx++){
						if(rowIdx == curRow && colIdx == curColumn){
							continue;
						}
						blockedCoords.push(new CellCoords(colIdx,rowIdx) );
					}
				}
				
				// advance coordinates while checking blocked ones from spans
				do {
					curColumn++;
					
					if (curColumn >= numColumns){
						curColumn = 0;
						curRow++;
					}
					
					var advanced:Boolean = true;
					
					for (i=0;i<blockedCoords.length;i++){
						if(blockedCoords[i].column == curColumn && blockedCoords[i].row == curRow){
							advanced = false;
							blockedCoords.splice(i,1);
						}
					}
					
					if (advanced) {
						break;
					}
					
				} while(1);
				
			}
			
		}
		
		/**
		 * Set the width of the specified column. The value can be a number or percent. 
		 **/
		public function setColumnWidth(columnIndex:int, value:*):Boolean
		{
			//TODO: changing the column width probably requires a recompose of all cells in that column. Mark the cells in that row damaged.
			var tableColElement:ITableColElement = getColumnAt(columnIndex);
			if ( ! tableColElement )
				return false;
			
			tableColElement.tableColumnWidth = value;
			return true;
		}
		
		/**
		 * Set the height of the specified row. The value can be a number or percent. 
		 **/
		public function setRowHeight(rowIdx:int, value:*):Boolean{
			//TODO: setting the row height might change the composition height of the cells. We'll need to do some housekeeping here.
			// I'm not sure this function makes sense. We need to handle both min and max values to allow for expanding cells.
			var row:ITableRowElement = getRowAt(rowIdx);
			if(!row)
				return false;
			
			return true;
		}
		
		/**
		 * Get the width of the column. 
		 **/
		public function getColumnWidth(columnIndex:int):*
		{
			var tableColElement:TableColElement = getColumnAt(columnIndex) as TableColElement;
			if ( tableColElement )
				return tableColElement.tableColumnWidth;
			return 0;
        }
		
		/**
		 * Sizes and positions the cells in the table. 
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableCellElement
		 **/
		public function composeCells():void{
			normalizeCells();
			_composedRowIndex = 0;
			
			// make sure the height that defines the row height did not change. If it did we might need to change the row height.
			if(!hasCellDamage)
				return;
			var damagedCells:Vector.<ITableCellElement> = getDamagedCells();
			var cell:ITableCellElement;
			
			for each(cell in damagedCells){
				// recompose the cells while tracking row height if necessary
				cell.compose();
			}
			
			// set row heights to minimum
			for each (var row:ITableRowElement in rows){
				var minH:Number = row.computedFormat.minCellHeight;
				var maxH:Number = row.computedFormat.maxCellHeight;
				row.totalHeight = row.composedHeight = minH;
				if(maxH > minH)
					row.isMaxHeight = false;
				else
					row.isMaxHeight = true;
				
			}
			
			// set column positions...
			var xPos:Number = 0;
			for each (var col:TableColElement in columns){
				col.x = xPos;
				xPos += col.columnWidth;
			}
			
			if (mxmlChildren) {
				for(var i:int=0;i<mxmlChildren.length;i++){
					if( !(mxmlChildren[i] is ITableCellElement) )
						continue;
					cell = mxmlChildren[i] as ITableCellElement;
					while(rows.length < cell.rowIndex+1){
						addRow(defaultRowFormat);
					}
					row = getRowAt(cell.rowIndex);
					if(!row)
						throw new Error("this should not happen...");
					if(row.isMaxHeight) {
						continue;
					}
					
					var cellHeight:Number = cell.getComposedHeight();
					if(cell.rowSpan > 1)
					{
						// figure out the total height taking into account fixed height rows and the total span.
						
						// for now, we're taking the easy way out assuming the rows are not fixed...
						row.totalHeight = Math.max(row.totalHeight, cellHeight);
						
					}
					else
					{
						row.composedHeight = Math.max(row.composedHeight, cellHeight);
						row.composedHeight = Math.min(row.composedHeight, row.computedFormat.maxCellHeight);
						row.totalHeight = Math.max(row.composedHeight, row.totalHeight);
					}
					if(row.composedHeight == row.computedFormat.maxCellHeight)
						row.isMaxHeight = true;
				}
			}
			
			
			if(!_tableRowsComputed)
			{
				// create arrays or rows to make table composition simpler
				// For now we're assuming all cells have the correct row and column indices.
				// For this assumption to remain valid, the interaction manager will have to update all indices when inserting rows and columns.
				// actually, it probably makes sense for TableElement to handle that when adding rows and columns.
				// we need to think this through.
				_bodyRows = new Vector.< Vector.<ITableCellElement> >();
				
				if (mxmlChildren) {
					for(i=0;i<mxmlChildren.length;i++){
						
						if ( !(mxmlChildren[i] is ITableCellElement) ) {
							continue;
						}
						
						cell = mxmlChildren[i] as ITableCellElement;
						
						while(cell.rowIndex >= _bodyRows.length)
							_bodyRows.push(new Vector.<ITableCellElement>());
							
						var rowVec:Vector.<ITableCellElement> = _bodyRows[cell.rowIndex] as Vector.<ITableCellElement>;
						
						if(!rowVec){
							rowVec = new Vector.<ITableCellElement>();
							_bodyRows[cell.rowIndex] = rowVec;
						}
						
						if(rowVec.length > cell.colIndex && rowVec[cell.colIndex]) {
							throw new Error("Two cells cannot have the same coordinates");
						}
						
						rowVec.push(cell);
					}
				}
				
				if(headerRowCount > 0){
					_headerRows = _bodyRows.splice(0,headerRowCount);
				} else {
					_headerRows = null;
				}
				
				if(footerRowCount > 0){
					_footerRows = _bodyRows.splice(-footerRowCount,Number.MAX_VALUE);
				} else {
					_footerRows = null;
				}
			}
		}
		
		/**
		 * returns the header rows for composition
		 **/
		public function getHeaderRows():Vector.< Vector.<ITableCellElement> >{
			return _headerRows;
		}
		
		/**
		 * returns the footer rows for composition
		 **/
		public function getFooterRows():Vector.< Vector.<ITableCellElement> >{
			return _footerRows;
		}
		
		/**
		 * returns the body rows (sans header and footer cells) for composition
		 **/
		public function getBodyRows():Vector.< Vector.<ITableCellElement> >{
			return _bodyRows;
		}
		
		/**
		 * returns a vector of table cells in the next row during composition
		 **/
		public function getNextRow():Vector.<ITableCellElement>{
			if(_composedRowIndex >= _bodyRows.length)
				return null;
			return _bodyRows[_composedRowIndex++];
		}
		
		/**
		 * Returns the next table cell after the supplied table cell
		 **/
		public function getNextCell(tableCell:ITableCellElement):ITableCellElement {
			var cell:ITableCellElement;
			
			for each (var element:IFlowElement in mxmlChildren) {
				cell = element as ITableCellElement;
				
				if (cell) {
					
					// get next cell in same row 
					if (cell.rowIndex==tableCell.rowIndex && cell.colIndex-1==tableCell.colIndex) {
						return cell;
					}
					
					// get first cell in next row
					if (cell.rowIndex-1==tableCell.rowIndex && cell.colIndex==0) {
						return cell;
					}
					
				}
			}
			
			return null;
		}
		
		/**
		 * Returns the previous table cell after the supplied table cell
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableCellElement
		 **/
		public function getPreviousCell(tableCell:ITableCellElement):ITableCellElement {
			var cell:ITableCellElement;
			var highestCellIndex:int = -1;
			var rowIndex:int = -1;
			
			for each (var element:IFlowElement in mxmlChildren) {
				
				if (element.className == "TableCellElement") {
					cell = element as ITableCellElement;
					// get previous cell in same row 
					if (cell.rowIndex==tableCell.rowIndex && cell.colIndex+1==tableCell.colIndex) {
						return cell;
					}
					
					// get last cell in previous row
					if (cell.rowIndex+1==tableCell.rowIndex) {
						rowIndex = cell.rowIndex;
						
						if (highestCellIndex<cell.colIndex) {
							highestCellIndex = cell.colIndex;
						}
					}
					
				}
			}
			
			if (rowIndex>-1 && highestCellIndex>-1) {
				return getCellAt(rowIndex, highestCellIndex);
			}
			
			return null;
		}
		
		/**
		 * Returns the table cell at the row and column specified.
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableCellElement
		 **/
		public function getCellAt(rowIndex:int, columnIndex:int):ITableCellElement {
			var cell:ITableCellElement;
			
			for each (var element:IFlowElement in mxmlChildren) {
				cell = element as ITableCellElement;
				
				if (cell && cell.rowIndex==rowIndex && cell.colIndex==columnIndex) {
					return cell;
				}
			}
			
			return null;
		}
		
		/**
		 * Computed height of the header cells
		 **/
		public function getHeaderHeight():Number{
			//TODO: compute the header height from the header cells
			return 0;
		}
		
		/**
		 * Computed height of the footer cells
		 **/
		public function getFooterHeight():Number{
			//TODO: compute the footer height from the footer cells
			return 0;
			
		}
		
		/**
		 * Accepts a suggested table width and calculates the column widths. 
		 **/
		public function normalizeColumnWidths(suggestedWidth:Number = 600):void{
			//TODO: before composition make sure all column widths are rational numbers
			// We feed in a width to use if there's no width otherwise specified.
			
			// quick and dirty...
			var setCount:* = computedFormat.columnCount;
			if(!setCount){
				// we need to figure this out...
			} else if(setCount == FormatValue.AUTO){
				// figure out...
			} else {
				var cCount:Number = computedFormat.columnCount;
			}
			
			while (cCount > columns.length){
				addColumn();
			}
			
			var w:Number = suggestedWidth;
			if (typeof(computedFormat.tableWidth) == "string"){
				if(computedFormat.tableWidth.indexOf("%") > 0){
					w = suggestedWidth / (parseFloat(computedFormat.tableWidth)/100);
				}
			}
			if(isNaN(w))
				w = 600;
			if(w > 20000)
				w = 600;
			
			_computedWidth = w;

			var numNonsetColumns:int = numColumns;
			var col:TableColElement;
			for each(col in columns){
				// simply stomp on the settings. (need to finesse this...)
				if(typeof(col.columnWidth) == "number")
				{
					w-= col.columnWidth;
					numNonsetColumns--;
				}
			}

			for each(col in columns)
			{
				// simply stomp on the settings. (need to finesse this...)
				if(typeof(col.columnWidth) == "number")
					continue;
				col.columnWidth = w / numNonsetColumns;
			}
		}
		
		/**
		 * Returns a vector of all the damaged cells in the table.
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableCellElement
		 **/
		private function getDamagedCells():Vector.<ITableCellElement>{
			var cells:Vector.<ITableCellElement> = new Vector.<ITableCellElement>();
			for each (var cell:* in this.mxmlChildren){
				if((cell is ITableCellElement) && cell.isDamaged())
					cells.push(cell as ITableCellElement);
			}
			return cells;
		}
		
		/**
		 * Marks all of the cells in the table as damaged.
		 **/
		private function markCellsDamaged():void {
			if (!mxmlChildren) return;
			
			for each (var cell:* in this.mxmlChildren){
				if (cell is ITableCellElement) {
					cell.damage();
				}
			}
		}
		
		/**
		 * Returns a vector of all the table cell elements in the table.
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableCellElement
		 **/
		public function getCells():Vector.<ITableCellElement> {
			var cells:Vector.<ITableCellElement> = new Vector.<ITableCellElement>();
			
			for each (var cell:* in mxmlChildren){
				if (cell is ITableCellElement) {
					cells.push(cell as ITableCellElement);
				}
			}
			
			return cells;
		}
		
		/**
		 * Returns an array of all the table cells.
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableCellElement
		 **/
		public function getCellsArray():Array {
			var cells:Array = [];
			
			for each (var cell:* in mxmlChildren){
				if (cell is ITableCellElement) {
					cells.push(cell as ITableCellElement);
				}
			}
			
			return cells;
		}
		
		/**
		 * Returns the table width
		 **/
		public function get width():Number
		{
			return _computedWidth;
		}
		
		/**
		 * Sets the table width
		 **/
		public function set width(value:Number):void
		{
			normalizeColumnWidths(value);
		}
		
		
		/**
		 * Indicates elements in the table have been modified and the table must be recomposed.
		 **/
		public function get hasCellDamage():Boolean
		{
			return _hasCellDamage;
		}

		public function set hasCellDamage(value:Boolean):void
		{
			_hasCellDamage = value;
		}

		/**
		 * Returns the number of header rows in the table
		 **/
		public function get headerRowCount():uint
		{
			return _headerRowCount;
		}

		/**
		 * Sets the number of header rows in the table
		 **/
		public function set headerRowCount(value:uint):void
		{
			if(value != _headerRowCount)
				_tableRowsComputed = false;
			_headerRowCount = value;
		}

		/**
		 * Returns the number of footer rows in the table
		 **/
		public function get footerRowCount():uint
		{
			return _footerRowCount;
		}

		/**
		 * Sets the number of footer rows in the table
		 **/
		public function set footerRowCount(value:uint):void
		{
			if(value != _footerRowCount)
				_tableRowsComputed = false;
			_footerRowCount = value;
		}
		
		/**
		 * Gets the first TextFlowTableBlock in the table. 
		 **/
		public function getFirstBlock():ITextFlowTableBlock{
			if(_tableBlocks == null)
				_tableBlocks = new Vector.<ITextFlowTableBlock>();
			if(_tableBlocks.length == 0)
				_tableBlocks.push(new TextFlowTableBlock(0));
			_tableBlockIndex = 0;
			_tableBlocks[0].parentTable = this;
			
			return _tableBlocks[0];
		}
		
		/**
		 * Gets the next TextFlowTableBlock. 
		 **/
		public function getNextBlock():ITextFlowTableBlock{
			if(_tableBlocks == null)
				_tableBlocks = new Vector.<ITextFlowTableBlock>();
			_tableBlockIndex++;
			while(_tableBlocks.length <= _tableBlockIndex){
				_tableBlocks.push( new TextFlowTableBlock(_tableBlocks.length) );
			}
			_tableBlocks[_tableBlockIndex].parentTable = this;
			
			return _tableBlocks[_tableBlockIndex];
		}
		
		/**
		 * Gets the total atom length of this flow element in the text flow.  
		 * 
		 * @inheritDoc
		 **/
		override public function get textLength():int{
			return 1;
		}
		/* @private */
		override public function getText(relativeStart:int = 0, relativeEnd:int = -1, paragraphSeparator:String = "\n"):String
		{
			//TODO The code in ParagraphElement.getText() returns no text for tables.
			// This is to ensure the results match when the TextBlocks are not created yet.
			return "";
			// return "\uFDEF";
		}
		
		/**
		 * Returns the cell at the specified row and column.
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ITableCellElement
		 **/
		private function getCellIndex(rowIdx:int,columnIdx:int):int{
			if(rowIdx == 0 && columnIdx == 0)
				return 0;
			for (var i:int=0;i<mxmlChildren.length;i++){
				var item:* = mxmlChildren[i];
				if(!(item is ITableCellElement))
					continue;
				var cell:ITableCellElement = item as ITableCellElement;
				if(cell.rowIndex == rowIdx && cell.colIndex == columnIdx)
					return i;
			}
			return -1;
			
		}
		
		/**
		 * Returns a vector of table cell elements in the given cell range. 
		 **/
		public function getCellsInRange(anchorCoords:CellCoordinates, activeCoords:CellCoordinates, block:ITextFlowTableBlock=null):Vector.<ITableCellElement>
		{
			var firstCoords:CellCoordinates = anchorCoords.clone();
			var lastCoords:CellCoordinates = activeCoords.clone();
			if(
				lastCoords.row < firstCoords.row ||
				(lastCoords.row == firstCoords.row && lastCoords.column < firstCoords.column)
			)
			{
				firstCoords = activeCoords.clone();
				lastCoords = anchorCoords.clone();
			}
			
			// make sure the rectangle is not inversed
			if(lastCoords.column < firstCoords.column)
			{
				var col:int = firstCoords.column;
				firstCoords.column = lastCoords.column;
				lastCoords.column = col;
			}
			var firstCell:ITableCellElement = findCell(firstCoords);
			var cells:Vector.<ITableCellElement> = new Vector.<ITableCellElement>();
			if(!block || getCellBlock(firstCell) == block)
				cells.push(firstCell);
			var idx:int = mxmlChildren.indexOf(firstCell);
			while(++idx < mxmlChildren.length)
			{
				var nextCell:ITableCellElement = mxmlChildren[idx];
				if(nextCell.rowIndex > lastCoords.row || (nextCell.rowIndex == lastCoords.row && nextCell.colIndex > lastCoords.column))
					break;
				// skip cells outside rectangle
				if(nextCell.colIndex > lastCoords.column || nextCell.colIndex < firstCoords.column)
					continue;
				if(!block || getCellBlock(nextCell) == block)
					cells.push(nextCell);
			}
			return cells;
		}
		
		/**
		 * Finds the cell at the specified cell coordinates or null if no cell is found. 
		 **/
		public function findCell(coords:CellCoordinates):ITableCellElement
		{
			// get a guess of the cell location. If there's no holes (such as spans), it should theoretically pinpoint the index.
			var idx:int = (coords.row+1) * (coords.column+1) -1;
			if(idx >= numChildren)
				idx = numChildren-1;
			
			var cell:ITableCellElement = mxmlChildren[idx];
			// look ahead to see if we're short (not sure if this is needed).
			do
			{
				if(idx == numChildren-1)
					break;
				var nextCell:ITableCellElement = mxmlChildren[idx+1];
				if(nextCell.rowIndex > coords.row || (nextCell.rowIndex == coords.row && nextCell.colIndex > coords.column))
					break;
				
				cell = nextCell;
				idx++;
				
			}while(true);
			// look behind accounting for spans
			do
			{
				//check if the coords fall within the row and column span
				if(
					cell.colIndex <= coords.column && cell.colIndex + cell.columnSpan - 1 >= coords.column &&
					cell.rowIndex <= coords.row && cell.rowIndex + cell.rowSpan - 1 >= coords.row
				)
					break;
				//oops we hit the first cell without finding anything. At least return that...
				if(cell.colIndex == 0 && cell.rowIndex == 0)
					break;
				if(idx == 0)
					break;
				var prevCell:ITableCellElement = mxmlChildren[idx-1];
				cell = prevCell;
				idx--;
			}while(true);
			
			return cell;
		}
		
		/**
		 * Adds the table cell container to the table block specified. 
		 **/
		public function addCellToBlock(cell:ITableCellElement, block:ITextFlowTableBlock):void
		{
			block.addCell(cell.container);
			tableBlockDict[cell] = block;
		}
		
		/**
		 * Returns the table block for the given table cell. 
		 **/
		public function getCellBlock(cell:ITableCellElement):ITextFlowTableBlock
		{
			return tableBlockDict[cell];
		}

		/**
		 * Keeps a reference to all the table blocks belonging to this table. 
		 **/
		private function get tableBlockDict():ObjectMap
		{
			if(_tableBlockDict == null)
				_tableBlockDict = new ObjectMap();
			return _tableBlockDict;
		}
		
		/**
		 * Returns a vector of the table blocks.
		 **/
		public function get tableBlocks():Vector.<ITextFlowTableBlock>
		{
			return _tableBlocks;
		}
		
		/**
		 * Returns a vector of the table blocks in the specified cell range.
		 **/
		public function getTableBlocksInRange(start:CellCoordinates,end:CellCoordinates):Vector.<ITextFlowTableBlock>
		{
			var coords:CellCoordinates = start.clone();
			if(end.column < start.column)
			{
				coords = end.clone();
				end = start.clone();
			}
			var blocks:Vector.<ITextFlowTableBlock> = new Vector.<ITextFlowTableBlock>();
			var block:ITextFlowTableBlock = getCellBlock(findCell(coords));
			if(block)
				blocks.push(block);
			while(block)
			{
				coords.row++;
				if(coords.row > end.row)
					break;
				if(getCellBlock(findCell(coords)) == block)
					continue;
				block = getCellBlock(findCell(coords));
				if(block)
					blocks.push(block);
			}
			return blocks;
		}

		/** @private */
		public override function getNextLeafHelper(limitElement:IFlowGroupElement,child:IFlowElement):IFlowLeafElement
		{
			return parent.getNextLeafHelper(limitElement,this);
		}
		
		/** @private */
		public override function getPreviousLeafHelper(limitElement:IFlowGroupElement,child:IFlowElement):IFlowLeafElement
		{
			return parent.getPreviousLeafHelper(limitElement,this);
		}

		private function getLeaf():TableLeafElement
		{
			if(_leaf == null)
				_leaf = new TableLeafElement(this);
			return _leaf;
		}
		
		public override function findLeaf(relativePosition:int):IFlowLeafElement
		{
			return getLeaf();
		}
		public override function getLastLeaf(): IFlowLeafElement
		{
			return getLeaf();
		}
		public override function getFirstLeaf():IFlowLeafElement
		{
			return getLeaf();
		}

		public override function createContentElement():void{}
		/** @private 
		 * Release the FTE data structure that corresponds to the FlowElement, so it can be gc'ed
		 */
		public override function releaseContentElement():void{}

		/**
		 * Creates and returns a default row 
		 **/
		public function createRowElement(index:int, defaultRowFormat:ITextLayoutFormat):ITableRowElement {
			var row:ITableRowElement = ElementHelper.getTableRow(defaultRowFormat);
			row.rowIndex = index;
			row.table = this;
			return row;
		}

		/**
		 * Creates and returns a default column 
		 **/
		public function createColumnElement(index:int, defaultColumnFormat:ITextLayoutFormat):TableColElement {
			var column:TableColElement = new TableColElement(defaultColumnFormat);
			column.colIndex = index;
			column.table = this;
			return column;
		}
		public override function normalizeRange(normalizeStart:uint,normalizeEnd:uint):void
		{
			
		}
	}
}
class CellCoords
{
	public var column:int;
	public var row:int;
	public function CellCoords(colIdx:int,rowIdx:int)
	{
		column = colIdx;
		row = rowIdx;
	}
}
