////////////////////////////////////////////////////////////////////////////////
//
// Licensed to the Apache Software Foundation (ASF) under one or more
// contributor license agreements.  See the NOTICE file distributed with
// this work for additional information regarding copyright ownership.
// The ASF licenses this file to You under the Apache License, Version 2.0
// (the "License"); you may not use this file except in compliance with
// the License.  You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.style.data
{
	/**
	 * Data model for menu/list items used by style-based menu components.
	 *
	 * @langversion 3.0
	 * @productversion Royale 1.0.0
	 */
	public class MenuData extends ListData implements IMenuData
	{
		/**
		 * Creates a menu data item with optional display text.
		 */
		public function MenuData(text:String = null)
		{
			super(text);
		}

		private var _isDivider:Boolean;

		/**
		 * True when this item should render as a divider rather than a selectable item.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get isDivider():Boolean
		{
			return _isDivider;
		}
		public function set isDivider(value:Boolean):void
		{
			_isDivider = value;
		}

		private var _isOpen:Boolean = false;

		/**
		 * True when this menu item is currently expanded.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get isOpen():Boolean
		{
			return _isOpen;
		}
		public function set isOpen(value:Boolean):void
		{
			_isOpen = value;
		}

		private var _isHeading:Boolean;

		/**
		 * True when this item is a non-selectable heading label.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get isHeading():Boolean
		{
			return _isHeading;
		}
		public function set isHeading(value:Boolean):void
		{
			_isHeading = value;
		}

		private var _subMenu:Array;

		/**
		 * Child menu items for nested submenus.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get subMenu():Array
		{
			return _subMenu;
		}
		public function set subMenu(value:Array):void
		{
			_subMenu = value;
		}
	}
}