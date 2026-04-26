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
package org.apache.royale.style
{
	COMPILE::JS{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ValueChangeEvent;

	/**
	 *  Dispatched when the selected tab changes.
	 */
	[Event(name="change", type="org.apache.royale.events.Event")]

	[DefaultProperty("tabs")]

	public class TabBar extends StyleUIBase
	{

		public function TabBar()
		{
			super();
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();
			elem.setAttribute("role", "tablist");
			return elem;
		}

		public function get tabs():Array
		{
			var result:Array = [];
			for(var i:int = 0; i < numElements; i++)
				result.push(getElementAt(i));
			return result;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Tab
		 */
		public function set tabs(value:Array):void
		{
			while(numElements > 0)
			{
				var oldTab:Tab = getElementAt(0) as Tab;
				oldTab.removeEventListener("itemClicked", itemClickedHandler);
				removeElement(oldTab);
			}
			if(value)
			{
				for each(var tab:Tab in value)
				{
					tab.addEventListener("itemClicked", itemClickedHandler);
					addElement(tab);
				}
				if(_selectedIndex >= 0 && _selectedIndex < value.length)
					value[_selectedIndex].selected = true;
			}
		}

		private var _selectedIndex:int = -1;

		[Bindable(event='valueChange',type='org.apache.royale.events.ValueChangeEvent')]
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}

		public function set selectedIndex(value:int):void
		{
			if(value != _selectedIndex)
			{
				var oldValue:int = _selectedIndex;
				selectTab(value);
				dispatchEvent(ValueChangeEvent.createUpdateEvent(this, 'selectedIndex', oldValue, value));
				dispatchEvent(new Event("change"));
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Tab
		 */
		public function get selectedTab():Tab
		{
			if(_selectedIndex >= 0 && _selectedIndex < numElements)
				return getElementAt(_selectedIndex) as Tab;
			return null;
		}

		private function itemClickedHandler(event:Event):void
		{
			var tab:Tab = event.target as Tab;
			for(var i:int = 0; i < numElements; i++)
			{
				if(getElementAt(i) == tab)
				{
					selectedIndex = i;
					return;
				}
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.Tab
		 */
		private function selectTab(index:int):void
		{
			for(var i:int = 0; i < numElements; i++)
			{
				(getElementAt(i) as Tab).selected = (i == index);
			}
			_selectedIndex = index;
		}

		override public function getWrapperStyle():String
		{
			return 'tab-bar';
		}
	}
}
