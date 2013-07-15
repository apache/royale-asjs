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
package org.apache.flex.html.staticControls
{
	import flash.display.Shape;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IBeadLayout;
	import org.apache.flex.core.ITitleBarModel;
	import org.apache.flex.core.ValuesManager;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.staticControls.Label;
	
	public class TitleBar extends Container
	{
		public function TitleBar()
		{
			super();
			
			className = "TitleBar";
		}
		
		public function get title():String
		{
			return ITitleBarModel(model).title;
		}
		public function set title(value:String):void
		{
			ITitleBarModel(model).title = value;
		}
		
		public function get htmlTitle():String
		{
			return ITitleBarModel(model).htmlTitle;
		}
		public function set htmlTitle(value:String):void
		{
			ITitleBarModel(model).htmlTitle = value;
		}
		
		public function get showCloseButton():Boolean
		{
			return ITitleBarModel(model).showCloseButton;
		}
		public function set showCloseButton(value:Boolean):void
		{
			ITitleBarModel(model).showCloseButton = value;
		}
		
		private var _titleLabel:Label;
		public function get titleLabel():Label
		{
			return _titleLabel;
		}
		
		private var _closeButton:Button;
		public function get closeButton():Button
		{
			return closeButton;
		}
		
		override protected function addedToParent():void
		{
			super.addedToParent();
			
			if( getBeadByType(IBeadLayout) == null )
				addBead(new (ValuesManager.valuesImpl.getValue(this, "iBeadLayout")) as IBead);
			
			// add the label for the title and the button for the close
			_titleLabel = createTitle();
			_titleLabel.className = className;
			_titleLabel.id = "title";
			_titleLabel.addToParent(this);
			
			_closeButton = createCloseButton();
			_closeButton.className = className;
			_closeButton.id = "closeButton";
			_closeButton.addToParent(this);
			
			childrenAdded();
            
            model.addEventListener('titleChange',handlePropertyChange);
            model.addEventListener('htmlTitleChange',handlePropertyChange);
            model.addEventListener('showCloseButtonChange',handlePropertyChange);

			// dispatch this event to force any beads to update
			dispatchEvent(new Event("widthChanged"));
		}
		
		private function handlePropertyChange(event:Event):void
		{
			if( event.type == "showCloseButtonChange" ) {
				if( closeButton ) closeButton.visible = showCloseButton;
			}
			else if( event.type == "titleChange" ) {
				if( titleLabel ) {
					titleLabel.text = title;
				}
			}
			else if( event.type == "htmlTitleChange" ) {
				if( titleLabel ) {
					titleLabel.html = htmlTitle;
				}
			}
			
			dispatchEvent(new Event("widthChanged"));
		}
		
		protected function createTitle() : Label
		{
			var label:Label = new Label();
			label.text = title;
			return label;
		}
		
		protected function createCloseButton() : Button
		{
			var upState:Shape = new Shape();
			upState.graphics.clear();
			upState.graphics.beginFill(0xCCCCCC);
			upState.graphics.drawRect(0,0,11,11);
			upState.graphics.endFill();
			
			var overState:Shape = new Shape();
			overState.graphics.clear();
			overState.graphics.beginFill(0x999999);
			overState.graphics.drawRect(0,0,11,11);
			overState.graphics.endFill();
			
			var downState:Shape = new Shape();
			downState.graphics.clear();
			downState.graphics.beginFill(0x666666);
			downState.graphics.drawRect(0, 0, 11, 11);
			downState.graphics.endFill();
			
			var hitArea:Shape = new Shape();
			hitArea.graphics.clear();
			hitArea.graphics.beginFill(0x000000);
			hitArea.graphics.drawRect(0, 0, 11, 11);
			hitArea.graphics.endFill();
			
			var button:Button = new Button(upState, overState, downState, hitArea);
			button.visible = showCloseButton;
			
			button.addEventListener('click',closeButtonHandler);
			
			return button;
		}
		
		private function closeButtonHandler(event:org.apache.flex.events.Event) : void
		{
			var newEvent:Event = new Event('close',true);
			dispatchEvent(newEvent);
		}
	}
}