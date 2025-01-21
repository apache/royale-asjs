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
package org.apache.royale.createjs
{
    COMPILE::SWF
    {
        import org.apache.royale.html.Button;            
    }
    COMPILE::JS
    {
        import createjs.Container;
        import createjs.Text;
        import createjs.Shape;
        import createjs.Stage;
        
        import org.apache.royale.createjs.core.CreateJSBase;
        import org.apache.royale.core.WrappedHTMLElement;
    }
	
	import org.apache.royale.core.ITextModel;
	import org.apache.royale.graphics.IFill;
	import org.apache.royale.graphics.SolidColor;
	
	/**
	 * The TextButton class provides a clickable button.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.0
	 */

	COMPILE::SWF
	public class TextButton extends Button
	{
		public function TextButton()
		{
			super();
		}
		
		private var _fill:IFill;
		
		/**
		 *  A solid color fill.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.0
		 */
		public function get fill():IFill
		{
			return _fill;
		}
		public function set fill(value:IFill):void
		{
			_fill = value;
		}
		
		private var _textColor:IFill;
		
		
		/**
		 *  The color of the text.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.0
		 */
		public function get textColor():IFill
		{
			return _textColor;
		}
		
		public function set textColor(value:IFill):void
		{
			_textColor = value;
		}
		
		private var _fontName:String;
		
		/**
		 *  The font to use for the button's label.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.0
		 */
		public function get fontName():String
		{
			return _fontName;
		}
		
		public function set fontName(value:String):void
		{
			_fontName = value;
		}
		
		
		/**
		 *  The button's label.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.0
		 */
		public function get text():String
		{
			return ITextModel(model).text;
		}
		public function set text(value:String):void
		{
			ITextModel(model).text = value;
		}	
	}
    
    COMPILE::JS
    public class TextButton extends CreateJSBase
    {
        private var buttonBackground:Shape;
        private var buttonLabel:Text;
        private var button:createjs.Container;
		
        /**
		 * @private
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        override protected function createElement():WrappedHTMLElement
        {	
            buttonBackground = new createjs.Shape(null);
            buttonBackground.name = 'background';
            
            buttonLabel = new createjs.Text('button');
            buttonLabel.name = 'label';
            buttonLabel.textAlign = 'center';
            buttonLabel.textBaseline = 'middle';
            
            button = new createjs.Container();
            button.name = 'button';
            button.addChild(buttonBackground);
            button.addChild(buttonLabel);
            
            element = button as WrappedHTMLElement;
            return element;
        }
		
		private var _fontName:String = "bold 18px Arial"
		
		/**
		 *  The font to use for the button's label.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.0
		 */
		public function get fontName():String
		{
			return _fontName;
		}
		
		public function set fontName(value:String):void
		{
			_fontName = value;
			redrawShape();
		}
        
		/**
		 *  The button's label
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.0
		 */
		public function get text():String
		{
			return ITextModel(model).text;
		}
		public function set text(value:String):void
		{
			ITextModel(model).text = value;
			redrawShape();
		}
		
		/**
		 * @private
		 */
		override protected function redrawShape():void
		{
			if (isNaN(width) || isNaN(height)) return;
			
			var fillColor:String = null;
			var fillAlpha:Number = 1.0;
			if (fill != null) {
				fillAlpha = (fill as SolidColor).alpha;
				fillColor = convertColorToString((fill as SolidColor).color, fillAlpha);
			}
			buttonBackground.graphics.beginFill(fillColor).
				drawRoundRect(0, 0, width, height, 8);
			
			var color:String = null;
			if (textColor != null) {
				color = convertColorToString((textColor as SolidColor).color, 1.0);
			}
			buttonLabel.x = width / 2;
			buttonLabel.y = height / 2;
			buttonLabel.text = text;
			buttonLabel["font"] = fontName;
			buttonLabel["color"] = color;
		}
    }
}
