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
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.core.Bead;
	import org.apache.royale.utils.sendStrandEvent;

	/**
	 *  Handles the removal of all itemRenderers once the all items has been removed
	 *  from the IDataProviderModel.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.0
	 */
	public class DynamicRemoveAllItemRendererForArrayListData extends Bead
	{
		/**
		 * Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.0
		 */
		public function DynamicRemoveAllItemRendererForArrayListData()
		{
		}

		/**
		 * @copy org.apache.royale.core.IStrand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.0
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			listenOnStrand("initComplete", initComplete);
		}
		
		/**
		 *  finish setup
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function initComplete(event:Event):void
		{
			(_strand as IEventDispatcher).removeEventListener("initComplete", initComplete);
			
			_dataProviderModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			dataProviderModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);	
			
			// invoke now in case "dataProviderChanged" has already been dispatched.
			dataProviderChangeHandler(null);
		}
		
		private var dp:IEventDispatcher;
		/**
		 * @private
		 *  @royaleemitcoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			if(dp)
			{
				dp.removeEventListener(CollectionEvent.ALL_ITEMS_REMOVED, handleAllItemsRemoved);
			}
			dp = dataProviderModel.dataProvider as IEventDispatcher;
			if (!dp)
				return;
			
			// listen for all items being removed in the future.
			dp.addEventListener(CollectionEvent.ALL_ITEMS_REMOVED, handleAllItemsRemoved);
		}

		/**
		 *  Handles the allItemsRemoved event by removing the item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.0
		 *  @royaleignorecoercion org.apache.royale.core.ISelectionModel
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function handleAllItemsRemoved(event:CollectionEvent):void
		{
			if (dataProviderModel is ISelectionModel)
			{
				var model:ISelectionModel = dataProviderModel as ISelectionModel;
				model.selectedIndex = -1;
				model.selectedItem = null;
			}

			itemRendererOwnerView.removeAllItemRenderers();
			sendStrandEvent(_strand,"layoutNeeded");
		}

		private var _dataProviderModel: IDataProviderModel;

		/**
		 *  The org.apache.royale.core.IDataProviderModel that contains the
		 *  data source.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.0
		 *  @royaleignorecoercion org.apache.royale.core.IDataProviderModel
		 */
		public function get dataProviderModel(): IDataProviderModel
		{
			if (_dataProviderModel == null && _strand != null) {
				_dataProviderModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
			}
			return _dataProviderModel;
		}

		private var _itemRendererOwnerView: IItemRendererOwnerView;

		/**
		 *  The org.apache.royale.core.IItemRendererOwnerView used
		 *  to generate instances of item renderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.0
         *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
         *  @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		public function get itemRendererOwnerView():IItemRendererOwnerView
		{
			if (_itemRendererOwnerView == null) {
				var view:IListView = (_strand as IStrandWithModelView).view as IListView;
				_itemRendererOwnerView = view.dataGroup;
			}
			return _itemRendererOwnerView;
		}
	}
}
