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
package org.apache.royale.events.utils
{
    COMPILE::SWF
    {
        import flash.events.Event;
        import flash.events.IEventDispatcher;
        import flash.events.FocusEvent;
        import org.apache.royale.events.utils.IHandlesOriginalEvent;
    }
    
    import org.apache.royale.events.FocusEvent;
    
	/**
	 *  Focus events conversion.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
	 */
    COMPILE::SWF
	public class FocusEventConverter
	{
        /**
         *  A map of events that are not converted, because there is no
         *  JS equivalent.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public static const UNCONVERTED_EVENTS:Object = {};
        
        /**
         *  A method used to copy properties from flash.events.FocusEvent to 
         *  org.apache.royale.events.Event.  The set of properties can be
         *  different based on platform and runtime.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public static var convert:Function = flashConvert;
        
        private static function flashConvert(event:flash.events.FocusEvent):org.apache.royale.events.FocusEvent
        {
//            if (UNCONVERTED_EVENTS[event.type])
//                return null;
            
            var newEvent:org.apache.royale.events.FocusEvent = 
                  new org.apache.royale.events.FocusEvent(event.type, event.bubbles, event.cancelable,
                                                        event.relatedObject,
                                                        event.shiftKey,
                                                        event.keyCode,
                                                        event.direction);

            return newEvent;
        }
        
        private static function focusEventConverter(event:flash.events.Event):void
        {
            if (event is flash.events.FocusEvent && (!(event is org.apache.royale.events.FocusEvent)))
            {
				var p:* = event.target;
				while (p != null) {
					if (p is IHandlesOriginalEvent) return;
					p = p.parent;
				}
				
                var newEvent:org.apache.royale.events.FocusEvent = 
                    convert(flash.events.FocusEvent(event));
                if (newEvent) 
                {
                    // some events are not converted if there are no JS equivalents
                    event.stopImmediatePropagation();
					newEvent.targetBeforeBubbling = event.target;
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
         *  @productversion Royale 0.9.4
         */
        public static var allConvertedEvents:Array = [
			flash.events.FocusEvent.FOCUS_IN,
			flash.events.FocusEvent.FOCUS_OUT,
			flash.events.FocusEvent.KEY_FOCUS_CHANGE,
			flash.events.FocusEvent.MOUSE_FOCUS_CHANGE
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
         *  @productversion Royale 0.9.4
         */
        public static var perInstanceConvertedEvents:Array = [
            flash.events.FocusEvent.FOCUS_OUT,
            flash.events.FocusEvent.KEY_FOCUS_CHANGE,
            flash.events.FocusEvent.MOUSE_FOCUS_CHANGE
        ];
        
        /**
         *  The event handler that converts the events.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public static var eventHandler:Function = focusEventConverter;
        
        /**
         *  Set up the top level converter.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
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
         *  @productversion Royale 0.9.4
         */
        public static function setupInstanceConverters(target:IEventDispatcher):void
        {
            for each (var eventType:String in perInstanceConvertedEvents)
                target.addEventListener(eventType, eventHandler, false, 9999);
        }
    }
    COMPILE::JS
	public class FocusEventConverter
	{
        public static function convert(nativeEvent:Object):FocusEvent
        {
            return new FocusEvent(nativeEvent["type"], nativeEvent["bubbles"], nativeEvent["cancelable"]);
        }
    }

}
