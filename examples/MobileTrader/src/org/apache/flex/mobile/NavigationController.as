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
	import org.apache.flex.core.UIBase;
	
	/**
	 *  The NavigationController is an interface that should be implemented by
	 *  any class that performs changes of views.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class NavigationController extends UIBase implements INavigationController
	{
		/**
		 *  Controller.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function NavigationController()
		{
			super();
			
			_views = [];
		}
		
		private var _views:Array;
		
		/**
		 *  The current set of views in the navigation stack. The last entry is
		 *  the top-most (visible) view controller.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get views():Array
		{
			return _views;
		}
		public function set views(value:Array):void
		{
			if (_views == null) _views = [];
			
			for(var i:int=0; i < value.length; i++) {
				var view:IViewController = value[i] as IViewController;
				if (view) {
					push(view);
				}
			}
		}
		
		/**
		 *  Pushes the next view onto the navigation stack.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function push(nextView:IViewController):void
		{
			nextView.navigationController = this;
			_views.push(nextView);
			
			addElement(nextView);
		}
		/**
		 *  Pops the top-most view from the navigation stack.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function pop():void
		{
			if (_views.length > 1) {
				var lastView:Object = _views.pop();
				removeElement(lastView);
			}
		}
	}
}