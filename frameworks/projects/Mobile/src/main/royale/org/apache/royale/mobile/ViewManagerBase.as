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
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.Group;
	import org.apache.royale.mobile.IViewManagerView;
	import org.apache.royale.mobile.IViewManager;
	import org.apache.royale.mobile.chrome.NavigationBar;
	import org.apache.royale.mobile.models.ViewManagerModel;
	
	/**
	 * Event dispatched when the current (selected) view changes.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="viewChanged",type="org.apache.royale.events.Event")]
	
	/**
	 * Base class for mobile navigation controls.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ViewManagerBase extends Group implements IViewManager
	{
		/**
		 * Constructor.
		 */
		public function ViewManagerBase()
		{
			super();
			
			model.addEventListener("selectedIndexChanged", changeView);

		}
		
		/**
		 * A title that can be used in the NavigationBar.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get title():String
		{
			return ViewManagerModel(model).title;
		}
		public function set title(value:String):void
		{
			ViewManagerModel(model).title = value;
		}
		
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
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
		 *  @productversion Royale 0.0
		 */
		public function get navigationBar():NavigationBar
		{
			return ViewManagerModel(model).navigationBar; 
		}
		
		/**
		 *  The current set of views in the stack. The last entry is
		 *  the top-most (visible) view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
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
		protected function changeView( event:Event ):void
		{
			// handled in subclass
		}
		
		private var _currentView:IViewManagerView;
		public function get currentView():IViewManagerView
		{
			return _currentView;
		}
		public function set currentView(value:IViewManagerView):void
		{
			_currentView = value;
			// probably need to dispatch an event or do something more complex
		}
		
		/**
		 * The currently visible view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get selectedView():IViewManagerView
		{
			return _currentView;
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
		 *  @productversion Royale 0.0
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
