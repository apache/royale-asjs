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
package org.apache.royale.test.bdd
{
	/**
	 * Interface for BDD-style natural language assertions that may be chained
	 * together.
	 */
	public interface IExpect
	{
		/**
		 * Asserts that the provided values are loosely equal (equivalent to
		 * the <code>==</code> operator).
		 * 
		 * @see Assert#assertEquals
		 * @see #equals
		 */
		function equal(value:*, message:String = null):IExpect;

		/**
		 * Alias for <code>equal()</code>.
		 * 
		 * @see #equal
		 */
		function equals(value:*, message:String = null):IExpect;

		/**
		 * Alias for <code>equal()</code>.
		 * 
		 * @see #equal
		 */
		function eq(value:*, message:String = null):IExpect;

		/**
		 * Asserts that the provided values are strictly equal (equivalent to
		 * the <code>===</code> operator).
		 * 
		 * @see Assert#assertStrictlyEquals
		 */
		function strictlyEqual(value:*, message:String = null):IExpect;

		/**
		 * Alias for <code>strictlyEqual()</code>.
		 * 
		 * @see #equal
		 */
		function strictlyEquals(value:*, message:String = null):IExpect;

		/**
		 * Asserts that the provided value is between a minimum and maximum
		 * value (inclusive). Equivalent to testing the
		 * value in an <code>if(value >= minimum && value <= maximum)</code>
		 * statement.
		 * 
		 * @see Assert#assertWithin
		 */
		function within(minimum:Number, maximum:Number, message:String = null):IExpect;

		/**
		 * Asserts that the provided value is less than another value.
		 * Equivalent to testing the value in an <code>if(value < other)</code>
		 * statement.
		 * 
		 * @see Assert#assertLessThan
		 */
		function lessThan(other:Number, message:String = null):IExpect;

		/**
		 * Asserts that the provided value is less or equal to than another
		 * value. Equivalent to testing the value in an
		 * <code>if(value <= other)</code> statement.
		 * 
		 * @see Assert#assertLessThanOrEqual
		 */
		function lessThanOrEqual(other:Number, message:String = null):IExpect;

		/**
		 * Asserts that the provided value is greater than another value.
		 * Equivalent to testing the value in an <code>if(value > other)</code>
		 * statement.
		 * 
		 * @see Assert#assertGreaterThan
		 */
		function greaterThan(other:Number, message:String = null):IExpect;

		/**
		 * Asserts that the provided value is greater than or equal to another
		 * value. Equivalent to testing the value in an
		 * <code>if(value >= other)</code> statement.
		 * 
		 * @see Assert#assertGreaterThanOrEqual
		 */
		function greaterThanOrEqual(other:Number, message:String = null):IExpect;

		/**
		 * Alias for <code>lessThan()</code>.
		 * 
		 * @see #lessThan
		 */
		function lt(other:Number, message:String = null):IExpect;

		/**
		 * Alias for <code>lessThan()</code>.
		 * 
		 * @see #lessThan
		 */
		function below(other:Number, message:String = null):IExpect;

		/**
		 * Alias for <code>greaterThan()</code>.
		 * 
		 * @see #greaterThan
		 */
		function gt(other:Number, message:String = null):IExpect;

		/**
		 * Alias for <code>greaterThan()</code>.
		 * 
		 * @see #greaterThan
		 */
		function above(other:Number, message:String = null):IExpect;

		/**
		 * Alias for <code>lessThanOrEqual()</code>.
		 * 
		 * @see #lessThanOrEqual
		 */
		function lte(other:Number, message:String = null):IExpect;

		/**
		 * Alias for <code>lessThanOrEqual()</code>.
		 * 
		 * @see #lessThanOrEqual
		 */
		function most(other:Number, message:String = null):IExpect;

		/**
		 * Alias for <code>greaterThanOrEqual()</code>.
		 * 
		 * @see #greaterThanOrEqual
		 */
		function gte(other:Number, message:String = null):IExpect;

		/**
		 * Alias for <code>greaterThanOrEqual()</code>.
		 * 
		 * @see #greaterThanOrEqual
		 */
		function least(other:Number, message:String = null):IExpect;

		/**
		 * Asserts that the provided value is of a type. Equivalent to testing
		 * the value in an <code>if(value is type)</code> statement.
		 * 
		 * @see Assert#assertType
		 */
		function type(type:Class, message:String = null):IExpect;

		/**
		 * Asserts that the provided value matches a regular expression.
		 * Equivalent to testing the value in an
		 * <code>if(regExp.test(value))</code> statement.
		 * 
		 * @see Assert#assertMatch
		 */
		function match(regExp:RegExp, message:String = null):IExpect;

		/**
		 * Asserts that the provided function throws.
		 * 
		 * @see Assert#assertThrows
		 */
		function throw(type:Class = null, message:String = null):IExpect;

		/**
		 * Alias for <code>throw()</code>.
		 * 
		 * @see #throw
		 */
		function throws(type:Class = null, message:String = null):IExpect;

		/**
		 * Negates all assertions that follow in the chain.
		 */
		function get not():IExpect;

		/**
		 * Asserts that the provided value is true (equivalent to testing the
		 * value in an <code>if(value)</code> statement).
		 * 
		 * @see Assert#assertTrue
		 */
		function get true():IExpect;

		/**
		 * Asserts that the provided value is false (equivalent to testing the
		 * value in an <code>if(!value)</code> statement).
		 * 
		 * @see Assert#assertFalse
		 */
		function get false():IExpect;

		/**
		 * Asserts that the provided value is NaN (equivalent to testing the
		 * value in an <code>if(isNaN(value))</code> statement).
		 * 
		 * @see Assert#assertNaN
		 */
		function get NaN():IExpect;

		/**
		 * Asserts that the provided value is null (equivalent to testing the
		 * value in an <code>if(value == null)</code> statement).
		 * 
		 * @see Assert#assertNull
		 */
		function get null():IExpect;

		//-- language chains

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get to():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get be():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get been():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get is():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get that():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get which():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get and():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get has():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get have():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get with():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get at():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get of():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get same():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get but():IExpect;

		/**
		 * Chainable getter to improve readability without altering the
		 * assertion.
		 */
		function get does():IExpect;
	}
}