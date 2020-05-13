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

	public class ExpectedTests
	{
		private var _runner:MetadataRunner;

		[Test]
		public function testExpectedWithCorrectException():void
		{
			_runner = new MetadataRunner(CorrectExceptionFixture);
			var notifier:RunNotifier = new RunNotifier();
			var listener:RunListener = new RunListener();
			notifier.addListener(listener);
			_runner.run(notifier);
			Assert.assertTrue(listener.result.successful);
			Assert.assertStrictlyEquals(listener.result.failures.length, 0);
		}

		[Test]
		public function testExpectedWithIncorrectException():void
		{
			_runner = new MetadataRunner(IncorrectExceptionFixture);
			var notifier:RunNotifier = new RunNotifier();
			var listener:RunListener = new RunListener();
			notifier.addListener(listener);
			_runner.run(notifier);
			Assert.assertFalse(listener.result.successful);
			Assert.assertStrictlyEquals(listener.result.failures.length, 1);
		}

		[Test]
		public function testExpectedWithNoException():void
		{
			_runner = new MetadataRunner(NoExceptionFixture);
			var notifier:RunNotifier = new RunNotifier();
			var listener:RunListener = new RunListener();
			notifier.addListener(listener);
			_runner.run(notifier);
			Assert.assertFalse(listener.result.successful);
			Assert.assertStrictlyEquals(listener.result.failures.length, 1);
		}
	}
}

var test1Ran:Boolean = false;
var test2Ran:Boolean = false;

class CorrectExceptionFixture
{
	[Test(expected="RangeError")]
	public function test1():void
	{
		throw new RangeError();
	}
}

class IncorrectExceptionFixture
{
	[Test(expected="RangeError")]
	public function test1():void
	{
		throw new ReferenceError();
	}
}

class NoExceptionFixture
{
	[Test(expected="RangeError")]
	public function test1():void
	{
	}
}

import org.apache.royale.test.runners.notification.IRunListener;
import org.apache.royale.test.runners.notification.Failure;
import org.apache.royale.test.runners.notification.Result;

class RunListener implements IRunListener
{
	public var result:Result = null;

	public function testStarted(description:String):void
	{
	}

	public function testFinished(description:String):void
	{
	}

	public function testFailure(failure:Failure):void
	{
	}

	public function testIgnored(description:String):void
	{
	}

	public function testRunStarted(description:String):void
	{
	}

	public function testRunFinished(result:Result):void
	{
		this.result = result;
	}
}