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
	import org.apache.royale.style.elements.Span;
	import org.apache.royale.style.skins.ITabSkin;

	/**
	 *  Dispatched when the user clicks on the tab.
	 */
	[Event(name="itemClicked", type="org.apache.royale.events.Event")]

	public class Tab extends StyleUIBase
	{

		public function Tab()
		{
			super();
		}

		private var labelSpan:Span;

		override protected function getTag():String
		{
			return "button";
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();
			elem.setAttribute("role", "tab");
			elem.setAttribute("type", "button");
			elem.onclick = elementClicked;

			return elem;
		}

		COMPILE::JS
		private function elementClicked():void
		{
			dispatchEvent(new Event("itemClicked"));
		}

		private var _text:String = "";

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			if(_text != value)
			{
				_text = value;
				if(!labelSpan)
				{
					labelSpan = new Span();
					addElement(labelSpan);
					if(_stylesLoaded)
					{
						applyLabelSkin();
					}
				}
				labelSpan.text = value;
			}
		}

		private var _selected:Boolean;

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			if(value != _selected)
			{
				_selected = value;
				toggleAttribute("data-selected", value);
				COMPILE::JS
				{
					element.setAttribute("aria-selected", value ? "true" : "false");
				}
			}
		}

		private var _disabled:Boolean;

		public function get disabled():Boolean
		{
			return _disabled;
		}

		public function set disabled(value:Boolean):void
		{
			if(value != _disabled)
			{
				_disabled = value;
				toggleAttribute("data-disabled", value);
				COMPILE::JS
				{
					(element as HTMLButtonElement).disabled = value;
				}
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.skins.ITabSkin
		 */
		override protected function applySkin():void
		{
			applyLabelSkin();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.skins.ITabSkin
		 */
		private function applyLabelSkin():void
		{
			if(!labelSpan) return;
			var tabSkin:ITabSkin = skin as ITabSkin;
			labelSpan.setStyles(tabSkin.labelStyles, true);
		}

		override public function getWrapperStyle():String
		{
			return 'tab';
		}
	}
}
