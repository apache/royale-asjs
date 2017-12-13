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

	public class ContentElement
	{
		public static const GRAPHIC_ELEMENT:uint = 0xFDEF;
		public function ContentElement(elementFormat:ElementFormat = null, eventMirror:EventDispatcher = null, textRotation:String = "rotate0")
		{
			this.elementFormat = elementFormat;
			this.eventMirror = eventMirror;
			this.textRotation = textRotation;
		}
		private var _elementFormat:ElementFormat;
		public function get elementFormat():ElementFormat
		{
			return _elementFormat;
		}
		public function set elementFormat(value:ElementFormat):void
		{
			_elementFormat = value;
		}
		
		public var eventMirror:EventDispatcher;
		
		/**
		 * The parent
		 */
		private var _groupElement:GroupElement;
		public function get groupElement():GroupElement
		{
			if(_groupElement)
				return _groupElement.getElementIndex(this) < 0 ? null : _groupElement;
			return null;
		}
		public function set groupElement(value:GroupElement):void
		{
			_groupElement = value;
		}
		
		public function get rawText() : String
		{
			return null;
		}
		public function get text() : String
		{
			return null;
		}

		private var _textBlock:ITextBlock;
		public function get textBlock():ITextBlock
		{
			if(groupElement)
				return groupElement.textBlock;
			return _textBlock;
		}
		public function set textBlock(value:ITextBlock):void
		{
			_textBlock = value;
		}
		
		public function get textBlockBeginIndex() : int
		{
			return textBlock ? textBlock.getRelativeStart(this) : 0;
		}

		public var textRotation : String
		public var userData : *		
	}
}
