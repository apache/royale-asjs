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
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.ITextFlow;

	public class AddElementMemento extends BaseMemento implements IMemento {
		private var _target:ElementMark;
		private var _targetIndex:int;
		private var _elemToAdd:IFlowElement;

		public function AddElementMemento(textFlow:ITextFlow, elemToAdd:IFlowElement, target:ElementMark, index:int) {
			super(textFlow);
			_target = target;
			_targetIndex = index;
			_elemToAdd = elemToAdd;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		static public function perform(textFlow:ITextFlow, elemToAdd:IFlowElement, parent:IFlowGroupElement, index:int, createMemento:Boolean):* {
			var elem:IFlowElement = elemToAdd;
			if (createMemento)
				elemToAdd = elem.deepCopy();	// for redo

			var target:ElementMark = new ElementMark(parent, 0);

			var targetElement:IFlowGroupElement = target.findElement(textFlow) as IFlowGroupElement;
			targetElement.addChildAt(index, elem);
			if (createMemento)
				return new AddElementMemento(textFlow, elemToAdd, target, index);
			return null;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function undo():* {
			var target:IFlowGroupElement = _target.findElement(_textFlow) as IFlowGroupElement;
			target.removeChildAt(_targetIndex);
		}

		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function redo():* {
			var parent:IFlowGroupElement = _target.findElement(_textFlow) as IFlowGroupElement;
			return perform(_textFlow, _elemToAdd, parent, _targetIndex, false);
		}
	}
}
