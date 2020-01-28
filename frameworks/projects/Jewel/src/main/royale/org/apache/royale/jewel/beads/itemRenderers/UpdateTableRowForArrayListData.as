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
	import org.apache.royale.core.IItemRendererOwnerView;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.IListView;
	import org.apache.royale.jewel.beads.models.TableModel;
	import org.apache.royale.jewel.supportClasses.table.TableCell;
	import org.apache.royale.jewel.supportClasses.table.TableRow;

    /**
	 *  Handles the update of an itemRenderer in a Table component once the corresponding 
	 *  datum has been updated from the IDataProviderModel.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class UpdateTableRowForArrayListData implements IBead
	{
		/**
		 *  Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function UpdateTableRowForArrayListData()
		{
		}

		protected var _strand:IStrand;
		/**
		 *  @copy org.apache.royale.core.IStrand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
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
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
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
		 * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
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
		 *  @productversion Royale 0.9.4
		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.table.TableCell
		 *  @royaleignorecoercion org.apache.royale.jewel.supportClasses.table.TableRow
		 *  @royaleignorecoercion org.apache.royale.core.ISelectableItemRenderer
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		protected function handleItemUpdated(event:CollectionEvent):void
		{
			var ir:ISelectableItemRenderer;
			var processedRow:TableRow = (itemRendererOwnerView as UIBase).getElementAt(event.index) as TableRow;
			var cell:TableCell;
			var n:int = processedRow.numElements;

			for (var i:int = 0; i < n; i++)
			{
				cell = processedRow.getElementAt(i) as TableCell;
				ir = cell.getElementAt(0) as ISelectableItemRenderer;
				setData(ir, event.item, event.index);
			}
			
			(_strand as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));
		}

		private var _itemRendererOwnerView: IItemRendererOwnerView;

		/**
		 *  The org.apache.royale.core.IItemRendererOwnerView used
		 *  to generate instances of item renderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
         *  @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		public function get itemRendererOwnerView():IItemRendererOwnerView
		{
			if (_itemRendererOwnerView == null) {
				var listView:IListView = _strand.getBeadByType(IListView) as IListView;
				_itemRendererOwnerView = listView.dataGroup;
			}
			return _itemRendererOwnerView;
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
