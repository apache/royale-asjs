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
    import org.apache.royale.core.layout.EdgeData;
    
	/**
	 * A Viewport is the area of a Container set aside for displaying
     * content and any scrolling controls.
     * The ViewportModel caches the offsets required to compute the size
     * of the Viewport.
	 */
	public interface IViewportModel extends IBead
	{	
		/**
		 * Size of the borders.
		 */
		function get borderMetrics():EdgeData;
		function set borderMetrics(value:EdgeData):void;
		
        /**
         * Size of the chrome.  A plain container doesn't have any chrome
         * but a Panel's TitleBar and any ControlBar or StatusBar is
         * considered chrome.  Scrollbars used to scroll content are
         * not factored into the viewport calculation.  The Viewport
         * is responsible for displaying any scrolling controls and
         * deciding whether to further shrink the content area or
         * have the scrollbars overlay the content.
         */
        function get chromeMetrics():EdgeData;
        function set chromeMetrics(value:EdgeData):void;
        
	}
}
