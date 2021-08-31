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
package org.apache.royale.jewel.beads.itemRenderers
{
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IIndexedItemRendererInitializer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.DataItemRendererFactoryForCollectionView;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.jewel.beads.models.IDropDownListModel;
	import org.apache.royale.jewel.itemRenderers.DropDownListItemRenderer;

	/**
	 * This class creates itemRenderer instances from the data contained within an ICollectionView
	 */
	public class DropDownListItemRendererFactoryForCollectionView extends DataItemRendererFactoryForCollectionView
	{
		public function DropDownListItemRendererFactoryForCollectionView(target:Object = null)
		{
			super(target);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.jewel.supportClasses.list.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function dataProviderChangeHandler(event:Event):void
		{
			if (!dataProviderModel)
				return;

			var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			var dataGroup:IItemRendererOwnerView = view.dataGroup;
			
			removeAllItemRenderers(dataGroup);

			if (!dataProviderModel.dataProvider)
				return;
			
			var offset:int = (dataProviderModel as IDropDownListModel).offset;
			var data:Object;
			if(offset == 1) {
				promptRender = itemRendererFactory.createItemRenderer() as IIndexedItemRenderer;
				data = DropDownListItemRenderer.OPTION_DISABLED;
				(itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(promptRender, data, 0);
				promptRender.data = data;				
				dataGroup.addItemRenderer(promptRender, false);
			}
			
			var n:int = dataProviderLength;
			var ir:IIndexedItemRenderer;
			for (var i:int = 0; i < n; i++)
			{				
				ir = itemRendererFactory.createItemRenderer() as IIndexedItemRenderer;
				data = getItemAt(i);
				(itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, i + offset);
				ir.data = data;				
				dataGroup.addItemRenderer(ir, false);
			}
			
			dispatchItemCreatedEvent();
			
			if(dped)
			{
				dped.removeEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
				dped.removeEventListener(CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
				dped.removeEventListener(CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);
			}
			// listen for individual items being added in the future.
			dped = dataProviderModel.dataProvider as IEventDispatcher;
			dped.addEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
			dped.addEventListener(CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
			dped.addEventListener(CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);
		}

		/**
		 *  @royalesuppresspublicvarwarning
		 */
		public var promptRender:IIndexedItemRenderer;

		/**
		 * used when need to update prompt at runtime
		 */
		public function updatePromptRender():void
		{
			if(promptRender)
			{
				promptRender.index = 0;
				promptRender.data = DropDownListItemRenderer.OPTION_DISABLED;
			}
		}
	}
}