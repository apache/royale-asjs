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
	import org.apache.royale.test.runners.notification.RunNotifier;
	import org.apache.royale.test.runners.MetadataRunner;
	import org.apache.royale.test.Assert;

	public class RunNotifierTests
	{
		private var _notifier:RunNotifier;

		[Before]
		public function setUp():void
		{
		}

		[After]
		public function tearDown():void
		{
			_notifier = null;
		}

		[Test]
		public function testRunNotifierWithZeroTests():void
		{
			var notifier:RunNotifier = new RunNotifier();
			var listener:RunListener = new RunListener();
			notifier.addListener(listener);
			var runner:MetadataRunner = new MetadataRunner(ZeroTests);
			var caughtError:Error = null;
			try
			{
				runner.run(notifier);
			}
			catch(error:Error)
			{
				caughtError = error;
			}
			Assert.assertNotNull(caughtError);
			Assert.assertTrue(listener.runStarted);
			Assert.assertStrictlyEquals(listener.startedTests.length, 0);
			Assert.assertStrictlyEquals(listener.finishedTests.length, 0);
			Assert.assertStrictlyEquals(listener.ignoredTests.length, 0);
			Assert.assertStrictlyEquals(listener.failures.length, 0);
			Assert.assertNull(listener.result);
		}

		[Test]
		public function testRunNotifierWithOnePassingTest():void
		{
			var notifier:RunNotifier = new RunNotifier();
			var listener:RunListener = new RunListener();
			notifier.addListener(listener);
			var runner:MetadataRunner = new MetadataRunner(OnePassingTest);
			runner.run(notifier);
			Assert.assertTrue(listener.runStarted);
			Assert.assertStrictlyEquals(listener.startedTests.length, 1);
			Assert.assertStrictlyEquals(listener.finishedTests.length, 1);
			Assert.assertStrictlyEquals(listener.ignoredTests.length, 0);
			Assert.assertStrictlyEquals(listener.failures.length, 0);
			Assert.assertNotNull(listener.result);
			Assert.assertStrictlyEquals(listener.result.failCount, 0);
			Assert.assertStrictlyEquals(listener.result.failures.length, 0);
			Assert.assertTrue(listener.result.successful);
		}

		[Test]
		public function testRunNotifierWithOneFailingTest():void
		{
			var notifier:RunNotifier = new RunNotifier();
			var listener:RunListener = new RunListener();
			notifier.addListener(listener);
			var runner:MetadataRunner = new MetadataRunner(OneFailingTest);
			runner.run(notifier);
			Assert.assertTrue(listener.runStarted);
			Assert.assertStrictlyEquals(listener.startedTests.length, 1);
			Assert.assertStrictlyEquals(listener.finishedTests.length, 1);
			Assert.assertStrictlyEquals(listener.ignoredTests.length, 0);
			Assert.assertStrictlyEquals(listener.failures.length, 1);
			Assert.assertNotNull(listener.result);
			Assert.assertStrictlyEquals(listener.result.failCount, 1);
			Assert.assertStrictlyEquals(listener.result.failures.length, 1);
			Assert.assertFalse(listener.result.successful);
		}

		[Test]
		public function testRunNotifierWithMultipleTests():void
		{
			var notifier:RunNotifier = new RunNotifier();
			var listener:RunListener = new RunListener();
			notifier.addListener(listener);
			var runner:MetadataRunner = new MetadataRunner(MultipleTests);
			runner.run(notifier);
			Assert.assertTrue(listener.runStarted);
			Assert.assertStrictlyEquals(listener.startedTests.length, 2);
			Assert.assertStrictlyEquals(listener.finishedTests.length, 2);
			Assert.assertStrictlyEquals(listener.ignoredTests.length, 1);
			Assert.assertStrictlyEquals(listener.failures.length, 1);
			Assert.assertNotNull(listener.result);
			Assert.assertStrictlyEquals(listener.result.failCount, 1);
			Assert.assertStrictlyEquals(listener.result.failures.length, 1);
			Assert.assertFalse(listener.result.successful);
		}
	}
}

import org.apache.royale.test.runners.notification.IRunListener;
import org.apache.royale.test.runners.notification.Failure;
import org.apache.royale.test.runners.notification.Result;
import org.apache.royale.test.Assert;

class RunListener implements IRunListener
{
	public var startedTests:Vector.<String> = new <String>[];
	public var finishedTests:Vector.<String> = new <String>[];
	public var ignoredTests:Vector.<String> = new <String>[];
	public var failures:Vector.<Failure> = new <Failure>[];
	public var runStarted:Boolean = false;
	public var result:Result = null;

	public function testStarted(description:String):void
	{
		startedTests.push(description);
	}

	public function testFinished(description:String):void
	{
		finishedTests.push(description);
	}

	public function testFailure(failure:Failure):void
	{
		failures.push(failure);
	}

	public function testIgnored(description:String):void
	{
		ignoredTests.push(description);
	}

	public function testRunStarted(description:String):void
	{
		runStarted = true;
	}

	public function testRunFinished(result:Result):void
	{
		this.result = result;
	}
}

class ZeroTests
{
	
}

class OnePassingTest
{
	[Test]
	public function passing():void
	{
	}
}

class OneFailingTest
{
	[Test]
	public function failing():void
	{
		Assert.fail();
	}
}

class MultipleTests
{
	[Test]
	public function passing():void
	{
	}

	[Test]
	public function failing():void
	{
		Assert.fail();
	}

	[Ignore]
	[Test]
	public function ignored():void
	{
		Assert.fail();
	}
}