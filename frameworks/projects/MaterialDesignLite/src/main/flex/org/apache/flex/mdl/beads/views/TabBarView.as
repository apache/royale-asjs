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
    import org.apache.flex.events.Event;
    import org.apache.flex.core.IContentViewHost;
    import org.apache.flex.core.IStrand;
    import org.apache.flex.mdl.TabBarButton;
    import org.apache.flex.mdl.supportClasses.ITabItemRenderer;

    /**
     *  The TabBarView class creates the visual elements of the org.apache.flex.mdl.TabBar
     *  component.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public class TabBarView extends ListView
    {
        public function TabBarView()
        {
            super();
        }

        override public function set strand(value:IStrand):void
        {
            super.strand = value;

            host.addEventListener("initComplete", initCompleteHandler);
        }

        private function initCompleteHandler(event:Event):void
        {
            host.removeEventListener("initComplete", initCompleteHandler);

            completeSetup();
        }

        protected function completeSetup():void
        {
            selectTabBarButton();
        }

        private function selectTabBarButton():void
        {
            if (listModel.selectedIndex < 0 ) return;

            var tabBarButton:Object = (host as IContentViewHost).strandChildren.getElementAt(listModel.selectedIndex);
            if (tabBarButton is ITabItemRenderer || tabBarButton is TabBarButton)
            {
                tabBarButton.isActive = true;
            }
        }
    }
}
