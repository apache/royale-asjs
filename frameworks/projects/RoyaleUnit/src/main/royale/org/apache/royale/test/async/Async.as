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
package org.apache.royale.test.async
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.test.Assert;

	/**
	 * Helper functions for tests marked with <code>[Test(async)]</code> metadata.
	 */
	public class Async
	{
		/**
		 * Calls a function after a delay, measured in milliseconds.
		 */
		public static function delayCall(testCase:Object, delayedFunction:Function, delayMS:int):void
		{
			var handler:IAsyncHandler = AsyncLocator.getAsyncHandlerForTest(testCase);
			handler.asyncHandler(function():void
			{
				delayedFunction();
			}, delayMS);
		}
		
		/**
		 * If an event is not dispatched within the specified delay (measured in
		 * milliseconds), the test will fail.
		 */
		public static function requireEvent(testCase:Object, dispatcher:EventDispatcher, eventName:String, timeout:int):void
		{
			handleEvent(testCase, dispatcher, eventName, null, timeout);
		}
		
		/**
		 * Similar to <code>requireEvent()</code>, requires an event to be
		 * dispatched for the test to pass, but the arguments are also passed to
		 * a custom event handler that may perform additional checks.
		 */
		public static function handleEvent(testCase:Object, dispatcher:EventDispatcher, eventName:String, eventHandler:Function, timeout:int):void
		{
			var eventDispatched:Boolean = false;
			function handleDispatch(...rest:Array):void
			{
				eventDispatched = true;
				if(eventHandler != null)
				{
					eventHandler.apply(null, rest);
				}
			}
			dispatcher.addEventListener(eventName, handleDispatch);
			var handler:IAsyncHandler = AsyncLocator.getAsyncHandlerForTest(testCase);
			handler.asyncHandler(function():void
			{
				dispatcher.removeEventListener(eventName, handleDispatch);
				if(!eventDispatched)
				{
					Assert.fail("Timeout occurred before expected event: " + eventName);
				}
			}, timeout);
		}
		
		/**
		 * If an event is dispatched within the specified delay, the test case
		 * will fail.
		 */
		public static function failOnEvent(testCase:Object, dispatcher:EventDispatcher, eventName:String, timeout:int):void
		{
			var savedEvent:Event = null;
			var eventDispatched:Boolean = false;
			function handleDispatch(event:Event, ...rest:Array):void
			{
				savedEvent = event;
				eventDispatched = true;
			}
			dispatcher.addEventListener(eventName, handleDispatch);
			var handler:IAsyncHandler = AsyncLocator.getAsyncHandlerForTest(testCase);
			handler.asyncHandler(function():void
			{
				dispatcher.removeEventListener(eventName, handleDispatch);
				if(eventDispatched)
				{
					var message:String = "Unexpected event " + eventName + "dispatched";
					if(savedEvent != null)
					{
						message += " " + String(savedEvent);
					}
					Assert.fail(message);
				}
			}, timeout);
		}
	}
}