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
package org.apache.royale.mobile.models
{
	import org.apache.royale.core.IBeadModel;
    import org.apache.royale.core.IChild;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.mobile.chrome.NavigationBar;
	import org.apache.royale.mobile.chrome.TabBar;
	import org.apache.royale.mobile.chrome.ToolBar;
	
	/**
	 * The ViewManagerModel houses properties and values common to the components
	 * which make up view managers. These properties include the title, which view
	 * is currently active and selected.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ViewManagerModel extends EventDispatcher implements IBeadModel
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ViewManagerModel()
		{
			super();
			
			_views = new Array();
		}
		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		//public var contentX:Number = 0;
		//public var contentY:Number = 0;
		//public var contentWidth:Number = 0;
		//public var contentHeight:Number = 0;
		
		private var _views:Array;
		
		/**
		 * The array of views displayed in the contentArea of the ViewManager.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get views():Array
		{
			return _views;
		}
		public function set views(value:Array):void
		{
			if (value != _views) {
				_views = value;
				_selectedIndex = value.length - 1;
				dispatchEvent(new Event("viewsChanged"));
			}
		}
		
		/**
		 * Pushes a view onto the top/end of the stack of views. This view becomes
		 * the active view. Mostly used by the StackedViewManager.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function pushView(value:IChild):void
		{
			_views.push(value);
			_selectedIndex = _views.length - 1;
			dispatchEvent(new Event("viewPushed"));
		}
		
		/**
		 * Removes the most recently added view. The next view in the stack becomes the
		 * active view. Mostly used by StackedViewManager.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function popView():IChild
		{
			if (_views.length > 1) {
				var discard:Object = _views.pop();
				_selectedIndex = _views.length - 1;
				dispatchEvent(new Event("viewPopped"));
			}
			return _views[_views.length-1];
		}
		
		private var _selectedIndex:Number = -1;
		
		/**
		 * The index into the views array of the currently active view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get selectedIndex():Number
		{
			return _selectedIndex;
		}
		public function set selectedIndex(value:Number):void
		{
			if (value != _selectedIndex) {
				_selectedIndex = value;
				dispatchEvent(new Event("selectedIndexChanged"));
			}
		}
		
		private var _title:String;
		
		/**
		 * The title of the view..
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get title():String
		{
			return _title;
		}
		public function set title(value:String):void
		{
			_title = value;
		}
		
		private var _navigationBarItems:Array;
		
		/**
		 * The array of controls that make up the NavigationBar.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get navigationBarItems():Array
		{
			return _navigationBarItems;
		}
		public function set navigationBarItems(value:Array):void
		{
			_navigationBarItems = value;
		}
		
		private var _navigationBar:NavigationBar;
		
		/**
		 * The NavigationBar (or null if not present).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get navigationBar():NavigationBar
		{
			return _navigationBar;
		}
		public function set navigationBar(value:NavigationBar):void
		{
			_navigationBar = value;
		}
		
		private var _toolBarItems:Array;
		
		/**
		 * The array of controls that make up the ToolBar..
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get toolBarItems():Array
		{
			return _toolBarItems;
		}
		public function set toolBarItems(value:Array):void
		{
			_toolBarItems = value;
		}
		
		private var _toolBar:ToolBar;
		
		/**
		 * The ToolBar (or null if not present).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get toolBar():ToolBar
		{
			return _toolBar;
		}
		public function set toolBar(value:ToolBar):void
		{
			_toolBar = value;
		}
		
		private var _tabBar:TabBar;
		
		/**
		 * The TabBar (or null if not present).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get tabBar():TabBar
		{
			return _tabBar;
		}
		public function set tabBar(value:TabBar):void
		{
			_tabBar = value;
		}
	}
}
