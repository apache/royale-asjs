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
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.beads.layouts.HorizontalLayout;
	import org.apache.flex.mobile.ManagerBase;
	import org.apache.flex.mobile.chrome.NavigationBar;
	import org.apache.flex.mobile.chrome.TabBar;
	import org.apache.flex.mobile.models.ViewManagerModel;
	
	/**
	 * The TabbedViewManagerView constructs the visual elements of the TabbedViewManager. The
	 * elements may be a navigation bar, a tab bar, and the contentArea.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class TabbedViewManagerView implements IBeadView
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
			layoutReady = false;
		}
		
		private var _navigationBar:NavigationBar;
		private var _tabBar:TabBar;
		
		private var layoutReady:Boolean;
		
		private var _strand:ManagerBase;
		
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value as ManagerBase;
			_strand.addEventListener("widthChanged", changeHandler);
			_strand.addEventListener("heightChanged", changeHandler);
			
			var model:ViewManagerModel = value.getBeadByType(IBeadModel) as ViewManagerModel;
			model.addEventListener("viewsChanged", changeHandler);
			
			if (model.navigationBarItems)
			{
				_navigationBar = new NavigationBar();
				_navigationBar.controls = model.navigationBarItems;
				_navigationBar.addBead(new HorizontalLayout());
				_strand.addElement(_navigationBar);
			}
			
			// TabbedViewManager always has a TabBar
			_tabBar = new TabBar();
			_tabBar.dataProvider = model.views;
			_tabBar.labelField = "title";
			_strand.addElement(_tabBar);
			_tabBar.addEventListener("change",handleButtonBarChange);
			
			layoutReady = true;
			layoutChromeElements();			
		}
		
		/**
		 * @private
		 */
		private function layoutChromeElements():void
		{
			var contentAreaY:Number = 0;
			var contentAreaHeight:Number = _strand.height;
			
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			
			if (_navigationBar)
			{
				_navigationBar.x = 0;
				_navigationBar.y = 0;
				_navigationBar.width = _strand.width;
				
				contentAreaY = _navigationBar.height;
				contentAreaHeight -= _navigationBar.height;
				
				model.navigationBar = _navigationBar;
			}
			
			if (_tabBar)
			{
				_tabBar.x = 0;
				_tabBar.y = _strand.height - _tabBar.height;
				_tabBar.width = _strand.width;
				
				contentAreaHeight -= _tabBar.height;
				
				model.tabBar = _tabBar;
			}
			
			_strand.contentArea.x = 0;
			_strand.contentArea.y = contentAreaY;
			_strand.contentArea.width = _strand.width;
			_strand.contentArea.height = contentAreaHeight;
		}
		
		/**
		 * @private
		 */
		protected function changeHandler(event:Event):void
		{
			if (layoutReady) layoutChromeElements();
		}
		
		/**
		 * @private
		 */		
		private function handleButtonBarChange(event:Event):void
		{
			var newIndex:Number = _tabBar.selectedIndex;
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			
			// doing this will trigger the selectedIndexChanged event which will
			// tell the strand to switch views
			model.selectedIndex = newIndex;
		}
		
		/**
		 * @private
		 */
		public function get host():IUIBase
		{
			return _strand;
		}
		
		/**
		 * @private
		 */
		public function get viewWidth():Number
		{
			return _strand.width;
		}
		
		/**
		 * @private
		 */
		public function get viewHeight():Number
		{
			return _strand.height;
		}
	}
}
