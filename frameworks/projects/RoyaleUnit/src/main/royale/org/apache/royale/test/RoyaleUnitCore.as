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
package org.apache.royale.test
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.test.runners.ITestRunner;
	import org.apache.royale.test.runners.notification.Failure;
	import org.apache.royale.test.runners.notification.IAsyncStartupRunListener;
	import org.apache.royale.test.runners.notification.IRunListener;
	import org.apache.royale.test.runners.notification.IRunNotifier;
	import org.apache.royale.test.runners.notification.Result;

	/**
	 * Simple entry point for running tests.
	 */
	public class RoyaleUnitCore extends EventDispatcher
	{
		/**
		 * Constructor.
		 */
		public function RoyaleUnitCore()
		{
		}

		/**
		 * @private
		 */
		protected var _runner:ITestRunner = null;

		/**
		 * @private
		 */
		protected var _listeners:Vector.<IRunListener> = new <IRunListener>[];

		/**
		 * Requests that the runner stops running the tests. Phrased politely
		 * because the test that is currently running may not be interrupted
		 * before completing.
		 */
		public function pleaseStop():void
		{
			if(!_runner)
			{
				return;
			}
			_runner.pleaseStop();
		}

		/**
		 * Adds a run listener.
		 */
		public function addListener(listener:IRunListener):void
		{
			var index:int = _listeners.indexOf(listener);
			if(index !== -1)
			{
				return;
			}
			_listeners.push(listener);
		}

		/**
		 * Removes a run listener.
		 */
		public function removeListener(listener:IRunListener):void
		{
			var index:int = _listeners.indexOf(listener);
			if(index === -1)
			{
				return;
			}
			_listeners.splice(index, 1);
		}

		/**
		 * @private
		 */
		public function runRunner(runner:ITestRunner):void
		{
			if(_runner)
			{
				throw new Error("Failed to run tests. Wait for previous test run to complete before starting again.");
			}

			_runner = runner;

			var allListenersReady:Boolean = true;
			var listenersLength:int = _listeners.length;
			for(var i:int = 0; i < listenersLength; i++)
			{
				var listener:IRunListener = _listeners[i];
				if(listener is IAsyncStartupRunListener)
				{
					var asyncListener:IAsyncStartupRunListener = IAsyncStartupRunListener(listener);
					if(!asyncListener.ready)
					{
						allListenersReady = false;
						asyncListener.addEventListener("ready", asyncListener_readyHandler);
						asyncListener.addEventListener("skip", asyncListener_skipHandler);
					}
				}
			}

			if(allListenersReady)
			{
				startRun();
			}
		}

		/**
		 * @private
		 */
		protected function startRun():void
		{
			var runner:ITestRunner = _runner;

			var notifier:IRunNotifier = new RootRunNotifier(testRunFinished);
			var listenersLength:int = _listeners.length;
			for(var i:int = 0; i < listenersLength; i++)
			{
				var listener:IRunListener = _listeners[i];
				notifier.addListener(_listeners[i]);
			}

			try
			{
				_runner.run(notifier);
			}
			catch(error:Error)
			{
				notifier.fireTestFailure(new Failure(runner.description, error));
				finishRunner();
			}
		}

		/**
		 * @private
		 */
		public function runClasses(testClass:Class, ...rest:Array):void
		{
			var classes:Vector.<Class> = new <Class>[];
			var classCount:int = rest.length;
			for(var i:int = 0; i < classCount; i++)
			{
				var item:* = rest[i];
				if(item is Class)
				{
					classes[i] = rest[i];
				}
				else
				{
					throw new Error("Not a class: " + item);
				}
			}
			classes.unshift(testClass);
			runRunner(new ClassesRunner(classes));
		}

		/**
		 * @private
		 */
		protected function finishRunner():void
		{
			_runner = null;
			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * @private
		 */
		protected function testRunFinished(result:Result):void
		{
			finishRunner();
		}

		/**
		 * @private
		 */
		protected function checkListenersReady():void
		{
			var allListenersReady:Boolean = true;
			var listenersLength:int = _listeners.length;
			for(var i:int = 0; i < listenersLength; i++)
			{
				var listener:IRunListener = _listeners[i];
				if(listener is IAsyncStartupRunListener)
				{
					var asyncListener:IAsyncStartupRunListener = IAsyncStartupRunListener(listener);
					if(asyncListener.ready)
					{
						asyncListener.removeEventListener("skip", asyncListener_skipHandler);
						asyncListener.removeEventListener("ready", asyncListener_readyHandler);
					}
					else
					{
						allListenersReady = false;
					}
				}
			}

			if(allListenersReady)
			{
				startRun();
			}
		}

		/**
		 * @private
		 */
		protected function asyncListener_skipHandler(event:Event):void
		{
			var listener:IAsyncStartupRunListener = IAsyncStartupRunListener(event.currentTarget);
			listener.removeEventListener("skip", asyncListener_skipHandler);
			listener.removeEventListener("ready", asyncListener_readyHandler);
			removeListener(listener);
			checkListenersReady();
		}

		/**
		 * @private
		 */
		protected function asyncListener_readyHandler(event:Event):void
		{
			checkListenersReady();
		}
	}
}

import org.apache.royale.test.runners.ITestRunner;
import org.apache.royale.test.runners.ParentRunner;
import org.apache.royale.test.runners.notification.IRunListener;
import org.apache.royale.test.runners.notification.IRunNotifier;
import org.apache.royale.test.runners.notification.Result;
import org.apache.royale.test.runners.notification.RunNotifier;

/**
 * An internal runner for a collection of classes.
 */
class ClassesRunner extends ParentRunner implements ITestRunner
{
	/**
	 * Constructor.
	 */
	public function ClassesRunner(classes:Vector.<Class>)
	{
		super();
		if(!classes)
		{
			throw new Error("Test classes collection must not be null.");
		}
		_classes = classes;
	}

	/**
	 * @private
	 */
	private var _classes:Vector.<Class> = null;

	/**
	 * @private
	 */
	override public function get description():String
	{
		return "RoyaleUnitCore";
	}

	/**
	 * @private
	 */
	override protected function collectChildren(result:Vector.<Class>):void
	{
		if(!_classes)
		{
			return;
		}
		var classCount:int = _classes.length;
		for(var i:int = 0; i < classCount; i++)
		{
			result.push(_classes[i]);
		}
	}
}

class RootRunNotifier extends RunNotifier
{
	public function RootRunNotifier(testRunFinishedCallback:Function)
	{
		_testRunFinishedCallback = testRunFinishedCallback;
	}

	private var _testRunFinishedCallback:Function = null;

	override public function fireTestRunFinished(result:Result):void
	{
		super.fireTestRunFinished(result);
		this._testRunFinishedCallback(result);
	}
}