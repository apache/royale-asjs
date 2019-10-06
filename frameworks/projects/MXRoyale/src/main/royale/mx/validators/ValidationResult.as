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
 *  The ValidationResult class contains the results of a validation. 
 *
 *  <p>The ValidationResultEvent class defines the event object
 *  that is passed to event listeners for the <code>valid</code>
 *  and <code>invalid</code> validator events. 
 *  The class also defines the <code>results</code> property,
 *  which contains an Array of ValidationResult objects,
 *  one for each field examined by the validator.
 *  This lets you access the ValidationResult objects
 *  from within an event listener.</p>
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
public class ValidationResult
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
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function ValidationResult(isError:Boolean, subField:String = "",
									 errorCode:String = "",
									 errorMessage:String = "")
	{
		super();

		this.isError = isError;
		this.subField = subField;
		this.errorMessage = errorMessage;
		this.errorCode = errorCode;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  errorCode
	//----------------------------------

	/**
	 *  The validation error code
	 *  if the value of the <code>isError</code> property is <code>true</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var errorCode:String;

	//----------------------------------
	//  errorMessage
	//----------------------------------

	/**
	 *  The validation error message
	 *  if the value of the <code>isError</code> property is <code>true</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var errorMessage:String;
	
	//----------------------------------
	//  isError
	//----------------------------------

	/**
	 *  Contains <code>true</code> if the field generated a validation failure.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var isError:Boolean;
	
	//----------------------------------
	//  subField
	//----------------------------------

	/**
	 *  The name of the subfield that the result is associated with.
	 *  Some validators, such as CreditCardValidator and DateValidator,
	 *  validate multiple subfields at the same time.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var subField:String;
}

}
