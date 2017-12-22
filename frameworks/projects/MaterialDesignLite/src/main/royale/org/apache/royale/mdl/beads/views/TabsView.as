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
package org.apache.royale.mdl.beads.views
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IContentViewHost;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IStrandWithModel;
    import org.apache.royale.events.Event;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.mdl.TabBar;
    import org.apache.royale.mdl.TabBarPanel;
    import org.apache.royale.mdl.beads.DynamicTabsAddItemRendererForArrayListData;
    import org.apache.royale.mdl.beads.DynamicTabsAddItemRendererForArrayListData;
    import org.apache.royale.mdl.supportClasses.ITabItemRenderer;

    /**
     *  The TabsView class creates the visual elements of the org.apache.royale.mdl.Tabs
     *  component.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class TabsView extends ListView
    {
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function TabsView()
        {
            super();
        }

        private var _tabBar:TabBar;
        /**
         *  The org.apache.royale.mdl.TabBar component of the
         *  org.apache.royale.mdl.Tabs.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
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
         * @copy org.apache.royale.core.BeadViewBase#strand
         *
         * @param value
		 *
		 * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.8
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

            var dynamicTabsAddBead:DynamicTabsAddItemRendererForArrayListData = _strand.getBeadByType(DynamicTabsAddItemRendererForArrayListData) as DynamicTabsAddItemRendererForArrayListData;
            if (dynamicTabsAddBead)
            {
                
                _tabBar.addBead(new DynamicTabsAddItemRendererForArrayListData() as IBead);
                _tabBar.addEventListener("layoutNeeded", tabBarLayoutNeededHandler);
            }
        }

        override protected function itemsCreatedHandler(event:Event):void
        {
            super.itemsCreatedHandler(event);

            completeTabBarSetup();
        }

        private function tabBarLayoutNeededHandler(event:Event):void
        {
            forceUpgradeTabs();
        }

        protected function completeTabBarSetup():void
        {
			var tb:TabBar = (host as IContentViewHost).getElementAt(0) as TabBar;
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
		 *  @productversion Royale 0.8
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
            var dynamicTabsAddBead:DynamicTabsAddItemRendererForArrayListData = _strand.getBeadByType(DynamicTabsAddItemRendererForArrayListData) as DynamicTabsAddItemRendererForArrayListData;
            if (!dynamicTabsAddBead) return;
            
            COMPILE::JS
            {
                var componentHandler:Object = window["componentHandler"];

                if (componentHandler)
                {
                    host.element.removeAttribute("data-upgraded");
                    host.element.classList.remove("is-upgraded");
                    componentHandler["upgradeElement"](host.element);
                }
            }
        }
    }
}
