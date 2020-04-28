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
package org.apache.royale.test.runners
{
	import org.apache.royale.events.Event;
	import org.apache.royale.reflection.MetaDataDefinition;
	import org.apache.royale.reflection.MethodDefinition;
	import org.apache.royale.reflection.TypeDefinition;
	import org.apache.royale.reflection.describeType;
	import org.apache.royale.reflection.getDefinitionByName;
	import org.apache.royale.reflection.getQualifiedClassName;
	import org.apache.royale.test.Assert;
	import org.apache.royale.test.AssertionError;
	import org.apache.royale.test.async.AsyncLocator;
	import org.apache.royale.test.async.IAsyncHandler;
	import org.apache.royale.test.runners.notification.Failure;
	import org.apache.royale.test.runners.notification.IRunListener;
	import org.apache.royale.test.runners.notification.IRunNotifier;
	import org.apache.royale.test.runners.notification.Result;
	import org.apache.royale.utils.Timer;

	/**
	 * Runs a class containing methods marked with <code>[Test]</code> metadata.
	 * 
	 * <p>Also supports the following optional metadata:</p>
	 * 
	 * <ul>
	 * <li>Tests with <code>[Ignore]</code> metadata should be ignored (skipped).</li>
	 * <li>Methods with <code>[Before]</code> metadata are run before every individual test.</li>
	 * <li>Methods with <code>[After]</code> metadata are run after every individual test.</li>
	 * <li>Static methods with <code>[BeforeClass]</code> metadata are run one time, before the first test.</li>
	 * <li>Static methods with <code>[AfterClass]</code> metadata are run one time, after the final test.</li>
	 * </ul>
	 * 
	 * <p>To test asynchronous functionality, add the <code>async</code>
	 * modifier to the <code>[Test]</code> metadata, and use the static methods
	 * on the <code>org.apache.royale.test.async.Async</code> class to set up a
	 * context for testing asynchronously.</p>
	 * 
	 * <pre><code>[Test(async)]</code></pre>
	 * 
	 * <p>By default, asynchronous tests fail if they do not complete within 500
	 * milliseconds. Set the <code>timeout</code> modifier on the
	 * <code>[Test]</code> metadata to customize this duration (measured in
	 * milliseconds).</p>
	 * 
	 * <pre><code>[Test(async,timeout="2000")]</code></pre>
	 * 
	 * <p>To require that a specific exception is thrown while a test is
	 * running, set the `expected` modifier on the `[Test]` metadata to the name
	 * of the exception class.</p>
	 * 
	 * <pre><code>[Test(expected="RangeError")]</code></pre>
	 * 
	 * @see org.apache.royale.test.async.Async
	 */
	public class MetadataRunner implements ITestRunner
	{
		/**
		 * The default timeout, measured in milliseconds, before an asynchronous
		 * test should be considered a failure.
		 */
		public static const DEFAULT_ASYNC_TIMEOUT:int = 500;

		/**
		 * Constructor.
		 */
		public function MetadataRunner(testClass:Class)
		{
			super();
			if(!testClass)
			{
				throw new Error("Test class must not be null.");
			}
			_testClass = testClass;
		}

		/**
		 * @private
		 */
		public function get description():String
		{
			return getQualifiedClassName(_testClass);
		}

		/**
		 * @private
		 */
		protected var _testClass:Class = null;

		/**
		 * @private
		 */
		protected var _failures:Boolean = false;

		/**
		 * @private
		 */
		protected var _stopRequested:Boolean = false;

		/**
		 * @private
		 */
		protected var _notifier:IRunNotifier = null;

		/**
		 * @private
		 */
		protected var _listener:IRunListener = null;

		/**
		 * @private
		 */
		protected var _collectedTests:Vector.<TestInfo> = new <TestInfo>[];

		/**
		 * @private
		 */
		protected var _currentIndex:int = 0;

		/**
		 * @private
		 */
		protected var _target:Object = null;

		/**
		 * @private
		 */
		protected var _result:Result = null;

		/**
		 * @private
		 */
		protected var _before:Function = null;

		/**
		 * @private
		 */
		protected var _after:Function = null;

		/**
		 * @private
		 */
		protected var _beforeClass:Function = null;

		/**
		 * @private
		 */
		protected var _afterClass:Function = null;

		/**
		 * @private
		 */
		protected var _timer:Timer = null;

		/**
		 * @inheritDoc
		 */
		public function pleaseStop():void
		{
			_stopRequested = true;
			if(_timer)
			{
				_timer.stop();
				cleanupAsync();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function run(notifier:IRunNotifier):void
		{
			_notifier = notifier;
			_failures = false;
			_stopRequested = false;
			_result = new Result();
			_listener = _result.createListener();
			_notifier.addListener(_listener);

			_notifier.fireTestRunStarted(description);
			if(_testClass)
			{
				readStaticMetadataTags();
				if(_beforeClass !== null)
				{
					_beforeClass.apply(_testClass);
				}
				_target = new _testClass();
				readInstanceMetadataTags();
				continueAll();
			}
			else
			{
				_failures = true;
				_notifier.fireTestFailure(new Failure(description + ".initializationError", new Error("No tests specified.")));

				_notifier.removeListener(_listener);
				_notifier.fireTestRunFinished(_result);
			}
		}

		/**
		 * @private
		 */
		protected function checkForDone():Boolean
		{
			var done:Boolean = _currentIndex >= _collectedTests.length;
			if(!done)
			{
				return false;
			}
			if(_afterClass !== null)
			{
				_afterClass.apply(_testClass);
			}
			_notifier.removeListener(_listener);
			_notifier.fireTestRunFinished(_result);
			return true;
		}

		/**
		 * @private
		 */
		protected function continueAll():void
		{
			var sync:Boolean = true;
			while(sync && !checkForDone())
			{
				sync = continueNext();
			}
		}

		/**
		 * @private
		 */
		protected function continueNext():Boolean
		{
			var test:TestInfo = _collectedTests[_currentIndex];
			try
			{
				if(test.ignore)
				{
					_notifier.fireTestIgnored(test.description);
					_currentIndex++;
					return true;
				}
				_notifier.fireTestStarted(test.description);
				if(_before !== null)
				{
					_before.apply(_target);
				}
				var asyncHandler:AsyncHandler = null;
				if(test.asyncTimeout > 0)
				{
					asyncHandler = new AsyncHandler();
					AsyncLocator.setAsyncHandlerForTest(_target, asyncHandler);
					asyncHandler.bodyExecuting = true;
				}
				if(test.expected != null)
				{
					var expectedType:Class = getDefinitionByName(test.expected) as Class;
					var throwsType:Class = null;
					try
					{
						test.reference.apply(_target);
					}
					catch(exception:Object)
					{
						throwsType = exception.constructor;
					}
					Assert.assertStrictlyEquals(throwsType, expectedType);
				}
				else
				{
					test.reference.apply(_target);
				}
				if(asyncHandler)
				{
					asyncHandler.bodyExecuting = false;
					_timer = new Timer(test.asyncTimeout, 1);
					_timer.addEventListener(Timer.TIMER, timer_timerHandler);
					_timer.start();
					return false;
				}
			}
			catch(error:Error)
			{
				_failures = true;
				_notifier.fireTestFailure(new Failure(test.description, error));
			}
			afterTest(test);
			return true;
		}

		protected function afterTest(test:TestInfo):void
		{
			try
			{
				if(_after !== null)
				{
					_after.apply(_target);
				}
			}
			catch(error:Error)
			{
				_failures = true;
				_notifier.fireTestFailure(new Failure(test.description, error));
			}
			_notifier.fireTestFinished(test.description);
			_currentIndex++;
		}

		/**
		 * @private
		 */
		protected function readStaticMetadataTags():void
		{
			var beforeClassDefinition:MethodDefinition = collectMethodWithMetadataTag(TestMetadata.BEFORE_CLASS, true);
			if(beforeClassDefinition != null)
			{
				_beforeClass = _testClass[beforeClassDefinition.name];
				if(!_beforeClass)
				{
					_notifier.fireTestFailure(new Failure(description + ".initializationError", new Error("Reflection failed to locate static method <" + beforeClassDefinition.name + "> defined on type <" + beforeClassDefinition.declaredBy.qualifiedName + "> with [BeforeClass] metadata.")));
				}
			}
			var afterClassDefinition:MethodDefinition = collectMethodWithMetadataTag(TestMetadata.AFTER_CLASS, true);
			if(afterClassDefinition != null)
			{
				_afterClass = _testClass[afterClassDefinition.name];
				if(!_afterClass)
				{
					_notifier.fireTestFailure(new Failure(description + ".initializationError", new Error("Reflection failed to locate static method <" + afterClassDefinition.name + "> defined on type <" + afterClassDefinition.declaredBy.qualifiedName + "> with [AfterClass] metadata.")));
				}
			}
			var beforeDefinition:MethodDefinition = collectMethodWithMetadataTag(TestMetadata.BEFORE, true);
			if(beforeDefinition != null)
			{
				_failures = true;
				_notifier.fireTestFailure(new Failure(description + ".initializationError", new Error("Unexpected [Before] metadata on static method <" + beforeDefinition.name + "> defined on type <" + beforeDefinition.declaredBy.qualifiedName + ">. [Before] may be used on instance methods only.")));
			}
			var afterDefinition:MethodDefinition = collectMethodWithMetadataTag(TestMetadata.AFTER, true);
			if(afterDefinition != null)
			{
				_failures = true;
				_notifier.fireTestFailure(new Failure(description + ".initializationError", new Error("Unexpected [After] metadata on static method <" + afterDefinition.name + "> defined on type <" + afterDefinition.declaredBy.qualifiedName + ">. [After] may be used on instance methods only.")));
			}
			var testDefinition:MethodDefinition = collectMethodWithMetadataTag(TestMetadata.TEST, true);
			if(testDefinition != null)
			{
				_failures = true;
				_notifier.fireTestFailure(new Failure(description + ".initializationError", new Error("Unexpected [Test] metadata on static method <" + testDefinition.name + "> defined on type <" + testDefinition.declaredBy.qualifiedName + ">. [Test] may be used on instance methods only.")));
			}
		}

		/**
		 * @private
		 */
		protected function readInstanceMetadataTags():void
		{
			collectTests();
			if(_collectedTests.length === 0)
			{
				//at least one test is required
				throw new Error("No methods with [Test] metadata found on instance of type <" + getQualifiedClassName(_testClass) + ">. Did you forget to include the -keep-as3-metadata compiler option?")
			}
			var beforeDefinition:MethodDefinition = collectMethodWithMetadataTag(TestMetadata.BEFORE);
			if(beforeDefinition != null)
			{
				_before = _target[beforeDefinition.name];
			}
			var afterDefinition:MethodDefinition = collectMethodWithMetadataTag(TestMetadata.AFTER);
			if(afterDefinition != null)
			{
				_after = _target[afterDefinition.name];
			}
			var beforeClassDefinition:MethodDefinition = collectMethodWithMetadataTag(TestMetadata.BEFORE_CLASS);
			if(beforeClassDefinition != null)
			{
				_failures = true;
				_notifier.fireTestFailure(new Failure(description + ".initializationError", new Error("Unexpected [BeforeClass] metadata on instance method <" + beforeClassDefinition.name + "> defined on type <" + beforeClassDefinition.declaredBy.qualifiedName + ">. [BeforeClass] may be used on static methods only.")));
			}
			var afterClassDefinition:MethodDefinition = collectMethodWithMetadataTag(TestMetadata.AFTER_CLASS);
			if(afterClassDefinition != null)
			{
				_failures = true;
				_notifier.fireTestFailure(new Failure(description + ".initializationError", new Error("Unexpected [AfterClass] metadata on instance method <" + afterClassDefinition.name + "> defined on type <" + afterClassDefinition.declaredBy.qualifiedName + ">. [AfterClass] may be used on static methods only.")));
			}
		}

		/**
		 * @private
		 */
		protected function collectMethodWithMetadataTag(tagName:String, isStatic:Boolean = false):MethodDefinition
		{
			var described:Object = isStatic ? _testClass : _target;
			var typeDefinition:TypeDefinition = describeType(described);
			if(!typeDefinition)
			{
				return null;
			}
			var methods:Array = isStatic ? typeDefinition.staticMethods : typeDefinition.methods;
			var length:int = methods.length;
			for(var i:int = 0; i < length; i++)
			{
				var method:MethodDefinition = methods[i];
				var metadata:Array = method.retrieveMetaDataByName(tagName);
				if(metadata.length > 0)
				{
					return method;
				}
			}
			return null;
		}

		/**
		 * @private
		 */
		protected function collectTests():void
		{
			_collectedTests.length = 0;
			_currentIndex = 0;

			var typeDefinition:TypeDefinition = describeType(_target);
			if(!typeDefinition)
			{
				return;
			}

			var methods:Array = typeDefinition.methods;
			var length:int = methods.length;
			for(var i:int = 0; i < length; i++)
			{
				var method:MethodDefinition = methods[i];
				var testName:String = null;
				var testFunction:Function = null;
				var ignore:Boolean = false;
				var async:Boolean = false;
				var asyncTimeout:int = 0;
				var expected:String = null;

				var testMetadata:Array = method.retrieveMetaDataByName(TestMetadata.TEST);
				if(testMetadata.length > 0)
				{
					var testTag:MetaDataDefinition = testMetadata[0];
					var qualifiedName:String = typeDefinition.qualifiedName;
					var qualifiedNameParts:Array = qualifiedName.split(".");
					var lastPart:String = qualifiedNameParts.pop();
					qualifiedName = qualifiedNameParts.join(".");
					if(qualifiedName.length > 0)
					{
						qualifiedName += "::";
					}
					qualifiedName += lastPart;
					testName = qualifiedName + "." + method.name;
					testFunction = _target[method.name];
					if(testTag.getArgsByKey(TestMetadata.TEST__ASYNC).length > 0)
					{
						var timeoutArgs:Array = testTag.getArgsByKey(TestMetadata.TEST__TIMEOUT);
						if(timeoutArgs.length > 0)
						{
							asyncTimeout = parseFloat(timeoutArgs[0].value);
						}
						else
						{
							asyncTimeout = DEFAULT_ASYNC_TIMEOUT;
						}
					}
					var expectedArgs:Array = testTag.getArgsByKey(TestMetadata.TEST__EXPECTED);
					if(expectedArgs.length > 0)
					{
						expected = expectedArgs[0].value;
					}
					var ignoreMetadata:Array = method.retrieveMetaDataByName(TestMetadata.IGNORE);
					if(ignoreMetadata.length > 0)
					{
						ignore = true;
					}
				}
				if(testName !== null)
				{
					_collectedTests.push(new TestInfo(testName, testFunction, ignore, asyncTimeout, expected));
				}
			}
		}

		/**
		 * @private
		 */
		protected function cleanupAsync():void
		{
			_timer.removeEventListener(Timer.TIMER, timer_timerHandler);
			_timer = null;

			AsyncLocator.clearAsyncHandlerForTest(_target);
		}

		/**
		 * @private
		 */
		protected function timer_timerHandler(event:Event):void
		{
			var asyncHandler:AsyncHandler = AsyncHandler(AsyncLocator.getAsyncHandlerForTest(_target));
			cleanupAsync();

			var test:TestInfo = _collectedTests[_currentIndex];
			if(asyncHandler.error)
			{
				_failures = true;
				_notifier.fireTestFailure(new Failure(test.description, asyncHandler.error));
			}
			if(asyncHandler.pendingCount > 0)
			{
				_failures = true;
				_notifier.fireTestFailure(new Failure(test.description, new AssertionError("Test did not complete within specified timeout " + test.asyncTimeout + "ms")));
			}
			
			afterTest(test);
			continueAll();
		}
	}
}

import org.apache.royale.events.Event;
import org.apache.royale.test.async.IAsyncHandler;
import org.apache.royale.test.runners.notification.Failure;
import org.apache.royale.utils.Timer;

class TestInfo
{
	public function TestInfo(name:String, reference:Function, ignore:Boolean, asyncTimeout:int, expected:String)
	{
		this.description = name;
		this.reference = reference;
		this.ignore = ignore;
		this.asyncTimeout = asyncTimeout;
		this.expected = expected;
	}

	public var description:String;
	public var reference:Function;
	public var ignore:Boolean;
	public var asyncTimeout:int;
	public var expected:String;
}

class AsyncHandler implements IAsyncHandler
{
	private var _bodyExecuting:Boolean = false;

	public function get bodyExecuting():Boolean
	{
		return _bodyExecuting;
	}

	public function set bodyExecuting(value:Boolean):void
	{
		_bodyExecuting = value;
	}

	private var _error:Error = null;

	public function get error():Error
	{
		return _error;
	}

	public function get pendingCount():int
	{
		return _timers.length;
	}

	private var _timers:Vector.<Timer> = new <Timer>[];

	public function asyncHandler(callback:Function, delayMS:int):void
	{
		var timerIndex:int = -1;
		var timer:Timer = new Timer(delayMS, 1);
		timer.addEventListener(Timer.TIMER, function(event:Event):void
		{
			timer.removeEventListener(Timer.TIMER, arguments["callee"]);
			var index:int = _timers.indexOf(timer);
			if(index !== -1)
			{
				_timers.splice(index, 1);
			}
			try
			{
				callback();
			}
			catch(error:Error)
			{
				_error = error;
			}
		});
		_timers.push(timer);
		timer.start();
	}
}