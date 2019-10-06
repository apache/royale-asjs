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

import org.apache.royale.events.Event;
import org.apache.royale.events.IRoyaleEvent;

/**
 *  Represents events that are specific to the NumericStepper control.
 *
 *  @see mx.controls.NumericStepper
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class NumericStepperEvent extends Event
{
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------

	/**
	 *  The <code>NumericStepperEvent.CHANGE</code> constant defines the value of the
	 *  <code>type</code> property of the event object for a <code>change</code> event.
	 *
     *	<p>The properties of the event object have the following values:</p>
	 *  <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>cancelable</code></td><td>false</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the
     *       event listener that handles the event. For example, if you use
     *       <code>myButton.addEventListener()</code> to register an event listener,
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event;
     *       it is not always the Object listening for the event.
     *       Use the <code>currentTarget</code> property to always access the
     *       Object listening for the event.</td></tr>
     *     <tr><td><code>value</code></td><td>The value of the NumericStepper control 
     *       when the event was dispatched.</td></tr>
	 *  </table>
	 *
     *  @eventType change
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public static const CHANGE:String = "change";

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
	 *  @param bubbles Specifies whether the event can bubble up the display list hierarchy.
	 *
	 *  @param cancelable Specifies whether the behavior associated with the event can be prevented.
	 *
	 *  @param value The value of the NumericStepper control when the event was dispatched.
         *
         *  @param triggerEvent If the value changed in response to a user action, contains a value
         *  indicating the type of input action, either <code>InteractionInputType.MOUSE</code>
         *  or <code>InteractionInputType.KEYBOARD</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public function NumericStepperEvent(type:String, bubbles:Boolean = false,
                                        cancelable:Boolean = false,
                                        value:Number = NaN,
                                        triggerEvent:Event = null)
	{
		super(type, bubbles, cancelable);

        this.value = value;
        this.triggerEvent = triggerEvent;
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	//----------------------------------
	//  value
	//----------------------------------

	/**
	 *	The value of the NumericStepper control when the event was dispatched.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */	
	public var value:Number;

	//----------------------------------
	//  triggerEvent
	//----------------------------------

	/**
	 *  If the value is changed in response to a user action, 
	 *  this property contains a value indicating the type of input action. 
	 *  The value is either <code>InteractionInputType.MOUSE</code> 
	 *  or <code>InteractionInputType.KEYBOARD</code>.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public var triggerEvent:Event;
	

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
		return new NumericStepperEvent(type, bubbles, cancelable, value);
	}
}

}
