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
package org.apache.flex.core
{
	/**
	 * A Viewport is a window onto an area of content. A viewport is given space
	 * in which to operate by a View bead. Viewports can control their area which
	 * is specified by the IViewportModel, adding scrollbars or whatever scrolling
	 * mechanism they want.
	 */
	public interface IViewport extends IBead
	{
		/**
		 * The IViewportModel the instance of the Viewport should use to determine
		 * its location and the location/size of the content it is managing. The
		 * model also contains the layout to use and the contentArea to manage.
		 */
		function get model():IViewportModel;
		function set model(value:IViewportModel):void;
		
		/**
		 * Invoke this function to actually change the contentArea (specified in
		 * the IViewportModel.
		 */
		function updateContentAreaSize():void;
		
		/**
		 * Invoke this function when the host of the viewport has changed size.
		 */
		function updateSize():void;
		
		/**
		 * If a View determines that scrollers are needed, it can inform the
		 * Viewport using one of these three methods.
		 */
		function needsScrollers():void;
		function needsVerticalScroller():void;
		function needsHorizontalScroller():void;
		
		/**
		 * Returns the vertical scroller being used, if any.
		 */
		function get verticalScroller():IViewportScroller;
		
		/**
		 * Returns the horizontal scroller being used, if any.
		 */
		function get horizontalScroller():IViewportScroller;
		
		/**
		 * Returns the effective width of the vertical scroller. This may
		 * be the actual width of the scroller or it might be zero if the
		 * scroller has no impact on the view.
		 */
		function scrollerWidth():Number;
		
		/**
		 * Returns the effective height of the horizontal scroller. This may
		 * be the actual height of the scroller or it might be zero if the
		 * scroller has no impact on the view.
		 */
		function scrollerHeight():Number;
	}
}