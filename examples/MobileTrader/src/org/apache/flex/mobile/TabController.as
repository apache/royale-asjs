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
	import org.apache.flex.events.Event;
	import org.apache.flex.html.ButtonBar;
	
	/**
	 *  The TabController class is used to navigate between sections of an
	 *  application. A TabBar is used to select which INavigationController
	 *  child of the TabController should be presented.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class TabController extends UIBase
	{
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function TabController()
		{
			super();
		}
		
		private var _views : Array;
		private var _buttonBar:ButtonBar;
		private var _currentView:UIBase;
		private var _selectedIndex:Number;
		
		/**
		 *  The components under tab management.
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
			_views = value;
			
			if (_currentView) {
				removeElement(_currentView);
			}
			
			_currentView = views[0];
			showCurrentView();
		}
		
		/**
		 *  The currently selected tab view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get currentView():UIBase
		{
			return _currentView;
		}
		
		/**
		 *  The zero-based index of the currently active tab.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get selectedIndex():Number
		{
			return _selectedIndex;
		}
		public function set selectedIndex(value:Number):void
		{
			if (value < _views.length) {
				if (_currentView) {
					removeElement(_currentView);
				}
				_selectedIndex = value;
				_currentView = views[value];
				showCurrentView();
			}
		}
		
		/**
		 *  The TabBar being used for navigation.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get buttonBar():ButtonBar
		{
			return _buttonBar;
		}
		public function set buttonBar(value:ButtonBar):void
		{
			if (value != _buttonBar) {
				if (_buttonBar) {
					_buttonBar.removeEventListener("change",handleButtonBarChange);
				}
				_buttonBar = value;
				_buttonBar.addEventListener("change",handleButtonBarChange);
			}
		}
		
		/**
		 *  @private
		 */
		private function showCurrentView() : void
		{
			_currentView.width = this.width;
			_currentView.height = this.height;
			addElement(_currentView);
		}
		
		/**
		 * @private
		 */
		override public function addElement(c:Object):void
		{
			super.addElement(c);
		}
		
		private function handleButtonBarChange(event:Event):void
		{
			var newIndex:Number = _buttonBar.selectedIndex;
			selectedIndex = newIndex;
		}
	}
}