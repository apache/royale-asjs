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
package org.apache.flex.html.supportClasses
{
	import org.apache.flex.core.IItemRenderer;
	import org.apache.flex.core.IItemRendererParent;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.MouseEvent;
	import org.apache.flex.html.TextButton;
	import org.apache.flex.html.beads.ITextItemRenderer;
	import org.apache.flex.events.ItemClickedEvent;

	/**
	 *  The ButtonBarButtonItemRenderer class handles the display of each item for the 
	 *  org.apache.flex.html.ButtonBar component. This class uses a 
	 *  org.apache.flex.html.Button to represent the data.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class ButtonBarButtonItemRenderer extends UIItemRendererBase implements ITextItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function ButtonBarButtonItemRenderer()
		{
			super();
		}
		
		private var textButton:TextButton;
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
		}
		
		/**
		 * @private
		 */
		private function handleClickEvent(event:MouseEvent):void
		{
			var newEvent:ItemClickedEvent = new ItemClickedEvent("itemClicked");
			newEvent.multipleSelection = event.shiftKey;
			newEvent.index = index;
			newEvent.data = data;
			dispatchEvent(newEvent);
		}
		
		/**
		 *  The string version of the data associated with the instance of the itemRenderer.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get text():String
		{
			return data as String;
		}
		public function set text(value:String):void
		{
			data = value;
		}
		
		/**
		 *  The data to be displayed by the itemRenderer instance. For ButtonBarItemRenderer, the
		 *  data's string version is used as the label for the Button.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			
			var added:Boolean = false;
			if (textButton == null) {
				textButton = new TextButton();
				
				// listen for clicks on the button and translate them into
				// an itemClicked event.
				textButton.addEventListener('click',handleClickEvent);
				added = true;
			}
			
			var valueAsString:String;
			
			if (value is String) {
				valueAsString = value as String;
			}
			else if (value.hasOwnProperty("label")) {
				valueAsString = String(value["label"]);
			}
			else if (value.hasOwnProperty("title")) {
				valueAsString = String(value["title"]);
			}
			
			if (valueAsString) textButton.text = valueAsString;
			
			if (added) addElement(textButton);
		}
		
		/**
		 * @private
		 */
		override public function adjustSize():void
		{
			textButton.width = this.width;
			textButton.height = this.height;
			
			updateRenderer();
		}
	}
}
