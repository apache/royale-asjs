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
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITextInputBead;
	import org.apache.flex.core.ITextModel;
	
	public class TextInputBead implements IBead, ITextInputBead
	{
		public function TextInputBead()
		{
			_textField = new TextField();
			_textField.selectable = true;
			_textField.type = TextFieldType.INPUT;
			_textField.mouseEnabled = true;
			_textField.multiline = false;
			_textField.wordWrap = false;
			
			// for debug only
			_textField.border = true;
			_textField.borderColor = 0x333333;
			_textField.width = 100;
			_textField.height = 18;
		}
		
		private var textModel:ITextModel;
		
		private var _strand:IStrand;
		
		private var _textField:TextField;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			textModel = value.getBeadByType(ITextModel) as ITextModel;
			textModel.addEventListener("textChange", textChangeHandler);
			textModel.addEventListener("htmlChange", htmlChangeHandler);
			DisplayObjectContainer(value).addChild(_textField);
			if (textModel.text !== null)
				text = textModel.text;
			if (textModel.html !== null)
				html = textModel.html;
			
			// for input, listen for changes to the _textField and update
			// the model
			_textField.addEventListener(Event.CHANGE, inputChangeHandler);
			
			// set initial size, if present, and listen for changes in dimension
			var ww:Number = DisplayObject(value).width;
			var hh:Number = DisplayObject(value).height;
			
			if( !isNaN(ww) && ww > 0 ) _textField.width = ww;
			if( !isNaN(hh) && hh > 0 ) _textField.height = hh;
			IEventDispatcher(_strand).addEventListener("widthChanged", widthChangedHandler);
			IEventDispatcher(_strand).addEventListener("heightChanged", heightChangedHandler);
		}
		
		private function textChangeHandler(event:Event):void
		{
			text = textModel.text;
		}
		
		private function htmlChangeHandler(event:Event):void
		{
			html = textModel.html;
		}
		
		private function inputChangeHandler(event:Event):void
		{
			textModel.text = _textField.text;
		}
		
		private function widthChangedHandler(event:Event):void
		{
			var ww:Number = DisplayObject(_strand).width;
			_textField.width = ww;
		}
		
		private function heightChangedHandler(event:Event):void
		{
			var hh:Number = DisplayObject(_strand).height;
			_textField.height = hh;
		}
		
		public function get text():String
		{
			return _textField.text;
		}
		public function set text(value:String):void
		{
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
	}
}