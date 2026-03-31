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
package org.apache.royale.style.beads
{
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.style.List;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.events.ItemAddedEvent;
	import org.apache.royale.events.ItemRemovedEvent;
	import org.apache.royale.events.ItemClickedEvent;
	import org.apache.royale.utils.sendStrandEvent;
	import org.apache.royale.style.renderers.IListItemRenderer;
	import org.apache.royale.events.Event;

	public class ListController implements IBeadController
	{
		public function ListController()
		{			
		}
		/**
		 *  The model.
		 */
		protected var listModel:ListModel;

		/**
		 *  The view.
		 *  
		 */
		protected var listView:IListView;

		/**
		 *  The parent of the item renderers.
		 */
		protected var dataGroup:IItemRendererOwnerView;

		protected var _strand:IStrand;

		private var host:List;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 * @royaleignorecoercion org.apache.royale.style.List
		 * @royaleignorecoercion org.apache.royale.style.beads.ListModel
		 * @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			host = value as List;
      listModel = host.model as ListModel;
			listView = host.view as IListView;
			host.addEventListener("itemAdded", handleItemAdded);
			host.addEventListener("itemRemoved", handleItemRemoved);
			loadBeadFromValuesManager(IKeyboardHandler, "iKeyboardHandler", _strand);
		}
		
    /**
     * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
     */
		protected function handleItemAdded(event:ItemAddedEvent):void
		{
			(event.item as IEventDispatcher).addEventListener("itemClicked", selectedHandler);
			(event.item as IEventDispatcher).addEventListener("itemRollOver", rolloverHandler);
			(event.item as IEventDispatcher).addEventListener("itemRollOut", rolloutHandler);
		}
		
        /**
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         */
		protected function handleItemRemoved(event:ItemRemovedEvent):void
		{
			(event.item as IEventDispatcher).removeEventListener("itemClicked", selectedHandler);
			(event.item as IEventDispatcher).removeEventListener("itemRollOver", rolloverHandler);
			(event.item as IEventDispatcher).removeEventListener("itemRollOut", rolloutHandler);
		}
		
		protected function selectedHandler(event:ItemClickedEvent):void
		{
			listModel.selectedIndex = event.index;
			listModel.selectedItem = event.data;
			sendStrandEvent(_strand,"change");
		}
		
		/**
		 * @royaleemitcoercion org.apache.royale.style.renderers.IListItemRenderer
		 */
		protected function rolloverHandler(event:Event):void
		{
			var renderer:IListItemRenderer = event.currentTarget as IListItemRenderer;
			if (renderer) {
				listModel.rollOverIndex = renderer.index;
			}
		}
		
		/**
			* @royaleemitcoercion org.apache.royale.style.renderers.IListItemRenderer
			*/
		protected function rolloutHandler(event:Event):void
		{
			var renderer:IListItemRenderer  = event.currentTarget as IListItemRenderer;
			if (renderer) {
				renderer.hovered = false;
				renderer.down = false;
				listModel.rollOverIndex = -1;
			}
		}

	}	
}