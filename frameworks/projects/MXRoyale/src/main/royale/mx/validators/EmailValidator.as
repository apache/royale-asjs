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
	[ResourceBundle("validators")]
    
/**
 *  The EmailValidator class validates that a String has a single &#64; sign,
 *  a period in the domain name and that the top-level domain suffix has
 *  two, three, four, or six characters.
 *  IP domain names are valid if they are enclosed in square brackets. 
 *  The validator does not check whether the domain and user name
 *  actually exist.
 *
 *  <p>You can use IP domain names if they are enclosed in square brackets; 
 *  for example, myname&#64;[206.132.22.1].
 *  You can use individual IP numbers from 0 to 255.</p>
 *  
 *  @mxml
 *
 *  <p>The <code>&lt;mx:EmailValidator&gt;</code> tag
 *  inherits all of the tag attributes of its superclass,
 *  and adds the following tag attributes:</p>
 *  
 *  <pre>
 *  &lt;mx:EmailValidator 
 *    invalidCharError="Your e-mail address contains invalid characters."
 *    invalidDomainError= "The domain in your e-mail address is incorrectly formatted." 
 *    invalidIPDomainError="The IP domain in your e-mail address is incorrectly formatted." 
 *    invalidPeriodsInDomainError="The domain in your e-mail address has consecutive periods." 
 *    missingAtSignError="An at sign (&64;) is missing in your e-mail address."
 *    missingPeriodInDomainError="The domain in your e-mail address is missing a period." 
 *    missingUsernameError="The username in your e-mail address is missing." 
 *    tooManyAtSignsError="Your e-mail address contains too many &64; characters."
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/EmailValidatorExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class EmailValidator extends Validator
{
	//include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	private static const DISALLOWED_LOCALNAME_CHARS:String =
								"()<>,;:\\\"[] `~!#$%^&*={}|/?\t\n\r";
	/**
	 *  @private
	 */							
	private static const DISALLOWED_DOMAIN_CHARS:String =
								"()<>,;:\\\"[] `~!#$%^&*+={}|/?'\t\n\r";
	
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
	 *  @param validator The EmailValidator instance.
	 *
	 *  @param value A field to validate.
	 *
	 *  @param baseField Text representation of the subfield
	 *  specified in the value parameter.
	 *  For example, if the <code>value</code> parameter specifies value.email,
	 *  the <code>baseField</code> value is "email".
	 *
	 *  @return An Array of ValidationResult objects, with one
	 *  ValidationResult object for each field examined by the validator. 
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
	public function EmailValidator()
	{
		super();
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
