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

import mx.events.ValidationResultEvent;

/**
 *  The interface that components implement to support
 *  the Flex data validation mechanism. 
 *  The UIComponent class implements this interface.
 *  Therefore, any subclass of UIComponent also implements it.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public interface IValidatorListener
{
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  errorString
	//----------------------------------

	/**
     *  The text that will be displayed by a component's error tip when a
     *  component is monitored by a Validator and validation fails.
     *
     *  <p>You can use the <code>errorString</code> property to show a 
     *  validation error for a component, without actually using
	 *  a validator class. 
     *  When you write a String value to the <code>errorString</code> property, 
     *  Flex draws a red border around the component to indicate
	 *  the validation error, and the String appears in a tooltip
	 *  as the validation error message when you move  the mouse over
	 *  the component, just as if a validator detected a validation error.</p>
     *
     *  <p>To clear the validation error, write an empty String, "", 
     *  to the <code>errorString</code> property.</p>
     *
     *  <p>Note that writing a value to the <code>errorString</code> property 
     *  does not trigger the valid or invalid events; it only changes the 
     *  border color and displays the validation error message.</p>
 	 *  
 	 *  @langversion 3.0
 	 *  @playerversion Flash 9
 	 *  @playerversion AIR 1.1
 	 *  @productversion Flex 3
 	 */
	function get errorString():String;

	/**
	 *  @private
	 */
	function set errorString(value:String):void;

	//----------------------------------
	//  validationSubField
	//----------------------------------

	/**
	 *  Used by a validator to assign a subfield.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function get validationSubField():String;

	/**
	 *  @private
	 */
	function set validationSubField(value:String):void;

	//--------------------------------------------------------------------------
	//
	//  Event handlers
	//
	//--------------------------------------------------------------------------

	/**
	 *  Handles both the <code>valid</code> and <code>invalid</code> events
	 *  from a  validator assigned to this component.  
	 *
	 *  <p>You typically handle the <code>valid</code> and <code>invalid</code>
	 *  events dispatched by a validator by assigning event listeners
	 *  to the validators. 
	 *  If you want to handle validation events directly in the component
	 *  that is being validated, you can override this method
	 *  to handle the <code>valid</code> and <code>invalid</code> events.
	 *  From within your implementation, you can use the
	 *  <code>dispatchEvent()</code> method to dispatch the 
	 *  <code>valid</code> and <code>invalid</code> events
	 *  in the case where a validator is also listening for them.</p>
	 *
	 *  @param event The event object for the validation.
     *
     *  @see mx.events.ValidationResultEvent
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	function validationResultHandler(event:ValidationResultEvent):void;
}

}
