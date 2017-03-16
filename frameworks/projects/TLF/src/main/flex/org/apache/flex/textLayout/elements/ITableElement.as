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
package org.apache.flex.textLayout.elements
{
	import org.apache.flex.textLayout.compose.ITextFlowTableBlock;
	public interface ITableElement extends ITableFormattedElement
	{
		function getRowAt(rIdx:int):ITableRowElement;
		function addCellToBlock(cell:ITableCellElement, curTableBlock:ITextFlowTableBlock):void;
		function composeCells():void;
		function getColumnAt(colIndex:int):ITableColElement;
		function getNextRow():Vector.<ITableCellElement>;
		function getFirstBlock():ITextFlowTableBlock;
		function normalizeColumnWidths(width:Number = 600):void;
		function getCellsForColumn(column:ITableColElement):Vector.<ITableCellElement>;
		function getNextCell(tableCellElement:ITableCellElement):ITableCellElement;
		function getPreviousCell(tableCellElement:ITableCellElement):ITableCellElement;
		function get hasCellDamage():Boolean;
		function set hasCellDamage(hasCellDamage:Boolean):void;
		function getTableBlocksInRange(anchorCoords:CellCoordinates, activeCoords:CellCoordinates):Vector.<ITextFlowTableBlock>;
		function get numRows():int;
		function get numColumns():int;
		function get width():Number;
		function getCellsInRange(anchorCoords:CellCoordinates, activeCoords:CellCoordinates, block:ITextFlowTableBlock = null):Vector.<ITableCellElement>;
		function findCell(coords:CellCoordinates):ITableCellElement;
		function getCellAt(rowIndex:int, colIndex:int):ITableCellElement;
		function getCellsForRowArray(row:ITableRowElement):Array;
		function getCellsForRowAtArray(index:int):Array;
		function getCellsForRowAt(index:int):Vector.<ITableCellElement>;
		function getCellsForRow(row:ITableRowElement):Vector.<ITableCellElement>;
		function set numColumns(numColumns:int):void;
		function insertRow(row:ITableRowElement=null,cells:Array = null):Boolean;
		
	}
}