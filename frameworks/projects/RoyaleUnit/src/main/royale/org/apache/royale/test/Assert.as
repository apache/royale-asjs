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
		 */
		public static function assertEquals(actual:*, expected:*, message:String = null):void
		{
			failNotEquals(actual, expected, message);
		}

		/**
		 * Asserts that the provided values are not loosely equal (equivalent to
		 * the <code>!=</code> operator).
		 */
		public static function assertNotEquals(actual:*, expected:*, message:String = null):void
		{
			failEquals(actual, expected, message);
		}

		/**
		 * Asserts that the provided value is true (equivalent to testing the
		 * value in an <code>if(value)</code> statement).
		 */
		public static function assertTrue(value:*, message:String = null):void
		{
			failFalse(value, message);
		}

		/**
		 * Asserts that the provided value is true (equivalent to testing the
		 * value in an <code>if(!value)</code> statement).
		 */
		public static function assertFalse(value:*, message:String = null):void
		{
			failTrue(value, message);
		}

		/**
		 * Asserts that the provided value is null.
		 */
		public static function assertNull(actual:*, message:String = null):void
		{
			failNotNull(actual, message);
		}

		/**
		 * Asserts that the provided value is not null.
		 */
		public static function assertNotNull(actual:*, message:String = null):void
		{
			failNull(actual, message);
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
		 */
		public static function failNotNull(object:*, message:String = null):void
		{
			if(object != null)
			{
				failWithUserMessage("expected null: <" + object + ">", message);
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