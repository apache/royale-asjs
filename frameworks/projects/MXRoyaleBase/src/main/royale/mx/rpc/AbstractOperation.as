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
import mx.messaging.messages.IMessage;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.rpc.AsyncToken;
import mx.rpc.events.AbstractEvent;

use namespace mx_internal;

/**
 * Dispatched when an Operation invocation successfully returns.
 * @eventType mx.rpc.events.ResultEvent.RESULT 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="result", type="mx.rpc.events.ResultEvent")]

/**
 * Dispatched when an Operation call fails.
 * @eventType mx.rpc.events.FaultEvent.FAULT 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="fault", type="mx.rpc.events.FaultEvent")]

//[ResourceBundle("rpc")]

/**
 * The AbstractOperation class represents an individual method on a
 * service. An Operation can be called either by invoking the function of the
 * same name on the service or by accessing the Operation as a property on the
 * service and calling the <code>send()</code> method.
 * 
 * @see mx.rpc.AbstractService
 * @see mx.rpc.remoting.RemoteObject
 * @see mx.rpc.soap.WebService
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class AbstractOperation extends AbstractInvoker
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------

    /**
     * Creates a new Operation. This is usually done directly by the MXML
     * compiler or automatically by the service when an unknown Operation has
     * been accessed. It is not recommended that a developer use this
     * constructor directly.
     *  
     *  @param service The service on which the Operation is being invoked.
     *  
     *  @param name The name of the new Operation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function AbstractOperation(service:AbstractService = null, name:String = null)
    {
        super();

        _service = service
        _name = name;
        this.arguments = {};
    }


    //-------------------------------------------------------------------------
    //
    // Variables
    //
    //-------------------------------------------------------------------------

    /**
     * The arguments to pass to the Operation when it is invoked. If you call
     * the <code>send()</code> method with no parameters, an array based on
     * this object is sent. If you call the <code>send()</code> method with
     * parameters (or call the function directly on the service) those
     * parameters are used instead of whatever is stored in this property.
     * For RemoteObject Operations the associated argumentNames array determines
     * the order of the arguments passed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     * 
     *  @royalesuppresspublicvarwarning
     */
    public var arguments:Object;

    /**
     * This is a hook primarily for framework developers to register additional user 
     * specified properties for your operation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     * 
     *  @royalesuppresspublicvarwarning
     */
    public var properties:Object;

    /**
     *  @private
     */
    private var resourceManager:IResourceManager =
                                    ResourceManager.getInstance();

    //--------------------------------------------------------------------------
    //
    // Properties
    //
    //--------------------------------------------------------------------------

    /**
     * The name of this Operation. This is how the Operation is accessed off the
     * service. It can only be set once.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get name():String
    {
        return _name;
    }

    public function set name(n:String):void
    {
        if (!_name)
        {
            _name = n;
        }
        else
        {
            var message:String = resourceManager.getString(
                "rpc", "cannotResetOperationName");
            throw new Error(message);
        }
    }

    /**
     * Provides convenient access to the service on which the Operation
     * is being invoked. Note that the service cannot be changed after
     * the Operation is constructed.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get service():AbstractService
    {
        return _service;
    }

    /**
     * @private
     */
    mx_internal function setService(s:AbstractService):void
    {
        if (!_service)
        {
            _service = s;
        }
        else
        {
            var message:String = resourceManager.getString(
                "rpc", "cannotResetService")
            throw new Error(message);
        }
    }


    //-------------------------------------------------------------------------
    //
    //  Methods
    //
    //-------------------------------------------------------------------------

    /**
     * Executes the method. Any arguments passed in are passed along as part of
     * the method call. If there are no arguments passed, the arguments object
     * is used as the source of parameters.
     *
     * @param args Optional arguments passed in as part of the method call. If there
     * are no arguments passed, the arguments object is used as the source of 
     * parameters.
     *
     * @return AsyncToken object.
     * The same object is available in the <code>result</code> and
     * <code>fault</code> events from the <code>token</code> property.
     *
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    /* abstract */ public function send(... args:Array):AsyncToken
    {
        return null;
    }

    //---------------------------------
    // Helper methods
    //---------------------------------

   /*
    * This is unless we come up with a way for faceless components to support
    * event bubbling; dispatch the event if there's someone listening on us,
    * otherwise have the RemoteObject dispatch it in case there's a default
    * handler.
    */
    override mx_internal function dispatchRpcEvent(event:AbstractEvent):void
    {
        event.callTokenResponders();
        if (!event.isDefaultPrevented())
        {
            if (hasEventListener(event.type))
            {
                dispatchEvent(event);
            }
            else
            {
                if (_service != null)
                _service.dispatchEvent(event);
            }            
        }
    }


    //--------------------------------------------------------------------------
    //
    // Private Variables
    // 
    //--------------------------------------------------------------------------

    mx_internal var _service:AbstractService;
    private var _name:String;
}

}
