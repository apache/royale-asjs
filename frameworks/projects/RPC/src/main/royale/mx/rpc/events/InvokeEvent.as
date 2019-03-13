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

package mx.rpc.events
{

import org.apache.royale.events.Event;
import mx.messaging.messages.IMessage;
import mx.rpc.AsyncToken;

/**
 * The event that indicates an RPC operation has been invoked.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class InvokeEvent extends AbstractEvent
{
    /**
     * The INVOKE event type.
     * 
     * <p>The properties of the event object have the following values:</p>
     * <table class="innertable">
     *     <tr><th>Property</th><th>Value</th></tr>
     *     <tr><td><code>bubbles</code></td><td>false</td></tr>
     *     <tr><td><code>token</code></td><td> The token that represents the indiviudal call
     *     to the method. Used in the asynchronous completion token pattern.</td></tr>
     *     <tr><td><code>cancelable</code></td><td>true</td></tr>
     *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
     *       event listener that handles the event. For example, if you use 
     *       <code>myButton.addEventListener()</code> to register an event listener, 
     *       myButton is the value of the <code>currentTarget</code>. </td></tr>
     *     <tr><td><code>message</code></td><td> The request Message associated with this event.</td></tr>
     *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
     *       it is not always the Object listening for the event. 
     *       Use the <code>currentTarget</code> property to always access the 
     *       Object listening for the event.</td></tr>
     *  </table>
     *  @eventType invoke 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const INVOKE:String = "invoke";

    /**
     * Create a new InvokeEvent.
     * @param type The event type; indicates the action that triggered the event.
     * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
     * @param cancelable Specifies whether the behavior associated with the event can be prevented.
     * @param token Token that represents the call to the method. Used in the asynchronous 
     *     completion token pattern.
     * @param message Source Message of the request.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function InvokeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
            token:AsyncToken = null, message:IMessage = null)
    {
        super(type, bubbles, cancelable, token, message);
    }

    /**
     * @private
     */
    public static function createEvent(token:AsyncToken = null, message:IMessage = null):InvokeEvent
    {
        return new InvokeEvent(InvokeEvent.INVOKE, false, false, token, message);
    }

    /** 
     * Because this event can be re-dispatched we have to implement clone to
     * return the appropriate type, otherwise we will get just the standard
     * event type.
     * @private
     */
    [SWFOverride(returns="flash.events.Event"))]
    override public function clone():Event
    {
        return new InvokeEvent(type, bubbles, cancelable, token, message);
    }
   /**
    * Returns a string representation of the InvokeEvent.
    *
    * @return String representation of the InvokeEvent.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    override public function toString():String
    {
        return formatToString("InvokeEvent", "messageId", "type", "bubbles", "cancelable", "eventPhase");
    }
}

}
