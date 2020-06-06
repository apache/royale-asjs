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
	import mx.events.FocusEvent;
    import org.apache.royale.utils.OSUtils;

	COMPILE::SWF
	{
		import flash.events.FocusEvent;
        import flash.events.IEventDispatcher;
        import org.apache.royale.events.utils.IHandlesOriginalEvent;
	}
	
	COMPILE::JS
	{
		import goog.events.BrowserEvent;
	}
	
	/**
	 *  Converts low level focus events to Royale FocusEvents
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class FocusEventConverter
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
		public static function convert(oldEvent:flash.events.FocusEvent):mx.events.FocusEvent
		{
			var newEvent:mx.events.FocusEvent = new mx.events.FocusEvent(oldEvent.type);
			return newEvent;
		}
		
		COMPILE::SWF
		private static function focusEventConverter(event:flash.events.Event):void
        {
            if (event is flash.events.FocusEvent && (!(event is mx.events.FocusEvent)))
            {
				var p:* = event.target;
				while (p != null) {
					if (p is IHandlesOriginalEvent) return;
					p = p.parent;
				}
				
                var newEvent:mx.events.FocusEvent = 
                    convert(flash.events.FocusEvent(event));
                if (newEvent) 
                {
                    // some events are not converted if there are no JS equivalents
                    event.stopImmediatePropagation();
					//newEvent.targetBeforeBubbling = event.target; might be needed
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
            flash.events.FocusEvent.KEY_FOCUS_CHANGE,
            flash.events.FocusEvent.MOUSE_FOCUS_CHANGE,
            flash.events.FocusEvent.FOCUS_IN,
            flash.events.FocusEvent.FOCUS_OUT
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
            flash.events.FocusEvent.KEY_FOCUS_CHANGE,
            flash.events.FocusEvent.MOUSE_FOCUS_CHANGE,
            flash.events.FocusEvent.FOCUS_OUT
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
        public static var eventHandler:Function = focusEventConverter;
        
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
		 *  
		 *  @royaleignorecoercion goog.events.BrowserEvent
		 */
		COMPILE::JS
		public static function convert(nativeEvent:Object,browserEvent:goog.events.BrowserEvent=null):mx.events.FocusEvent
		{
            var type:String = nativeEvent.type;
            if (type == "focusin") type = "focusIn";
            if (type == "focusout") type = "focusOut";
			var newEvent:FocusEvent = new FocusEvent(type, true);
			if(!browserEvent)
			{
				browserEvent = new goog.events.BrowserEvent(nativeEvent as goog.events.Event,nativeEvent["currentTarget"]);
			}
			newEvent.wrapEvent(browserEvent);
			return newEvent;
		}
	}
}
