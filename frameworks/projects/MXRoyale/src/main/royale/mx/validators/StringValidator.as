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

/* import mx.managers.ISystemManager;
import mx.managers.SystemManager; */
import mx.utils.StringUtil;

//[ResourceBundle("validators")]

/**
 *  The StringValidator class validates that the length of a String 
 *  is within a specified range. 
 *  
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:StringValidator&gt;</code> tag
 *  inherits all of the tag attributes of its superclass,
 *  and add the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:StringValidator
 *    maxLength="NaN" 
 *    minLength="NaN" 
 *    tooLongError="This string is longer than the maximum allowed length. This must be less than {0} characters long." 
 *    tooShortError="This string is shorter than the minimum allowed length. This must be at least {0} characters long." 
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/StringValidatorExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class StringValidator extends Validator
{
   // include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------

    /**
     *  Convenience method for calling a validator.
     *  Each of the standard Flex validators has a similar convenience method.
     *
     *  @param validator The StringValidator instance.
     *
     *  @param value A field to validate.
     *
     *  @param baseField Text representation of the subfield
     *  specified in the <code>value</code> parameter.
     *  For example, if the <code>value</code> parameter specifies
     *  value.mystring, the <code>baseField</code> value
     *  is <code>"mystring"</code>.
     *
     *  @return An Array of ValidationResult objects, with one
     *  ValidationResult  object for each field examined by the validator. 
     *
     *  @see mx.validators.ValidationResult
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static function validateString(validator:StringValidator,
                                          value:Object,
                                          baseField:String = null):Array
    {
        var results:Array = [];
        
        // Resource-backed properties of the validator.
        var maxLength:Number = Number(validator.maxLength);
        var minLength:Number = Number(validator.minLength);

        var val:String = value != null ? String(value) : "";

        if (!isNaN(maxLength) && val.length > maxLength)
        {
            results.push(new ValidationResult(
                true, baseField, "tooLong",
                StringUtil.substitute(validator.tooLongError, maxLength)));
            return results;
        }

        if (!isNaN(minLength) && val.length < minLength)
        {
            results.push(new ValidationResult(
                true, baseField, "tooShort",
                StringUtil.substitute(validator.tooShortError, minLength)));
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
    public function StringValidator()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  maxLength
    //----------------------------------

    /**
     *  @private
     *  Storage for the maxLength property.
     */
    private var _maxLength:Object;
    
    /**
     *  @private
     */
    private var maxLengthOverride:Object;
    
    [Inspectable(category="General", defaultValue="null")]

    /** 
     *  Maximum length for a valid String. 
     *  A value of NaN means this property is ignored.
     *
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get maxLength():Object
    {
        return _maxLength;
    }

    /**
     *  @private
     */
    public function set maxLength(value:Object):void
    {
       /*  maxLengthOverride = value; */

        _maxLength = value != null ?
                     Number(value) : /*
                     resourceManager.getNumber(
                         "validators", "maxLength"); */ 20;
    }
    
    //----------------------------------
    //  minLength
    //----------------------------------

    /**
     *  @private
     *  Storage for the minLength property.
     */
    private var _minLength:Object;
    
    /**
     *  @private
     */
    private var minLengthOverride:Object;
    
    [Inspectable(category="General", defaultValue="null")]

    /** 
     *  Minimum length for a valid String.
     *  A value of NaN means this property is ignored.
     *
     *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get minLength():Object
    {
        return _minLength;
    }

    /**
     *  @private
     */
    public function set minLength(value:Object):void
    {
       /*  minLengthOverride = value;*/

        _minLength = value != null ?
                     Number(value) : /*
                     resourceManager.getNumber(
                         "validators", "minLength"); */ 0;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties: Errors
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  tooLongError
    //----------------------------------

    /**
     *  @private
     *  Storage for the tooLongError property.
     */
    private var _tooLongError:String = "This string is longer than the maximum allowed length. This must be less than {0} characters long.";

    /**
     *  @private
     */
    //private var tooLongErrorOverride:String;
    
    //[Inspectable(category="Errors", defaultValue="null")]

    /** 
     *  Error message when the String is longer
     *  than the <code>maxLength</code> property.
     *
     *  @default "This string is longer than the maximum allowed length. This must be less than {0} characters long."
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get tooLongError():String 
    {
        return _tooLongError;
    }

    /**
     *  @private
     */
    public function set tooLongError(value:String):void
    {
        //tooLongErrorOverride = value;

        _tooLongError = value != null ?
                        value :
                        /*resourceManager.getString(
                            "validators", */"tooLongError"/*)*/;
    }

    //----------------------------------
    //  tooShortError
    //----------------------------------

    /**
     *  @private
     *  Storage for the tooShortError property.
     */
    private var _tooShortError:String = "This string is shorter than the minimum allowed length. This must be at least {0} characters long.";
    
    /**
     *  @private
     */
    //private var tooShortErrorOverride:String;
    
    //[Inspectable(category="Errors", defaultValue="null")]

    /** 
     *  Error message when the string is shorter
     *  than the <code>minLength</code> property.
     *
     *  @default "This string is shorter than the minimum allowed length. This must be at least {0} characters long."
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get tooShortError():String 
    {
        return _tooShortError;
    }

    /**
     *  @private
     */
    public function set tooShortError(value:String):void
    {
        //tooShortErrorOverride = value;

        _tooShortError = value != null ?
                         value :
                         /*resourceManager.getString(
                             "validators", */"tooShortError"/*)*/;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private    
     */
    /* override protected function resourcesChanged():void
    {
        super.resourcesChanged();

        maxLength = maxLengthOverride;
        minLength = minLengthOverride;

        tooLongError = tooLongErrorOverride;
        tooShortError = tooShortErrorOverride;
    } */

    /**
     *  Override of the base class <code>doValidation()</code> method
     *  to validate a String.
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
        // or if the required property is set to false and length is 0.
        var val:String = value ? String(value) : "";
        if (results.length > 0 || ((val.length == 0) && !required))
            return results;
        else
            return StringValidator.validateString(this, value, null);
    }
}

}
