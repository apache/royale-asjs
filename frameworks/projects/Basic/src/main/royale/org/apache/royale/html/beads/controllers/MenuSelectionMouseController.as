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
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.html.Menu;
	import org.apache.royale.html.beads.models.MenuModel;
	import org.apache.royale.utils.UIUtils;
	
	COMPILE::JS {
		import org.apache.royale.events.BrowserEvent;
	}

	/**
	 * Listens for item selections on the component and translates them to external events. Also
	 * listens for events on the background and uses them to dismiss the menu.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class MenuSelectionMouseController extends ListSingleSelectionMouseController
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function MenuSelectionMouseController()
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
			
			(_strand as IEventDispatcher).addEventListener("menuWillHide", handleMenuWillHide);
			
			// detect an up event on the background as a way to dismiss this menu
			COMPILE::SWF {
				var host:IEventDispatcher = UIUtils.findPopUpHost(_strand as IUIBase) as IEventDispatcher;
				host.addEventListener(MouseEvent.MOUSE_UP, hideMenu_internal);
			}
			COMPILE::JS {
				window.addEventListener('mouseup', hideMenu_internal, false);
			}
		}
		
		/**
		 * Listen for selections made on the component and translate them into change events.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		override protected function selectedHandler(event:ItemClickedEvent):void
		{						
			var menuModel:MenuModel = listModel as MenuModel;
			var node:Object = event.data;
			
			listModel.selectedItem = node;
			IEventDispatcher(_strand).dispatchEvent(new Event("change"));
		}
		
		// Internal Event Handling
		
		COMPILE::SWF
		private function handleMenuWillHide(event:Event):void
		{
			var host:IEventDispatcher = UIUtils.findPopUpHost(_strand as IUIBase) as IEventDispatcher;
			host.removeEventListener(MouseEvent.MOUSE_UP, hideMenu_internal);
		}
		
		COMPILE::JS
		private function handleMenuWillHide(event:Event):void
		{
			window.removeEventListener('mouseup', hideMenu_internal, false);
		}
		
		COMPILE::SWF
		private function hideMenu_internal(event:MouseEvent):void
		{
			(_strand as Menu).hide();
		}

		COMPILE::JS
		private function hideMenu_internal(event:BrowserEvent):void
		{			
			event.stopImmediatePropagation();
			(_strand as Menu).hide();
		}
	}
}