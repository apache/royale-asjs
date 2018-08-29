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
package
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	import mx.controls.List;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.FlexMouseEvent;
	import mx.events.ListEvent;
	import mx.managers.PopUpManager;
	
	[Event(name="textChange", type="flash.events.Event")]
	[Event(name="itemSelected", type="SearchBoxEvent")]
	
	public class SearchBox extends UIComponent
	{
		[Embed("assets/icon_close.png")]
		private var closeIcon:Class;
		
		private var textInput:TextInput;
		private var closeButton:Button;
		private var list:List;
		
		private var isListVisible:Boolean = false;
		
		public var text:String;
		
		public function set dataProvider(dp:ArrayCollection):void
		{
			list.dataProvider = dp;
			if (dp != null && dp.length > 0)
			{
				 if (!isListVisible) popup();
				 list.selectedIndex = 0;
			}
			else
			{
				 if (isListVisible) removePopup();
			}
		}
		
		override protected function createChildren():void
		{
			super.createChildren();

            textInput = new TextInput();
			textInput.addEventListener(Event.CHANGE, textInput_changeHandler);
			textInput.addEventListener(KeyboardEvent.KEY_DOWN, textInput_keyDownHandler);
            addChild(textInput);
            
            closeButton = new Button();
            closeButton.setStyle("icon", closeIcon)
            closeButton.setStyle("skin", null)
            closeButton.addEventListener(MouseEvent.CLICK, closeHandler);
			closeButton.width = 20;
            addChild(closeButton);
			
			list = new List();
			list.setStyle("dropShadowEnabled", true);
			list.addEventListener(ListEvent.ITEM_CLICK, selectItem);
            systemManager.addEventListener(Event.RESIZE, removePopup, false, 0, true);
		}
	   	
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			textInput.width = unscaledWidth - closeButton.width;
			textInput.height = unscaledHeight;
			
			closeButton.height = unscaledHeight;
			closeButton.move(unscaledWidth - closeButton.width, 0);
		}
		
        override protected function measure():void 
        {
            super.measure();
            this.measuredWidth = 160;
            this.measuredHeight = textInput.measuredHeight;
        }

		private function textInput_keyDownHandler(event:KeyboardEvent):void
		{
			switch (event.keyCode) 
			{
				case Keyboard.DOWN:
					if (isListVisible)
						list.selectedIndex++;
					else
						popup();					
    				break;
				case Keyboard.UP:
					if (isListVisible && list.selectedIndex > 0)
					{
						list.selectedIndex--;
					}
					textInput.setSelection(textInput.text.length, textInput.text.length);
    				break;
				case Keyboard.ENTER:
					if (isListVisible) selectItem();
    				break;
				case Keyboard.ESCAPE:
					if (isListVisible) removePopup();
    				break;
			}
		}

	    private function textInput_changeHandler(event:Event):void
	    {
	    	text = textInput.text;
	    	dispatchEvent(new Event("textChange"));	
	    }

	    private function list_mouseDownOutsideHandler(event:MouseEvent):void
	    {
    		removePopup();
	    }

	    private function selectItem(event:ListEvent = null):void
	    {
	    	dispatchEvent(new SearchBoxEvent(SearchBoxEvent.ITEM_SELECTED, list.selectedItem));	
	    	removePopup();
	    }

		private function popup():void
		{
			PopUpManager.addPopUp(list, this);
        	isListVisible = true;
			list.width = textInput.width;
	        var point:Point = new Point(0, unscaledHeight);
    	    point = localToGlobal(point);
    	    point = list.parent.globalToLocal(point);
        	list.move(point.x, point.y);
            list.addEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, list_mouseDownOutsideHandler);
		}

		private function removePopup(event:Event=null):void
		{
			PopUpManager.removePopUp(list);
            list.removeEventListener(FlexMouseEvent.MOUSE_DOWN_OUTSIDE, list_mouseDownOutsideHandler);
			isListVisible = false;	
		}
		
		private function closeHandler(event:MouseEvent):void
		{
			textInput.text = "";
			textInput.setFocus();
		}
		
	}
}