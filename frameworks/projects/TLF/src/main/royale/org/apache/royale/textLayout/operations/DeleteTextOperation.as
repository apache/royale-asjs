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
package org.apache.royale.textLayout.operations {
	import org.apache.royale.textLayout.edit.IMemento;
	import org.apache.royale.textLayout.edit.ModelEdit;
	import org.apache.royale.textLayout.edit.PointFormat;
	import org.apache.royale.textLayout.edit.SelectionState;

	


	/**
	 * The DeleteTextOperation class encapsulates the deletion of a range of text.
	 *
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class DeleteTextOperation extends FlowTextOperation
	{
		private var _memento:IMemento;
		private var _allowMerge:Boolean;
		private var _pendingFormat:PointFormat;
		
		private var _deleteSelectionState:SelectionState = null;
		/** 
		 * Creates a DeleteTextOperation operation.
		 * 
		 * @param operationState The original range of text.
		 * @param deleteSelectionState The range of text to delete, if different from the range 
		 * described by <code>operationState</code>. (Set to <code>null</code> to delete the range
		 * described by <code>operationState</code>.)
		 * @param allowMerge Set to <code>true</code> if this operation can be merged with the next or previous operation.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function DeleteTextOperation(operationState:SelectionState, deleteSelectionState:SelectionState = null, allowMerge:Boolean = false)
		{
			_deleteSelectionState = deleteSelectionState ? deleteSelectionState : operationState;				
			
			super(_deleteSelectionState);
			originalSelectionState = operationState;
			_allowMerge = allowMerge;
		}
		
		/** 
		 * Indicates whether this operation can be merged with operations executed before or after it.
		 * 
		 * <p>Some delete operations, for example, a sequence of backspace keystrokes, can be fruitfully 
		 * merged into one operation so that undoing the operation reverses the entire sequence.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get allowMerge():Boolean
		{
			return _allowMerge;
		}
		public function set allowMerge(value:Boolean):void
		{
			_allowMerge = value;
		}
		
		/** 
		 * deleteSelectionState The range of text to delete
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get deleteSelectionState():SelectionState
		{
			return _deleteSelectionState;
		}
		public function set deleteSelectionState(value:SelectionState):void
		{
			_deleteSelectionState = value;
		}
		
		/** @private */
		public override function doOperation():Boolean
		{
			// Nothing to delete
			if (absoluteStart == absoluteEnd)
				return false;
				
			_pendingFormat = PointFormat.createFromFlowElement(textFlow.findLeaf(absoluteStart));
			if (_pendingFormat.linkElement)		// don't propagate links or tcy from deleted text
				_pendingFormat.linkElement = null;
			if (_pendingFormat.tcyElement)		// don't propagate links or tcy from deleted text
				_pendingFormat.tcyElement = null;
						
			_memento = ModelEdit.deleteText(textFlow, absoluteStart, absoluteEnd, true);
			
			if (originalSelectionState.selectionManagerOperationState && textFlow.interactionManager)
			{
				// set pointFormat from leafFormat
				var state:SelectionState = textFlow.interactionManager.getSelectionState();
				if (state.anchorPosition == state.activePosition)
				{
					state.pointFormat = PointFormat.clone(_pendingFormat);
					textFlow.interactionManager.setSelectionState(state);
				}
			}

			return true;	
		}
		
		/** @private */
		public override function undo():SelectionState
		{
			if (_memento)
				_memento.undo();
			return originalSelectionState;				
		}
	
		/** @private */
		public override function redo():SelectionState
		{
			if (_memento)
				_memento.redo();
			return new SelectionState(textFlow,absoluteStart,absoluteStart,_pendingFormat);	
		}

		/** @private */
		public override function merge(op2:FlowOperation):FlowOperation
		{
			if (this.endGeneration != op2.beginGeneration)
					return null;
			var delOp:DeleteTextOperation = op2 as DeleteTextOperation;
			if ((delOp == null) || !delOp.allowMerge || !_allowMerge)
				return null;
				
			return new CompositeOperation([this, op2]);
		}	
	}
}
