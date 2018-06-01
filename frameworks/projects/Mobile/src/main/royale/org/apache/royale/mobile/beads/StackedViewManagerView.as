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
	import org.apache.royale.mobile.chrome.ToolBar;
	import org.apache.royale.mobile.models.ViewManagerModel;

	/**
	 * The StackedViewManagerView creates the visual elements of the StackedViewManager. This
	 * includes a NavigationBar, ToolBar, and contentArea.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class StackedViewManagerView extends ViewManagerViewBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function StackedViewManagerView()
		{
			super();
		}
		
		/*
		 * Children
		 */
		
		public function get toolBar():ToolBar
		{
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			return model.toolBar;
		}
		public function set toolBar(value:ToolBar):void
		{
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			model.toolBar = value;
		}
		
		/*
		 * ViewBead
		 */
		
		override public function set strand(value:IStrand):void
		{
			super.strand = value;
			
			var model:ViewManagerModel = value.getBeadByType(IBeadModel) as ViewManagerModel;
			
			if (model.toolBarItems)
			{
				var tbar:ToolBar = new ToolBar();
				tbar.controls = model.toolBarItems;
				tbar.addBead(new HorizontalLayout());
				toolBar = tbar;
			}
		}
		
		override protected function addViewElements():void
		{			
			super.addViewElements();
			
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			model.addEventListener("viewPushed", handlePushEvent);
			model.addEventListener("viewPopped", handlePopEvent);
			
			if (toolBar) {
				getHost().addElement(toolBar);
			}
			
			showViewByIndex(0);
		}
		
		private var _topView:IViewManagerView;
		
		private function handlePushEvent(event:Event):void
		{
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			var n:int = model.views.length;
			if (n > 0) {
				showViewByIndex(n-1);
			}
		}
		
		private function handlePopEvent(event:Event):void
		{
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			var n:int = model.views.length;
			if (n > 0) {
				showViewByIndex(n-1);
			}
		}
		
		public function showView(view:IViewManagerView):void
		{
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			for(var i:int=0; i < model.views.length; i++) {
				if (view == model.views[i]) {
					showViewByIndex(i);
					break;
				}
			}
		}
		
		protected function showViewByIndex(index:int):void
		{
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			
			if (_topView != null) {
				getHost().removeElement(_topView);
			}
			_topView = model.views[index] as IViewManagerView;
			_topView.viewManager = _strand as IViewManager;
			
			getHost().addElementAt(_topView,(navigationBar == null ? 0 : 1));
			
			COMPILE::JS {
				if (_topView) {
					UIBase(_topView).element.style["flex-grow"] = "1";
				}
			}
			COMPILE::SWF {
				if (UIBase(_topView).style == null) {
					UIBase(_topView).style = new SimpleCSSStylesWithFlex();
				}
				UIBase(_topView).style.flexGrow = 1;
				UIBase(_topView).percentWidth = 100;
			}
			
			// Now that a view has changed, refresh the layout for this component.
			getHost().dispatchEvent(new Event("layoutNeeded"));
		}
	}
}
