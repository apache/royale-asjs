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
package org.apache.flex.mobile
{	
	import org.apache.flex.events.Event;
	import org.apache.flex.mobile.ManagerBase;
	import org.apache.flex.mobile.chrome.NavigationBar;
	import org.apache.flex.mobile.chrome.TabBar;
	import org.apache.flex.mobile.chrome.ToolBar;
	import org.apache.flex.mobile.models.ViewManagerModel;
	
	/**
	 * Event dispatched when the current (selected) view changes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	[Event(name="viewChanged")]
	
	/**
	 * The TabbedViewManager displays a set of views, only one of which is active at
	 * a time. The other views are reachable via a set of tab buttons at the bottom of
	 * the view manager's space.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class TabbedViewManager extends ManagerBase implements IViewManager
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function TabbedViewManager()
		{
			super();
			
			className = "TabbedViewManager";
			
			model.addEventListener("selectedIndexChanged", changeView);
		}
		
		/**
		 * A title that can be used in the NavigationBar.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get title():String
		{
			return ViewManagerModel(model).title;
		}
		public function set title(value:String):void
		{
			ViewManagerModel(model).title = value;
		}
		
		/**
		 * @private
		 */
		override public function toString():String
		{
			return ViewManagerModel(model).title;
		}
		
		/**
		 * True if this view manager instance is displaying a NavigationBar.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get hasNavigationBar():Boolean
		{
			return ViewManagerModel(model).navigationBarItems != null;
		}
		
		/**
		 * The items that make up the NavigationBar.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get navigationBarItems():Array
		{
			return ViewManagerModel(model).navigationBarItems;
		}
		public function set navigationBarItems(value:Array):void
		{
			ViewManagerModel(model).navigationBarItems = value;
		}
		
		/**
		 * The NavigationBar (or null if not present).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get navigationBar():NavigationBar
		{
			return ViewManagerModel(model).navigationBar; 
		}
		
		/**
		 * The TabBar (or null if not present).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get tabBar():TabBar
		{
			return ViewManagerModel(model).tabBar;
		}
		
		/**
		 * The index (starting at zero) of the currently visible view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get selectedIndex():Number
		{
			return ViewManagerModel(model).selectedIndex;
		}
		public function set selectedIndex(value:Number):void
		{
			ViewManagerModel(model).selectedIndex = value;
		}
		
		private var _currentView:IView;
		
		/**
		 * The currently visible view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get selectedView():IView
		{
			return _currentView;
		}
		
		/**
		 *  The current set of views in the stack. The last entry is
		 *  the top-most (visible) view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get views():Array
		{
			return ViewManagerModel(model).views;
		}
		public function set views(value:Array):void
		{
			ViewManagerModel(model).views = value;
		}
		
		/**
		 * @private
		 */
		private function changeView( event:Event ):void
		{
			var index:Number = ViewManagerModel(model).selectedIndex;
			if (_currentView) {
				removeElement(_currentView);
			}
			_currentView = views[index];
			addElement(_currentView);
			
			dispatchEvent( new Event("viewChanged") );
		}
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
			
			var n:int = ViewManagerModel(model).views.length;
			if (n > 0) {
				for (var i:int = 0; i < n; i++)
				{
					var view:IView = ViewManagerModel(model).views[i] as IView;
					view.viewManager = this;
					if (i == 0) {
						addElement(view,false);
					}
				}
				ViewManagerModel(model).selectedIndex = 0;
			}
		}
		
		/**
		 * IViewManager
		 */
		
		private var _viewManager:IViewManager;
		
		/**
		 * This view manager's parent view manager, if any.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get viewManager():IViewManager
		{
			return _viewManager;
		}
		public function set viewManager(value:IViewManager):void
		{
			_viewManager = value;
		}
	}
}