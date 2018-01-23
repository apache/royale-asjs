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
	COMPILE::SWF
	{
		import flash.display.DisplayObject;
		import flash.text.TextField;
		import flash.text.TextFormat;
		import flash.text.TextFieldAutoSize;
		import flash.geom.Point;
	}
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.geom.Point;
		import org.apache.royale.utils.PointUtils;
	}
	
	import org.apache.royale.text.engine.ElementFormat;
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.text.engine.ITextBlock;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.html.elements.Div;
	
	public class TextLine extends Div implements ITextLine
	{
		COMPILE::SWF
		public var textField:TextField;
		
		public function TextLine(textBlock:ITextBlock, beginIndex:int)
		{
			COMPILE::SWF
			{
				textField = new TextField();
				textField.mouseEnabled = false;
				addChild(textField);
				textField.autoSize = TextFieldAutoSize.LEFT;
				
				// use these to help calculate line breaks
				textField.multiline = true;
				textField.wordWrap = true;
				
				var textFormat:TextFormat = new TextFormat();
				var ef:ElementFormat = textBlock.content.elementFormat;
				textFormat.font = ef.fontDescription.fontName;
				textFormat.size = ef.fontSize;
				textFormat.color = ef.color;
				textField.defaultTextFormat = textFormat;
				
			}
			_textBlock = textBlock;
			_beginIndex = beginIndex;
		}
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
        override protected function createElement():WrappedHTMLElement
		{
			var e:WrappedHTMLElement = super.createElement();
			e.style.position = "absolute";
			return e;
		}
			
		public function get ascent():Number
		{
			COMPILE::SWF
			{
				return textField.getLineMetrics(0).ascent;
			}
			COMPILE::JS
			{
				// needs improvement.  For now assume 2 pixel descent.
				return _textBlock.content.elementFormat.fontSize - 2;
			}
		}
		
		/**
		 * @royaleignorecoercion HTMLElement
		 */
		public function get atomCount():int
		{
			COMPILE::SWF
			{
				return textField.length;
			}
			COMPILE::JS
			{
				return (element.firstChild as HTMLElement).firstChild["length"];
			}
		}
		
		COMPILE::JS
		public function get blendMode():String
		{
			return null;
		}
		
		COMPILE::JS
		public function get cacheAsBitmap():Boolean
		{
			return false;
		}
		
		public function get descent():Number
		{
			COMPILE::SWF
			{
				return textField.getLineMetrics(0).descent;
			}
			COMPILE::JS
			{
				// needs improvement.  For now assume 2 pixel descent.
				return 2;
			}
		}
		
		COMPILE::JS
		private var _doubleClickEnabled:Boolean;
		COMPILE::JS
		public function get doubleClickEnabled():Boolean
		{
			return _doubleClickEnabled;
		}
		COMPILE::JS
		public function set doubleClickEnabled(value:Boolean):void
		{
			_doubleClickEnabled = value;
		}
		
		
		public function get hasGraphicElement():Boolean
		{
			return false;
		}
		
		public function get hasTabs():Boolean
		{
			return false;
		}
		
		public function get nextLine():ITextLine
		{
			return null;
		}
		
		public function get previousLine():ITextLine
		{
			return null;
		}
		
		public function get rawTextLength():int
		{
			COMPILE::SWF
			{
				return textField.length;
			}
			COMPILE::JS
			{
				return atomCount;
			}
		}
		
		public function get specifiedWidth():Number
		{
			return 0;
		}
		
		private var _textBlock:ITextBlock;
		
		public function get textBlock():ITextBlock
		{
			return _textBlock;
		}
		
		private var _beginIndex:int;
		public function get textBlockBeginIndex():int
		{
			return _beginIndex;
		}
		
		/**
		 * @royaleignorecoercion HTMLElement
		 */
		public function get textHeight():Number
		{
			COMPILE::SWF
			{
				return textField.textHeight;
			}
			COMPILE::JS
			{
				return (element.firstChild as HTMLElement).getClientRects()[0].height;
			}
		}
		
		/**
		 * @royaleignorecoercion HTMLElement
		 */
		public function get textWidth():Number
		{
			COMPILE::SWF
			{
				return textField.textWidth;
			}
			COMPILE::JS
			{
				if (element.firstChild.textContent == "\u2029")
				{ 
				  // if para terminator, use nbsp instead
				  (element.firstChild as HTMLElement).innerHTML = "\u00A0";
				  var w:Number = (element.firstChild as HTMLElement).getClientRects()[0].width;
				  (element.firstChild as HTMLElement).innerHTML = "\u2029";
				  return w;
				}
				return (element.firstChild as HTMLElement).getClientRects()[0].width;
			}
		}
		
		public function get totalAscent():Number
		{
			return ascent;
		}
		
		public function get totalDescent():Number
		{
			return descent;
		}
		
		public function get totalHeight():Number
		{
			return textHeight;
		}
		
		public function get unjustifiedTextWidth():Number
		{
			return textWidth;
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
		
		private var _validity:String = "valid";
		public function get validity():String
		{
			return _validity;
		}
		public function set validity(value:String):void
		{
			_validity = value;
		}
		
		/**
		 * Not sure if we need this.
		 */
		public function dump():String
		{
			return "";
		}

		/**
		 * Gets the bidirectional level of the atom at the specified index.
		 * The FTE system seems to make no sense. Here's the "explanation":
		 *
		 * Gets the bidirectional level of the atom at the specified index. Determined by a combination of TextBlock.bidiLevel
		 * and the Unicode bidirectional properties of the characters that form the line.
		 *
		 * For example, if you start a text block with some Hebrew text, you set TextBlock.bidiLevel to 1, establishing a default of right to left.
		 * If within the text you have a quote in English (left to right), that text has an AtomBidiLevel of 2.
		 * If within the English you have a bit of Arabic (right to left), AtomBidiLevel for that run goes to 3.
		 * If within the Arabic a number (left to right) occurs, the AtomBidiLevel setting for the number is 4.
		 * It does not matter in which line the atoms end up; the Hebrew atoms are AtomBidiLevel 1,
		 * the English atoms are AtomBidiLevel 2, Arabic atoms are AtomBidiLevel 3, and the number atoms are AtomBidiLevel 4.
		 *
		 * After further research. it seems like it's being faithful to the unicode spec which allows up 125 levels of bidi nesting.
		 * Full details here: http://www.unicode.org/reports/tr9/
		 * I'm not sure why this is important from a client perspective. Maybe to properly handle cursor management?
		 * Either way, using it is pretty straight-forward: level % 2 should be 0 for ltr and 1 for rtl.
		 */
		public function getAtomBidiLevel(atomIndex:int):int
		{
			//TODO implement bidi
			return 0;
		}

		COMPILE::SWF
		{
        [SWFOverride(returns="flash.geom.Rectangle",params="flash.display.DisplayObject",altparams="Object")]
		override public function getBounds(ref:Object):Rectangle
		{
			return Rectangle.fromObject(super.getBounds(ref as DisplayObject));
		}
		}
		
		COMPILE::JS
		public function getBounds(ref:Object):Rectangle
		{
			return new Rectangle(element.offsetLeft, element.offsetTop, element.offsetWidth, element.offsetHeight);
		}
		
		/**
		 *  @royaleignorecoercion HTMLCanvasElement
		 *  @royaleignorecoercion CanvasRenderingContext2D
		 */
		public function getAtomBounds(atomIndex:int):Rectangle
		{
			COMPILE::SWF
			{
				var r:Object = textField.getCharBoundaries(atomIndex);
				if (r == null)
				{
					// getCharBoundaries doesn't seem to work if char is paragraph terminator
					if (textField.text.charAt(atomIndex) == "\u2029")
					{
						if (textField.text.length == 1)
							return new Rectangle(0, 1.2 - Number(textField.defaultTextFormat.size), 3, 1.2);
						else
						{
							r = textField.getCharBoundaries(atomIndex - 1);
							return new Rectangle(r.right, 1.2 - Number(textField.defaultTextFormat.size), 3, 1.2)
						}
					}
				}
				return Rectangle.fromObject(r);
			}
			COMPILE::JS
			{
				var w:Number;
				if (atomIndex == element.firstChild.textContent.length - 1)
				{
					w = (element.firstChild as HTMLElement).getClientRects()[0].width;
					return new Rectangle(w, 1.2, 3, 1.2 + _textBlock.content.elementFormat.fontSize);
				}
				else
				{
					var s:String = element.firstChild.textContent;
    				var span:HTMLSpanElement = document.createElement("span") as HTMLSpanElement;
    				element.appendChild(span);
                    var w1:Number = 0;
                    if (atomIndex > 0)
                    {
                        span.innerHTML = s.substring(0, atomIndex);
    					w1 = span.getClientRects()[0].width;
                    }
                    span.innerHTML = s.substring(0, atomIndex + 1);
                    w = span.getClientRects()[0].width;
					element.removeChild(span);
					return new Rectangle(w1, 1.2, w - w1, 1.2 + _textBlock.content.elementFormat.fontSize);
				}
			}
		}

		public function getAtomCenter(atomIndex:int):Number
		{
			var bounds:Rectangle = getAtomBounds(atomIndex);
			return bounds.left + (bounds.right - bounds.left);
		}

		public function getAtomGraphic(atomIndex:int):IUIBase
		{
			//TODO implement embedded graphics
			return null;
		}

		public function getAtomIndexAtCharIndex(charIndex:int):int
		{
			//TODO track indexes...
			return charIndex;
		}

		public function getAtomIndexAtPoint(localX:Number, localY:Number):int
		{
			COMPILE::SWF
			{
				var pt:Point = textField.parent.localToGlobal(new Point(localX,localY));
				return textField.getCharIndexAtPoint(pt.x, pt.y);
			}
			COMPILE::JS
			{
				var pt:Point = new Point(localX, localY);
				// pt = PointUtils.globalToLocal(pt, this);
				var s:String = element.firstChild.textContent;
				if (s === "") return 0;
				// pick a starting point for which atom it might be.
				// assume fixed width fonts
				var start:int = Math.floor(s.length * pt.x / width);
				var done:Boolean = false;
				while (!done)
				{
					var r:Rectangle = getAtomBounds(start);
					if (r.left > pt.x)
					{
						start--;
						if (start == 0)
							return 0;
					} 
					else if (r.right < pt.x)
					{
						start++;
						if (start >= s.length - 1)
							return s.length - 1;
					}
					else
						return start;
				}
				return 0;
			}
		}

		public function getAtomTextBlockBeginIndex(atomIndex:int):int
		{
			return _beginIndex + atomIndex;
		}

		public function getAtomTextBlockEndIndex(atomIndex:int):int
		{
            return _beginIndex + atomIndex + 1;
		}

		public function getAtomTextRotation(atomIndex:int):String
		{
			trace("getAtomTextRotation not implemented");
			//TODO returns TextRotation values.
			return "rotate0";
		}

		public function getAtomWordBoundaryOnLeft(atomIndex:int):Boolean
		{
            var s:String;
            COMPILE::SWF
            {
                s = textField.text;
            }
            COMPILE::JS
            {
                s = element.firstChild.textContent;
            }
            s = s.substring(0, atomIndex);
            return s.indexOf(" ") != -1;
		}

		public function getBaselinePosition(baseline:String):Number
		{
			//TODO baseline is one of TextBaseline, but I'm not sure what the correct value is
			switch(baseline){
				case "ascent":
					break;
				case "descent":
					break;
				case "ideographicBottom":
					break;
				case "ideographicCenter":
					break;
				case "ideographicTop":
					break;
				case "roman":
					break;
				case "useDominantBaseline":
					break;
				default:
					throw new Error("Invalid argument");
			}
			return 0;
		}

		private var _numberLine:ITextLine;
		public function get numberLine():ITextLine
		{
			return _numberLine;
		}
		public function set numberLine(value:ITextLine):void
		{
			_numberLine = value;
		}

		public function getAdornmentOffsetBase():Number
		{
			return 0;
		}

	}
}
