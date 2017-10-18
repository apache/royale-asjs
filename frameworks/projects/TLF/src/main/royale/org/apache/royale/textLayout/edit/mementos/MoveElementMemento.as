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

	public class MoveElementMemento extends BaseMemento implements IMemento {
		private var _target:ElementMark;
		private var _targetIndex:int;
		private var _elemBeforeMove:ElementMark;
		private var _elemAfterMove:ElementMark;
		private var _source:ElementMark;		// original parent
		private var _sourceIndex:int; 			// original index

		public function MoveElementMemento(textFlow:ITextFlow, elemBeforeMove:ElementMark, elemAfterMove:ElementMark, target:ElementMark, targetIndex:int, source:ElementMark, sourceIndex:int) {
			super(textFlow);
			_elemBeforeMove = elemBeforeMove;
			_elemAfterMove = elemAfterMove;
			_target = target;
			_targetIndex = targetIndex;
			_source = source;
			_sourceIndex = sourceIndex;
		}

		static public function perform(textFlow:ITextFlow, elem:IFlowElement, newParent:IFlowGroupElement, newIndex:int, createMemento:Boolean):* {
			var target:ElementMark = new ElementMark(newParent, 0);
			var elemBeforeMove:ElementMark = new ElementMark(elem, 0);

			var source:IFlowGroupElement = elem.parent;
			var sourceIndex:int = source.getChildIndex(elem);
			var sourceMark:ElementMark = new ElementMark(source, 0);

			newParent.addChildAt(newIndex, elem);
			if (createMemento)
				return new MoveElementMemento(textFlow, elemBeforeMove, new ElementMark(elem, 0), target, newIndex, sourceMark, sourceIndex);
			return elem;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function undo():* {
			var elem:IFlowElement = _elemAfterMove.findElement(_textFlow);
			elem.parent.removeChildAt(elem.parent.getChildIndex(elem));
			var source:IFlowGroupElement = _source.findElement(_textFlow) as IFlowGroupElement;
			source.addChildAt(_sourceIndex, elem);
		}

		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function redo():* {
			var target:IFlowGroupElement = _target.findElement(_textFlow) as IFlowGroupElement;
			var elem:IFlowElement = _elemBeforeMove.findElement(_textFlow) as IFlowElement;
			return perform(_textFlow, elem, target, _targetIndex, false);
		}
	}
}
