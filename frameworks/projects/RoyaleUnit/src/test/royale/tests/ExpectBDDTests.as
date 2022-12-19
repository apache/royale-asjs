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
	import org.apache.royale.test.bdd.expect;

	public class ExpectBDDTests
	{
		[Test]
		public function testExpectTrueWithTrueGetter():void
		{
			expect(true).is.true;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithFalseGetter():void
		{
			expect(true).is.false;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithNullGetter():void
		{
			expect(true).is.null;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithNaNGetter():void
		{
			expect(true).is.NaN;
		}

		[Test]
		public function testExpectTrueWithEqualsTrue():void
		{
			expect(true).equals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithEqualsFalse():void
		{
			expect(true).equals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithEqualsNull():void
		{
			expect(true).equals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithEqualsUndefined():void
		{
			expect(true).equals(undefined);
		}

		[Test]
		public function testExpectTrueWithEquals1():void
		{
			expect(true).equals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithEquals0():void
		{
			expect(true).equals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithEqualsNaN():void
		{
			expect(true).equals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithEqualsString():void
		{
			expect(true).equals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithEqualsEmptyString():void
		{
			expect(true).equals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithEqualsObject():void
		{
			expect(true).equals({});
		}

		[Test]
		public function testExpectTrueWithStrictlyEqualsTrue():void
		{
			expect(true).strictlyEquals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithStrictlyEqualsFalse():void
		{
			expect(true).strictlyEquals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithStrictlyEqualsNull():void
		{
			expect(true).strictlyEquals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithStrictlyEqualsUndefined():void
		{
			expect(true).strictlyEquals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithStrictlyEquals1():void
		{
			expect(true).strictlyEquals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithStrictlyEquals0():void
		{
			expect(true).strictlyEquals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithStrictlyEqualsNaN():void
		{
			expect(true).strictlyEquals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithStrictlyEqualsString():void
		{
			expect(true).strictlyEquals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithStrictlyEqualsEmptyString():void
		{
			expect(true).strictlyEquals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithStrictlyEqualsObject():void
		{
			expect(true).strictlyEquals({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectTrueWithNotAndTrueGetter():void
		{
			expect(true).is.not.true;
		}

		[Test]
		public function testExpectTrueWithNotAndFalseGetter():void
		{
			expect(true).is.not.false;
		}

		[Test]
		public function testExpectTrueWithNotAndNullGetter():void
		{
			expect(true).is.not.null;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithTrueGetter():void
		{
			expect(false).is.true;
		}

		[Test]
		public function testExpectFalseWithFalseGetter():void
		{
			expect(false).is.false;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithNullGetter():void
		{
			expect(false).is.null;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithNaNGetter():void
		{
			expect(false).is.NaN;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithEqualsTrue():void
		{
			expect(false).equals(true);
		}

		[Test]
		public function testExpectFalseWithEqualsFalse():void
		{
			expect(false).equals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithEqualsNull():void
		{
			expect(false).equals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithEqualsUndefined():void
		{
			expect(false).equals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithEquals1():void
		{
			expect(false).equals(1);
		}

		[Test]
		public function testExpectFalseWithEquals0():void
		{
			expect(false).equals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithEqualsNaN():void
		{
			expect(false).equals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithEqualsString():void
		{
			expect(false).equals("royale");
		}

		[Test]
		public function testExpectFalseWithEqualsEmptyString():void
		{
			expect(false).equals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithEqualsObject():void
		{
			expect(false).equals({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithStrictlyEqualsTrue():void
		{
			expect(false).strictlyEquals(true);
		}

		[Test]
		public function testExpectFalseWithStrictlyEqualsFalse():void
		{
			expect(false).strictlyEquals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithStrictlyEqualsNull():void
		{
			expect(false).strictlyEquals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithStrictlyEqualsUndefined():void
		{
			expect(false).strictlyEquals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithStrictlyEquals1():void
		{
			expect(false).strictlyEquals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithStrictlyEquals0():void
		{
			expect(false).strictlyEquals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithStrictlyEqualsNaN():void
		{
			expect(false).strictlyEquals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithStrictlyEqualsString():void
		{
			expect(false).strictlyEquals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithStrictlyEqualsEmptyString():void
		{
			expect(false).strictlyEquals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithStrictlyEqualsObject():void
		{
			expect(false).strictlyEquals({});
		}

		[Test]
		public function testExpectFalseWithNotAndTrueGetter():void
		{
			expect(false).is.not.true;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectFalseWithNotAndFalseGetter():void
		{
			expect(false).is.not.false;
		}

		[Test]
		public function testExpectFalseWithNotAndNullGetter():void
		{
			expect(false).is.not.null;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithTrueGetter():void
		{
			expect(null).is.true;
		}

		[Test]
		public function testExpectNullWithFalseGetter():void
		{
			expect(null).is.false;
		}

		[Test]
		public function testExpectNullWithNullGetter():void
		{
			expect(null).is.null;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithNaNGetter():void
		{
			expect(null).is.NaN;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithEqualsTrue():void
		{
			expect(null).equals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithEqualsFalse():void
		{
			expect(null).equals(false);
		}

		[Test]
		public function testExpectNullWithEqualsNull():void
		{
			expect(null).equals(null);
		}

		[Test]
		public function testExpectNullWithEqualsUndefined():void
		{
			expect(null).equals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithEquals1():void
		{
			expect(null).equals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithEquals0():void
		{
			expect(null).equals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithEqualsNaN():void
		{
			expect(null).equals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithEqualsString():void
		{
			expect(null).equals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithEqualsEmptyString():void
		{
			expect(null).equals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithEqualsObject():void
		{
			expect(null).equals({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithStrictlyEqualsTrue():void
		{
			expect(null).strictlyEquals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithStrictlyEqualsFalse():void
		{
			expect(null).strictlyEquals(false);
		}

		[Test]
		public function testExpectNullWithStrictlyEqualsNull():void
		{
			expect(null).strictlyEquals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithStrictlyEqualsUndefined():void
		{
			expect(null).strictlyEquals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithStrictlyEquals1():void
		{
			expect(null).strictlyEquals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithStrictlyEquals0():void
		{
			expect(null).strictlyEquals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithStrictlyEqualsNaN():void
		{
			expect(null).strictlyEquals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithStrictlyEqualsString():void
		{
			expect(null).strictlyEquals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithStrictlyEqualsEmptyString():void
		{
			expect(null).strictlyEquals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithStrictlyEqualsObject():void
		{
			expect(null).strictlyEquals({});
		}

		[Test]
		public function testExpectNullWithNotAndTrueGetter():void
		{
			expect(null).is.not.true;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithNotAndFalseGetter():void
		{
			expect(null).is.not.false;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNullWithNotAndNullGetter():void
		{
			expect(null).is.not.null;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithTrueGetter():void
		{
			expect(undefined).is.true;
		}

		[Test]
		public function testExpectUndefinedWithFalseGetter():void
		{
			expect(undefined).is.false;
		}

		[Test]
		public function testExpectUndefinedWithNullGetter():void
		{
			expect(undefined).is.null;
		}

		[Test]
		public function testExpectUndefinedWithNaNGetter():void
		{
			expect(undefined).is.NaN;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithEqualsTrue():void
		{
			expect(undefined).equals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithEqualsFalse():void
		{
			expect(undefined).equals(false);
		}

		[Test]
		public function testExpectUndefinedWithEqualsNull():void
		{
			expect(undefined).equals(null);
		}

		[Test]
		public function testExpectUndefinedWithEqualsUndefined():void
		{
			expect(undefined).equals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithEquals1():void
		{
			expect(undefined).equals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithEquals0():void
		{
			expect(undefined).equals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithEqualsNaN():void
		{
			expect(undefined).equals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithEqualsString():void
		{
			expect(undefined).equals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithEqualsEmptyString():void
		{
			expect(undefined).equals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithEqualsObject():void
		{
			expect(undefined).equals({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithStrictlyEqualsTrue():void
		{
			expect(undefined).strictlyEquals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithStrictlyEqualsFalse():void
		{
			expect(undefined).strictlyEquals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithStrictlyEqualsNull():void
		{
			expect(undefined).strictlyEquals(null);
		}

		[Test]
		public function testExpectUndefinedWithStrictlyEqualsUndefined():void
		{
			expect(undefined).strictlyEquals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithStrictlyEquals1():void
		{
			expect(undefined).strictlyEquals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithStrictlyEquals0():void
		{
			expect(undefined).strictlyEquals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithStrictlyEqualsNaN():void
		{
			expect(undefined).strictlyEquals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithStrictlyEqualsString():void
		{
			expect(undefined).strictlyEquals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithStrictlyEqualsEmptyString():void
		{
			expect(undefined).strictlyEquals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithStrictlyEqualsObject():void
		{
			expect(undefined).strictlyEquals({});
		}

		[Test]
		public function testExpectUndefinedWithNotAndTrueGetter():void
		{
			expect(undefined).is.not.true;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithNotAndFalseGetter():void
		{
			expect(undefined).is.not.false;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectUndefinedWithNotAndNullGetter():void
		{
			expect(undefined).is.not.null;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithTrueGetter():void
		{
			expect(0).is.true;
		}

		[Test]
		public function testExpect0WithFalseGetter():void
		{
			expect(0).is.false;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithNullGetter():void
		{
			expect(0).is.null;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithNaNGetter():void
		{
			expect(0).is.NaN;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithEqualsTrue():void
		{
			expect(0).equals(true);
		}

		[Test]
		public function testExpect0WithEqualsFalse():void
		{
			expect(0).equals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithEqualsNull():void
		{
			expect(0).equals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithEqualsUndefined():void
		{
			expect(0).equals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithEquals1():void
		{
			expect(0).equals(1);
		}

		[Test]
		public function testExpect0WithEquals0():void
		{
			expect(0).equals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithEqualsNaN():void
		{
			expect(0).equals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithEqualsString():void
		{
			expect(0).equals("royale");
		}

		[Test]
		public function testExpect0WithEqualsEmptyString():void
		{
			expect(0).equals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithEqualsObject():void
		{
			expect(0).equals({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithStrictlyEqualsTrue():void
		{
			expect(0).strictlyEquals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithStrictlyEqualsFalse():void
		{
			expect(0).strictlyEquals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithStrictlyEqualsNull():void
		{
			expect(0).strictlyEquals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithStrictlyEqualsUndefined():void
		{
			expect(0).strictlyEquals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithStrictlyEquals1():void
		{
			expect(0).strictlyEquals(1);
		}

		[Test]
		public function testExpect0WithStrictlyEquals0():void
		{
			expect(0).strictlyEquals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithStrictlyEqualsNaN():void
		{
			expect(0).strictlyEquals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithStrictlyEqualsString():void
		{
			expect(0).strictlyEquals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithStrictlyEqualsEmptyString():void
		{
			expect(0).strictlyEquals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithStrictlyEqualsObject():void
		{
			expect(0).strictlyEquals({});
		}

		[Test]
		public function testExpect0WithNotAndTrueGetter():void
		{
			expect(0).is.not.true;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect0WithNotAndFalseGetter():void
		{
			expect(0).is.not.false;
		}

		[Test]
		public function testExpect0WithNotAndNullGetter():void
		{
			expect(0).is.not.null;
		}

		[Test]
		public function testExpect1WithTrueGetter():void
		{
			expect(1).is.true;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithFalseGetter():void
		{
			expect(1).is.false;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithNullGetter():void
		{
			expect(1).is.null;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithNaNGetter():void
		{
			expect(1).is.NaN;
		}

		[Test]
		public function testExpect1WithEqualsTrue():void
		{
			expect(1).equals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithEqualsFalse():void
		{
			expect(1).equals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithEqualsNull():void
		{
			expect(1).equals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithEqualsUndefined():void
		{
			expect(1).equals(undefined);
		}

		[Test]
		public function testExpect1WithEquals1():void
		{
			expect(1).equals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithEquals0():void
		{
			expect(1).equals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithEqualsNaN():void
		{
			expect(1).equals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithEqualsString():void
		{
			expect(1).equals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithEqualsEmptyString():void
		{
			expect(1).equals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithEqualsObject():void
		{
			expect(1).equals({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithStrictlyEqualsTrue():void
		{
			expect(1).strictlyEquals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithStrictlyEqualsFalse():void
		{
			expect(1).strictlyEquals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithStrictlyEqualsNull():void
		{
			expect(1).strictlyEquals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithStrictlyEqualsUndefined():void
		{
			expect(1).strictlyEquals(undefined);
		}

		[Test]
		public function testExpect1WithStrictlyEquals1():void
		{
			expect(1).strictlyEquals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithStrictlyEquals0():void
		{
			expect(1).strictlyEquals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithStrictlyEqualsNaN():void
		{
			expect(1).strictlyEquals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithStrictlyEqualsString():void
		{
			expect(1).strictlyEquals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithStrictlyEqualsEmptyString():void
		{
			expect(1).strictlyEquals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithStrictlyEqualsObject():void
		{
			expect(1).strictlyEquals({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpect1WithNotAndTrueGetter():void
		{
			expect(1).is.not.true;
		}

		[Test]
		public function testExpect1WithNotAndFalseGetter():void
		{
			expect(1).is.not.false;
		}

		[Test]
		public function testExpect1WithNotAndNullGetter():void
		{
			expect(1).is.not.null;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithTrueGetter():void
		{
			expect(NaN).is.true;
		}

		[Test]
		public function testExpectNaNWithFalseGetter():void
		{
			expect(NaN).is.false;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithNullGetter():void
		{
			expect(NaN).is.null;
		}

		[Test]
		public function testExpectNaNWithNaNGetter():void
		{
			expect(NaN).is.NaN;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithEqualsTrue():void
		{
			expect(NaN).equals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithEqualsFalse():void
		{
			expect(NaN).equals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithEqualsNull():void
		{
			expect(NaN).equals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithEqualsUndefined():void
		{
			expect(NaN).equals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithEquals1():void
		{
			expect(NaN).equals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithEquals0():void
		{
			expect(NaN).equals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithEqualsNaN():void
		{
			expect(NaN).equals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithEqualsString():void
		{
			expect(NaN).equals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithEqualsEmptyString():void
		{
			expect(NaN).equals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithEqualsObject():void
		{
			expect(NaN).equals({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithStrictlyEqualsTrue():void
		{
			expect(NaN).strictlyEquals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithStrictlyEqualsFalse():void
		{
			expect(NaN).strictlyEquals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithStrictlyEqualsNull():void
		{
			expect(NaN).strictlyEquals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithStrictlyEqualsUndefined():void
		{
			expect(NaN).strictlyEquals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithStrictlyEquals1():void
		{
			expect(NaN).strictlyEquals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithStrictlyEquals0():void
		{
			expect(NaN).strictlyEquals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaN0WithStrictlyEqualsNaN():void
		{
			expect(NaN).strictlyEquals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithStrictlyEqualsString():void
		{
			expect(NaN).strictlyEquals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithStrictlyEqualsEmptyString():void
		{
			expect(NaN).strictlyEquals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithStrictlyEqualsObject():void
		{
			expect(NaN).strictlyEquals({});
		}

		[Test]
		public function testExpectNaNWithNotAndTrueGetter():void
		{
			expect(NaN).is.not.true;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectNaNWithNotAndFalseGetter():void
		{
			expect(NaN).is.not.false;
		}

		[Test]
		public function testExpectNaNWithNotAndNullGetter():void
		{
			expect(NaN).is.not.null;
		}

		[Test]
		public function testExpectStringWithTrueGetter():void
		{
			expect("royale").is.true;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithFalseGetter():void
		{
			expect("royale").is.false;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithNullGetter():void
		{
			expect("royale").is.null;
		}

		[Test]

		public function testExpectStringWithNaNGetter():void
		{
			expect("royale").is.NaN;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithEqualsTrue():void
		{
			expect("royale").equals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithEqualsFalse():void
		{
			expect("royale").equals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithEqualsNull():void
		{
			expect("royale").equals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithEqualsUndefined():void
		{
			expect("royale").equals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithEquals1():void
		{
			expect("royale").equals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithEquals0():void
		{
			expect("royale").equals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithEqualsNaN():void
		{
			expect("royale").equals(NaN);
		}

		[Test]
		public function testExpectStringWithEqualsString():void
		{
			expect("royale").equals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithEqualsEmptyString():void
		{
			expect("royale").equals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithEqualsObject():void
		{
			expect("royale").equals({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithStrictlyEqualsTrue():void
		{
			expect("royale").strictlyEquals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithStrictlyEqualsFalse():void
		{
			expect("royale").strictlyEquals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithStrictlyEqualsNull():void
		{
			expect("royale").strictlyEquals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithStrictlyEqualsUndefined():void
		{
			expect("royale").strictlyEquals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithStrictlyEquals1():void
		{
			expect("royale").strictlyEquals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithStrictlyEquals0():void
		{
			expect("royale").strictlyEquals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithStrictlyEqualsNaN():void
		{
			expect("royale").strictlyEquals(NaN);
		}

		[Test]
		public function testExpectStringWithStrictlyEqualsString():void
		{
			expect("royale").strictlyEquals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithStrictlyEqualsEmptyString():void
		{
			expect("royale").strictlyEquals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithStrictlyEqualsObject():void
		{
			expect("royale").strictlyEquals({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectStringWithNotAndTrueGetter():void
		{
			expect("royale").is.not.true;
		}

		[Test]
		public function testExpectStringWithNotAndFalseGetter():void
		{
			expect("royale").is.not.false;
		}

		[Test]
		public function testExpectStringWithNotAndNullGetter():void
		{
			expect("royale").is.not.null;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithTrueGetter():void
		{
			expect("").is.true;
		}

		[Test]
		public function testExpectEmptyStringWithFalseGetter():void
		{
			expect("").is.false;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithNullGetter():void
		{
			expect("").is.null;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithNaNGetter():void
		{
			expect("").is.NaN;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithEqualsTrue():void
		{
			expect("").equals(true);
		}

		[Test]
		public function testExpectEmptyStringWithEqualsFalse():void
		{
			expect("").equals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithEqualsNull():void
		{
			expect("").equals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithEqualsUndefined():void
		{
			expect("").equals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithEquals1():void
		{
			expect("").equals(1);
		}

		[Test]
		public function testExpectEmptyStringWithEquals0():void
		{
			expect("").equals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithEqualsNaN():void
		{
			expect("").equals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithEqualsString():void
		{
			expect("").equals("royale");
		}

		[Test]
		public function testExpectEmptyStringWithEqualsEmptyString():void
		{
			expect("").equals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithEqualsObject():void
		{
			expect("").equals({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithStrictlyEqualsTrue():void
		{
			expect("").strictlyEquals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithStrictlyEqualsFalse():void
		{
			expect("").strictlyEquals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithStrictlyEqualsNull():void
		{
			expect("").strictlyEquals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithStrictlyEqualsUndefined():void
		{
			expect("").strictlyEquals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithStrictlyEquals1():void
		{
			expect("").strictlyEquals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithStrictlyEquals0():void
		{
			expect("").strictlyEquals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithStrictlyEqualsNaN():void
		{
			expect("").strictlyEquals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithStrictlyEqualsString():void
		{
			expect("").strictlyEquals("royale");
		}

		[Test]
		public function testExpectEmptyStringWithStrictlyEqualsEmptyString():void
		{
			expect("").strictlyEquals("");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithStrictlyEqualsObject():void
		{
			expect("").strictlyEquals({});
		}

		[Test]
		public function testExpectEmptyStringWithNotAndTrueGetter():void
		{
			expect("").is.not.true;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectEmptyStringWithNotAndFalseGetter():void
		{
			expect("").is.not.false;
		}

		[Test]
		public function testExpectEmptyStringWithNotAndNullGetter():void
		{
			expect("").is.not.null;
		}

		[Test]
		public function testExpectObjectWithTrueGetter():void
		{
			expect({}).is.true;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectObjectWithFalseGetter():void
		{
			expect({}).is.false;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectObjectWithNullGetter():void
		{
			expect({}).is.null;
		}

		[Test]
		public function testExpectObjectWithNaNGetter():void
		{
			expect({}).is.NaN;
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectObjectWithEqualsTrue():void
		{
			expect({}).equals(true);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectObjectWithEqualsFalse():void
		{
			expect({}).equals(false);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectObjectWithEqualsNull():void
		{
			expect({}).equals(null);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectObjectWithEqualsUndefined():void
		{
			expect({}).equals(undefined);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectObjectWithEquals1():void
		{
			expect({}).equals(1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectObjectWithEquals0():void
		{
			expect({}).equals(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectObjectWithEqualsNaN():void
		{
			expect({}).equals(NaN);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectObjectWithEqualsString():void
		{
			expect({}).equals("royale");
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectObjectWithEqualsEmptyString():void
		{
			expect({}).equals("");
		}

		[Test]
		public function testExpectObjectWithEqualsSelf():void
		{
			var obj1:Object = {};
			var obj2:Object = obj1;
			expect(obj1).equals(obj2);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectObjectWithEqualsOtherObject():void
		{
			expect({}).equals({});
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectObjectWithNotAndTrueGetter():void
		{
			expect({}).is.not.true;
		}

		[Test]
		public function testExpectObjectWithNotAndFalseGetter():void
		{
			expect({}).is.not.false;
		}

		[Test]
		public function testExpectObjectWithNotAndNullGetter():void
		{
			expect({}).is.not.null;
		}

		[Test]
		public function testExpectWithinBetween():void
		{
			expect(0).is.within(-1, 1);
		}

		[Test]
		public function testExpectWithinMinimum():void
		{
			expect(-1).is.within(-1, 1);
		}

		[Test]
		public function testExpectWithinMaximum():void
		{
			expect(1).is.within(-1, 1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectWithinOutsideMinimum():void
		{
			expect(-1.0001).is.within(-1, 1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectWithinOutsideMaximum():void
		{
			expect(-1.0001).is.within(-1, 1);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectLessThanMatch():void
		{
			expect(0).lessThan(0);
		}

		[Test]
		public function testExpectLessThanLess():void
		{
			expect(-1).lessThan(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectLessThanGreater():void
		{
			expect(1).lessThan(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectGreaterThanMatch():void
		{
			expect(0).greaterThan(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectGreaterThanLess():void
		{
			expect(-1).greaterThan(0);
		}

		[Test]
		public function testExpectGreaterThanGreater():void
		{
			expect(1).greaterThan(0);
		}

		[Test]
		public function testExpectLessThanOrEqualMatch():void
		{
			expect(0).lessThanOrEqual(0);
		}

		[Test]
		public function testExpectLessThanOrEqualLess():void
		{
			expect(-1).lessThanOrEqual(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectLessThanOrEqualGreater():void
		{
			expect(1).lessThanOrEqual(0);
		}

		[Test]
		public function testExpectGreaterThanOrEqualMatch():void
		{
			expect(0).greaterThanOrEqual(0);
		}

		[Test(expected="org.apache.royale.test.AssertionError")]
		public function testExpectGreaterThanOrEqualLess():void
		{
			expect(-1).greaterThanOrEqual(0);
		}

		[Test]
		public function testExpectGreaterThanOrEqualGreater():void
		{
			expect(1).greaterThanOrEqual(0);
		}
	}
}