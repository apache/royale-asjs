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
package org.apache.flex.mdl.beads.views
{
    import org.apache.flex.core.IContentViewHost;
    import org.apache.flex.core.IDataProviderItemRendererMapper;
    import org.apache.flex.core.IParent;
    import org.apache.flex.core.IStrandWithModel;
    import org.apache.flex.events.Event;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.mdl.TabBar;
    import org.apache.flex.mdl.TabBarPanel;
    import org.apache.flex.mdl.beads.TabsItemRendererFactoryForArrayListData;
    import org.apache.flex.mdl.supportClasses.ITabItemRenderer;

    /**
     *  The TabsView class creates the visual elements of the org.apache.flex.mdl.Tabs
     *  component.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public class TabsView extends ListView
    {
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
        public function TabsView()
        {
            super();
        }

        private var _tabBar:TabBar;
        /**
         *  The org.apache.flex.mdl.TabBar component of the
         *  org.apache.flex.mdl.Tabs.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get tabBar():TabBar
        {
            return _tabBar;
        }

        public function set tabBar(value:TabBar):void
        {
            _tabBar = value;
        }

        /**
         * @copy org.apache.flex.core.BeadViewBase#strand
         *
         * @param value
		 *
		 * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.8
         */
        override public function set strand(value:IStrand):void
        {
            super.strand = value;

            if (!_tabBar)
            {
                _tabBar = new TabBar();
                _tabBar.id = "tabsTabBar";
            }

            _tabBar.model = (value as IStrandWithModel).model;

            if (isTabsDynamic())
            {
                _tabBar.addEventListener("itemsCreated", tabBarItemsCreatedHandler);
                _tabBar.addBead(new TabsItemRendererFactoryForArrayListData());
            }
        }

        override protected function itemsCreatedHandler(event:Event):void
        {
            super.itemsCreatedHandler(event);

            completeSetup();
        }

        private function tabBarItemsCreatedHandler(event:Event):void
        {
            forceUpgradeTabs();
        }

        /**
		 *  complete setup
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
        protected function completeSetup():void
        {
            var tb:TabBar = (host as IContentViewHost).strandChildren.getElementAt(0) as TabBar;
            if (!tb)
            {
                (host as IContentViewHost).strandChildren.addElementAt(tabBar, 0);
            }

            selectTabBarPanel();
        }

        /**
		 *  select tabbar panel
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
        private function selectTabBarPanel():void
        {
            var strandChildren:IParent = (host as IContentViewHost).strandChildren;
            var indexElementAfterTabBar:int = listModel.selectedIndex + 1;
            if (strandChildren.numElements <= 0) return;
            if (strandChildren.numElements < indexElementAfterTabBar) return;
            if (listModel.selectedIndex < 0) return;

            var tabBarPanel:Object = strandChildren.getElementAt(indexElementAfterTabBar);
            if (tabBarPanel is ITabItemRenderer || tabBarPanel is TabBarPanel)
            {
                tabBarPanel.isActive = true;
            }
        }

        private function forceUpgradeTabs():void
        {
            if (!isTabsDynamic()) return;
            
            COMPILE::JS
            {
                var componentHandler:Object = window["componentHandler"];

                if (componentHandler)
                {
                    host.element.removeAttribute("data-upgraded");
                    host.element.classList.remove("is-upgraded");
                    componentHandler.upgradeElement(host.element);
                }
            }
        }

        public function isTabsDynamic():Boolean
        {
            var arrayListMapper:TabsItemRendererFactoryForArrayListData =
                    _strand.getBeadByType(IDataProviderItemRendererMapper) as TabsItemRendererFactoryForArrayListData;
            return arrayListMapper != null;
        }
    }
}
