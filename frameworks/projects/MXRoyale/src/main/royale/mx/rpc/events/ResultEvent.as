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

import mx.core.mx_internal;
import mx.messaging.messages.IMessage;
import mx.messaging.messages.AbstractMessage;
import mx.rpc.AsyncToken;

use namespace mx_internal;

/**
 * The event that indicates an RPC operation has successfully returned a result.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class ResultEvent extends AbstractEvent
{
    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
    * The RESULT event type.
    *
    * <p>The properties of the event object have the following values:</p>
    * <table class="innertable">
    *     <tr><th>Property</th><th>Value</th></tr>
    *     <tr><td><code>bubbles</code></td><td>false</td></tr>
    *     <tr><td><code>cancelable</code></td><td>true, preventDefault() 
    *       from the associated token's responder.result method will prevent
    *       the service or operation from dispatching this event</td></tr>
    *     <tr><td><code>currentTarget</code></td><td>The Object that defines the 
    *       event listener that handles the event. For example, if you use 
    *       <code>myButton.addEventListener()</code> to register an event listener, 
    *       myButton is the value of the <code>currentTarget</code>. </td></tr>
    *     <tr><td><code>message</code></td><td> The Message associated with this event.</td></tr>
    *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
    *       it is not always the Object listening for the event. 
    *       Use the <code>currentTarget</code> property to always access the 
    *       Object listening for the event.</td></tr>
    *     <tr><td><code>result</code></td><td>Result that the RPC call returns.</td></tr>
    *     <tr><td><code>token</code></td><td>The token that represents the indiviudal call
    *     to the method. Used in the asynchronous completion token pattern.</td></tr>
    *  </table>
    *     
    *  @eventType result      
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public static const RESULT:String = "result";


    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     * Creates a new ResultEvent.
     * @param type The event type; indicates the action that triggered the event.
     * @param bubbles Specifies whether the event can bubble up the display list hierarchy.
     * @param cancelable Specifies whether the behavior associated with the event can be prevented.
     * @param result Object that holds the actual result of the call.
     * @param token Token that represents the call to the method. Used in the asynchronous completion token pattern.
     * @param message Source Message of the result.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function ResultEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true,
                                result:Object = null, token:AsyncToken = null, message:IMessage = null)
    {
        super(type, bubbles, cancelable, token, message);

        if (message != null && message.headers != null)
            _statusCode = message.headers[AbstractMessage.STATUS_CODE_HEADER] as int;

        _result = result;
    }


    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     * In certain circumstances, headers may also be returned with a result to
     * provide further context.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get headers():Object
    {
        return _headers;
    }

    /**
     * @private
     */
    public function set headers(value:Object):void
    {
        _headers = value;
    }

    /**
     * Result that the RPC call returns.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get result():Object
    {
        return _result;
    }

    /**
     * If the source message was sent via HTTP, this property provides access
     * to the HTTP response status code (if available), otherwise the value is
     * 0.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    public function get statusCode():int
    {
        return _statusCode;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * @private
     */
    public static function createEvent(result:Object = null, token:AsyncToken = null, message:IMessage = null):ResultEvent
    {
        return new ResultEvent(ResultEvent.RESULT, false, true, result, token, message);
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
        return new ResultEvent(type, bubbles, cancelable, result, token, message);
    }
   /**
     * Returns a string representation of the ResultEvent.
     *
     * @return String representation of the ResultEvent.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function toString():String
    {
        return formatToString("ResultEvent", "messageId", "type", "bubbles", "cancelable", "eventPhase");
    }

    /*
     * Have the token apply the result.
     */
    override mx_internal function callTokenResponders():void
    {
        if (token != null)
            token.applyResult(this);
    }

    mx_internal function setResult(r:Object):void
    {
        _result = r;
    }


    //--------------------------------------------------------------------------
    //
    //  Private Variables
    //
    //--------------------------------------------------------------------------

    private var _result:Object;
    private var _headers:Object;
    private var _statusCode:int;
}

}
