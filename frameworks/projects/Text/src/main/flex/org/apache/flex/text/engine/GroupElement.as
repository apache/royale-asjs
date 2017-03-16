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
package org.apache.flex.text.engine
{
	import org.apache.flex.events.EventDispatcher;
	
	public class GroupElement extends ContentElement
	{
		public function GroupElement(elements:Vector.<ContentElement> = null, elementFormat:ElementFormat = null, eventMirror:EventDispatcher = null, textRotation:String = "rotate0")
		{
			super(elementFormat, eventMirror, textRotation);
		}
		private var _elementCount:int=0;
		public function get elementCount():int
		{
			return _elementCount;
		}

		public function getElementAt(index:int):ContentElement
		{
			return null;
		}
		public function getElementAtCharIndex(charIndex:int):ContentElement
		{
			return null;
		}
		public function getElementIndex(element:ContentElement):int
		{
			return -1;
		}
		public function groupElements(beginIndex:int, endIndex:int):GroupElement
		{
			return null;
		}
		public function mergeTextElements(beginIndex:int, endIndex:int):TextElement
		{
			return null;
		}
		public function replaceElements(beginIndex:int, endIndex:int, newElements:Vector.<ContentElement>):Vector.<ContentElement>
		{
			return null;
		}
		public function setElements(value:Vector.<ContentElement>):void
		{
			//TODO
		}
		public function splitTextElement(elementIndex:int, splitIndex:int):TextElement
		{
			return null;
		}
		public function ungroupElements(groupIndex:int):void
		{
			//TODO
		}

	}
}