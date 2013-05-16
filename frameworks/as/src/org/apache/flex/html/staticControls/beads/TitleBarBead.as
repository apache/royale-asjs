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
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.CSSTextField;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IInitSkin;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ITextModel;
	import org.apache.flex.core.ITitleBarBead;
	import org.apache.flex.events.Event;
	
	public class TitleBarBead implements ITitleBarBead,IInitSkin, IStrand
	{
		public function TitleBarBead()
		{
			_titleField = new CSSTextField();
			_titleField.type = TextFieldType.DYNAMIC;
			_titleField.autoSize = TextFieldAutoSize.LEFT;
			
			_closeButton = new SimpleButton();
			_closeButton.mouseEnabled = true;
			_closeButton.useHandCursor = true;
			
			var upState:Sprite = new Sprite();
			upState.graphics.clear();
			upState.graphics.beginFill(0xAAAAAA);
			upState.graphics.lineStyle(1,0x333333);
			upState.graphics.drawRect(0,0,9,9);
			upState.graphics.endFill();
			_closeButton.upState = upState;
			
			var overState:Sprite = new Sprite();
			overState.graphics.clear();
			overState.graphics.beginFill(0x999999);
			overState.graphics.lineStyle(1,0x333333);
			overState.graphics.drawRect(0,0,9,9);
			overState.graphics.endFill();
			_closeButton.overState = overState;
			
			var downState:Sprite = new Sprite();
			downState.graphics.clear();
			downState.graphics.beginFill(0x666666);
			downState.graphics.lineStyle(1,0x333333);
			downState.graphics.drawRect(0,0,9,9);
			downState.graphics.endFill();
			_closeButton.downState = downState;
		}
		
		private var _titleField:CSSTextField;
		private var _closeButton:SimpleButton;
		
		protected function get textField() : CSSTextField
		{
			return _titleField;
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
			
			DisplayObjectContainer(value).addChild(_titleField);
			
			if (textModel.text !== null)
				text = textModel.text;
			if (textModel.html !== null)
				html = textModel.html;
			
			sizeChangeHandler(null);
		}
		
		public function initSkin():void
		{
		}
		
		public function get text():String
		{
			return _titleField.text;
		}
		public function set text(value:String):void
		{
			_titleField.text = value;
		}
		
		public function get html():String
		{
			return _titleField.htmlText;
		}
		
		public function set html(value:String):void
		{
			_titleField.htmlText = value;
		}
		
		private var _showCloseButton:Boolean = false;
		public function get showCloseButton() : Boolean
		{
			return _showCloseButton;
		}
		public function set showCloseButton(value:Boolean):void
		{
			_showCloseButton = value;
			if( value ) {
				DisplayObjectContainer(_strand).addChild(_closeButton);
			}
			else {
				DisplayObjectContainer(_strand).removeChild(_closeButton);
			}
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
			_titleField.x = (DisplayObject(_strand).width - _titleField.width)/2;
			_titleField.y = (DisplayObject(_strand).height - _titleField.height)/2;
			
			trace("TitleBarBead. strand.width="+DisplayObject(_strand).width+"; titleField.width="+_titleField.width);
			
			if( showCloseButton ) {
				_closeButton. x = DisplayObject(_strand).width - _closeButton.width - 5;
				_closeButton.y = (DisplayObject(_strand).height - _closeButton.height)/2;
			}
		}
		
		// beads declared in MXML are added to the strand.
		// from AS, just call addBead()
		public var beads:Array;
		
		private var _beads:Vector.<IBead>;
		public function addBead(bead:IBead):void
		{
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			bead.strand = this;
		}
		
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in _beads)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}
		
		public function removeBead(value:IBead):IBead	
		{
			var n:int = _beads.length;
			for (var i:int = 0; i < n; i++)
			{
				var bead:IBead = _beads[i];
				if (bead == value)
				{
					_beads.splice(i, 1);
					return bead;
				}
			}
			return null;
		}
	}
}