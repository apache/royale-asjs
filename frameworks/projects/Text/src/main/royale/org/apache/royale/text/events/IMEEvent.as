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
    import org.apache.royale.text.ime.IIMEClient;

    public class IMEEvent extends Event
    {
        public static const IME_COMPOSITION : String = "imeComposition";
 	 	public static const IME_START_COMPOSITION : String = "imeStartComposition";
        public var text:String;
        public var imeClient:IIMEClient;
        public function IMEEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "", imeClient:IIMEClient = null)
        {
            this.text = text;
            this.imeClient = imeClient;
            super(type, bubbles, cancelable);
        }
		/**
		 * Create a copy/clone of the Event object.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.0
		 */
		override public function cloneEvent():IRoyaleEvent
		{
			return new IMEEvent(type, bubbles, cancelable, text, imeClient);
		}
    }
}
