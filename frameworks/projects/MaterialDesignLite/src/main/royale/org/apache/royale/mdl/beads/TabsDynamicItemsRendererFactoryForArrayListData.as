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
package org.apache.royale.mdl.beads
{
    import org.apache.royale.collections.IArrayList;
    import org.apache.royale.core.IListPresentationModel;
    import org.apache.royale.events.CollectionEvent;

    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.DynamicItemsRendererFactoryForArrayListData;
    import org.apache.royale.mdl.beads.models.ITabModel;
    import org.apache.royale.mdl.supportClasses.ITabItemRenderer;
    import org.apache.royale.events.Event;

    [Event(name="itemRendererCreated",type="org.apache.royale.events.ItemRendererEvent")]

    /**
     *  The TabsDynamicItemsRendererFactoryForArrayListData class reads an
     *  array of data and creates an item renderer for every
     *  ITabItemRenderer in the array.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class TabsDynamicItemsRendererFactoryForArrayListData extends DynamicItemsRendererFactoryForArrayListData
    {
        public function TabsDynamicItemsRendererFactoryForArrayListData(target:Object = null)
        {
            super(target);
        }

        protected var tabsIdField:String;

        /**
         *  finish setup
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        override protected function initComplete(event:Event):void
        {
            var model:ITabModel = _strand.getBeadByType(ITabModel) as ITabModel;
            tabsIdField = model.tabIdField;

            super.initComplete(event);
        }

        override protected function dataProviderChangeHandler(event:Event):void
        {
            var dp:IArrayList = dataProviderModel.dataProvider as IArrayList;
            if (!dp)
                return;

            dataGroup.removeAllItemRenderers();

            var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;

            var n:int = dp.length;
            for (var i:int = 0; i < n; i++)
            {
                var ir:ITabItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as ITabItemRenderer;
                ir.tabIdField = tabsIdField;

                var item:Object = dp.getItemAt(i);
                fillRenderer(i, item, ir, presentationModel);
            }

            IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
        }

        override protected function itemAddedHandler(event:CollectionEvent):void
        {
            var dp:IArrayList = dataProviderModel.dataProvider as IArrayList;
            if (!dp)
                return;

            var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;

            var ir:ITabItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as ITabItemRenderer;
            ir.tabIdField = tabsIdField;

            var index:int = dp.length - 1;
            fillRenderer(index, event.item, ir, presentationModel);

            IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
        }
    }
}
