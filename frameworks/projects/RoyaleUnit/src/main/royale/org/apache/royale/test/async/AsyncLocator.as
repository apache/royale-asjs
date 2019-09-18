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
	import org.apache.royale.test.AssertionError;
	
	COMPILE::SWF
	{
		import flash.utils.Dictionary;
	}

	/**
	 * Used for tests with <code>[Test(async)]</code> metadata.
	 */
	COMPILE::SWF
	public class AsyncLocator
	{
		private static var handlers:Dictionary;

		public static function setAsyncHandlerForTest(test:Object, handler:IAsyncHandler):void
		{
			if(!handlers)
			{
				handlers = new Dictionary()
			}
			handlers[test] = handler;
		}

		public static function getAsyncHandlerForTest(test:Object):IAsyncHandler
		{
			if(!handlers || !hasAsyncHandlerForTest(test))
			{
				throw new AssertionError(MISSING_ASYNC_ERROR_MESSAGE);
			}
			return handlers[test];
		}

		public static function clearAsyncHandlerForTest(test:Object):void
		{
			if(!handlers || !hasAsyncHandlerForTest(test))
			{
				return;
			}
			delete handlers[test];
		}

		public static function hasAsyncHandlerForTest(test:Object):Boolean
		{
			return test in handlers;
		}
	}
	
	/**
	 * Used for tests with <code>[Test(async)]</code> metadata.
	 */
	COMPILE::JS
	public class AsyncLocator
	{
		private static var handlers:Map = new Map();

		public static function setAsyncHandlerForTest(test:Object, handler:IAsyncHandler):void
		{
			handlers.set(test, handler);
		}

		public static function getAsyncHandlerForTest(test:Object):IAsyncHandler
		{
			if(!handlers || !hasAsyncHandlerForTest(test))
			{
				throw new AssertionError(MISSING_ASYNC_ERROR_MESSAGE);
			}
			return IAsyncHandler(handlers.get(test));
		}

		public static function clearAsyncHandlerForTest(test:Object):void
		{
			if(!handlers || !hasAsyncHandlerForTest(test))
			{
				return;
			}
			handlers.delete(test);
		}

		public static function hasAsyncHandlerForTest(test:Object):Boolean
		{
			return handlers.has(test);
		}
	}
}

const MISSING_ASYNC_ERROR_MESSAGE:String = "Cannot add asynchronous functionality to methods defined by Test, Before, or After that are not marked async"