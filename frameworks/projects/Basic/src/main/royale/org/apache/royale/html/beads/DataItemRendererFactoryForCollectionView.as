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
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IIndexedItemRendererInitializer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.utils.sendStrandEvent;
	
	/**
	 * This class creates itemRenderer instances from the data contained within an ICollectionView
	 */
	public class DataItemRendererFactoryForCollectionView extends DataItemRendererFactoryBase
	{
		//resetOnRemove = true can support 'clean-up' in data setters in some renderers, because it automatically sets them to null after removal
		//but it can be problematic if data setters were not configured to handle null values being set, or perhaps any changes in data value, generally.
		//so it is false by default, ensuring compatibility with existing codebases
		protected var resetOnRemove:Boolean;
		
		
		public function DataItemRendererFactoryForCollectionView(target:Object = null)
		{
			super(target);
		}
		
		/**
		 * the dataProvider as a dispatcher
		 */
		protected var dped:IEventDispatcher;
		/**
		 * a way to ensure avoidance of layout for certain local methods from subclasses
		 */
		protected var avoidLayout:Boolean;

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function dataProviderChangeHandler(event:Event):void
		{
			super.dataProviderChangeHandler(event);
			
			if(dped)
			{
				dped.removeEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
				dped.removeEventListener(CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
				dped.removeEventListener(CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);
				dped = null;
			}
			
			if (!dataProviderModel.dataProvider)
				return;
			
			// listen for individual items being added in the future.
			dped = dataProviderModel.dataProvider as IEventDispatcher;
			dped.addEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
			dped.addEventListener(CollectionEvent.ITEM_REMOVED, itemRemovedHandler);
			dped.addEventListener(CollectionEvent.ITEM_UPDATED, itemUpdatedHandler);
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRendererInitializer
		 * @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
		 * @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		protected function itemAddedHandler(event:CollectionEvent):void
		{
			if(!dataProviderExist)
				return;
			var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			var dataGroup:IItemRendererOwnerView = view.dataGroup;
			
			var ir:IIndexedItemRenderer = itemRendererFactory.createItemRenderer() as IIndexedItemRenderer;

			var data:Object = event.item;
			dataGroup.addItemRendererAt(ir, event.index);
			(itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, event.index);

			setRendererData(ir, data);
			// update the index values in the itemRenderers to correspond to their shifted positions.
			if (!avoidLayout) {
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

			//	sendStrandEvent(_strand,"itemsCreated");
				sendStrandEvent(_strand,"layoutNeeded");
			}

		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
		 * @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		protected function itemRemovedHandler(event:CollectionEvent):void
		{
			if(!dataProviderExist)
				return;
			
			var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			var dataGroup:IItemRendererOwnerView = view.dataGroup;
			
			var ir:IIndexedItemRenderer = dataGroup.getItemRendererAt(event.index) as IIndexedItemRenderer;
			if (!ir) return; // may have already been cleaned up, possibly when a tree node closes
			dataGroup.removeItemRenderer(ir);
			//resetOnRemove = true can support 'clean-up' on data setters in some renderers, but can be problematic if data setters were not configured to handle null values, or changes in data value.
			//so it is false by default for greater compatibility with existing codebases
			if (resetOnRemove) setRendererData(ir, null);
			// adjust the itemRenderers' index to adjust for the shift
			if (!avoidLayout) {
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
				sendStrandEvent(_strand,"layoutNeeded");
			}
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRendererInitializer
		 * @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
		 * @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		protected function itemUpdatedHandler(event:CollectionEvent):void
		{
			if(!dataProviderExist)
				return;

			var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			var dataGroup:IItemRendererOwnerView = view.dataGroup;
			
			// update the given renderer with (possibly) new information so it can change its
			// appearance or whatever.
			var ir:IIndexedItemRenderer = dataGroup.getItemRendererAt(event.index) as IIndexedItemRenderer;

			var data:Object = event.item;
			(itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, event.index);
			
			setRendererData(ir, data);
		}

		override protected function get dataProviderLength():int
		{
			return dataProviderModel.dataProvider.length;
		}
		
		override protected function getItemAt(i:int):Object
		{
			return dataProviderModel.dataProvider.getItemAt(i);
		}
	}
}