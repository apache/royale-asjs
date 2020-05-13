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
	import org.apache.royale.html.DataGridButtonBarTextButton;
	import org.apache.royale.html.beads.ITextItemRenderer;
	import org.apache.royale.events.ItemClickedEvent;

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
	public class DataGridButtonBarButtonItemRenderer extends ButtonBarButtonItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function DataGridButtonBarButtonItemRenderer()
		{
			super();
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
			var added:Boolean = false;
			if (textButton == null) {
				textButton = new DataGridButtonBarTextButton();
				textButton.percentWidth = 100;
				
				// listen for clicks on the button and translate them into
				// an itemClicked event.
				textButton.addEventListener('click',handleClickEvent);
				added = true;
			}
			
			super.data = value;
			
			if (added) addElement(textButton);
		}
		
		/**
		 * @private
		 */
		COMPILE::JS
		override public function adjustSize():void
		{
			// not neeed for JS platform
		}
	}
}
