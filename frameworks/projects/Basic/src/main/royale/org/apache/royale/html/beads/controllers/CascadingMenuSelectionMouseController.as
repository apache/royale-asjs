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
package org.apache.royale.html.beads.controllers
{
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IMenu;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.ICascadingMenuModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.html.CascadingMenu;
	import org.apache.royale.html.Menu;
	import org.apache.royale.html.beads.models.MenuModel;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;

	COMPILE::JS {
		import org.apache.royale.events.BrowserEvent;
	}

	/**
	 * The CascadingMenuSelectionMouseController does the same job as the MenuSelectionMouseController
	 * except if the item in the menu that has been selected has children, in which case a new
	 * CascadingMenu is presented.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class CascadingMenuSelectionMouseController extends MenuSelectionMouseController
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function CascadingMenuSelectionMouseController()
		{
			super();
		}
		
		/**
		 * @private
		 * 
		 * Replaces the selectedHandler from the super class to handle the presentation of
		 * submenus. If an element has the submenu indicator, a new CascadingMenu is presented.
		 * If the element is a regular element, then the super class's handler is called.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		override protected function selectedHandler(event:ItemClickedEvent):void
		{
			var node:Object = event.data;
			
			var model:ICascadingMenuModel = _strand.getBeadByType(IBeadModel) as ICascadingMenuModel;
			
			if (getHasMenu(node, model)) {
				var c:Class = ValuesManager.valuesImpl.getValue(_strand, "iMenu");
				var component:IUIBase = event.target as IUIBase;
				var menu:IMenu = new c() as IMenu;
				menu.dataProvider = getSubMenuDataProvider(node, model);
				menu.labelField = model.labelField;
				menu.parentMenuBar = (_strand as IMenu).parentMenuBar;
				// selected item holds the currently open submenu data 
				// check to see if that exists and hide it if it does
				if (model.selectedItem)
				{
					var dp:Object = getSubMenuDataProvider(model.selectedItem, model);
					if (dp)
					{
						var nextMenu:CascadingMenu = getMenuWithDataProvider(MenuModel.menuList, dp);
						if (nextMenu)
						{
							clearSubmenusOnSameLevel(nextMenu, nextMenu.model as ISelectionModel);
						}
					}
				}
				model.selectedItem = event.data;
				menu.show(component, component.width, 0);
			}
			else {
				super.selectedHandler(event);
				hideOpenMenus();
			}
		}

		private function clearSubmenusOnSameLevel(menuToBeRemoved:UIBase, model:ISelectionModel):void
		{
			var selectedItem:Object = model.selectedItem;
			if (!selectedItem)
			{
				return removeMenu(menuToBeRemoved);
			}
			var menuList:Array = MenuModel.menuList;
			for (var i:int = 0; i < menuList.length; i++)
			{
				var menu:UIBase = menuList[i] as UIBase;
				var menuModel:ISelectionModel = menu.model as ISelectionModel;
				if (menuModel && menuModel.selectedItem == selectedItem)
				{
					var dp:Object = getSubMenuDataProvider(selectedItem, menuModel as ICascadingMenuModel);
					if (dp)
					{
						// though this is being called in a loop, performance shouldn't be a big issue as
						// number of open nested menus is expected to be small
						var nextMenu:CascadingMenu = getMenuWithDataProvider(menuList, dp);
						if (nextMenu)
						{
							clearSubmenusOnSameLevel(nextMenu, nextMenu.model as ISelectionModel);
							break;
						}
					}
				}
			}
			removeMenu(menuToBeRemoved);
		}

		/**
		 * @private
		 * 
		 *  Search for an open menu strand according to the given data provider.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		protected function getMenuWithDataProvider(menuList:Array, dp:Object):CascadingMenu
		{
			// go over open menus and return the one with the given data provider
			for (var i:int = 0; i < menuList.length; i++)
			{
				var cascadingMenu:CascadingMenu = menuList[i] as CascadingMenu;
				if (cascadingMenu && cascadingMenu.dataProvider == dp)
				{
					return cascadingMenu;
				}
			}
			return null;
		}

		protected function getSubMenuDataProvider(node:Object, model:ICascadingMenuModel):Object
		{
			return node[model.submenuField];
		}
		
		protected function getHasMenu(node:Object, model:ICascadingMenuModel):Boolean
		{
			return node.hasOwnProperty(model.submenuField);
		}
		
	}
}