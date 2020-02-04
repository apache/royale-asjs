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
	import org.apache.royale.graphics.SolidColor;
	import org.apache.royale.html.Label;
	import org.apache.royale.html.beads.ITextItemRenderer;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.html.util.getLabelFromData;
	import org.apache.royale.svg.Rect;

	/**
	 * The CascadingMenuItemRenderer is the itemRenderer class for the elements of a CascadingMenu.
	 * Each item can either be a label or a separator (indicated by type:"separator" in the data for
	 * the item). If there is a sub-menu (indicated by menu:[array of items] in the data for
	 * the item), a sub-menu indicator is displayed next to the label.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class CascadingMenuItemRenderer extends DataItemRenderer implements ITextItemRenderer
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function CascadingMenuItemRenderer()
		{
			super();
			typeNames = "CascadingMenuItemRenderer";
		}
		
		/**
		 * A place to show the label
		 */
		private var label:Label;
		
		/**
		 * A place to show the sub-menu indicator
		 */
		private var submenuIndicator:Label;
		private var showingIndicator:Boolean = false;
		
		/**
		 * The separator if that's what this itemRenderer instance is supposed to show
		 */
		private var separator:Rect;
		
		/**
		 *  Sets the data value and uses the String version of the data for display.
		 *
		 *  @param Object data The object being displayed by the itemRenderer instance.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		override public function set data(value:Object):void
		{
			super.data = value;
			var isSeparator:Boolean = getType() == "separator";
			
			if (isSeparator) {
				if (separator == null) {
					separator = new Rect();
					separator.fill = new SolidColor(0x000000);
					addElement(separator);
				}
			}
			else {
				
				if (label == null) {
					label = new Label();
					addElement(label);
				}
				
				label.text = getLabel();
				
				if (getHasMenu()) {
					if (submenuIndicator == null) {
						submenuIndicator = new Label();
						submenuIndicator.text = "▶";
						addElement(submenuIndicator);
					}
					COMPILE::SWF {
						this.width = this.width + 2 + submenuIndicator.width;
					}
				} 
			}
		}
		
		protected function getHasMenu():Boolean
		{
			return data.hasOwnProperty("menu");
		}
		
		protected function getLabel():String
		{
			return getLabelFromData(this,data);
		}
		
		protected function getType():String
		{
			return data.hasOwnProperty("type") ? data["type"] : null; 
		}
		
		/**
		 * The label of the itemRenderer, if any.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get text():String
		{
			return label.text;
		}
		public function set text(value:String):void
		{
			label.text = text;
		}
		
		/**
		 * @private
		 */
		override public function adjustSize():void
		{
			var cy:Number = height/2;
			
			if (label) {
				label.x = 0;
				label.y = cy - label.height/2;
			}
			
			if (submenuIndicator) {
				submenuIndicator.x = width - submenuIndicator.width;
				submenuIndicator.y = cy - submenuIndicator.height/2;
			}
			
			if (separator) {
				this.setHeight(3,true);
				separator.x = 0;
				separator.y = 1;
				separator.width = width;
				separator.height = 1;
				separator.draw();
			}
		}
	}
}