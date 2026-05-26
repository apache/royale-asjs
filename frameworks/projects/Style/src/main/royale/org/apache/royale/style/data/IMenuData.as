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
package org.apache.royale.style.data
{
	/**
	 * Describes the data contract for menu items used by Style menu controls.
	 *
	 * @langversion 3.0
	 * @productversion Royale 1.0.0
	 */
	public interface IMenuData extends IListData
	{
		/**
		 * True when this item should render as a visual divider instead of a selectable item.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		function get isDivider():Boolean;
		function set isDivider(value:Boolean):void

		/**
		 * True when this menu item is currently expanded.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		function get isOpen():Boolean;
		function set isOpen(value:Boolean):void

		/**
		 * True when this item is a non-selectable heading label.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		function get isHeading():Boolean;
		function set isHeading(value:Boolean):void

		/**
		 * Child menu items for nested submenus.
		 *
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		function get subMenu():Array
		function set subMenu(value:Array):void
	}
}