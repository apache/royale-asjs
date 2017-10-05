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
package org.apache.royale.core
{
    import org.apache.royale.geom.Size;

	/**
	 * A Viewport is a window onto an area of content. A viewport is given space
	 * in which to operate by a View bead. Viewports can control their area which
	 * is specified by the IViewportModel, adding scrollbars or whatever scrolling
	 * mechanism they want.
	 */
    public interface IViewport extends IBead
	{
        /**
         * Get the actual parent of the container's content.
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
         */
        function get contentView():IUIBase;

		/**
		 * Sets the upper left position of the viewport
         * @param x The left position.
         * @param y The top position.
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		function setPosition(x:Number, y:Number):void;

		/**
		 * Size the content area based on any visible scrolling controls and
         * the given width and height.  If width and/or height is NaN
         * then that dimension is being sized to content.
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
		 */
		function layoutViewportBeforeContentLayout(width:Number, height:Number):void;

        /**
         * This method is invoked after layout is complete.  If width and/or height is
         * sized to content, the viewport should determine that size and set the
         * content area size appropriately, and display any scrolling controls
         * before returning the resulting size of the viewport (which means the
         * area used up by both content area and scrolling controls).
	     *
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.0
         */
        function layoutViewportAfterContentLayout(contentSize:Size):void;

	}
}
