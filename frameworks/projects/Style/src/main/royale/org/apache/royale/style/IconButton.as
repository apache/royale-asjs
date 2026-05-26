/////////////////////////////////////////////////////////////////////////////////
// 
// Licensed to the Apache Software Foundation (ASF) under one or more
// contributor license agreements.  See the NOTICE file distributed with
// this work for additional information regarding copyright ownership.
// The ASF licenses this file to You under the Apache License, Version 2.0
// (the "License"); you may not use this file except in compliance with
// the License.  You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// 
/////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.style
{
	import org.apache.royale.style.support.NodeElementBase;

	/**
	 *  A styled Button component that contains only an icon.
	 *  Does not support text.
	 */
	public class IconButton extends NodeElementBase
	{
		public function IconButton()
		{
			super();
		}

		override protected function applySkin():void
		{
			// keep existing icon.
			if (icon && getElementIndex(icon) != -1)
				return;

			if (icon && this.getElementIndex(icon) == -1)
			{
				this.addElementAt(icon, 0);
			}
		}
		COMPILE::SWF
		private var _disabled:Boolean;
		COMPILE::JS
		private function get button():HTMLButtonElement
		{
			return element as HTMLButtonElement;
		}
		/**
		 * Whether the button is disabled
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get disabled():Boolean
		{
			COMPILE::SWF
			{
				return _disabled;
			}

			COMPILE::JS
			{
				return button.disabled;
			}
		}
		public function set disabled(value:Boolean):void
		{
			COMPILE::SWF
			{
				_disabled = value;
			}
			COMPILE::JS
			{
				button.disabled = value;
				if (icon)
					icon.toggleAttribute("data-disabled", value);
			}
		}


		private var _icon:IIcon;
		/**
		 * The icon to display in the button. Should be an icon that can be styled with CSS.
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
		public function get icon():IIcon
		{
			return _icon;
		}

		public function set icon(value:IIcon):void
		{
			_icon = value;
			if(disabled)
				_icon.toggleAttribute("data-disabled", true);
			if(selected)
				_icon.toggleAttribute("data-selected", true);
		}
		override protected function getTag():String
		{
			return "button";
		}

		private var _selected:Boolean;
		/**
		 * Whether the button is selected.
		 * This is a separate state from "disabled" and can be used to indicate an active or toggled state for the button.
		 * @langversion 3.0
		 * @productversion Royale 1.0.0
		 */
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
				if (icon)
					icon.toggleAttribute("data-selected", value);
				COMPILE::JS
				{
					element.setAttribute("aria-selected", value ? "true" : "false");
				}
			}
		}

	}
}
