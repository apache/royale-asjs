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
package org.apache.flex.html.beads
{
	import flash.display.Shape;
	
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.Button;
	import org.apache.flex.html.Label;
	import org.apache.flex.html.TitleBar;

	public class TitleBarView extends ContainerView implements IBeadView
	{
		public function TitleBarView()
		{
			super();
		}
		
		/**
		 * @private
		 */
		private var _titleLabel:Label;
		public function get titleLabel():Label
		{
			return _titleLabel;
		}
		
		/**
		 * @private
		 */
		private var _closeButton:Button;
		public function get closeButton():Button
		{
			return closeButton;
		}
		
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			_strand = value;
			
			// add the label for the title and the button for the close
			_titleLabel = createTitle();
			_titleLabel.className = UIBase(_strand).className;
			_titleLabel.id = "title";
			UIBase(_strand).addElement(_titleLabel);
			
			_closeButton = createCloseButton();
			_closeButton.className = UIBase(_strand).className;
			_closeButton.id = "closeButton";
			UIBase(_strand).addElement(_closeButton);
			
			TitleBar(_strand).childrenAdded();
			
			UIBase(_strand).model.addEventListener('titleChange',handlePropertyChange);
			UIBase(_strand).model.addEventListener('htmlTitleChange',handlePropertyChange);
			UIBase(_strand).model.addEventListener('showCloseButtonChange',handlePropertyChange);
			
			// dispatch this event to force any beads to update
			UIBase(_strand).dispatchEvent(new Event("widthChanged"));
		}
		
		/**
		 * @private
		 */
		private function handlePropertyChange(event:Event):void
		{
			if( event.type == "showCloseButtonChange" ) {
				if( closeButton ) closeButton.visible = TitleBar(_strand).showCloseButton;
			}
			else if( event.type == "titleChange" ) {
				if( titleLabel ) {
					titleLabel.text = TitleBar(_strand).title;
				}
			}
			else if( event.type == "htmlTitleChange" ) {
				if( titleLabel ) {
					titleLabel.html = TitleBar(_strand).htmlTitle;
				}
			}
			
			UIBase(_strand).dispatchEvent(new Event("widthChanged"));
		}
		
		/**
		 * @private
		 */
		protected function createTitle() : Label
		{
			var label:Label = new Label();
			label.text = TitleBar(_strand).title;
			return label;
		}
		
		/**
		 * @private
		 */
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
			
			var button:Button = new Button();
			button.upState = upState;
			button.overState = overState;
			button.downState = downState;
			button.hitTestState = hitArea;
			button.visible = TitleBar(_strand).showCloseButton;
			
			button.addEventListener('click',closeButtonHandler);
			
			return button;
		}
		
		/**
		 * @private
		 */
		private function closeButtonHandler(event:org.apache.flex.events.Event) : void
		{
			var newEvent:Event = new Event('close',true);
			UIBase(_strand).dispatchEvent(newEvent);
		}
	}
}