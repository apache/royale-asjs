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
package org.apache.royale.mobile
{	
	import org.apache.royale.core.IChild;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.Container;
	import org.apache.royale.mobile.IViewManager;
	import org.apache.royale.mobile.IViewManagerView;
	import org.apache.royale.mobile.chrome.NavigationBar;
	import org.apache.royale.mobile.chrome.ToolBar;
	import org.apache.royale.mobile.models.ViewManagerModel;
	import org.apache.royale.mobile.beads.StackedViewManagerView;
	
	[Event(name="viewChanged",type="org.apache.royale.events.Event")]
	
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
	 *  @productversion Royale 0.0
	 */
	public class StackedViewManager extends ViewManagerBase implements IViewManager
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function StackedViewManager()
		{
			super();
			
			typeNames = "StackedViewManager";
		}
		
		/**
		 * True if this view manager is displaying a ToolBar.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
		 */
		public function get toolBar():ToolBar
		{
			return ViewManagerModel(model).toolBar;
		}

		
		private var _topView:IViewManagerView;
		
		override public function set views(value:Array):void
		{
			super.views = value;
			
			if (value != null && value.length > 0) {
				_topView = value[0] as IViewManagerView;
			}
		}

		/**
		 * The top-most (current) view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		override public function get selectedView():IViewManagerView
		{
			return _topView;
		}
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
		}

		
		/**
		 *  Pushes the next view onto the navigation stack.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function push(nextView:IViewManagerView):void
		{
			nextView.viewManager = this;
			ViewManagerModel(model).pushView(nextView);
		}
		
		/**
		 *  Pops the top-most view from the navigation stack.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function pop():IChild
		{
			var stackedView:StackedViewManagerView = getBeadByType(StackedViewManagerView) as StackedViewManagerView;
			return ViewManagerModel(model).popView();
		}

	}
}
