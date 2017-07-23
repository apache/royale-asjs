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
package org.apache.flex.events
{
    COMPILE::JS
    {
        import goog.events.BrowserEvent;
		import org.apache.flex.events.Event;
    }
    import org.apache.flex.events.IBrowserEvent;

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

		/**
		 * @type {?goog.events.BrowserEvent}
		 */
        COMPILE::JS
		private var wrappedEvent:Object;

        COMPILE::JS
		public function wrapEvent(event:goog.events.BrowserEvent):void
        {
            wrappedEvent = event;
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

		/**
         *  @copy org.apache.flex.events.BrowserEvent#target
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.9
		 */
        COMPILE::JS
		override public function get target():Object
		{
			return wrappedEvent ? getTargetWrapper(wrappedEvent.target) : super.target;
		}

		/**
         *  @copy org.apache.flex.events.BrowserEvent#currentTarget
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.9
		 */
        COMPILE::JS
		override public function get currentTarget():Object
		{
			return wrappedEvent ? getTargetWrapper(wrappedEvent.currentTarget) : super.currentTarget;
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
        
        private var _shiftKey:Boolean;
        public function get shiftKey():Boolean
        {
            return _shiftKey;
        }

        private var _altKey:Boolean;
        public function get altKey():Boolean
        {
            return _altKey;
        }
        public function set altKey(value:Boolean):void
        {
            _altKey = value;
        }
        
        private var _ctrlKey:Boolean;
        public function get ctrlKey():Boolean
        {
            return _ctrlKey;
        }
        public function set ctrlKey(value:Boolean):void
        {
            _ctrlKey = value;
        }

        private var _metaKey:Boolean;
        public function get metaKey():Boolean
        {
            return _metaKey;
        }
        public function set metaKey(value:Boolean):void
        {
            _metaKey = value;
        }
        
        public function get modifierKey():Boolean
        {
            return shiftKey || ctrlKey || metaKey;
        }
		
        private var _specialKey:Boolean;
		public function get specialKey():Boolean

		{
			return _specialKey;
		}

		public function set specialKey(value:Boolean):void
		{
			_specialKey = value;
		}

        /**
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.9
         */
        COMPILE::JS
		override public function stopImmediatePropagation():void
		{
            if(wrappedEvent)
            {
			    wrappedEvent.stopPropagation();
			    wrappedEvent.getBrowserEvent().stopImmediatePropagation();
            }
		}

        /**
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.9
         */
        COMPILE::JS
		override public function stopPropagation():void
		{
            if(wrappedEvent)
			    wrappedEvent.stopPropagation();
		}

        /**
         * Create a copy/clone of the KeyboardEvent object.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
         */
        override public function cloneEvent():IFlexJSEvent
        {
            return new KeyboardEvent(type, key, code, shiftKey, altKey, ctrlKey, metaKey, bubbles, cancelable);
        }
    }
}