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
package flex.events
{	
	import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.FocusEvent;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    
    import flex.display.InteractiveObject;
        
	/**
	 *  Mouse events conversion.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
	 */
    COMPILE::SWF
	public class FlashEventConverter
	{
        private static function mouseEventConverter(event:flash.events.Event):void
        {
			var srcClass:Class;
			var destClass:Class;
			var converter:Function;
			for (var c:Class in eventClassMap)
			{
				if (event is c)
				{
					srcClass = c;
					destClass = eventClassMap[c];
					converter = eventClassConverters[c];
				}
			}
			if (!srcClass)
			{
				srcClass = flash.events.Event;
				destClass = flex.events.Event;
				converter = eventConverter;
			}
            if (!(event is destClass))
            {
				var newEvent:flex.events.Event = converter(event) as flex.events.Event;
				event.stopImmediatePropagation();
				event.target.dispatchEvent(newEvent);
            }
        }
        
		/**
		 *  The map of events classes to convert.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public static var eventClassMap:Dictionary = new Dictionary();
		
		/**
		 *  The map of events class conversion functions.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public static var eventClassConverters:Dictionary = new Dictionary();
		
        /**
         *  The list of events to convert by intercepting in capture phase
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static var captureConvertedEvents:Array = [
			flash.events.Event.ACTIVATE,
			flash.events.Event.ADDED,
			flash.events.Event.DEACTIVATE,
			flash.events.Event.REMOVED
            ];
            
		/**
		 *  The list of stage events to convert that can't be captured
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public static var stageConvertedEvents:Array = [
			flash.events.Event.ACTIVATE,
			flash.events.Event.ADDED,
			flash.events.Event.DEACTIVATE,
			flash.events.Event.ENTER_FRAME,
			flash.events.Event.REMOVED,
			flash.events.Event.RENDER
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
		 *  The target used to capture and convert the events.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		private static var captureTarget:DisplayObject;
		
        /**
         *  Set up the top level converter.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static function setupAllConverters(target:DisplayObject):void
        {
			captureTarget = target;
            for each (var eventType:String in captureConvertedEvents)
                target.addEventListener(eventType, eventHandler, true, 9999);
	
			if (target.stage) 
				for each (eventType in stageConvertedEvents)
					target.stage.addEventListener(eventType, eventHandler, false, 9999);
				
			// don't add this.  It is the default if no other matches
			// eventClassMap[flash.events.Event] = flex.events.Event;
			eventClassMap[flash.events.FocusEvent] = flex.events.FocusEvent;
			eventClassConverters[flash.events.FocusEvent] = focusEventConverter;
        }

		/**
		 *  Set up the top level converter.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public static function removeAllConverters(target:DisplayObject):void
		{
			captureTarget = target;
			for each (var eventType:String in captureConvertedEvents)
				target.removeEventListener(eventType, eventHandler, true);
		}
		
        /**
         *  Add another event to convert.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static function addEventType(type:String):void
        {
			if (!captureTarget)
				captureConvertedEvents.push(type);
			else
                captureTarget.addEventListener(type, eventHandler, false, 9999);
        }
		
		private static function focusEventConverter(e:flash.events.FocusEvent):flex.events.FocusEvent
		{
			return new flex.events.FocusEvent(e.type, e.bubbles, e.cancelable, e.relatedObject as flex.display.InteractiveObject, e.shiftKey, e.keyCode);
		}
		
		private static function eventConverter(e:flash.events.Event):flex.events.Event
		{
			return new flex.events.Event(e.type, e.bubbles, e.cancelable);
		}
    }
}
