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
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.edit.ElementMark;
	import org.apache.royale.textLayout.edit.MementoList;
	import org.apache.royale.textLayout.edit.ModelEdit;
	import org.apache.royale.textLayout.edit.SelectionState;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ISpanElement;
	import org.apache.royale.textLayout.elements.SubParagraphGroupElement;
	import org.apache.royale.textLayout.elements.ISubParagraphGroupElementBase;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;




	/**
	 * The CreateSPGEOperation class encapsulates creating a SubPargraphGroupElement
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class CreateSubParagraphGroupOperation extends FlowTextOperation
	{
		// describes the target
		private var _spgeParentMarker:ElementMark;
		private var _format:ITextLayoutFormat;

		private var _mementoList:MementoList;

		// the element that gets created
		private var _spgeElement:SubParagraphGroupElement;		
		private var _postOpSelectionState:SelectionState;
		
		/** 
		 * Constructor.
		 * 
		 * This operation creates a single SubParagraphGroupElement in the first paragraph of the selection range.  That paragraph must have at least one character selected the paragraph terminator does not count towards that selection.
		 * Specifying the spgeParent creates an SubParagraphGroupElement int he part of the selection range included by that spgeParent.
		 * 
		 * @param operationState selection over which to apply the operation.  
		 * @param spgeParent optional parent for the spge element.  If not specified one is chosen based on the selection
		 * @param spgeFormat optional format to set in the new spge element.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function CreateSubParagraphGroupOperation(operationState:SelectionState, parent:IFlowGroupElement = null, format:ITextLayoutFormat = null)
		{
			super(operationState);
			
			_format = format;
			this.parent = parent;
			_mementoList = new MementoList(operationState.textFlow);
		}
		
		/** 
		 * Specifies the element this operation modifies.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function get parent():IFlowGroupElement
		{
			return _spgeParentMarker ? _spgeParentMarker.findElement(originalSelectionState.textFlow) as IFlowGroupElement : null;
		}
		public function set parent(value:IFlowGroupElement):void
		{
			if (!value)
			{
				// descend to the lowest level non-paragraph element that contains both positions
				// effectively make the new spge as close to the spans as possible
				
				var begPos:int = this.absoluteStart;
				var endPos:int = this.absoluteEnd;
				
				// start with the ParagraphElement
				var para:IParagraphElement = textFlow.findLeaf(begPos).getParagraph();
				var paraStart:int = para.getAbsoluteStart();
				
				// can't be just the terminator
				if (begPos < paraStart+para.textLength-1)
				{
					// Only work in this ParagraphElement - include the terminator if it was excluded
					if (endPos >= paraStart+para.textLength-1)
						endPos = paraStart+para.textLength;
					
					value = para;
					
					for (;;)
					{
						var begChildIdx:int = value.findChildIndexAtPosition(begPos);
						var elem:IFlowGroupElement = value.getChildAt(begChildIdx) as IFlowGroupElement;
						if (elem == null)
							break;
						begPos -= elem.parentRelativeStart;
						endPos -= elem.parentRelativeStart;
						if (endPos > elem.textLength)	// end pos is in the next element.  can be at the beginning
							break;
						value = elem;
					}
				}
			}
			else if (!(value is ISubParagraphGroupElementBase) || !(value is IParagraphElement))
				value = null;
			
			_spgeParentMarker = value ? new ElementMark(value,0) : null;
		}
		
		/** Format to be applied to the new SubParagraphGroupElement
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */		
		public function get format():ITextLayoutFormat
		{ return _format; }
		public function set format(value:ITextLayoutFormat):void
		{ _format = value; }
		
		/** The new SubParagraphGroupElement. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */	
		public function get newSubParagraphGroupElement():SubParagraphGroupElement
		{ return _spgeElement; }
		
		/**
		 *  @private
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.ISpanElement
		 */
		public override function doOperation():Boolean
		{
			if (absoluteStart == absoluteEnd)
				return false;
			
			var target:IFlowGroupElement = this.parent;
			if (!target)
				return false;
			
			// find the starting child that's going to be in the list and 
			var begChildIndex:int = 0;
			var begStart:int = absoluteStart - target.getAbsoluteStart();
			CONFIG::debug { assert(begStart >= 0 && begStart < target.textLength,"CreateSPGEOperation: bad target"); }
			
			var endChildIndex:int;
			var endStart:int = absoluteEnd - target.getAbsoluteStart();
			if (endStart >= target.getAbsoluteStart()+target.textLength-1)
				endStart = target.getAbsoluteStart()+target.textLength;
			
			// scratch vars
			var child:IFlowElement;
			
			if (begStart > 0)
			{
				// figure out the starting child
				begChildIndex = target.findChildIndexAtPosition(begStart);
				child = target.getChildAt(begChildIndex);
				if (child.parentRelativeStart != begStart)
				{				
					if (child is IFlowGroupElement)
						_mementoList.push(ModelEdit.splitElement(textFlow,child as IFlowGroupElement,begStart-child.parentRelativeStart));
					else
						child.splitAtPosition(begStart-child.parentRelativeStart);
					begChildIndex++;
				}
			}
			
			if (endStart >= 0)
			{
				if (endStart >= target.textLength - 1)
				{
					endChildIndex = target.numChildren;
					// if last element in target is a span with just a terminator than go before it
					if (endChildIndex != 0)
					{
						var lastChild:IFlowElement = target.getChildAt(endChildIndex-1);
						if (lastChild is ISpanElement && lastChild.textLength == 1 && (lastChild as ISpanElement).hasParagraphTerminator)
							endChildIndex--;
					}
				}
				else
				{
					// figure out the starting child
					endChildIndex = target.findChildIndexAtPosition(endStart);
					child = target.getChildAt(endChildIndex);
					if (child.parentRelativeStart != endStart)			
					{
						if (child is IFlowGroupElement)
							_mementoList.push(ModelEdit.splitElement(textFlow,child as IFlowGroupElement,endStart-child.parentRelativeStart));
						else
							child.splitAtPosition(endStart-child.parentRelativeStart);
						endChildIndex++;
					}
				}
			}
			else
				endChildIndex = begChildIndex+1;
			
			_spgeElement = new SubParagraphGroupElement;
			_spgeElement.format = format;
			
			
			CONFIG::debug { assert(begChildIndex != target.numChildren,"Invalid begChildIndex in CreateSPGEOperation"); }

			_mementoList.push(ModelEdit.addElement(textFlow,_spgeElement,target,endChildIndex));
			{
				while (begChildIndex < endChildIndex)
				{
					child = target.getChildAt(begChildIndex);
					if (child.textLength == 0)
					{
						// skip it
						begChildIndex++;
					}
					else
					{
						_mementoList.push(ModelEdit.moveElement(textFlow,child,_spgeElement,_spgeElement.numChildren));
						endChildIndex--;
					}
				}
			}
			
			if (originalSelectionState.selectionManagerOperationState && textFlow.interactionManager)
			{
				textFlow.normalize();
				_postOpSelectionState = new SelectionState(textFlow,_spgeElement.getAbsoluteStart(),_spgeElement.getAbsoluteStart()+_spgeElement.textLength);
				textFlow.interactionManager.setSelectionState(_postOpSelectionState);
			}
			
			return true;
		}

		/** @private */
		public override function undo():SelectionState
		{
			_mementoList.undo();
			return originalSelectionState; 
		}
		
		/** @private */
		public override function redo():SelectionState
		{
			_mementoList.redo();
			return _postOpSelectionState; 
		}
	}
}
