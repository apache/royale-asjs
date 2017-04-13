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
package org.apache.flex.mobile.beads
{
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.beads.ContainerView;
	import org.apache.flex.html.beads.layouts.HorizontalLayout;
	import org.apache.flex.mobile.IViewManagerView;
	import org.apache.flex.mobile.ManagedContentArea;
	import org.apache.flex.mobile.chrome.NavigationBar;
	import org.apache.flex.mobile.chrome.TabBar;
	import org.apache.flex.mobile.models.ViewManagerModel;
	import org.apache.flex.mobile.beads.TabbedViewManagerView;
	
	/**
	 * The TabbedViewManagerView constructs the visual elements of the TabbedViewManager. The
	 * elements may be a navigation bar, a tab bar, and the contentArea.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class TabbedViewManagerView extends ViewManagerViewBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function TabbedViewManagerView()
		{
			super();
		}
		
		private var _strand:IStrand;
		private var _contentArea:ManagedContentArea;
		
		public function get tabBar():TabBar
		{
			var model:ViewManagerModel = strand.getBeadByType(IBeadModel) as ViewManagerModel;
			return model.tabBar;
		}
		public function set tabBar(value:TabBar):void
		{
			var model:ViewManagerModel = strand.getBeadByType(IBeadModel) as ViewManagerModel;
			model.tabBar = value;
		}
		
		public function get contentArea():ManagedContentArea
		{
			return _contentArea;
		}
		
		override public function get strand():IStrand
		{
			return _strand;
		}
		override public function set strand(value:IStrand):void
		{
			_strand = value;
			super.strand = value;
			
			// The content area will hold the views
			_contentArea = new ManagedContentArea();
			
			var model:ViewManagerModel = value.getBeadByType(IBeadModel) as ViewManagerModel;
			
			// TabbedViewManager always has a TabBar
			var tbar:TabBar = new TabBar();
			tbar.dataProvider = model.views;
			tbar.labelField = "title";
			tbar.addEventListener("change",handleButtonBarChange);
			tabBar = tbar;
		}
		
		override protected function handleInitComplete(event:Event):void
		{			
			super.handleInitComplete(event);
			
			COMPILE::SWF {
				_contentArea.percentWidth = 100;
				_contentArea.percentHeight = 100;
			}
			UIBase(_strand).addElement(_contentArea);
			
			if (tabBar) {
				UIBase(_strand).addElement(tabBar);
			}
			
			performLayout(event);
			
			showViewByIndex(0);
		}
		
		private var _currentView:IViewManagerView;
		
		protected function showViewByIndex(index:int):void
		{
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			
			if (_currentView != null) {
				contentArea.removeElement(_currentView);
			}
			_currentView = model.views[index] as IViewManagerView;
			contentArea.addElement(_currentView);
			
			COMPILE::JS {
				if (_currentView) {
					UIBase(_currentView).element.style["flex-grow"] = "1";
				}
			}
		}
		
		override protected function layoutViewAfterContentLayout():void
		{
			super.layoutViewAfterContentLayout();
			
			COMPILE::SWF {
				if (_currentView) {
					UIBase(_currentView).width = contentArea.width;
					UIBase(_currentView).height = contentArea.height;
				}
			}
		}
		
		/**
		 * @private
		 */		
		private function handleButtonBarChange(event:Event):void
		{
			var newIndex:Number = tabBar.selectedIndex;
			var model:ViewManagerModel = strand.getBeadByType(IBeadModel) as ViewManagerModel;
			
			// doing this will trigger the selectedIndexChanged event which will
			// tell the strand to switch views
			model.selectedIndex = newIndex;
			
			showViewByIndex(newIndex);
		}
		
		/**
		 * @private
		 */
//		override protected function layoutChromeElements():void
//		{
//			var host:UIBase = _strand as UIBase;
//			var contentAreaY:Number = 0;
//			var contentAreaHeight:Number = host.height;
//			
//			var model:ViewManagerModel = strand.getBeadByType(IBeadModel) as ViewManagerModel;
//			
//			if (navigationBar)
//			{
//				navigationBar.x = 0;
//				navigationBar.y = 0;
//				navigationBar.width = host.width;
//				
//				contentAreaHeight -= navigationBar.height;
//				contentAreaY = navigationBar.height;
//				
//				model.navigationBar = navigationBar;
//			}
//			
//			if (_tabBar)
//			{
//				_tabBar.x = 0;
//				_tabBar.y = host.height - _tabBar.height;
//				_tabBar.width = host.width;
//				_tabBar.dispatchEvent(new Event("layoutNeeded"));
//				
//				contentAreaHeight -= _tabBar.height;
//				
//				model.tabBar = _tabBar;
//			}
//			
//			model.contentX = 0;
//			model.contentY = contentAreaY;
//			model.contentWidth = host.width;
//			model.contentHeight = contentAreaHeight;
//			
//			sizeViewsToFitContentArea();
//			
//			// notify the views that the content size has changed
//			IEventDispatcher(strand).dispatchEvent( new Event("contentSizeChanged") );
//		}
	}
}
