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
			Assert.assertStrictlyEquals(listener.finishedCount, 1);
			Assert.assertStrictlyEquals(listener.failureCount, 0);
			Assert.assertStrictlyEquals(listener.ignoreCount, 0);
			Assert.assertEquals(listener.active, "tests.AsyncTests::AsyncFixture.test2");
			_runner.pleaseStop();
		}
	}
}

import org.apache.royale.test.runners.notification.IRunListener;
import org.apache.royale.test.runners.notification.Failure;
import org.apache.royale.test.runners.notification.Result;

class AsyncFixture
{
	[Test]
	public function test1():void
	{
	}

	[Test(async)]
	public function test2():void
	{
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
		runFinished = true;
	}
}