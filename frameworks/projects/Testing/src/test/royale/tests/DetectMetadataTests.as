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
	import org.apache.royale.test.TestRunner;
	import org.apache.royale.test.Assert;

	public class DetectMetadataTests
	{
		[Test]
		public function testBeforeTestAfterMetadata():void
		{
			var runner:TestRunner = new TestRunner();
			runner.run(new <Class>[TestClass]);
			Assert.true(TestClass.before);
			Assert.true(TestClass.test);
			Assert.true(TestClass.after);
		}
	}
}

class TestClass
{
	public static var before:Boolean = false;
	public static var after:Boolean = false;
	public static var test:Boolean = false;

	[Before]
	public function testBeforeMetadata():void
	{
		TestClass.before = true;
	}

	[After]
	public function testAfterMetadata():void
	{
		TestClass.after = true;
	}

	[Test]
	public function testTestMetadata():void
	{
		TestClass.test = true;
	}
}