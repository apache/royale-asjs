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

	public class BeforeClassAndAfterClassTests
	{
		private var _runner:MetadataRunner;

		[Before]
		public function setUp():void
		{
			beforeClassRan = false;
			afterClassRan = false;
			test1Ran = false;
			test2Ran = false;
		}

		[After]
		public function tearDown():void
		{
			beforeClassRan = false;
			afterClassRan = false;
			test1Ran = false;
			test2Ran = false;
			_runner = null;
		}

		[Test]
		public function testBeforeClass():void
		{
			_runner = new MetadataRunner(BeforeClassFixture);

			Assert.assertFalse(beforeClassRan);
			Assert.assertFalse(afterClassRan);
			Assert.assertFalse(test1Ran);
			Assert.assertFalse(test2Ran);

			_runner.run(new RunNotifier());

			Assert.assertTrue(beforeClassRan);
			Assert.assertFalse(afterClassRan);
			Assert.assertTrue(test1Ran);
			Assert.assertTrue(test2Ran);
		}

		[Test]
		public function testAfterClass():void
		{
			_runner = new MetadataRunner(AfterClassFixture);

			Assert.assertFalse(beforeClassRan);
			Assert.assertFalse(afterClassRan);
			Assert.assertFalse(test1Ran);
			Assert.assertFalse(test2Ran);

			_runner.run(new RunNotifier());

			Assert.assertFalse(beforeClassRan);
			Assert.assertTrue(afterClassRan);
			Assert.assertTrue(test1Ran);
			Assert.assertTrue(test2Ran);
		}

		[Test]
		public function testBeforeClassAndAfterClass():void
		{
			_runner = new MetadataRunner(BeforeClassAndAfterClassFixture);

			Assert.assertFalse(beforeClassRan);
			Assert.assertFalse(afterClassRan);
			Assert.assertFalse(test1Ran);
			Assert.assertFalse(test2Ran);

			_runner.run(new RunNotifier());

			Assert.assertTrue(beforeClassRan);
			Assert.assertTrue(afterClassRan);
			Assert.assertTrue(test1Ran);
			Assert.assertTrue(test2Ran);
		}
	}
}

import org.apache.royale.test.Assert;

var beforeClassRan:Boolean = false;
var afterClassRan:Boolean = false;
var test1Ran:Boolean = false;
var test2Ran:Boolean = false;

class BeforeClassFixture
{
	[BeforeClass]
	public function beforeClass():void
	{
		Assert.assertFalse(beforeClassRan);
		beforeClassRan = true;
		Assert.assertFalse(test1Ran);
		Assert.assertFalse(test2Ran);
		Assert.assertFalse(afterClassRan);
	}

	[Test]
	public function test1():void
	{
		Assert.assertFalse(test1Ran);
		test1Ran = true;
		Assert.assertTrue(beforeClassRan);
		Assert.assertFalse(afterClassRan);
	}

	[Test]
	public function test2():void
	{
		Assert.assertFalse(test2Ran);
		test2Ran = true;
		Assert.assertTrue(beforeClassRan);
		Assert.assertFalse(afterClassRan);
	}
}

class AfterClassFixture
{
	[AfterClass]
	public function afterClass():void
	{
		Assert.assertFalse(afterClassRan);
		afterClassRan = true;
		Assert.assertFalse(beforeClassRan);
		Assert.assertTrue(test1Ran);
		Assert.assertTrue(test2Ran);
	}

	[Test]
	public function test1():void
	{
		Assert.assertFalse(test1Ran);
		test1Ran = true;
		Assert.assertFalse(beforeClassRan);
		Assert.assertFalse(afterClassRan);
	}

	[Test]
	public function test2():void
	{
		Assert.assertFalse(test2Ran);
		test2Ran = true;
		Assert.assertFalse(beforeClassRan);
		Assert.assertFalse(afterClassRan);
	}
}

class BeforeClassAndAfterClassFixture
{
	[BeforeClass]
	public function beforeClass():void
	{
		Assert.assertFalse(beforeClassRan);
		beforeClassRan = true;
		Assert.assertFalse(test1Ran);
		Assert.assertFalse(test2Ran);
		Assert.assertFalse(afterClassRan);
	}

	[AfterClass]
	public function afterClass():void
	{
		Assert.assertFalse(afterClassRan);
		afterClassRan = true;
		Assert.assertTrue(beforeClassRan);
		Assert.assertTrue(test1Ran);
		Assert.assertTrue(test2Ran);
	}

	[Test]
	public function test1():void
	{
		Assert.assertFalse(test1Ran);
		test1Ran = true;
		Assert.assertTrue(beforeClassRan);
		Assert.assertFalse(afterClassRan);
	}

	[Test]
	public function test2():void
	{
		Assert.assertFalse(test2Ran);
		test2Ran = true;
		Assert.assertTrue(beforeClassRan);
		Assert.assertFalse(afterClassRan);
	}
}