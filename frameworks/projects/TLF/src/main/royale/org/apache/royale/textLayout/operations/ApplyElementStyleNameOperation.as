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
	 * The ApplyElementStyleNameOperation class encapsulates a style name change.
	 *
	 * @see org.apache.royale.textLayout.elements.FlowElement#styleName
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class ApplyElementStyleNameOperation extends FlowElementOperation
	{	
		private var _origStyleName:String;
		private var _newStyleName:String;
		
		/** 
		 * Creates a ApplyElementStyleNameOperation object. 
		 * 
		 * <p>If the <code>relativeStart</code> and <code>relativeEnd</code> parameters are set, then the existing
		 * element is split into multiple elements, the selected portion using the new 
		 * style name and the rest using the existing style name.</p>
		 * 
		 * @param operationState Describes the current selection.
		 * @param targetElement Specifies the element to change.
		 * @param newStyleName The style name to assign.
		 * @param relativeStart An offset from the beginning of the target element.
		 * @param relativeEnd An offset from the end of the target element.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function ApplyElementStyleNameOperation(operationState:SelectionState, targetElement:IFlowElement, newStyleName:String, relativeStart:int = 0, relativeEnd:int = -1)
		{
			_newStyleName = newStyleName;
			super(operationState,targetElement,relativeStart,relativeEnd);
		}
		
		/** 
		 * The style name assigned by this operation.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function get newStyleName():String
		{ return _newStyleName; }
		public function set newStyleName(val:String):void
		{ _newStyleName = val; }

		/** @private */
		public override function doOperation():Boolean
		{
			var targetElement:IFlowElement = getTargetElement();
			_origStyleName = targetElement.styleName;
			
			adjustForDoOperation(targetElement);
			
			targetElement.styleName = _newStyleName;
			return true;
		}	
		
		/** @private */
		public override function undo():SelectionState
		{
			var targetElement:IFlowElement = getTargetElement();
			targetElement.styleName = _origStyleName;
			
			adjustForUndoOperation(targetElement);
			
			return originalSelectionState;
		}
	}
}
