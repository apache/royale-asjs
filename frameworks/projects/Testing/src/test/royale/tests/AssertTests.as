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
	import org.apache.royale.test.asserts.*;

	public class ScopeTests
	{
		private var _value:String = "hello";

		[Before]
		public function prepare():void
		{
			Assert.strictEqual(this._value, "hello",
				"Function marked with [Before] metadata called with incorrect scope.");
		}

		[After]
		public function cleanup():void
		{
			Assert.strictEqual(this._value, "hello",
				"Function marked with [After] metadata called with incorrect scope.");
		}

		[Test]
		public function testScope():void
		{
			Assert.strictEqual(this._value, "hello",
				"Function marked with [Test] metadata called with incorrect scope.");
		}

		[Test]
		public function testAssertDefined():void
		{
			var foo:String = "";
			assertDefined(foo);
			var baz:Boolean = false;
			assertDefined(baz);
			baz = true;
			assertDefined(baz);
		}

		[Test]
		public function testAssertEquals():void
		{
			var foo:String = "";
			var baz:String = "";
			assertEquals(foo,baz);
			var bVal1:Boolean = true;
			var bVal2:Boolean = true;
			assertEquals(bVal1,bVal2);
			bVal1 = false;
			assertEquals(baz,bVal1);
			foo = baz = "foo";
			assertEquals(foo,baz);
		}

		[Test]
		public function testAssertFalse():void
		{
			var foo:String = "";
			var baz:String = "";
			assertFalse(foo != baz);
			var bVal1:Boolean = true;
			var bVal2:Boolean = true;
			assertFalse(bVal1 != bVal2);
			bVal1 = false;
			assertFalse(baz != bVal1);
			foo = baz = "foo";
			assertFalse(foo != baz);
		}

		[Test]
		public function testAssertEquals():void
		{
			var foo:String = "";
			var baz:String = "";
			assertEquals(foo,baz);
			var bVal1:Boolean = true;
			var bVal2:Boolean = true;
			assertEquals(bVal1,bVal2);
			bVal1 = false;
			assertEquals(baz,bVal1);
			foo = baz = "foo";
			assertEquals(foo,baz);
		}

		[Test]
		public function testAssertNotEquals():void
		{
			var foo:String = "";
			var baz:String = "1";
			assertNotEquals(foo,baz);
			var bVal1:Boolean = true;
			var bVal2:Boolean = false;
			assertNotEquals(bVal1,bVal2);
			assertNotEquals(baz,bVal2);
		}

		[Test]
		public function testAssertNotNull():void
		{
			var foo:String = "";
			var baz:String = "1";
			assertNotNull(foo);
			assertNotNull(baz;
			var bVal1:Boolean = true;
			var bVal2:Boolean = false;
			assertNotNull(bVal1);
			assertNotNull(bVal2);
		}

// assertNotStrictlyEquals.as
// assertNull.as
// assertStrictlyEquals.as
// assertTrue.as
// assertUndefined.as
// fail.as
	}
}