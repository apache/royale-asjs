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
package org.apache.royale.html.beads.models
{
	import org.apache.royale.html.beads.models.ArraySelectionModel;
	import org.apache.royale.core.IStrand;

	/**
	 * The model used to support menus.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class MenuModel extends ArraySelectionModel
	{
		/**
		 * Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function MenuModel()
		{
			super();
		}
		
		/**
		 * @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			MenuModel.menuList.push(_strand);
		}
		
		private static var _menuList:Array = [];
		
		/**
		 * The array of active IMenu instances. This list is maintained so that any of the
		 * instances can close all of them. Imagine several cascading menus open the user
		 * selects one of the items. That menu uses this array to close itself and the others.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public static function get menuList():Array
		{
			return _menuList;
		}
		
		/**
		 * Empties the menuList.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public static function clearMenuList():void
		{
			_menuList = [];
		}
		
		/**
		 * Removes a specific menu from the menuList.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public static function removeMenu(menu:Object):void
		{
			for(var i:int=0; i < menuList.length; i++) {
				if (menuList[i] == menu) {
					menuList.splice(i,1);
					break;
				}
			}
		}
	}
}