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
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.html.CascadingMenu;
	import org.apache.royale.html.beads.models.CascadingMenuModel;
	
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
				
		private var _strand:IStrand;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
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
		 * @private
		 * 
		 * Replaces the selectedHandler from the super class to handle the presentation of
		 * submenus. If an element has the submenu indicator, a new CascadingMenu is presented.
		 * If the element is a regular element, then the super class's handler is called.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		override protected function selectedHandler(event:ItemClickedEvent):void
		{
			var node:Object = event.data;
			
			var model:CascadingMenuModel = _strand.getBeadByType(IBeadModel) as CascadingMenuModel;
			
			if (node.hasOwnProperty(model.submenuField)) {
				var component:IUIBase = event.target as IUIBase;
				var menu:IMenu = new CascadingMenu();
				menu.dataProvider = node[model.submenuField];
				menu.labelField = model.labelField;
				menu.parentMenuBar = (_strand as IMenu).parentMenuBar;
				menu.show(component, component.width, 0);
			}
			else {
				super.selectedHandler(event);
				hideOpenMenus();
			}
		}
	}
}