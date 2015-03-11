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
	import org.apache.flex.mobile.chrome.ToolBar;
	import org.apache.flex.mobile.models.ViewManagerModel;
	
	/**
	 * Event dispatched when the currently selected view changes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	[Event("viewChanged")]
	
	/**
	 * The StackedViewManager displays a single View at a time from a
	 * collection of Views where views[0] is at the bottom and views[n-1]
	 * is at the top and displayed.
	 * 
	 * The StackedViewManager has an optional navigation bar at the top
	 * and an optional tool bar at the bottom. The views are displayed
	 * within the StackedViewManager's content area.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class StackedViewManager extends ManagerBase implements IViewManager
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function StackedViewManager()
		{
			super();
			
			className = "StackedViewManager";
		}
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
			
			var n:int = ViewManagerModel(model).views.length;
			if (n > 0) {
				var view:IView = ViewManagerModel(model).views[n-1] as IView;
				addElement(view,false);
				_topView = view;
			}
		}
		
		/**
		 * The title to use in the NavigationBar.
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
		 * True if this view manager is displaying a NavigationBar.
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
		 * The contents of the NavigationBar.
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
		 * True if this view manager is displaying a ToolBar.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get hasToolBar():Boolean
		{
			return ViewManagerModel(model).toolBarItems != null;
		}
		
		/**
		 * The contents of the ToolBar.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get toolBarItems():Array
		{
			return ViewManagerModel(model).toolBarItems;
		}
		public function set toolBarItems(value:Array):void
		{
			ViewManagerModel(model).toolBarItems = value;
		}
		
		/**
		 * The ToolBar (or null if not present).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get toolBar():ToolBar
		{
			return ViewManagerModel(model).toolBar;
		}
		
		private var _topView:IView;
		
		/**
		 * The top-most (current) view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get selectedView():IView
		{
			return _topView;
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
		 *  Pushes the next view onto the navigation stack.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function push(nextView:IView):void
		{
			nextView.viewManager = this;
			ViewManagerModel(model).pushView(nextView);
			
			removeElement(_topView);
			_topView = nextView;
			addElement(_topView);
			
			dispatchEvent( new Event("viewChanged") );
		}
		/**
		 *  Pops the top-most view from the navigation stack.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function pop():void
		{
			if (ViewManagerModel(model).views.length > 1) {
				var lastView:Object = ViewManagerModel(model).popView();
				removeElement(_topView);
				addElement(lastView);
				_topView = lastView as IView;
				
				dispatchEvent( new Event("viewChanged") );
			}
		}
		
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