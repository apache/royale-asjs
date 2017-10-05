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
        import org.apache.royale.html.Label;            
    }

    COMPILE::JS
    {
        import createjs.Text;
        import createjs.Stage;
        
        import org.apache.royale.createjs.core.CreateJSBase;
        import org.apache.royale.core.WrappedHTMLElement;
    }
	
	import org.apache.royale.core.ITextModel;
	import org.apache.royale.graphics.IFill;
	import org.apache.royale.graphics.SolidColor;
	
	/**
	 * The Label class provides a static text string which may be colored.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.0
	 */
    
    COMPILE::SWF
	public class Label extends org.apache.royale.html.Label
	{		
		/**
		 * @private
		 */
		public function get fill():IFill
		{
			return null;
		}
		public function set fill(value:IFill):void
		{
		}
				
		/**
		 * The color of the text.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get textColor():IFill
		{
			return null;
		}
		public function set textColor(value:IFill):void
		{
		}
				
		/**
		 * The font to use for the text. Any CSS-style font name may be used.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get fontName():String
		{
			return null;
		}
		public function set fontName(value:String):void
		{
		}	
	}
    
    COMPILE::JS
    public class Label extends CreateJSBase
    {
		private var _fontName:String = "18px Arial"
		
		/**
		 * The font to use for the text. Any CSS-style font name may be used.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
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
		 * The string to display.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
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
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        override protected function createElement():WrappedHTMLElement
        {
            var text:Text = new Text('default text');
            text.textBaseline = 'alphabetic';
            
            element = text as WrappedHTMLElement;
            return element;
        }
		
		/**
		 * @private
		 * @royaleignorecoercion createjs.Text
		 */
		override protected function redrawShape():void
		{
			var color:String = null;
			if (textColor != null) {
				color = convertColorToString((textColor as SolidColor).color, 1.0);
			}
			
			var label:createjs.Text = element as createjs.Text;
			label.text = text;
			label["font"] = fontName;
			label["color"] = color;
		}
        
    }
}
