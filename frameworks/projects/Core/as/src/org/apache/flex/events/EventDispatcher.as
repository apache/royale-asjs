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
package org.apache.flex.events
{
	COMPILE::JS
	{
        import goog.events;
		import goog.events.EventTarget;
	}

	COMPILE::AS3
	{
		import flash.events.EventDispatcher;
	}

	/**
	 * This class simply wraps flash.events.EventDispatcher so that
	 * no flash packages are needed on the JS side.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion FlexJS 0.0
	 */
	COMPILE::AS3
	public class EventDispatcher extends flash.events.EventDispatcher implements IEventDispatcher
	{
		/**
		 * Constructor.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion FlexJS 0.0
		 */
		public function EventDispatcher()
		{
			super();
		}
	}

	COMPILE::JS
	public class EventDispatcher extends goog.events.EventTarget implements IEventDispatcher
	{

		override public function addEventListener(type:String, handler:Object, opt_capture:Boolean = false, opt_handlerScope:Object = null):void
		{
			super.addEventListener(type, handler, opt_capture, opt_handlerScope);

			const that:* = this;
			var source:* = this;

			if (that.element && that.element.nodeName &&
				that.element.nodeName.toLowerCase() !== 'div' &&
				that.element.nodeName.toLowerCase() !== 'body')
			{
				source = that.element;
			}
			else if (ElementEvents.elementEvents[type])
			{
				// mouse and keyboard events also dispatch off the element.
				source = that.element;
			}

			goog.events.listen(source, type, handler);
		}
	}
}
