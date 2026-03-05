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
package org.apache.royale.style.elements
{
	import org.apache.royale.style.elements.Iframe;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.ValueEvent;

	[Event(name="message", type="org.apache.royale.events.ValueEvent")]
	[Event(name="iframeLoad", type="org.apache.royale.events.Event")]
	[Event(name="iframeError", type="org.apache.royale.events.Event")]

	/**
	 *  Enhanced version of the Iframe base component, with additional security support for message filtering
	 *
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.13
	 */
	public class SecurityIframe extends Iframe
	{
		public function SecurityIframe()
		{
			super();
		}

		private var _checkExpectedOrigin:Boolean = true;

		/**
		 * This is true by default. Setting it to false will also allow message handling from
		 * potential opaque origins ("" or 'null' origins)  which is NOT considered secure
		 * @param value
		 */
		public function set checkExpectedOrigin(value:Boolean):void
		{
			_checkExpectedOrigin = value;
		}
		public function get checkExpectedOrigin():Boolean
		{
			return _checkExpectedOrigin;
		}

		COMPILE::JS
		private static function isDescendantWindow(source:Window, root:Window):Boolean
		{
			var w:Window = source;

			// Walk up the parent chain until we reach the top window
			while (w && w !== w.parent)
			{
				if (w === root)
					return true;
				w = w.parent as Window;
			}

			return false;
		}

		private var _allowNestedFrames:Boolean = false;

		/**
		 * whether or not to filter messaging from deeper nested iframes
		 * @param value true if messaging from nested iframes is supported. false by default
		 */
		public function set allowNestedFrames(value:Boolean):void
		{
			_allowNestedFrames = value;
		}
		public function get allowNestedFrames():Boolean
		{
			return _allowNestedFrames;
		}

		private var _srcSet:Boolean;
		override public function set src(value:String):void
		{
			COMPILE::JS
			{
				if (!_srcSet)
				{
					(element as HTMLIFrameElement).addEventListener('load', onStatus);
					(element as HTMLIFrameElement).addEventListener('error', onStatus);
				}
				try
				{
					expectedOrigin = new URL(value, window.location.href).origin;
				}
				catch (e:Error)
				{
					expectedOrigin = null;
				}

				if ((_listeners.length || hasEventListener('message')) && expectedOrigin)
				{
					activateMessaging(true);
				}
			}
			_srcSet = true;
			super.src = value;

		}

		COMPILE::JS
		private var _listeners:Array = [];

		/* the royale version needs fixing... this might be a candidate */
		override public function addMessageListener(handler:(e:MessageEvent)=>void):void
		{
			COMPILE::JS
			{
				var idx:int = _listeners.indexOf(handler);
				if (idx == -1)
					_listeners.push(handler);
				if (expectedOrigin)
					activateMessaging(true);
			}
		}

		public function removeMessageListener(handler:(e:MessageEvent)=>void):void
		{
			COMPILE::JS
			{
				var idx:int = _listeners.indexOf(handler);
				if (idx != -1)
					_listeners.splice(idx, 1);
				if (!_listeners.length)
				{
					activateMessaging(false);
				}
			}
		}

		COMPILE::JS

		private function onStatus(e:Object):void
		{
			var localEventType:String = 'iframe' + e.type.charAt(0).toUpperCase() + e.type.substr(1);
			dispatchEvent(new Event(localEventType));
		}

		COMPILE::JS

		private var expectedOrigin:String;

		COMPILE::JS

		private var messagingActive:Boolean;
		COMPILE::JS

		private function activateMessaging(on:Boolean):void
		{
			if (on)
			{
				if (!messagingActive)
				{
					window.addEventListener('message', filterMessaging);
					messagingActive = true;
				}
			}
			else
			{
				if (messagingActive)
				{
					window.removeEventListener('message', filterMessaging);
					messagingActive = false;
				}
			}
		}

		private var _messageShapeChecker:(dataObject:Object)=>Boolean;

		/**
		 * extra optional check to make sure the data received conforms to some expectations
		 * for example, check if a namespace field matches expectations, or data appears to be a certain 'shape'
		 * @param checker the function which should examine the data object and return true if it conforms to expectations
		 */
		public function setMessageValidationCheck(checker:(dataObject:Object)=>Boolean):void
		{
			_messageShapeChecker = checker;
		}

		COMPILE::JS

		private function filterMessaging(e:MessageEvent):void
		{
			// opaque origins (cases including "" and "null" origin) will always be excluded unless  checkExpectedOrigin is false
			if (checkExpectedOrigin)
			{
				if (!e.origin || e.origin === "null")
					return;
				if (e.origin != expectedOrigin)
					return;
			}

			if (!allowNestedFrames)
			{
				// default: only accept messages from the iframe itself
				if (e.source != contentWindow)
					return;
			}
			else
			{
				// accept messages also from nested iframes
				if (!isDescendantWindow(e.source as Window, contentWindow as Window))
					return;
			}

			// extra optional check to make sure the data received conforms to some expectations
			if (_messageShapeChecker && !_messageShapeChecker(e.data))
				return;

			for each (var _listener:(e:MessageEvent)=>void in _listeners)
			{
				_listener(e);
			}
			if (hasEventListener('message'))
			{
				// send the native MessageEvent via a ValueEvent
				dispatchEvent(new ValueEvent('message', e));

			}
		}

		COMPILE::JS

		override public function addEventListener(type:String, handler:Function, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
		{
			if (type == 'message' && expectedOrigin || !_checkExpectedOrigin)
			{
				activateMessaging(true);

			}
			super.addEventListener(type, handler, opt_capture, opt_handlerScope);
		}

	}
}
