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
			var newEvent:mx.events.FocusEvent = new mx.events.FocusEvent(oldEvent.type, true);
			return newEvent;
		}
		
		/**
		 *  Converts JS keyboard events to Royale ones.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		COMPILE::JS
		public static function convert(nativeEvent:Object):FocusEvent
		{
            var type:String = nativeEvent.type;
            if (type == "focusin") type = "focusIn";
            if (type == "focusout") type = "focusOut";
			var newEvent:FocusEvent = new FocusEvent(type, true);
			return newEvent;
		}
	}
}
