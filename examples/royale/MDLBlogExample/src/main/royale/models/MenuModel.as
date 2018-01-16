/**
 * @license
 * Copyright 2015 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package models
{
    import org.apache.royale.events.EventDispatcher;
    import org.apache.royale.events.IEventDispatcher;

    import vos.MenuItemVO;

    public class MenuModel extends EventDispatcher
    {
    	/* Strings are from https://github.com/google/material-design-lite/blob/88872e672e41c56af0a78a35b34373b8c4a8c49d/src/menu/snippets/top-left.html
    	   which is available under CC-BY-4.0 */
    	public static const MENU_ITEM_SOME_ACTION:String = "Some Action";
    	public static const MENU_ITEM_ANOTHER_ACTION:String = "Another Action";
    	public static const MENU_ITEM_MORE_ACTION:String = "More Action";
    	public static const MENU_ITEM_DISABLED:String = "Item Disabled";
    	
        private var _menuItems:Array = [
            new MenuItemVO(MENU_ITEM_SOME_ACTION),
            new MenuItemVO(MENU_ITEM_ANOTHER_ACTION, true),
            new MenuItemVO(MENU_ITEM_MORE_ACTION),
            new MenuItemVO(MENU_ITEM_DISABLED, false, true)
        ];

        public function get menuItems():Array
        {
            return _menuItems;
        }
    }
}
