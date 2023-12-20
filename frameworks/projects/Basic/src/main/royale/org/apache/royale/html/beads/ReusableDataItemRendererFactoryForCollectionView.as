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
	import org.apache.royale.utils.sendStrandEvent;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IIndexedItemRendererInitializer;
	import org.apache.royale.core.IItemRendererOwnerView;
	/**
	 * The ReusableDataItemRendererFactoryForCollectionView class will save removed itemRenderers
	 * and reuse them when new item renderers are needed. This is useful for large collections
	 * where creating new item renderers can be expensive. Using this class can drastically
	 * reduce rendering time at the expense of preventing the unused item renderers from being
	 * garbage collected.
	 * 
	 * In an unscientific test, using this class reduced rendering time by about a factor of 100 in some cases.
	 * 
	 * Item renderers must be able to be reused. Resetting the data property must properly reset the state and
	 * clean any event listeners from the old state.
	 */
	public class ReusableDataItemRendererFactoryForCollectionView extends DataItemRendererFactoryForCollectionView
	{
		public function ReusableDataItemRendererFactoryForCollectionView(target:Object = null)
		{
			super(target);
		}

		private var _unusedRenderers:Array = [];

		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRendererInitializer
		 * @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
		 * @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		override protected function itemAddedHandler(event:CollectionEvent):void
		{
			if(!dataProviderExist)
				return;
			var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			var dataGroup:IItemRendererOwnerView = view.dataGroup;
			
			var ir:IIndexedItemRenderer;
			if(_unusedRenderers.length > 0)
				ir = _unusedRenderers.pop();

			else
				ir = itemRendererFactory.createItemRenderer() as IIndexedItemRenderer;

			var data:Object = event.item;
			dataGroup.addItemRendererAt(ir, event.index);
			(itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, event.index);
			ir.data = data;
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
			
			sendStrandEvent(_strand,"itemsCreated");
			// The itemsCreated handler sends layoutNeeded, so no need to do it here.
			// sendStrandEvent(_strand,"layoutNeeded");
		}
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.collections.ICollectionView
		 * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 * @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
		 * @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		override protected function itemRemovedHandler(event:CollectionEvent):void
		{
			if(!dataProviderExist)
				return;
			
			var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			var dataGroup:IItemRendererOwnerView = view.dataGroup;
			
			var ir:IIndexedItemRenderer = dataGroup.getItemRendererAt(event.index) as IIndexedItemRenderer;
			if (!ir) return; // may have already been cleaned up, possibly when a tree node closes
			dataGroup.removeItemRenderer(ir);
			_unusedRenderers.push(ir);
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

			sendStrandEvent(_strand,"layoutNeeded");
		}
				
	}
}