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
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.beads.ContainerView;
	import org.apache.flex.html.beads.layouts.HorizontalLayout;
	import org.apache.flex.mobile.chrome.NavigationBar;
	import org.apache.flex.mobile.chrome.ToolBar;
	import org.apache.flex.mobile.models.ViewManagerModel;
	import org.apache.flex.utils.BeadMetrics;

	/**
	 * The StackedViewManagerView creates the visual elements of the StackedViewManager. This
	 * includes a NavigationBar, ToolBar, and contentArea.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class StackedViewManagerView extends ViewManagerView
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
		
		private var _toolBar:ToolBar;

		override public function set strand(value:IStrand):void
		{
			var model:ViewManagerModel = value.getBeadByType(IBeadModel) as ViewManagerModel;
			
			if (model.toolBarItems)
			{
				_toolBar = new ToolBar();
				_toolBar.controls = model.toolBarItems;
				_toolBar.addBead(new HorizontalLayout());
				UIBase(value).addElement(_toolBar,false);
			}
			
			super.strand = value;
		}
		override public function get strand():IStrand
		{
			return super.strand;
		}
		
		/**
		 * @private
		 */
		override protected function layoutChromeElements():void
		{
			var host:UIBase = strand as UIBase;
			var contentAreaY:Number = 0;
			var contentAreaHeight:Number = host.height;
			var toolbarHeight:Number = _toolBar == null ? 0 : _toolBar.height;
			
			var model:ViewManagerModel = strand.getBeadByType(IBeadModel) as ViewManagerModel;
			
			if (navigationBar)
			{
				navigationBar.x = 0;
				navigationBar.y = 0;
				navigationBar.width = host.width;
				
				contentAreaHeight -= navigationBar.height;
				contentAreaY = navigationBar.height;
				
				model.navigationBar = navigationBar;
			}
			
			if (_toolBar)
			{
				_toolBar.x = 0;
				_toolBar.y = host.height - toolbarHeight;
				_toolBar.width = host.width;
				
				contentAreaHeight -= toolbarHeight;
				
				model.toolBar = _toolBar;
			}
			
			if (contentAreaY < 0) contentAreaY = 0;
			if (contentAreaHeight < 0) contentAreaHeight = 0;
			
			model.contentX = 0;
			model.contentY = contentAreaY;
			model.contentWidth = host.width;
			model.contentHeight = contentAreaHeight;
			
			sizeViewsToFitContentArea();
			
			// notify the views that the content size has changed
			IEventDispatcher(strand).dispatchEvent( new Event("contentSizeChanged") );
		}
	}
}
