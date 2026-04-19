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
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.skins.LinkSkin;

	/**
	 * Styled anchor element with LinkSkin defaults.
	 */
	public class Link extends StyleUIBase
	{
		public function Link()
		{
			super();
		}

		override protected function getTag():String
		{
			return "a";
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

		private var _href:String = "";
		public function get href():String
		{
			return _href;
		}

		public function set href(value:String):void
		{
			_href = value;
			COMPILE::JS
			{
				if (!_disabled)
				{
					if (_href)
						element.setAttribute("href", _href);
					else
						element.removeAttribute("href");
				}
			}
		}

		// private var _target:String = "_self";
		// public function get target():String
		// {
		// 	return _target;
		// }

		// public function set target(value:String):void
		// {
		// 	_target = value;
		// 	setAttribute("target", value);
		// }

		// private var _download:String = "";
		// public function get download():String
		// {
		// 	return _download;
		// }

		// public function set download(value:String):void
		// {
		// 	_download = value;
		// 	setAttribute("download", value);
		// }

		// private var _rel:String = "";
		// public function get rel():String
		// {
		// 	return _rel;
		// }

		// public function set rel(value:String):void
		// {
		// 	_rel = value;
		// 	setAttribute("rel", value);
		// }

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
					toggleAttribute("data-disabled", value);
					toggleAttribute("aria-disabled", value);
					if (value)
					{
						element.removeAttribute("href");
						element.setAttribute("tabindex", "-1");
					}
					else
					{
						element.removeAttribute("tabindex");
						if (_href)
							element.setAttribute("href", _href);
					}
				}
			}
			_disabled = value;
		}
	}
}
