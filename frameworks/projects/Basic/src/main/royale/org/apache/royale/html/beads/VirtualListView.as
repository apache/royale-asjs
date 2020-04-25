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
package org.apache.royale.html.beads
{
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IItemRenderer;
	import org.apache.royale.core.IRollOverModel;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.ItemRendererEvent;
	import org.apache.royale.utils.getSelectionRenderBead;
		
	/**
	 *  The List class creates the visual elements of the org.apache.royale.html.List
	 *  component. A List consists of the area to display the data (in the dataGroup), any
	 *  scrollbars, and so forth.
	 *
	 *  @viewbead
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class VirtualListView extends VirtualDataContainerView
	{
		public function VirtualListView()
		{
			super();
		}

		protected var listModel:ISelectionModel;

		protected var lastSelectedIndex:int = -1;
		
		/**
		 * @private
		 */
		override protected function handleInitComplete(event:Event):void
		{
			listModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			listModel.addEventListener("selectedIndexChanged", selectionChangeHandler);
			listModel.addEventListener("rollOverIndexChanged", rollOverIndexChangeHandler);
			var mapper:IEventDispatcher = _strand.getBeadByType(IDataProviderItemRendererMapper) as IEventDispatcher;
			mapper.addEventListener(ItemRendererEvent.CREATED, itemCreatedHandler);

			super.handleInitComplete(event);
		}

		protected function itemCreatedHandler(event:ItemRendererEvent):void
		{
			var selectionBead:ISelectableItemRenderer;
			var ir:IIndexedItemRenderer = event.itemRenderer as IIndexedItemRenderer;
			if (ir.index == lastSelectedIndex)
			{
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.selected = true;				
			}
			
		}
		
		protected var firstElementIndex:int = 1;
		
		override public function getItemRendererForIndex(index:int):IItemRenderer
		{
			if (contentView.numElements == 0)
				return null;
			
			var firstIndex:int = (contentView.getElementAt(firstElementIndex) as IIndexedItemRenderer).index;
			
			if (index < firstIndex) 
				return null;
			if (index >= (firstIndex + contentView.numElements))
				return null;
			
			return contentView.getElementAt(index - firstIndex + firstElementIndex) as IItemRenderer;			
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		protected function selectionChangeHandler(event:Event):void
		{
			var selectionBead:ISelectableItemRenderer;
			var ir:IIndexedItemRenderer = (lastSelectedIndex == -1) ? null : dataGroup.getItemRendererForIndex(lastSelectedIndex) as IIndexedItemRenderer;
			if(ir)
			{
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.selected = false;
			}
			ir = dataGroup.getItemRendererForIndex(listModel.selectedIndex) as IIndexedItemRenderer;
			if(ir)
			{
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.selected = true;
			}

			lastSelectedIndex = listModel.selectedIndex;
		}

		protected var lastRollOverIndex:int = -1;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * * @royaleignorecoercion org.apache.royale.core.IRollOverModel
		 */
		protected function rollOverIndexChangeHandler(event:Event):void
		{
			var selectionBead:ISelectableItemRenderer;
			var ir:IIndexedItemRenderer = dataGroup.getItemRendererForIndex(lastRollOverIndex) as IIndexedItemRenderer;
			if(ir)
			{
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.hovered = false;
			}
			ir = dataGroup.getItemRendererForIndex((listModel as IRollOverModel).rollOverIndex) as IIndexedItemRenderer;
			if(ir)
			{
				selectionBead = getSelectionRenderBead(ir);
				if (selectionBead)
					selectionBead.hovered = true;
			}
			lastRollOverIndex = (listModel as IRollOverModel).rollOverIndex;
		}

		override protected function dataProviderChangeHandler(event:Event):void
		{

		}
	}
}
