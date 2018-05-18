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
    import mx.events.FlexEvent;
    import org.apache.royale.events.IEventDispatcher;
    import mx.events.ValidationResultEvent;
//import mx.managers.SystemManager;

[ResourceBundle("validators")]

[Alternative(replacement="spark.validators.NumberValidator", since="4.5")]
/**
 *  The NumberValidator class ensures that a String represents a valid number.
 *  It can ensure that the input falls within a given range
 *  (specified by <code>minValue</code> and <code>maxValue</code>),
 *  is an integer (specified by <code>domain</code>),
 *  is non-negative (specified by <code>allowNegative</code>),
 *  and does not exceed the specified <code>precision</code>.
 *  The validator correctly validates formatted numbers (e.g., "12,345.67")
 *  and you can customize the <code>thousandsSeparator</code> and
 *  <code>decimalSeparator</code> properties for internationalization.
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;mx:NumberValidator&gt;</code> tag
 *  inherits all of the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:NumberValidator 
 *    allowNegative="true|false" 
 *    decimalPointCountError="The decimal separator can only occur once." 
 *    decimalSeparator="." 
 *    domain="real|int" 
 *    exceedsMaxError="The number entered is too large." 
 *    integerError="The number must be an integer." 
 *    invalidCharError="The input contains invalid characters." 
 *    invalidFormatCharsError="One of the formatting parameters is invalid." 
 *    lowerThanMinError="The amount entered is too small." 
 *    maxValue="NaN" 
 *    minValue="NaN" 
 *    negativeError="The amount may not be negative." 
 *    precision="-1" 
 *    precisionError="The amount entered has too many digits beyond the decimal point." 
 *    separationError="The thousands separator must be followed by three digits." 
 *    thousandsSeparator="," 
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/NumberValidatorExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class NumberValidator extends Validator
{
//	include "../core/Version.as";

    /**
     *  Convenience method for calling a validator
	 *  from within a custom validation function.
	 *  Each of the standard Flex validators has a similar convenience method.
	 *
	 *  @param validator The NumberValidator instance.
	 *
	 *  @param value A field to validate.
	 *
     *  @param baseField Text representation of the subfield
	 *  specified in the <code>value</code> parameter.
	 *  For example, if the <code>value</code> parameter specifies value.number,
	 *  the <code>baseField</code> value is "number".
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
	public function NumberValidator()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  allowNegative
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the allowNegative property.
	 */
	private var _allowNegative:Object;
	
    /**
	 *  @private
	 */
	//private var allowNegativeOverride:Object;

    [Inspectable(category="General", defaultValue="null")]

    /**
     *  Specifies whether negative numbers are permitted.
	 *  Valid values are <code>true</code> or <code>false</code>.
	 *
	 *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	public function get allowNegative():Object
	{
		return _allowNegative;
	}

	/**
	 *  @private
	 */
	public function set allowNegative(value:Object):void
	{
		//allowNegativeOverride = value;

		_allowNegative = value != null ?
						 Boolean(value) : false;
	//					 resourceManager.getBoolean(
	//					     "validators", "allowNegative");
	}

	//----------------------------------
	//  decimalSeparator
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the decimalSeparator property.
	 */
	private var _decimalSeparator:String;
	
    /**
	 *  @private
	 */
	//private var decimalSeparatorOverride:String;

    [Inspectable(category="General", defaultValue="null")]

    /**
     *  The character used to separate the whole
	 *  from the fractional part of the number.
	 *  Cannot be a digit and must be distinct from the
     *  <code>thousandsSeparator</code>.
	 *
	 *  @default "."
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */	
	public function get decimalSeparator():String
	{
		return _decimalSeparator;
	}

	/**
	 *  @private
	 */
	public function set decimalSeparator(value:String):void
	{
		//decimalSeparatorOverride = value;

		_decimalSeparator = value != null ?
							value : "";
	//						resourceManager.getString(
	//						    "validators", "decimalSeparator");
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
	//private var domainOverride:String;

    [Inspectable(category="General", enumeration="int,real", defaultValue="null")]

    /**
     *  Type of number to be validated.
	 *  Permitted values are <code>"real"</code> and <code>"int"</code>.
	 *
	 *  <p>In ActionScript, you can use the following constants to set this property: 
     *  <code>NumberValidatorDomainType.REAL</code> or
     *  <code>NumberValidatorDomainType.INT</code>.</p>
     * 
	 *  @default "real"
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
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
		//domainOverride = value;

		_domain = value != null ?
				  value : "";
	//			  resourceManager.getString(
	//			      "validators", "numberValidatorDomain");
	}
	
	//----------------------------------
	//  maxValue
	//----------------------------------
	
    /**
	 *  @private
	 *  Storage for the maxValue property.
	 */
	private var _maxValue:Object;
	
    /**
	 *  @private
	 */
	//private var maxValueOverride:Object;

    [Inspectable(category="General", defaultValue="null")]

    /**
     *  Maximum value for a valid number. A value of NaN means there is no maximum.
	 *
	 *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	public function get maxValue():Object
	{
		return _maxValue;
	}

	/**
	 *  @private
	 */
	public function set maxValue(value:Object):void
	{
		//maxValueOverride = value;

		_maxValue = value != null ?
					Number(value) : 0;
	//				resourceManager.getNumber(
	//					"validators", "maxValue");
	}

	//----------------------------------
	//  minValue
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the minValue property.
	 */
	private var _minValue:Object;
	
    /**
	 *  @private
	 */
	//private var minValueOverride:Object;

    [Inspectable(category="General", defaultValue="null")]

    /**
     *  Minimum value for a valid number. A value of NaN means there is no minimum.
	 *
	 *  @default NaN
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	public function get minValue():Object
	{
		return _minValue;
	}

	/**
	 *  @private
	 */
	public function set minValue(value:Object):void
	{
		//minValueOverride = value;

		_minValue = value != null ?
					Number(value) : 0;
	//				resourceManager.getNumber(
	//					"validators", "minValue");
	}
	
	//----------------------------------
	//  precision
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the precision property.
	 */
	private var _precision:Object;
	
    /**
	 *  @private
	 */
	//private var precisionOverride:Object;

    [Inspectable(category="General", defaultValue="null")]

    /**
     *  The maximum number of digits allowed to follow the decimal point.
	 *  Can be any nonnegative integer. 
	 *  Note: Setting to <code>0</code> has the same effect
	 *  as setting <code>domain</code> to <code>"int"</code>.
	 *  A value of -1 means it is ignored.
	 *
	 *  @default -1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	public function get precision():Object
	{
		return _precision;
	}

	/**
	 *  @private
	 */
	public function set precision(value:Object):void
	{
		//precisionOverride = value;

		_precision = value != null ?
					 int(value) : 0;
	//				 resourceManager.getInt(
	//				     "validators", "numberValidatorPrecision");
	}
	
 	//----------------------------------
	//  thousandsSeparator
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the thousandsSeparator property.
	 */
	private var _thousandsSeparator:String;
	
    /**
	 *  @private
	 */
	//private var thousandsSeparatorOverride:String;

    [Inspectable(category="General", defaultValue="null")]

    /**
     *  The character used to separate thousands
	 *  in the whole part of the number.
	 *  Cannot be a digit and must be distinct from the
     *  <code>decimalSeparator</code>.
	 *
	 *  @default ","
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	public function get thousandsSeparator():String
	{
		return _thousandsSeparator;
	}

	/**
	 *  @private
	 */
	public function set thousandsSeparator(value:String):void
	{
		//thousandsSeparatorOverride = value;

		_thousandsSeparator = value != null ?
							  value : "";
	//						  resourceManager.getString(
	//						      "validators", "thousandsSeparator");
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties: Errors
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  decimalPointCountError
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the decimalPointCountError property.
	 */
	private var _decimalPointCountError:String;
	
    /**
	 *  @private
	 */
	//private var decimalPointCountErrorOverride:String;

    [Inspectable(category="Errors", defaultValue="null")]

    /**
     *  Error message when the decimal separator character occurs more than once.
	 *
	 *  @default "The decimal separator can occur only once."
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	public function get decimalPointCountError():String
	{
		return _decimalPointCountError;
	}

	/**
	 *  @private
	 */
	public function set decimalPointCountError(value:String):void
	{
		//decimalPointCountErrorOverride = value;

		_decimalPointCountError = value != null ?
								  value : "";
	//							  resourceManager.getString(
	//							      "validators", "decimalPointCountError");
	}
	
	//----------------------------------
	//  exceedsMaxError
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the exceedsMaxError property.
	 */
	private var _exceedsMaxError:String;
	
    /**
	 *  @private
	 */
	//private var exceedsMaxErrorOverride:String;

    [Inspectable(category="Errors", defaultValue="null")]

    /**
     *  Error message when the value exceeds the <code>maxValue</code> property.
	 *
	 *  @default "The number entered is too large."
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	public function get exceedsMaxError():String
	{
		return _exceedsMaxError;
	}

	/**
	 *  @private
	 */
	public function set exceedsMaxError(value:String):void
	{
		//exceedsMaxErrorOverride = value;

		_exceedsMaxError = value != null ?
						   value : "";
	//					   resourceManager.getString(
	//					       "validators", "exceedsMaxErrorNV");
	}
	
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
	//private var invalidCharErrorOverride:String;

    [Inspectable(category="Errors", defaultValue="null")]

    /**
     *  Error message when the value contains invalid characters.
	 *
	 *  @default The input contains invalid characters."
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
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
		//invalidCharErrorOverride = value;

		_invalidCharError = value != null ?
							value : "";
	//						resourceManager.getString(
	//							"validators", "invalidCharError");
	}

	//----------------------------------
	//  lowerThanMinError
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the lowerThanMinError property.
	 */
	private var _lowerThanMinError:String;
	
    /**
	 *  @private
	 */
	//private var lowerThanMinErrorOverride:String;

    [Inspectable(category="Errors", defaultValue="null")]

    /**
     *  Error message when the value is less than <code>minValue</code>.
	 *
	 *  @default "The amount entered is too small."
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	public function get lowerThanMinError():String
	{
		return _lowerThanMinError;
	}

	/**
	 *  @private
	 */
	public function set lowerThanMinError(value:String):void
	{
		//lowerThanMinErrorOverride = value;

		_lowerThanMinError = value != null ?
							 value : "";
	//						 resourceManager.getString(
	//						     "validators", "lowerThanMinError");
	}

	//----------------------------------
	//  negativeError
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the negativeError property.
	 */
	private var _negativeError:String;
	
    /**
	 *  @private
	 */
	//private var negativeErrorOverride:String;

    [Inspectable(category="Errors", defaultValue="null")]

    /**
     *  Error message when the value is negative and the 
     *  <code>allowNegative</code> property is <code>false</code>.
	 *
	 *  @default "The amount may not be negative."
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	public function get negativeError():String
	{
		return _negativeError;
	}

	/**
	 *  @private
	 */
	public function set negativeError(value:String):void
	{
		//negativeErrorOverride = value;

		_negativeError = value != null ?
						 value : "";
	//					 resourceManager.getString(
	//					     "validators", "negativeError");
	}

	//----------------------------------
	//  precisionError
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the precisionError property.
	 */
	private var _precisionError:String;
	
    /**
	 *  @private
	 */
	//private var precisionErrorOverride:String;

    [Inspectable(category="Errors", defaultValue="null")]

    /**
     *  Error message when the value has a precision that exceeds the value defined 
     *  by the precision property.
	 *
	 *  @default "The amount entered has too many digits beyond the decimal point."
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	public function get precisionError():String
	{
		return _precisionError;
	}

	/**
	 *  @private
	 */
	public function set precisionError(value:String):void
	{
		//precisionErrorOverride = value;

		_precisionError = value != null ?
						  value : "";
	//					  resourceManager.getString(
	//					      "validators", "precisionError");
	}

	//----------------------------------
	//  separationError
	//----------------------------------

    /**
	 *  @private
	 *  Storage for the separationError property.
	 */
	private var _separationError:String;
	
    /**
	 *  @private
	 */
	//private var separationErrorOverride:String;

    [Inspectable(category="Errors", defaultValue="null")]

    /**
     *  Error message when the thousands separator is in the wrong location.
	 *
	 *  @default "The thousands separator must be followed by three digits."
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
	public function get separationError():String
	{
		return _separationError;
	}

	/**
	 *  @private
	 */
	public function set separationError(value:String):void
	{
		//separationErrorOverride = value;

		_separationError = value != null ?
						   value : "";
	//					   resourceManager.getString(
	//					       "validators", "separationError");
	}

    //----------------------------------
    //  enabled
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the enabled property.
     */
    private var _enabled:Boolean = true;
    
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
    *  @productversion Royale 0.9.3
     */
    public function get enabled():Boolean
    {
        return _enabled;
    }

    /**
     *  @private
     */
    public function set enabled(value:Boolean):void
    {
        _enabled = value;
    }
    

    //----------------------------------
    //  property
    //----------------------------------    
    
    /**
     *  @private
     *  Storage for the property property.
     */
    private var _property:String;
    
    [Inspectable(category="General")]

    /**
     *  A String specifying the name of the property
     *  of the <code>source</code> object that contains 
     *  the value to validate.
     *  The property is optional, but if you specify <code>source</code>,
     *  you should set a value for this property as well.
     *  
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
    *  @productversion Royale 0.9.3
     */
    public function get property():String
    {
        return _property;
    }

    /**
     *  @private
     */
    public function set property(value:String):void
    {
        _property = value;
    }
    
    //----------------------------------
    //  source
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the source property.
     */
    private var _source:Object;
    
    [Inspectable(category="General")]
	[Bindable("sourceChanged")]
    /**
     *  Specifies the object containing the property to validate. 
     *  Set this to an instance of a component or a data model. 
     *  You use data binding syntax in MXML to specify the value.
     *  This property supports dot-delimited Strings
     *  for specifying nested properties. 
     *
     *  If you specify a value to the <code>source</code> property,
     *  then you should specify a value to the <code>property</code>
     *  property as well. 
     *  The <code>source</code> property is optional.
     *  
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
    *  @productversion Royale 0.9.3
     */
    public function get source():Object
    {
        return _source;
    }
    
    /**
     *  @private
     */
    public function set source(value:Object):void
    {
        if (_source == value)
            return;
        
        if (value is String)
        {
            var message:String = "" ; //resourceManager.getString(
               // "validators", "SAttribute", [ value ]);
            throw new Error(message);
        }
        
        // Remove the listener from the old source.
        //removeTriggerHandler();
        //removeListenerHandler();
        
        _source = value;
                
        // Listen for the trigger event on the new source.
        //addTriggerHandler();    
        //addListenerHandler();
		//dispatchEvent(new Event("sourceChanged"));
    }

    //----------------------------------
    //  trigger
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the trigger property.
     */
    private var _trigger:IEventDispatcher;
    
    [Inspectable(category="General")]

    /**
     *  Specifies the component generating the event that triggers the validator. 
     *  If omitted, by default Flex uses the value of the <code>source</code> property.
     *  When the <code>trigger</code> dispatches a <code>triggerEvent</code>,
     *  validation executes. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
    *  @productversion Royale 0.9.3
     */
    public function get trigger():IEventDispatcher
    {
        return _trigger;
    }
    
    /**
     *  @private
     */
    public function set trigger(value:IEventDispatcher):void
    {
        //removeTriggerHandler();
        _trigger = value;
        //addTriggerHandler();    
    }
    
    //----------------------------------
    //  triggerEvent
    //----------------------------------
    
    /**
     *  @private
     *  Storage for the triggerEvent property.
     */
    private var _triggerEvent:String = FlexEvent.VALUE_COMMIT;
    
    [Inspectable(category="General")]

    /**
     *  Specifies the event that triggers the validation. 
     *  If omitted, Flex uses the <code>valueCommit</code> event. 
     *  Flex dispatches the <code>valueCommit</code> event
     *  when a user completes data entry into a control.
     *  Usually this is when the user removes focus from the component, 
     *  or when a property value is changed programmatically.
     *  If you want a validator to ignore all events,
     *  set <code>triggerEvent</code> to the empty string ("").
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
    *  @productversion Royale 0.9.3
     */
    public function get triggerEvent():String
    {
        return _triggerEvent;
    }
    
    /**
     *  @private
     */
    public function set triggerEvent(value:String):void
    {
        if (_triggerEvent == value)
            return;
            
        //removeTriggerHandler();
        _triggerEvent = value;
        //addTriggerHandler();
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
    *  @productversion Royale 0.9.3
     */
    public function validate(
                        value:Object = null,
                        suppressEvents:Boolean = false):ValidationResultEvent
    {   
        /*if (value == null)
            value = getValueFromSource();   
        
        if (isRealValue(value) || required)
        {
            // Validate if the target is required or our value is non-null.
            return processValidation(value, suppressEvents);
        }
        else
        {*/
            // We assume if value is null and required is false that
            // validation was successful.
            var resultEvent:ValidationResultEvent; /*= handleResults(null);
            if (!suppressEvents && _enabled)
            {
                dispatchEvent(resultEvent);
            }*/
            return resultEvent; 
        //} 
    }
    
 }

}
