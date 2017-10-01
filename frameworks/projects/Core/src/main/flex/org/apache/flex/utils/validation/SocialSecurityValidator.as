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


	// [ResourceBundle("validators")]

	/**
	 *  The SocialSecurityValidator class validates that a String
	 *  is a valid United States Social Security number.
	 *  It does not check whether it is an existing Social Security number.
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;mx:SocialSecurityValidator&gt;</code> tag
	 *  inherits all of the tag attributes of its superclass,
	 *  and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;mx:SocialSecurityValidator
	 *    allowedFormatChars=" -"
	 *    invalidCharError="You entered invalid characters in your Social Security number."
	 *    wrongFormatError="The Social Security number must be 9 digits or in the form NNN-NN-NNNN."
	 *    zeroStartError="Invalid Social Security number; the number cannot start with 000."
	 *  /&gt;
	 *  </pre>
	 *
	 *  @includeExample examples/SocialSecurityValidatorExample.mxml
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class SocialSecurityValidator extends Validator
	{

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  Convenience method for calling a validator.
		 *  Each of the standard Flex validators has a similar convenience method.
		 *
		 *  @param validator The SocialSecurityValidator instance.
		 *
		 *  @param value A field to validate.
		 *
		 *  @param baseField Text representation of the subfield
		 *  specified in the <code>value</code> parameter.
		 *  For example, if the <code>value</code> parameter specifies
		 *  value.social, the <code>baseField</code> value is <code>social</code>.
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
		public static function validateSocialSecurity(
									validator:SocialSecurityValidator,
									value:Object,
									baseField:String):Array
		{
			var results:Array = [];

			// Resource-backed properties of the validator.
			var allowedFormatChars:String = validator.allowedFormatChars;

			var resourceManager:IResourceManager = ResourceManager.getInstance();

			var hyphencount:int = 0;
			var len:int = value.toString().length;
			var checkForFormatChars:Boolean = false;

			var n:int;
			var i:int;

			if ((len != 9) && (len != 11))
			{
				results.push(new ValidationResult(
					true, baseField, "wrongFormat",
					validator.wrongFormatError));
				return results;
			}

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

			if (len == 11)
				checkForFormatChars = true;

			for (i = 0; i < len; i++)
			{
				var allowedChars:String;
				if (checkForFormatChars && (i == 3 || i == 6))
					allowedChars = allowedFormatChars;
				else
					allowedChars = DECIMAL_DIGITS;

				if (allowedChars.indexOf(value.charAt(i)) == -1)
				{
					results.push(new ValidationResult(
						true, baseField, "invalidChar",
						validator.invalidCharError));
					return results;
				}
			}

			if (value.substring(0, 3) == "000")
			{
				results.push(new ValidationResult(
					true, baseField, "zeroStart",
					validator.zeroStartError));
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
		public function SocialSecurityValidator()
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
		 */
		private var _allowedFormatChars:String;

		/**
		 *  @private
		 */
		private var allowedFormatCharsOverride:String;
		
		[Inspectable(category="General", defaultValue="null")]

		/**
		 *  Specifies the set of formatting characters allowed in the input.
		 *
		 *  @default "()- .+" // ?????
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
						throw new Error(invalidFormatChars);
					}
				}
			}

			allowedFormatCharsOverride = value;

			_allowedFormatChars = value != null ?
								value : "()- .+";
			// TODO get from resource bundle
			// _allowedFormatChars = value != null ?
			// 					value :
			// 					resourceManager.getString(
			// 						"validators",
			// 						"socialSecurityValidatorAllowedFormatChars");
		}

		public var invalidFormatChars:String;

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
		 *  Error message when the value contains characters
		 *  other than digits and formatting characters
		 *  defined by the <code>allowedFormatChars</code> property.
		 *
		 *  @default "You entered invalid characters in your Social Security number."
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
								value : "You entered invalid characters in your Social Security number.";
			// TODO get from resource bundle
			// _invalidCharError = value != null ?
			// 					value :
			// 					resourceManager.getString(
			// 						"validators", "invalidCharErrorSSV");
		}

		//----------------------------------
		//  wrongFormatError
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the wrongFormatError property.
		 */
		private var _wrongFormatError:String;
		
		/**
		 *  @private
		 */
		private var wrongFormatErrorOverride:String;
		
		[Inspectable(category="Errors", defaultValue="null")]

		/**
		 *  Error message when the value is incorrectly formatted.
		 *
		 *  @default "The Social Security number must be 9 digits or in the form NNN-NN-NNNN."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get wrongFormatError():String
		{
			return _wrongFormatError;
		}

		/**
		 *  @private
		 */
		public function set wrongFormatError(value:String):void
		{
			wrongFormatErrorOverride = value;

			_wrongFormatError = value != null ?
								value : "The Social Security number must be 9 digits or in the form NNN-NN-NNNN.";
			// TODO get from resource bundle
			// _wrongFormatError = value != null ?
			// 					value :
			// 					resourceManager.getString(
			// 						"validators", "wrongFormatError");
		}

		//----------------------------------
		//  zeroStartError
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the zeroStartError property.
		 */
		private var _zeroStartError:String;
		
		/**
		 *  @private
		 */
		private var zeroStartErrorOverride:String;
		
		[Inspectable(category="Errors", defaultValue="null")]

		/**
		 *  Error message when the value contains an invalid Social Security number.
		 *
		 *  @default "Invalid Social Security number; the number cannot start with 000."
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get zeroStartError():String
		{
			return _zeroStartError;
		}

		/**
		 *  @private
		 */
		public function set zeroStartError(value:String):void
		{
			zeroStartErrorOverride = value;

			_zeroStartError = value != null ?
							value :  "Invalid Social Security number; the number cannot start with 000.";
			// TODO get from resource bundle
			// _zeroStartError = value != null ?
			// 				value :
			// 				resourceManager.getString(
			// 					"validators", "zeroStartError");
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  Override of the base class <code>doValidation()</code> method
		 *  to validate a Social Security number.
		 *
		 *  <p>You do not call this method directly;
		 *  Flex calls it as part of performing a validation.
		 *  If you create a custom Validator class, you must implement this method.</p>
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
				return SocialSecurityValidator.validateSocialSecurity(this, value, null);
		}
	}

}
