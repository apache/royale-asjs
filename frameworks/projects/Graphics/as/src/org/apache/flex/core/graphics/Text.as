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
package org.apache.flex.core.graphics
{
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.CSSTextField;
	
	/**
	 *  Draws a string of characters at a specific location using the stroke
	 *  value of color and alpha.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Text extends GraphicShape
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Text()
		{
			super();
			
			_textField = new CSSTextField();
			addChild(_textField);
		}
		
		
		private var _textField:CSSTextField;
		
		/**
		 *  @copy org.apache.flex.core.ITextModel#textField
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get textField() : CSSTextField
		{
			return _textField;
		}
		
		/**
		 *  Draws text at the given point.
		 *  @param value The string to draw.
		 *  @param x The x position of the top-left corner of the rectangle.
		 *  @param y The y position of the top-left corner.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function drawText(value:String, x:Number, y:Number):void
		{
			textField.selectable = false;
			textField.type = TextFieldType.DYNAMIC;
			textField.mouseEnabled = false;
			textField.autoSize = "left";
			textField.text = value;
			
			var color:SolidColorStroke = stroke as SolidColorStroke;
			if (color) {
				textField.textColor = color.color;
				textField.alpha = color.alpha;
			}
			
			textField.x = x;
			textField.y = y;
		}
	}
}