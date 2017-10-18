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
package org.apache.royale.textLayout.edit.mementos
{
	import org.apache.royale.textLayout.edit.ElementMark;
	import org.apache.royale.textLayout.edit.IMemento;
	import org.apache.royale.textLayout.edit.ModelEdit;
	import org.apache.royale.textLayout.elements.FlowGroupElement;
	import org.apache.royale.textLayout.elements.IContainerFormattedElement;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.IListItemElement;
	import org.apache.royale.textLayout.elements.IParagraphElement;
	import org.apache.royale.textLayout.elements.ITextFlow;
	import org.apache.royale.textLayout.elements.ElementHelper;

	public class SplitMemento extends BaseMemento implements IMemento {
		private var _mementoList:Array;
		private var _target:ElementMark;

		public function SplitMemento(textFlow:ITextFlow, target:ElementMark, mementoList:Array) {
			super(textFlow);
			_target = target;
			_mementoList = mementoList;
		}

		static public function perform(textFlow:ITextFlow, elemToSplit:IFlowGroupElement, relativePosition:int, createMemento:Boolean):* {
			var target:ElementMark = new ElementMark(elemToSplit, relativePosition);
			var mementoList:Array = [];

			var newChild:IFlowGroupElement = performInternal(textFlow, target, createMemento ? mementoList : null);

			if (createMemento)
				return new SplitMemento(textFlow, target, mementoList);

			return newChild;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IListItemElement
		 */
		static private function testValidLeadingParagraph(elem:IFlowGroupElement):Boolean {
			// listitems have to have the very first item as a paragraph
			if (elem.className == "ListItemElement")
				return !(elem as IListItemElement).normalizeNeedsInitialParagraph();

			while (elem && !(elem.className == "ParagraphElement"))
				elem = elem.getChildAt(0) as IFlowGroupElement;
			return elem.className == "ParagraphElement";
		}

		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		static public function performInternal(textFlow:ITextFlow, target:ElementMark, mementoList:Array):FlowGroupElement {
			// split all the way up the chain and then do a move
			var targetElement:IFlowGroupElement = target.findElement(textFlow) as IFlowGroupElement;
			var child:IFlowGroupElement = (target.elemStart == targetElement.textLength ? targetElement.getLastLeaf() : targetElement.findLeaf(target.elemStart)).parent;
			var newChild:FlowGroupElement;

			var splitStart:int = target.elemStart;
			var memento:IMemento;

			for (;;) {
				var splitPos:int = splitStart - (child.getAbsoluteStart() - targetElement.getAbsoluteStart());
				// if (splitPos != 0)
				{
					var splitMemento:InternalSplitFGEMemento = InternalSplitFGEMemento.perform(textFlow, child, splitPos, true);
					if (mementoList)
						mementoList.push(splitMemento);
					newChild = splitMemento.newSibling;

					if (child is IParagraphElement && !(target.elemStart == targetElement.textLength)) {
						// count the terminator
						splitStart++;
					} else if (child is IContainerFormattedElement) {
						// if its a IContainerFormattedElement there needs to be a paragraph at position zero on each side
						if (!testValidLeadingParagraph(child)) {
							memento = ModelEdit.addElement(textFlow, ElementHelper.getParagraph(), child, 0);
							if (mementoList)
								mementoList.push(memento);
							splitStart++;
						}
						if (!testValidLeadingParagraph(newChild)) {
							memento = ModelEdit.addElement(textFlow, ElementHelper.getParagraph(), newChild, 0);
							if (mementoList)
								mementoList.push(memento);
						}
					}
				}
				if (child == targetElement)
					break;
				child = child.parent;
			}

			return newChild;
		}

		public function undo():* {
			_mementoList.reverse();
			for each (var memento:IMemento in  _mementoList)
				memento.undo();
			_mementoList.reverse();
		}

		public function redo():* {
			return performInternal(_textFlow, _target, null);
		}
	}
}
