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
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.core.IHasLabel;
	import org.apache.royale.style.elements.Div;
	import org.apache.royale.style.elements.Span;
	import org.apache.royale.style.skins.IToggleSkin;
	import org.apache.royale.style.stylebeads.utils.ScreenReader;

	/**
	 *  Dispatched when the user toggles the switch.
	 */
	[Event(name="change", type="org.apache.royale.events.Event")]

	public class Toggle extends StyleUIBase implements IHasLabel
	{

		public function Toggle()
		{
			super();
		}

		COMPILE::JS
		private var input:HTMLInputElement;

		private var track:Div;

		private var thumb:Div;

		COMPILE::JS
		private function elementClicked():void
		{
			processCheckedChange(input.checked, false);
		}

		override protected function getTag():String
		{
			return "label";
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();
			input = newElement("input") as HTMLInputElement;
			input.type = "checkbox";
			var srOnly:String = new ScreenReader().getSelector();
			input.className = ("peer " + srOnly);
			input.onclick = elementClicked;
			elem.appendChild(input);

			track = new Div();
			addElement(track);

			thumb = new Div();
			track.addElement(thumb);

			return elem;
		}

		private var _label:String = "";

		public function get label():String
		{
			return _label;
		}

		private var span:Span;

		public function set label(value:String):void
		{
			COMPILE::JS
			{
				if(_label != value){
					_label = value;
					if(!span){
						span = new Span();
						addElement(span);
						if(_stylesLoaded)
						{
							applyLabelSkin();
						}
					}
					span.text = value;
					input.setAttribute("aria-label", value);
				}
			}
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.skins.IToggleSkin
		 */
		override protected function applySkin():void
		{
			var toggleSkin:IToggleSkin = skin as IToggleSkin;
			track.setStyles(toggleSkin.trackStyles, true);
			thumb.setStyles(toggleSkin.thumbStyles, true);
			applyLabelSkin();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.style.skins.IToggleSkin
		 */
		private function applyLabelSkin():void
		{
			if(!span) return;
			var toggleSkin:IToggleSkin = skin as IToggleSkin;
			span.setStyles(toggleSkin.labelStyles, true);
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
				if(value != _disabled){
					input.disabled = value;
					toggleAttribute("data-disabled", value);
				}
			}
			_disabled = value;
		}

		private var _checked:Boolean;

		[Bindable(event='valueChange',type='org.apache.royale.events.ValueChangeEvent')]
		public function get checked():Boolean
		{
			return _checked;
		}

		public function set checked(value:Boolean):void
		{
			processCheckedChange(value, true);
		}

		private function processCheckedChange(value:Boolean, programmatic:Boolean):void
		{
			COMPILE::JS
			{
				if(value != _checked){
					_checked = value;
					if (programmatic) input.checked = value;
					toggleAttribute("data-checked", value);
					dispatchEvent(ValueChangeEvent.createUpdateEvent(this, 'checked', !value, value));
				}
			}
		}

		override public function getWrapperStyle():String
		{
			return 'toggle';
		}
	}
}
