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
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.utils.sendStrandEvent;

	/**
	 * Handles the removal of an itemRenderer once the corresponding datum has been removed
	 * from the IDataProviderModel.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.0
	 */
	public class DynamicRemoveItemRendererForArrayListData extends ItemRendererFactoryBase
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.0
		 */
		public function DynamicRemoveItemRendererForArrayListData()
		{
		}

		private var dp:IEventDispatcher;
		/**
		 * @private
		 *  @royaleemitcoercion org.apache.royale.events.IEventDispatcher
		 */
		override protected function dataProviderChangeHandler(event:Event):void
		{
			if(dp)
			{
				dp.removeEventListener(CollectionEvent.ITEM_REMOVED, handleItemRemoved);
			}
			dp = dataProviderModel.dataProvider as IEventDispatcher;
			if (!dp)
				return;
			
			// listen for individual items being added in the future.
			dp.addEventListener(CollectionEvent.ITEM_REMOVED, handleItemRemoved);
		}

		/**
		 * Handles the itemRemoved event by removing the item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.0
		 *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
		 *  @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 *  @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		protected function handleItemRemoved(event:CollectionEvent):void
		{
			var view:IListView = (_strand as IStrandWithModelView).view as IListView;
			var dataGroup:IItemRendererOwnerView = view.dataGroup;
			var ir:IIndexedItemRenderer = dataGroup.getItemRendererForIndex(event.index) as IIndexedItemRenderer;
			dataGroup.removeItemRenderer(ir);
			
			// adjust the itemRenderers' index to adjust for the shift
			var n:int = dataGroup.numItemRenderers;
			for (var i:int = event.index; i < n; i++)
			{
				ir = dataGroup.getItemRendererForIndex(i) as IIndexedItemRenderer;
				ir.index = i;
			}
			sendStrandEvent(_strand,"layoutNeeded");
		}
	}
}
