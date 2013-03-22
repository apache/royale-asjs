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
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.apache.flex.binding.ConstantBinding;
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IComboBoxBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.html.staticControls.Button;
	import org.apache.flex.html.staticControls.List;
	import org.apache.flex.html.staticControls.TextInput;
	
	public class ComboBoxBead implements IBead, IComboBoxBead
	{
		public function ComboBoxBead()
		{
		}
		
		private var textInput:TextInput;
		private var button:Button;
		private var list:List;
		
		public function get text():String
		{
			return textInput.text;
		}
		public function set text(value:String):void
		{
			textInput.text = value;
		}
		
		public function get html():String
		{
			return textInput.html;
		}
		public function set html(value:String):void
		{
			textInput.html = value;
		}
		private var _strand:IStrand;
		
		public function get strand():IStrand
		{
			return _strand;
		}
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			textInput = new TextInput();
			textInput.addToParent(DisplayObjectContainer(strand));
			textInput.initModel();
			textInput.width = 100;
			textInput.height = 18;
			textInput.initSkin();
			
			upSprite = new Sprite();
			drawButton( upSprite, "up", 18, 18 );
			overSprite = new Sprite();
			drawButton( overSprite, "over", 18, 18 );
			downSprite = new Sprite();
			drawButton( downSprite, "down", 18, 18 );
			
			button = new Button( upSprite, overSprite, downSprite );
			DisplayObjectContainer(strand).addChild(button);
			button.initModel();
			button.width = 18;
			button.height = 18;
			button.x = textInput.width;
			button.y = textInput.y;
			button.initSkin();
			
			list = new List();
			list.addToParent(DisplayObjectContainer(strand));
			list.initModel();
			list.width = 118;
			list.height = 100;
			list.x = textInput.x;
			list.y = textInput.y + textInput.height + 2;
			
			if( value.getBeadByType(ConstantBinding) ) {
				var cb:ConstantBinding = value.getBeadByType(ConstantBinding) as ConstantBinding;
				list.addBead(cb);
			}
			list.initSkin();
			
			// listen for events on the list and take those selections to the text input
			list.addEventListener("change", listChangeHandler,false,0,true);
			
			// listen for events on the text input and modify the list and selection
			textInput.addEventListener("change", textChangeHandler,false,0,true);
		}
		
		private var upSprite:Sprite;
		private var overSprite:Sprite;
		private var downSprite:Sprite;
		
		private function drawButton( sprite:Sprite, mode:String, width:Number, height:Number ) : void
		{
			sprite.graphics.clear();
			sprite.graphics.lineStyle(1,0xFFFFFF);
			sprite.graphics.drawRect(0, 0, width-1, height-1);
			sprite.graphics.lineStyle(-1);
			
			if( mode == "over" ) sprite.graphics.beginFill(0xCCCCCC);
			else if( mode == "down" ) sprite.graphics.beginFill(0x888888);
			sprite.graphics.drawRect(0, 0, width-1, height-1);
			sprite.graphics.endFill();
			
			sprite.graphics.beginFill(0x333333);
			sprite.graphics.moveTo(4,4);
			sprite.graphics.lineTo(width-4,4);
			sprite.graphics.lineTo(int(width/2),height-4);
			sprite.graphics.lineTo(4,4);
			sprite.graphics.endFill();
		}
		
		private function listChangeHandler( event:Event ) : void
		{
			var item:Object = list.selectedItem;
			textInput.text = item.toString();
			
			var newEvent:Event = new Event(Event.CHANGE);
			IEventDispatcher(strand).dispatchEvent(newEvent);
		}
		
		private function textChangeHandler( event:Event ) : void
		{
			list.selectedItem = textInput.text;
			list.selectedIndex = -1;
			
			var newEvent:Event = new Event(Event.CHANGE);
			IEventDispatcher(strand).dispatchEvent(newEvent);
		}
	}
}