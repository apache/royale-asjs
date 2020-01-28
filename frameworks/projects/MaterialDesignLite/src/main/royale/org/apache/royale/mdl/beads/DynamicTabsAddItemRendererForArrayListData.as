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
    import org.apache.royale.core.ISelectionModel;
    import org.apache.royale.events.CollectionEvent;
    import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.html.beads.DynamicAddItemRendererForArrayListData;
    import org.apache.royale.mdl.beads.models.ITabModel;
    import org.apache.royale.mdl.supportClasses.ITabItemRenderer;

    /**
     *  @copy org.apache.royale.html.beads.DynamicAddItemRendererForArrayListData
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class DynamicTabsAddItemRendererForArrayListData extends DynamicAddItemRendererForArrayListData
	{
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

        override protected function handleItemAdded(event:CollectionEvent):void
        {
            var dp:IArrayList = dataProviderModel.dataProvider as IArrayList;
            if (!dp)
                return;

            if (dataProviderModel is ISelectionModel) {
                var model:ISelectionModel = dataProviderModel as ISelectionModel;
                model.selectedIndex = -1;
            }

            var presentationModel:IListPresentationModel = _strand.getBeadByType(IListPresentationModel) as IListPresentationModel;
            var ir:ITabItemRenderer = itemRendererFactory.createItemRenderer(itemRendererOwnerView) as ITabItemRenderer;
            ir.tabIdField = tabsIdField;

            fillRenderer(event.index, event.item, ir, presentationModel);

            (_strand as IEventDispatcher).dispatchEvent(new Event("layoutNeeded"));
        }
	}
}
