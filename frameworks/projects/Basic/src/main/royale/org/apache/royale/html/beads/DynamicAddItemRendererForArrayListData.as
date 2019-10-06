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
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IDataProviderModel;
	import org.apache.royale.core.IItemRendererClassFactory;
	import org.apache.royale.core.IItemRendererParent;
	import org.apache.royale.core.IItemRendererProvider;
	import org.apache.royale.core.IListPresentationModel;
	import org.apache.royale.core.ISelectableItemRenderer;
	import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IStrandWithModelView;
	import org.apache.royale.core.SimpleCSSStyles;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.CollectionEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.IListView;
	import org.apache.royale.utils.loadBeadFromValuesManager;

    /**
	 * Handles the adding of an itemRenderer once the corresponding datum has been added
	 * from the IDataProviderModel.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.0
	 */
	public class DynamicAddItemRendererForArrayListData implements IBead
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

		protected var _strand:IStrand;

        protected var labelField:String;

		/**
		 * @copy org.apache.royale.core.IStrand
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
			IEventDispatcher(value).addEventListener("initComplete", initComplete);
		}
		
		/**
		 *  finish setup
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		protected function initComplete(event:Event):void
		{
			IEventDispatcher(_strand).removeEventListener("initComplete", initComplete);
			
			_dataProviderModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
			labelField = _dataProviderModel.labelField;

			dataProviderModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);	

			// invoke now in case "dataProviderChanged" has already been dispatched.
			dataProviderChangeHandler(null);
		}
		
		/**
		 * @private
		 */
		protected function dataProviderChangeHandler(event:Event):void
		{
			var dp:IEventDispatcher = dataProviderModel.dataProvider as IEventDispatcher;
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
		 */
		protected function handleItemAdded(event:CollectionEvent):void
		{
            var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
            var ir:ISelectableItemRenderer = itemRendererFactory.createItemRenderer(itemRendererParent) as ISelectableItemRenderer;

            fillRenderer(event.index, event.item, ir, presentationModel);
			
			// update the index values in the itemRenderers to correspond to their shifted positions.
			var dataGroup:UIBase = itemRendererParent as UIBase;
			var n:int = dataGroup.numElements;
			for (var i:int = event.index; i < n; i++)
			{
				ir = dataGroup.getElementAt(i) as ISelectableItemRenderer;
				ir.index = i;
			}

			(_strand as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));
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
		 */
		public function get dataProviderModel(): IDataProviderModel
		{
			if (_dataProviderModel == null && _strand != null) {
				_dataProviderModel = _strand.getBeadByType(IDataProviderModel) as IDataProviderModel;
			}
			return _dataProviderModel;
		}

		private var _itemRendererParent: IItemRendererParent;

		/**
		 *  The org.apache.royale.core.IItemRendererParent used
		 *  to generate instances of item renderers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.0
         *  @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
         *  @royaleignorecoercion org.apache.royale.html.beads.IListView
		 */
		public function get itemRendererParent():IItemRendererParent
		{
			if (_itemRendererParent == null) {
				var view:IListView = (_strand as IStrandWithModelView).view as IListView;
				_itemRendererParent = view.dataGroup;
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
         *  @productversion Royale 0.8
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
