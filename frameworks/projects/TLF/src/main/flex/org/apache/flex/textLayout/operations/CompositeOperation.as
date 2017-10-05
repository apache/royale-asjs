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
package org.apache.royale.textLayout.operations
{
	import org.apache.royale.textLayout.edit.SelectionState;

	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.debug.assert;



	/**
	 * The CompositeOperation class encapsulates a group of transformations managed as a unit.
	 *
	 * <p>The CompositeOperation class provides a grouping mechanism for combining multiple FlowOperations 
	 * into a single atomic operation. Grouping operations allows them to be undone and redone as a unit. 
	 * For example, several single character inserts followed by several backspaces can be undone together as if 
	 * they were a single operation. Grouping also provides a mechanism for representing
	 * complex operations. For example, a replace operation that modifies more than one text ranges
	 * can be represented and managed as a single composite operation.</p>
	 * 
	 * <p><b>Note:</b> It can be more efficient to merge individual atomic operations
	 *  rather than to combine separate operations into a group. For example, several sequential
	 *  character inserts can easily be represented as a single insert operation,
	 *  and undoing or redoing that single operation is more efficient than
	 *  undoing or redoing a group of insert operations.</p>
	 * 
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class CompositeOperation extends FlowOperation
	{
		private var _operations:Array;
		
		/** 
		 * Creates a CompositeOperation object.
		 * 
		 * @param operations The operations to group.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function CompositeOperation(operations:Array = null)
		{
			super(null);
			this.operations = operations;
			if (_operations.length)
				setGenerations(_operations[0].beginGeneration,_operations[_operations.length-1].endGeneration);
		}

		/** @private */
		override public function get textFlow():ITextFlow
		{ return _operations.length > 0 ? _operations[0].textFlow : null; }
		
		/**
		 * An array containing the operations grouped by this composite operation.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function get operations():Array
		{
			return _operations;
		}
		public function set operations(value:Array):void
		{
			_operations = value ? value.slice() : [];	// make a copy
		}
		
		/** 
		 * Adds an additional operation to the end of the list. 
		 * 
		 * <p>The new operation must operate on the same TextFlow object as 
		 * the other operations in the list.</p>
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function addOperation(operation:FlowOperation):void
		{
			// Can't handle operations from other TextFlows
			if (_operations.length > 0 && operation.textFlow != textFlow)
				return;
				
			CONFIG::debug { assert(_operations.length <= 0 || operation.beginGeneration == _operations[_operations.length - 1].endGeneration,
				"adding non-contiguous operation to composite operation"); }
			_operations.push(operation);
		}
		
		/** @private */
		public override function doOperation():Boolean
		{
			// execute all the operations in order
			var success:Boolean = true;
			for (var i:int = 0; i < _operations.length; i++)
				success = success && FlowOperation(_operations[i]).doOperation();
			
			// return selectionState from last operation
			return true;
		}
		
		/** @private */
		public override function undo():SelectionState
		{
			// undo all the operations in reverse order
			var selState:SelectionState;
			for (var i:int = _operations.length - 1; i >= 0; i--)
				selState = FlowOperation(_operations[i]).undo();
			
			// return selectionState from last performed
			// (i.e., the first in the set of operations)
			return selState;
		}
		
		/** @private */
		public override function redo():SelectionState
		{
			// execute all the operations in order
			var selState:SelectionState;
			for (var i:int = 0; i < _operations.length; i++)
				selState = FlowOperation(_operations[i]).redo();
			
			// return selectionState from last operation
			return selState;
		}		
		
		/** @private */
		public override function canUndo():Boolean
		{ 
			// All operations within the CompositeOperation must have matching generation numbers, and be undoable
			var undoable:Boolean = true;
			var generation:int = beginGeneration;
			var opCount:int = _operations.length;
			for (var i:int = 0; i < opCount && undoable; i++)
			{
				var op:FlowOperation = _operations[i];
				if (op.beginGeneration != generation || !op.canUndo())
					undoable = false;
				generation = op.endGeneration;
			}
			if (opCount > 0 && _operations[opCount - 1].endGeneration != endGeneration)
				undoable = false;
			
			return undoable; 
		}
		
		
		/** @private */
		public override function merge(operation:FlowOperation):FlowOperation
		{
			if (operation is InsertTextOperation || operation is SplitParagraphOperation || operation is DeleteTextOperation)
			{
				if (this.endGeneration != operation.beginGeneration)
					return null;
				// For efficiency, try to combine the last low-level operation
				// with the new operation. If that's not possible, we just add it 
				// as an additional operation.
				// Note that we are making various assumptions here about the technical
				// feasability and appropriateness of merging the individual operations (e.g.,
				// that the selection hasn't changed), relying on SelectionManager to
				// guarantee that these are satisfied.
				var mergedOp:FlowOperation;
				var lastOp:FlowOperation = (_operations && _operations.length) ? 
										FlowOperation(_operations[_operations.length - 1]) :
										null;
				if (lastOp) 
					mergedOp = lastOp.merge(operation);
				
				if (mergedOp && !(mergedOp is CompositeOperation))
					_operations[_operations.length - 1] = mergedOp;
				else
					_operations.push(operation);
				setGenerations(beginGeneration,operation.endGeneration);
				return this;
			}
			return null;
		}
		
//		/**
//		 *  Add an additional operation to the end of this operation.
//		 *  If the additional operation is itself a CompositeOperation, 
//		 *  its child operations are just added to this operation's 
//		 *  set of child operations.
//		 * 	
//		 * @param operation The operation to be merged.
//		 * 
//		 */
//		private function mergeOperationViaConcatenation(operation:FlowOperation):void
//		{
//			var compositeOp:CompositeOperation = operation as CompositeOperation;
//			if (compositeOp)
//				operations = operations.concat(compositeOp.operations);
//			else
//				operations.push(operation);
//		}

	}
}
