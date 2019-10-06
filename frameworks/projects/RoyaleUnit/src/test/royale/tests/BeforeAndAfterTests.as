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

	public class BeforeAndAfterTests
	{
		private var _runner:MetadataRunner;

		[Before]
		public function setUp():void
		{
			beforeRan = false;
			afterRan = false;
			testRan = false;
		}

		[After]
		public function tearDown():void
		{
			beforeRan = false;
			afterRan = false;
			testRan = false;
			_runner = null;
		}

		[Test]
		public function testBefore():void
		{
			_runner = new MetadataRunner(BeforeFixture);

			Assert.assertFalse(beforeRan);
			Assert.assertFalse(afterRan);
			Assert.assertFalse(testRan);

			_runner.run(new RunNotifier());

			Assert.assertTrue(beforeRan);
			Assert.assertFalse(afterRan);
			Assert.assertTrue(testRan);
		}

		[Test]
		public function testAfter():void
		{
			_runner = new MetadataRunner(AfterFixture);

			Assert.assertFalse(beforeRan);
			Assert.assertFalse(afterRan);
			Assert.assertFalse(testRan);

			_runner.run(new RunNotifier());

			Assert.assertFalse(beforeRan);
			Assert.assertTrue(afterRan);
			Assert.assertTrue(testRan);
		}

		[Test]
		public function testBeforeAndAfter():void
		{
			_runner = new MetadataRunner(BeforeAndAfterFixture);

			Assert.assertFalse(beforeRan);
			Assert.assertFalse(afterRan);
			Assert.assertFalse(testRan);

			_runner.run(new RunNotifier());

			Assert.assertTrue(beforeRan);
			Assert.assertTrue(afterRan);
			Assert.assertTrue(testRan);
		}
	}
}

import org.apache.royale.test.Assert;

var beforeRan:Boolean = false;
var afterRan:Boolean = false;
var testRan:Boolean = false;

class BeforeFixture
{
	[Before]
	public function before():void
	{
		Assert.assertFalse(beforeRan);
		beforeRan = true;
		Assert.assertFalse(testRan);
		Assert.assertFalse(afterRan);
	}

	[Test]
	public function test():void
	{
		Assert.assertFalse(testRan);
		testRan = true;
		Assert.assertTrue(beforeRan);
		Assert.assertFalse(afterRan);
	}
}

class AfterFixture
{
	[After]
	public function after():void
	{
		Assert.assertFalse(afterRan);
		afterRan = true;
		Assert.assertFalse(beforeRan);
		Assert.assertTrue(testRan);
	}

	[Test]
	public function test():void
	{
		Assert.assertFalse(testRan);
		testRan = true;
		Assert.assertFalse(beforeRan);
		Assert.assertFalse(afterRan);
	}
}

class BeforeAndAfterFixture
{
	[Before]
	public function before():void
	{
		Assert.assertFalse(beforeRan);
		beforeRan = true;
		Assert.assertFalse(testRan);
		Assert.assertFalse(afterRan);
	}

	[After]
	public function after():void
	{
		Assert.assertFalse(afterRan);
		afterRan = true;
		Assert.assertTrue(beforeRan);
		Assert.assertTrue(testRan);
	}

	[Test]
	public function test():void
	{
		Assert.assertFalse(testRan);
		testRan = true;
		Assert.assertTrue(beforeRan);
		Assert.assertFalse(afterRan);
	}
}