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
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.ITextFlow;

	public class RemoveElementsMemento extends BaseMemento implements IMemento {
		private var _elements:Array;
		private var _elemParent:ElementMark;
		private var _startIndex:int;
		private var _numElements:int;

		/**
		 * RemoveElements from the ITextFlow,
		 * @param parent parent of elements to rmeove
		 * @param startIndex index of first child to remove
		 * @param numElements number of elements to remove
		 */
		public function RemoveElementsMemento(textFlow:ITextFlow, elementParent:ElementMark, startIndex:int, numElements:int, elements:Array) {
			super(textFlow);
			_elemParent = elementParent;
			_startIndex = startIndex;
			_numElements = numElements;
			_elements = elements;
		}

		static public function perform(textFlow:ITextFlow, parent:IFlowGroupElement, startIndex:int, numElements:int, createMemento:Boolean):* {
			var elemParent:ElementMark = new ElementMark(parent, 0);

			// hold on to elements for undo
			var elements:Array = parent.mxmlChildren.slice(startIndex, startIndex + numElements);
			// now remove them
			parent.replaceChildren(startIndex, startIndex + numElements);
			if (createMemento)
				return new RemoveElementsMemento(textFlow, elemParent, startIndex, numElements, elements);
			return elements;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function undo():* {
			var parent:IFlowGroupElement = _elemParent.findElement(_textFlow) as IFlowGroupElement;
			parent.replaceChildren(_startIndex, _startIndex, _elements);
			_elements = null;	// release the saved elements array
			return parent.mxmlChildren.slice(_startIndex, _startIndex + _numElements);
		}

		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function redo():* {
			var parent:IFlowGroupElement = _elemParent.findElement(_textFlow) as IFlowGroupElement;
			_elements = perform(_textFlow, parent, _startIndex, _numElements, false);
		}
	}
}
