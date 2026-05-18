// ///////////////////////////////////////////////////////////////////////////////
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
// ///////////////////////////////////////////////////////////////////////////////
package org.apache.royale.style
{
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	import org.apache.royale.style.support.NodeElementBase;

	/**
	 *  A styled Button component that contains only text.
	 *  Does not support icons.
	 */
	public class TextButton extends NodeElementBase
	{
		public function TextButton()
		{
			super();
		}

		COMPILE::JS
		protected var textNode:Text;
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			var elem:WrappedHTMLElement = super.createElement();
			textNode = document.createTextNode('') as Text;
			elem.appendChild(textNode);
			return elem;
		}

		COMPILE::JS
		private function get button():HTMLButtonElement
		{
			return element as HTMLButtonElement;
		}

		COMPILE::SWF
		private var _disabled:Boolean;

		/**
		 *  Whether the button is disabled
		 *
		 *  @langversion 3.0
		 *  @productversion Royale 1.0.0
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
					textNode.nodeValue = value;
				
			}
			_text = value;
		}
		override protected function getTag():String
		{
			return "button";
		}
	}
}
