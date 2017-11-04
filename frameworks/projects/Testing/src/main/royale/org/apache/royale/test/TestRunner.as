/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */
package org.apache.royale.test
{
	import org.apache.royale.test.errors.AssertionError;
	import org.apache.royale.test.events.TestEvent;

	/**
	 * Dispatched at the start of an individual test.
	 *
	 * @eventType nextgenas.unit.events.TestEvent.TEST_START
	 *
	 * @see #event:testComplete
	 * @see #event:testFail
	 */
	[Event(name="testStart",type="nextgenas.unit.events.TestEvent")]

	/**
	 * Dispatched when an individual test completes successfully. If the test
	 * fails, <code>TestEvent.TEST_FAIL</code> will be dispatched instead.
	 *
	 * @eventType nextgenas.unit.events.TestEvent.TEST_COMPLETE
	 *
	 * @see #event:testFail
	 */
	[Event(name="testComplete",type="nextgenas.unit.events.TestEvent")]

	/**
	 * Dispatched when an individual test fails.
	 *
	 * @eventType nextgenas.unit.events.TestEvent.TEST_FAIL
	 */
	[Event(name="testFail",type="nextgenas.unit.events.TestEvent")]

	/**
	 * Dispatched at the start of all tests.
	 *
	 * @eventType nextgenas.unit.events.TestEvent.TEST_RUN_START
	 *
	 * @see #event:testRunComplete
	 * @see #event:testRunFail
	 */
	[Event(name="testRunStart",type="nextgenas.unit.events.TestEvent")]

	/**
	 * Dispatched when all tests complete successfully. If any tests fail,
	 * <code>TestEvent.TEST_RUN_FAIL</code> will be dispatched instead.
	 *
	 * @eventType nextgenas.unit.events.TestEvent.TEST_RUN_COMPLETE
	 *
	 * @see #event:testRunFail
	 */
	[Event(name="testRunComplete",type="nextgenas.unit.events.TestEvent")]

	/**
	 * Dispatched when all tests have been run, but some failed.
	 *
	 * @eventType nextgenas.unit.events.TestEvent.TEST_RUN_FAIL
	 */
	[Event(name="testRunFail",type="nextgenas.unit.events.TestEvent")]

	/**
	 *
	 */
	public class TestRunner
	{
		/**
		 * Constructor.
		 */
		public function TestRunner()
		{

		}

		/**
		 * @private
		 */
		private var _failCount:int = 0;

		/**
		 * The total number of tests that have failed.
		 *
		 * @see #testCount
		 */
		public function get failCount():int
		{
			return this._failCount;
		}

		/**
		 * @private
		 */
		private var _testCount:int = 0;

		/**
		 * The number of tests that have been run.
		 *
		 * @see #failCount
		 */
		public function get testCount():int
		{
			return this._testCount;
		}

		/**
		 * @private
		 */
		private var _listeners:Object;

		/**
		 * 
		 */
		public function addEventListener(type:String, listener:Function):void
		{
			if(!this._listeners)
			{
				this._listeners = {};
			}
			var listenersOfType:Vector.<Function>;
			if(type in this._listeners)
			{
				listenersOfType = this._listeners[type] as Vector.<Function>
			}
			else
			{
				listenersOfType = new <Function>[];
				this._listeners[type] = listenersOfType;
			}
			if(listenersOfType.indexOf(listener) >= 0)
			{
				//the event is already added
				return;
			}
			listenersOfType[listenersOfType.length] = listener;
		}

		/**
		 * 
		 */
		public function removeEventListener(type:String, listener:Function):void
		{
			if(!this._listeners)
			{
				return;
			}
			if(!(type in this._listeners))
			{
				return;
			}
			var listenersOfType:Vector.<Function> = this._listeners[type] as Vector.<Function>;
			var index:int = listenersOfType.indexOf(listener);
			if(index < 0)
			{
				return;
			}
			//if this is called while the event is being dispatched, we don't
			//want to modify the original array
			listenersOfType = listenersOfType.slice();
			this._listeners[type] = listenersOfType;
			if(index == 0)
			{
				listenersOfType.shift();
			}
			else if(index == listenersOfType.length - 1)
			{
				listenersOfType.pop();
			}
			else
			{
				listenersOfType.splice(index, 1);
			}
		}

		/**
		 * @private
		 */
		private function dispatchEvent(event:TestEvent):void
		{
			if(!this._listeners)
			{
				return;
			}
			var type:String = event.type;
			if(!(type in this._listeners))
			{
				return;
			}
			var listenersOfType:Vector.<Function> = this._listeners[type] as Vector.<Function>;
			var listenerCount:int = listenersOfType.length;
			for(var i:int = 0; i < listenerCount; i++)
			{
				var listener:Function = listenersOfType[i];
				listener(event);
			}
		}

		/**
		 * Runs all tests defined on the specified classes.
		 */
		public function run(tests:Vector.<Class>):void
		{
			this._testCount = 0;
			this._failCount = 0;
			this.dispatchEvent(new TestEvent(TestEvent.TEST_RUN_START));
			var classCount:int = tests.length;
			for(var i:int = 0; i < classCount; i++)
			{
				var testClass:Class = tests[i];
				var test:Object = new testClass();
				this.runTestMethods(test);
			}
			if(this._failCount > 0)
			{
				this.dispatchEvent(new TestEvent(TestEvent.TEST_RUN_FAIL));
			}
			else
			{
				this.dispatchEvent(new TestEvent(TestEvent.TEST_RUN_COMPLETE));
			}
		}

		/**
		 * @private
		 */
		private function runTestMethods(target:Object):void
		{
			var before:Function = collectMethodWithMetadataTag(target, "Before");
			var after:Function = collectMethodWithMetadataTag(target, "After");
			var tests:Vector.<TestInfo> = collectTests(target);
			var testCount:int = tests.length;
			if(testCount == 0)
			{
				throw new Error("No methods found with [Test] metadata. Did you forget to include the -keep-as3-metadata compiler option?")
			}
			for(var i:int = 0; i < testCount; i++)
			{
				try
				{
					var test:TestInfo = tests[i];
					this.dispatchEvent(new TestEvent(TestEvent.TEST_START, test.name));
					if(before != null)
					{
						before.apply(target);
					}
					test.reference.apply(target);
					if(after != null)
					{
						after.apply(target);
					}
					this._testCount++;
					this.dispatchEvent(new TestEvent(TestEvent.TEST_COMPLETE, test.name));
				}
				catch(error:Error)
				{
					this._testCount++;
					this._failCount++;
					this.dispatchEvent(new TestEvent(TestEvent.TEST_FAIL, test.name, error));
				}
			}
		}

		/**
		 * @private
		 */
		private function collectMethodWithMetadataTag(target:Object, tagName:String):Function
		{
			var reflection:Object = target["FLEXJS_REFLECTION_INFO"]();
			var methods:Object = reflection.methods();
			for(var methodName:String in methods)
			{
				var method:Object = methods[methodName];
				if("metadata" in method)
				{
					var declaredBy:String = method.declaredBy;
					var tags:Array = method.metadata();
					var tagsCount:int = tags.length;
					for(var i:int = 0; i < tagsCount; i++)
					{
						var tag:Object = tags[i];
						var methodTagName:String = tag.name;
						if(methodTagName == tagName)
						{
							return target[methodName];
						}
					}
				}
			}
			return null;
		}

		/**
		 * @private
		 */
		private function collectTests(target:Object):Vector.<TestInfo>
		{
			var tests:Vector.<TestInfo> = new <TestInfo>[];
			var reflection:Object = target["FLEXJS_REFLECTION_INFO"]();
			var methods:Object = reflection.methods();
			for(var methodName:String in methods)
			{
				var method:Object = methods[methodName];
				if("metadata" in method)
				{
					var declaredBy:String = method.declaredBy;
					var tags:Array = method.metadata();
					var tagsCount:int = tags.length;
					for(var i:int = 0; i < tagsCount; i++)
					{
						var tag:Object = tags[i];
						var tagName:String = tag.name;
						if(tagName == "Test")
						{
							var reference:Function = target[methodName];
							var info:TestInfo = new TestInfo(declaredBy + "." + methodName, reference);
							tests.push(info);
						}
					}
				}
			}
			return tests;
		}
	}
}

class TestInfo
{
	public function TestInfo(name:String, reference:Function)
	{
		this.name = name;
		this.reference = reference;
	}

	public var name:String;
	public var reference:Function;
}