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
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	import org.apache.royale.core.IChild;
	import org.apache.royale.events.Event;
	import org.apache.royale.style.elements.Div;
	import org.apache.royale.style.skins.IDropdownSkin;
	import org.apache.royale.style.StyleUIBase;

	[Event(name="openChanged", type="org.apache.royale.events.Event")]

	public class Dropdown extends Group
	{
		public function Dropdown()
		{
			super();
			useWrapperStyle = true;
		}

		protected var triggerElem:Div;
		protected var contentElem:Div;

		private var _triggerText:String;

		public function get triggerText():String
		{
			return _triggerText;
		}

		public function set triggerText(value:String):void
		{
			_triggerText = value;
			if (triggerElem)
				triggerElem.text = value;
		}

		private var _open:Boolean = false;

		public function get open():Boolean
		{
			return _open;
		}

		public function set open(value:Boolean):void
		{
			if (value != _open)
			{
				_open = value;
				toggleAttribute("open", value);
				dispatchEvent(new Event("openChanged"));
			}
		}

		private var _disabled:Boolean = false;

		public function get disabled():Boolean
		{
			return _disabled;
		}

		public function set disabled(value:Boolean):void
		{
			if (value != _disabled)
			{
				_disabled = value;
				toggleAttribute("data-disabled", value);
				if (triggerElem)
				{
					COMPILE::JS
					{
						(triggerElem.element as HTMLElement).tabIndex = value ? -1 : 0;
					}
				}
			}
		}

		/**
		 * Override numElements/addElementAt/getElementAt/getElementIndex
		 * so that MXML content goes into the content div, not the wrapper.
		 */
		override public function get numElements():int
		{
			return contentElem ? contentElem.numElements : 0;
		}

		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			contentElem.addElement(c, dispatchEvent);
			applyItemStyles(c);
		}

		override public function addElementAt(c:IChild, index:int, dispatchEvent:Boolean = true):void
		{
			contentElem.addElementAt(c, index, dispatchEvent);
			applyItemStyles(c);
		}

		override public function getElementAt(index:int):IChild
		{
			return contentElem.getElementAt(index);
		}

		override public function getElementIndex(c:IChild):int
		{
			return contentElem.getElementIndex(c);
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();

			triggerElem = new Div();
			triggerElem.tabIndex = _disabled ? -1 : 0;
			super.addElement(triggerElem);
			if (_triggerText)
				triggerElem.text = _triggerText;

			contentElem = new Div();
			super.addElement(contentElem);

			if (_open)
				toggleAttribute("open", true);
			if (_disabled)
				toggleAttribute("data-disabled", true);

			element.addEventListener("focusout", handleFocusOut);

			return elem;
		}

		COMPILE::JS
		private function handleFocusOut(event:Object):void
		{
			// Close when focus leaves the dropdown entirely
			if (_open && !element.contains(event.relatedTarget))
			{
				open = false;
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.skins.IDropdownSkin
		 */
		override protected function applySkin():void
		{
			var dropSkin:IDropdownSkin = skin as IDropdownSkin;
			triggerElem.setStyles(dropSkin.triggerStyles, true);
			contentElem.setStyles(dropSkin.contentStyles, true);
			// Apply item styles to any children already added
			for (var i:int = 0; i < numElements; i++)
			{
				applyItemStyles(getElementAt(i));
			}
		}

		private function applyItemStyles(c:IChild):void
		{
			(c as StyleUIBase).setStyles((skin as IDropdownSkin).itemStyles, true);
		}
	}
}
