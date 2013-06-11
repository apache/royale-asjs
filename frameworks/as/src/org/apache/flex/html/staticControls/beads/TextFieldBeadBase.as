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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import org.apache.flex.core.CSSTextField;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITextBead;
	import org.apache.flex.core.ITextModel;
	import org.apache.flex.events.Event;
	
	public class TextFieldBeadBase implements IBead, ITextBead
	{
		public function TextFieldBeadBase()
		{
			_textField = new CSSTextField();
		}
		
		private var _textField:CSSTextField;
		
		public function get textField() : CSSTextField
		{
			return _textField;
		}
		
		private var _textModel:ITextModel;
		
		public function get textModel() : ITextModel
		{
			return _textModel;
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			_textModel = value.getBeadByType(ITextModel) as ITextModel;
			textModel.addEventListener("textChange", textChangeHandler);
			textModel.addEventListener("htmlChange", htmlChangeHandler);
			textModel.addEventListener("widthChanged", sizeChangeHandler);
			textModel.addEventListener("heightChanged", sizeChangeHandler);
			DisplayObjectContainer(value).addChild(_textField);
			sizeChangeHandler(null);
			if (textModel.text !== null)
				text = textModel.text;
			if (textModel.html !== null)
				html = textModel.html;
		}
		
		public function get strand() : IStrand
		{
			return _strand;
		}
		
		public function get text():String
		{
			return _textField.text;
		}
		public function set text(value:String):void
		{
            if (value == null)
                value == "";
			_textField.text = value;
		}
		
		public function get html():String
		{
			return _textField.htmlText;
		}
		
		public function set html(value:String):void
		{
			_textField.htmlText = value;
		}
		
		private function textChangeHandler(event:Event):void
		{
			text = textModel.text;
		}
		
		private function htmlChangeHandler(event:Event):void
		{
			html = textModel.html;
		}
		
		private function sizeChangeHandler(event:Event):void
		{
			textField.width = DisplayObject(_strand).width;
			textField.height = DisplayObject(_strand).height;
		}
	}
}