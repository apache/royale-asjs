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

package org.apache.flex.utils.validation
{
	import org.apache.flex.utils.StringUtil;
	//TODO make PAYG

	// [ResourceBundle("validators")]

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
	 *  @productversion Flex 3
	 */
	public class PhoneNumberValidator extends Validator
	{

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
		public static function validatePhoneNumber(validator:PhoneNumberValidator,
												value:Object,
												baseField:String):Array
		{
			var results:Array = [];
			
			// Resource-backed properties of the validator.
			var allowedFormatChars:String = validator.allowedFormatChars;

			var resourceManager:IResourceManager = ResourceManager.getInstance();

			var valid:String =  DECIMAL_DIGITS + allowedFormatChars;
			var len:int = value.toString().length;
			var digitLen:int = 0;
			var n:int;
			var i:int;
			var minDigits:Number = Number(validator.minDigits);
			
			n = allowedFormatChars.length;
			for (i = 0; i < n; i++)
			{
				if (DECIMAL_DIGITS.indexOf(allowedFormatChars.charAt(i)) != -1)
				{
					var message:String = resourceManager.getString(
						"validators", "invalidFormatChars");
					throw new Error(message);
				}
			}

			for (i = 0; i < len; i++)
			{
				var temp:String = "" + value.toString().substring(i, i + 1);
				if (valid.indexOf(temp) == -1)
				{
					results.push(new ValidationResult(
						true, baseField, "invalidChar",
						validator.invalidCharError));
					return results;
				}
				if (valid.indexOf(temp) <= 9)
					digitLen++;
			}

			if (!isNaN(minDigits) && digitLen < minDigits)
			{
				results.push(new ValidationResult(
					true, baseField, "wrongLength",
					StringUtil.substitute(validator.wrongLengthError, minDigits)));
				return results;
			}

			return results;
		}

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
		 *  @productversion Flex 3
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
		private var allowedFormatCharsOverride:String;
		
		[Inspectable(category="General", defaultValue="null")]

		/** 
		 *  The set of allowable formatting characters.
		 *
		 *  @default "()- .+"
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
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
					if (DECIMAL_DIGITS.indexOf(value.charAt(i)) != -1)
					{
						var message:String = resourceManager.getString(
							"validators", "invalidFormatChars");
						throw new Error(message);
					}
				}
			}

			allowedFormatCharsOverride = value;

			_allowedFormatChars = value != null ?
								value : "()- .+";
		}

		//----------------------------------
		//  minDigits
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the minDigits property.
		 */
		private var _minDigits:Object;
		
		/**
		 *  @private
		 */
		private var minDigitsOverride:Object;
		
		[Inspectable(category="General", defaultValue="null")]

		/** 
		 *  Minimum number of digits for a valid phone number.
		 *  A value of NaN means this property is ignored.
		 *
		 *  @default 10
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get minDigits():Object
		{
			return _minDigits;
		}

		/**
		 *  @private
		 */
		public function set minDigits(value:Object):void
		{
			minDigitsOverride = value;

			_minDigits = value != null ?
						Number(value) : 10;

			// TODO get from resource bundle
			// _minDigits = value != null ?
			// 			Number(value) :
			// 			resourceManager.getNumber(
			// 				"validators", "minDigitsPNV");
		}
		//--------------------------------------------------------------------------
		//
		//  Properties: Errors
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  invalidCharError
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the invalidCharError property.
		 */
		private var _invalidCharError:String;
		
		/**
		 *  @private
		 */
		private var invalidCharErrorOverride:String;
		
		[Inspectable(category="Errors", defaultValue="null")]

		/** 
		 *  Error message when the value contains invalid characters.
		 *
		 *  @default "Your telephone number contains invalid characters."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get invalidCharError():String
		{
			return _invalidCharError;
		}

		/**
		 *  @private
		 */
		public function set invalidCharError(value:String):void
		{
			invalidCharErrorOverride = value;

			_invalidCharError = value != null ?
								value : "Your telephone number contains invalid characters.";
		}

		//----------------------------------
		//  wrongLengthError
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the wrongLengthError property.
		 */
		private var _wrongLengthError:String;
		
		/**
		 *  @private
		 */
		private var wrongLengthErrorOverride:String;
		
		[Inspectable(category="Errors", defaultValue="null")]

		/** 
		 *  Error message when the value has fewer than 10 digits.
		 *
		 *  @default "Your telephone number must contain at least 10 digits."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get wrongLengthError():String
		{
			return _wrongLengthError;
		}

		/**
		 *  @private
		 */
		public function set wrongLengthError(value:String):void
		{
			wrongLengthErrorOverride = value;

			_wrongLengthError = value != null ?
								value : "Your telephone number must contain at least 10 digits.";
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private    
		 */
		override protected function resourcesChanged():void
		{
			super.resourcesChanged();

			allowedFormatChars = allowedFormatCharsOverride;
			minDigits = minDigitsOverride;
			invalidCharError = invalidCharErrorOverride;
			wrongLengthError = wrongLengthErrorOverride;
		}

		/**
		 *  Override of the base class <code>doValidation()</code> method
		 *  to validate a phone number.
		 *
		 *  <p>You do not typically call this method directly;
		 *  Flex calls it as part of performing a validation.
		 *  If you create a custom Validator class, you must implement this method. </p>
		 *
		 *  @param value Object to validate.
		 *
		 *  @return An Array of ValidationResult objects, with one ValidationResult 
		 *  object for each field examined by the validator. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		override protected function doValidation(value:Object):Array
		{
			var results:Array = super.doValidation(value);
			
			// Return if there are errors
			// or if the required property is set to <code>false</code> and length is 0.
			var val:String = value ? String(value) : "";
			if (results.length > 0 || ((val.length == 0) && !required))
				return results;
			else
				return PhoneNumberValidator.validatePhoneNumber(this, value, null);
		}
	}

}
