/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package flexunit.framework
{
	//import flexunit.framework.AssertionFailedError;
 	
	/**
	 * A set of assert methods.  Messages are only displayed when an assert fails.
     * @royalesuppresspublicvarwarning
     */
	public class Assert
	{
		/**
		 * @private
		 */
		public static var _assertCount:uint = 0;
		
		/**
		 * Returns the number of assertions that have been made
		 */
		public static function get assertionsMade() : uint {
			return _assertCount;
		}
		
		
		/**
		 * Resets the count for the number of assertions that have been made back to zero
		 */
		public static function resetAssertionsFields() : void {
			_assertCount = 0;
		}
		
		/**
		 * @private
		 */
		public static function assertWithApply( asserter:Function, args:Array ):void {
			_assertCount++;
			asserter.apply( null, args );
		}

		/**
		 * @private
		 */
		public static function assertWith( asserter:Function, ...rest ):void {
			_assertCount++;
			asserter.apply( null, rest );
		}

		/**
		 * Asserts that two provided values are equal.
		 * 
		 * @param asserter The function to use for assertion. 
		 * @param rest
		 * 			Must be passed at least 2 arguments of type Object to compare for equality.
		 * 			If three arguments are passed, the first argument must be a String
		 * 			and will be used as the error message.
		 *          The first of the comparison arguments represents the expected result
		 *          The second is the actual result to compare with the expected result.
		 * 
		 * 			<code>assertEquals( String, Object, Object );</code>
		 * 			<code>assertEquals( Object, Object );</code>
		 */
		public static function assertEquals(... rest):void
		{
			_assertCount++;
			if ( rest.length == 3 )
				failNotEquals( rest[0], rest[1], rest[2] );
			else
				failNotEquals( "", rest[0], rest[1] );
		}
		
		/**
		 * Asserts that the provided values are not loosely equal (equivalent to
		 * the <code>!=</code> operator).
		 */
		public static function assertNotEquals(... rest):void
		{
			_assertCount++;
			if ( rest.length == 3 )
				failEquals( rest[0], rest[1], rest[2] );
			else
				failEquals( "", rest[0], rest[1] );
		}
		
	
        /**
         * @private
         */
		public static function failNotEquals( message:String, expected:Object, actual:Object ):void
		{
			if ( expected != actual )
			   failWithUserMessage( message, "expected:<" + expected + "> but was:<" + actual + ">" );
		}
		
		
		/**
		 * Fails if the values are loosely equal.
		 * @private
		 */
		public static function failEquals(message:String, expected:Object, actual:Object):void
		{
			if(actual == expected)
			{
				failWithUserMessage(message,"expected: <" + expected + "> not to be equal to <" + actual + ">");
			}
		}
	
		/**
		 * /**
		 * Asserts that the provided values are strictly equal.
		 * 
		 * @param rest
		 * 			Must be passed at least 2 arguments of type Object to compare for strict equality.
		 * 			If three arguments are passed, the first argument must be a String
		 * 			and will be used as the error message.
		 *          The first of the comparison arguments represents the expected result
		 *          The second is the actual result to compare with the expected result.
		 * 
		 * 			<code>assertStrictlyEquals( String, Object, Object );</code>
		 * 			<code>assertStrictlyEquals( Object, Object );</code>
		 */
		public static function assertStrictlyEquals(... rest):void
		{
			_assertCount++;
			if ( rest.length == 3 )
				failNotStrictlyEquals( rest[0], rest[1], rest[2] );
			else
				failNotStrictlyEquals( "", rest[0], rest[1] );
		}
		
		/**
		 * Asserts that the provided values are not strictly equal (equivalent
		 * to the <code>!==</code> operator).
		 */
		public static function assertNotStrictlyEquals(... rest):void
		{
			_assertCount++;
			if ( rest.length == 3 )
				failStrictlyEquals( rest[0], rest[1], rest[2] );
			else
				failStrictlyEquals( "", rest[0], rest[1] );
			
		}
		
		
		/**
		 * Fails if the values are strictly equal.
		 */
		public static function failStrictlyEquals(message:String, expected:Object, actual:Object):void
		{
			if(actual === expected)
			{
				failWithUserMessage(message,"expected: <" + expected + "> not to be strictly equal to <" + actual + ">");
			}
		}
	
        /**
         * @private
         */
		public static function failNotStrictlyEquals( message:String, expected:Object, actual:Object ):void
		{
			if ( expected !== actual )
			   failWithUserMessage( message, "expected:<" + expected + "> but was:<" + actual + ">" );
		}
	
		/**
		 * Asserts that a condition is true.
		 * 
		 * @param rest
		 * 			Accepts an argument of type Boolean.
		 * 			If two arguments are passed the first argument must be a String 
		 * 			and will be used as the error message.
		 * 			
		 * 			<code>assertTrue( String, Boolean );</code>
		 * 			<code>assertTrue( Boolean );</code>
		 */
		public static function assertTrue(... rest):void
		{
			_assertCount++;
			if ( rest.length == 2 )
				failNotTrue( rest[0], rest[1] );
			else
				failNotTrue( "", rest[0] );
		}
	
        /**
         * Asserts that a condition is not true.
		 * 
		 * @param rest
		 * 			Accepts an argument of type Boolean.
		 * 			If two arguments are passed the first argument must be a String 
		 * 			and will be used as the error message.
		 * 			
		 * 			<code>assertTrue( String, Boolean );</code>
		 * 			<code>assertTrue( Boolean );</code>
         */
		public static function failNotTrue( message:String, condition:Boolean ):void
		{
			if ( !condition )
			   failWithUserMessage( message, "expected true but was false" );
		}
	
		/**
         * Asserts that a condition is false.
		 * 
		 * @param rest
		 * 			Accepts an argument of type Boolean.
		 * 			If two arguments are passed the first argument must be a String
		 * 			and will be used as the error message.
		 * 			
		 * 			<code>assertFalse( String, Boolean );</code>
		 * 			<code>assertFalse( Boolean );</code>
		 */
		public static function assertFalse(... rest):void
		{
			_assertCount++;
			if ( rest.length == 2 )
				failTrue( rest[0], rest[1] );
			else
				failTrue( "", rest[0] );
		}
	
        /**
         * Asserts that a condition is false. 
		 * 
		 * @param rest
		 * 			Accepts an argument of type Boolean.
		 * 			If two arguments are passed the first argument must be a String 
		 * 			and will be used as the error message.
		 * 			
		 * 			<code>assertTrue( String, Boolean );</code>
		 * 			<code>assertTrue( Boolean );</code>
         */
		public static function failTrue( message:String, condition:Boolean ):void
		{
			if ( condition )
			   failWithUserMessage( message, "expected false but was true" );
		}
	
		//TODO:  (<code>null</code> okay) needs removal?
		/**
		 * Asserts that an object is null.
		 * 
		 * @param rest
		 * 			Accepts an argument of type Object.
		 * 			If two arguments are passed the first argument must be a String
		 * 			and will be used as the error message.
		 * 			
		 * 			<code>assertNull( String, Object );</code>
		 * 			<code>assertNull( Object );</code>
		 * 
		 */
		public static function assertNull(... rest):void
		{
			_assertCount++;
			if ( rest.length == 2 )
				failNotNull( rest[0], rest[1] );
			else
				failNotNull( "", rest[0] );
		}
	
        /**
         * Asserts that an object is not null. 
		 * 
		 * @param rest
		 * 			Accepts an argument of type Boolean.
		 * 			If two arguments are passed the first argument must be a String 
		 * 			and will be used as the error message.
		 * 			
		 * 			<code>assertTrue( String, Boolean );</code>
		 * 			<code>assertTrue( Boolean );</code>
         */
		public static function failNull( message:String, object:Object ):void
		{
			if ( object == null )
			   failWithUserMessage( message, "object was null: " + object );
		}
	
		//TODO:  (<code>null</code> okay) needs removal?
		/**
		 * Asserts that an object is not null.
		 * 
		 * @param rest
		 * 			Accepts an argument of type Object.
		 * 			If two arguments are passed the first argument must be a String
		 * 			and will be used as the error message.
		 * 			
		 * 			<code>assertNotNull( String, Object );</code>
		 * 			<code>assertNotNull( Object );</code>
		 */
		public static function assertNotNull(... rest):void
		{
			_assertCount++;
			if ( rest.length == 2 )
				failNull( rest[0], rest[1] );
			else
				failNull( "", rest[0] );
		}
	
        /**
         * Asserts that an object is not null.
		 * 
		 * @param rest
		 * 			Accepts an argument of type Boolean.
		 * 			If two arguments are passed the first argument must be a String 
		 * 			and will be used as the error message.
		 * 			
		 * 			<code>assertTrue( String, Boolean );</code>
		 * 			<code>assertTrue( Boolean );</code>
         */
		public static function failNotNull( message:String, object:Object ):void
		{
			if ( object != null )
			   failWithUserMessage( message, "object was not null: " + object );
		}
		//TODO:  (<code>null</code> okay) needs removal?
		/**
		 * Fails a test with the argument message.
		 * 
		 * @param failMessage
		 *            the identifying message for the <code> AssertionFailedError</code> (<code>null</code>
		 *            okay)
		 * @see AssertionFailedError
		 */
		public static function fail( failMessage:String = ""):void
		{
			var error:AssertionFailedError = new AssertionFailedError(failMessage);
			//this seems necessary for js:
			if (error.message!=failMessage) error.message = failMessage;
			throw error;
		}
	

        /**
         * @private
         */
		private static function failWithUserMessage( userMessage:String, failMessage:String ):void
		{
			if ( userMessage.length > 0 )
				userMessage = userMessage + " - ";
			failMessage = userMessage + failMessage;
			fail(failMessage);
		}
	}
}
