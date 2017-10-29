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
    import org.apache.royale.core.IItemRendererClassFactory;
    import org.apache.royale.core.IItemRendererParent;
    import org.apache.royale.core.IListPresentationModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.SimpleCSSStyles;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.CollectionEvent;

    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.IListView;
    import org.apache.royale.events.Event;
    import org.apache.royale.core.ISelectableItemRenderer;
    import org.apache.royale.core.ISelectionModel;
	import org.apache.royale.utils.loadBeadFromValuesManager;

    [Event(name="itemRendererCreated",type="org.apache.royale.events.ItemRendererEvent")]

    /**
     *  The DynamicItemsRendererFactoryForArrayListData class reads an
     *  array of data and creates an item renderer for every
     *  ISelectableItemRenderer in the array.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9
     */
    public class DynamicItemsRendererFactoryForArrayListData extends EventDispatcher implements IBead, IDataProviderItemRendererMapper
    {
        public function DynamicItemsRendererFactoryForArrayListData(target:Object = null)
        {
            super(target);
        }

        protected var dataProviderModel:ISelectionModel;

        protected var labelField:String;

        protected var _strand:IStrand;

        /**
         *  @copy org.apache.royale.core.IBead#strand
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
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

            dataProviderModel = _strand.getBeadByType(ISelectionModel) as ISelectionModel;
            var listView:IListView = _strand.getBeadByType(IListView) as IListView;
            dataGroup = listView.dataGroup;
            dataProviderModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);
            dataProviderModel.addEventListener(CollectionEvent.ITEM_ADDED, itemAddedHandler);

            labelField = dataProviderModel.labelField;

            dataProviderChangeHandler(null);
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
         *  @private
         */
        public function set itemRendererFactory(value:IItemRendererClassFactory):void
        {
            _itemRendererFactory = value;
        }

        /**
         *  The org.apache.royale.core.IItemRendererParent that will
         *  parent the item renderers.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        protected var dataGroup:IItemRendererParent;

        protected function dataProviderChangeHandler(event:Event):void
        {
            var dp:IArrayList = dataProviderModel.dataProvider as IArrayList;
            if (!dp)
                return;

            dataGroup.removeAllItemRenderers();

            var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;

            var n:int = dp.length;
            for (var i:int = 0; i < n; i++)
            {
                var ir:ISelectableItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as ISelectableItemRenderer;
                var item:Object = dp.getItemAt(i);
                fillRenderer(i, item, ir, presentationModel);
            }

            IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
        }

        protected function itemAddedHandler(event:CollectionEvent):void
        {
            var dp:IArrayList = dataProviderModel.dataProvider as IArrayList;
            if (!dp)
                return;

            var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
            var ir:ISelectableItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as ISelectableItemRenderer;

            fillRenderer(dp.length - 1, event.item, ir, presentationModel);

            IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
        }

        protected function fillRenderer(index:int,
                                      item:Object,
                                      itemRenderer:ISelectableItemRenderer,
                                      presentationModel:IListPresentationModel):void
        {
            dataGroup.addItemRenderer(itemRenderer);

            itemRenderer.index = index;
            itemRenderer.labelField = labelField;

            if (presentationModel) {
                var style:SimpleCSSStyles = new SimpleCSSStyles();
                style.marginBottom = presentationModel.separatorThickness;
                UIBase(itemRenderer).style = style;
                UIBase(itemRenderer).height = presentationModel.rowHeight;
                UIBase(itemRenderer).percentWidth = 100;
            }
            itemRenderer.data = item;
        }
    }
}
