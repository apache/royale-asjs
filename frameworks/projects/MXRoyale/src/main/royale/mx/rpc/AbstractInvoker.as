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

package mx.rpc
{

import mx.core.mx_internal;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.messaging.errors.MessagingError;
import mx.messaging.events.MessageEvent;
import mx.messaging.events.MessageFaultEvent;
import mx.messaging.messages.AsyncMessage;
import mx.messaging.messages.IMessage;
import mx.netmon.NetworkMonitor;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.rpc.events.AbstractEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.InvokeEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectProxy;
import mx.utils.StringUtil;

import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.reflection.getQualifiedClassName;

use namespace mx_internal;

//[ResourceBundle("rpc")]

/**
 * An invoker is an object that actually executes a remote procedure call (RPC).
 * For example, RemoteObject, HTTPService, and WebService objects are invokers.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AbstractInvoker extends EventDispatcher
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    public function AbstractInvoker()
    {
        super();
        _log = Log.getLogger("mx.rpc.AbstractInvoker");
        activeCalls = new ActiveCalls();
    }

    //-------------------------------------------------------------------------
    //
    // Variables
    //
    //-------------------------------------------------------------------------

    /**
     *  @private
     */
    private var resourceManager:IResourceManager =
                                    ResourceManager.getInstance();

    //-------------------------------------------------------------------------
    //
    // Properties
    //
    //-------------------------------------------------------------------------

    private var _keepLastResult:Boolean = true;
    private var _keepLastResultSet: Boolean = false;

    /**  Flag indicating whether the operation should keep its last call result for later access.
     * <p> If set to true, the last call result will be accessible through <code>lastResult</code> bindable property. </p>
     * <p> If set to false, the last call result will be cleared after the call,
     * and must be processed in the operation's result handler.
     * This will allow the result object to be garbage collected,
     * which is especially useful if the operation is only called a few times and returns a large result. </p>
     * <p>If not set, will use the <code>keepLastResult</code> value of its owning Service, if any, or the default value.</p>
     *  @see #lastResult
     *  @see mx.rpc.AbstractService#keepLastResult
     *   @default true
     *
     *  @playerversion Flash 10
     *  @playerversion AIR 3
     *  @productversion Flex 4.11
     */
    public function get keepLastResult():Boolean
    {
        return _keepLastResult;
    }

    public function set keepLastResult(value:Boolean):void
    {
        _keepLastResult = value;
        _keepLastResultSet = true;
    }

    /** @private
     * sets keepLastResult if not set locally, typically by container Service or RemoteObject
     * @param value
     */
    mx_internal function setKeepLastResultIfNotSet( value: Boolean):void
    {
        if (!_keepLastResultSet)
              _keepLastResult = value;
    }

    [Bindable("resultForBinding")]

    /**
     *  The result of the last invocation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get lastResult():Object
    {
        return _result;
    }

    [Inspectable(defaultValue="true", category="General")]

    /**
     * When this value is true, anonymous objects returned are forced to bindable objects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get makeObjectsBindable():Boolean
    {
        return _makeObjectsBindable;
    }

    public function set makeObjectsBindable(b:Boolean):void
    {
        _makeObjectsBindable = b;
    }

    /**
     * This property is set usually by framework code which wants to modify the
     * behavior of a service invocation without modifying the way in which the
     * service is called externally.  This allows you to add a "filter" step on 
     * the method call to ensure for example that you do not return duplicate
     * instances for the same id or to insert parameters for performing on-demand
     * paging.
     *
     * When this is set to a non-null value on the send call, the operationManager function 
     * is called instead.  It returns the token that the caller uses to be notified
     * of the result.  Typically the called function will at some point clear this
     * property temporarily, then invoke the operation again actually sending it to 
     * the server this time.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     * 
     *  @royalesuppresspublicvarwarning
     */
    public var operationManager:Function;

    /** 
     * Specifies an optional return type for the operation.  Used in situations where 
     * you want to coerce the over-the-wire information into a specific ActionScript class
     * or to provide metadata for other services as to the return type of this operation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     * 
     *  @royalesuppresspublicvarwarning
     */
    public var resultType:Class;

    /**
     * Like resultType, used to define the ActionScript class used by a given operation though
     * this property only applies to operations which return a multi-valued result (e.g. an Array
     * or ArrayCollection (IList)).  This property specifies an ActionScript class for the members of the
     * array or array collection.   When you set resultElementType, you do not have to set 
     * resultType.  In that case, the operation returns an Array if makeObjectsbindable is
     * false and an ArrayCollection otherwise.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     * 
     *  @royalesuppresspublicvarwarning
     */
    public var resultElementType:Class;
    
    /**
    *  Event dispatched for binding when the <code>result</code> property
    *  changes.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    mx_internal static const BINDING_RESULT:String = "resultForBinding";

    //-------------------------------------------------------------------------
    //
    //             Public Methods
    //
    //-------------------------------------------------------------------------

    /**
     *  Cancels the last service invocation or an invokation with the specified ID.
     *  Even though the network operation may still continue, no result or fault event
     *  is dispatched.
     * 
     *  @param id The messageId of the invocation to cancel. Optional. If omitted, the
     *         last service invocation is canceled.
     *  
     *  @return The AsyncToken associated with the call that is cancelled or null if no call was cancelled.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function cancel(id:String = null):AsyncToken
    {
        if (id != null)
            return activeCalls.removeCall(id);
        else 
            return activeCalls.cancelLast();
    }

    /**
     *  Sets the <code>result</code> property of the invoker to <code>null</code>.
     *  This is useful when the result is a large object that is no longer being
     *  used.
     *
     *  @param fireBindingEvent Set to <code>true</code> if you want anything
     *  bound to the result to update. Otherwise, set to
     *  <code>false</code>.
     *  The default value is <code>true</code>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function clearResult(fireBindingEvent:Boolean = true):void
    {
        if (fireBindingEvent)
            setResult(null);
        else
            _result = null;
    }

    /**
     *  This hook is exposed to update the lastResult property.  Since lastResult
     *  is ordinarily updated automatically by the service, you do not typically 
     *  call this.  It is used by managed services that want to ensure lastResult
     *  always points to "the" managed instance for a given identity even if the
     *  the service returns a new copy of the same object.  
     *
     *  @param result The new value for the lastResult property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setResult(result:Object):void
    {
        _result = result;
        dispatchEvent(new Event(BINDING_RESULT));
    }


   //-------------------------------------------------------------------------
   //
   // Internal Methods
   //
   //-------------------------------------------------------------------------

   /**
    *  This method is overridden in subclasses to redirect the event to another
    *  class.
    *
    *  @private
    */
    mx_internal function dispatchRpcEvent(event:AbstractEvent):void
    {
        event.callTokenResponders();
        if (!event.isDefaultPrevented())
        {
            dispatchEvent(event);       
        }
    }

    /**
     * Monitor an rpc event that is being dispatched
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    mx_internal function monitorRpcEvent(event:AbstractEvent):void
    {
        if (NetworkMonitor.isMonitoring())
        {
            if (event is mx.rpc.events.ResultEvent)
            {
                NetworkMonitor.monitorResult(event.message, mx.rpc.events.ResultEvent(event).result);    
            }
            else if (event is mx.rpc.events.FaultEvent)
            {
                //trace(" AbstractInvoker: MonitorFault - message:" + event.message);
                NetworkMonitor.monitorFault(event.message, mx.rpc.events.FaultEvent(event).fault);
            }
        }
    }    


    /**
     *  Take the MessageAckEvent and take the result, store it, and broadcast out
     *  appropriately.
     *
     *  @private
     */
    protected function resultHandler(event:MessageEvent):void
    {
        var token:AsyncToken = preHandle(event);

        //if the handler didn't give us something just bail
        if (token == null)
            return;

        if (processResult(event.message, token))
        {
            dispatchEvent(new Event(BINDING_RESULT));
            var resultEvent:ResultEvent = ResultEvent.createEvent(_result, token, event.message);
            resultEvent.headers = _responseHeaders;
            dispatchRpcEvent(resultEvent);
            // we are done with the result, clear if not kept, for GC
            if (!_keepLastResult){
                  _result = null;
            }
        }
        //no else, we assume process would have dispatched the faults if necessary
    }

    /**
     *  Take the fault and convert it into a rpc.events.FaultEvent.
     *
     *  @private
     */
    mx_internal function faultHandler(event:MessageFaultEvent):void
    {
        var msgEvent:MessageEvent = MessageEvent.createEvent(MessageEvent.MESSAGE, event.message);
        var token:AsyncToken = preHandle(msgEvent);

        // continue only on a matching or empty correlationId
        // empty correlationIds could be the result of de/serialization errors
        if ((token == null) &&
            (AsyncMessage(event.message).correlationId != null) &&
            (AsyncMessage(event.message).correlationId != "") &&
            (event.faultCode != "Client.Authentication"))
        {
            return;
        }

        if (processFault(event.message, token))
        {
            var fault:Fault = new Fault(event.faultCode, event.faultString, event.faultDetail);
            fault.content = event.message.body;
            fault.rootCause = event.rootCause;
            var faultEvent:FaultEvent = FaultEvent.createEvent(fault, token, event.message);
            faultEvent.headers = _responseHeaders;
            dispatchRpcEvent(faultEvent);
        }
    }

    /**
     * Return the id for the NetworkMonitor.
     * @private
     */
    mx_internal function getNetmonId():String
    {
        return null;
    }

    /**
     * @private
     */
    mx_internal function invoke(message:IMessage, token:AsyncToken = null) : AsyncToken
    {
        if (token == null)
            token = new AsyncToken(message);
        else
            token.setMessage(message);

        activeCalls.addCall(message.messageId, token);

        var fault:Fault;
        try
        {
            //asyncRequest.invoke(message, new AsyncResponder(resultHandler, faultHandler, token));
            asyncRequest.invoke(message, new Responder(resultHandler, faultHandler));
            dispatchRpcEvent(InvokeEvent.createEvent(token, message));
        }
        catch(e:Error)
        {
            if (e is MessagingError)
            {
                _log.warn(e.toString());
                var errorText:String = resourceManager.getString(
                    "rpc", "cannotConnectToDestination",
                    [ asyncRequest.destination ]);
                fault = new Fault("InvokeFailed", e.toString(), errorText);
                new AsyncDispatcher(dispatchRpcEvent, [FaultEvent.createEvent(fault, token, message)], 10);
            }
            else
            {
                _log.warn(e.toString());
                fault = new Fault("InvokeFailed", e.message);
                new AsyncDispatcher(dispatchRpcEvent, [FaultEvent.createEvent(fault, token, message)], 10);
            }
        }
       
        return token;
    }

    /**
     * Find the matching call object and pass it back.
     *
     * @private
     */
    mx_internal function preHandle(event:MessageEvent):AsyncToken
    {
        return activeCalls.removeCall(AsyncMessage(event.message).correlationId);
    }

    /**
     * @private
     */
    mx_internal function processFault(message:IMessage, token:AsyncToken):Boolean
    {
        return true;
    }

    /**
     * @private
     */
    mx_internal function processResult(message:IMessage, token:AsyncToken):Boolean
    {
        var body:Object = message.body;
        
        if (makeObjectsBindable && (body != null) && (getQualifiedClassName(body) == "Object"))
        {
            _result = new ObjectProxy(body);            
        }
        else
        {
            _result = body;
        }

        return true;
    }

    /**
     * @private
     */
    mx_internal function get asyncRequest():AsyncRequest
    {
        if (_asyncRequest == null)
        {
            _asyncRequest = new AsyncRequest();
        }
        return _asyncRequest;
    }
    
    /**
     * @private
     */
    mx_internal function set asyncRequest(req:AsyncRequest):void
    {
        _asyncRequest = req;
    }

    /**
     * @private
     */
    mx_internal var activeCalls:ActiveCalls;

    /**
     * @private
     */
    mx_internal var _responseHeaders:Array;

    /**
     * @private
     */
    mx_internal var _result:Object;

    /**
     * @private
     */
    mx_internal var _makeObjectsBindable:Boolean;
    
    /**
     * @private
     */
    private var _asyncRequest:AsyncRequest;

    /**
     * @private
     */
    private var _log:ILogger;
}

}
