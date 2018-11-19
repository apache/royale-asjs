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
package org.apache.royale.mobile.beads
{
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IViewportModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.SimpleCSSStylesWithFlex;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.beads.layouts.HorizontalLayout;
	import org.apache.royale.mobile.IViewManager;
	import org.apache.royale.mobile.IViewManagerView;
	import org.apache.royale.mobile.chrome.NavigationBar;
	import org.apache.royale.mobile.chrome.TabBar;
	import org.apache.royale.mobile.models.ViewManagerModel;
	import org.apache.royale.mobile.beads.TabbedViewManagerView;
	
	/**
	 * The TabbedViewManagerView constructs the visual elements of the TabbedViewManager. The
	 * elements may be a navigation bar, a tab bar, and the contentArea.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class TabbedViewManagerView extends ViewManagerViewBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function TabbedViewManagerView()
		{
			super();
		}
		
		/*
		 * Children
		 */
		
		public function get tabBar():TabBar
		{
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			return model.tabBar;
		}
		public function set tabBar(value:TabBar):void
		{
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			model.tabBar = value;
		}
		
		/*
		 * ViewBead
		 */
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			var model:ViewManagerModel = value.getBeadByType(IBeadModel) as ViewManagerModel;
			
			// TabbedViewManager always has a TabBar
			var tbar:TabBar = new TabBar();
			tbar.dataProvider = model.views;
			tbar.labelField = "title";
			tbar.addEventListener("change",handleButtonBarChange);
			tabBar = tbar;
		}
		
		override protected function addViewElements():void
		{			
			super.addViewElements();
			
			if (tabBar) {
				getHost().addElement(tabBar);
			}
			
			showViewByIndex(0);
		}
		
		private var _currentView:IViewManagerView;
		
		/**
		 * @royaleignorecoercion org.apache.royale.core.UIBase
		 * @royaleignorecoercion org.apache.royale.mobile.IViewManagerView
		 * @royaleignorecoercion org.apache.royale.mobile.IViewManager
		 */
		protected function showViewByIndex(index:int):void
		{
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			
			if (_currentView != null) {
				getHost().removeElement(_currentView);
			}
			_currentView = model.views[index] as IViewManagerView;
			_currentView.viewManager = _strand as IViewManager;
			insertCurrentView(_currentView);
			
			COMPILE::JS {
				if (_currentView) {
					(_currentView as UIBase).element.style["flex-grow"] = "1";
				}
			}
			COMPILE::SWF {
				if (UIBase(_currentView).style == null) {
					UIBase(_currentView).style = new SimpleCSSStylesWithFlex();
				}
				UIBase(_currentView).style.flexGrow = 1;
				UIBase(_currentView).percentWidth = 100;
			}
			
			// Now that the view has changed, refresh the layout on this component.
			getHost().dispatchEvent(new Event("layoutNeeded"));
			getHost().dispatchEvent(new Event("viewChanged"));
		}
		protected function insertCurrentView(view:IViewManagerView):void{
			getHost().addElementAt(view,(navigationBar ? 1 : 0));
		}
		/**
		 * @private
		 */		
		private function handleButtonBarChange(event:Event):void
		{
			var newIndex:Number = tabBar.selectedIndex;
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			
			// doing this will trigger the selectedIndexChanged event which will
			// tell the strand to switch views
			model.selectedIndex = newIndex;
			
			showViewByIndex(newIndex);
		}
	}
}
