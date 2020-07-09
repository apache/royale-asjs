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
package org.apache.royale.svg
{
    import org.apache.royale.graphics.IDrawable;
	import org.apache.royale.graphics.IText;
	import org.apache.royale.graphics.SolidColor;

    COMPILE::SWF
    {
        import flash.text.TextFieldType;
        import org.apache.royale.core.CSSTextField;
    }
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.createSVG;
    }

	/**
	 *  Draws a string of characters at a specific location using the fill
	 *  value of color and alpha.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
     *  // TODO (aharui) ignore imports of external linkage interfaces?
     *  @royaleignoreimport SVGLocatable
	 */
	public class Text extends GraphicShape implements IText, IDrawable
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function Text()
		{
			super();

            COMPILE::SWF
            {
                _textField = new CSSTextField();
                addChild(_textField);
            }
		}

		private var _text:String;
		public function get text():String
		{
			return _text;
		}
		public function set text(value:String):void
		{
			_text = value;
			updateView();
		}

        COMPILE::SWF
		private var _textField:CSSTextField;

		COMPILE::JS
		private var _textElem:WrappedHTMLElement;

		/**
		 *  @copy org.apache.royale.core.ITextModel#textField
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
        COMPILE::SWF
		public function get textField() : CSSTextField
		{
			return _textField;
		}

		/**
		 *  Draws text at the given point.
		 *  @param value The string to draw.
		 *  @param xt The x position of the top-left corner of the rectangle.
		 *  @param yt The y position of the top-left corner.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         *  @royaleignorecoercion Node
         *  @royaleignorecoercion SVGLocatable
		 */
		public function drawText(value:String, xt:Number, yt:Number):void
		{
            COMPILE::SWF
            {
                textField.selectable = false;
                textField.type = TextFieldType.DYNAMIC;
                textField.mouseEnabled = false;
                textField.autoSize = "left";
                textField.text = value;

                var color:SolidColor = fill as SolidColor;
                if (color) {
                    textField.textColor = color.color;
                    textField.alpha = color.alpha;
                }

                textField.x = xt;
                textField.y = yt;
            }
            COMPILE::JS
            {
                var style:String = this.getStyleStr();
				if (_textElem == null) {
                	_textElem = createSVG('text') as WrappedHTMLElement;
                	_textElem.royale_wrapper = this;
					element.appendChild(_textElem);
				}
				else {
					_textElem.removeChild(_textElem.childNodes[0]);
				}
                _textElem.setAttribute('style', style);
                _textElem.setAttribute('x', xt);
                _textElem.setAttribute('y', yt);
				var textNode:Node = document.createTextNode(value) as Node;
				_textElem.appendChild(textNode as Node);

                // resize(x, y, getBBox(_textElem));
                resize(x, y);

            }
		}

        override protected function drawImpl():void
        {
            drawText(text,x,y);
        }

		public function draw():void
		{
			drawImpl();
		}

	}
}
