////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//	  http://www.apache.org/licenses/LICENSE-2.0
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
	import org.apache.royale.core.IBeadController;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IMultiSelectionModel;
	import org.apache.royale.core.IRollOverModel;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemAddedEvent;
	import org.apache.royale.events.ItemRemovedEvent;
	import org.apache.royale.events.MultiSelectionItemClickedEvent;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.utils.getSelectionRenderBead;
	import org.apache.royale.utils.sendEvent;
	import org.apache.royale.core.Bead;

	/**
	 *  The ListMultiSelectionMouseController class is a controller for
	 *  org.apache.royale.html.List.  Controllers
	 *  watch for events from the interactive portions of a View and
	 *  update the data model or dispatch a semantic event.
	 *  This controller watches for events from the item renderers
	 *  and updates an IMultiSelectionModel (which supports multi
	 *  selection).	  
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.7
	 */
	public class ListMultiSelectionMouseController extends Bead implements IBeadController
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function ListMultiSelectionMouseController()
		{
		}

		/**
		 *  The model.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		protected var listModel:IMultiSelectionModel;

		/**
		 *  The view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		protected var listView:IListView;

		/**
		 *  The parent of the item renderers.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		protected var dataGroup:IItemRendererOwnerView;


		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 *  @royaleignorecoercion org.apache.royale.core.IMultiSelectionModel
		 *  @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			listModel = value.getBeadByType(IMultiSelectionModel) as IMultiSelectionModel;
			listView = value.getBeadByType(IListView) as IListView;
			listenOnStrand("itemAdded", handleItemAdded);
			listenOnStrand("itemRemoved", handleItemRemoved);
		}

		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function handleItemAdded(event:ItemAddedEvent):void
		{
			IEventDispatcher(event.item).addEventListener("itemClicked", selectedHandler);
			IEventDispatcher(event.item).addEventListener("itemRollOver", rolloverHandler);
			IEventDispatcher(event.item).addEventListener("itemRollOut", rolloutHandler);
		}

		/**
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function handleItemRemoved(event:ItemRemovedEvent):void
		{
			IEventDispatcher(event.item).removeEventListener("itemClicked", selectedHandler);
			IEventDispatcher(event.item).removeEventListener("itemRollOver", rolloverHandler);
			IEventDispatcher(event.item).removeEventListener("itemRollOut", rolloutHandler);
		}

		protected function selectedHandler(event:MultiSelectionItemClickedEvent):void
		{
			var selectedIndices:Array = [];
			var newIndices:Array;
			if (!(event.ctrlKey || event.shiftKey) || !listModel.selectedIndices || listModel.selectedIndices.length == 0)
			{
				newIndices = [event.index];
			} else if (event.ctrlKey)
			{
				// concat is so we have a new instance, avoiding code that might presume no change was made according to instance
				newIndices = listModel.selectedIndices.concat();
				var locationInSelectionList:int = newIndices.indexOf(event.index);
				if (locationInSelectionList < 0)
				{
					newIndices.push(event.index);
				} else
				{
					newIndices.removeAt(locationInSelectionList);
				}
			} else if (event.shiftKey)
			{
				newIndices = [];
				var min:int = getMin(listModel.selectedIndices);
				var max:int = getMax(listModel.selectedIndices);
				var from:int = Math.min(min, event.index);
				var to:int = event.index > min ? event.index : min;
				while (from <= to)
				{
					newIndices.push(from++);
				}
			}
			listModel.selectedIndices = newIndices;
			sendEvent(listView.host,"change");
		}

		private function getMin(value:Array):int
		{
			var result:int = int(value[0]);
			for (var i:int = 0; i < value.length; i++)
			{
				if (value[i] < result)
				{
					result = value[i];
				}
			}
			return result;
		}

		private function getMax(value:Array):int
		{
			var result:int = int(value[0]);
			for (var i:int = 0; i < value.length; i++)
			{
				if (value[i] > result)
				{
					result = value[i];
				}
			}
			return result;
		}

		/**
		 * @royaleemitcoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.core.IRollOverModel
		 */
		protected function rolloverHandler(event:Event):void
		{
			var renderer:IIndexedItemRenderer = event.currentTarget as IIndexedItemRenderer;
			if (renderer) {
				IRollOverModel(listModel).rollOverIndex = renderer.index;
			}
		}

		/**
		 * @royaleemitcoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.core.IRollOverModel
		 */
		protected function rolloutHandler(event:Event):void
		{
			var renderer:IIndexedItemRenderer = event.currentTarget as IIndexedItemRenderer;
			if (renderer) {
				if (renderer is IStrand)
				{
					var selectionBead:ISelectableItemRenderer = getSelectionRenderBead(renderer);
					if (selectionBead)
					{
						selectionBead.hovered = false;
						selectionBead.down = false;						
					}
				}
				IRollOverModel(listModel).rollOverIndex = -1;
			}
		}
	}
}
