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

	import mx.managers.ISystemManager;
	//import mx.managers.SystemManager;
	//import mx.resources.IResourceManager;
	//import mx.resources.ResourceManager;
	import mx.utils.StringUtil;
    import mx.events.ValidationResultEvent;

//[ResourceBundle("validators")]

/**
 *  The PhoneNumberValidator class validates that a string
 *  is a valid phone number.
 *  A valid phone number contains at least 10 digits,
 *  plus additional formatting characters.
 *  The validator does not check if the phone number
 *  is an actual active phone number.
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;mx:PhoneNumberValidator&gt;</code> tag
 *  inherits all of the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:PhoneNumberValidator 
 *    allowedFormatChars="()- .+" 
 *    invalidCharError="Your telephone number contains invalid characters."
 * 	  minDigits="10"
 *    wrongLengthError="Your telephone number must contain at least 10 digits."
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/PhoneNumberValidatorExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class PhoneNumberValidator extends Validator
{
//	include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	/**
	 *  Convenience method for calling a validator
	 *  from within a custom validation function.
	 *  Each of the standard Flex validators has a similar convenience method.
	 *
	 *  @param validator The PhoneNumberValidator instance.
	 *
	 *  @param value A field to validate.
	 *
	 *  @param baseField Text representation of the subfield
	 *  specified in the <code>value</code> parameter.
	 *  For example, if the <code>value</code> parameter specifies value.phone,
	 *  the <code>baseField</code> value is "phone".
	 *
	 *  @return An Array of ValidationResult objects, with one ValidationResult 
	 *  object for each field examined by the validator. 
	 *
	 *  @see mx.validators.ValidationResult
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public function PhoneNumberValidator()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  allowedFormatChars
	//----------------------------------

	/**
	 *  @private
	 *  Storage for the allowedFormatChars property.
	 */
	private var _allowedFormatChars:String;

    /**
	 *  @private
	 */
	//private var allowedFormatCharsOverride:String;
	
	[Inspectable(category="General", defaultValue="null")]

	/** 
	 *  The set of allowable formatting characters.
	 *
	 *  @default "()- .+"
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public function get allowedFormatChars():String
	{
		return _allowedFormatChars;
	}

    /**
	 *  @private
	 */
	public function set allowedFormatChars(value:String):void
	{
		if (value != null)
		{
			var n:int = value.length;
			for (var i:int = 0; i < n; i++)
			{
				/*if (DECIMAL_DIGITS.indexOf(value.charAt(i)) != -1)
				{
					var message:String = "";
					resourceManager.getString(
						"validators", "invalidFormatChars");
					throw new Error(message);
				}*/
			}
		}

		//allowedFormatCharsOverride = value;

		_allowedFormatChars = value != null ?
							  value : "";
	//						  resourceManager.getString(
	//							  "validators",
	//							  "phoneNumberValidatorAllowedFormatChars");
	}

}

}
