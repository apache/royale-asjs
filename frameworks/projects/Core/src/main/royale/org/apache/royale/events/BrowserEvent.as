/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.royale.events
{

    COMPILE::JS {        
        import goog.events.BrowserEvent;
    }

	/**
	 * @fileoverview A patched, standardized event object for browser events.
	 *
	 * <pre>
	 * The patched event object contains the following members:
	 * - type           {string}    Event type, e.g. 'click'
	 * - timestamp      {Date}      A date object for when the event was fired
	 * - target         {Object}    The element that actually triggered the event
	 * - currentTarget  {Object}    The element the listener is attached to
	 * - relatedTarget  {Object}    For mouseover and mouseout, the previous object
	 * - offsetX        {number}    X-coordinate relative to target
	 * - offsetY        {number}    Y-coordinate relative to target
	 * - clientX        {number}    X-coordinate relative to viewport
	 * - clientY        {number}    Y-coordinate relative to viewport
	 * - screenX        {number}    X-coordinate relative to the edge of the screen
	 * - screenY        {number}    Y-coordinate relative to the edge of the screen
	 * - button         {number}    Mouse button. Use isButton() to test.
	 * - keyCode        {number}    Key-code
	 * - ctrlKey        {boolean}   Was ctrl key depressed
	 * - altKey         {boolean}   Was alt key depressed
	 * - shiftKey       {boolean}   Was shift key depressed
	 * - metaKey        {boolean}   Was meta key depressed
	 * - defaultPrevented {boolean} Whether the default action has been prevented
	 * - state          {Object}    History state object
	 *
	 * NOTE: The keyCode member contains the raw browser keyCode. For normalized
	 * key and character code use {@link goog.events.KeyHandler}.
	 * </pre>
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.0
	 */
	COMPILE::JS
	public class BrowserEvent implements IBrowserEvent
	{

		//--------------------------------------
		//   Property
		//--------------------------------------

		/**
		 	* @type {Event}
      * @royalesuppresspublicvarwarning
		 */
        COMPILE::JS
		public var nativeEvent:Object;


		/**
		 * @type {?goog.events.BrowserEvent}
		 */
		private var wrappedEvent:Object;

		public function wrapEvent(event:goog.events.BrowserEvent):void
		{
			wrappedEvent = event;
			nativeEvent = event.getBrowserEvent();
		}
		//--------------------------------------
		//   Function
		//--------------------------------------

		/**
		 * Was altKey key depressed.
		 * @type {boolean}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get altKey():Boolean
		{
			return wrappedEvent.altKey;
		}

		/**
		 * Which mouse button was pressed.
		 * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get button():uint
		{
			return wrappedEvent.button;
		}

		/**
		 * CharCode of key press.
		 * Native browser event.charCode || (type == 'keypress' ? event.keyCode : 0);
		 * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get charCode():uint
		{
			return wrappedEvent.charCode;
		}

		/**
		 * X-coordinate relative to the window.
		 * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get clientX():Number
		{
			return wrappedEvent.clientX;
		}

		public function get localX():Number
		{
			return clientX;
		}

		/**
		 * Y-coordinate relative to the window.
		 * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get clientY():Number
		{
			return wrappedEvent.clientY;
		}

		public function get localY():Number
		{
			return clientY;
		}
		/**
		 * Was ctrl key depressed.
		 * @type {boolean}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get ctrlKey():Boolean
		{
			return wrappedEvent.ctrlKey;
		}

		/**
		 * The element the listener is attached to.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get currentTarget():Object
		{
			return getTargetWrapper(wrappedEvent.currentTarget);
		}

		/**
		 * Whether the default action has been prevented.
		 * @type {boolean}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get defaultPrevented():Boolean
		{
			return wrappedEvent.defaultPrevented;
		}

		/**
		 * The underlying browser event object.
		 * (for debugging purposes)
		 *
		 * @return The underlying browser event object.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function getBrowserEvent():Object
		{
			return wrappedEvent.getBrowserEvent();
		}

		/**
		 * Tests to see which button was pressed during the event. This is really only
		 * useful in IE and Gecko browsers. And in IE, it's only useful for
		 * mousedown/mouseup events, because click only fires for the left mouse button.
		 *
		 * Safari 2 only reports the left button being clicked, and uses the value '1'
		 * instead of 0. Opera only reports a mousedown event for the middle button, and
		 * no mouse events for the right button. Opera has default behavior for left and
		 * middle click that can only be overridden via a configuration setting.
		 *
		 * There's a nice table of this mess at http://www.unixpapa.com/js/mouse.html.
		 *
		 * @param button The button to test for.
		 * @return True if button was pressed.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function isButton(button:int):Boolean
		{
			return wrappedEvent.isButton(button);
		}

		/**
		 * Whether this has an "action"-producing mouse button.
		 *
		 * By definition, this includes left-click on windows/linux, and left-click
		 * without the ctrl key on Macs.
		 *
		 * @return The result.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function isMouseActionButton():Boolean
		{
			return wrappedEvent.isMouseActionButton();
		}

		/**
		 * Keycode of key press.
		 * Native browser event.keyCode || 0;
		 * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get keyCode():uint
		{
			return wrappedEvent.keyCode;
		}

		/**
		 * Whether the meta key was pressed at time of event.
		 * @type {boolean}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get metaKey():Boolean
		{
			return wrappedEvent.metaKey;
		}

		/**
		 * X-coordinate relative to target.
		 * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get offsetX():Number
		{
			return wrappedEvent.offsetX;
		}

		/**
		 * Y-coordinate relative to target.
		 * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get offsetY():Number
		{
			return wrappedEvent.offsetY;
		}

		/**
		 * Whether the default platform modifier key was pressed at time of event.
		 * (This is control for all platforms except Mac, where it's Meta.)
		 * @type {boolean}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get platformModifierKey():Boolean
		{
			return platformModifierKey;
		}

		/**
		 * Whether the default action has been prevented.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function preventDefault():void
		{
			wrappedEvent.preventDefault();
		}

		/**
		 * For mouseover and mouseout, the previous object.
		 * @type {object}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get relatedTarget():Object
		{
			return getTargetWrapper(wrappedEvent.relatedTarget);
		}

		/**
		 * X-coordinate relative to the monitor.
		 * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get screenX():Number
		{
			return wrappedEvent.screenX;
		}

		/**
		 * Y-coordinate relative to the monitor.
		 * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get screenY():Number
		{
			return wrappedEvent.screenY;
		}

		/**
		 * Was shiftKey key depressed.
		 * @type {boolean}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get shiftKey():Boolean
		{
			return wrappedEvent.shiftKey;
		}

		/**
		 * History state object, only set for PopState events where it's a copy of the
		 * state object provided to pushState or replaceState.
		 * @type {Object}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get state():Object
		{
			return wrappedEvent.state;
		}

        /**
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
         */
		public function stopImmediatePropagation():void
		{
			wrappedEvent.getBrowserEvent().stopImmediatePropagation(); // not in goog.events.BrowserEvent
			wrappedEvent.stopPropagation();
		}

        /**
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
         */
		public function stopPropagation():void
		{
			wrappedEvent.stopPropagation();
		}

		/**
		 * The element that actually triggered the event.
		 * @type {object}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get target():Object
		{
			return getTargetWrapper(wrappedEvent.target);
		}

		/**
		 * A date object for when the event was fired.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get timestamp():Date
		{
			return wrappedEvent.timestamp;
		}

		/**
		 * Event type, e.g. 'click'.
		 * @type {string}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
		public function get type():String
		{
			return wrappedEvent.type;
		}

		private var _buttons:int = -1;
		public function get buttonDown():Boolean
		{
			if(_buttons > -1)
				return _buttons == 1;
			var ev:* = wrappedEvent.getBrowserEvent();
			//Safari does not yet support buttons
			if ('buttons' in ev)
				return ev["buttons"] == 1;
			return ev["which"] == 1;
		}
		public function set buttonDown(value:Boolean):void
		{
			_buttons = value ? 1 : 0;
		}

		public function get buttons():int
		{
			return wrappedEvent.getBrowserEvent().buttons;
		}
	}
}
