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
		/**
		 * @private
		 */
		private static var handlers:Dictionary;

		/**
		 * Called by the test runner before an async test has started.
		 */
		public static function setAsyncHandlerForTest(test:Object, handler:IAsyncHandler):void
		{
			if(!handlers)
			{
				handlers = new Dictionary()
			}
			handlers[test] = handler;
		}

		/**
		 * Returns the current async handler for the specified test, or throws
		 * an exception if there is none.
		 */
		public static function getAsyncHandlerForTest(test:Object):IAsyncHandler
		{
			if(!handlers || !hasAsyncHandlerForTest(test))
			{
				throw new AssertionError(MISSING_ASYNC_ERROR_MESSAGE);
			}
			return handlers[test];
		}

		/**
		 * Called by the test runner after an async test has completed.
		 */
		public static function clearAsyncHandlerForTest(test:Object):void
		{
			if(!handlers || !hasAsyncHandlerForTest(test))
			{
				return;
			}
			delete handlers[test];
		}

		/**
		 * Indicates if there is an async handler for the specified test.
		 */
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
		/**
		 * @private
		 */
		private static var handlers:Map = new Map();

		/**
		 * Called by the test runner before an async test has started.
		 */
		public static function setAsyncHandlerForTest(test:Object, handler:IAsyncHandler):void
		{
			handlers.set(test, handler);
		}

		/**
		 * Returns the current async handler for the specified test, or throws
		 * an exception if there is none.
		 */
		public static function getAsyncHandlerForTest(test:Object):IAsyncHandler
		{
			if(!handlers || !hasAsyncHandlerForTest(test))
			{
				throw new AssertionError(MISSING_ASYNC_ERROR_MESSAGE);
			}
			return IAsyncHandler(handlers.get(test));
		}

		/**
		 * Called by the test runner after an async test has completed.
		 */
		public static function clearAsyncHandlerForTest(test:Object):void
		{
			if(!handlers || !hasAsyncHandlerForTest(test))
			{
				return;
			}
			handlers.delete(test);
		}

		/**
		 * Indicates if there is an async handler for the specified test.
		 */
		public static function hasAsyncHandlerForTest(test:Object):Boolean
		{
			return handlers.has(test);
		}
	}
}

const MISSING_ASYNC_ERROR_MESSAGE:String = "Cannot add asynchronous functionality to methods defined by Test, Before, or After that are not marked async"