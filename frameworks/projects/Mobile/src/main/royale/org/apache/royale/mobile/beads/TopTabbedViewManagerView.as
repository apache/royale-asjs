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
	import org.apache.royale.mobile.chrome.TabBar;
	import org.apache.royale.mobile.models.ViewManagerModel;
	import org.apache.royale.mobile.beads.TabbedViewManagerView;
	
	/**
	 * The TopTabbedViewManagerView constructs the visual elements of the TabbedViewManager.
	 * It always contains a tab bar and it's located at the top.
	 * It may contain a navigation bar at the bottom.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class TopTabbedViewManagerView extends TabbedViewManagerView
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9
		 */
		public function TopTabbedViewManagerView()
		{
			super();
		}
		
		override protected function addViewElements():void
		{			
			
			if (tabBar) {
				getHost().addElement(tabBar);
			}
			if (navigationBar) {
				getHost().addElement(navigationBar);
			}
			
			showViewByIndex(0);
		}
		override protected function insertCurrentView(view:IViewManagerView):void{
			getHost().addElementAt(view,(tabBar ? 1 : 0));
		}

	}
}
