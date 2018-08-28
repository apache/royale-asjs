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
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererParent;
	import org.apache.royale.core.IList;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.jewel.beads.models.TableModel;
	import org.apache.royale.jewel.supportClasses.table.TableColumn;
	import org.apache.royale.jewel.beads.itemRenderers.ITextItemRenderer;
	import org.apache.royale.jewel.supportClasses.table.TBodyContentArea;
	import org.apache.royale.html.supportClasses.DataItemRenderer;
	import org.apache.royale.collections.ICollectionView;

    /**
	 *  Handles the adding of an itemRenderer in a Table component once the corresponding datum has been added
	 *  from the IDataProviderModel.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class AddTableItemRendererForArrayListData implements IBead
	{
		/**
		 *  Constructor
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function AddTableItemRendererForArrayListData()
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
				dp.removeEventListener(CollectionEvent.ITEM_ADDED, handleItemAdded);
			}
			dp = model.dataProvider as IEventDispatcher;
			if (!dp)
				return;
			
			// listen for individual items being added in the future.
			dp.addEventListener(CollectionEvent.ITEM_ADDED, handleItemAdded);
		}

		/**
		 *  Handles the itemRemoved event by removing the item.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		protected function handleItemAdded(event:CollectionEvent):void
		{
            var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
			var column:TableColumn;
			var ir:ITextItemRenderer;

			var index:int = event.index * model.columns.length;
			for(var j:int = 0; j < model.columns.length; j++)
			{
				column = model.columns[j] as TableColumn;
				
				if(column.itemRenderer != null)
				{
					ir = column.itemRenderer.newInstance() as ITextItemRenderer;
				} else
				{
					ir = itemRendererFactory.createItemRenderer(itemRendererParent) as ITextItemRenderer;
				}

				labelField =  column.dataField;
		
				(ir as DataItemRenderer).dataField = labelField;
				(ir as DataItemRenderer).rowIndex = event.index;
				(ir as DataItemRenderer).columnIndex = j;
		
				fillRenderer(index++, event.item, (ir as ISelectableItemRenderer), presentationModel);
				
				if(column.align != "")
				{
					ir.align = column.align;
				}
			}

			// update the index values in the itemRenderers to correspond to their shifted positions.
			var n:int = itemRendererParent.numElements;
			var d:DataItemRenderer;
			for (var i:int = event.index; i < n; i++)
			{
				d = itemRendererParent.getItemRendererForIndex(i) as DataItemRenderer;
				d.index = i;
			}

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

        private var _itemRendererFactory:IItemRendererClassFactory;

        /**
         *  The org.apache.royale.core.IItemRendererClassFactory used
         *  to generate instances of item renderers.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
        public function get itemRendererFactory():IItemRendererClassFactory
        {
            if(!_itemRendererFactory)
                _itemRendererFactory = loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", _strand) as IItemRendererClassFactory;

            return _itemRendererFactory;
        }

        /**
         * @private
         */
        protected function fillRenderer(index:int,
                                        item:Object,
                                        itemRenderer:ISelectableItemRenderer,
                                        presentationModel:IListPresentationModel):void
        {
            itemRendererParent.addItemRendererAt(itemRenderer, index);

            itemRenderer.labelField = labelField;

            if (presentationModel) {
                var style:SimpleCSSStyles = new SimpleCSSStyles();
                style.marginBottom = presentationModel.separatorThickness;
                UIBase(itemRenderer).style = style;
                UIBase(itemRenderer).height = presentationModel.rowHeight;
                UIBase(itemRenderer).percentWidth = 100;
            }

            setData(itemRenderer, item, index);
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
