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
package org.apache.flex.events.utils
{	
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.MouseEvent;
    
    import org.apache.flex.events.MouseEvent;
    
	/**
	 *  Mouse events conversion.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
	 */
	public class MouseEventConverter
	{
        /**
         *  A map of events that are not converted, because there is no
         *  JS equivalent.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static const UNCONVERTED_EVENTS:Object = { mouseWheel: 1 };
        
        /**
         *  A method used to copy properties from flash.events.MouseEvent to 
         *  org.apache.flex.events.Event.  The set of properties can be
         *  different based on platform and runtime.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static var convert:Function = flashConvert;
        
        private static function flashConvert(event:flash.events.MouseEvent):org.apache.flex.events.MouseEvent
        {
            if (UNCONVERTED_EVENTS[event.type])
                return null;
            
            var newEvent:org.apache.flex.events.MouseEvent = 
                  new org.apache.flex.events.MouseEvent(event.type, event.bubbles, event.cancelable,
                                                        event.localX, event.localY, event.relatedObject,
                                                        event.ctrlKey, event.altKey, event.shiftKey,
                                                        event.buttonDown, event.delta);

            return newEvent;
        }
        
        private static function mouseEventConverter(event:flash.events.Event):void
        {
            if (event is flash.events.MouseEvent && (!(event is org.apache.flex.events.MouseEvent)))
            {
                var newEvent:org.apache.flex.events.MouseEvent = 
                    convert(flash.events.MouseEvent(event));
                if (newEvent) 
                {
                    // some events are not converted if there are no JS equivalents
                    event.stopImmediatePropagation();
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
         *  @productversion FlexJS 0.0
         */
        public static var allConvertedEvents:Array = [
            flash.events.MouseEvent.CLICK,
            flash.events.MouseEvent.MOUSE_DOWN,
            flash.events.MouseEvent.MOUSE_UP,
            flash.events.MouseEvent.ROLL_OVER,
            flash.events.MouseEvent.ROLL_OUT,
            flash.events.MouseEvent.MOUSE_OVER,
            flash.events.MouseEvent.MOUSE_OUT,
            flash.events.MouseEvent.MOUSE_MOVE
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
         *  @productversion FlexJS 0.0
         */
        public static var perInstanceConvertedEvents:Array = [
            flash.events.MouseEvent.MOUSE_UP,
            flash.events.MouseEvent.ROLL_OUT,
            flash.events.MouseEvent.MOUSE_OUT
        ];
        
        /**
         *  The event handler that converts the events.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static var eventHandler:Function = mouseEventConverter;
        
        /**
         *  Set up the top level converter.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static function setupAllConverters(target:IEventDispatcher):void
        {
            for each (var eventType:String in allConvertedEvents)
                target.addEventListener(eventType, eventHandler, true, 9999);
        }

        /**
         *  Set up some event handlers on each instance.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static function setupInstanceConverters(target:IEventDispatcher):void
        {
            for each (var eventType:String in perInstanceConvertedEvents)
                target.addEventListener(eventType, eventHandler, false, 9999);
        }
    }
}