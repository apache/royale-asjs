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

    import mx.events.FlexEvent;
    import org.apache.royale.events.IEventDispatcher;
    import mx.events.ValidationResultEvent;
//import mx.resources.IResourceManager;
//import mx.resources.ResourceManager;

//[ResourceBundle("SharedResources")]
//[ResourceBundle("validators")]

/**
 *  The DateValidator class validates that a String, Date, or Object contains a 
 *  proper date and matches a specified format. Users can enter a single 
 *  digit or two digits for month, day, and year. 
 *  By default, the validator ensures the following formats:
 *
 *  <ul>
 *    <li>The month is between 1 and 12 (or 0-11 for <code>Date</code> objects)</li>
 *    <li>The day is between 1 and 31</li>
 *    <li>The year is a number</li>
 *  </ul>
 *
 *  <p>You can specify the date in the DateValidator class in two ways:</p>
 *  <ul>
 *    <li>Single String containing the date - Use the <code>source</code>
 *    and <code>property</code> properties to specify the String.
 *    The String can contain digits and the formatting characters
 *    specified by the <code>allowedFormatChars</code> property,
 *    which include the "/&#92;-. " characters. 
 *    By default, the input format of the date in a String field
 *    is "MM/DD/YYYY" where "MM" is the month, "DD" is the day,
 *    and "YYYY" is the year. 
 *    You can use the <code>inputFormat</code> property
 *    to specify a different format.</li>
 * 	  <li><code>Date</code> object.</li>
 *    <li>Object or multiple fields containing the day, month, and year.  
 *    Use all of the following properties to specify the day, month,
 *    and year inputs: <code>daySource</code>, <code>dayProperty</code>,
 *    <code>monthSource</code>, <code>monthProperty</code>,
 *    <code>yearSource</code>, and <code>yearProperty</code>.</li>
 *  </ul>
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;mx:DateValidator&gt;</code> tag
 *  inherits all of the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>  
 *  
 *  <pre>
 *  &lt;mx:DateValidator 
 *    allowedFormatChars="/&#92;-. " 
 *    dayListener="<i>Object specified by daySource</i>"
 *    dayProperty="<i>No default</i>"
 *    daySource="<i>No default</i>"
 *    formatError= "Configuration error: Incorrect formatting string." 
 *    includeFormatInError="true|false"
 *    inputFormat="MM/DD/YYYY" 
 *    invalidCharError="The date contains invalid characters."
 *    monthListener="<i>Object specified by monthSource</i>"
 *    monthProperty="<i>No default</i>"
 *    monthSource="<i>No default</i>"
 *    validateAsString="true|false"
 *    wrongDayError="Enter a valid day for the month."
 *    wrongLengthError="Type the date in the format <i>inputFormat</i>." 
 *    wrongMonthError="Enter a month between 1 and 12."
 *    wrongYearError="Enter a year between 0 and 9999."
 *    yearListener="<i>Object specified by yearSource</i>"
 *    yearProperty="<i>No default</i>"
 *    yearSource="<i>No default</i>"
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/DateValidatorExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class DateValidator extends Validator
{
	//include "../core/Version.as";

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
	 *  @param validator The DateValidator instance.
	 *
	 *  @param value A field to validate.
	 *
	 *  @param baseField Text representation of the subfield
	 *  specified in the value parameter. 
	 *  For example, if the <code>value</code> parameter
	 *  specifies value.date, the <code>baseField</code> value is "date".
	 *
	 *  @return An Array of ValidationResult objects, with one ValidationResult 
	 *  object for each field examined by the validator. 
	 *
	 *  @see mx.validators.ValidationResult
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
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
	public function DateValidator()
	{
		super(); 
	}  
	/** 
	 *  If <code>true</code> the date format is shown in some
	 *  validation error messages. Setting to <code>false</code>
	 *  changes all DateValidators.
	 *
	 *  @default true
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion ApacheFlex 4.10
	 */
	  
    /**
	 *  @private
	 *  Storage for the inputFormat property.
	 */
	private var _inputFormat:String;
	
    /**
	 *  @private
	 */ 
	[Inspectable(category="General", defaultValue="null")]

	/** 
	 *  The date format to validate the value against.
	 *  "MM" is the month, "DD" is the day, and "YYYY" is the year.
	 *  This String is case-sensitive.
	 *
	 *  @default "MM/DD/YYYY"
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public function get inputFormat():String
	{
		return _inputFormat;
	}

	/**
	 *  @private
	 */
	public function set inputFormat(value:String):void
	{ 
		_inputFormat = value != null ?
					   value : "";
					  // resourceManager.getString(
					  //    "SharedResources", "dateFormat");
	} 
	
	[Inspectable(category="General")]
  
	//----------------------------------
	//  formatError
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the formatError property.
	 */
	private var _formatError:String;
	
    /**
	 *  @private
	 */ 
	
	[Inspectable(category="Errors", defaultValue="null")]

	/** 
	 *  Error message when the <code>inputFormat</code> property
	 *  is not in the correct format.
	 *
	 *  @default "Configuration error: Incorrect formatting string." 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public function get formatError():String
	{
		return _formatError;
	}

	/**
	 *  @private
	 */
	public function set formatError(value:String):void
	{ 
		_formatError = value != null ?
					   value : "" ;
					 //  resourceManager.getString(
					  //     "validators", "formatError");
	}  

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
    //private var requiredFieldErrorOverride:String;

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
    *  @productversion Royale 0.9.3
     */
    override public function get requiredFieldError():String
    {
        return _requiredFieldError;
    }

    /**
     *  @private
     */
    override public function set requiredFieldError(value:String):void
    {
        //requiredFieldErrorOverride = value;

        _requiredFieldError = value != null ?
                              value : "" ;
                            //  resourceManager.getString(
                            //     "validators", "requiredFieldError");
    }

}

}
