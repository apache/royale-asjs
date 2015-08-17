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
package org.apache.flex.html.supportClasses
{
	import flash.geom.Rectangle;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IParentIUIBase;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.core.IViewport;
	import org.apache.flex.core.IViewportModel;
	import org.apache.flex.core.IViewportScroller;
	import org.apache.flex.core.UIBase;
	import org.apache.flex.core.UIMetrics;
	import org.apache.flex.events.Event;
	import org.apache.flex.html.beads.models.ScrollBarModel;
	import org.apache.flex.utils.BeadMetrics;
	
	public class Viewport implements IBead, IViewport
	{	
		public function Viewport()
		{
		}
		
		private var contentArea:UIBase;		
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
		}
		
		private var _model:IViewportModel;
		
		public function set model(value:IViewportModel):void
		{
			_model = value;
			
			if (model.contentArea) contentArea = model.contentArea as UIBase;
			
			model.addEventListener("contentAreaChanged", handleContentChange);
		}
		public function get model():IViewportModel
		{
			return _model;
		}
		
		public function get verticalScroller():IViewportScroller
		{
			return null;
		}
		
		public function get horizontalScroller():IViewportScroller
		{
			return null;
		}
		
		/**
		 * Invoke this function to reshape and set the contentArea being managed by
		 * this viewport. If scrollers are present this will update them as well to
		 * reflect the current location of the visible portion of the contentArea
		 * within the viewport.
		 */
		public function updateContentAreaSize():void
		{
			if (!model.contentIsHost) {
				contentArea.x = model.contentX;
				contentArea.y = model.contentY;
			}
			//contentArea.setWidthAndHeight(model.contentWidth, model.contentHeight, true);
		}
		
		public function updateSize():void
		{
			// not needed for this type of viewport
		}
		
		/**
		 * Call this function when at least one scroller is needed to view the entire
		 * contentArea.
		 */
		public function needsScrollers():void
		{
		}
		
		/**
		 * Call this function when only a vertical scroller is needed
		 */
		public function needsVerticalScroller():void
		{
			
		}
		
		/**
		 * Call this function when only a horizontal scroller is needed
		 */
		public function needsHorizontalScroller():void
		{
			
		}
		
		public function scrollerWidth():Number
		{
			return 0;
		}
		
		public function scrollerHeight():Number
		{
			return 0;
		}
		
		private function handleContentChange(event:Event):void
		{
			contentArea = model.contentArea as UIBase;
		}
	}
}