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

package mx.events
{

/* import flash.events.Event; */

import org.apache.royale.events.Event;
import org.apache.royale.events.IRoyaleEvent;
/**
 *  The ValidationResultEvent class represents the event object 
 *  passed to the listener for the <code>valid</code> validator event
 *  or the <code>invalid</code> validator event. 
 *
 *  @see mx.validators.Validator
 *  @see mx.validators.ValidationResult
 *  @see mx.validators.RegExpValidationResult
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 *  @royalesuppresspublicvarwarning
 */
public class ValidationResultEvent extends Event
{
/*     include "../core/Version.as"; */

	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 *  The <code>ValidationResultEvent.INVALID</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for an <code>invalid</code> event.
	 *  The value of this constant is "invalid".
	 *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>field</code></td><td>The name of the field that failed validation.</td></tr>
     *     <tr><td><code>message</code></td><td>A single string that contains 
     *       every error message from all of the ValidationResult objects in the results Array.</td></tr>
     *     <tr><td><code>results</code></td><td>An array of ValidationResult objects, 
     *       one per validated field.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType invalid 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public static const INVALID:String = "invalid";

	/**
	 *  The <code>ValidationResultEvent.VALID</code> constant defines the value of the 
	 *  <code>type</code> property of the event object for a <code>valid</code>event.
	 *  The value of this constant is "valid".
	 *
	 *  <p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>field</code></td><td>An empty String.</td></tr>
     *     <tr><td><code>message</code></td><td>An empty String.</td></tr>
     *     <tr><td><code>results</code></td><td>An empty Array.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
	 *  </table>
	 *
     *  @eventType valid 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
	public static const VALID:String = "valid";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

	/**
	 *  Constructor.
	 *
	 *  @param type The event type; indicates the action that caused the event.
	 *
	 *  @param bubbles Specifies whether the event can bubble up the 
	 *  display list hierarchy.
	 *
	 *  @param cancelable Specifies whether the behavior associated with the event can be prevented.
	 *
	 *  @param field The name of the field that failed validation and triggered the event.
	 *
	 *  @param results An array of ValidationResult objects, one per validated field. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
    public function ValidationResultEvent(type:String, bubbles:Boolean = false,
										  cancelable:Boolean = false,
										  field:String = null,
										  results:Array = null)
    {
        super(type, bubbles, cancelable);

        this.field = field;
        this.results = results;
    }

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
    //  field
    //----------------------------------

	/**
	 *  The name of the field that failed validation and triggered the event.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
    public var field:String;
	
	//----------------------------------
    //  message
    //----------------------------------

	/**
	 *  A single string that contains every error message from all
	 *  of the ValidationResult objects in the results Array.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
    public function get message():String
    {
        var msg:String = "";
		var n:int;
		
		if (results)
			n = results.length;
		
		for (var i:int = 0; i < n; ++i)
        {
			if (results[i].isError)
			{
	            msg += msg == "" ? "" : "\n";
				msg += results[i].errorMessage;
			}
        }
        
		return msg;
    }

	//----------------------------------
    //  results
    //----------------------------------

	/**
	 *  An array of ValidationResult objects, one per validated field. 
	 *
	 *  @see mx.validators.ValidationResult
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 0.9.3
	 */
    public var results:Array;
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods: Event
	//
	//--------------------------------------------------------------------------

	/**
	 *  @private
	 */
	override public function cloneEvent():IRoyaleEvent
	{
		return new ValidationResultEvent(type, bubbles, cancelable,
										 field, results);
	}
}

}
