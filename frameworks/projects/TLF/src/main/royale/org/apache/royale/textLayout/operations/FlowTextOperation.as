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
	import org.apache.royale.textLayout.edit.SelectionState;




	//
	// Considered several ways of doing undo/redo
	// 1 - object model level - stashing copies of all changed objects in the model and restoring them
	// 2 - cookies - saving an audit trail of every modified property of the model objects
	// 3 - operations - each operation creates an object that knows how to do/undo/redo itself
	// going with # 3 for now
	//

	/** 
	 * The FlowTextOperation is the base class for operations that transform a range of text.
	 * 
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class FlowTextOperation extends FlowOperation
	{
		private var _originalSelectionState:SelectionState;
		private var _absoluteStart:int;
		private var _absoluteEnd:int;

		/** 
		 * Creates the FlowTextOperation object.
		 * 
		 * @param operationState Specifies the relevant selection. If relevant to the operation, the 
		 * <code>operationState</code> describes the text range to which this operation applies.
		 * Otherwise, <code>operationState</code> is used to save the current selection state so that
		 * it can be restored when the operation is undone.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function FlowTextOperation(operationState:SelectionState)
		{
			super(operationState.textFlow);
			_absoluteStart = operationState.absoluteStart;
			_absoluteEnd = operationState.absoluteEnd;
			_originalSelectionState = operationState;
		}
				
		/** 
		 * The absolute start point of the range of text to which this operation is applied.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get absoluteStart():int
		{ return _absoluteStart; }
		public function set absoluteStart(value:int):void
		{ _absoluteStart = value; }
		
		/** 
		 * The absolute end point of the range of text to which this operation is applied. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get absoluteEnd():int
		{ return _absoluteEnd; }
		public function set absoluteEnd(value:int):void
		{ _absoluteEnd = value; }
		
		/** 
		 * The selection state at the start of the operation. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get originalSelectionState():SelectionState
		{
			return _originalSelectionState;
		}
		public function set originalSelectionState(value:SelectionState):void
		{
			_originalSelectionState = value;
		}
		
		/**	
		 * @inheritDoc
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		override public function redo():SelectionState
		{
			doOperation();
			return _originalSelectionState;
		}
		
	}
}
