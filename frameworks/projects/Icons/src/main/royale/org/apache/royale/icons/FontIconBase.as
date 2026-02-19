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
package org.apache.royale.icons
{
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
	}
	import org.apache.royale.core.IIcon;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.CSSClassList;

	/**
	 *  FontIconBase is the base class to provide most common features
	 *  for all kinds of text based icons
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class FontIconBase extends UIBase implements IIcon
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function FontIconBase()
		{
			super();
			classList = new CSSClassList();
			typeNames = "";

		}
		protected var classList:CSSClassList;

		COMPILE::JS
		override protected function computeFinalClassNames():String
		{
			return (classList.compute() + super.computeFinalClassNames()).trim();
		}

		protected var _text:String = "";

		/**
		 *  The text of the icon
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.7
		 */
		public function get text():String
		{
			return _text;
		}
		public function set text(value:String):void
		{
			_text = value;
		}

		COMPILE::JS
		protected var textNode:Text;

		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion HTMLElement
		 * @royaleignorecoercion Text
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var i:WrappedHTMLElement = addElementToWrapper(this, 'i');

			textNode = document.createTextNode(iconText) as Text;
			textNode.textContent = '';
			i.appendChild(textNode);

			return element;
		}

		/**
		 *  the icon text that matchs with font icon.
		 *  override in extending classes
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		protected function get iconText():String
		{
			return "";
		}

		private var _size:Number = 24;

		/**
		 *  Activate "size-XX" size class selector. Although the icons in the
		 *  font can be scaled to any size, recommended sizes are 18, 24, 36 or 48px.
		 *
		 *  The default being 24px.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function get size():Number
		{
			return _size;
		}
		public function set size(value:Number):void
		{
			if (_size != value)
			{
				COMPILE::JS
				{
					classList.remove("size-" + _size);
					_size = value;
					classList.add("size-" + _size);
					computeInternal();
				}
			}
		}

		private var _dark:Boolean;

		/**
		 *  Activate "dark" class selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get dark():Boolean
		{
			return _dark;
		}

		public function set dark(value:Boolean):void
		{
			if (_dark != value)
			{
				_dark = value;
				value ? classList.add("dark") : classList.remove("dark");
				computeInternal();
			}
		}

		private var _light:Boolean;

		/**
		 *  Activate "light" class selector.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get light():Boolean
		{
			return _light;
		}
		public function set light(value:Boolean):void
		{
			if (_light != value)
			{
				_light = value;
				value ? classList.add("light") : classList.remove("light");
				computeInternal();
			}
		}

		private var _inactive:Boolean;

		/**
		 *  Activate "inactive" class selector.
		 *  To show the icon as inactive
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function get inactive():Boolean
		{
			return _inactive;
		}
		public function set inactive(value:Boolean):void
		{
			if (_inactive != value)
			{
				_inactive = value;

				value ? classList.add("inactive") : classList.remove("inactive");
				computeInternal();
			}
		}

		/**
		 *  Adds a CSS class name to this icon.
		 *
		 *  @param className The class name to add.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function addClass(className:String):void
		{
			classList.add(className);
			computeInternal();
		}

		/**
		 *  Removes a CSS class name from this icon.
		 *
		 *  @param className The class name to remove.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function removeClass(className:String):void
		{
			classList.remove(className);
			computeInternal();
		}

		/**
		 *  Toggles a CSS class name on this icon.
		 *
		 *  @param className The class name to toggle.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function toggleClass(className:String, value:Boolean):void
		{
			value ? classList.add(className) : classList.remove(className);
			computeInternal();
		}
		private function computeInternal():void
		{
			COMPILE::JS
			{
				setClassName(computeFinalClassNames());
			}
		}

	}
}
