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
package org.apache.royale.events
{
	COMPILE::JS
	{
    import goog.events;
		import goog.events.EventTarget;
    import org.apache.royale.core.IChild;
	}

	COMPILE::SWF
	{
		import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
	}

	/**
	 * This class simply wraps flash.events.EventDispatcher so that
	 * no flash packages are needed on the JS side.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.0
	 */
	COMPILE::SWF
	public class EventDispatcher extends flash.events.EventDispatcher implements org.apache.royale.events.IEventDispatcher
	{
		/**
		 * Constructor.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.0
		 */
		public function EventDispatcher(target:org.apache.royale.events.IEventDispatcher = null)
		{
			super(target as flash.events.IEventDispatcher);
		}
	}

	COMPILE::JS
	public class EventDispatcher extends goog.events.EventTarget implements IEventDispatcher
	{
		
		private var _dispatcher:IEventDispatcher;
        public function EventDispatcher(target:IEventDispatcher = null)
        {
            _dispatcher = target || this;
        }
        
        public function hasEventListener(type:String):Boolean
        {
            return goog.events.hasListener(this, type);
        }
		
		override public function dispatchEvent(event1:Object):Boolean
		{
			try 
			{
				//we get quite a few string events here, "initialize" etc
				//so this general approach doesn't work:
				//event.target = _dispatcher;
				if (event1) {
					if (typeof event1 == "string") {
						event1 = new Event("" + event1);
						event1.target = _dispatcher;
						//console.log("created event from string ",event);
					}
					else if ("target" in event1) {
						event1.target = _dispatcher;
						//console.log("assigned target to event ",event);
					}
				} else return false;

				return super.dispatchEvent(event1);
			}
			catch (e:Error)
			{
				if (e.name != "stopImmediatePropagation")
					throw e;
			}
			return false;
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IChild
		 * @royaleemitcoercion org.apache.royale.events.EventDispatcher
		 */
		override public function getParentEventTarget():goog.events.EventTarget{
			return (this as IChild).parent as EventDispatcher;
		}

		public function toString():String
        {
            return "[object Object]";
        }
	}
}
