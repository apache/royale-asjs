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
package tests
{
	import org.apache.royale.test.Assert;
	import org.apache.royale.test.runners.MetadataRunner;
	import org.apache.royale.test.runners.notification.RunNotifier;
	import org.apache.royale.test.runners.notification.IRunListener;
	import org.apache.royale.test.async.Async;

	public class AsyncTests
	{
		private var _runner:MetadataRunner;

		[Before]
		public function setUp():void
		{
		}

		[After]
		public function tearDown():void
		{
			_runner = null;
		}

		[Test]
		public function testRunNotFinishedAfterAsyncTest():void
		{
			var notifier:RunNotifier = new RunNotifier();
			var listener:AsyncListener = new AsyncListener();
			notifier.addListener(listener);
			_runner = new MetadataRunner(AsyncFixture);
			_runner.run(notifier);
			Assert.assertTrue(listener.runStarted);
			Assert.assertFalse(listener.runFinished);
			//we can't check finished count because the order of tests cannot be
			//determined. the async test may be run first.
			Assert.assertStrictlyEquals(listener.failureCount, 0);
			Assert.assertStrictlyEquals(listener.ignoreCount, 0);
			Assert.assertTrue(listener.active.indexOf("AsyncTests::AsyncFixture.test2") > 0);
			_runner.pleaseStop();
		}

		[Test(async)]
		public function testRunFinishesAsynchronously():void
		{
			var notifier:RunNotifier = new RunNotifier();
			var listener:AsyncListener = new AsyncListener();
			notifier.addListener(listener);
			_runner = new MetadataRunner(AsyncFixture);
			_runner.run(notifier);
			Async.delayCall(this, function():void
			{
				Assert.assertTrue(listener.runStarted);
				Assert.assertTrue(listener.runFinished);
				Assert.assertStrictlyEquals(listener.finishedCount, 2);
				Assert.assertStrictlyEquals(listener.failureCount, 0);
				Assert.assertStrictlyEquals(listener.ignoreCount, 0);
				Assert.assertNull(listener.active);
				Assert.assertTrue(listener.result.successful);
			}, 400);
		}

		[Test(async)]
		public function testAsyncTestWithSynchronousFail():void
		{
			var notifier:RunNotifier = new RunNotifier();
			var listener:AsyncListener = new AsyncListener();
			notifier.addListener(listener);
			_runner = new MetadataRunner(AsyncFailFixture);
			_runner.run(notifier);
			Assert.assertTrue(listener.runStarted);
			Assert.assertTrue(listener.runFinished);
			Assert.assertStrictlyEquals(listener.finishedCount, 1);
			Assert.assertStrictlyEquals(listener.failureCount, 1);
			Assert.assertStrictlyEquals(listener.ignoreCount, 0);
			Assert.assertNull(listener.active);
			Assert.assertFalse(listener.result.successful);
		}

		[Test(async)]
		public function testAsyncTestWithFailInsideDelayCall():void
		{
			var notifier:RunNotifier = new RunNotifier();
			var listener:AsyncListener = new AsyncListener();
			notifier.addListener(listener);
			_runner = new MetadataRunner(AsyncFailWithDelayCallFixture);
			_runner.run(notifier);
			Async.delayCall(this, function():void
			{
				Assert.assertTrue(listener.runStarted);
				Assert.assertTrue(listener.runFinished);
				Assert.assertStrictlyEquals(listener.finishedCount, 1);
				Assert.assertStrictlyEquals(listener.failureCount, 1);
				Assert.assertStrictlyEquals(listener.ignoreCount, 0);
				Assert.assertNull(listener.active);
				Assert.assertFalse(listener.result.successful);
			}, 400);
		}

		[Test(async)]
		public function testAsyncTestFinishesWithFailOnEventAndNoDispatch():void
		{
			var notifier:RunNotifier = new RunNotifier();
			var listener:AsyncListener = new AsyncListener();
			notifier.addListener(listener);
			_runner = new MetadataRunner(AsyncFailOnEventWithoutDispatchFixture);
			_runner.run(notifier);
			Async.delayCall(this, function():void
			{
				Assert.assertTrue(listener.runStarted);
				Assert.assertTrue(listener.runFinished);
				Assert.assertStrictlyEquals(listener.finishedCount, 1);
				Assert.assertStrictlyEquals(listener.failureCount, 0);
				Assert.assertStrictlyEquals(listener.ignoreCount, 0);
				Assert.assertNull(listener.active);
				Assert.assertTrue(listener.result.successful);
			}, 400);
		}

		[Test(async)]
		public function testAsyncTestFailsWithFailOnEventAndDispatch():void
		{
			var notifier:RunNotifier = new RunNotifier();
			var listener:AsyncListener = new AsyncListener();
			notifier.addListener(listener);
			_runner = new MetadataRunner(AsyncFailOnEventWithDispatchFixture);
			_runner.run(notifier);
			Async.delayCall(this, function():void
			{
				Assert.assertTrue(listener.runStarted);
				Assert.assertTrue(listener.runFinished);
				Assert.assertStrictlyEquals(listener.finishedCount, 1);
				Assert.assertStrictlyEquals(listener.failureCount, 1);
				Assert.assertStrictlyEquals(listener.ignoreCount, 0);
				Assert.assertNull(listener.active);
				Assert.assertFalse(listener.result.successful);
			}, 400);
		}

		[Test(async)]
		public function testAsyncTestFinishesWithRequireEventAndDispatch():void
		{
			var notifier:RunNotifier = new RunNotifier();
			var listener:AsyncListener = new AsyncListener();
			notifier.addListener(listener);
			_runner = new MetadataRunner(AsyncRequireEventWithDispatchFixture);
			_runner.run(notifier);
			Async.delayCall(this, function():void
			{
				Assert.assertTrue(listener.runStarted);
				Assert.assertTrue(listener.runFinished);
				Assert.assertStrictlyEquals(listener.finishedCount, 1);
				Assert.assertStrictlyEquals(listener.failureCount, 0);
				Assert.assertStrictlyEquals(listener.ignoreCount, 0);
				Assert.assertNull(listener.active);
				Assert.assertTrue(listener.result.successful);
			}, 400);
		}

		[Test(async)]
		public function testAsyncTestFailsWithRequireEventAndNoDispatch():void
		{
			var notifier:RunNotifier = new RunNotifier();
			var listener:AsyncListener = new AsyncListener();
			notifier.addListener(listener);
			_runner = new MetadataRunner(AsyncRequireEventWithoutDispatchFixture);
			_runner.run(notifier);
			Async.delayCall(this, function():void
			{
				Assert.assertTrue(listener.runStarted);
				Assert.assertTrue(listener.runFinished);
				Assert.assertStrictlyEquals(listener.finishedCount, 1);
				Assert.assertStrictlyEquals(listener.failureCount, 1);
				Assert.assertStrictlyEquals(listener.ignoreCount, 0);
				Assert.assertNull(listener.active);
				Assert.assertFalse(listener.result.successful);
			}, 400);
		}
	}
}

import org.apache.royale.test.runners.notification.IRunListener;
import org.apache.royale.test.runners.notification.Failure;
import org.apache.royale.test.runners.notification.Result;
import org.apache.royale.test.Assert;
import org.apache.royale.test.async.Async;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.events.Event;

class AsyncFixture
{
	[Test]
	public function test1():void
	{
	}

	[Test(async,timeout="100")]
	public function test2():void
	{
	}
}

class AsyncFailFixture
{
	[Test(async,timeout="100")]
	public function test1():void
	{
		Assert.fail();
	}
}

class AsyncFailWithDelayCallFixture
{
	[Test(async,timeout="200")]
	public function test1():void
	{
		Async.delayCall(this, function():void
		{
			Assert.fail();
		}, 100);
	}
}

class AsyncFailOnEventWithoutDispatchFixture
{
	[Test(async,timeout="200")]
	public function test1():void
	{
		var dispatcher:EventDispatcher = new EventDispatcher();
		Async.failOnEvent(this, dispatcher, Event.CHANGE, 100);
	}
}

class AsyncFailOnEventWithDispatchFixture
{
	[Test(async,timeout="300")]
	public function test1():void
	{
		var dispatcher:EventDispatcher = new EventDispatcher();
		Async.failOnEvent(this, dispatcher, Event.CHANGE, 200);
		Async.delayCall(this, function():void
		{
			dispatcher.dispatchEvent(new Event(Event.CHANGE));
			Assert.fail();
		}, 100);
	}
}

class AsyncRequireEventWithDispatchFixture
{
	[Test(async,timeout="300")]
	public function test1():void
	{
		var dispatcher:EventDispatcher = new EventDispatcher();
		Async.requireEvent(this, dispatcher, Event.CHANGE, 200);
		Async.delayCall(this, function():void
		{
			dispatcher.dispatchEvent(new Event(Event.CHANGE));
		}, 100);
	}
}

class AsyncRequireEventWithoutDispatchFixture
{
	[Test(async,timeout="200")]
	public function test1():void
	{
		var dispatcher:EventDispatcher = new EventDispatcher();
		Async.requireEvent(this, dispatcher, Event.CHANGE, 100);
	}
}

class AsyncListener implements IRunListener
{
	public var runStarted:Boolean = false;
	public var runFinished:Boolean = false;
	public var active:String = null;
	public var finishedCount:int = 0;
	public var failureCount:int = 0;
	public var ignoreCount:int = 0;
	public var result:Result = null;

	public function testStarted(description:String):void
	{
		active = description;
	}

	public function testFinished(description:String):void
	{
		active = null;
		finishedCount++;
	}

	public function testFailure(failure:Failure):void
	{
		failureCount++;
	}

	public function testIgnored(description:String):void
	{
		ignoreCount++;
	}

	public function testRunStarted(description:String):void
	{
		runStarted = true;
	}

	public function testRunFinished(result:Result):void
	{
		this.result = result;
		runFinished = true;
	}
}