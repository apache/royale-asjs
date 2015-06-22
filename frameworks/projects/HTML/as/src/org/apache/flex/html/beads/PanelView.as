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
package org.apache.flex.html.beads
{
	import flash.display.Sprite;
	
	import org.apache.flex.core.IBeadView;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.IEventDispatcher;
	import org.apache.flex.html.Container;
	import org.apache.flex.html.Panel;
	import org.apache.flex.html.TitleBar;
	import org.apache.flex.utils.BeadMetrics;
	
	/**
	 *  The Panel class creates the visual elements of the org.apache.flex.html.Panel 
	 *  component. A Panel has a org.apache.flex.html.TitleBar, and content.  A
     *  different View, PanelWithControlBarView, can display a ControlBar.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class PanelView extends ContainerView implements IBeadView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function PanelView()
		{
		}
		
		private var _titleBar:TitleBar;
		
		/**
		 *  The org.apache.flex.html.TitleBar component of the 
		 *  org.apache.flex.html.Panel.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get titleBar():TitleBar
		{
			return _titleBar;
		}
        /**
         *  @private
         */
        public function set titleBar(value:TitleBar):void
        {
            _titleBar = value;
        }
				
		/**
		 *  @copy org.apache.flex.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		override public function set strand(value:IStrand):void
		{
            var host:UIBase = UIBase(value);
            
            if (!_titleBar)
                _titleBar = new TitleBar();
			// replace the TitleBar's model with the Panel's model (it implements ITitleBarModel) so that
			// any changes to values in the Panel's model that correspond values in the TitleBar will 
			// be picked up automatically by the TitleBar.
			titleBar.model = host.model;
			host.addElement(titleBar, false);
			titleBar.addEventListener("heightChanged", titleBarHeightChanged);
			            
            super.strand = value;

		}
		
		/**
		 * Creates the viewport for panel by first using the super.createViewport to get
		 * a baseline, then adjusts the viewport to account for the title bar.
		 */
		override protected function createViewport(metrics:UIMetrics):void
		{
			super.createViewport(metrics);
			setupViewport(metrics);
		}
		
		private function setupViewport(metrics:UIMetrics):void
		{
			var host:UIBase = UIBase(_strand);
			
			titleBar.width = host.width;
			
			var model:IViewportModel = viewport.model;
			model.viewportX = 0;
			model.viewportY = titleBar.height;
			model.viewportWidth = host.width;
			model.viewportHeight = host.height - titleBar.height;
			model.contentX = model.viewportX + metrics.left;
			model.contentY = model.viewportY + metrics.top;
			model.contentWidth = model.viewportWidth - metrics.left - metrics.right;
			model.contentHeight = model.viewportHeight - metrics.top - metrics.bottom;
		}
		
		/**
		 * This function is called when the layout has changed the size of the contentArea
		 * (aka, actualParent). Depending on how the Panel is being sized, the contentArea
		 * affects how the panel is presented.
		 */
		override protected function handleContentResize():void
		{
			var host:UIBase = UIBase(_strand);
			var viewportModel:IViewportModel = viewport.model;
			
			titleBar.x = 0;
			titleBar.y = 0;
			titleBar.width = host.width;
			
			// If the host is being sized by its content, the change in the contentArea
			// causes the host's size to change
			if (host.isWidthSizedToContent() && host.isHeightSizedToContent()) {
				host.setWidthAndHeight(viewportModel.contentWidth, viewportModel.contentHeight + titleBar.height, false);
				
				titleBar.setWidth(host.width, true);
				
				var metrics:UIMetrics = getMetrics();
				
				viewportModel.viewportHeight = viewportModel.contentHeight + metrics.top + metrics.bottom;
				viewportModel.viewportWidth  = viewportModel.contentWidth + metrics.left + metrics.right;
			}
				
			// if the width is fixed and the height is changing, then set up horizontal
			// scrolling (if the viewport supports it).
			else if (!host.isWidthSizedToContent() && host.isHeightSizedToContent())
			{
				viewport.needsHorizontalScroller();
				
				metrics = getMetrics();
				
				host.setHeight(viewportModel.contentHeight + titleBar.height, false);
				viewportModel.viewportHeight = viewportModel.contentHeight + metrics.top + metrics.bottom;
				
			}
				
				// if the height is fixed and the width can change, then set up
				// vertical scrolling (if the viewport supports it).
			else if (host.isWidthSizedToContent() && !host.isHeightSizedToContent())
			{
				viewport.needsVerticalScroller();
				
				metrics = getMetrics();
				
				host.setWidth(viewportModel.contentWidth+viewport.scrollerWidth(), false);
				viewportModel.viewportWidth = viewportModel.contentWidth + metrics.left + metrics.right;
			}
				
				// Otherwise the viewport needs to display some scrollers (or other elements
				// allowing the rest of the contentArea to be visible)
			else {
				
				viewport.needsScrollers();
			}
		}
		
		override protected function resizeHandler(event:Event):void
		{
			var host:UIBase = UIBase(_strand);
			var viewportModel:IViewportModel = viewport.model;
			
			titleBar.width = host.width;
						
			// the viewport has to be adjusted to account for the change
			// in the host size.			
			viewportModel.viewportHeight = host.height - titleBar.height;
			viewportModel.viewportWidth = host.width;
			
			// if the host has a fixed width, reset the contentWidth to match.
			if (!host.isWidthSizedToContent()) viewportModel.contentWidth = host.width;
			
			// if the host has a fixed height, reset the contentHeight to match.
			if (!host.isHeightSizedToContent()) viewportModel.contentHeight = host.height - titleBar.height;
			
			// the viewport's size and position also has to be adjusted since the
			// host's size has changed.
			viewport.updateSize();
			
			// the layout needs to be run to adjust the content for 
			// the new host size.
			changeHandler(event);
		}
		
		private function titleBarHeightChanged(event:Event):void
		{
			var metrics:UIMetrics = this.getMetrics();
			setupViewport(metrics);
		}
        
        /**
         * @private
         * Panel always needs content area.
         */
        override protected function contentAreaNeeded():Boolean
        {
            return true;
        }
                
	}
}
