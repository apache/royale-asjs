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

	

	
	/**
	 * A read only class that describes a range of contiguous table cells. Such a range occurs when you select a
	 * section of table cells. The range consists of the anchor point of the selection, <code>anchorPosition</code>,
	 * and the point that is to be modified by actions, <code>activePosition</code>.  As block selections are 
	 * modified and extended <code>anchorPosition</code> remains fixed and <code>activePosition</code> is modified.  
	 * The anchor position may be placed in the text before or after the active position.
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see org.apache.royale.textLayout.elements.TextFlow TextFlow
	 * @see org.apache.royale.textLayout.edit.SelectionState SelectionState
	 */
	public class CellRange
	{
		
		private var _table:ITableElement;
		
		// current range of selection
		private var _anchorCoords:CellCoordinates;
		private var _activeCoords:CellCoordinates;
		
		/**
		 * Limits the row and column values to 0 or the number of rows or column. 
		 **/
		private function clampToRange(coords:CellCoordinates):CellCoordinates
		{
			if(coords == null)
				return null;
			if (coords.row < 0)
				coords.row = 0;
			if (coords.column < 0)
				coords.column = 0;
			if(_table == null)
				return coords;
			
			if (coords.row >= _table.numRows)
				coords.row = _table.numRows-1;
			if (coords.column >= _table.numColumns)
				coords.column = _table.numColumns-1;
			return coords;
		}

		public function CellRange(table:ITableElement, anchorCoords:CellCoordinates, activeCoords:CellCoordinates)
		{
			_table = table;
			_anchorCoords = clampToRange(anchorCoords);
			_activeCoords = clampToRange(activeCoords);
			
		}
		
		/** 
		 * Update the range with new anchor or active position values.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 *  @param newAnchorPosition	the anchor index of the selection.
		 *  @param newActivePosition	the active index of the selection.
		 *  @return true if selection is changed.
		 */
		public function updateRange(newAnchorCoordinates:CellCoordinates, newActiveCoordinates:CellCoordinates):Boolean
		{
			clampToRange(newAnchorCoordinates);
			clampToRange(newActiveCoordinates);
			
			if (!CellCoordinates.areEqual(_anchorCoords, newAnchorCoordinates) || !CellCoordinates.areEqual(_activeCoords, newActiveCoordinates))
			{
				_anchorCoords = newAnchorCoordinates;
				_activeCoords = newActiveCoordinates;
				return true;
			}
			return false;
		}

		/** The TableElement of the selection.
		 */
		public function get table():ITableElement
		{
			return _table;
		}

		/**
		 * @private
		 */
		public function set table(value:ITableElement):void
		{
			_table = value;
		}

		/** 
		 * Anchor point of the current selection, as a CellCoordinates in the TableElement. 
		 */
		public function get anchorCoordinates():CellCoordinates
		{
			return _anchorCoords;
		}

		/**
		 * @private
		 */
		public function set anchorCoordinates(value:CellCoordinates):void
		{
			_anchorCoords = value;
		}

		/** 
		 * Active end of the current selection, as a CellCoordinates in the TableElement. 
		 */
		public function get activeCoordinates():CellCoordinates
		{
			return _activeCoords;
		}

		/**
		 * @private
		 */
		public function set activeCoordinates(value:CellCoordinates):void
		{
			_activeCoords = value;
		}


	}
}
