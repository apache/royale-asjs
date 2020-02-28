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
package mx.events.utils
{	
    import mx.core.Keyboard;
	import mx.events.KeyboardEvent;
	import org.apache.royale.events.utils.KeyConverter;
    import org.apache.royale.utils.OSUtils;

	COMPILE::SWF
	{
		import flash.events.IEventDispatcher;
		import flash.events.KeyboardEvent;
        import org.apache.royale.events.utils.IHandlesOriginalEvent;
	}
	COMPILE::JS
	{
		import goog.events.BrowserEvent;
		import goog.events.Event;
	}
	
	/**
	 *  Converts low level keyboard events to Royale KeyboardEvents
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class KeyboardEventConverter
	{
		
		/**
		 *  Converts Flash keyboard events to Royale ones.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		COMPILE::SWF
		public static function convert(oldEvent:flash.events.KeyboardEvent):mx.events.KeyboardEvent
		{
			//var code:String = KeyConverter.convertKeyCode(oldEvent.keyCode);
			//var key:String = KeyConverter.convertCharCode(oldEvent.charCode);
			var type:String = oldEvent.type == flash.events.KeyboardEvent.KEY_DOWN ? mx.events.KeyboardEvent.KEY_DOWN : 
				mx.events.KeyboardEvent.KEY_UP;
			var newEvent:mx.events.KeyboardEvent = new mx.events.KeyboardEvent(type, true, false, oldEvent.charCode, oldEvent.keyCode, 0,
					oldEvent.ctrlKey, oldEvent.altKey, oldEvent.shiftKey);
			newEvent.altKey = oldEvent.altKey;
//			newEvent.ctrlKey = oldEvent.controlKey; // TODO
			return newEvent;
		}
		
		COMPILE::SWF
        private static function keyEventConverter(event:flash.events.Event):void
        {
            if (event is flash.events.KeyboardEvent && (!(event is mx.events.KeyboardEvent)))
            {
				var p:* = event.target;
				while (p != null) {
					if (p is IHandlesOriginalEvent) return;
					p = p.parent;
				}
				
                var newEvent:mx.events.KeyboardEvent = 
                    convert(flash.events.KeyboardEvent(event));
                if (newEvent) 
                {
                    // some events are not converted if there are no JS equivalents
                    event.stopImmediatePropagation();
					//newEvent.targetBeforeBubbling = event.target;
                    event.target.dispatchEvent(newEvent);
                }
                else
                    trace("did not convert", event.type);
            }
        }
        
        /**
         *  The list of events to convert.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		COMPILE::SWF
        public static var allConvertedEvents:Array = [
			flash.events.KeyboardEvent.KEY_DOWN,
			flash.events.KeyboardEvent.KEY_UP
            ];
            
        /**
         *  The list of events to convert on each instance.
         *  Per-instance killers are needed for "out" events because
         *  they can be sent after the instance is removed from the 
         *  display list so the main converter can't intercept them
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		COMPILE::SWF
        public static var perInstanceConvertedEvents:Array = [
            flash.events.KeyboardEvent.KEY_UP
        ];
        
        /**
         *  The event handler that converts the events.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		COMPILE::SWF
        public static var eventHandler:Function = keyEventConverter;
        
        /**
         *  Set up the top level converter.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		COMPILE::SWF
        public static function setupAllConverters(target:IEventDispatcher, capture:Boolean = true):void
        {
            for each (var eventType:String in allConvertedEvents)
                target.addEventListener(eventType, eventHandler, capture, 9999);
        }

        /**
         *  Set up some event handlers on each instance.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		COMPILE::SWF
        public static function setupInstanceConverters(target:IEventDispatcher):void
        {
            for each (var eventType:String in perInstanceConvertedEvents)
                target.addEventListener(eventType, eventHandler, false, 9999);
        }

		/**
		 *  Converts JS keyboard events to Royale ones.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 *  @royaleignorecoercion Event
         * @royaleignorecoercion goog.events.Event
         * We're lying to the compiler for now because it thinks it's supposed to accept a goog.events.Event.
         * We need to fix this in typedefs
		 */
		COMPILE::JS
		public static function convert(nativeEvent:Object,browserEvent:goog.events.BrowserEvent=null):KeyboardEvent
		{
            if (nativeEvent["getModifierState"])
            {
                Keyboard.setCapsLock(nativeEvent["getModifierState"]("CapsLock"));
            }
			var type:String = nativeEvent["type"];
			var key:String = nativeEvent["key"];
			if (!key)
				key = KeyConverter.convertCharCode(nativeEvent['charCode']);
			
			var code:String = nativeEvent["code"];
			if (code == null)
				code = KeyConverter.convertKeyCode(nativeEvent['keyCode']);
			
            if (type == "keydown") type = "keyDown";
            if (type == "keyup") type = "keyUp";
			var newEvent:KeyboardEvent = new KeyboardEvent(type, key, code, nativeEvent["shiftKey"]);
			if(!browserEvent)
			{
				browserEvent = new goog.events.BrowserEvent(nativeEvent as goog.events.Event,nativeEvent["currentTarget"]);
			}
			newEvent.wrapEvent(browserEvent);
			return newEvent;
		}
	}
}
