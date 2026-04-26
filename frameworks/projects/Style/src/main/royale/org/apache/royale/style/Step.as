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
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.skins.IStepSkin;
	import org.apache.royale.style.elements.Div;
	import org.apache.royale.style.elements.Span;

	public class Step extends StyleUIBase
	{
		public function Step()
		{
			super();
		}

		// Step is a purely visual element with no user interaction,
		// so it doesn't need MVC view or controller beads.
		override protected function requiresView():Boolean
		{
			return false;
		}

		override protected function requiresController():Boolean
		{
			return false;
		}

		private var _text:String = "";

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			if (_text != value)
			{
				_text = value;
				COMPILE::JS
				{
					if (_labelElem)
						_labelElem.element.textContent = value;
				}
			}
		}

		private var _content:String = "";

		/**
		 * Custom content to display inside the circle.
		 * If empty, the circle shows the step number.
		 */
		public function get content():String
		{
			return _content;
		}

		public function set content(value:String):void
		{
			if (_content != value)
			{
				_content = value;
				COMPILE::JS
				{
					if (_circleElem)
						_circleElem.element.textContent = value;
				}
			}
		}

		private var _vertical:Boolean = false;

		public function get vertical():Boolean
		{
			return _vertical;
		}

		public function set vertical(value:Boolean):void
		{
			if (_vertical != value)
			{
				_vertical = value;
				if (skin)
				{
					skin.update();
					applySkin();
				}
			}
		}

		private var _completed:Boolean = false;

		public function get completed():Boolean
		{
			return _completed;
		}

		public function set completed(value:Boolean):void
		{
			if (_completed != value)
			{
				_completed = value;
				toggleAttribute("data-completed", value);
				COMPILE::JS
				{
					if (_connectorRow)
					{
						setElementDataCompleted(_connectorRow.element, value);
						setElementDataCompleted(_beforeLine.element, value);
						setElementDataCompleted(_circleElem.element, value);
						setElementDataCompleted(_afterLine.element, value);
						setElementDataCompleted(_labelElem.element, value);
					}
				}
			}
		}

		COMPILE::JS
		private function setElementDataCompleted(el:Object, value:Boolean):void
		{
			if (value)
				el.setAttribute("data-completed", "");
			else
				el.removeAttribute("data-completed");
		}

		COMPILE::JS
		private var _connectorRow:Div;

		COMPILE::JS
		private var _beforeLine:Span;

		COMPILE::JS
		private var _circleElem:Span;

		COMPILE::JS
		private var _afterLine:Span;

		COMPILE::JS
		private var _labelElem:Span;

		COMPILE::JS
		public function get connectorRow():Div
		{
			return _connectorRow;
		}

		COMPILE::JS
		public function get beforeLine():Span
		{
			return _beforeLine;
		}

		COMPILE::JS
		public function get circleElem():Span
		{
			return _circleElem;
		}

		COMPILE::JS
		public function get afterLine():Span
		{
			return _afterLine;
		}

		COMPILE::JS
		public function get labelElem():Span
		{
			return _labelElem;
		}

		override protected function getTag():String
		{
			return "li";
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			addElementToWrapper(this, 'li');

			_connectorRow = new Div();
			element.appendChild(_connectorRow.element);

			_beforeLine = new Span();
			_connectorRow.element.appendChild(_beforeLine.element);

			_circleElem = new Span();
			_circleElem.element.textContent = _content;
			_connectorRow.element.appendChild(_circleElem.element);

			_afterLine = new Span();
			_connectorRow.element.appendChild(_afterLine.element);

			_labelElem = new Span();
			_labelElem.element.textContent = _text;
			element.appendChild(_labelElem.element);

			if (_completed)
			{
				setElementDataCompleted(_connectorRow.element, true);
				setElementDataCompleted(_beforeLine.element, true);
				setElementDataCompleted(_circleElem.element, true);
				setElementDataCompleted(_afterLine.element, true);
				setElementDataCompleted(_labelElem.element, true);
			}

			return element;
		}

		override protected function applySkin():void
		{
			var stepSkin:IStepSkin = skin as IStepSkin;
			assert(stepSkin, "Step requires a skin that implements IStepSkin");
			COMPILE::JS
			{
				_connectorRow.setStyles(stepSkin.connectorStyles, true);
				_circleElem.setStyles(stepSkin.circleStyles, true);
				_beforeLine.setStyles(stepSkin.beforeLineStyles, true);
				_afterLine.setStyles(stepSkin.afterLineStyles, true);
				_labelElem.setStyles(stepSkin.labelStyles, true);
			}
		}

		override public function getWrapperStyle():String
		{
			return 'step';
		}
	}
}
