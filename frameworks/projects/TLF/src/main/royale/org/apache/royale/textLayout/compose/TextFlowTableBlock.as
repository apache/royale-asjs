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
package org.apache.royale.textLayout.compose
{
	import org.apache.royale.textLayout.container.IContainerController;
	import org.apache.royale.core.IParentIUIBase;
	import org.apache.royale.graphics.ICompoundGraphic;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.textLayout.edit.SelectionFormat;
	import org.apache.royale.textLayout.elements.CellContainer;
	import org.apache.royale.textLayout.elements.CellCoordinates;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ITableCellElement;
	import org.apache.royale.textLayout.elements.ITableElement;
	import org.apache.royale.textLayout.elements.TableBlockContainer;

	/**
	 * 
	 **/
	public class TextFlowTableBlock extends TextFlowLine implements ITextFlowTableBlock
	{
		private var _textHeight:Number;

		/** Constructor - creates a new TextFlowTableBlock instance. 
		 *  <p><strong>Note</strong>: No client should call this. It's exposed for writing your own composer.</p>
		 *
		 * @param index The index in the Table text flow.
		 * */
		public function TextFlowTableBlock(index:uint)
		{
			blockIndex = index;
			_container = new TableBlockContainer();
			super(null, null);
		}

		override public function get composable():Boolean
		{
			return false;
		}

		/**
		 * @inheritDoc
		 **/
		override public function initialize(paragraph:IParagraphElement, outerTargetWidth:Number = 0, lineOffset:Number = 0, absoluteStart:int = 0, numChars:int = 0, textLine:ITextLine = null):void
		{
			_container.userData = this;
			_lineOffset = lineOffset;

			super.initialize(paragraph, outerTargetWidth, lineOffset, absoluteStart, numChars, textLine);
		}

		override public function setController(cont:IContainerController, colNumber:int):void
		{
			super.setController(cont, colNumber);
			if (cont)
				controller.addComposedTableBlock(container);
		}

		/**
		 * The table that owns this table block
		 **/
		private var _parentTable:ITableElement;
		/**
		 * The index of this block in the table text flow layout
		 **/
		public var blockIndex:uint = 0;
		/**
		 * @private
		 **/
		private var _container:TableBlockContainer;
		private var _cells:Array;

		/**
		 * Returns an array of table cells. 
		 * @private
		 **/
		private function getCells():Array
		{
			if (_cells == null)
			{
				_cells = [];
			}
			return _cells;
		}

		/**
		 * Returns a vector of table cell elements in the given cell range. 
		 **/
		public function getCellsInRange(anchorCoords:CellCoordinates, activeCoords:CellCoordinates):Vector.<ITableCellElement>
		{
			if (!parentTable)
				return null;
			return parentTable.getCellsInRange(anchorCoords, activeCoords, this);
		}

		/**
		 * Clears the cells in the table block. Wraps clearCells(). 
		 **/
		public function clear():void
		{
			clearCells();
		}

		/**
		 * Clears the cells in the table block
		 **/
		public function clearCells():void
		{
			while (_container.numElements)
			{
				_container.removeElement(_container.getElementAt(0));
			}
			getCells().length = 0;
		}

		/**
		 * Adds a cell container to table container. This adds it to the display list. 
		 * If the cell is already added it does not add it twice. 
		 **/
		public function addCell(cell:CellContainer):void
		{
			var cells:Array = getCells();
			if (cells.indexOf(cell) < 0)
			{
				cells.push(cell);
				_container.addElement(cell);
			}
		}

		public function drawBackground(backgroundInfo:*):void
		{
			// TODO: need to figure this out...
		}

		/**
		 * Container that displays this collection of cells
		 **/
		public function get container():TableBlockContainer
		{
			return _container;
		}

		/**
		 * Triggers drawing of composed cell contents
		 **/
		public function updateCompositionShapes():void
		{
			var cells:Array = getCells();
			for each (var cell:CellContainer in cells)
			{
				cell.cellElement.updateCompositionShapes();
			}
		}

		/**
		 * Sets the height of the container 
		 **/
		override public function set height(value:Number):void
		{
			// _container.height = value;
			_textHeight = value;
		}

		/**
		 * @inheritDoc
		 **/
		override public function get height():Number
		{
			return _textHeight;
		}

		/**
		 * Sets the width of the container 
		 **/
		public function set width(value:Number):void
		{
			_container.width = value;
		}

		/**
		 * Gets the width of the container 
		 **/
		public function get width():Number
		{
			return _container.width;
		}

		/**
		 * Sets the x position of the container
		 **/
		override public function set x(value:Number):void
		{
			super.x = _container.x = value;
		}

		override public function get x():Number
		{
			return _container.x;
		}

		/**
		 * Sets the y value of the container
		 **/
		override public function set y(value:Number):void
		{
			super.y = _container.y = value;
		}

		override public function get y():Number
		{
			return _container.y;
		}

		/**
		 * Returns a vector of table cell elements.
		 **/
		public function getTableCells():Vector.<ITableCellElement>
		{
			var tCells:Vector.<ITableCellElement> = new Vector.<ITableCellElement>();
			var cells:Array = getCells();

			for each (var cellContainer:CellContainer in cells)
			{
				tCells.push(cellContainer.cellElement);
			}

			return tCells;
		}

		public override function get textHeight():Number
		{
			return _textHeight;
		}

		public override function hiliteBlockSelection(selObj:ICompoundGraphic, selFormat:SelectionFormat, container:IParentIUIBase, begIdx:int, endIdx:int, prevLine:ITextFlowLine, nextLine:ITextFlowLine):void
		{
			// do nothing for now...
		}

		public function get parentTable():ITableElement
		{
			return _parentTable;
		}

		public function set parentTable(parentTable:ITableElement):void
		{
			this._parentTable = parentTable;
		}
	}
}
