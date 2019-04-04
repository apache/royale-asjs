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

package mx.messaging.events
{

import org.apache.royale.events.Event;
import mx.messaging.messages.ErrorMessage;

/**
 * The MessageFaultEvent class is used to propagate fault messages within the messaging system.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 * 
 *  @royalesuppresspublicvarwarning
 */
public class MessageFaultEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    // Static Constants
    // 
    //--------------------------------------------------------------------------    

    /**
     *  The FAULT event type; dispatched for a message fault.
     *  <p>The value of this constant is <code>"fault"</code>.</p>
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
     *     <tr><td><code>faultCode</code></td><td>Provides destination-specific
     *       details of the failure.</td></tr>
     *     <tr><td><code>faultDetail</code></td><td>Provides access to the
     *       destination-specific reason for the failure.</td></tr>
     *     <tr><td><code>faultString</code></td><td>Provides access to the underlying
     *        reason for the failure if the channel did not raise the failure itself.</td></tr>
     *     <tr><td><code>message</code></td><td>The ErrorMessage for this event.</td></tr>    
     *     <tr><td><code>rootCause</code></td><td> Provides access to the underlying reason
     *       for the failure, if one exists.</td></tr>         
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *  @eventType fault
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */     
    public static const FAULT:String = "fault";

    //--------------------------------------------------------------------------
    //
    // Static Methods
    // 
    //--------------------------------------------------------------------------    
    
    /**
     *  Utility method to create a new MessageFaultEvent that doesn't bubble and
     *  is not cancelable.
     * 
     *  @param message The ErrorMessage associated with the fault.
     * 
     *  @return New MessageFaultEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static function createEvent(msg:ErrorMessage):MessageFaultEvent
    {
        return new MessageFaultEvent(MessageFaultEvent.FAULT, false, false, msg);
    }

    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------    
    
    /**
     *  Constructs an instance of a fault message event for the specified message
     *  and fault information.
     * 
     *  @param type The type for the MessageAckEvent.
     * 
     *  @param bubbles Specifies whether the event can bubble up the display 
     *  list hierarchy.
     * 
     *  @param cancelable Indicates whether the behavior associated with the 
     *  event can be prevented.
     * 
     *  @param message The ErrorMessage associated with the fault.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function MessageFaultEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
            message:ErrorMessage = null)
    {
        super(type, bubbles, cancelable);

        this.message = message;
    }
    
    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------    

    /**
     *  The ErrorMessage for this event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public var message:ErrorMessage;
    
    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

	//----------------------------------
	//  faultCode
	//----------------------------------

    /**
     *  Provides access to the destination specific failure code.
     *  For more specific details see <code>faultString</code> and
     *  <code>faultDetails</code> properties.
     *
     *  <p>The format of the fault codes are provided by the remote destination,
     *  but, will typically have the following form: <i>host.operation.error</i>
     *  For example, <code>"Server.Connect.Failed"</code></p>
     *
     *  @see #faultString
     *  @see #faultDetail
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get faultCode():String
    {
        return message.faultCode;
    }

	//----------------------------------
	//  faultDetail
	//----------------------------------

    /**
     *  Provides destination specific details of the failure.
     *
     *  <p>Typically fault details are a stack trace of an exception thrown at
     *  the remote destination.</p>
     *
     *  @see #faultString
     *  @see #faultCode
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get faultDetail():String
    {
        return message.faultDetail;
    }

	//----------------------------------
	//  faultString
	//----------------------------------

    /**
     *  Provides access to the destination specific reason for the failure.
     *
     *  @see #faultCode
     *  @see #faultDetail
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get faultString():String
    {
        return message.faultString;
    }

	//----------------------------------
	//  rootCause
	//----------------------------------

    /**
     *  Provides access to the root cause of the failure, if one exists.
     *
     *  In the case of custom exceptions thrown by a destination, the root cause
     *  represents the top level failure that is merely transported by the
     *  ErrorMessage.
     *
     *  @see MessageFaultEvent#rootCause
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get rootCause():Object
    {
        return message.rootCause;
    }

    //--------------------------------------------------------------------------
    //
    // Overridden Methods
    // 
    //--------------------------------------------------------------------------        

    /**
     *  Clones the MessageFaultEvent.
     *
     *  @return Copy of this MessageFaultEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    [SWFOverride(returns="flash.events.Event"))]
    COMPILE::SWF { override }
    public function clone():Event
    {
        return new MessageFaultEvent(type, bubbles, cancelable, message);
    }
    
    /**
     *  Returns a string representation of the MessageFaultEvent.
     *
     *  @return String representation of the MessageFaultEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    COMPILE::SWF { override }
    public function toString():String
    {
        return formatToString("MessageFaultEvent", "faultCode", "faultDetail", "faultString", "rootCause", "type", "bubbles", "cancelable", "eventPhase");
    }
    
    COMPILE::JS
    public function formatToString(className:String, ... args):String
    {
        for each (var s:String in args)
        className += " " + s;
        
        return className;
    }

}

}
