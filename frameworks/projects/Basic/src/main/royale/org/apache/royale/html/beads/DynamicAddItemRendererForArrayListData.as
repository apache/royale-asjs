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
	import org.apache.royale.collections.IArrayList;
	import org.apache.royale.core.IIndexedItemRenderer;
	import org.apache.royale.core.IIndexedItemRendererInitializer;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.utils.sendStrandEvent;

	/**
	 *  Handles the adding of an itemRenderer once the corresponding datum has been added
	 *  from the IDataProviderModel.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.0
	 */
	public class DynamicAddItemRendererForArrayListData extends ItemRendererFactoryBase
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.0
		 */
		public function DynamicAddItemRendererForArrayListData()
		{
		}

		private var dp:IArrayList;
		/**
		 *  @private
		 *  @royaleemitcoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function dataProviderChangeHandler(event:Event):void
		{
			if(dp)
			{
				dp.removeEventListener(CollectionEvent.ITEM_ADDED, handleItemAdded);
			}
			dp = dataProviderModel.dataProvider as IArrayList;
			if (!dp)
				return;
			
			// listen for individual items being added in the future.
			dp.addEventListener(CollectionEvent.ITEM_ADDED, handleItemAdded);
		}

		/**
		 * Handles the itemRemoved event by removing the item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.0
		 *  @royaleignorecoercion org.apache.royale.core.IListPresentationModel
		 *  @royaleignorecoercion org.apache.royale.core.IParent
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 */
		protected function handleItemAdded(event:CollectionEvent):void
		{
			var ir:IIndexedItemRenderer = itemRendererFactory.createItemRenderer() as IIndexedItemRenderer;

			var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			var dataGroup:IItemRendererOwnerView = view.dataGroup;
			
			// update the index values in the itemRenderers to correspond to their shifted positions.
			dataGroup.addItemRenderer(ir, false);
			var data:Object = event.item;
			(itemRendererInitializer as IIndexedItemRendererInitializer).initializeIndexedItemRenderer(ir, data, event.index);
			ir.data = data;
			
			// update the index values in the itemRenderers to correspond to their shifted positions.
			var n:int = dataGroup.numItemRenderers;
			for (var i:int = event.index; i < n; i++)
			{
				ir = dataGroup.getItemRendererAt(i) as IIndexedItemRenderer;
				ir.index = i;
			}
			sendStrandEvent(_strand,"layoutNeeded");
		}
	}
}
