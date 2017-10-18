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
package org.apache.royale.textLayout.edit.mementos {
	import org.apache.royale.textLayout.edit.ElementMark;
	import org.apache.royale.textLayout.edit.IMemento;
	import org.apache.royale.textLayout.edit.TextFlowEdit;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.ITextFlow;

	public class JoinMemento extends BaseMemento implements IMemento {
		private var _element1:ElementMark;
		private var _element2:ElementMark;
		private var _joinPosition:int;
		private var _removeParentChain:IMemento;

		public function JoinMemento(textFlow:ITextFlow, element1:ElementMark, element2:ElementMark, joinPosition:int, removeParentChain:IMemento) {
			super(textFlow);
			_element1 = element1;
			_element2 = element2;
			_joinPosition = joinPosition;
			_removeParentChain = removeParentChain;
		}

		static public function perform(textFlow:ITextFlow, element1:IFlowGroupElement, element2:IFlowGroupElement, createMemento:Boolean):* {
			var joinPosition:int = element1.textLength - 1;

			var element1Mark:ElementMark = new ElementMark(element1, 0);
			var element2Mark:ElementMark = new ElementMark(element2, 0);
			performInternal(textFlow, element1Mark, element2Mark);
			var removeParentChain:IMemento = TextFlowEdit.removeEmptyParentChain(element2);

			if (createMemento) {
				return new JoinMemento(textFlow, element1Mark, element2Mark, joinPosition, removeParentChain);
			}

			return null;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		static public function performInternal(textFlow:ITextFlow, element1Mark:ElementMark, element2Mark:ElementMark):void {
			var element1:IFlowGroupElement = element1Mark.findElement(textFlow) as IFlowGroupElement;
			var element2:IFlowGroupElement = element2Mark.findElement(textFlow) as IFlowGroupElement;

			moveChildren(element2, element1);
		}

		static private function moveChildren(elementSource:IFlowGroupElement, elementDestination:IFlowGroupElement):void {
			// move children of elementSource to end of elementDestination
			var childrenToMove:Array = elementSource.mxmlChildren;
			elementSource.replaceChildren(0, elementSource.numChildren);
			elementDestination.replaceChildren(elementDestination.numChildren, elementDestination.numChildren, childrenToMove);
		}

		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function undo():* {
			_removeParentChain.undo();

			var element1:IFlowGroupElement = _element1.findElement(_textFlow) as IFlowGroupElement;
			var element2:IFlowGroupElement = _element2.findElement(_textFlow) as IFlowGroupElement;
			var tmpElement:IFlowGroupElement = element1.splitAtPosition(_joinPosition) as IFlowGroupElement;
			// everything after the split moves to element2
			moveChildren(tmpElement, element2);
			tmpElement.parent.removeChild(tmpElement);
		}

		public function redo():* {
			performInternal(_textFlow, _element1, _element2);
			_removeParentChain.redo();
		}
	}
}
