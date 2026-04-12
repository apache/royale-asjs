// //////////////////////////////////////////////////////////////////////////////
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
// //////////////////////////////////////////////////////////////////////////////
package org.apache.royale.style
{
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.Button;
	}
	import org.apache.royale.core.IHasLabel;
	import org.apache.royale.style.elements.Span;
	import org.apache.royale.style.skins.IIconButtonSkin;
	import org.apache.royale.style.stylebeads.IStyleBead;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.skins.TextButtonSkin;

	/**
	 *  A styled Button component that supports style beads and a skin.
	 */
	public class TextButton extends StyleUIBase
	{
		public function TextButton()
		{
			super();
		}

		override protected function getTag():String
		{
			return "button";
		}

		override protected function applySkin():void
		{
			var buttonSkin:TextButtonSkin = skin as TextButtonSkin;
			assert(buttonSkin, "Button requires an ButtonSkin");
			icon = buttonSkin.getIcon();
			if (icon && this.getElementIndex(icon) == -1){
				this.addElementAt(icon, 0);
			}
		}

		private var _labelSpan:Span;

		private function getLabelSpan():void
		{
			if (!_labelSpan)
			{
				_labelSpan = new Span();
				if (icon && this.getElementIndex(icon) != -1)
					this.addElementAt(_labelSpan, 1);
				else
					this.addElement(_labelSpan);
			}
		}

		private var _text:String = "";
		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			COMPILE::JS
			{
				if (_text != value)
				{
					element.innerText = value;
				}
			}
			_text = value;
		}

		private var _disabled:Boolean;
		public function get disabled():Boolean
		{
			return _disabled;
		}

		public function set disabled(value:Boolean):void
		{
			COMPILE::JS
			{
				if (value != !!_disabled)
				{
					toggleAttribute("disabled", value);
					if (icon)
					{
						icon.toggleAttribute("data-disabled", value);
					}
				}
			}
			_disabled = value;
		}
		private var _icon:IStyleUIBase;
		public function get icon():IStyleUIBase
		{
			return _icon;
		}

		public function set icon(value:IStyleUIBase):void
		{
			_icon = value;
		}
	}
}
