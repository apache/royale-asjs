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
	import org.apache.royale.core.IFactory;
	import org.apache.royale.core.IMenu;
	import org.apache.royale.core.IMenuBarModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemAddedEvent;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.events.ItemRemovedEvent;
	import org.apache.royale.html.Menu;
	import org.apache.royale.html.MenuBar;
	import org.apache.royale.utils.UIUtils;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.utils.sendEvent;

	/**
	 * The MenuBarMouseController handles mouse events for the MenuBar. While the menu bar is
	 * a list, selecting an item causes a Menu (or one of its subclasses) to appear.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class MenuBarMouseController extends ListSingleSelectionMouseController
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function MenuBarMouseController()
		{
			super();
		}
				
		/**
		 * @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
		}
        /**
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
		override protected function handleItemAdded(event:ItemAddedEvent):void
		{
			IEventDispatcher(event.item).addEventListener("itemMouseDown", selectedHandler);
			IEventDispatcher(event.item).addEventListener("itemRollOver", rolloverHandler);
			IEventDispatcher(event.item).addEventListener("itemRollOut", rolloutHandler);
		}
		
        /**
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
		override protected function handleItemRemoved(event:ItemRemovedEvent):void
		{
			IEventDispatcher(event.item).removeEventListener("itemMouseDown", selectedHandler);
			IEventDispatcher(event.item).removeEventListener("itemRollOver", rolloverHandler);
			IEventDispatcher(event.item).removeEventListener("itemRollOut", rolloutHandler);
		}
		
		/**
		 * Called when an item in the MenuBar is selected; it produces an IMenu below
		 * the item selected.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
		 *  @royaleignorecoercion org.apache.royale.core.UIBase
		 *  @royaleignorecoercion org.apache.royale.core.IFactory
		 *  @royaleignorecoercion org.apache.royale.core.IMenuBarModel
     * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function selectedHandler(event:ItemClickedEvent):void
		{
			// close any previously open menus
			var host:UIBase = UIUtils.findPopUpHost(_strand as IUIBase) as UIBase;
			sendEvent(host,"hideMenus");
			
			var component:IUIBase = event.target as IUIBase;
			
			var menuFactory:IFactory = loadBeadFromValuesManager(IFactory, "iMenuFactory", _strand) as IFactory;
			var menu:IMenu = menuFactory.newInstance() as IMenu;
			
			var model:IMenuBarModel = _strand.getBeadByType(IBeadModel) as IMenuBarModel;
			
			menu.dataProvider = getMenuDataProvider(event.data, model.submenuField);
			menu.labelField = model.labelField;
			menu.submenuField = model.submenuField;
			menu.parentMenuBar = _strand as IEventDispatcher;
            showMenu(menu, component);
        }
        
        protected function getMenuDataProvider(obj:Object, fieldName:String):Object
        {
            return obj[fieldName];
        }
        
        protected function showMenu(menu:IMenu, component:IUIBase):void
        {
			menu.show(component, 0, component.height);
		}
	}
}