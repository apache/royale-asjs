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
package models
{
    import vos.NavigationLinkVO;
    import org.apache.flex.collections.ArrayList;

    public class MainNavigationModel
    {
        private var _mainNavigation:Array = [
                new NavigationLinkVO("About", "https://getmdl.io/index.html"),
                new NavigationLinkVO("Getting Started", "https://getmdl.io/started/index.html"),
                new NavigationLinkVO("Components", "https://getmdl.io/components/index.html"),
                new NavigationLinkVO("Customize", "https://getmdl.io/customize/index.html")
        ];

        public function get mainNavigation():Array
        {
            return _mainNavigation;
        }

        private var _drawerNavigation:Array = [
                new NavigationLinkVO("About", "https://getmdl.io/index.html"),
                new NavigationLinkVO("Getting Started", "https://getmdl.io/started/index.html"),
                new NavigationLinkVO("Templates", "https://getmdl.io/templates/index.html"),
                new NavigationLinkVO("Components", "https://getmdl.io/components/index.html"),
                new NavigationLinkVO("Styles", "https://getmdl.io/styles/index.html"),
                new NavigationLinkVO("Customize", "https://getmdl.io/customize/index.html"),
                new NavigationLinkVO("Showcase", "https://getmdl.io/showcase/index.html"),
                new NavigationLinkVO("FAQ", "https://getmdl.io/faq/index.html")
        ];

        public function get drawerNavigation():Array
        {
            return _drawerNavigation;
        }

        private var _componentsTabs:ArrayList = new ArrayList([
            new NavigationLinkVO("Cards", "cards_panel"),
            new NavigationLinkVO("Chips", "chips_panel"),
            new NavigationLinkVO("Sliders", "sliders_panel"),
            new NavigationLinkVO("Grids", "grids_panel"),
            new NavigationLinkVO("Footers", "footers_panel"),
            new NavigationLinkVO("Tabs", "tabs_panel"),
            new NavigationLinkVO("Buttons", "buttons_panel"),
            new NavigationLinkVO("TextFields", "textfield_panel"),
            new NavigationLinkVO("Snackbar", "snackbar_panel"),
            new NavigationLinkVO("Dialogs", "dialogs_panel"),
            new NavigationLinkVO("Toggles", "toggles_panel"),
            new NavigationLinkVO("Lists", "lists_panel"),
            new NavigationLinkVO("Tables", "tables_panel"),
            new NavigationLinkVO("Loading", "loading_panel"),
            new NavigationLinkVO("Menu", "menus_panel"),
            new NavigationLinkVO("Badges", "badges_panel"),
            new NavigationLinkVO("Icons", "icons_panel")
        ]);

        public function get componentsTabs():ArrayList
        {
            return _componentsTabs;
        }
    }
}
