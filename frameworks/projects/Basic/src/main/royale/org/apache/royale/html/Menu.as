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
	import org.apache.royale.core.IMenu;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IParent;
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
	 * menu.addEventListener("change", handleSelection);
	 * 
	 * Present the menu using the show function:
	 * menu.show(component, xoffset, yoffset);
	 * 
	 * Pass a component to use a reference when calculating the position of the menu.
	 * Set an offset from the component's upper-left corner. If an item is selected
	 * the event listener will be called.
	 * 
	 * Remove the menu using menu.hide();
	 * 
	 * Note: submenus are not supported.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class Menu extends List implements IMenu
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
			super();
			typeNames = "Menu";
		}
		
		/**
		 * The submenuField is not used by Menu (see CascadingMenu).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get submenuField():String
		{
			return null;
		}
		public function set submenuField(value:String):void
		{
			// not implemented
		}
		
		private var _parentMenuBar:IEventDispatcher;
		
		/**
		 * @private
		 * 
		 * If this menu is used as part of a menu bar system, this property should reference
		 * that menu bar. If this property is set, the "change" event is dispatched against this
		 * object rather than the Menu itself.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function get parentMenuBar():IEventDispatcher
		{
			return _parentMenuBar;
		}
		public function set parentMenuBar(value:IEventDispatcher):void
		{
			_parentMenuBar = value;
		}
		
		/**
		 * Creates a new instance of the menu, attaching the data given as the dataProvider
		 * to the menu.
		 * 
		 * @param dataProvider Object Either an Array of Strings or an Array of Objects.
		 * 
		 * @return Menu The Menu created.
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
		 * @param component IUIBase A reference position used to place the Menu.
		 * @param xoffset Number The horizontal offset from the component's position.
		 * @param yoffset Number The vertical offset from the component's position.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function show(component:IUIBase, xoffset:Number=0, yoffset:Number=0):void
		{
			var host:IParent = UIUtils.findPopUpHost(component).popUpParent as IParent;
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
			// dispatch the "hideMenus" event to trigger any exposed menu to be hidden.
			var host:IParent = UIUtils.findPopUpHost(this).popUpParent as IParent;
			(host as IEventDispatcher).dispatchEvent(new Event("hideMenus"));
		}
	}
}