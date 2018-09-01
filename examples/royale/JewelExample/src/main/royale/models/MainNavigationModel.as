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
            new NavigationLinkVO("Alert", "alert_panel", MaterialIconType.WEB_ASSET),
            new NavigationLinkVO("Button", "button_panel", MaterialIconType.CROP_7_5),
            new NavigationLinkVO("NumericStepper", "numericstepper_panel", MaterialIconType.UNFOLD_MORE),
            new NavigationLinkVO("Date Components", "datecomponents_panel", MaterialIconType.DATE_RANGE),
            new NavigationLinkVO("DropDownList/ComboBox", "dropdownlist_panel", MaterialIconType.CREDIT_CARD),
            new NavigationLinkVO("CheckBox", "checkbox_panel", MaterialIconType.CHECK_BOX),
            new NavigationLinkVO("Icon", "miscelanea_panel", MaterialIconType.FACE),
            new NavigationLinkVO("Label", "label_panel", MaterialIconType.LABEL),
            new NavigationLinkVO("List", "list_panel", MaterialIconType.LIST_ALT),
            new NavigationLinkVO("RadioButton", "radiobutton_panel", MaterialIconType.RADIO_BUTTON_CHECKED),
            new NavigationLinkVO("Slider", "slider_panel", MaterialIconType.STORAGE),
            new NavigationLinkVO("Text", "text_panel", MaterialIconType.SUBJECT),
            new NavigationLinkVO("TextInput", "textinput_panel", MaterialIconType.TEXT_FIELDS),
            new NavigationLinkVO("Forms & Validation", "form_validation_panel", MaterialIconType.ASSIGNMENT_TURNED_IN)

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
