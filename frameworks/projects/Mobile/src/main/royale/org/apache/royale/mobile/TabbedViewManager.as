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
package org.apache.royale.mobile
{	
	import org.apache.royale.events.Event;
	import org.apache.royale.html.Container;
	import org.apache.royale.mobile.IViewManagerView;
	import org.apache.royale.mobile.IViewManager;
	import org.apache.royale.mobile.chrome.TabBar;
	import org.apache.royale.mobile.models.ViewManagerModel;
	import org.apache.royale.mobile.beads.TabbedViewManagerView;
	
	[Event(name="viewChanged",type="org.apache.royale.events.Event")]
	
	/**
	 * The TabbedViewManager displays a set of views, only one of which is active at
	 * a time. The other views are reachable via a set of tab buttons at the bottom of
	 * the view manager's space.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class TabbedViewManager extends ViewManagerBase implements IViewManager
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function TabbedViewManager()
		{
			super();
			
			typeNames = "TabbedViewManager";
		}
		
		/**
		 * The TabBar (or null if not present).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get tabBar():TabBar
		{
			return ViewManagerModel(model).tabBar;
		}
		
		/**
		 * The index (starting at zero) of the currently visible view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function get selectedIndex():Number
		{
			return ViewManagerModel(model).selectedIndex;
		}
		public function set selectedIndex(value:Number):void
		{
			ViewManagerModel(model).selectedIndex = value;
		}
		
		/**
		 * @private
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
		}

	}
}
