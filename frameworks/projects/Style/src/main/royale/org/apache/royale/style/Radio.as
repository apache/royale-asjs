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
	import org.apache.royale.style.skins.IRadioSkin;
	import org.apache.royale.style.elements.Div;
	import org.apache.royale.events.Event;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.stylebeads.utils.ScreenReader;

	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.style.elements.Span;
	}

	/**
	 *  Dispatched when the user checks or un-checks the CheckBox.
	 *
	 */
	[Event(name="change", type="org.apache.royale.events.Event")]

	public class Radio extends StyleUIBase
	{
		public function Radio()
		{
			super();
		}	
		COMPILE::JS
		{
			private var input:HTMLInputElement;
			private var box:Span;
			private var dot:Span;
		}

		COMPILE::JS
		override protected function getTag():String
		{
			return "label";
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();
			input = newElement("input") as HTMLInputElement;
			input.type = "radio";
			input.className = "peer " + new ScreenReader().getSelector();
			// class="peer sr-only"
			input.checked = _checked;
			input.disabled = _disabled;
			if (_name)
				input.name = _name;
			input.onchange = elementChanged;
			elem.appendChild(input);
			box = new Span();
			addElement(box);
			dot = new Span();
			addElement(dot);
			return elem;
		}

		COMPILE::JS
		override protected function applySkin():void
		{
			var radioSkin:IRadioSkin = skin as IRadioSkin;
			assert(radioSkin, "Radio requires a skin that implements IRadioSkin");
			box.setStyles(radioSkin.boxStyles || [], true);
			dot.setStyles(radioSkin.dotStyles || [], true);
		}

		private var _checked:Boolean;
		public function get checked():Boolean
		{
			return _checked;
		}
		COMPILE::JS
		public function set checked(value:Boolean):void
		{
			if (input)
				input.checked = value;
			toggleAttribute("checked", value);
			_checked = value;
		}
		COMPILE::JS

		private function elementChanged(event:Event = null):void
		{
			_checked = input.checked;
			dispatchEvent(new Event("change"));
		}
		private var _disabled:Boolean;
		public function get disabled():Boolean
		{
			return _disabled;
		}

		COMPILE::JS

		public function set disabled(value:Boolean):void
		{
			if (input)
				input.disabled = value;
			toggleAttribute("disabled", value);
			_disabled = value;
		}

		private var _name:String;

		COMPILE::JS

		public function get name():String
		{
			return _name;
		}

		COMPILE::JS

		public function set name(value:String):void
		{
			_name = value;
			if (input)
				input.name = value;
		}

	}

}