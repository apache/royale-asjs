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
package org.apache.royale.test.runners.notification
{
	/**
	 * Listens for notifications from an <code>ITestRunner</code>.
	 */
	public class RunNotifier implements IRunNotifier
	{
		/**
		 * Constructor.
		 */
		public function RunNotifier()
		{
		}

		/**
		 * @private
		 */
		private var _listeners:Vector.<IRunListener> = new <IRunListener>[];

		/**
		 * @inheritDoc
		 */
		public function addListener(listener:IRunListener):void
		{
			var index:int = _listeners.indexOf(listener);
			if(index !== -1)
			{
				//already added
				return;
			}
			_listeners.push(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function addFirstListener(listener:IRunListener):void
		{
			var index:int = _listeners.indexOf(listener);
			if(index === 0)
			{
				//already added at the start
				return;
			}
			if(index !== -1)
			{
				//remove so that we can add to the start
				_listeners.splice(index, 1);
			}
			_listeners.unshift(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function removeListener(listener:IRunListener):void
		{
			var index:int = _listeners.indexOf(listener);
			if(index === -1)
			{
				//wasn't added
				return;
			}
			_listeners.splice(index, 1);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllListeners():void
		{
			_listeners.length = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function fireTestStarted(description:String):void
		{
			var length:int = _listeners.length;
			for(var i:int = 0; i < length; i++)
			{
				var listener:IRunListener = _listeners[i];
				listener.testStarted(description);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function fireTestFinished(description:String):void
		{
			var length:int = _listeners.length;
			for(var i:int = 0; i < length; i++)
			{
				var listener:IRunListener = _listeners[i];
				listener.testFinished(description);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function fireTestFailure(failure:Failure):void
		{
			var length:int = _listeners.length;
			for(var i:int = 0; i < length; i++)
			{
				var listener:IRunListener = _listeners[i];
				listener.testFailure(failure);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function fireTestIgnored(description:String):void
		{
			var length:int = _listeners.length;
			for(var i:int = 0; i < length; i++)
			{
				var listener:IRunListener = _listeners[i];
				listener.testIgnored(description);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function fireTestRunStarted(description:String):void
		{
			var length:int = _listeners.length;
			for(var i:int = 0; i < length; i++)
			{
				var listener:IRunListener = _listeners[i];
				listener.testRunStarted(description);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function fireTestRunFinished(result:Result):void
		{
			var length:int = _listeners.length;
			for(var i:int = 0; i < length; i++)
			{
				var listener:IRunListener = _listeners[i];
				listener.testRunFinished(result);
			}
		}
	}
}