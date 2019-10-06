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
import mx.messaging.messages.IMessage;
import mx.core.mx_internal;

use namespace mx_internal;

/**
 *  The MessageEvent class is used to propagate messages within the messaging system.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 * 
 *  @royalesuppresspublicvarwarning
 */
public class MessageEvent extends Event
{
    //--------------------------------------------------------------------------
    //
    // Static Constants
    // 
    //--------------------------------------------------------------------------    

    /**
     *  The MESSAGE event type; dispatched upon receipt of a message.
     *  <p>The value of this constant is <code>"message"</code>.</p>
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
     *     <tr><td><code>message</code></td><td>The message associated with this event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *  @eventType message
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */     
    public static const MESSAGE:String = "message";

    /**
     *  The RESULT event type; dispatched when an RPC agent receives a result from
     *  a remote service destination.
     *  <p>The value of this constant is <code>"result"</code>.</p>
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
     *     <tr><td><code>message</code></td><td>The message associated with this event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *  @eventType result
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */      
    public static const RESULT:String = "result";

    //--------------------------------------------------------------------------
    //
    // Static Methods
    // 
    //--------------------------------------------------------------------------    
    
    /**
     *  Utility method to create a new MessageEvent that doesn't bubble and
     *  is not cancelable.
     * 
     *  @param type The type for the MessageEvent.
     *  
     *  @param message The associated message.
     * 
     *  @return New MessageEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static function createEvent(type:String, msg:IMessage):MessageEvent
    {
        return new MessageEvent(type, false, false, msg);
    }

    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------    

    /**
     *  Constructs an instance of this event with the specified type and 
     *  message.
     * 
     *  @param type The type for the MessageEvent.
     * 
     *  @param bubbles Specifies whether the event can bubble up the display 
     *  list hierarchy.
     * 
     *  @param cancelable Indicates whether the behavior associated with the 
     *  event can be prevented; used by the RPC subclasses.
     * 
     *  @param message The associated message.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function MessageEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, 
            message:IMessage = null)
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
     *  The Message associated with this event.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public var message:IMessage;

    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------    

	//----------------------------------
	//  messageId
	//----------------------------------

    /**
     *  @private
     */
    public function get messageId():String
    {
        if (message != null)
        {
            return message.messageId;
        }
        return null;
    }

    //--------------------------------------------------------------------------
    //
    // Overridden Methods
    // 
    //--------------------------------------------------------------------------

    /**
     *  Clones the MessageEvent.
     *
     *  @return Copy of this MessageEvent.
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
        return new MessageEvent(type, bubbles, cancelable, message);
    }

    /**
     *  Returns a string representation of the MessageEvent.
     *
     *  @return String representation of the MessageEvent.
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
        return formatToString("MessageEvent", "messageId", "type", "bubbles", "cancelable", "eventPhase");
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
