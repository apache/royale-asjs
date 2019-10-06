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

	public class IgnoreTests
	{
		private var _runner:MetadataRunner;

		[Before]
		public function setUp():void
		{
			test1Ran = false;
			test2Ran = false;
		}

		[After]
		public function tearDown():void
		{
			test1Ran = false;
			test2Ran = false;
			_runner = null;
		}

		[Test]
		public function testIgnore():void
		{
			_runner = new MetadataRunner(IgnoreFixture);

			Assert.assertFalse(test1Ran);
			Assert.assertFalse(test2Ran);

			_runner.run(new RunNotifier());

			Assert.assertTrue(test1Ran);
			Assert.assertFalse(test2Ran);
		}

		[Test]
		public function testIgnoreAll():void
		{
			_runner = new MetadataRunner(IgnoreAllFixture);

			Assert.assertFalse(test1Ran);
			Assert.assertFalse(test2Ran);

			_runner.run(new RunNotifier());

			Assert.assertFalse(test1Ran);
			Assert.assertFalse(test2Ran);
		}
	}
}

var test1Ran:Boolean = false;
var test2Ran:Boolean = false;

class IgnoreFixture
{
	[Test]
	public function test1():void
	{
		test1Ran = true;
	}

	[Ignore]
	[Test]
	public function test2():void
	{
		test2Ran = true;
	}
}

class IgnoreAllFixture
{
	[Ignore]
	[Test]
	public function test1():void
	{
		test1Ran = true;
	}

	[Ignore]
	[Test]
	public function test2():void
	{
		test2Ran = true;
	}
}