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
package org.apache.royale.text.events
{
	import org.apache.royale.events.IRoyaleEvent;
	import org.apache.royale.events.Event;
	
	/**
	 * A TextLayoutEvent instance represents an event, such as the 
	 * <code>TextLayoutEvent.SCROLL</code> event, that does not require
	 * custom properties. 
	 * <p>A scroll event is represented by a TextLayoutEvent instance with its 
	 * <code>type</code> property set to <code>TextLayoutEvent.SCROLL</code>.
	 * A class specifically for scroll events is not necessary because there are
	 * no custom properties for a scroll event, as there are for the other
	 * events that have specific event classes.
	 * If a new text layout event is needed, and the event does not require
	 * custom properties, the new event will also be represented by a
	 * TextLayoutEvent object, but with its <code>type</code> property
	 * set to a new static constant.
	 * </p>
	 *
	 * @includeExample examples/TextLayoutEvent_example.as -noswf
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public class TextEvent extends Event
	{
		public static const LINK : String = "link";
		public static const TEXT_INPUT : String = "textInput";

		public function TextEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, text:String = "")
		{
			this.text = text;
			super(type, bubbles, cancelable);
		}
		public var text:String;
		
        /** @private */
        override public function cloneEvent():IRoyaleEvent
        {
        	return new TextEvent(type, bubbles, cancelable, text);
        }		
	}
}
