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
	 *  Dispatched when the selected page changes.
	 */
	[Event(name="change", type="org.apache.royale.events.Event")]

	[DefaultProperty("items")]

	public class Pagination extends StyleUIBase
	{

		public function Pagination()
		{
			super();
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();
			elem.setAttribute("role", "navigation");
			elem.setAttribute("aria-label", "Pagination");
			return elem;
		}

		public function get items():Array
		{
			var result:Array = [];
			for(var i:int = 0; i < numElements; i++)
				result.push(getElementAt(i));
			return result;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.PaginationItem
		 */
		public function set items(value:Array):void
		{
			while(numElements > 0)
			{
				var oldItem:PaginationItem = getElementAt(0) as PaginationItem;
				oldItem.removeEventListener("itemClicked", itemClickedHandler);
				removeElement(oldItem);
			}
			if(value)
			{
				for each(var item:PaginationItem in value)
				{
					item.addEventListener("itemClicked", itemClickedHandler);
					addElement(item);
				}
				if(_selectedIndex >= 0 && _selectedIndex < value.length)
				{
					(value[_selectedIndex] as PaginationItem).selected = true;
				}
				else
				{
					for(var j:int = 0; j < value.length; j++)
					{
						if((value[j] as PaginationItem).selected)
						{
							_selectedIndex = j;
							break;
						}
					}
				}
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
				selectItem(value);
				dispatchEvent(ValueChangeEvent.createUpdateEvent(this, 'selectedIndex', oldValue, value));
				dispatchEvent(new Event("change"));
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.PaginationItem
		 */
		public function get selectedItem():PaginationItem
		{
			if(_selectedIndex >= 0 && _selectedIndex < numElements)
				return getElementAt(_selectedIndex) as PaginationItem;
			return null;
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.PaginationItem
		 */
		private function itemClickedHandler(event:Event):void
		{
			var item:PaginationItem = event.target as PaginationItem;
			for(var i:int = 0; i < numElements; i++)
			{
				if(getElementAt(i) == item)
				{
					if(item.selectable)
					{
						selectedIndex = i;
					}
					else if(_selectedIndex >= 0)
					{
						if(i < _selectedIndex)
							selectNeighbor(-1);
						else
							selectNeighbor(1);
					}
					return;
				}
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.PaginationItem
		 */
		private function selectNeighbor(direction:int):void
		{
			var i:int = _selectedIndex + direction;
			while(i >= 0 && i < numElements)
			{
				var item:PaginationItem = getElementAt(i) as PaginationItem;
				if(item.selectable && !item.disabled)
				{
					selectedIndex = i;
					return;
				}
				i += direction;
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.PaginationItem
		 */
		private function selectItem(index:int):void
		{
			for(var i:int = 0; i < numElements; i++)
			{
				(getElementAt(i) as PaginationItem).selected = (i == index);
			}
			_selectedIndex = index;
		}

		override public function getWrapperStyle():String
		{
			return 'pagination';
		}
	}
}
