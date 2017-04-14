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
	import org.apache.flex.mobile.IViewManager;
	import org.apache.flex.mobile.IViewManagerView;
	import org.apache.flex.mobile.ManagedContentArea;
	import org.apache.flex.mobile.chrome.NavigationBar;
	import org.apache.flex.mobile.chrome.ToolBar;
	import org.apache.flex.mobile.models.ViewManagerModel;

	/**
	 * The StackedViewManagerView creates the visual elements of the StackedViewManager. This
	 * includes a NavigationBar, ToolBar, and contentArea.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class StackedViewManagerView extends ViewManagerViewBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function StackedViewManagerView()
		{
			super();
		}
		
		private var _strand:IStrand;
		
		/*
		 * Children
		 */
		
		private var _contentArea:ManagedContentArea;
		
		public function get contentArea():ManagedContentArea
		{
			return _contentArea;
		}
		
		public function get toolBar():ToolBar
		{
			var model:ViewManagerModel = strand.getBeadByType(IBeadModel) as ViewManagerModel;
			return model.toolBar;
		}
		public function set toolBar(value:ToolBar):void
		{
			var model:ViewManagerModel = strand.getBeadByType(IBeadModel) as ViewManagerModel;
			model.toolBar = value;
		}
		
		/*
		 * ViewBead
		 */
		
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
			
			if (model.toolBarItems)
			{
				var tbar:ToolBar = new ToolBar();
				tbar.controls = model.toolBarItems;
				tbar.addBead(new HorizontalLayout());
				toolBar = tbar;
			}
		}
		
		override protected function handleInitComplete(event:Event):void
		{			
			super.handleInitComplete(event);
			
			var model:ViewManagerModel = _strand.getBeadByType(IBeadModel) as ViewManagerModel;
			IEventDispatcher(model).addEventListener("viewPushed", handlePushEvent);
			IEventDispatcher(model).addEventListener("viewPopped", handlePopEvent);
			
			COMPILE::SWF {
				_contentArea.percentWidth = 100;
			}
			UIBase(_strand).addElement(_contentArea);
			
			if (toolBar) {
				UIBase(_strand).addElement(toolBar);
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
				contentArea.removeElement(_topView);
			}
			_topView = model.views[index] as IViewManagerView;
			_topView.viewManager = _strand as IViewManager;
			contentArea.addElement(_topView);
			
			COMPILE::JS {
				if (_topView) {
					UIBase(_topView).element.style["flex-grow"] = "1";
				}
			}
			COMPILE::SWF {
				UIBase(_topView).percentWidth = 100;
				UIBase(_topView).percentHeight = 100;
				contentArea.layoutNeeded();
			}
		}
		
		override public function afterLayout():void
		{
			super.afterLayout();
			
			COMPILE::SWF {
				if (_topView) {
					UIBase(_topView).width = contentArea.width;
					UIBase(_topView).height = contentArea.height;
				}
			}
		}
	}
}
