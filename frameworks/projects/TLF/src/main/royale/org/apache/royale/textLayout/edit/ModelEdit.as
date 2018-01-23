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
package org.apache.royale.textLayout.edit
{
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.edit.mementos.AddElementMemento;
	import org.apache.royale.textLayout.edit.mementos.DeleteTextMemento;
	import org.apache.royale.textLayout.edit.mementos.JoinMemento;
	import org.apache.royale.textLayout.edit.mementos.MoveElementMemento;
	import org.apache.royale.textLayout.edit.mementos.RemoveElementsMemento;
	import org.apache.royale.textLayout.edit.mementos.SplitMemento;
	import org.apache.royale.textLayout.edit.mementos.TextRangeMemento;
	import org.apache.royale.textLayout.elements.ElementHelper;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IFlowLeafElement;
	import org.apache.royale.textLayout.elements.IListItemElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ISpanElement;
	import org.apache.royale.textLayout.elements.ITextFlow;

	// [ExcludeClass]
	/** 
	 * The ModelEdit class contains static functions for performing speficic suboperations.  Each suboperation returns a "memento" for undo/redo.
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public class ModelEdit
	{
		public static function splitElement(textFlow:ITextFlow, elemToSplit:IFlowGroupElement, relativePosition:int):IMemento
		{
			return SplitMemento.perform(textFlow, elemToSplit, relativePosition, true);
		}

		public static function joinElement(textFlow:ITextFlow, element1:IFlowGroupElement, element2:IFlowGroupElement):IMemento
		{
			return JoinMemento.perform(textFlow, element1, element2, true);
		}

		public static function addElement(textFlow:ITextFlow, elemToAdd:IFlowElement, parent:IFlowGroupElement, index:int):IMemento
		{
			CONFIG::debug
			{
				assert(elemToAdd.parent == null, "Use moveElement"); }
			return AddElementMemento.perform(textFlow, elemToAdd, parent, index, true);
		}

		public static function moveElement(textFlow:ITextFlow, elemToMove:IFlowElement, parent:IFlowGroupElement, index:int):IMemento
		{
			CONFIG::debug
			{
				assert(elemToMove.parent != null, "Use addElement"); }
			return MoveElementMemento.perform(textFlow, elemToMove, parent, index, true);
		}

		public static function removeElements(textFlow:ITextFlow, elemtToRemoveParent:IFlowGroupElement, startIndex:int, numElements:int):IMemento
		{
			return RemoveElementsMemento.perform(textFlow, elemtToRemoveParent, startIndex, numElements, true);
		}

		public static function deleteText(textFlow:ITextFlow, absoluteStart:int, absoluteEnd:int, createMemento:Boolean):IMemento
		{
			var memento:MementoList;
			var mergePara:IParagraphElement;

			// Special case to see if the whole of the last element of the flow is selected. If so, force the terminator at the end to be deleted
			// so that if there is a list or a div at the end, it will be entirely removed.
			if (absoluteEnd == textFlow.textLength - 1)
			{
				var lastElement:IFlowElement = textFlow.getChildAt(textFlow.numChildren - 1);
				if (absoluteStart <= lastElement.getAbsoluteStart())
					absoluteEnd = textFlow.textLength;
			}

			// Special case for when the last paragraph in the flow is deleted. We clone the last paragraph
			// before letting the delete get processed. This lets whatever hierarchy is associated with the
			// old last paragraph die a natural death, but doesn't leave the flow with no terminator.
			var newLastParagraph:IParagraphElement;
			if (absoluteEnd >= textFlow.textLength)
			{
				var lastSpan:IFlowLeafElement = textFlow.getLastLeaf();
				var lastParagraph:IParagraphElement = lastSpan.getParagraph();
				newLastParagraph = ElementHelper.getParagraph();
				var newLastSpan:ISpanElement = ElementHelper.getSpan();
				newLastParagraph.replaceChildren(0, 0, newLastSpan);
				newLastParagraph.format = lastParagraph.format;
				newLastSpan.format = lastSpan.format;
				absoluteEnd = textFlow.textLength;
			}

			if (createMemento)
			{
				memento = new MementoList(textFlow);
				if (newLastParagraph)
					memento.push(addElement(textFlow, newLastParagraph, textFlow, textFlow.numChildren));
				var deleteTextMemento:DeleteTextMemento = new DeleteTextMemento(textFlow, absoluteStart, absoluteEnd);
				memento.push(deleteTextMemento);

				mergePara = TextFlowEdit.deleteRange(textFlow, absoluteStart, absoluteEnd);
				memento.push(TextFlowEdit.joinNextParagraph(mergePara, false));
				checkNormalize(textFlow, deleteTextMemento.commonRoot, memento);
			}
			else
			{
				if (newLastParagraph)
					textFlow.replaceChildren(textFlow.numChildren, textFlow.numChildren, newLastParagraph);
				mergePara = TextFlowEdit.deleteRange(textFlow, absoluteStart, absoluteEnd);
				TextFlowEdit.joinNextParagraph(mergePara, false);
			}

			if (textFlow.interactionManager)
				textFlow.interactionManager.notifyInsertOrDelete(absoluteStart, -(absoluteEnd - absoluteStart));

			return memento;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		private static function checkNormalize(textFlow:ITextFlow, commonRoot:IFlowGroupElement, mementoList:MementoList):void
		{
			if ((commonRoot is IListItemElement) && (commonRoot as IListItemElement).normalizeNeedsInitialParagraph())
			{
				var paragraph:IParagraphElement = ElementHelper.getParagraph();
				paragraph.replaceChildren(0, 0, ElementHelper.getSpan());
				mementoList.push(addElement(textFlow, paragraph, commonRoot, 0));
			}
			for (var index:int = 0; index < commonRoot.numChildren; ++index)
			{
				var child:IFlowGroupElement = commonRoot.getChildAt(index) as IFlowGroupElement;
				if (child)
					checkNormalize(textFlow, child, mementoList);
			}
		}

		public static function saveCurrentState(textFlow:ITextFlow, absoluteStart:int, absoluteEnd:int):IMemento
		{
			return new TextRangeMemento(textFlow, absoluteStart, absoluteEnd);
		}
	}
}
