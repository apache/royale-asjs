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
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;



	
	/**
	 * The ApplyFormatToElementOperation class encapsulates a style change to an element.
	 *
	 * <p>This operation applies one or more formats to a flow element.</p>
	 * 
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.formats.TextLayoutFormat
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class ApplyFormatToElementOperation extends FlowElementOperation
	{
		private var _format:ITextLayoutFormat;
		
		private var _undoStyles:TextLayoutFormat;
				
		/** 
		* Creates an ApplyFormatToElementOperation object. 
		* 
		* @param operationState Specifies the text flow containing the element to which this operation is applied.
		* @param targetElement specifies the element to which this operation is applied.
		* @param format The formats to apply in this operation.
		 * 
		* @playerversion Flash 10
		* @playerversion AIR 1.5
	 	* @langversion 3.0 
		*/
		public function ApplyFormatToElementOperation(operationState:SelectionState, targetElement:IFlowElement, format:ITextLayoutFormat, relativeStart:int = 0, relativeEnd:int = -1)
		{
			super(operationState,targetElement,relativeStart,relativeEnd);
				
			// split up the properties by category
			_format = format;
		}
				
		/** 
		 * The character formats applied in this operation.
		 * 
		 * <p>If <code>null</code> no character formats are changed.</p> 
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		*/
		public function get format():ITextLayoutFormat
		{
			return _format;
		}
		public function set format(value:ITextLayoutFormat):void
		{
			_format = value;
		}
		
		/** @private */
		public override function doOperation():Boolean
		{
			var targetElement:IFlowElement = getTargetElement();
			
			adjustForDoOperation(targetElement);
			
			_undoStyles = new TextLayoutFormat(targetElement.format);
			
			if (_format)
			{
				var newFormat:TextLayoutFormat = new TextLayoutFormat(targetElement.format);
				newFormat.apply(_format);
				targetElement.format = newFormat;
			}
			
			return true;
		}	
		
		/** @private */
		public override function undo():SelectionState
		{
			var targetElement:IFlowElement = getTargetElement();
			
			targetElement.format = new TextLayoutFormat(_undoStyles);
			
			adjustForUndoOperation(targetElement);
			
			return originalSelectionState;
		}
	}
}
