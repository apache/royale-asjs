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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IRadioButtonBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IToggleButtonModel;
	
	public class RadioButtonBead implements IBead, IRadioButtonBead
	{
		public function RadioButtonBead()
		{
			sprites = [ upSprite = new Sprite(),
				        downSprite = new Sprite(),
						overSprite = new Sprite(),
						upAndSelectedSprite = new Sprite(),
						downAndSelectedSprite = new Sprite(),
						overAndSelectedSprite = new Sprite() ];
			
			for each( var s:Sprite in sprites )
			{
				var tf:TextField = new TextField();
				tf.type = TextFieldType.DYNAMIC;
				tf.autoSize = TextFieldAutoSize.LEFT;
				tf.name = "textField";
				var icon:Shape = new Shape();
				icon.name = "icon";
				s.addChild(icon);
				s.addChild(tf);
			}
		}
		
		private var upSprite:Sprite;
		private var downSprite:Sprite;
		private var overSprite:Sprite;
		private var upAndSelectedSprite:Sprite;
		private var downAndSelectedSprite:Sprite;
		private var overAndSelectedSprite:Sprite;
		
		private var sprites:Array;
		
		private var _toggleButtonModel:IToggleButtonModel;
		
		public function get toggleButtonModel() : IToggleButtonModel
		{
			return _toggleButtonModel;
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			_toggleButtonModel = value.getBeadByType(IToggleButtonModel) as IToggleButtonModel;
			_toggleButtonModel.addEventListener("textChange", textChangeHandler);
			_toggleButtonModel.addEventListener("htmlChange", htmlChangeHandler);
			_toggleButtonModel.addEventListener("selectedChange", selectedChangeHandler);
			_toggleButtonModel.addEventListener("valueChange", valueChangeHandler);
			if (_toggleButtonModel.text != null)
				text = _toggleButtonModel.text;
			if (_toggleButtonModel.html != null)
				html = _toggleButtonModel.html;
			
			layoutControl();
			
			var hitArea:Shape = new Shape();
			hitArea.graphics.beginFill(0x000000);
			hitArea.graphics.drawRect(12,0,upSprite.width, upSprite.height);
			hitArea.graphics.endFill();
			
			SimpleButton(value).upState = upSprite;
			SimpleButton(value).downState = downSprite;
			SimpleButton(value).overState = overSprite;
			SimpleButton(value).hitTestState = hitArea;
			
			if (toggleButtonModel.text !== null)
				text = toggleButtonModel.text;
			if (toggleButtonModel.html !== null)
				html = toggleButtonModel.html;
			
			if (toggleButtonModel.selected && toggleButtonModel.value == value) {
				selected = true;
			}
		}
		
		public function get text():String
		{
			var tf:TextField = upSprite.getChildByName('textField') as TextField;
			return tf.text;
		}
		
		public function set text(value:String):void
		{
			for each( var s:Sprite in sprites )
			{
				var tf:TextField = s.getChildByName('textField') as TextField;
				tf.text = value;
			}
			
			layoutControl();
		}
		
		public function get html():String
		{
			var tf:TextField = upSprite.getChildByName('textField') as TextField;
			return tf.htmlText;
		}
		
		public function set html(value:String):void
		{
			for each(var s:Sprite in sprites)
			{
				var tf:TextField = s.getChildByName('textField') as TextField;
				tf.htmlText = value;
			}
			
			layoutControl();
		}
		
		private function textChangeHandler(event:Event):void
		{
			text = toggleButtonModel.text;
		}
		
		private function htmlChangeHandler(event:Event):void
		{
			html = toggleButtonModel.html;
		}
		
		private var _selected:Boolean;
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			layoutControl();
			
			if( value ) {
				SimpleButton(_strand).upState = upAndSelectedSprite;
				SimpleButton(_strand).downState = downAndSelectedSprite;
				SimpleButton(_strand).overState = overAndSelectedSprite;
				
			} else {
				SimpleButton(_strand).upState = upSprite;
				SimpleButton(_strand).downState = downSprite;
				SimpleButton(_strand).overState = overSprite;
			}
		}
		
		private var _value:Object;
		
		public function get value() : Object
		{
			return _value;
		}
		
		public function set value(newValue:Object):void
		{
			_value = newValue;
		}
		
		private function selectedChangeHandler(event:Event):void
		{
			selected = toggleButtonModel.selected;
		}
		
		private function valueChangeHandler(event:Event):void
		{
			value = toggleButtonModel.value;
		}
		
		protected function layoutControl() : void
		{
			for each(var s:Sprite in sprites)
			{
				var icon:Shape = s.getChildByName("icon") as Shape;
				var tf:TextField = s.getChildByName("textField") as TextField;
				
				drawRadioButton(icon);
				
				var mh:Number = Math.max(icon.height,tf.height);
				
				icon.x = 0;
				icon.y = (mh - icon.height)/2;
				
				tf.x = icon.x + icon.width + 1;
				tf.y = (mh - tf.height)/2;
			}
			
		}
		
		protected function drawRadioButton(icon:Shape) : void
		{
			icon.graphics.clear();
			icon.graphics.beginFill(0xCCCCCC);
			icon.graphics.lineStyle(1,0x333333);
			icon.graphics.drawEllipse(0,0,10,10);
			icon.graphics.endFill();
			
			if( _toggleButtonModel.selected ) {
				icon.graphics.beginFill(0x555555);
				icon.graphics.drawEllipse(2,2,6,6);
				icon.graphics.endFill();
			}
		}
	}
}