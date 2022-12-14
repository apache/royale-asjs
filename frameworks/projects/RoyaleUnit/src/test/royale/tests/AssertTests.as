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

	public class AssertTests
	{
		[Test]
		public function testAssertTrueWithTrue():void
		{
			Assert.assertTrue(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertTrueWithFalse():void
		{
			Assert.assertTrue(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertTrueWith0():void
		{
			Assert.assertTrue(0);
		}

		[Test]
		public function testAssertTrueWith1():void
		{
			Assert.assertTrue(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertTrueWithNaN():void
		{
			Assert.assertTrue(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertTrueWithNull():void
		{
			Assert.assertTrue(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertTrueWithUndefined():void
		{
			Assert.assertTrue(undefined);
		}

		[Test]
		public function testAssertTrueWithObject():void
		{
			Assert.assertTrue({});
		}

		[Test]
		public function testAssertTrueWithString():void
		{
			Assert.assertTrue("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertTrueWithEmptyString():void
		{
			Assert.assertTrue("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertFalseWithTrue():void
		{
			Assert.assertFalse(true);
		}

		[Test]
		public function testAssertFalseWithFalse():void
		{
			Assert.assertFalse(false);
		}

		[Test]
		public function testAssertFalseWith0():void
		{
			Assert.assertFalse(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertFalseWith1():void
		{
			Assert.assertFalse(1);
		}

		[Test]
		public function testAssertFalseWithNaN():void
		{
			Assert.assertFalse(NaN);
		}

		[Test]
		public function testAssertFalseWithNull():void
		{
			Assert.assertFalse(null);
		}

		[Test]
		public function testAssertFalseWithUndefined():void
		{
			Assert.assertFalse(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertFalseWithObject():void
		{
			Assert.assertFalse({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertFalseWithString():void
		{
			Assert.assertFalse("royale");
		}

		[Test]
		public function testAssertFalseWithEmptyString():void
		{
			Assert.assertFalse("");
		}

		[Test]
		public function testAssertNullWithNull():void
		{
			Assert.assertNull(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertNullWithObject():void
		{
			Assert.assertNull({});
		}

		[Test]
		public function testAssertNullWithUndefined():void
		{
			Assert.assertNull(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertNullWithTrue():void
		{
			Assert.assertNull(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertNullWithFalse():void
		{
			Assert.assertNull(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertNullWith0():void
		{
			Assert.assertNull(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertNullWith1():void
		{
			Assert.assertNull(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertNullWithNaN():void
		{
			Assert.assertNull(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertNullWithString():void
		{
			Assert.assertNull("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertNullWithEmptyString():void
		{
			Assert.assertNull("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertNotNullWithNull():void
		{
			Assert.assertNotNull(null);
		}

		[Test]
		public function testAssertNotNullWithObject():void
		{
			Assert.assertNotNull({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertNotNullWithUndefined():void
		{
			Assert.assertNotNull(undefined);
		}

		[Test]
		public function testAssertNotNullWithTrue():void
		{
			Assert.assertNotNull(true);
		}

		[Test]
		public function testAssertNotNullWithFalse():void
		{
			Assert.assertNotNull(false);
		}

		[Test]
		public function testAssertNotNullWith0():void
		{
			Assert.assertNotNull(0);
		}

		[Test]
		public function testAssertNotNullWith1():void
		{
			Assert.assertNotNull(1);
		}

		[Test]
		public function testAssertNotNullWithNaN():void
		{
			Assert.assertNotNull(NaN);
		}

		[Test]
		public function testAssertNotNullWithString():void
		{
			Assert.assertNotNull("royale");
		}

		[Test]
		public function testAssertNotNullWithEmptyString():void
		{
			Assert.assertNotNull("");
		}

		[Test]
		public function testAssertEqualsWithEqualNumbers():void
		{
			Assert.assertEquals(123.4, 123.4);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithNotEqualNumbers():void
		{
			Assert.assertEquals(123.4, 123.5);
		}

		[Test]
		public function testAssertEqualsWithTrue():void
		{
			Assert.assertEquals(true, true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithTrueAndFalse():void
		{
			Assert.assertEquals(true, false);
		}

		[Test]
		public function testAssertEqualsWithTrueAnd1():void
		{
			Assert.assertEquals(true, 1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithTrueAnd0():void
		{
			Assert.assertEquals(true, 0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithTrueAndNaN():void
		{
			Assert.assertEquals(true, NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithTrueAndNull():void
		{
			Assert.assertEquals(true, null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithTrueAndUndefined():void
		{
			Assert.assertEquals(true, undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithTrueAndObject():void
		{
			Assert.assertEquals(true, {});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithTrueAndString():void
		{
			Assert.assertEquals(true, "royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithTrueAndEmptyString():void
		{
			Assert.assertEquals(true, "");
		}

		[Test]
		public function testAssertEqualsWithFalse():void
		{
			Assert.assertEquals(false, false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithFalseAndTrue():void
		{
			Assert.assertEquals(false, true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithFalseAnd1():void
		{
			Assert.assertEquals(false, 1);
		}

		public function testAssertEqualsWithFalseAnd0():void
		{
			Assert.assertEquals(false, 0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithFalseAndNaN():void
		{
			Assert.assertEquals(false, NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithFalseAndNull():void
		{
			Assert.assertEquals(false, null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithFalseAndUndefined():void
		{
			Assert.assertEquals(false, undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithFalseAndObject():void
		{
			Assert.assertEquals(false, {});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithFalseAndString():void
		{
			Assert.assertEquals(false, "royale");
		}

		[Test]
		public function testAssertEqualsWithFalseAndEmptyString():void
		{
			Assert.assertEquals(false, "");
		}

		[Test]
		public function testAssertEqualsWithNull():void
		{
			Assert.assertEquals(null, null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithNullAnd1():void
		{
			Assert.assertEquals(null, 1);
		}

		public function testAssertEqualsWithNullAnd0():void
		{
			Assert.assertEquals(null, 0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithNullAndNaN():void
		{
			Assert.assertEquals(null, NaN);
		}

		[Test]
		public function testAssertEqualsWithNullAndUndefined():void
		{
			Assert.assertEquals(null, undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithNullAndObject():void
		{
			Assert.assertEquals(null, {});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithNullAndString():void
		{
			Assert.assertEquals(null, "royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithNullAndEmptyString():void
		{
			Assert.assertEquals(null, "");
		}

		[Test]
		public function testAssertEqualsWithUndefined():void
		{
			Assert.assertEquals(undefined, undefined);
		}

		[Test]
		public function testAssertEqualsWithUndefinedAndNull():void
		{
			Assert.assertEquals(undefined, null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithUndefinedAnd1():void
		{
			Assert.assertEquals(undefined, 1);
		}

		public function testAssertEqualsWithUndefinedAnd0():void
		{
			Assert.assertEquals(undefined, 0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithUndefinedAndNaN():void
		{
			Assert.assertEquals(undefined, NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithUndefinedAndObject():void
		{
			Assert.assertEquals(undefined, {});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithUndefinedAndString():void
		{
			Assert.assertEquals(undefined, "royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithUndefinedAndEmptyString():void
		{
			Assert.assertEquals(undefined, "");
		}

		[Test]
		public function testAssertEqualsWithEqualObjects():void
		{
			var obj1:Object = {};
			var obj2:Object = obj1;
			Assert.assertEquals(obj1, obj2);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertEqualsWithNotEqualObjects():void
		{
			Assert.assertEquals({}, {});
		}

		[Test]
		public function testAssertStrictlyEqualsWithEqualNumbers():void
		{
			Assert.assertStrictlyEquals(123.4, 123.4);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithNotEqualNumbers():void
		{
			Assert.assertStrictlyEquals(123.4, 123.5);
		}

		[Test]
		public function testAssertStrictlyEqualsWithTrue():void
		{
			Assert.assertStrictlyEquals(true, true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithTrueAndFalse():void
		{
			Assert.assertStrictlyEquals(true, false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithTrueAnd1():void
		{
			Assert.assertStrictlyEquals(true, 1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithTrueAnd0():void
		{
			Assert.assertStrictlyEquals(true, 0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithTrueAndNaN():void
		{
			Assert.assertStrictlyEquals(true, NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithTrueAndNull():void
		{
			Assert.assertStrictlyEquals(true, null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithTrueAndUndefined():void
		{
			Assert.assertStrictlyEquals(true, undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithTrueAndObject():void
		{
			Assert.assertStrictlyEquals(true, {});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithTrueAndString():void
		{
			Assert.assertStrictlyEquals(true, "royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithTrueAndEmptyString():void
		{
			Assert.assertStrictlyEquals(true, "");
		}

		[Test]
		public function testAssertStrictlyEqualsWithFalse():void
		{
			Assert.assertStrictlyEquals(false, false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithFalseAndTrue():void
		{
			Assert.assertStrictlyEquals(false, true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithFalseAnd1():void
		{
			Assert.assertStrictlyEquals(false, 1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithFalseAnd0():void
		{
			Assert.assertStrictlyEquals(false, 0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithFalseAndNaN():void
		{
			Assert.assertStrictlyEquals(false, NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithFalseAndNull():void
		{
			Assert.assertStrictlyEquals(false, null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithFalseAndUndefined():void
		{
			Assert.assertStrictlyEquals(false, undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithFalseAndObject():void
		{
			Assert.assertStrictlyEquals(false, {});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithFalseAndString():void
		{
			Assert.assertStrictlyEquals(false, "royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithFalseAndEmptyString():void
		{
			Assert.assertStrictlyEquals(false, "");
		}

		[Test]
		public function testAssertStrictlyEqualsWithNull():void
		{
			Assert.assertStrictlyEquals(null, null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithNullAnd1():void
		{
			Assert.assertStrictlyEquals(null, 1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithNullAnd0():void
		{
			Assert.assertStrictlyEquals(null, 0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithNullAndNaN():void
		{
			Assert.assertStrictlyEquals(null, NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithNullAndUndefined():void
		{
			Assert.assertStrictlyEquals(null, undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithNullAndObject():void
		{
			Assert.assertStrictlyEquals(null, {});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithNullAndString():void
		{
			Assert.assertStrictlyEquals(null, "royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithNullAndEmptyString():void
		{
			Assert.assertStrictlyEquals(null, "");
		}

		[Test]
		public function testAssertStrictlyEqualsWithUndefined():void
		{
			Assert.assertStrictlyEquals(undefined, undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithUndefinedAndNull():void
		{
			Assert.assertStrictlyEquals(undefined, null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithUndefinedAnd1():void
		{
			Assert.assertStrictlyEquals(undefined, 1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithUndefinedAnd0():void
		{
			Assert.assertStrictlyEquals(undefined, 0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithUndefinedAndNaN():void
		{
			Assert.assertStrictlyEquals(undefined, NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithUndefinedAndObject():void
		{
			Assert.assertStrictlyEquals(undefined, {});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithUndefinedAndString():void
		{
			Assert.assertStrictlyEquals(undefined, "royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithUndefinedAndEmptyString():void
		{
			Assert.assertStrictlyEquals(undefined, "");
		}

		[Test]
		public function testAssertStrictlyEqualsWithEqualObjects():void
		{
			var obj1:Object = {};
			var obj2:Object = obj1;
			Assert.assertStrictlyEquals(obj1, obj2);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testAssertStrictlyEqualsWithNotEqualObjects():void
		{
			Assert.assertStrictlyEquals({}, {});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFail():void
		{
			Assert.fail();
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailTrueWithTrue():void
		{
			Assert.failTrue(true);
		}

		[Test]
		public function testFailTrueWithFalse():void
		{
			Assert.failTrue(false);
		}

		[Test]
		public function testFailTrueWith0():void
		{
			Assert.failTrue(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailTrueWith1():void
		{
			Assert.failTrue(1);
		}

		[Test]
		public function testFailTrueWithNaN():void
		{
			Assert.failTrue(NaN);
		}

		[Test]
		public function testFailTrueWithNull():void
		{
			Assert.failTrue(null);
		}

		[Test]
		public function testFailTrueWithUndefined():void
		{
			Assert.failTrue(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailTrueWithObject():void
		{
			Assert.failTrue({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailTrueWithString():void
		{
			Assert.failTrue("royale");
		}

		[Test]
		public function testFailTrueWithEmptyString():void
		{
			Assert.failTrue("");
		}

		[Test]
		public function testFailFalseWithTrue():void
		{
			Assert.failFalse(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailFalseWithFalse():void
		{
			Assert.failFalse(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailFalseWith0():void
		{
			Assert.failFalse(0);
		}

		[Test]
		public function testFailFalseWith1():void
		{
			Assert.failFalse(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailFalseWithNaN():void
		{
			Assert.failFalse(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailFalseWithNull():void
		{
			Assert.failFalse(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailFalseWithUndefined():void
		{
			Assert.failFalse(undefined);
		}

		[Test]
		public function testFailFalseWithObject():void
		{
			Assert.failFalse({});
		}

		[Test]
		public function testFailFalseWithString():void
		{
			Assert.failFalse("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailFalseWithEmptyString():void
		{
			Assert.failFalse("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailNullWithNull():void
		{
			Assert.failNull(null);
		}

		[Test]
		public function testFailNullWithObject():void
		{
			Assert.failNull({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailNullWithUndefined():void
		{
			Assert.failNull(undefined);
		}

		[Test]
		public function testFailNullWithTrue():void
		{
			Assert.failNull(true);
		}

		[Test]
		public function testFailNullWithFalse():void
		{
			Assert.failNull(false);
		}

		[Test]
		public function testFailNullWith0():void
		{
			Assert.failNull(0);
		}

		[Test]
		public function testFailNullWith1():void
		{
			Assert.failNull(1);
		}

		[Test]
		public function testFailNullWithNaN():void
		{
			Assert.failNull(NaN);
		}

		[Test]
		public function testFailNullWithString():void
		{
			Assert.failNull("royale");
		}

		[Test]
		public function testFailNullWithEmptyString():void
		{
			Assert.failNull("");
		}

		[Test]
		public function testFailNotNullWithNull():void
		{
			Assert.failNotNull(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailNotNullWithObject():void
		{
			Assert.failNotNull({});
		}

		[Test]
		public function testFailNotNullWithUndefined():void
		{
			Assert.failNotNull(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailNotNullWithTrue():void
		{
			Assert.failNotNull(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailNotNullWithFalse():void
		{
			Assert.failNotNull(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailNotNullWith0():void
		{
			Assert.failNotNull(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailNotNullWith1():void
		{
			Assert.failNotNull(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailNotNullWithNaN():void
		{
			Assert.failNotNull(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailNotNullWithString():void
		{
			Assert.failNotNull("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testFailNotNullWithEmptyString():void
		{
			Assert.failNotNull("");
		}
	}
}