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

    //import mx.events.FlexEvent;
    //import org.apache.royale.events.IEventDispatcher;
    //import mx.events.ValidationResultEvent;
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
	 
}

}
