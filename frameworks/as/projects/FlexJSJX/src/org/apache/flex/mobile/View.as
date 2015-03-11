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
package org.apache.flex.mobile
{
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.html.Container;
	
	/**
	 * The View class represents the area for a mobile app's primary
	 * interface elements.
	 */
	public class View extends Container implements IView
	{
		public function View()
		{
			super();
		}
		
		private var _title:String;
		public function get title():String
		{
			return _title;
		}
		public function set title(value:String):void
		{
			_title = value;
		}
		
		override public function toString():String
		{
			return _title;
		}
		
		private var _viewManager:IViewManager;
		public function get viewManager():IViewManager
		{
			return _viewManager;
		}
		public function set viewManager(value:IViewManager):void
		{
			_viewManager = value;
		}
		
		override public function addedToParent():void
		{
			super.addedToParent();
//			this.width = this.viewManager.contentWidth;
//			this.height = this.viewManager.contentHeight;
//			trace("Set View to "+this.width+"x"+this.height);
		}
	}
}