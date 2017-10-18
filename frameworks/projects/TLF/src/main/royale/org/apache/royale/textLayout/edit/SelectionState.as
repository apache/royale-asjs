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
package org.apache.royale.textLayout.edit {
	import org.apache.royale.textLayout.elements.CellRange;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.TextRange;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;

	

	


	/**
	 * The SelectionState class represents a selection in a text flow.  
	 * 
	 * <p>A selection range has an anchor point, representing the point at which the selection of text began, and an
	 * active point, representing the point to which the selection is extended. The active point can be before or after 
	 * the anchor point in the text. If a selection is modified (for example, by a user shift-clicking with the mouse),
	 * the active point changes while the anchor point always remains in the same position.</p>
	 *
	 * @see org.apache.royale.textLayout.edit.ISelectionManager#getSelectionState()
	 * @see org.apache.royale.textLayout.elements.TextFlow
	 * @see org.apache.royale.textLayout.elements.TextRange
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
 	 * @langversion 3.0
 	 */
	public class SelectionState extends TextRange
	{		
		/** Format that are associated with the caret position & will be applied to inserted text */
		private var _pointFormat:ITextLayoutFormat;
		
		private var _cellRange:CellRange;
		
		private var _selectionManagerOperationState:Boolean;

		/** 
		 * Creates a SelectionState object.
		 * 
		 * <p><b>Note:</b> Do not construct a SelectionState object in order to create a selection. To
		 * create a selection in a text flow, call the <code>setSelection()</code> method of the relevant
		 * ISelectionManager instance (which is the SelectionManager or EditManager object assigned 
		 * to the <code>interactionManager</code> property of the text flow).</p>
		 * 
		 * @param	root	The TextFlow associated with the selection.
		 * @param anchorPosition	The anchor index of the selection.
		 * @param activePosition	The active index of the selection.
		 * @param	format	The TextLayoutFormat to be applied on next character typed when a point selection
		 * 
		 * @see org.apache.royale.textLayout.edit.ISelectionManager#getSelectionState()
		 * @see org.apache.royale.textLayout.edit.SelectionManager
		 * @see org.apache.royale.textLayout.edit.EditManager
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */		
		public function SelectionState(root:ITextFlow,anchorPosition:int,activePosition:int,format:ITextLayoutFormat = null,cellRange:CellRange = null)
		{
			super(root, anchorPosition, activePosition);
			if (format)
				_pointFormat = format;
			_cellRange = cellRange;
		}
		
		/** 
		 * Updates the selection range with new anchor or active position values.  
		 * 
		 * <p>The <code>pointFormat</code> styles are cleared if the selection is changed.</p>
		 * 
		 * @param newAnchorPosition	the anchor index of the selection.
		 * @param newActivePosition	the active index of the selection.
		 * @return true if selection is changed
		 * 
		 */
		public override function updateRange(newAnchorPosition:int,newActivePosition:int):Boolean
		{
			if (super.updateRange(newAnchorPosition,newActivePosition) )
			{
				_pointFormat = null;
				return true;
			}
			return false;
		}
		
		/** 
		 * The format attributes applied to inserted text. 
		 * 
		 * <p><b>Note:</b> The <code>pointFormat</code> object does not include inherited styles. To
		 * get all the applicable style definitions, use the <code>getCommonCharacterFormat()</code>
		 * method of the ISelectionManager class.</p>
		 * 
		 * @see ISelectionManager#getCommonCharacterFormat()
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
 	 	 * @langversion 3.0
		 */												
		public function get pointFormat():ITextLayoutFormat
		{ return _pointFormat; }
		public function set pointFormat(format:ITextLayoutFormat):void
		{ _pointFormat = format; } 
		
		/** @private used to tell an operation that the SelectionState is from the SelectionManager and that the SelectionManager pointFormat should be updated. */
		public function get selectionManagerOperationState():Boolean
		{ return _selectionManagerOperationState; }
		/** @private */		
		public function set selectionManagerOperationState(val:Boolean):void
		{ _selectionManagerOperationState = val; }
		/** @private */
		public function clone():SelectionState
		{ return new SelectionState(textFlow,anchorPosition,activePosition,pointFormat); }

		/** Range of table cells in selection (null if no cells selected)*/
		public function get cellRange():CellRange
		{
			return _cellRange;
		}

		/**
		 * @private
		 */
		public function set cellRange(value:CellRange):void
		{
			_cellRange = value;
		}

	}
}
