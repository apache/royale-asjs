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
	import flash.display.Sprite;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IComboBoxModel;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.staticControls.Button;
	import org.apache.flex.html.staticControls.TextInput;
	
	public class ComboBoxView implements IBead, IComboBoxView
	{
		public function ComboBoxView()
		{
		}
		
		private var textInput:TextInput;
		private var button:Button;
		
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
		
		private var selectionModel:IComboBoxModel;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			selectionModel = value.getBeadByType(IComboBoxModel) as IComboBoxModel;
			selectionModel.addEventListener("selectedIndexChanged", selectionChangeHandler);
			
			textInput = new TextInput();
			textInput.addToParent(DisplayObjectContainer(strand));
			textInput.width = 100;
			textInput.height = 18;
			
			upSprite = new Sprite();
			drawButton( upSprite, "up", 18, 18 );
			overSprite = new Sprite();
			drawButton( overSprite, "over", 18, 18 );
			downSprite = new Sprite();
			drawButton( downSprite, "down", 18, 18 );
			
			button = new Button( upSprite, overSprite, downSprite );
			DisplayObjectContainer(strand).addChild(button);
			button.width = 18;
			button.height = 18;
			button.x = textInput.width;
			button.y = textInput.y;
			
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
		
		private var _popUp:IStrand;
		public function get popUp():IStrand
		{
			return _popUp;
		}
		
		private var _popUpVisible:Boolean;
		
		public function get popUpVisible():Boolean
		{
			return _popUpVisible;
		}
		
		public function set popUpVisible(value:Boolean):void
		{
			if (value != _popUpVisible)
			{
				_popUpVisible = value;
				if (value)
				{
					if (!_popUp)
					{
						var popUpClass:Class = ValuesManager.valuesImpl.getValue(_strand, "iPopUp") as Class;
						_popUp = new popUpClass() as IStrand;
					}
					var root:Object = DisplayObject(_strand).root;
					var host:DisplayObjectContainer = DisplayObject(_strand).parent;
					while (host.parent != root)
						host = host.parent;
					IUIBase(popUp).addToParent(host);
				}
				else
				{
					DisplayObject(_popUp).parent.removeChild(_popUp as DisplayObject);                    
				}
			}
		}
		
		private function selectionChangeHandler(event:Event):void
		{
			text = selectionModel.selectedItem.toString();
		}
		
		private function textChangeHandler(event:Event):void
		{	
			var newEvent:Event = new Event("change");
			IEventDispatcher(strand).dispatchEvent(newEvent);
		}
	}
}