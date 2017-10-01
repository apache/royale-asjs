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
    //TODO Make PAYG

    // [ResourceBundle("validators")]

    /**
     *  The ZipCodeValidator class validates that a String
     *  has the correct length and format for a five-digit ZIP code,
     *  a five-digit+four-digit United States ZIP code, or Canadian postal code.
     *  
     *  @mxml
     *
     *  <p>The <code>&lt;mx:ZipCodeValidator&gt;</code> tag
     *  inherits all of the tag attributes of its superclass,
     *  and adds the following tag attributes:</p>
     *  
     *  <pre>
     *  &lt;mx:ZipCodeValidator
     *    allowedFormatChars=" -" 
     *    domain="US Only | US or Canada | Canada Only"
     *    invalidCharError="The ZIP code contains invalid characters." 
     *    invalidDomainError="The domain parameter is invalid. It must be either 'US Only', 'Canada Only', or 'US or Canada'." 
     *    wrongCAFormatError="The Canadian postal code must be formatted 'A1B 2C3'." 
     *    wrongLengthError="The ZIP code must be 5 digits or 5+4 digits." 
     *    wrongUSFormatError="The ZIP+4 code must be formatted '12345-6789'." 
     *  /&gt;
     *  </pre>
     *  
     *  @see mx.validators.ZipCodeValidatorDomainType
     * 
     *  @includeExample examples/ZipCodeValidatorExample.mxml
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public class ZipCodeValidator extends Validator
    {

        //--------------------------------------------------------------------------
        //
        //  Class constants
        //
        //--------------------------------------------------------------------------

        /**
         *  @private
         */
        private static const DOMAIN_US:uint = 1;
        
        /**
         *  @private
         */
        private static const DOMAIN_US_OR_CANADA:uint = 2;
        
        /**
         * @private 
         */
        private static const DOMAIN_CANADA:uint = 3;   

        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------

        /**
         *  Convenience method for calling a validator.
         *  Each of the standard Flex validators has a similar convenience method.
         *
         *  @param validator The ZipCodeValidator instance.
         *
         *  @param value A field to validate.
         *
         *  @param baseField Text representation of the subfield
         *  specified in the <code>value</code> parameter.
         *  For example, if the <code>value</code> parameter specifies value.zipCode,
         *  the <code>baseField</code> value is <code>"zipCode"</code>.
         *
         *  @return An Array of ValidationResult objects, with one ValidationResult 
         *  object for each field examined by the validator. 
         *
         *  @see mx.validators.ValidationResult
         *
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function validateZipCode(validator:ZipCodeValidator,
                                            value:Object,
                                            baseField:String):Array
        {
            var results:Array = [];
        
            // Resource-backed properties of the validator.
            var allowedFormatChars:String = validator.allowedFormatChars;
            var domain:String = validator.domain;

            var resourceManager:IResourceManager = ResourceManager.getInstance();

            var zip:String = String(value);
            var len:int = zip.length;
            
            var domainType:uint = DOMAIN_US;
            switch (domain)
            {
                case ZipCodeValidatorDomainType.US_OR_CANADA:
                {
                    domainType = DOMAIN_US_OR_CANADA;
                    break;
                }
                
                case ZipCodeValidatorDomainType.US_ONLY:
                {
                    domainType = DOMAIN_US;
                    break;
                }
                
                case ZipCodeValidatorDomainType.CANADA_ONLY:
                {
                    domainType = DOMAIN_CANADA;
                    break;
                }
                
                default:
                {
                    results.push(new ValidationResult(
                        true, baseField, "invalidDomain",
                        validator.invalidDomainError));
                    return results;
                }
                
            }
            
            var n:int;
            var i:int;
            var c:String;
            
            // Make sure localAllowedFormatChars contains no numbers or letters.
            n = allowedFormatChars.length;
            for (i = 0; i < n; i++)
            {
                c = allowedFormatChars.charAt(i);
                if (DECIMAL_DIGITS.indexOf(c) != -1 ||
                    ROMAN_LETTERS.indexOf(c) != -1)
                {
                    var message:String = resourceManager.getString(
                        "validators", "invalidFormatCharsZCV");
                    throw new Error(message);
                }
            }

            // Now start checking the ZIP code.
            // At present, only US and Canadian ZIP codes are supported.
            // As a result, the easiest thing to check first
            // to determine the domain is the length.
            // A length of 5 or 10 means a US ZIP code
            // and a length of 6 or 7 means a Canadian ZIP.
            // If more countries are supported in the future, it may make sense
            // to check other conditions first depending on the domain specified
            // and all the possible ZIP code formats for that domain.
            // For now, this approach makes the most sense.

            // Make sure there are no invalid characters in the ZIP.
            for (i = 0; i < len; i++)
            {
                c = zip.charAt(i);
                
                if (ROMAN_LETTERS.indexOf(c) == -1 &&
                    DECIMAL_DIGITS.indexOf(c) == -1 &&
                    allowedFormatChars.indexOf(c) == -1)
                {
                    results.push(new ValidationResult(
                        true, baseField, "invalidChar",
                        validator.invalidCharError));
                    return results;
                }
            }
            
            // Find out if the ZIP code contains any letters.
            var containsLetters:Boolean = false;
            for (i = 0; i < len; i++)
            {
                if (ROMAN_LETTERS.indexOf(zip.charAt(i)) != -1)
                {
                    containsLetters = true;
                    break;
                }
            }
            
            // do an initial check on the length
            if ((len < 5 || len > 10) || (len == 8) || 
                (!containsLetters && (len == 6 || len == 7)))
            {
                // it's the wrong length for either a US or Canadian zip
                results.push(new ValidationResult(
                    true, baseField, "wrongLength",
                    validator.wrongLengthError));
                return results;
            }
            
            // if we got this far, we're doing good so far
            switch (domainType)
            {
                case DOMAIN_US:
                {
                    if (validator.validateUSCode(zip, containsLetters) == false)
                    {
                        results.push(new ValidationResult(
                                true, baseField, "wrongUSFormat",
                                validator.wrongUSFormatError));
                        return results;
                    }
                    break;
                }
                
                case DOMAIN_CANADA:
                {
                    if (validator.validateCACode(zip, containsLetters) == false)
                    {
                        results.push(new ValidationResult(
                            true, baseField, "wrongCAFormat",
                            validator.wrongCAFormatError));
                        return results;
                    }
                    break;
                }
                
                case DOMAIN_US_OR_CANADA:
                {
                    
                    var valid:Boolean = true;
                    var validationResult:ValidationResult;
                    
                    if (len == 5 || len == 9 || len == 10) // US
                    {
                        if (validator.validateUSCode(zip, containsLetters) == false)
                        {
                            validationResult = new ValidationResult(
                                true, baseField, "wrongUSFormat",
                                validator.wrongUSFormatError);
                                
                            valid = false;
                        }
                    }
                    else // CA
                    {
                        if (validator.validateCACode(zip, containsLetters) == false)
                        {
                            validationResult = new ValidationResult(
                                true, baseField, "wrongCAFormat",
                                validator.wrongCAFormatError);
                        
                            valid = false;
                        }
                    }
                    
                    if (!valid)
                    {         
                        results.push(validationResult);
                        return results;
                    }
                    break;
                }
            }

            return results;
        }
        
        /**
         *  @private
         */
        private function validateUSCode (zip:String, containsLetters:Boolean):Boolean
        {
            var len:int = zip.length;
                    
            if (containsLetters) 
            {
                return false;
            }
            
            // Make sure the first 5 characters are all digits.
            var i:uint;
            for (i = 0; i < 5; i++)
            {
                if (DECIMAL_DIGITS.indexOf(zip.charAt(i)) == -1)
                {
                    return false;
                }
            }
            
            if (len == 9 || len == 10)
            {
                if (len == 10)
                {
                    // Make sure the 6th character
                    // is an allowed formatting character.
                    if (allowedFormatChars.indexOf(zip.charAt(5)) == -1)
                    {
                        return false;
                    }
                    i++;
                }
                
                // Make sure the remaining 4 characters are digits.
                for (; i < len; i++)
                {
                    if (DECIMAL_DIGITS.indexOf(zip.charAt(i)) == -1)
                    {
                        return false;
                    }
                }
            }
            
            return true;
        }
        
        /**
         *  @private
         */
        private function validateCACode (zip:String, containsLetters:Boolean):Boolean
        {
            var len:int = zip.length;
            
            // check the basics
            if (!containsLetters)
            {
                return false;
            }
            
            var i:uint = 0;

            // Make sure the zip is in the form 'ldlfdld'
            // where l is a letter, d is a digit,
            // and f is an allowed formatting character.
            if (ROMAN_LETTERS.indexOf(zip.charAt(i++)) == -1 ||
                DECIMAL_DIGITS.indexOf(zip.charAt(i++)) == -1 ||
                ROMAN_LETTERS.indexOf(zip.charAt(i++)) == -1)
            {
                return false;
            }
            
            if (len == 7 &&
                allowedFormatChars.indexOf(zip.charAt(i++)) == -1)
            {
                return false;
            }
            
            if (DECIMAL_DIGITS.indexOf(zip.charAt(i++)) == -1 ||
                ROMAN_LETTERS.indexOf(zip.charAt(i++)) == -1 ||
                DECIMAL_DIGITS.indexOf(zip.charAt(i++)) == -1)
            {
                return false;
            }
            
            return true;
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
        public function ZipCodeValidator()
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
         *  The set of formatting characters allowed in the ZIP code.
         *  This can not have digits or alphabets [a-z A-Z].
         *
         *  @default " -". 
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
                for (var i:int = 0; i < value.length; i++)
                {
                    var c:String = value.charAt(i);
                    if (DECIMAL_DIGITS.indexOf(c) != -1 ||
                        ROMAN_LETTERS.indexOf(c) != -1)
                    {
                        var message:String = resourceManager.getString(
                            "validators", "invalidFormatCharsZCV");
                        throw new Error(message);
                    }
                }
            }

            allowedFormatCharsOverride = value;

            _allowedFormatChars = value != null ?
                                value : " -";
        }

        //----------------------------------
        //  domain
        //----------------------------------

        /**
         *  @private
         *  Storage for the domain property.
         */
        private var _domain:String;
        
        /**
         *  @private
         */
        private var domainOverride:String;

        [Inspectable(category="General", defaultValue="null")]

        /** 
         *  Type of ZIP code to check.
         *  In MXML, valid values are <code>"US or Canada"</code>, 
         *  <code>"US Only"</code> and <code>"Canada Only"</code>.
         *
         *  <p>In ActionScript, you can use the following constants to set this property: 
         *  <code>ZipCodeValidatorDomainType.US_ONLY</code>, 
         *  <code>ZipCodeValidatorDomainType.US_OR_CANADA</code>, or
         *  <code>ZipCodeValidatorDomainType.CANADA_ONLY</code>.</p>
         *
         *  @default ZipCodeValidatorDomainType.US_ONLY
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get domain():String
        {
            return _domain;
        }

        /**
         *  @private
         */
        public function set domain(value:String):void
        {
            domainOverride = value;

            _domain = value != null ?
                    value : ZipCodeValidatorDomainType.US_ONLY;
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
         *  Error message when the ZIP code contains invalid characters.
         *
         *  @default "The ZIP code contains invalid characters."
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
                                value : "The ZIP code contains invalid characters.";
        }

        //----------------------------------
        //  invalidDomainError
        //----------------------------------
        
        /**
         *  @private
         *  Storage for the invalidDomainError property.
         */
        private var _invalidDomainError:String;
        
        /**
         *  @private
         */
        private var invalidDomainErrorOverride:String;

        [Inspectable(category="Errors", defaultValue="null")]

        /** 
         *  Error message when the <code>domain</code> property contains an invalid value.
         *
         *  @default "The domain parameter is invalid. It must be either 'US Only' or 'US or Canada'."
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get invalidDomainError():String
        {
            return _invalidDomainError;
        }

        /**
         *  @private
         */
        public function set invalidDomainError(value:String):void
        {
            invalidDomainErrorOverride = value;

            _invalidDomainError = value != null ?
                                value : "The domain parameter is invalid. It must be either 'US Only' or 'US or Canada'.";
        }
        
        //----------------------------------
        //  wrongCAFormatError
        //----------------------------------

        /**
         *  @private
         *  Storage for the wrongCAFormatError property.
         */
        private var _wrongCAFormatError:String;
        
        /**
         *  @private
         */
        private var wrongCAFormatErrorOverride:String;

        [Inspectable(category="Errors", defaultValue="null")]

        /** 
         *  Error message for an invalid Canadian postal code.
         *
         *  @default "The Canadian postal code must be formatted 'A1B 2C3'."
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get wrongCAFormatError():String
        {
            return _wrongCAFormatError;
        }

        /**
         *  @private
         */
        public function set wrongCAFormatError(value:String):void
        {
            wrongCAFormatErrorOverride = value;

            _wrongCAFormatError = value != null ?
                                value : "The Canadian postal code must be formatted 'A1B 2C3'.";
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
         *  Error message for an invalid US ZIP code.
         *
         *  @default "The ZIP code must be 5 digits or 5+4 digits."
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
                                value : "The ZIP code must be 5 digits or 5+4 digits.";
        }
        
        //----------------------------------
        //  wrongUSFormatError
        //----------------------------------

        /**
         *  @private
         *  Storage for the wrongUSFormatError property.
         */
        private var _wrongUSFormatError:String;
        
        /**
         *  @private
         */
        private var wrongUSFormatErrorOverride:String;

        [Inspectable(category="Errors", defaultValue="null")]

        /** 
         *  Error message for an incorrectly formatted ZIP code.
         *
         *  @default "The ZIP+4 code must be formatted '12345-6789'."
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get wrongUSFormatError():String
        {
            return _wrongUSFormatError;
        }

        /**
         *  @private
         */
        public function set wrongUSFormatError(value:String):void
        {
            wrongUSFormatErrorOverride = value;

            _wrongUSFormatError = value != null ?
                                value : "The ZIP+4 code must be formatted '12345-6789'.";
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
            domain = domainOverride;

            invalidDomainError = invalidDomainErrorOverride;
            invalidCharError = invalidCharErrorOverride;
            wrongCAFormatError = wrongCAFormatErrorOverride;
            wrongLengthError = wrongLengthErrorOverride;
            wrongUSFormatError = wrongUSFormatErrorOverride;    
        }

        /**
         *  Override of the base class <code>doValidation()</code> method
         *  to validate a ZIP code.
         *
         *  <p>You do not call this method directly;
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
            // or if the required property is set to false and length is 0.
            var val:String = value ? String(value) : "";
            if (results.length > 0 || ((val.length == 0) && !required))
                return results;
            else
                return ZipCodeValidator.validateZipCode(this, value, null);
        }
    }

}

