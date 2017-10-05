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
package org.apache.royale.text.engine
{
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.text.engine.TextElement;
	import org.apache.royale.text.engine.GroupElement;
	
	public class GroupElement extends ContentElement
	{
		public function GroupElement(elements:Vector.<ContentElement> = null, elementFormat:ElementFormat = null, eventMirror:EventDispatcher = null, textRotation:String = "rotate0")
		{
			super(elementFormat, eventMirror, textRotation);
			if(elements)
			{
				_elements = elements;
				setElementsGroup(this);
			}	
			else
				_elements = new Vector.<ContentElement>();
		}
		public function get elementCount():int
		{
			return _elements.length;
		}
		private var _elements:Vector.<ContentElement>;
		public function getElementAt(index:int):ContentElement
		{
			return _elements[index];
		}
		public function getElementAtCharIndex(charIndex:int):ContentElement
		{
			var curIdx:int = 0;
			var len:int = elementCount;
			for(var i:int=0;i<len;i++)
			{
				curIdx += _elements[i].rawText.length;
				if(curIdx > charIndex)
					return _elements[i];
			}

			return null;
		}
		public function getElementIndex(element:ContentElement):int
		{
			return _elements.indexOf(element);
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
			setElementsGroup(null);
            COMPILE::SWF
            {
                var args:Array = [beginIndex, endIndex-beginIndex];
                // Vectors don't seen to support concat with an array/vector parameter
                if (newElements)
                {
                    for each (var el:ContentElement in newElements)
                        args = args.concat(el);
                }
            }
            COMPILE::JS
            {
    			var args:Array = [beginIndex, endIndex-beginIndex];
				// don't concat null
				if(newElements)
					args = args.concat(newElements);
			// _elements.splice(beginIndex,endIndex-beginIndex);
            }
            _elements.splice.apply(_elements, args);
			setElementsGroup(this);
			return _elements;
		}
		public function setElements(value:Vector.<ContentElement>):void
		{
			_elements = value;
			setElementsGroup(this);
		}
		private function setElementsGroup(group:GroupElement):void
		{
			for(var i:int=0; i<_elements.length; i++)
				_elements[i].groupElement = group;
		}
		public function splitTextElement(elementIndex:int, splitIndex:int):TextElement
		{
			var elem:ContentElement = _elements[elementIndex];
			if(!elem is TextElement)
				throw new Error("Specified element is not a TextElement");
			var textElem:TextElement  = elem as TextElement;
			if(splitIndex >= textElem.rawText.length)
				throw new Error("Split index is out of range");
			var firstText:String = textElem.rawText.substr(0,splitIndex);
			var nextText:String = textElem.rawText.substr(splitIndex);
			var newElem:TextElement = new TextElement(nextText,textElem.elementFormat,textElem.eventMirror,textElem.textRotation);
			textElem.text = firstText;
			newElem.groupElement = this;
			_elements.splice(elementIndex+1,0,newElem);
			
			return newElem;
		}
		public function ungroupElements(groupIndex:int):void
		{
			//TODO
		}
		override public function get rawText():String
		{
			var val:String = "";
			var len:int = elementCount;
			for(var i:int = 0;i<len;i++)
			{
				val += _elements[i].rawText;
			}
			return val;
		}

	}
}
