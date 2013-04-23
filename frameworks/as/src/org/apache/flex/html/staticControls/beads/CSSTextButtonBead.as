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
package org.apache.flex.html.staticControls.beads
{
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.CSSTextField;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITextModel;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;

	public class CSSTextButtonBead implements ITextButtonBead
	{
		public function CSSTextButtonBead()
		{
			upTextField = new CSSTextField();
			downTextField = new CSSTextField();
			overTextField = new CSSTextField();
			upTextField.border = true;
			downTextField.border = true;
			overTextField.border = true;
			upTextField.background = true;
			downTextField.background = true;
			overTextField.background = true;
			upTextField.selectable = false;
			upTextField.type = TextFieldType.DYNAMIC;
			downTextField.selectable = false;
			downTextField.type = TextFieldType.DYNAMIC;
			overTextField.selectable = false;
			overTextField.type = TextFieldType.DYNAMIC;
			upTextField.autoSize = "left";
			downTextField.autoSize = "left";
			overTextField.autoSize = "left";

		}
		
		private var textModel:ITextModel;
		
		private var _strand:IStrand;
		
		private var shape:Shape;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			textModel = value.getBeadByType(ITextModel) as ITextModel;
			textModel.addEventListener("textChange", textChangeHandler);
			textModel.addEventListener("htmlChange", htmlChangeHandler);
			shape = new Shape();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, 10, 10);
			shape.graphics.endFill();
			SimpleButton(value).upState = upTextField;
			SimpleButton(value).downState = downTextField;
			SimpleButton(value).overState = overTextField;
			SimpleButton(value).hitTestState = shape;
			if (textModel.text !== null)
				text = textModel.text;
			if (textModel.html !== null)
				html = textModel.html;
			var defaultBorderStyles:Object = ValuesManager.valuesImpl.getValue(value, "border");
			var defaultBackgroundColor:Object = ValuesManager.valuesImpl.getValue(value, "backgroundColor");
			var borderStyles:Object = ValuesManager.valuesImpl.getValue(value, "border", "hover");
			var borderColor:uint;
			var borderThickness:uint;
			var borderStyle:String;
			if (!borderStyles)
				borderStyles = defaultBorderStyles;
			if (borderStyles is Array)
			{
				borderColor = borderStyles[2];
				borderStyle = borderStyles[1];
				borderThickness = borderStyles[0];
				overTextField.borderColor = borderColor;
				overTextField.border = borderStyle != "none";
			}
			var backgroundColor:Object = ValuesManager.valuesImpl.getValue(value, "backgroundColor", "hover");
			if (backgroundColor == null)
				backgroundColor = defaultBackgroundColor;
			overTextField.backgroundColor = backgroundColor as uint;
			
			borderStyles = ValuesManager.valuesImpl.getValue(value, "border", "active");
			if (!borderStyles)
				borderStyles = defaultBorderStyles;
			if (borderStyles is Array)
			{
				borderColor = borderStyles[2];
				borderStyle = borderStyles[1];
				borderThickness = borderStyles[0];
				downTextField.borderColor = borderColor;
				downTextField.border = borderStyle != "none";
			}
			backgroundColor = ValuesManager.valuesImpl.getValue(value, "backgroundColor", "active");
			if (backgroundColor == null)
				backgroundColor = defaultBackgroundColor;
			downTextField.backgroundColor = backgroundColor as uint;

			borderStyles = defaultBorderStyles;
			if (borderStyles is Array)
			{
				borderColor = borderStyles[2];
				borderStyle = borderStyles[1];
				borderThickness = borderStyles[0];
				upTextField.borderColor = borderColor;
				upTextField.border = borderStyle != "none";
			}
			upTextField.backgroundColor = defaultBackgroundColor as uint;
		}
		
		private function textChangeHandler(event:Event):void
		{
			text = textModel.text;
		}
		
		private function htmlChangeHandler(event:Event):void
		{
			html = textModel.html;
		}
		
		private var upTextField:CSSTextField;
		private var downTextField:CSSTextField;
		private var overTextField:CSSTextField;
		
		public function get text():String
		{
			return upTextField.text;
		}
		public function set text(value:String):void
		{
			upTextField.text = value;
			downTextField.text = value;
			overTextField.text = value;
			shape.graphics.clear();
			shape.graphics.beginFill(0xCCCCCC);
			shape.graphics.drawRect(0, 0, upTextField.textWidth, upTextField.textHeight);
			shape.graphics.endFill();
			
		}
		
		public function get html():String
		{
			return upTextField.htmlText;
		}
		
		public function set html(value:String):void
		{
			upTextField.htmlText = value;
			downTextField.htmlText = value;
			overTextField.htmlText = value;
		}
	}
}