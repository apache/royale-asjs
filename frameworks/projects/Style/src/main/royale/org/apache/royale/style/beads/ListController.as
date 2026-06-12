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

	/**
	 * Controller for list item selection and rollover state.
	 *
	 * @langversion 3.0
	 * @productversion Royale 1.0.0
	 */
	public class ListController implements IBeadController
	{
		/**
		 * Creates a ListController bead.
		 */
		public function ListController()
		{			
		}

		/**
		 * The model for the list.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		protected var listModel:ListModel;

		/**
		 * The view for the list.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		protected var listView:IListView;

		/**
		 * The parent of the item renderers.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		protected var dataGroup:IItemRendererOwnerView;

		/**
		 * The strand that owns this bead.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		protected var _strand:IStrand;

		private var host:List;
		
		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 *
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
		 * Adds item renderer event listeners.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 *
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function handleItemAdded(event:ItemAddedEvent):void
		{
			(event.item as IEventDispatcher).addEventListener("itemClicked", selectedHandler);
			(event.item as IEventDispatcher).addEventListener("itemRollOver", rolloverHandler);
			(event.item as IEventDispatcher).addEventListener("itemRollOut", rolloutHandler);
		}
		
		/**
		 * Removes item renderer event listeners.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 *
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function handleItemRemoved(event:ItemRemovedEvent):void
		{
			(event.item as IEventDispatcher).removeEventListener("itemClicked", selectedHandler);
			(event.item as IEventDispatcher).removeEventListener("itemRollOver", rolloverHandler);
			(event.item as IEventDispatcher).removeEventListener("itemRollOut", rolloutHandler);
		}
		
		/**
		 * Updates the selected item in the list model.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		protected function selectedHandler(event:ItemClickedEvent):void
		{
			listModel.selectedIndex = event.index;
			listModel.selectedItem = event.data;
			sendStrandEvent(_strand,"change");
		}
		
		/**
		 * Updates the rollover index in the list model.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 *
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
		 * Clears rollover and pressed state from the item renderer.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 *
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