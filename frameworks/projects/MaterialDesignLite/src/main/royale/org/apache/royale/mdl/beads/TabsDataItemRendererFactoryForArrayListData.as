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
    import org.apache.royale.core.IItemRendererOwnerView;
    import org.apache.royale.core.IListPresentationModel;
    import org.apache.royale.core.IStrandWithModelView;
    import org.apache.royale.core.SimpleCSSStyles;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.html.beads.DataItemRendererFactoryForArrayList;
    import org.apache.royale.html.beads.IListView;
    import org.apache.royale.html.supportClasses.DataItemRenderer;
    import org.apache.royale.mdl.beads.models.ITabModel;
    import org.apache.royale.mdl.supportClasses.ITabItemRenderer;

    /**
     *  The TabsDataItemRendererFactoryForArrayListData class reads an
     *  array of data and creates an item renderer for every
     *  ITabItemRenderer in the array.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class TabsDataItemRendererFactoryForArrayListData extends DataItemRendererFactoryForArrayList
    {
        public function TabsDataItemRendererFactoryForArrayListData(target:Object = null)
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

        /**
         * @royaleignorecoercion org.apache.royale.core.UIBase
         * @royaleignorecoercion org.apache.royale.core.IStrandWithModelView
         * @royaleignorecoercion org.apache.royale.html.beads.IListView
         * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         * @royaleignorecoercion org.apache.royale.html.supportClasses.DataItemRenderer
         * @royaleignorecoercion org.apache.royale.mdl.supportClasses.ITabItemRenderer
         */
        override protected function dataProviderChangeHandler(event:Event):void
        {
            var dp:IArrayList = dataProviderModel.dataProvider as IArrayList;
            if (!dp)
                return;

            var view:IListView = (_strand as IStrandWithModelView).view as IListView;
            var dataGroup:IItemRendererOwnerView = view.dataGroup;

            dataGroup.removeAllItemRenderers();

            var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;

            var n:int = dp.length;
            for (var i:int = 0; i < n; i++)
            {
                var ir:ITabItemRenderer = itemRendererFactory.createItemRenderer(dataGroup) as ITabItemRenderer;
                ir.tabIdField = tabsIdField;
                var dataItemRenderer:DataItemRenderer = ir as DataItemRenderer;

                dataGroup.addItemRenderer(ir, false);

                if (presentationModel) {
                    var style:SimpleCSSStyles = new SimpleCSSStyles();
                    style.marginBottom = presentationModel.separatorThickness;
                    UIBase(ir).style = style;
                    UIBase(ir).height = presentationModel.rowHeight;
                    UIBase(ir).percentWidth = 100;
                }

                ir.labelField = labelField;
                if (dataItemRenderer)
                {
                    dataItemRenderer.dataField = dataField;
                }

                setData(ir, dp.getItemAt(i), i);
            }

            IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
        }
    }
}
