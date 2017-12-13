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
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;

	
	

	
	/** 
	 * TableRowElement is an item in a TableElement. It most commonly contains one or more TableCellElement objects, 
	 * A TableRowElement always appears within a TableElement, TableBodyElement.
	 *
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 */
	public class TableRowElement extends TableFormattedElement implements ITableRowElement
	{		
		public var x:Number;
		public var y:Number;
		public var height:Number;
		private var _rowIndex:int;
		
		// This is used for background drawing
		public var parcelIndex:int;
		
		public var columnIndex:Number = 0;
		public var iMaxRowDepth:Number = 0;
		public var beyondParcel:Boolean = false;
		private var _composedHeight:Number = 0;
		private var _totalHeight:Number = 0;// used to compute if a row will fit in parcel. Need a separate value for cells that span rows.
		private var _isMaxHeight:Boolean = false;
		
		public function TableRowElement(format:ITextLayoutFormat=null)
		{
			super();
			
			if (format) {
				this.format = format;
			}
		}
		override public function get className():String{
			return "TableRowElement";
		}

		
		/** @private */
		override protected function get abstract():Boolean
		{ return false; }
		
		/** @private */
		public override function get defaultTypeName():String
		{ return "tr"; }
		
		/** @private */
		public override function canOwnFlowElement(elem:IFlowElement):Boolean
		{
			return (elem is ITableCellElement);
		}
		
		/** @private if its in a numbered list expand the damage to all list items - causes the numbers to be regenerated */
		public override function modelChanged(changeType:String, elem:IFlowElement, changeStart:int, changeLen:int, needNormalize:Boolean = true, bumpGeneration:Boolean = true):void
		{
			super.modelChanged(changeType,elem,changeStart,changeLen,needNormalize,bumpGeneration);
		}
		
		/**
		 * Returns a vector of table cell elements or null if the row contains no cells
		 **/
		public function getCells():Vector.<ITableCellElement>
		{
			var table:ITableElement = this.table;
			
			if(!table) {
				return null;
			}

			return table.getCellsForRow(this);
		}
		
		/**
		 * Get an array of cells or null if the row contains no cells
		 **/
		public function get cells():Array
		{
			var table:ITableElement = this.table;
			
			if (!table) {
				return null;
			}
			
			return table.getCellsForRowArray(this);
		}
		
		/**
		 * Returns the number of cells in this row. 
		 **/
		public function get numCells():int
		{
			var table:ITableElement = this.table;
			
			if (!table) {
				return 0;
			}
			
			return table.getCellsForRow(this).length;
		}
		
		/**
		 * Returns the cell at the specified index or null if out of range. 
		 **/
		public function getCellAt(index:int):ITableCellElement
		{
			var cells:Vector.<ITableCellElement> = getCells();
			
			if(!cells || index<0 || index>=cells.length)
				return null;
			return cells[index];
		}
		
		/**
		 * Adds a table cell to the row
		 **/
		public function addCell(cell:ITableCellElement):ITableCellElement
		{
			var table:ITableElement = this.table;
			var cellLength:int = numChildren;
			
			if (!table) {
				throw new Error("Table must be set");
			}
			
			cell.rowIndex = rowIndex;
			
			if (cell.colIndex==-1) {
				cell.colIndex = cellLength;
			}
			
			cells.push(cell);
			//var selectable:Boolean = textFlow.interactionManager is SelectionManager;
			//var editable:Boolean = textFlow.interactionManager is EditManager;
			
			return cell;
		}
		
		/**
		 * Adds a table cell to the row
		 **/
		public function addCellAt(index:int):ITableCellElement
		{
			throw new Error("Add cell at is not implemented");
		}
		
		/**
		 * Get an estimate column count for this row.
		 * This is temporary. TODO loop through cells and check for column span.
		 **/
		public function getColumnCount():int
		{
			return numCells || numChildren;
		}

		public function get composedHeight():Number
		{
			return _composedHeight;
		}

		public function set composedHeight(composedHeight:Number):void
		{
			this._composedHeight = composedHeight;
		}

		public function get rowIndex():int
		{
			return _rowIndex;
		}

		public function set rowIndex(rowIndex:int):void
		{
			this._rowIndex = rowIndex;
		}

		public function get isMaxHeight():Boolean
		{
			return _isMaxHeight;
		}

		public function set isMaxHeight(isMaxHeight:Boolean):void
		{
			this._isMaxHeight = isMaxHeight;
		}

		public function get totalHeight():Number
		{
			return _totalHeight;
		}

		public function set totalHeight(totalHeight:Number):void
		{
			this._totalHeight = totalHeight;
		}


	}
}
