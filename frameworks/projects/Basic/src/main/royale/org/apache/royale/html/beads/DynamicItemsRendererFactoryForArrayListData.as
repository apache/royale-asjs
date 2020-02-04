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
    import org.apache.royale.core.IBead;
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
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.CollectionEvent;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.IListView;
    import org.apache.royale.utils.loadBeadFromValuesManager;
    import org.apache.royale.core.DispatcherBead;
    import org.apache.royale.utils.sendStrandEvent;

    [Event(name="itemRendererCreated",type="org.apache.royale.events.ItemRendererEvent")]

    /**
     *  The DynamicItemsRendererFactoryForArrayListData class reads an
     *  array of data and creates an item renderer for every
     *  IIndexedItemRenderer in the array.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
    public class DynamicItemsRendererFactoryForArrayListData extends DispatcherBead implements IDataProviderItemRendererMapper
    {
        public function DynamicItemsRendererFactoryForArrayListData(target:Object = null)
        {
            super(target);
        }

        protected var labelField:String;


        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
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
         * @royaleignorecoercion org.apache.royale.core.ISelectionModel
         * @royaleignorecoercion org.apache.royale.html.beads.IListView
         */
        protected function initComplete(event:Event):void
        {
            IEventDispatcher(_strand).removeEventListener("initComplete", initComplete);

			_dataProviderModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
            var listView:IListView = _strand.getBeadByType(IListView) as IListView;
            dataGroup = listView.dataGroup;
            dataProviderModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
			labelField = dataProviderModel.labelField;
			
			dataProviderChangeHandler(null);
        }
		
		protected var _dataProviderModel:ISelectionModel;
		
		/**
		 * The model holding the dataProvider.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
		 */
		public function get dataProviderModel():IDataProviderModel
		{
			return _dataProviderModel;
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
         * @royaleignorecoercion org.apache.royale.core.IItemRendererClassFactory
         */
        public function get itemRendererFactory():IItemRendererClassFactory
        {
			if(!_itemRendererFactory)
    			_itemRendererFactory = loadBeadFromValuesManager(IItemRendererClassFactory, "iItemRendererClassFactory", _strand) as IItemRendererClassFactory;

            return _itemRendererFactory;
        }

        /**
         *  @private
         */
        public function set itemRendererFactory(value:IItemRendererClassFactory):void
        {
            _itemRendererFactory = value;
        }

        /**
         *  The org.apache.royale.core.IItemRendererOwnerView that will
         *  parent the item renderers.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        protected var dataGroup:IItemRendererOwnerView;

		/**
		 * @private
         * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 */
        protected function dataProviderChangeHandler(event:Event):void
        {
            var dp:IArrayList = dataProviderModel.dataProvider as IArrayList;
            if (!dp)
                return;

			// listen for individual items being added in the future.
			(dp as IEventDispatcher).addEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);
			
            dataGroup.removeAllItemRenderers();

            var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;

            var n:int = dp.length;
            for (var i:int = 0; i < n; i++)
            {
                var ir:IIndexedItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as IIndexedItemRenderer;
                var item:Object = dp.getItemAt(i);
                fillRenderer(i, item, ir, presentationModel);
            }

            sendStrandEvent(_strand,"itemsCreated");
        }

		/**
		 * @private
         * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         * @royaleignorecoercion org.apache.royale.core.IIndexedItemRenderer
		 */
        protected function itemAddedHandler(event:CollectionEvent):void
        {
            var dp:IArrayList = dataProviderModel.dataProvider as IArrayList;
            if (!dp)
                return;

            var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
            var ir:IIndexedItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as IIndexedItemRenderer;

            fillRenderer(event.index, event.item, ir, presentationModel);
			
			// update the index values in the itemRenderers to correspond to their shifted positions.
			var n:int = dataGroup.numItemRenderers;
			for (var i:int = event.index; i < n; i++)
			{
				ir = dataGroup.getItemRendererAt(i) as IIndexedItemRenderer;
				ir.index = i;
			}

			sendStrandEvent(_strand,"itemsCreated");
			sendStrandEvent(_strand,"layoutNeeded");
        }

		/**
		 * @private
         * @royaleignorecoercion org.apache.royale.core.UIBase
		 */
        protected function fillRenderer(index:int,
                                      item:Object,
                                      itemRenderer:IIndexedItemRenderer,
                                      presentationModel:IListPresentationModel):void
        {
			dataGroup.addItemRendererAt(itemRenderer, index);

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
		protected function setData(itemRenderer:IIndexedItemRenderer, data:Object, index:int):void
		{
			itemRenderer.index = index;
			itemRenderer.data = data;
		}
    }
}
