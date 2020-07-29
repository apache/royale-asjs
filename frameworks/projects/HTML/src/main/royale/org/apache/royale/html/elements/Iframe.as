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
package org.apache.royale.html.elements
{
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
	}

	import org.apache.royale.html.NodeElementBase;

	/**
	 *  The Iframe class represents an HTML <iframe> element
	 * https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.8
	 */
	public class Iframe extends NodeElementBase
	{
		public function Iframe()
		{
			super();
		}
		/**
		 * Specifies the feature policy for the iframe
		 * https://developer.mozilla.org/en-US/docs/Web/HTTP/Feature_Policy
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get allow():String
		{
			return getAttribute("allow");
		}

		public function set allow(value:String):void
		{
			setAttribute("allow",value);
		}
		/**
		 * Specifies the Content Security Policy for the iframe
		 * https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get csp():String
		{
			return getAttribute("csp");
		}

		public function set csp(value:String):void
		{
			setAttribute("csp",value);
		}

		/**
		 * The download priority of the resource in the <iframe>'s src attribute.
		 * Allowed values:
		 * auto (default)
		 *    No preference. The browser uses its own heuristics to decide the priority of the resource.
		 * high
		 *    The resource should be downloaded before other lower-priority page resources.
		 * low
		 *    The resource should be downloaded after other higher-priority page resources. 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get importance():String
		{
			return getAttribute("importance");
		}

    [Inspectable(category="General", enumeration="auto,high,low", defaultValue="auto")]
		public function set importance(value:String):void
		{
			setAttribute("importance",value);
		}

		/**
		 * Indicates how the browser should load the iframe:
		 * eager: Load the iframe immediately, regardless if it is outside the visible viewport (this is the default value).
		 * lazy: Defer loading of the iframe until it reaches a calculated distance from the viewport, as defined by the browser.

		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get loading():String
		{
			return getAttribute("loading");
		}

    [Inspectable(category="General", enumeration="eager,lazy")]
		public function set loading(value:String):void
		{
			setAttribute("loading",value);
		}
		
		/**
		 * A targetable name for the embedded browsing context.
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		COMPILE::JS
		public function get name():String
		{
			return iframe.name;
		}
		COMPILE::JS
		public function set name(value:String):void
		{
			iframe.name = value;
		}

		COMPILE::SWF
		override public function get name():String
		{
			return super.name;
		}
		COMPILE::SWF
		override public function set name(value:String):void
		{
			super.name = value;
		}

		/**
		 * Indicates which referrer to send when fetching the frame's resource
		 * https://developer.mozilla.org/en-US/docs/Web/API/HTMLIFrameElement/referrerPolicy
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get referrerpolicy():String
		{
			return getAttribute("referrerpolicy");
		}

    [Inspectable(category="General", enumeration="no-referrer,no-referrer-when-downgrade,origin,origin-when-cross-origin,same-origin,strict-origin,strict-origin-when-cross-origin,unsafe-url", defaultValue="no-referrer-when-downgrade")]
		public function set referrerpolicy(value:String):void
		{
			setAttribute("referrerpolicy",value);
		}
		COMPILE::SWF
		private var _sandbox:String;
		/**
		 * Applies extra restrictions to the content in the frame. The value of the attribute can either be
		 * empty to apply all restrictions, or space-separated tokens to lift particular restrictions:
		 * https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#attr-sandbox
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get sandbox():String
		{
			COMPILE::SWF
			{
				return _sandbox;
			}

			COMPILE::JS
			{
				return iframe.sandbox;
			}
		}

    [Inspectable(category="General", enumeration="allow-downloads-without-user-activation,allow-downloads,allow-forms,allow-modals,allow-orientation-lock,allow-pointer-lock,allow-popups,allow-popups-to-escape-sandbox,allow-presentation,allow-same-origin,allow-scripts,allow-storage-access-by-user-activation,allow-top-navigation,allow-top-navigation-by-user-activation")]
		public function set sandbox(value:String):void
		{
			COMPILE::SWF
			{
				_sandbox = value;
			}

			COMPILE::JS
			{
				iframe.sandbox = value;
			}
		}
		COMPILE::SWF
		private var _src:String;
		/**
		 * The URL of the page to embed.
		 * https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe#attr-src
		 * https://developer.mozilla.org/en-US/docs/Web/HTTP/Feature_Policy
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 */
		public function get src():String
		{
			COMPILE::SWF
			{
				return _src;
			}

			COMPILE::JS
			{
				return iframe.src;
			}
		}

		public function set src(value:String):void
		{
			COMPILE::SWF
			{
				_src = value;
			}

			COMPILE::JS
			{
				iframe.src = value;
			}
		}

		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			return addElementToWrapper(this,'iframe');
		}
		/**
		 * @royaleignorecoercion HTMLIFrameElement
		 */
		COMPILE::JS
		private function get iframe():HTMLIFrameElement
		{
			return element as HTMLIFrameElement;
		}
	}
}