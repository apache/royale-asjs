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
	
	public class TextElement extends ContentElement
	{
		public function TextElement(text:String = null, elementFormat:ElementFormat = null, eventMirror:EventDispatcher = null, textRotation:String = "rotate0")
		{
			this.text = text;
			super(elementFormat, eventMirror, textRotation);
		}
		private var _text:String;
		override public function get text():String
		{
			return _text;
		}
		public function set text(value:String):void
		{
			_text = value;
			resetGlyphs();
			resetText();
		}

		override public function get rawText():String
		{
			return _text;
		}
		override public function set elementFormat(value:ElementFormat):void
		{
			super.elementFormat = value;
			resetGlyphs();
			resetText();
		}
		private function resetGlyphs():void
		{
			if(glyphs)
				glyphs = null;
			lastComposed = -1;
		}
		
		private function resetText():void
		{
			if(words)
				words = null;
		}
		public function replaceText(beginIndex:int, endIndex:int, newText:String):void
		{
            if (_text == null)
                _text = newText;
            else
            {
    			var b:String = _text.substring(0,beginIndex);
    			var e:String = _text.substring(endIndex);
    			_text = b + newText + e;
            }
			resetGlyphs();
			resetText();
		}

		/**
		* @private This is for the Text Engine to store internal glyph data as the text is being composed.
		* This should not be used by client code. The text engine should clean up after itself.
		*/
		public var glyphs:Array;

		/**
		* @private To track which glyph we broke the text on
		*/
		public var lastComposed:int = -1;

		/**
		* @private
		*/
		public var words:Array;

		/**
		* @private
		*/
		public var wordWidths:Array;


	}
}
