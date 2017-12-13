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
package org.apache.royale.text.html
{
	import org.apache.royale.text.engine.ContentElement;
	import org.apache.royale.text.engine.FontDescription;
	import org.apache.royale.text.engine.ITextBlock;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.text.engine.TabStop;
	import org.apache.royale.text.engine.TextJustifier;
	import org.apache.royale.text.engine.ITextFactory;
	import org.apache.royale.text.engine.TextElement;
	import org.apache.royale.text.engine.ElementFormat;
	import org.apache.royale.text.html.TextLine;
	import org.apache.royale.html.elements.Span;
	
	import org.apache.royale.core.IParent;
	
	public class TextBlock implements ITextBlock
	{
		public function TextBlock(factory:ITextFactory)
		{
			_textFactory = factory;
		}
		private var _textFactory:ITextFactory;
		public function get textFactory():ITextFactory
		{
			return _textFactory;
		}
		private var _applyNonLinearFontScaling:Boolean;
		public function get applyNonLinearFontScaling():Boolean
		{
			return _applyNonLinearFontScaling;
		}
		public function set applyNonLinearFontScaling(value:Boolean):void
		{
			_applyNonLinearFontScaling = value;
		}

		private var _baselineFontDescription:FontDescription;
		public function get baselineFontDescription():FontDescription
		{
			return _baselineFontDescription;
		}
		public function set baselineFontDescription(value:FontDescription):void
		{
			_baselineFontDescription = value;
		}
		private var _baselineFontSize:Number = 12;
		public function get baselineFontSize():Number
		{
			return _baselineFontSize;
		}
		public function set baselineFontSize(value:Number):void
		{
			_baselineFontSize = value;
		}
		
		private var _baselineZero:String = "roman";
		public function get baselineZero():String
		{
			return _baselineZero;
		}
		public function set baselineZero(value:String):void
		{
			_baselineZero = value;
		}
		
		private var _bidiLevel:int;
		public function get bidiLevel():int
		{
			return _bidiLevel;
		}
		public function set bidiLevel(value:int):void
		{
			_bidiLevel = value;
		}
		
		private var _content:ContentElement;
		public function get content():ContentElement
		{
			return _content;
		}
		public function set content(value:ContentElement):void
		{
			_content = value;
		}

		private var _firstInvalidLine:ITextLine;
		public function get firstInvalidLine():ITextLine
		{
			return _firstInvalidLine;
		}
		public function set firstInvalidLine(value:ITextLine):void
		{
			_firstInvalidLine = value;
		}

		private var _firstLine:ITextLine;
		public function get firstLine():ITextLine
		{
			return _firstLine;
		}
		public function set firstLine(value:ITextLine):void
		{
			_firstLine = value;
		}

		private var _lastLine:ITextLine;
		public function get lastLine():ITextLine
		{
			return _lastLine;
		}
		public function set lastLine(value:ITextLine):void
		{
			_lastLine = value;
		}

		private var _lineRotation:String;
		public function get lineRotation():String
		{
			return _lineRotation;
		}
		public function set lineRotation(value:String):void
		{
			_lineRotation = value;
		}
		
		private var _tabStops:Vector.<TabStop>;
		public function get tabStops():Vector.<TabStop>
		{
			return _tabStops;
		}
		public function set tabStops(value:Vector.<TabStop>):void
		{
			_tabStops = value;
		}

		private var _textJustifier:TextJustifier;
		public function get textJustifier():TextJustifier
		{
			return _textJustifier;
		}
		public function set textJustifier(value:TextJustifier):void
		{
			_textJustifier = value;
		}
		
		private var _textLineCreationResult:String;
		public function get textLineCreationResult():String
		{
			return _textLineCreationResult;
		}
		public function set textLineCreationResult(value:String):void
		{
			_textLineCreationResult = value;
		}
		
		private var _userData:*;
		public function get userData():*
		{
			return _userData;
		}
		public function set userData(value:*):void
		{
			_userData = value;
		}
		
		private var lines:Array = [];
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.IParent
		 */
		public function createTextLine(previousLine:ITextLine = null, width:Number = 1000000, lineOffset:Number = 0.0, fitSomething:Boolean = false):ITextLine
		{
			if (previousLine == null)
				lines.length = 0;
			// Not a very good implementation at this point...
			var textElem:TextElement = content as TextElement;
			var format:ElementFormat = content.elementFormat;
			var tl:TextLine = new TextLine(this, previousLine ? previousLine.textBlockBeginIndex + previousLine.rawTextLength : 0);
			COMPILE::SWF
			{
				var s:String = content.text;
				if (previousLine)
				    s = s.substring(previousLine.textBlockBeginIndex + previousLine.rawTextLength);
				if (s.length == 0)
				  return null;
				tl.textField.text = s;
				tl.textField.width = width;
				if (tl.textField.numLines > 1)
				{
					s = tl.textField.getLineText(0);
					tl.textField.text = s;
					tl.textField.multiline = false;
				}
				lines.push(tl);
			}
			COMPILE::JS
			{
				textFactory.currentContainer.addElement(tl); // add to DOM early so textWidth is valid
				var span:Span = new Span();
				span.text = textElem.text;
				//span.element.style.display = "block";
				tl.addElement(span);
				lines.push(tl);
			}
			if (previousLine == null)
				_firstLine = tl;
			_lastLine = tl;
			return tl;
		}
		public function dump():String{
			return null;
		}
		public function findNextAtomBoundary(afterCharIndex:int):int
		{
			return afterCharIndex + 1;
		}
		public function findNextWordBoundary(afterCharIndex:int):int
		{
			trace("findNextWordBoundary not implemented");
			return 0;
		}
		public function findPreviousAtomBoundary(beforeCharIndex:int):int
		{
			return beforeCharIndex - 1;
		}
		public function findPreviousWordBoundary(beforeCharIndex:int):int
		{
			trace("findPreviousWordBoundary not implemented");
			return 0;
		}
		public function getTextLineAtCharIndex(charIndex:int):ITextLine
		{
			var lineIndex:int = 0;
			for each (var line:TextLine in lines)
			{
				COMPILE::SWF
				{
				lineIndex += line.textField.text.length;
				}
				COMPILE::JS
				{
				lineIndex += line.element.firstChild.textContent.length;
				}
				if (lineIndex > charIndex)
				  	return line;
				
			}
			return null;
		}
		public function recreateTextLine(textLine:ITextLine, previousLine:ITextLine = null, width:Number = 1000000, lineOffset:Number = 0.0, fitSomething:Boolean = false):ITextLine
		{
			trace("recreateTextLine not implemented");
			return null;
		}
		public function releaseLineCreationData():void
		{
			//what to do...
		}
		public function releaseLines(firstLine:ITextLine, lastLine:ITextLine):void
		{
			lines.length = 0;
		}
		public function getRelativeStart(element:ContentElement):int
		{
			return 0;
		}

	}
}
