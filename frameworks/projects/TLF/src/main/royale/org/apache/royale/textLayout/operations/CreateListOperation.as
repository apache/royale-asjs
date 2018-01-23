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
	import org.apache.royale.textLayout.elements.ElementHelper;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IListElement;
	import org.apache.royale.textLayout.elements.IListItemElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ISubParagraphGroupElementBase;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;

	/**
	 * The CreateListOperation class encapsulates creating list
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 */
	public class CreateListOperation extends FlowTextOperation
	{
		// describes the target
		private var _listParentMarker:ElementMark;
		private var _mementoList:MementoList;

		private var _listFormat:ITextLayoutFormat;
		private var _listElement:IListElement;		// the element that gets created
		
		private var _postOpSelectionState:SelectionState;
		
		/** 
		 * Creates an CreateListOperation object.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public function CreateListOperation(operationState:SelectionState, parent:IFlowGroupElement = null, listFormat:ITextLayoutFormat = null)
		{
			super(operationState);
			
			this.parent = parent;
			_listFormat = listFormat;
			_mementoList = new MementoList(operationState.textFlow);
		}
		
		/** 
		 * Specifies the element this operation adds a new IListElement to.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function get parent():IFlowGroupElement
		{
			return _listParentMarker ? _listParentMarker.findElement(originalSelectionState.textFlow) as IFlowGroupElement : null;
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function set parent(value:IFlowGroupElement):void
		{
			if (!value)
			{
				// descend to the lowest level non-paragraph element that contains both positions
				// effectively make the new list as close to the spans as possible
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
			
			_listParentMarker = new ElementMark(value,0);
		}

		/** TextLayoutFormat to be applied to the new IListElement. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */	
		public function get listFormat():ITextLayoutFormat
		{ return _listFormat; }
		public function set listFormat(value:ITextLayoutFormat):void
		{ _listFormat = value; }
		
		/** The new IListElement. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */	
		public function get newListElement():IListElement
		{ return _listElement; }
		
		/**
		 *  @private
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public override function doOperation():Boolean
		{
			var target:IFlowGroupElement = parent;
			
			// find the starting child that's going to be in the list and 
			var begChildIndex:int = 0;
			var begStart:int = absoluteStart - target.getAbsoluteStart();
			CONFIG::debug { assert(begStart >= 0 && begStart < target.textLength,"CreateListOperation: bad target"); }
			
			var endChildIndex:int;
			var endStart:int = absoluteEnd - target.getAbsoluteStart();
			CONFIG::debug { assert(endStart >= 0 && endStart <= target.textLength,"CreateListOperation: bad target"); }
			
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
			
			_listElement = ElementHelper.getList();
			_listElement.format = listFormat;
			
			var listItem:IListItemElement;
			
			if (begChildIndex == target.numChildren)
			{
				// new list at the end of target
				child = target.getChildAt(target.numChildren-1) as IFlowGroupElement;
				
				_mementoList.push(ModelEdit.splitElement(textFlow,child,child.textLength));
				_mementoList.push(ModelEdit.addElement(textFlow,_listElement,target,target.numChildren));

				if (!(child is IListItemElement))
				{
					listItem = ElementHelper.getListItem();	// NO PMD
					_mementoList.push(ModelEdit.addElement(textFlow,listItem,_listElement,_listElement.numChildren));
					_mementoList.push(ModelEdit.moveElement(textFlow,child,listItem,listItem.numChildren));
					// normalize does this
					if (listItem.normalizeNeedsInitialParagraph())
						_mementoList.push(ModelEdit.addElement(textFlow,ElementHelper.getParagraph(),listItem,0));
				}
				else
					_mementoList.push(ModelEdit.moveElement(textFlow,child,_listElement,_listElement.numChildren));
			}
			else
			{
				_mementoList.push(ModelEdit.addElement(textFlow,_listElement,target,endChildIndex));
				
				// normalize does this
				if ((target is IListItemElement) && (target as IListItemElement).normalizeNeedsInitialParagraph())
				{
					_mementoList.push(ModelEdit.addElement(textFlow,ElementHelper.getParagraph(),target,0));
					begChildIndex++;
					endChildIndex++;
				}

				if (begChildIndex == endChildIndex)
				{
					listItem = ElementHelper.getListItem();	// No PMD
					_mementoList.push(ModelEdit.addElement(textFlow,listItem,_listElement,0));
					_mementoList.push(ModelEdit.addElement(textFlow,ElementHelper.getParagraph(),listItem,0));					
				}
				else
				{
					while (begChildIndex < endChildIndex)
					{
						child = target.getChildAt(begChildIndex) as IFlowGroupElement;
						if (child is IListItemElement)
						{
							listItem = child as IListItemElement;
							_mementoList.push(ModelEdit.moveElement(textFlow,listItem,_listElement,_listElement.numChildren));
							if (!(listItem.getChildAt(0) is IParagraphElement))
								_mementoList.push(ModelEdit.addElement(textFlow,ElementHelper.getParagraph(),listItem,0));
						}
						else
						{
							listItem = ElementHelper.getListItem();	// No PMD
							_mementoList.push(ModelEdit.addElement(textFlow,listItem,_listElement,_listElement.numChildren));
							_mementoList.push(ModelEdit.moveElement(textFlow,child,listItem,listItem.numChildren));
							// normalize does this
							if (listItem.normalizeNeedsInitialParagraph())
								_mementoList.push(ModelEdit.addElement(textFlow,ElementHelper.getParagraph(),listItem,0));
	
							child = listItem;
						}
						child.normalizeRange(0,child.textLength);
						endChildIndex--;
					}
				}
				// normalize does this
				var testListItem:IListItemElement = target as IListItemElement;
				if (testListItem && testListItem.normalizeNeedsInitialParagraph())
					_mementoList.push(ModelEdit.addElement(textFlow,ElementHelper.getParagraph(),testListItem,0));
				testListItem = target.parent as IListItemElement;
				if (testListItem && testListItem.normalizeNeedsInitialParagraph())
					_mementoList.push(ModelEdit.addElement(textFlow,ElementHelper.getParagraph(),testListItem,0));
			}
			
			if (originalSelectionState.selectionManagerOperationState && textFlow.interactionManager)
			{
				textFlow.normalize();
				_postOpSelectionState = new SelectionState(textFlow,_listElement.getAbsoluteStart(),_listElement.getAbsoluteStart()+_listElement.textLength-1);
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
