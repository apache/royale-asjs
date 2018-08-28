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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDataProviderModel;
    import org.apache.royale.core.IItemRendererParent;
	import org.apache.royale.core.IList;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.jewel.beads.models.TableModel;

    /**
	 *  Handles the update of an itemRenderer in a Table component once the corresponding 
	 *  datum has been updated from the IDataProviderModel.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class UpdateTableItemRendererForArrayListData implements IBead
	{
		/**
		 *  Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function UpdateTableItemRendererForArrayListData()
		{
		}

		
		protected var _strand:IStrand;
		/**
		 *  @copy org.apache.royale.core.IStrand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("initComplete", initComplete);
		}

        protected var labelField:String;
		
		protected var model:TableModel;

		/**
		 *  finish setup
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		protected function initComplete(event:Event):void
		{
			IEventDispatcher(_strand).removeEventListener("initComplete", initComplete);
			
			model = _strand.getBeadByType(ISelectionModel) as TableModel;
			labelField = model.labelField;

			model.addEventListener("dataProviderChanged", dataProviderChangeHandler);

			// invoke now in case "dataProviderChanged" has already been dispatched.
			dataProviderChangeHandler(null);
		}
		
		private var dp:IEventDispatcher;
		/**
		 * @private
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			if(dp)
			{
				dp.removeEventListener(CollectionEvent.ITEM_UPDATED, handleItemUpdated);
			}
			dp = model.dataProvider as IEventDispatcher;
			if (!dp)
				return;
			
			// listen for individual items being added in the future.
			dp.addEventListener(CollectionEvent.ITEM_UPDATED, handleItemUpdated);
		}

		/**
		 *  Handles the itemUpdated event by updating the item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		protected function handleItemUpdated(event:CollectionEvent):void
		{
            var ir:ISelectableItemRenderer = itemRendererParent.getItemRendererForIndex(event.index) as ISelectableItemRenderer;
			
            setData(ir, event.item, event.index);

			(_strand as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));
		}

		private var _itemRendererParent: IItemRendererParent;

		/**
		 *  The org.apache.royale.core.IItemRendererParent used
		 *  to generate instances of item renderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get itemRendererParent():IItemRendererParent
		{
			if (_itemRendererParent == null) {
				var list:IList = _strand as IList;
				_itemRendererParent = list.dataGroup;
			}
			return _itemRendererParent;
		}

        /**
         * @private
         */
        protected function setData(itemRenderer:ISelectableItemRenderer, data:Object, index:int):void
        {
            itemRenderer.index = index;
            itemRenderer.data = data;
        }
	}
}
