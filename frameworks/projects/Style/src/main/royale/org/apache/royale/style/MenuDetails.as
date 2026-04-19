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
		import org.apache.royale.html.util.addElementToWrapper;
	}
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.style.elements.Summary;
	import org.apache.royale.style.skins.IMenuDetailsSkin;
	import org.apache.royale.style.IStyleUIBase;

	[Event(name="openChanged", type="org.apache.royale.events.Event")]

	public class MenuDetails extends Group
	{
		public function MenuDetails()
		{
			super();
		}

		public function get headerText():String
		{
			return headerElem.text;
		}

		public function set headerText(value:String):void
		{
			headerElem.text = value;
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
				COMPILE::JS
				{
					if (value)
						detailsElem.setAttribute("open", "");
					else
						detailsElem.removeAttribute("open");
				}
				if (headerIcon)
				{
					headerIcon.toggleAttribute("data-open", value);
				}
				dispatchEvent(new Event("openChanged"));
			}
		}

		private function toggleSection(ev:MouseEvent):void
		{
			ev.stopPropagation();
			ev.preventDefault();
			open = !open;
		}

		protected var headerElem:Summary;

		protected var headerIcon:IStyleUIBase;

		COMPILE::JS
		protected var detailsElem:HTMLElement;

		/**
		 * @royaleignorecoercion org.apache.royale.style.skins.IMenuDetailsSkin
		 */
		override protected function applySkin():void
		{
			super.applySkin();
			if (skin is IMenuDetailsSkin)
			{
				headerElem.setStyles((skin as IMenuDetailsSkin).summaryStyles);
				var icon:IStyleUIBase = (skin as IMenuDetailsSkin).getIcon();
				if (icon)
				{
					headerIcon = icon;
					headerElem.addElement(headerIcon);
					if (open)
						headerIcon.toggleAttribute("data-open", true);
				}
			}
		}

		override public function getWrapperStyle():String
		{
			return 'menu-details';
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			addElementToWrapper(this, 'li');

			detailsElem = document.createElement('details') as HTMLElement;
			element.appendChild(detailsElem);

			headerElem = new Summary();
			headerElem.text = '';
			headerElem.addEventListener("click", toggleSection);
			detailsElem.appendChild(headerElem.element);

			return element;
		}

		COMPILE::JS
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
			detailsElem.appendChild((c as UIBase).element);
			(c as UIBase).addedToParent();
		}
	}
}
