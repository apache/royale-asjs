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
    import org.apache.flex.geom.Size;
    
    /**
     * A Viewport is the area of a Container set aside for displaying
     * content and any scrolling controls.
     */
	public interface IViewport extends IBead
	{
        /**
         * Get the actual parent of the container's content.
         */
        function get contentView():IUIBase;
        
		/**
		 * Sets the upper left position of the viewport
         * @param x The left position.
         * @param y The top position.
		 */
		function setPosition(x:Number, y:Number):void;
		
		/**
		 * Size the content area based on any visible scrolling controls and
         * the given width and height.  If width and/or height is NaN
         * then that dimension is being sized to content.
		 */
		function layoutViewportBeforeContentLayout(width:Number, height:Number):void;
		
        /**
         * This method is invoked after layout is complete.  If width and/or height is
         * sized to content, the viewport should determine that size and set the
         * content area size appropriately, and display any scrolling controls
         * before returning the resulting size of the viewport (which means the
         * area used up by both content area and scrolling controls).
         */
        function layoutViewportAfterContentLayout():Size;
        
	}
}