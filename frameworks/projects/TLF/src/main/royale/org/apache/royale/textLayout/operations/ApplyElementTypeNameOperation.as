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
	 * The ApplyElementTypeNameOperation class encapsulates a type name change.
	 *
	 * @see org.apache.royale.textLayout.elements.FlowElement#typeName
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class ApplyElementTypeNameOperation extends FlowElementOperation
	{
		private var _undoTypeName:String;
		private var _typeName:String;

		/** 
		 * Creates a ApplyElementTypeNameOperation object. 
		 * 
		 * <p>If the <code>relativeStart</code> and <code>relativeEnd</code> parameters are set, then the existing
		 * element is split into multiple elements, the selected portion using the new 
		 * type name and the rest using the existing type name.</p>
		 * 
		 * @param operationState Describes the current selection.
		 * @param targetElement Specifies the element to change.
		 * @param newTypeName The type name to assign.
		 * @param relativeStart An offset from the beginning of the target element.
		 * @param relativeEnd An offset from the end of the target element.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function ApplyElementTypeNameOperation(operationState:SelectionState, targetElement:IFlowElement, typeName:String, relativeStart:int = 0, relativeEnd:int = -1)
		{
			_typeName = typeName;
			super(operationState, targetElement, relativeStart, relativeEnd);
		}

		/** 
		 * The type name assigned by this operation.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get typeName():String
		{
			return _typeName;
		}

		public function set typeName(val:String):void
		{
			_typeName = val;
		}

		/** @private */
		public override function doOperation():Boolean
		{
			var targetElement:IFlowElement = getTargetElement();
			_undoTypeName = targetElement.typeName;

			adjustForDoOperation(targetElement);

			targetElement.typeName = _typeName;
			return true;
		}

		/** @private */
		public override function undo():SelectionState
		{
			var targetElement:IFlowElement = getTargetElement();
			targetElement.typeName = _undoTypeName;

			adjustForUndoOperation(targetElement);

			return originalSelectionState;
		}
	}
}
