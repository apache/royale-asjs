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
package org.apache.royale.html.supportClasses
{
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.TextButton;
	import org.apache.royale.html.beads.ITextItemRenderer;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.html.supportClasses.UIItemRendererBase;

	/**
	 *  The ButtonBarButtonItemRenderer class handles the display of each item for the 
	 *  org.apache.royale.html.ButtonBar component. This class uses a 
	 *  org.apache.royale.html.Button to represent the data.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ButtonBarButtonItemRenderer extends UIItemRendererBase implements ITextItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ButtonBarButtonItemRenderer()
		{
			super();
		}
		
		protected var textButton:TextButton;
		
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
		protected function handleClickEvent(event:MouseEvent):void
		{
			var newEvent:ItemClickedEvent = new ItemClickedEvent("itemClicked");
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
		 *  @productversion Royale 0.0
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
		 * @private
		 */
		override public function setWidth(value:Number, noEvent:Boolean = false):void
		{
			super.setWidth(value, noEvent);
			textButton.width = value;
		}
		
		/**
		 * @private
		 */
		override public function setHeight(value:Number, noEvent:Boolean = false):void
		{
			super.setHeight(value, noEvent);
			textButton.height = value;
		}
		
		/**
		 *  The data to be displayed by the itemRenderer instance. For ButtonBarItemRenderer, the
		 *  data's string version is used as the label for the Button.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			
			var added:Boolean = false;
			if (textButton == null) {
				textButton = new TextButton();
				textButton.percentWidth = 100;
				
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
		}
	}
}
