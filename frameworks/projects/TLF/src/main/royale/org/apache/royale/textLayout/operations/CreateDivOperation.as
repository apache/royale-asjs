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
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.edit.ElementMark;
	import org.apache.royale.textLayout.edit.MementoList;
	import org.apache.royale.textLayout.edit.ModelEdit;
	import org.apache.royale.textLayout.edit.SelectionState;
	import org.apache.royale.textLayout.elements.DivElement;
	import org.apache.royale.textLayout.elements.IDivElement;
	import org.apache.royale.textLayout.elements.ElementHelper;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IListItemElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ISubParagraphGroupElementBase;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;

	/**
	 * The CreateDivOperation class encapsulates creating IDivElement
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class CreateDivOperation extends FlowTextOperation
	{
		// describes the target
		private var _divParentMarker:ElementMark;
		private var _mementoList:MementoList;

		private var _format:ITextLayoutFormat;
		private var _divElement:IDivElement;		// the element that gets created
		
		private var _postOpSelectionState:SelectionState;
		
		/** 
		 * Creates an CreateDivOperation object.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function CreateDivOperation(operationState:SelectionState, parent:IFlowGroupElement = null, format:ITextLayoutFormat = null)
		{
			super(operationState);
			
			this.parent = parent;
			_format = format;
			_mementoList = new MementoList(operationState.textFlow);
		}
		
		/** 
		 * Specifies the parent element for the new IDivElement
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function get parent():IFlowGroupElement
		{
			return _divParentMarker ? _divParentMarker.findElement(originalSelectionState.textFlow) as IFlowGroupElement : null;
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function set parent(value:IFlowGroupElement):void
		{
			if (!value)
			{
				// descend to the lowest level non-paragraph element that contains both positions
				// effectively make the new div as close to the spans as possible
				value = textFlow;
				
				var begPos:int = this.absoluteStart;
				var endPos:int = this.absoluteEnd;
				for (;;)
				{
					var begChildIdx:int = value.findChildIndexAtPosition(begPos);
					var elem:IFlowGroupElement = value.getChildAt(begChildIdx) as IFlowGroupElement;
					if (elem is IParagraphElement)
						break;
					begPos -= elem.parentRelativeStart;
					endPos -= elem.parentRelativeStart;
					if (endPos >= elem.textLength)	// end pos is in the next element
						break;
					value = elem;
				}
			}
			else if (value is ISubParagraphGroupElementBase)
				value = value.getParagraph().parent;
			
			_divParentMarker = new ElementMark(value,0);
		}
		
		/** TextLayoutFormat to be applied to the new IDivElement. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */	
		public function get format():ITextLayoutFormat
		{ return _format; }
		public function set format(value:ITextLayoutFormat):void
		{ _format = value; }
		
		/** The new IDivElement. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */	
		public function get newDivElement():IDivElement
		{ return _divElement; }
		
		/**
		 *  @private
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public override function doOperation():Boolean
		{
			var target:IFlowGroupElement = parent;
			
			// do nothing if target is a paragraphElement or below
			if (!target || (target is IParagraphElement) || (target is ISubParagraphGroupElementBase))
				return false;
			
			// find the starting child that's going to be in the div and 
			var begChildIndex:int = 0;
			var begStart:int = absoluteStart - target.getAbsoluteStart();
			CONFIG::debug { assert(begStart >= 0 && begStart < target.textLength,"CreateDivOperation: bad target"); }
			
			var endChildIndex:int;
			var endStart:int = absoluteEnd - target.getAbsoluteStart();
			CONFIG::debug { assert(endStart >= 0 && endStart <= target.textLength,"CreateDivOperation: bad target"); }
			
			// scratch vars
			var child:IFlowGroupElement;
			
			if (begStart > 0)
			{
				// figure out the starting child
				begChildIndex = target.findChildIndexAtPosition(begStart);
				child = target.getChildAt(begChildIndex) as IFlowGroupElement;
				if (child.parentRelativeStart != begStart)
				{					
					_mementoList.push(ModelEdit.splitElement(textFlow,child,begStart-child.parentRelativeStart));
					
					if (child is IParagraphElement)
						endStart++;
					begChildIndex++;
				}
			}
			
			if (endStart >= 0)
			{
				if (endStart >= target.textLength - 1)
					endChildIndex = target.numChildren;
				else
				{
					// figure out the starting child
					endChildIndex = target.findChildIndexAtPosition(endStart);
					child = target.getChildAt(endChildIndex) as IFlowGroupElement;
					if (child.parentRelativeStart != endStart)			
					{
						_mementoList.push(ModelEdit.splitElement(textFlow,child,endStart-child.parentRelativeStart));
						endChildIndex++;
					}
				}
			}
			else
				endChildIndex = begChildIndex+1;
			
			_divElement = new DivElement();
			_divElement.format = format;
						
			if (begChildIndex == target.numChildren)
			{
				// new div at the end of target
				child = target.getChildAt(target.numChildren-1) as IFlowGroupElement;
				
				_mementoList.push(ModelEdit.splitElement(textFlow,child,child.textLength));
				_mementoList.push(ModelEdit.addElement(textFlow,_divElement,target,target.numChildren));


				_mementoList.push(ModelEdit.moveElement(textFlow,child,_divElement,_divElement.numChildren));
			}
			else
			{
				_mementoList.push(ModelEdit.addElement(textFlow,_divElement,target,endChildIndex));


				if (begChildIndex == endChildIndex)
				{
					_mementoList.push(ModelEdit.addElement(textFlow,ElementHelper.getParagraph(),_divElement,0));					
				}
				else
				{
					while (begChildIndex < endChildIndex)
					{
						child = target.getChildAt(begChildIndex) as IFlowGroupElement;
						if (child is IListItemElement)
						{
							// move all the children up and delete the IListItemElement
							while (child.numChildren)
								_mementoList.push(ModelEdit.moveElement(textFlow,child.getChildAt(0),_divElement,_divElement.numChildren));
							_mementoList.push(ModelEdit.removeElements(textFlow,target,begChildIndex,1));
						}
						else
						{
							_mementoList.push(ModelEdit.moveElement(textFlow,child,_divElement,_divElement.numChildren));
							child.normalizeRange(0,child.textLength);
						}
						endChildIndex--;
					}
				}
				// normalize does this
				if ((target is IListItemElement) && (target as IListItemElement).normalizeNeedsInitialParagraph())
					_mementoList.push(ModelEdit.addElement(textFlow,ElementHelper.getParagraph(),target,0));
			}
			
			if (originalSelectionState.selectionManagerOperationState && textFlow.interactionManager)
			{
				textFlow.normalize();
				_postOpSelectionState = new SelectionState(textFlow,_divElement.getAbsoluteStart(),_divElement.getAbsoluteStart()+_divElement.textLength-1);
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
