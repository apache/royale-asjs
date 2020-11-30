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
package org.apache.royale.events
{
    COMPILE::JS
    {
    import goog.events.BrowserEvent;
    import org.apache.royale.core.ElementWrapper;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.utils.KeyboardEventConverter;
    }
    import org.apache.royale.events.IBrowserEvent;

    /**
     *  Keyboard events
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
     */
    public class KeyboardEvent extends Event implements IBrowserEvent
    {
        COMPILE::SWF
        public static const KEY_DOWN:String = "keyDown";
        COMPILE::SWF
        public static const KEY_UP:String = "keyUp";

        COMPILE::JS
        public static const KEY_DOWN:String = "keydown";
        COMPILE::JS
        public static const KEY_UP:String = "keyup";

        public static const KEYCODE_UP:uint = 38;
        public static const KEYCODE_DOWN:uint = 40;
        public static const KEYCODE_LEFT:uint = 37;
        public static const KEYCODE_RIGHT:uint = 39;
        public static const KEYCODE_PAGEUP:uint = 33;
        public static const KEYCODE_PAGEDOWN:uint = 34;
        public static const KEYCODE_HOME:uint = 36;
        public static const KEYCODE_END:uint = 35;
        
		/**
		 * @type {?goog.events.BrowserEvent}
		 */
        COMPILE::JS
		private var wrappedEvent:Object;

		/**
		 * @type {KeyboardEvent}
         * @royalesuppresspublicvarwarning
		 */
        COMPILE::JS
		public var nativeEvent:Object;

        COMPILE::JS
		public function wrapEvent(event:goog.events.BrowserEvent):void
        {
            wrappedEvent = event;
            nativeEvent = event.getBrowserEvent();
        }

        public function KeyboardEvent(
            type:String,
            key:String,
            code:String,
            shiftKey:Boolean=false,
            altKey:Boolean=false,
            ctrlKey:Boolean=false,
            metaKey:Boolean=false,
            bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles = false, cancelable);
            _key = key;
            _code = code;
            _shiftKey = shiftKey;
            _altKey = altKey;
            _ctrlKey = ctrlKey;
            _metaKey = metaKey;
        }
        COMPILE::JS
        private var _target:Object;
		/**
         *  @copy org.apache.royale.events.BrowserEvent#target
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9
		 */
        COMPILE::JS
        override public function get target():Object
		{
			return wrappedEvent ? getTargetWrapper(wrappedEvent.target) : _target;
		}

        COMPILE::JS
        override public function set target(value:Object):void
		{
			_target = value;
		}

		/**
         *  @copy org.apache.royale.events.BrowserEvent#currentTarget
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9
		 */
        COMPILE::JS
        override public function get currentTarget():Object
		{
			return wrappedEvent ? getTargetWrapper(wrappedEvent.currentTarget) : _target;
		}

        COMPILE::JS
        override public function set currentTarget(value:Object):void
		{
			_target = value;
		}

        private var _key:String;
        public function get key():String
        {
            return _key;
        }
        public function set key(value:String):void
        {
            _key = value;
        }
        
        private var _code:String;
        public function get code():String
        {
            return _code;
        }
        public function set code(value:String):void
        {
            _code = value;
        }

        private var _altKey:Boolean;

        COMPILE::SWF
        public function get altKey():Boolean
        {
            return _altKey;
        }
        
        COMPILE::JS
        public function get altKey():Boolean
        {
        	return wrappedEvent ? wrappedEvent.altKey : _altKey;
        }
        COMPILE::SWF
        public function set altKey(value:Boolean):void
        {
            _altKey = value;
        }

        COMPILE::JS
        public function set altKey(value:Boolean):void
        {
            if(wrappedEvent)wrappedEvent.altKey = value;
            else _altKey = value;
        }

        private var _ctrlKey:Boolean;
        
        COMPILE::SWF
        public function get ctrlKey():Boolean
        {
            return _ctrlKey;
        }

        COMPILE::JS
        public function get ctrlKey():Boolean
        {
        	return wrappedEvent ? wrappedEvent.ctrlKey : _ctrlKey;
        }

        COMPILE::SWF
        public function set ctrlKey(value:Boolean):void
        {
            _ctrlKey = value;
        }

        COMPILE::JS
        public function set ctrlKey(value:Boolean):void
        {
            if(wrappedEvent)
                wrappedEvent.ctrlKey = value;
            else 
                _ctrlKey = value;
        }
        private var _metaKey:Boolean;

        COMPILE::SWF
        public function get metaKey():Boolean
        {
            return _metaKey;
        }
        
        COMPILE::JS
        public function get metaKey():Boolean
        {
            return wrappedEvent ? wrappedEvent.metaKey : _metaKey;
        }

        COMPILE::SWF
        public function set metaKey(value:Boolean):void
        {
            _metaKey = value;
        }

        COMPILE::JS
        public function set metaKey(value:Boolean):void
        {
            if(wrappedEvent)wrappedEvent.metaKey = value;
            else _metaKey = value;
        }

        private var _shiftKey:Boolean;

        COMPILE::SWF
        public function get shiftKey():Boolean
        {
            return _shiftKey;
        }
        
        COMPILE::JS
        public function get shiftKey():Boolean
        {
        	return wrappedEvent ? wrappedEvent.shiftKey : _shiftKey;
        }

        COMPILE::SWF
        public function set shiftKey(value:Boolean):void
        {
            _shiftKey = value;
        }

        COMPILE::JS
        public function set shiftKey(value:Boolean):void
        {
            if(wrappedEvent)wrappedEvent.shiftKey = value;
            else _shiftKey = value;
        }
        
        public function get modifierKey():Boolean
        {
            return shiftKey || ctrlKey || metaKey;
        }

        /**
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9
         */
        COMPILE::JS
		override public function stopImmediatePropagation():void
		{
            if(wrappedEvent)
            {
			    wrappedEvent.stopPropagation();
			    nativeEvent.stopImmediatePropagation();
            }
		}

        /**
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9
         */
        COMPILE::JS
		override public function stopPropagation():void
		{
            if(wrappedEvent)
			    wrappedEvent.stopPropagation();
		}
		/**
		 * Whether the default action has been prevented.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
        COMPILE::JS
		override public function preventDefault():void
		{
			if(wrappedEvent)
				wrappedEvent.preventDefault();
			else
			{
				super.preventDefault();
				_defaultPrevented = true;
			}
		}

		COMPILE::JS
		private var _defaultPrevented:Boolean;
		/**
		 * Whether the default action has been prevented.
		 * @type {boolean}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 */
        COMPILE::JS
		override public function get defaultPrevented():Boolean
		{
			return wrappedEvent ? wrappedEvent.defaultPrevented : _defaultPrevented;
		}
        COMPILE::JS
        override public function set defaultPrevented(value:Boolean):void
		{
			_defaultPrevented = value;
		}

        /**
         * Create a copy/clone of the KeyboardEvent object.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
         */
        override public function cloneEvent():IRoyaleEvent
        {
            return new KeyboardEvent(type, key, code, shiftKey, altKey, ctrlKey, metaKey, bubbles, cancelable);
        }
        
        COMPILE::JS
        public static function setupConverter():Boolean
        {
            ElementWrapper.converterMap["KeyboardEvent"] = KeyboardEventConverter.convert;
            return true;
        }
        
        COMPILE::JS
        public static var initialized:Boolean = setupConverter();

    }
}
