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
    import org.apache.royale.collections.ArrayList;

    import vos.NavigationLinkVO;

    public class MainNavigationModel
    {
        private var _controlsDrawerNavigation:ArrayList = new ArrayList([
            new NavigationLinkVO("Label", "label_panel"),
            new NavigationLinkVO("Text", "text_panel"),
            new NavigationLinkVO("Button", "button_panel"),
            new NavigationLinkVO("TextInput", "textinput_panel")//,
            // new NavigationLinkVO("CheckBox", "checkbox_panel"),
            // new NavigationLinkVO("RadioButton", "radiobutton_panel"),
            // new NavigationLinkVO("Slider", "slider_panel"),
            // new NavigationLinkVO("Alert", "alert_panel"),
            // new NavigationLinkVO("List", "list_panel"),
            // new NavigationLinkVO("DropDownList", "dropdownlist_panel")

            // new NavigationLinkVO("Menu", "menus_panel"),
            // new NavigationLinkVO("Loading", "loading_panel"),
            // new NavigationLinkVO("Snackbar", "snackbar_panel"),
            // new NavigationLinkVO("Tables", "tables_panel"),
            
        ]);
        public function get controlsDrawerNavigation():ArrayList
        {
            return _controlsDrawerNavigation;
        }
        
        private var _containerDrawerNavigation:ArrayList = new ArrayList([
            new NavigationLinkVO("Grid", "grid_panel"),
            new NavigationLinkVO("Card", "card_panel")
            
            // new NavigationLinkVO("Tabs", "tabs_panel"),
            // new NavigationLinkVO("Snackbar", "snackbar_panel"),
            // new NavigationLinkVO("Tables", "tables_panel"),
            
        ]);

        public function get containerDrawerNavigation():ArrayList
        {
            return _containerDrawerNavigation;
        }
    }
}
