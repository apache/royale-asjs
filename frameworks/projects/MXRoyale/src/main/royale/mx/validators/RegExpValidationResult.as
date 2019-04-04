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

package mx.validators
{

/**
 *  The RegExpValidator class dispatches the <code>valid</code>
 *  and <code>invalid</code> events. 
 *  For an <code>invalid</code> event, the event object
 *  is an instance of the ValidationResultEvent class, 
 *  and the <code>ValidationResultEvent.results</code> property
 *  contains an Array of ValidationResult objects.
 *
 *  <p>However, for a <code>valid</code> event, the 
 *  <code>ValidationResultEvent.results</code> property contains 
 *  an Array of RegExpValidationResult objects.
 *  The RegExpValidationResult class is a child class
 *  of the ValidationResult class, and contains additional properties 
 *  used with regular expressions.</p>
 *
 *  @see mx.events.ValidationResultEvent
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class RegExpValidationResult extends ValidationResult
{
//	include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/** 
	 *  Constructor
	 *  
     *  @param isError Pass <code>true</code> if there was a validation error.
     *
     *  @param subField Name of the subfield of the validated Object.
     *
     *  @param errorCode  Validation error code.
     *
     *  @param errorMessage Validation error message.
     *
     *  @param matchedString Matching substring.
     *
     *  @param matchedIndex Index of the matching String.
     *
     *  @param matchedSubstrings Array of substring matches.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function RegExpValidationResult(isError:Boolean, 
										   subField:String = "", 
										   errorCode:String = "", 
										   errorMessage:String = "",
										   matchedString:String = "",
										   matchedIndex:int = 0,
										   matchedSubstrings:Array = null)
	{
		super(isError, subField, errorCode, errorMessage);
		
		this.matchedString = matchedString;
		this.matchedIndex = matchedIndex;
		this.matchedSubstrings = matchedSubstrings ? matchedSubstrings : [];
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//--------------------------------------------------------------------------
	//  matchedIndex
	//--------------------------------------------------------------------------

	/** 
	 *  An integer that contains the starting index
	 *  in the input String of the match.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var matchedIndex:int;

	//--------------------------------------------------------------------------
	//  matchedString
	//--------------------------------------------------------------------------

	/**
	 *  A String that contains the substring of the input String
	 *  that matches the regular expression.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var matchedString:String;

	//--------------------------------------------------------------------------
	//  matchedSubstrings
	//--------------------------------------------------------------------------

	/**
	 *  An Array of Strings that contains parenthesized
	 *  substring matches, if any. 
	 *	If no substring matches are found, this Array is of length 0.
	 *	Use <code>matchedSubStrings[0]</code> to access
	 *  the first substring match.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var matchedSubstrings:Array;
}

}
