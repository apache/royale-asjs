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
package org.apache.flex.html.staticControls.supportClasses
{
	import org.apache.flex.events.Event;
	import org.apache.flex.html.staticControls.TextButton;

	public class ButtonBarButtonItemRenderer extends UIItemRendererBase
	{
		public function ButtonBarButtonItemRenderer()
		{
			super();
		}
		
		private var textButton:TextButton;
		
		override public function addedToParent():void
		{
			super.addedToParent();
		}
		
		private function handleClickEvent(event:Event):void
		{
			this.dispatchEvent(new Event("selected"));
		}
		
		override public function set data(value:Object):void
		{
			super.data = value;
			
			var added:Boolean = false;
			if (textButton == null) {
				textButton = new TextButton();
				textButton.addEventListener('click',handleClickEvent);
				added = true;
			}
			
			if (value is String) {
				textButton.text = String(value);
			}
			else if (value.hasOwnProperty("label")) {
				textButton.text = String(value["label"]);
			}
			else if (value.hasOwnProperty("title")) {
				textButton.text = String(value["title"]);
			}
			
			if (added) addElement(textButton);
		}
		
		override public function adjustSize():void
		{
			textButton.width = this.width;
			textButton.height = this.height;
			
			updateRenderer();
		}
	}
}