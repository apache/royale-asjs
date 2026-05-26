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
	}

	import org.apache.royale.debugging.assert;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ValueChangeEvent;
	import org.apache.royale.style.elements.Div;
	import org.apache.royale.style.elements.Input;
	import org.apache.royale.style.skins.IRangeSkin;

	[Event(name="change", type="org.apache.royale.events.Event")]
	public class Range extends StyleUIBase
	{
		public function Range()
		{
			super();
		}

		private var track:Div;
		private var fill:Div;
		private var handle:Div;
		private var empty:Div;
		private var rangeInput:Input;
		private var _min:Number = 0;
		private var _max:Number = 100;
		private var _value:Number = 0;
		private var _step:Number = 1;
		private var _disabled:Boolean;

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();
			track = new Div();
			addElement(track);
			fill = new Div();
			track.addElement(fill);
			handle = new Div();
			track.addElement(handle);
			empty = new Div();
			track.addElement(empty);
			rangeInput = new Input();
			rangeInput.type = "range";
			track.addElement(rangeInput);
			COMPILE::JS
			{
				var nativeInput:HTMLInputElement = rangeInput.element as HTMLInputElement;
				nativeInput.oninput = inputChanged;
				nativeInput.onchange = inputChanged;
			}
			updateStyles();
			return elem;
		}
		override protected function applySkin():void
		{
			var rangeSkin:IRangeSkin = skin as IRangeSkin;
			assert(rangeSkin, "Range requires a skin that implements IRangeSkin");
			track.setStyles(rangeSkin.trackStyles, true);
			fill.setStyles(rangeSkin.fillStyles, true);
			handle.setStyles(rangeSkin.handleStyles, true);
			empty.setStyles(rangeSkin.emptyStyles, true);
			rangeInput.setStyles(rangeSkin.inputStyles, true);
		}

		private function inputChanged(event:Event):void
		{
			var oldValue:Number = _value;
			value = readInputValue();
			updateStyles();
			if(oldValue != _value)
				dispatchEvent(ValueChangeEvent.createUpdateEvent(this, "value", oldValue, _value));
			dispatchEvent(new Event("change"));
		}

		private function readInputValue():Number
		{
			if(!rangeInput)
				return _value;
			var nextValue:Number = parseFloat(rangeInput.value);
			return isNaN(nextValue) ? _value : nextValue;
		}

		private function getFillPercent():Number
		{
			var minValue:Number = _min;
			var maxValue:Number = _max;
			var range:Number = maxValue - minValue;
			if(range <= 0)
				return 0;
			var percent:Number = ((_value - minValue) / range) * 100;
			if(percent < 0)
				return 0;
			if(percent > 100)
				return 100;
			return percent;
		}

		private function updateStyles():void
		{
			if(!fill || !empty)
				return;
			var fillPercent:Number = getFillPercent();
			fill.setStyle("width", fillPercent + "%");
			empty.setStyle("width", (100 - fillPercent) + "%");
		}

		[Bindable(event='valueChange', type='org.apache.royale.events.ValueChangeEvent')]
		public function get value():Number
		{
			return _value;
		}

		public function set value(v:Number):void
		{
			if(isNaN(v))
				return;
			var oldValue:Number = _value;
			_value = v;
			if(rangeInput)
				rangeInput.value = v.toString();
			updateStyles();
			if(oldValue != _value)
				dispatchEvent(ValueChangeEvent.createUpdateEvent(this, "value", oldValue, _value));
		}

		public function get min():Number
		{
			return _min;
		}

		public function set min(v:Number):void
		{
			if(isNaN(v))
				return;
			_min = v;
			if(rangeInput)
				rangeInput.setAttribute("min", v.toString());
			updateStyles();
		}

		public function get max():Number
		{
			return _max;
		}

		public function set max(v:Number):void
		{
			if(isNaN(v))
				return;
			_max = v;
			if(rangeInput)
				rangeInput.setAttribute("max", v.toString());
			updateStyles();
		}

		public function get step():Number
		{
			return _step;
		}

		public function set step(v:Number):void
		{
			if(isNaN(v) || v <= 0)
				return;
			_step = v;
			if(rangeInput)
				rangeInput.setAttribute("step", v.toString());
		}

		public function get disabled():Boolean
		{
			return _disabled;
		}

		public function set disabled(value:Boolean):void
		{
			_disabled = value;
			toggleAttribute("data-disabled", value);
			if(rangeInput)
				rangeInput.disabled = value;
		}

		override public function getWrapperStyle():String
		{
			return "range";
		}
	}
}
