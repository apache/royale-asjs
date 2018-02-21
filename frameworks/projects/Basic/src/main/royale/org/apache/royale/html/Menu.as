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
package org.apache.royale.html
{
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.geom.Point;
	import org.apache.royale.html.beads.models.MenuModel;
	import org.apache.royale.utils.PointUtils;
	import org.apache.royale.utils.UIUtils;

	/**
	 * The Menu class builds pop-up menus that are presented as a list, displayed
	 * at a specific location. The dataProvider should be an Array of either Strings
	 * or Objects; if Objects, set the Menu's labelField to identify the property in
	 * the Object to use for the labels in the Menu.
	 * 
	 * Use createMenu to create a Menu and add an event listener to be triggered when
	 * a menu item is selected.
	 * 
	 * var menu:Menu = Menu.createMenu(dataProvider);
	 * menu.addEventListener("itemSelected", handleSelection);
	 * 
	 * Present the menu using the show function:
	 * menu.show(component, xoffset, yoffset);
	 * 
	 * Pass a component to use a reference when calculating the position of the menu.
	 * Set an offset from the component's upper-left corner. If an item is selected
	 * the event listener will be called.
	 * 
	 * Note: submenus are not supported.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class Menu extends List
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function Menu()
		{
			typeNames = "Menu";
			super();
		}
		
		/**
		 * Creates a new instance of the menu, attaching the data given as the dataProvider
		 * to the menu.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public static function createMenu(dataProvider:Object):Menu
		{
			var menu:Menu = new Menu();
			menu.dataProvider = dataProvider;
			return menu;
		}
		
		/**
		 * Displays the menu at the given location which is an offset from the origin
		 * of the component supplied.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function show(component:IUIBase, xoffset:Number=0, yoffset:Number=0):void
		{
			var host:UIBase = UIUtils.findPopUpHost(component) as UIBase;
			var orgPoint:Point = new Point(component.x+xoffset, component.y+yoffset);
			var popupPoint:Point = PointUtils.localToGlobal(orgPoint, component.parent);
			this.x = popupPoint.x;
			this.y = popupPoint.y;
			host.addElement(this);
		}
		
		/**
		 * Hides the menu if displayed.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function hide():void
		{			
			if (this.parent != null) {
				this.dispatchEvent(new Event("menuWillHide"));
				this.parent.removeElement(this);
			}
		}
	}
}