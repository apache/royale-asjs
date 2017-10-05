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
	import org.apache.royale.textLayout.elements.IParagraphElement;

	





	/**
	 * The SplitParagraphOperation class encapsulates a change that splits a paragraph into two elements.
	 *
	 * <p>The operation creates a new paragraph containing the text from 
	 * the specified position to the end of the paragraph. If a range of text is specified, the text 
	 * in the range is deleted first.</p>
	 * 
	 * @see org.apache.royale.textLayout.elements.ParagraphElement
	 * @see org.apache.royale.textLayout.edit.EditManager
	 * @see org.apache.royale.textLayout.events.FlowOperationEvent
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */			
	public class SplitParagraphOperation extends SplitElementOperation
	{		
		/** 
		 * Creates a SplitParagraphOperation object.
		 * 
		 * @param operationState Describes the point at which to split the paragraph.
		 * If a range of text is specified, the contents of the range are deleted.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function SplitParagraphOperation(operationState:SelectionState)
		{
			var para:IParagraphElement = operationState.textFlow.findLeaf(operationState.absoluteStart).getParagraph();
			super(operationState, para);
		}
		
		/** @private */
		public override function merge(operation:FlowOperation):FlowOperation
		{
			if (this.endGeneration != operation.beginGeneration)
				return null;
			// TODO we could probably do something a bit more efficient for a backspace
			if ((operation is SplitParagraphOperation) || (operation is InsertTextOperation))
				return new CompositeOperation([this,operation]);
			return null;
		}
	}
}
