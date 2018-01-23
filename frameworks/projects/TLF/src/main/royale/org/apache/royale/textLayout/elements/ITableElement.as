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
package org.apache.royale.textLayout.elements
{
	import org.apache.royale.textLayout.compose.ITextFlowTableBlock;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	public interface ITableElement extends ITableFormattedElement
	{
		function get numRows():int;
		function get numColumns():int;
		function get numCells():int;
		function set numRows(value:int):void;
		function set numColumns(value:int):void;
		function get defaultRowFormat():ITextLayoutFormat;
		function set defaultRowFormat(value:ITextLayoutFormat):void;
		function get defaultColumnFormat():ITextLayoutFormat;
		function set defaultColumnFormat(value:ITextLayoutFormat):void;
		function addRow(format:ITextLayoutFormat=null):void;
		function addRowAt(idx:int, format:ITextLayoutFormat=null):void;
		function addColumn(format:ITextLayoutFormat=null):void;
		function addColumnAt(idx:int, format:ITextLayoutFormat=null):void;
		function getColumnAt(columnIndex:int):ITableColElement;
		function getRowAt(rowIndex:int):ITableRowElement;
		function getRowIndex(row:ITableRowElement):int;
		function getCellsForRow(row:ITableRowElement):Vector.<ITableCellElement>;
		function getCellsForRowArray(row:ITableRowElement):Array;
		function getCellsForRowAt(index:int):Vector.<ITableCellElement>;
		function getCellsForRowAtArray(index:int):Array;
		function getCellsForColumn(column:ITableColElement):Vector.<ITableCellElement>;
		function getCellsForColumnAt(index:int):Vector.<ITableCellElement>;
		function hasMergedCells():Boolean;
		function insertColumn(column:TableColElement=null,cells:Array = null):Boolean;
		function insertColumnAt(idx:int,column:TableColElement=null,cells:Array = null):Boolean;
		function insertRow(row:ITableRowElement=null,cells:Array = null):Boolean;
		function insertRowAt(idx:int,row:ITableRowElement=null,cells:Array = null):Boolean;
		function removeRow(row:ITableRowElement):ITableRowElement;
		function removeRowWithContent(row:ITableRowElement):Array;
		function removeRowAt(idx:int):ITableRowElement;
		function removeRowWithContentAt(idx:int):Array;
		function removeAllRowsWithContent():void;
		function removeAllRows():void;
		function removeColumn(column:ITableColElement):ITableColElement;
		function removeColumnWithContent(column:ITableColElement):Array;
		function removeColumnAt(idx:int):ITableColElement;
		function removeColumnWithContentAt(idx:int):Array;
		function normalizeCells():void;
		function setColumnWidth(columnIndex:int, value:*):Boolean;
		function setRowHeight(rowIdx:int, value:*):Boolean;
		function getColumnWidth(columnIndex:int):*;
		function composeCells():void;
		function getHeaderRows():Vector.< Vector.<ITableCellElement> >;
		function getFooterRows():Vector.< Vector.<ITableCellElement> >;
		function getBodyRows():Vector.< Vector.<ITableCellElement> >;
		function getNextRow():Vector.<ITableCellElement>;
		function getNextCell(tableCell:ITableCellElement):ITableCellElement;
		function getPreviousCell(tableCell:ITableCellElement):ITableCellElement;
		function getCellAt(rowIndex:int, columnIndex:int):ITableCellElement;
		function getHeaderHeight():Number;
		function getFooterHeight():Number;
		function normalizeColumnWidths(suggestedWidth:Number = 600):void;
		function getCells():Vector.<ITableCellElement>;
		function getCellsArray():Array;
		function get width():Number;
		function set width(value:Number):void;
		function get hasCellDamage():Boolean;
		function set hasCellDamage(value:Boolean):void;
		function get headerRowCount():uint;
		function set headerRowCount(value:uint):void;
		function get footerRowCount():uint;
		function set footerRowCount(value:uint):void;
		function getFirstBlock():ITextFlowTableBlock;
		function getNextBlock():ITextFlowTableBlock;
		function getCellsInRange(anchorCoords:CellCoordinates, activeCoords:CellCoordinates, block:ITextFlowTableBlock=null):Vector.<ITableCellElement>;
		function findCell(coords:CellCoordinates):ITableCellElement;
		function addCellToBlock(cell:ITableCellElement, block:ITextFlowTableBlock):void;
		function getCellBlock(cell:ITableCellElement):ITextFlowTableBlock;
		function get tableBlocks():Vector.<ITextFlowTableBlock>;
		function getTableBlocksInRange(start:CellCoordinates,end:CellCoordinates):Vector.<ITextFlowTableBlock>;
		function createRowElement(index:int, defaultRowFormat:ITextLayoutFormat):ITableRowElement;
		function createColumnElement(index:int, defaultColumnFormat:ITextLayoutFormat):TableColElement;
        
	}
}
