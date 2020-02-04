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
package org.apache.royale.html.beads
{
	import org.apache.royale.collections.ICollectionView;
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IDataProviderItemRendererMapper;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.supportClasses.StringItemRenderer;
	import org.apache.royale.html.supportClasses.UIItemRendererBase;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.html.beads.IListView;

	
	/**
	 * This class creates itemRenderer instances from the data contained within an ICollectionView
	 */
	public class DataItemRendererFactoryForCollectionView extends DataItemRendererFactoryBase
	{
		public function DataItemRendererFactoryForCollectionView(target:Object = null)
		{
			super(target);
		}
		
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			if (!dataProviderModel)
				return;
			var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
			// listen for individual items being added in the future.
			var dped:IEventDispatcher = dp as IEventDispatcher;
			dped.addEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
			dped.addEventListener(CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
			dped.addEventListener(CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);
			
            super.dataProviderChangeHandler(event);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function itemAddedHandler(event:CollectionEvent):void
		{
			if (!dataProviderModel)
				return;
			var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
			var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
			var ir:IIndexedItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as IIndexedItemRenderer;
			labelField = dataProviderModel.labelField;
			
			fillRenderer(event.index, event.item, ir, presentationModel);
			
			// update the index values in the itemRenderers to correspond to their shifted positions.
			var n:int = dataGroup.numItemRenderers;
			for (var i:int = event.index; i < n; i++)
			{
				ir = dataGroup.getItemRendererAt(i) as IIndexedItemRenderer;
				ir.index = i;
				
				// could let the IR know its index has been changed (eg, it might change its
				// UI based on the index). Instead (PAYG), allow another bead to detect
				// this event and do this as not every IR will need to be updated.
				//var ubase:UIItemRendererBase = ir as UIItemRendererBase;
				//if (ubase) ubase.updateRenderer()
			}
			
			(_strand as IEventDispatcher).dispatchEvent(new Event("itemsCreated"));
			(_strand as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function itemRemovedHandler(event:CollectionEvent):void
		{
			if (!dataProviderModel)
				return;
			var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;
			
			var ir:IIndexedItemRenderer = dataGroup.getItemRendererAt(event.index) as IIndexedItemRenderer;
			dataGroup.removeItemRenderer(ir);
			
			// adjust the itemRenderers' index to adjust for the shift
			var n:int = dataGroup.numItemRenderers;
			for (var i:int = event.index; i < n; i++)
			{
				ir = dataGroup.getItemRendererAt(i) as IIndexedItemRenderer;
				ir.index = i;
				
				// could let the IR know its index has been changed (eg, it might change its
				// UI based on the index). Instead (PAYG), allow another bead to detect
				// this event and do this as not every IR will need to be updated.
				//var ubase:UIItemRendererBase = ir as UIItemRendererBase;
				//if (ubase) ubase.updateRenderer()
			}
			
			(_strand as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		protected function itemUpdatedHandler(event:CollectionEvent):void
		{
			if (!dataProviderModel)
				return;
			var dp:ICollectionView = dataProviderModel.dataProvider as ICollectionView;
			if (!dp)
				return;

			// update the given renderer with (possibly) new information so it can change its
			// appearence or whatever.
			var ir:IIndexedItemRenderer = dataGroup.getItemRendererAt(event.index) as IIndexedItemRenderer;
			setData(ir, event.item, event.index);
		}
		
	}
}