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
	import org.apache.royale.textLayout.debug.Debugging;
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.elements.IFlowElement;
	import org.apache.royale.textLayout.elements.IFlowGroupElement;
	import org.apache.royale.textLayout.elements.ITextFlow;

	// [ExcludeClass]
	/** @private - Marks an element by its position in the hierarchy. */
	public class ElementMark
	{
		/** @private */
		public var _elemStart:int;
		/** @private */
		public var _indexChain:Array;
		CONFIG::debug
		{
			private var _originalElement:String; }
		public function ElementMark(elem:IFlowElement, relativeStartPosition:int)
		{
			_elemStart = relativeStartPosition;
			_indexChain = [];

			CONFIG::debug
			{
				var origElem:IFlowElement = elem; }
			CONFIG::debug
			{
				_originalElement = Debugging.getIdentity(origElem); }

			var p:IFlowGroupElement = elem.parent;
			while (p != null)
			{
				_indexChain.splice(0, 0, p.getChildIndex(elem));
				elem = p;
				p = p.parent;
			}

			CONFIG::debug
			{
				var foundElem:IFlowElement = findElement(origElem.getTextFlow());
				assert(origElem == findElement(origElem.getTextFlow()), "Bad ElementMarker"); 
			}
		}

		public function get elemStart():int
		{
			return _elemStart;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.textLayout.elements.IFlowGroupElement
		 */
		public function findElement(textFlow:ITextFlow):IFlowElement
		{
			var element:IFlowElement = textFlow;
			for each (var idx:int in _indexChain)
				element = (element as IFlowGroupElement).getChildAt(idx);

			CONFIG::debug
			{
				assert(element != null, "ElementMarker:findElement No element found"); }

			return element;
		}
	}
}
