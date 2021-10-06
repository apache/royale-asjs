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
 *  This interface specifies the methods and properties that a Validator 
 *  object must implement. 
 *  <p>This interface allows to validate multiple data
 *  types like numbers, currency, phone numbers, zip codes etc that
 *  are defined in both mx and spark namespaces. The classes 
 *  mx:Validator and spark:GlobaliationValidatorBase  
 *  implement this interface. The validateAll() method in these classes use
 *  this interface type to call the validate() method on 
 *  multiple validator objects.</p>
 *  
 *
 *  @see mx.validators.Validator
 *  @see spark.validators.GlobalizationValidatorBase
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4.5
 */
public interface IValidator
{
    //----------------------------------------------------------------------
    //
    //  Properties
    //
    //----------------------------------------------------------------------

    //----------------------------------
    //  enabled
    //----------------------------------

    /**
     *  Property to enable/disable validation process.
     *  <p>Setting this value to <code>false</code> will stop the validator
     *  from performing validation. 
     *  When a validator is disabled, it dispatches no events, 
     *  and the <code>validate()</code> method returns null.</p>
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.0
     *  @productversion Flex 4.5
     */
    function get enabled():Boolean;
    function set enabled(value:Boolean):void;
    
    //----------------------------------------------------------------------
    //
    //  Methods
    //
    //----------------------------------------------------------------------

    //----------------------------------
    //  validate
    //----------------------------------

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
     *  @playerversion Flash 10.1
     *  @playerversion AIR 2.5
     *  @productversion Flex 4.5
     */
    function validate(value:Object = null,
                      suppressEvents:Boolean = false):ValidationResultEvent
}
}
