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
	import org.apache.royale.html.beads.GroupView;
	import org.apache.royale.core.IBeadModel;
	import org.apache.royale.core.IBeadView;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.IViewportModel;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.IEventDispatcher;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.Container;
	import org.apache.royale.html.beads.layouts.HorizontalLayout;
	import org.apache.royale.mobile.IViewManagerView;
	import org.apache.royale.mobile.chrome.NavigationBar;
	import org.apache.royale.mobile.models.ViewManagerModel;
	
	/**
	 * The ViewManagerViewBase creates the visual elements of the StackedViewManager. This
	 * includes a NavigationBar, ToolBar, and contentArea.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ViewManagerViewBase extends GroupView
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ViewManagerViewBase()
		{
			super();
		}
		
		/*
		 * Children
		 */
		
		/**
		 * @private
		 * @royaleignorecoercion org.apache.royale.core.IUIBase
		 */
		protected function getHost():UIBase
		{
			return _strand as UIBase;
		}

		public function get navigationBar():NavigationBar
		{
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			return model.navigationBar;
		}
		public function set navigationBar(value:NavigationBar):void
		{
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			model.navigationBar = value;
		}
		
		/*
		 * ViewBead
		 */
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			var model:ViewManagerModel = value.getBeadByType(IBeadModel) as ViewManagerModel;
//			model.addEventListener("selectedIndexChanged", viewsChangedHandler);

			if (model.navigationBarItems)
			{
				var navBar:NavigationBar = new NavigationBar();
				navBar.controls = model.navigationBarItems;
				navBar.addBead(new HorizontalLayout());
				navigationBar = navBar;
			}
		}
		
		override protected function handleInitComplete(event:Event):void
		{
			super.handleInitComplete(event);
			addViewElements();
		}
		protected function addViewElements():void
		{
			if (navigationBar) {
				getHost().addElement(navigationBar);
			}
		}
		
		/**
		 * @private
		 */
//		protected function viewsChangedHandler(event:Event):void
//		{
//			layoutChromeElements();
//		}
		
		/**
		 * @private
		 */
//		protected function sizeChangedHandler(event:Event):void
//		{
//			layoutChromeElements();
//		}
		
		/**
		 * @private
		 */
		protected function layoutChromeElements():void
		{
			performLayout(null);
//			var host:UIBase = _strand as UIBase;
//			var contentAreaY:Number = 0;
//			var contentAreaHeight:Number = host.height;
//			
//			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
//			
//			if (_navigationBar)
//			{
//				_navigationBar.x = 0;
//				_navigationBar.y = 0;
//				_navigationBar.width = host.width;
//				
//				contentAreaHeight -= _navigationBar.height;
//				contentAreaY = _navigationBar.height;
//				
//				model.navigationBar = _navigationBar;
//			}
//			
//			model.contentX = 0;
//			model.contentY = contentAreaY;
//			model.contentWidth = host.width;
//			model.contentHeight = contentAreaHeight;
//			
//			sizeViewsToFitContentArea();
		}
		
		protected function sizeViewsToFitContentArea():void
		{
//			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
//			
//			var n:int = ViewManagerModel(model).views.length;
//			if (n > 0) {
//				for (var i:int = 0; i < n; i++)
//				{
//					var view:IViewManagerView = ViewManagerModel(model).views[i] as IViewManagerView;
//					UIBase(view).x = model.contentX;
//					UIBase(view).y = model.contentY;
//					UIBase(view).setWidthAndHeight(model.contentWidth, model.contentHeight, true);
//				}
//			}
		}
	}
}
