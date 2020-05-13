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
	import org.apache.royale.events.KeyboardEvent;
	import org.apache.royale.utils.OSUtils;

	COMPILE::SWF
	{
		import flash.events.KeyboardEvent;
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
		public static function convert(oldEvent:flash.events.KeyboardEvent):org.apache.royale.events.KeyboardEvent
		{
			var code:String = KeyConverter.convertKeyCode(oldEvent.keyCode);
			var key:String = KeyConverter.convertCharCode(oldEvent.charCode);
			var type:String = oldEvent.type == flash.events.KeyboardEvent.KEY_DOWN ? org.apache.royale.events.KeyboardEvent.KEY_DOWN : 
				org.apache.royale.events.KeyboardEvent.KEY_UP;
			var newEvent:org.apache.royale.events.KeyboardEvent = new org.apache.royale.events.KeyboardEvent(
				type,
				key,
				code,
				oldEvent.shiftKey,
				oldEvent.altKey
			);
			return newEvent;
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
			var type:String = nativeEvent["type"];
			var key:String = nativeEvent["key"];
			if (!key)
				key = KeyConverter.convertCharCode(nativeEvent['charCode']);
			
			var code:String = nativeEvent["code"];
			if (code == null)
				code = KeyConverter.convertKeyCode(nativeEvent['keyCode']);
			
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
