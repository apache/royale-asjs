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
            new NavigationLinkVO("Alert", "alert_panel", "web_asset"),
            new NavigationLinkVO("Button", "button_panel", "crop_7_5"),
            new NavigationLinkVO("DropDownList", "dropdownlist_panel", "credit_card"),
            new NavigationLinkVO("CheckBox", "checkbox_panel", "check_box"),
            new NavigationLinkVO("Label", "label_panel", "label"),
            new NavigationLinkVO("List", "list_panel", "list_alt"),
            new NavigationLinkVO("RadioButton", "radiobutton_panel", "radio_button_checked"),
            new NavigationLinkVO("Slider", "slider_panel", "storage"),
            new NavigationLinkVO("Text", "text_panel", "subject"),
            new NavigationLinkVO("TextInput", "textinput_panel", "text_fields")

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
            new NavigationLinkVO("Card", "card_panel", "web_asset"),
            new NavigationLinkVO("Grid", "grid_panel", "grid_on"),
            new NavigationLinkVO("Tables", "tables_panel", "view_quilt")
            
            // new NavigationLinkVO("Tabs", "tabs_panel"),
            // new NavigationLinkVO("Snackbar", "snackbar_panel"),
            
        ]);

        public function get containerDrawerNavigation():ArrayList
        {
            return _containerDrawerNavigation;
        }
    }
}
