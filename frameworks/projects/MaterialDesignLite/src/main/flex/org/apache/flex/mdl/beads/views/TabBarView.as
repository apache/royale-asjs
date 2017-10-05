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
    import org.apache.royale.core.IParent;
    import org.apache.royale.events.Event;
    import org.apache.royale.core.IContentViewHost;
    import org.apache.royale.mdl.TabBarButton;
    import org.apache.royale.mdl.supportClasses.ITabItemRenderer;

    /**
     *  The TabBarView class creates the visual elements of the org.apache.royale.mdl.TabBar
     *  component.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public class TabBarView extends ListView
    {
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function TabBarView()
        {
            super();
        }

        override protected function itemsCreatedHandler(event:org.apache.royale.events.Event):void
        {
            super.itemsCreatedHandler(event);

            selectTabBarButton();
        }

        /**
		 *  select tabbar button
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        private function selectTabBarButton():void
        {
            var strandChildren:IParent = (host as IContentViewHost).strandChildren;
            if (strandChildren.numElements <= 0) return;
            if (listModel.selectedIndex < 0) return;

            var tabBarButton:Object = strandChildren.getElementAt(listModel.selectedIndex);
            
            if (tabBarButton is ITabItemRenderer || tabBarButton is TabBarButton)
            {
                tabBarButton.isActive = true;
            }
        }
    }
}
