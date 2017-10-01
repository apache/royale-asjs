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

    import org.apache.flex.events.Event;
    import org.apache.flex.events.EventDispatcher;
    import org.apache.flex.core.IDocument;
    import org.apache.flex.core.Strand;
    import org.apache.flex.events.IEventDispatcher;

    //--------------------------------------
    //  Events
    //--------------------------------------

    /**
     *  Dispatched when validation succeeds.
     *
     *  @eventType org.apache.flex.utils.validation.ValidationResultEvent.VALID 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Event(name="valid", type="org.apache.flex.utils.validation.ValidationResultEvent")]

    /** 
     *  Dispatched when validation fails.
     *
     *  @eventType org.apache.flex.utils.validation.ValidationResultEvent.INVALID 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    [Event(name="invalid", type="org.apache.flex.utils.validation.ValidationResultEvent")]

    //--------------------------------------
    //  Other metadata
    //--------------------------------------

    // [ResourceBundle("core")]
    // [ResourceBundle("validators")]

    /**
     *  The Validator class is the base class for all Flex validators. 
     *  This class implements the ability for a validator to make a field
     *  required, which means that the user must enter a value in the field
     *  or the validation fails.
     * 
     *  @mxml
     *
     *  <p>The Validator class defines the following tag attributes, 
     *  which all of its subclasses inherit:</p>
     *
     *  <pre>
     *  &lt;mx:Validator 
     *    enabled="true|false" 
     *    listener="<i>Value of the source property</i>" 
     *    property="<i>No default</i>" 
     *    required="true|false" 
     *    requiredFieldError="This field is required." 
     *    source="<i>No default</i>" 
     *    trigger="<i>Value of the source property</i>" 
     *    triggerEvent="valueCommit" 
     *  /&gt;
     *  </pre>
     *
     *  @see org.apache.flex.utils.validation.ValidationResultEvent
     *  @see mx.validators.ValidationResult
     *  @see mx.validators.RegExpValidationResult
     *
     *  @includeExample examples/SimpleValidatorExample.mxml
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public class Validator extends Strand implements IDocument,IValidator
    {

        //--------------------------------------------------------------------------
        //
        //  Class constants
        //
        //--------------------------------------------------------------------------

        /**
         *  A string containing the upper- and lower-case letters
         *  of the Roman alphabet  ("A" through "Z" and "a" through "z").
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected static const ROMAN_LETTERS:String =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

        /**
         *  A String containing the decimal digits 0 through 9.    
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */ 
        protected static const DECIMAL_DIGITS:String = "0123456789";
        
        //--------------------------------------------------------------------------
        //
        //  Class methods
        //
        //--------------------------------------------------------------------------

        /**
         *  Invokes all the validators in the <code>validators</code> Array.
         *  Returns an Array containing one ValidationResultEvent object 
         *  for each validator that failed.
         *  Returns an empty Array if all validators succeed. 
         *
         *  @param validators An Array containing the Validator objects to execute. 
         *
         *  @return Array of ValidationResultEvent objects, where the Array
         *  contains one ValidationResultEvent object for each validator
         *  that failed. 
         *  The Array is empty if all validators succeed.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public static function validateAll(validators:Array):Array
        {   
            var result:Array = [];

            var n:int = validators.length;
            for (var i:int = 0; i < n; i++)
            {
                var v:Validator = validators[i] as Validator;
                if (v && v.enabled)
                {
                    var resultEvent:ValidationResultEvent = v.validate();
                    
                    if (resultEvent.type != ValidationResultEvent.VALID)
                        result.push(resultEvent);
                }
            }   
            
            return result;
        }
        
        /**
         *  @private
         */
        private static function trimString(str:String):String
        {
            var startIndex:int = 0;
            while (str.indexOf(' ', startIndex) == startIndex)
            {
                ++startIndex;
            }

            var endIndex:int = str.length - 1;
            while (str.lastIndexOf(' ', endIndex) == endIndex)
            {
                --endIndex;
            }

            return endIndex >= startIndex ?
                str.slice(startIndex, endIndex + 1) :
                "";
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
        public function Validator()
        {
            super();
        }
        //----------------------------------
        //  subFields
        //----------------------------------

        /**
         *  An Array of Strings containing the names for the properties contained 
         *  in the <code>value</code> Object passed to the <code>validate()</code> method. 
         *  For example, CreditCardValidator sets this property to 
         *  <code>[ "cardNumber", "cardType" ]</code>. 
         *  This value means that the <code>value</code> Object 
         *  passed to the <code>validate()</code> method 
         *  should contain a <code>cardNumber</code> and a <code>cardType</code> property. 
         *
         *  <p>Subclasses of the Validator class that 
         *  validate multiple data fields (like CreditCardValidator and DateValidator)
         *  should assign this property in their constructor. </p>
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected var subFields:Array = [];


        
        //--------------------------------------------------------------------------
        //
        //  Properties: Errors
        //
        //--------------------------------------------------------------------------

        //----------------------------------
        //  requiredFieldError
        //----------------------------------

        /**
         *  @private
         *  Storage for the requiredFieldError property.
         */
        private var _requiredFieldError:String;
        
        /**
         *  @private
         */
        private var requiredFieldErrorOverride:String;

        [Inspectable(category="Errors", defaultValue="null")]
        
        /**
         *  Error message when a value is missing and the 
         *  <code>required</code> property is <code>true</code>. 
         *  
         *  @default "This field is required."
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function get requiredFieldError():String
        {
            return _requiredFieldError;
        }

        /**
         *  @private
         */
        public function set requiredFieldError(value:String):void
        {
            requiredFieldErrorOverride = value;
            isRealValue(value)
            if(isRealValue(value))
                _requiredFieldError = value;
        }
        
        /**
         *  Returns <code>true</code> if <code>value</code> is not null. 
         * 
         *  @param value The value to test.
         *
         *  @return <code>true</code> if <code>value</code> is not null.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected function isRealValue(value:Object):Boolean
        {
            return (value != null); 
        }

        /**
         *  Performs validation and optionally notifies
         *  the listeners of the result. 
         *
         *  @param value Optional value to validate.
         *  If null, then the validator uses the <code>source</code> and
         *  <code>property</code> properties to determine the value.
         *  If you specify this argument, you should also set the
         *  <code>listener</code> property to specify the target component
         *  for any validation error messages.
         *
         *  @param suppressEvents If <code>false</code>, then after validation,
         *  the validator will notify the listener of the result.
         *
         *  @return A ValidationResultEvent object
         *  containing the results of the validation. 
         *  For a successful validation, the
         *  <code>ValidationResultEvent.results</code> Array property is empty. 
         *  For a validation failure, the
         *  <code>ValidationResultEvent.results</code> Array property contains
         *  one ValidationResult object for each field checked by the validator, 
         *  both for fields that failed the validation and for fields that passed. 
         *  Examine the <code>ValidationResult.isError</code>
         *  property to determine if the field passed or failed the validation. 
         *
         *  @see mx.events.ValidationResultEvent
         *  @see mx.validators.ValidationResult
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public function validate(
                            value:Object = null,
                            suppressEvents:Boolean = false):ValidationResultEvent
        {   
            if (isRealValue(value))
            {
                // Validate if the target is required or our value is non-null.
                return processValidation(value, suppressEvents);
            }
            else
            {
                // We assume if value is null and required is false that
                // validation was successful.
                var resultEvent:ValidationResultEvent = 
                    new ValidationResultEvent(ValidationResultEvent.VALID);
                if (!suppressEvents && enabled)
                {
                    dispatchEvent(resultEvent);
                }
                return resultEvent; 
            } 
        }
        
        /** 
         *  @private 
         *  Main internally used function to handle validation process.
         */ 
        private function processValidation(
                            value:Object,
                            suppressEvents:Boolean):ValidationResultEvent
        {   
            var resultEvent:ValidationResultEvent;
            
            if (enabled)
            {
                var errorResults:Array = doValidation(value);

                resultEvent = handleResults(errorResults);
            }           
            else
            {
                suppressEvents = true; // Don't send any events
            }
            
            if (!suppressEvents)
            {
                dispatchEvent(resultEvent);
            }

            return resultEvent;
        }

        /**
         *  Executes the validation logic of this validator, 
         *  including validating that a missing or empty value
         *  causes a validation error as defined by
         *  the value of the <code>required</code> property.
         *
         *  <p>If you create a subclass of a validator class,
         *  you must override this method. </p>
         *
         *  @param value Value to validate.
         *
         *  @return For an invalid result, an Array of ValidationResult objects,
         *  with one ValidationResult object for each field examined
         *  by the validator that failed validation.
         *
         *  @see mx.validators.ValidationResult
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected function doValidation(value:Object):Array
        {
            var results:Array = [];
            
            var result:ValidationResult = validateRequired(value);
            if (result)
                results.push(result);
                
            return results;
        }
                
        /**
         *  @private 
         *  Determines if an object is valid based on its
         *  <code>required</code> property.
         *  This is a convenience method for calling a validator from within a 
         *  custom validation function. 
         */
        private function validateRequired(value:Object):ValidationResult
        {
            if (required)
            {
                var val:String = (value != null) ? String(value) : "";

                val = trimString(val);

                // If the string is empty and required is set to true
                // then throw a requiredFieldError.
                if (val.length == 0)
                {
                    return new ValidationResult(true, "", "requiredField",
                                                requiredFieldError);                 
                }
            }
            
            return null;
        }

        [Inspectable(category="General", defaultValue="true")]
        
        /**
         *  If <code>true</code>, specifies that a missing or empty 
         *  value causes a validation error. 
         *  
         *  @default true
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public var required:Boolean = true;

        [Inspectable(category="General", defaultValue="true")]
        
        /** 
         *  Setting this value to <code>false</code> will stop the validator
         *  from performing validation. 
         *  When a validator is disabled, it dispatch no events, 
         *  and the <code>validate()</code> method returns null.
         *
         *  @default true
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        public var enabled:Boolean = true;

        /**
         *  Returns a ValidationResultEvent from the Array of error results. 
         *  Internally, this function takes the results from the 
         *  <code>doValidation()</code> method and puts it into a ValidationResultEvent object. 
         *  Subclasses, such as the RegExpValidator class, 
         *  should override this function if they output a subclass
         *  of ValidationResultEvent objects, such as the RegExpValidationResult objects, and 
         *  needs to populate the object with additional information. You never
         *  call this function directly, and you should rarely override it. 
         *
         *  @param errorResults Array of ValidationResult objects.
         * 
         *  @return The ValidationResultEvent returned by the <code>validate()</code> method. 
         *  
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion Flex 3
         */
        protected function handleResults(errorResults:Array):ValidationResultEvent
        {
            var resultEvent:ValidationResultEvent;
            
            if (errorResults.length > 0)
            {
                resultEvent =
                    new ValidationResultEvent(ValidationResultEvent.INVALID);
                resultEvent.results = errorResults;
                
                if (subFields.length > 0)
                {
                    var errorFields:Object = {};
                    var subField:String;
                    
                    // Now we need to send valid results
                    // for every subfield that didn't fail.
                    var n:int;
                    var i:int;
                    
                    n = errorResults.length;
                    for (i = 0; i < n; i++)
                    {
                        subField = errorResults[i].subField;
                        if (subField)
                        {
                            errorFields[subField] = true;
                        }
                    }
                    
                    n = subFields.length;
                    for (i = 0; i < n; i++)
                    {
                        if (!errorFields[subFields[i]])
                        {
                            errorResults.push(new ValidationResult(false,subFields[i]));
                        }
                    }
                }
            }
            else
            {
                resultEvent = new ValidationResultEvent(ValidationResultEvent.VALID);
            }
            
            return resultEvent;
        }

        private var document:Object;
        
        /**
         *  @copy org.apache.flex.core.IDocument#setDocument()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function setDocument(document:Object, id:String = null):void
        {
            this.document = document;
        }

    }   

}
