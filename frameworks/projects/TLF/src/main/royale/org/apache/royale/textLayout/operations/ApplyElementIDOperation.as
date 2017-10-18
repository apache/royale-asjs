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
	import org.apache.royale.textLayout.elements.IFlowElement;

	/**
	 * The ChangeElementIDOperation class encapsulates an element ID change.
	 *
	 * @see org.apache.royale.textLayout.elements.FlowElement
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class ApplyElementIDOperation extends FlowElementOperation
	{
		private var _origID:String;
		private var _newID:String;

		/** 
		 * Creates a ChangeElementIDOperation object. 
		 * 
		 * <p>If the <code>relativeStart</code> or <code>relativeEnd</code> parameters are set, then the existing
		 * element is split into two elements, one using the existing ID and the other
		 * using the new ID. If both parameters are set, then the existing element is split into three elements.
		 * The first and last elements of the set are both assigned the original ID.</p>
		 * 
		 * @param operationState Specifies the selection state before the operation
		 * @param targetElement Specifies the element to change
		 * @param newID The ID to assign
		 * @param relativeStart An offset from the beginning of the target element.
		 * @param relativeEnd An offset from the end of the target element.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function ApplyElementIDOperation(operationState:SelectionState, targetElement:IFlowElement, newID:String, relativeStart:int = 0, relativeEnd:int = -1)
		{
			_newID = newID;
			super(operationState, targetElement, relativeStart, relativeEnd);
		}

		/** 
		 * The ID assigned by this operation.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get newID():String
		{
			return _newID;
		}

		public function set newID(val:String):void
		{
			_newID = val;
		}

		/** @private */
		public override function doOperation():Boolean
		{
			var targetElement:IFlowElement = getTargetElement();
			_origID = targetElement.id;

			adjustForDoOperation(targetElement);

			targetElement.id = _newID;
			return true;
		}

		/** @private */
		public override function undo():SelectionState
		{
			var targetElement:IFlowElement = getTargetElement();
			targetElement.id = _origID;

			adjustForUndoOperation(targetElement);

			return originalSelectionState;
		}
	}
}
