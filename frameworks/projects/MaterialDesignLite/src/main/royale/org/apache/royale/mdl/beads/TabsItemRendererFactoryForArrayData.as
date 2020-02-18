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
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IDataProviderItemRendererMapper;
    import org.apache.royale.core.IItemRendererClassFactory;
    import org.apache.royale.core.IItemRendererOwnerView;
    import org.apache.royale.html.IListPresentationModel;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.SimpleCSSStyles;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.core.ValuesManager;
    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.events.IEventDispatcher;
    import org.apache.royale.events.ItemRendererEvent;
    import org.apache.royale.html.beads.IListView;
    import org.apache.royale.mdl.beads.models.ITabModel;
    import org.apache.royale.events.Event;
    import org.apache.royale.mdl.supportClasses.ITabItemRenderer;
	import org.apache.royale.utils.loadBeadFromValuesManager;

    [Event(name="itemRendererCreated",type="org.apache.royale.events.ItemRendererEvent")]

    /**
     *  The TabsItemRendererFactoryForArrayData class reads an
     *  array of data and creates an item renderer for every
     *  ITabItemRenderer in the array.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class TabsItemRendererFactoryForArrayData extends EventDispatcher implements IBead, IDataProviderItemRendererMapper
    {
        public function TabsItemRendererFactoryForArrayData(target:Object = null)
        {
            super(target);
        }

        protected var dataProviderModel:ITabModel;

        protected var labelField:String;
        protected var tabsIdField:String;

        private var _strand:IStrand;

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
            IEventDispatcher(value).addEventListener("initComplete",finishSetup);
        }

        /**
         *  finish setup
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        private function finishSetup(event:Event):void
        {
            IEventDispatcher(_strand).removeEventListener("initComplete",finishSetup);

            dataProviderModel = _strand.getBeadByType(ITabModel) as ITabModel;
            var listView:IListView = _strand.getBeadByType(IListView) as IListView;
            dataGroup = listView.dataGroup;
            dataProviderModel.addEventListener("dataProviderChanged", dataProviderChangeHandler);

            tabsIdField = dataProviderModel.tabIdField;
            labelField = dataProviderModel.labelField

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
         * @royaleignorecoercion Array
         * @royaleignorecoercion org.apache.royale.core.UIBase
         * @royaleignorecoercion org.apache.royale.core.IListPresentationModel
         * @royaleignorecoercion org.apache.royale.events.IEventDispatcher
         * @royaleignorecoercion org.apache.royale.mdl.supportClasses.ITabItemRenderer
         */
        protected function dataProviderChangeHandler(event:Event):void
        {
            var dp:Array = dataProviderModel.dataProvider as Array;
            if (!(dp is Array))
            {
                return;
            }

            dataGroup.removeAllItemRenderers();

            var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;

            var n:int = dp.length;
            for (var i:int = 0; i < n; i++)
            {
                var ir:ITabItemRenderer = itemRendererFactory.createItemRenderer() as ITabItemRenderer;
                dataGroup.addItemRenderer(ir, false);
                ir.index = i;
                ir.labelField = labelField;
                ir.tabIdField = tabsIdField;
                
                if (presentationModel) {
                    var style:SimpleCSSStyles = new SimpleCSSStyles();
                    style.marginBottom = presentationModel.separatorThickness;
                    UIBase(ir).style = style;
                    UIBase(ir).height = presentationModel.rowHeight;
                    UIBase(ir).percentWidth = 100;
                }
                ir.data = dp[i];
            }

            IEventDispatcher(_strand).dispatchEvent(new Event("itemsCreated"));
        }
    }
}
