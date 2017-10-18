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
	 * The ApplyElementUserStyleOperation class encapsulates a change in a style value of an element.
	 *
	 * @see org.apache.royale.textLayout.elements.FlowElement#userStyles
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class ApplyElementUserStyleOperation extends FlowElementOperation
	{
		private var _styleName:String;
		private var _origValue:*;
		private var _newValue:*;

		/** 
		 * Creates a ApplyElementUserStyleOperation object.
		 * 
		 * <p>If the <code>relativeStart</code> and <code>relativeEnd</code> parameters are set, then the existing
		 * element is split into multiple elements, the selected portion using the new 
		 * style value and the rest using the existing style value.</p>
		 * 
		 * @param operationState Describes the range of text to style.
		 * @param targetElement Specifies the element to change.
		 * @param styleName The name of the style to change.
		 * @param value The new style value.
		 * @param relativeStart An offset from the beginning of the target element.
		 * @param relativeEnd An offset from the end of the target element.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function ApplyElementUserStyleOperation(operationState:SelectionState, targetElement:IFlowElement, styleName:String, value:*, relativeStart:int = 0, relativeEnd:int = -1)
		{
			_styleName = styleName;
			_newValue = value;

			super(operationState, targetElement, relativeStart, relativeEnd);
		}

		/** 
		 * The name of the style changed. 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get styleName():String
		{
			return _styleName;
		}

		public function set styleName(val:String):void
		{
			_styleName = val;
		}

		/** 
		 * The new style value.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public function get newValue():*
		{
			return _newValue;
		}

		public function set newValue(val:*):void
		{
			_newValue = val;
		}

		/** @private */
		public override function doOperation():Boolean
		{
			var targetElement:IFlowElement = getTargetElement();
			_origValue = targetElement.getStyle(_styleName);

			adjustForDoOperation(targetElement);

			targetElement.setStyle(_styleName, _newValue);
			return true;
		}

		/** @private */
		public override function undo():SelectionState
		{
			var targetElement:IFlowElement = getTargetElement();
			targetElement.setStyle(_styleName, _origValue);

			adjustForUndoOperation(targetElement);

			return originalSelectionState;
		}
	}
}
