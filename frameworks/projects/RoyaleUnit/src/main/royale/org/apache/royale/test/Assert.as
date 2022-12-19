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
package org.apache.royale.test
{
	/**
	 * A set of assertion methods. Messages only displayed when an assert fails.
	 */
	public class Assert
	{
		/**
		 * Asserts that the provided values are strictly equal (equivalent to
		 * the <code>===</code> operator).
		 */
		public static function assertStrictlyEquals(actual:*, expected:*, message:String = null):void
		{
			failNotStrictlyEquals(actual, expected, message);
		}

		/**
		 * Asserts that the provided values are not strictly equal (equivalent
		 * to the <code>!==</code> operator).
		 */
		public static function assertNotStrictlyEquals(actual:*, expected:*, message:String = null):void
		{
			failStrictlyEquals(actual, expected, message);
		}

		/**
		 * Asserts that the provided values are loosely equal (equivalent to
		 * the <code>==</code> operator).
		 * 
		 * <p>Note: Type coercion may occur. For a strict comparison, without
		 * type coercion, use
		 * <code>assertStrictlyEquals(actual, expected, message)</code>
		 * instead.</p>
		 * 
		 * @see Assert.assertStrictlyEquals()
		 */
		public static function assertEquals(actual:*, expected:*, message:String = null):void
		{
			failNotEquals(actual, expected, message);
		}

		/**
		 * Asserts that the provided values are not loosely equal (equivalent to
		 * the <code>!=</code> operator).
		 * 
		 * <p>Note: Type coercion may occur. For a strict comparison, without
		 * type coercion, use
		 * <code>assertNotStrictlyEquals(actual, expected, message)</code>
		 * instead.</p>
		 * 
		 * @see Assert.assertNotStrictlyEquals()
		 */
		public static function assertNotEquals(actual:*, expected:*, message:String = null):void
		{
			failEquals(actual, expected, message);
		}

		/**
		 * Asserts that the provided value is true (equivalent to testing the
		 * value in an <code>if(value)</code> statement).
		 * 
		 * <p>Note: Type coercion may occur. The assertion will pass for any
		 * value that is considered <em>truthy</em>. For strict comparison to
		 * true, without type coercion, use
		 * <code>assertStrictlyEquals(value, true, message)</code> instead.</p>
		 */
		public static function assertTrue(value:*, message:String = null):void
		{
			failFalse(value, message);
		}

		/**
		 * Asserts that the provided value is false (equivalent to testing the
		 * value in an <code>if(!value)</code> statement).
		 * 
		 * <p>Note: Type coercion may occur. The assertion will pass for any
		 * value that is considered <em>falsy</em>. For strict comparison to
		 * false, without type coercion, use
		 * <code>assertStrictlyEquals(value, false, message)</code> instead.</p>
		 */
		public static function assertFalse(value:*, message:String = null):void
		{
			failTrue(value, message);
		}

		/**
		 * Asserts that the provided value is null (equivalent to testing the
		 * value in an <code>if(value == null)</code> statement).
		 * 
		 * <p>Note: Type coercion may occur. The assertion will pass for any
		 * value that is considered <em>nullish</em>. For strict comparison to
		 * null, without type coercion, use
		 * <code>assertStrictlyEquals(value, null, message)</code> instead.</p>
		 */
		public static function assertNull(actual:*, message:String = null):void
		{
			failNotNull(actual, message);
		}

		/**
		 * Asserts that the provided value is not null (equivalent to testing
		 * the value in an <code>if(value != null)</code> statement).
		 * 
		 * <p>Note: Type coercion may occur. The assertion will fail for any
		 * value that is considered <em>nullish</em>. For strict comparison to
		 * null, without type coercion, use
		 * <code>assertNotStrictlyEquals(value, null, message)</code> instead.</p>
		 */
		public static function assertNotNull(actual:*, message:String = null):void
		{
			failNull(actual, message);
		}

		/**
		 * Asserts that the provided value is NaN (equivalent to testing the
		 * value in an <code>if(isNaN(value))</code> statement).
		 */
		public static function assertNaN(actual:Number, message:String = null):void
		{
			if (!isNaN(actual))
			{
				failWithUserMessage("expected NaN but was <" + actual + ">", message);
			}
		}

		/**
		 * Asserts that the provided value is between a minimum and maximum
		 * value (inclusive). Equivalent to testing the
		 * value in an <code>if(value >= minimum && value <= maximum)</code>
		 * statement.
		 */
		public static function assertWithin(actual:Number, minimum:Number, maximum:Number, message:String = null):void
		{
			failNotWithin(actual, minimum, maximum, message);
		}

		/**
		 * Asserts that the provided value is not between a minimum and maximum
		 * value (inclusive). Equivalent to testing the
		 * value in an <code>if(value < minimum || value > maximum)</code>
		 * statement.
		 */
		public static function assertNotWithin(actual:Number, minimum:Number, maximum:Number, message:String = null):void
		{
			failWithin(actual, minimum, maximum, message);
		}

		/**
		 * Asserts that the provided value is less than another value.
		 * Equivalent to testing the value in an <code>if(value < other)</code>
		 * statement.
		 */
		public static function assertLessThan(actual:Number, other:Number, message:String = null):void
		{
			failGreaterThanOrEqual(actual, other, message);
		}

		/**
		 * Asserts that the provided value is greater than another value.
		 * Equivalent to testing the value in an <code>if(value > other)</code>
		 * statement.
		 */
		public static function assertGreaterThan(actual:Number, other:Number, message:String = null):void
		{
			failLessThanOrEqual(actual, other, message);
		}

		/**
		 * Asserts that the provided value is less or equal to than another
		 * value. Equivalent to testing the value in an
		 * <code>if(value <= other)</code> statement.
		 */
		public static function assertLessThanOrEqual(actual:Number, other:Number, message:String = null):void
		{
			failGreaterThan(actual, other, message);
		}

		/**
		 * Asserts that the provided value is greater than or equal to another
		 * value. Equivalent to testing the value in an
		 * <code>if(value >= other)</code> statement.
		 */
		public static function assertGreaterThanOrEqual(actual:Number, other:Number, message:String = null):void
		{
			failLessThan(actual, other, message);
		}

		/**
		 * Asserts that the provided value is of a type. Equivalent to testing
		 * the value in an <code>if(value is type)</code> statement.
		 */
		public static function assertType(actual:*, type:Class, message:String = null):void
		{
			failNotType(actual, type, message);
		}

		/**
		 * Asserts that the provided value is not of a type. Equivalent to
		 * testing the value in an <code>if(!(value is type))</code> statement.
		 */
		public static function assertNotType(actual:*, type:Class, message:String = null):void
		{
			failType(actual, type, message);
		}

		/**
		 * Asserts that the provided value matches a regular expression.
		 * Equivalent to testing the value in an
		 * <code>if(regExp.test(value))</code> statement.
		 */
		public static function assertMatch(actual:String, regExp:RegExp, message:String = null):void
		{
			failNotMatch(actual, regExp, message);
		}

		/**
		 * Asserts that the provided value does not match a regular expression.
		 * Equivalent to testing the value in an
		 * <code>if(!regExp.test(value))</code> statement.
		 */
		public static function assertNotMatch(actual:String, regExp:RegExp, message:String = null):void
		{
			failMatch(actual, regExp, message);
		}

		/**
		 * Asserts that the provided function throws.
		 * 
		 * <p>Equivalent to <code>[Test(expected="RangeError")]</code></p>
		 */
		public static function assertThrows(fn:Function, type:Class = null, message:String = null):void
		{
			try
			{
				fn();
			}
			catch(e:*)
			{
				if (type != null)
				{
					assertType(e, type, message);
				}
				return;
			}
			fail("expected function to throw");
		}

		/**
		 * Fails.
		 */
		public static function fail(message:String = "", sourceError:Error = null):void
		{
			throw new AssertionError(message, sourceError);
		}

		/**
		 * Fails if the condition is true.
		 * 
		 * <p>Note: Type coercion may occur. The assertion will fail for any
		 * value that is considered <em>truthy</em>. For strict comparison to
		 * true, without type coercion, use
		 * <code>failStrictlyEquals(value, true, message)</code> instead.</p>
		 */
		public static function failTrue(condition:*, message:String = null):void
		{
			if(condition)
			{
				failWithUserMessage("expected false but was true", message);
			}
		}

		/**
		 * Fails if the condition is false.
		 * 
		 * <p>Note: Type coercion may occur. The assertion will fail for any
		 * value that is considered <em>falsy</em>. For strict comparison to
		 * false, without type coercion, use
		 * <code>failStrictlyEquals(value, false, message)</code> instead.</p>
		 */
		public static function failFalse(condition:*, message:String = null):void
		{
			if(!condition)
			{
				failWithUserMessage("expected true but was false", message);
			}
		}

		/**
		 * Fails if the values are loosely equal.
		 * 
		 * <p>Note: Type coercion may occur. For a strict comparison without
		 * type coercion, use
		 * <code>failStrictlyEquals(actual, expected, message)</code>
		 * instead.</p>
		 * 
		 * @see Assert.failStrictlyEquals()
		 */
		public static function failEquals(actual:*, expected:*, message:String = null):void
		{
			if(actual == expected)
			{
				failWithUserMessage("expected <" + actual + "> not to be equal to <" + expected + ">", message);
			}
		}

		/**
		 * Fails if the values are not loosely equal.
		 * 
		 * <p>Note: Type coercion may occur. For a strict comparison without
		 * type coercion, use
		 * <code>failNotStrictlyEquals(actual, expected, message)</code>
		 * instead.</p>
		 * 
		 * @see Assert.failNotStrictlyEquals()
		 */
		public static function failNotEquals(actual:*, expected:*, message:String = null):void
		{
			if(actual != expected)
			{
				failWithUserMessage("expected <" + actual + "> to be equal to <" + expected + ">", message);
			}
		}

		/**
		 * Fails if the values are strictly equal.
		 */
		public static function failStrictlyEquals(actual:*, expected:*, message:String = null):void
		{
			if(actual === expected)
			{
				failWithUserMessage("expected <" + actual + "> not to be strictly equal to <" + expected + ">", message);
			}
		}

		/**
		 * Fails if the values are not strictly equal.
		 */
		public static function failNotStrictlyEquals(actual:*, expected:*, message:String = null):void
		{
			if(actual !== expected)
			{
				failWithUserMessage("expected <" + actual + "> to be strictly equal to <" + expected + ">", message);
			}
		}

		/**
		 * Fails if the value is null.
		 * 
		 * <p>Note: Type coercion may occur. The assertion will fail for any
		 * value that is considered <em>nullish</em>. For strict comparison
		 * to null, without type coercion, use
		 * <code>failStrictlyEquals(value, null, message)</code> instead.</p>
		 */
		public static function failNull(object:*, message:String = null):void
		{
			if(object == null)
			{
				failWithUserMessage("expected not null", message);
			}
		}

		/**
		 * Fails if the value is not null.
		 * 
		 * <p>Note: Type coercion may occur. The assertion will pass for any
		 * value that is considered <em>nullish</em>. For strict comparison
		 * to null, without type coercion, use
		 * <code>failNotStrictlyEquals(value, null, message)</code> instead.</p>
		 */
		public static function failNotNull(object:*, message:String = null):void
		{
			if(object != null)
			{
				failWithUserMessage("expected null: <" + object + ">", message);
			}
		}

		/**
		 * Fails if the value is NaN.
		 */
		public static function failNaN(actual:Number, message:String = null):void
		{
			if (isNaN(actual))
			{
				failWithUserMessage("expected not NaN: <" + actual + ">", message);
			}
		}

		/**
		 * Fails if the provided value is between a minimum and maximum value
		 * (inclusive).
		 */
		public static function failWithin(actual:Number, minimum:Number, maximum:Number, message:String = null):void
		{
			if (actual >= minimum && actual <= maximum)
			{
				failWithUserMessage("expected not between <" + minimum + "> and <" + maximum + "> but was <" + actual + ">", message);
			}
		}

		/**
		 * Fails if the provided value is not between a minimum and maximum
		 * value (inclusive).
		 */
		public static function failNotWithin(actual:Number, minimum:Number, maximum:Number, message:String = null):void
		{
			if (actual < minimum || actual > maximum)
			{
				failWithUserMessage("expected between <" + minimum + "> and <" + maximum + "> but was <" + actual + ">", message);
			}
		}

		/**
		 * Fails if the provided value is less than another value.
		 */
		public static function failLessThan(actual:Number, other:Number, message:String = null):void
		{
			if (actual < other)
			{
				failWithUserMessage("expected greater than or equal to <" + other + "> but was <" + actual + ">", message);
			}
		}

		/**
		 * Fails if the provided value is greater than another value.
		 */
		public static function failGreaterThan(actual:Number, other:Number, message:String = null):void
		{
			if (actual > other)
			{
				failWithUserMessage("expected less than or equal to <" + other + "> but was <" + actual + ">", message);
			}
		}

		/**
		 * Fails if the provided value is less than or equal to another value.
		 */
		public static function failLessThanOrEqual(actual:Number, other:Number, message:String = null):void
		{
			if (actual <= other)
			{
				failWithUserMessage("expected greater than <" + other + "> but was <" + actual + ">", message);
			}
		}

		/**
		 * Fails if the provided value is greater than or equal to another
		 * value.
		 */
		public static function failGreaterThanOrEqual(actual:Number, other:Number, message:String = null):void
		{
			if (actual >= other)
			{
				failWithUserMessage("expected less than <" + other + "> but was <" + actual + ">", message);
			}
		}

		/**
		 * Fails if the provided value is of a type.
		 */
		public static function failType(actual:*, type:Class, message:String = null):void
		{
			if (actual is type)
			{
				failWithUserMessage("expected <" + actual + "> to not be of type <" + type + ">", message);
			}
		}

		/**
		 * Fails if the provided value is not of a type.
		 */
		public static function failNotType(actual:*, type:Class, message:String = null):void
		{
			if (!(actual is type))
			{
				failWithUserMessage("expected <" + actual + "> to be of type <" + type + ">", message);
			}
		}

		/**
		 * Fails if the provided value matches a regular expression.
		 */
		public static function failMatch(actual:String, regExp:RegExp, message:String = null):void
		{
			if (regExp.test(actual))
			{
				failWithUserMessage("expected <" + actual + "> to match regular expression <" + regExp + ">", message);
			}
		}

		/**
		 * Fails if the provided value does not match a regular expression.
		 */
		public static function failNotMatch(actual:String, regExp:RegExp, message:String = null):void
		{
			if (!regExp.test(actual))
			{
				failWithUserMessage("expected <" + actual + "> not to match regular expression <" + regExp + ">", message);
			}
		}

		/**
		 * Fails if the provided function throws.
		 */
		public static function failThrows(fn:Function, type:Class = null, message:String = null):void
		{
			try
			{
				fn();
			}
			catch(e:*)
			{
				if (type != null && e is type)
				{
					fail("expected function not to throw type <" + type + ">");
					return;
				}
				fail("expected function not to throw");
			}
		}

		/**
		 * @private
		 */
		protected static function failWithUserMessage(userMessage:String, failMessage:String = null):void
		{
			if(failMessage)
			{
				throw new AssertionError(userMessage + " - " + failMessage);
			}
	
			throw new AssertionError(userMessage);
		}
	}
}