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
import mx.messaging.ChannelSet;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.rpc.events.AbstractEvent;

import org.apache.royale.events.Event;
import org.apache.royale.events.EventDispatcher;
import org.apache.royale.events.IEventDispatcher;
import org.apache.royale.utils.Proxy;

COMPILE::SWF
{
import flash.utils.flash_proxy;
use namespace flash_proxy;
}
use namespace mx_internal;

/**
 * The invoke event is dispatched when a service Operation is invoked so long as
 * an Error is not thrown before the Channel attempts to send the message.
 * @eventType mx.rpc.events.InvokeEvent.INVOKE 
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]

/**
 * The result event is dispatched when a service call successfully returns and
 * isn't handled by the Operation itself.
 * @eventType mx.rpc.events.ResultEvent.RESULT 
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="result", type="mx.rpc.events.ResultEvent")]

/**
 * The fault event is dispatched when a service call fails and isn't handled by
 * the Operation itself.
 * @eventType mx.rpc.events.FaultEvent.FAULT 
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="fault", type="mx.rpc.events.FaultEvent")]

//[ResourceBundle("rpc")]

[Bindable(event="operationsChange")]

/**
 * The AbstractService class is the base class for the HTTPMultiService, WebService, 
 * and RemoteObject classes. This class does the work of creating Operations
 * which do the actual execution of remote procedure calls.
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public dynamic class AbstractService extends Proxy implements IEventDispatcher
{   
    //-------------------------------------------------------------------------
    //
    // Constructor
    //
    //-------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @param destination The destination of the service.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function AbstractService(destination:String = null)
    {
        super();
        eventDispatcher = new EventDispatcher(this);
        asyncRequest = new AsyncRequest();

        if (destination)
        {
            this.destination = destination;
            asyncRequest.destination = destination;
        }

        _operations = {};
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
    //              Properties
    //
    //-------------------------------------------------------------------------

    //----------------------------------
    //  channelSet
    //----------------------------------

    /**
     *  Provides access to the ChannelSet used by the service. The
     *  ChannelSet can be manually constructed and assigned, or it will be 
     *  dynamically created to use the configured Channels for the
     *  <code>destination</code> for this service.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get channelSet():ChannelSet
    {
        return asyncRequest.channelSet;
    }

    /**
     *  @private
     */
    public function set channelSet(value:ChannelSet):void
    {
        if (channelSet != value)
        {
            asyncRequest.channelSet = value;
        }
    }

    //----------------------------------
    //  destination
    //----------------------------------

    [Inspectable(category="General")]

    /**
     * The destination of the service. This value should match a destination
     * entry in the services-config.xml file.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get destination():String
    {
        return asyncRequest.destination;
    }

    public function set destination(name:String):void
    {
        asyncRequest.destination = name;
    }


    //----------------------------------
    //  managers
    //----------------------------------

    private var _managers:Array;

    /**
     * The managers property stores a list of data managers which modify the
     * behavior of this service.  You can use this hook to define one or more
     * manager components associated with this service.  When this property is set,
     * if the managers have a property called "service" that property is set to 
     * the value of this service.  When this service is initialized, we also call
     * the initialize method on any manager components.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get managers():Array
    {
        return _managers;
    }

    public function set managers(mgrs:Array):void
    {
        if (_managers != null)
        {
            for (var i:int = 0; i < _managers.length; i++)
            {
                var mgr:Object = _managers[i];
                if (mgr.hasOwnProperty("service"))
                    mgr.service = null;
            }
        }
        _managers = mgrs;
        for (i = 0; i < mgrs.length; i++)
        {
            mgr = _managers[i];
            if (mgr.hasOwnProperty("service"))
                mgr.service = this;
            if (_initialized && mgr.hasOwnProperty("initialize"))
                mgr.initialize();
        }
    }

    //----------------------------------
    //  operations
    //----------------------------------

    /**
     * @private
     */
    mx_internal var _operations:Object;

    /**
     * @private
     * This is required by data binding.
     */
    public function get operations():Object
    {
        return _operations;
    }

    /**
     * The Operations array is usually only set by the MXML compiler if you
     * create a service using an MXML tag.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function set operations(ops:Object):void
    {
        var op:AbstractOperation;
        for (var i:String in ops)
        {
            op = AbstractOperation(ops[i]);
            op.setService(this); // service is a write only property.
            if (!op.name)
                op.name = i;
            op.asyncRequest = asyncRequest;
            op.setKeepLastResultIfNotSet( _keepLastResult);
        }
        _operations = ops;
        dispatchEvent(new org.apache.royale.events.Event("operationsChange"));
    }

    //----------------------------------
    //  requestTimeout
    //----------------------------------

    [Inspectable(category="General")]

    /**
     *  Provides access to the request timeout in seconds for sent messages. 
     *  A value less than or equal to zero prevents request timeout.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */ 
    public function get requestTimeout():int
    {
        return asyncRequest.requestTimeout;
    }

    /**
     *  @private
     */
    public function set requestTimeout(value:int):void
    {
        if (requestTimeout != value)
        {
            asyncRequest.requestTimeout = value;
        }
    }

    //----------------------------------
    //  keepLastResult
    //----------------------------------
    protected var _keepLastResult: Boolean = true ;


    [Inspectable(defaultValue="true", category="General")]

    /**  Flag indicating whether the service's operations should keep their last call result for later access.
     * <p>Setting this flag at the service level will set <code>keepLastResult</code> for each operation, unless explicitly  set in the operation.</p>
     * <p> If set to true or not set, each operation's last call result will be accessible through its <code>lastResult</code> bindable property. </p>
     * <p> If set to false, each operation's last call result will be cleared after the call,
     * and must be processed in the operation's result handler.
     * This will allow the result object to be garbage collected,
     * which is especially useful if the operation is only called a few times and returns a large result. </p>
     *  @see mx.rpc.AbstractInvoker#keepLastResult
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
    }
    
    //-------------------------------------------------------------------------
    //
    //              Methods
    //
    //-------------------------------------------------------------------------

    //---------------------------------
    //   EventDispatcher methods
    //---------------------------------

    /**
     * @private
     */
    COMPILE::SWF
    public function addEventListener(type:String, listener:Function,
        useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
    {
        eventDispatcher.addEventListener(type, listener, useCapture);
    }

    /**
     * @private
     */
    [SWFOverride(params="flash.events.Event", altparams="org.apache.royale.events.Event")]
    COMPILE::SWF
    public function dispatchEvent(event:Event):Boolean
    {
        return eventDispatcher.dispatchEvent(event);
    }

    /**
     * @private
     */
    COMPILE::SWF
    public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
    {
        eventDispatcher.removeEventListener(type, listener, useCapture);
    }

    /**
     * @private
     */
    COMPILE::SWF
    public function hasEventListener(type:String):Boolean
    {
        return eventDispatcher.hasEventListener(type);
    }
    
    /**
     * @private
     */
    COMPILE::SWF
    public function willTrigger(type:String):Boolean
    {
        return eventDispatcher.willTrigger(type);
    }

    /**
     *  Called to initialize the service.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function initialize():void
    {
        if (!_initialized && _managers != null)
        {
            for (var i:int = 0; i < _managers.length; i++)
            {
                var mgr:Object = _managers[i];
                if (mgr.hasOwnProperty("initialize"))
                    mgr.initialize();
            }
            _initialized = true;
        }
    }

    //---------------------------------
    //   Proxy methods
    //---------------------------------
    /**
     * @private
     */
    COMPILE::SWF
    override flash_proxy function getProperty(name:*):*
    {
        return getOperation(getLocalName(name));
    }
    COMPILE::JS
    override public function getProperty(propName:String):*
    {
        return getOperation(propName);        
    }
    
    /**
     * @private
     */
    COMPILE::SWF
    override flash_proxy function setProperty(name:*, value:*):void
    {
        var message:String = resourceManager.getString(
            "rpc", "operationsNotAllowedInService", [ getLocalName(name) ]);
        throw new Error(message);
    }
    COMPILE::JS
    override public function setProperty(propName:String, value:*):void
    {
        var message:String = resourceManager.getString(
            "rpc", "operationsNotAllowedInService", [ propName ]);
        throw new Error(message);        
    }
    
    COMPILE::JS
    override public function hasProperty(propName:String):Boolean
    {
        return getOperation(propName) != null;                
    }
    
    COMPILE::JS
    override public function deleteProperty(propName:String):Boolean
    {
        var message:String = resourceManager.getString(
            "rpc", "operationsNotAllowedInService", [ propName ]);
        throw new Error(message);
       // return false;
    }

    /**
     * @private
     */
    COMPILE::SWF
    override flash_proxy function callProperty(name:*, ... args:Array):*
    {
        return getOperation(getLocalName(name)).send.apply(null, args);
    }

    COMPILE::JS
    override public function callProperty(name:*, ... args:Array):*
    {
        var op:AbstractOperation = getOperation(getLocalName(name))
        return op.send.apply(op, args);
    }
    
    //used to store the nextName values
    private var nextNameArray:Array;
    
    /**
     * @private
     */
    COMPILE::SWF
    override flash_proxy function nextNameIndex(index:int):int
    {
        if (index == 0)
        {
            nextNameArray = [];
            for (var op:String in _operations)
            {
                nextNameArray.push(op);    
            }    
        }
        return index < nextNameArray.length ? index + 1 : 0;
    }

    /**
     * @private
     */
    COMPILE::SWF
    override flash_proxy function nextName(index:int):String
    {
        return nextNameArray[index-1];
    }

    COMPILE::JS
    override public function propertyNames():Array
    {
        nextNameArray = [];
        for (var op:String in _operations)
        {
            nextNameArray.push(op);    
        }
        return nextNameArray;
    }
    
    /**
     * @private
     */
    COMPILE::SWF
    override flash_proxy function nextValue(index:int):*
    {
        return _operations[nextNameArray[index-1]];
    }

    mx_internal function getLocalName(name:Object):String
    {
        if (name is QName)
        {
            return QName(name).localName;
        }
        else
        {
            return String(name);
        }
    }

    //---------------------------------
    //   Public methods
    //---------------------------------

    /**
     * Returns an Operation of the given name. If the Operation wasn't
     * created beforehand, subclasses are responsible for creating it during
     * this call. Operations are usually accessible by simply naming them after
     * the service variable (<code>myService.someOperation</code>), but if your
     * Operation name happens to match a defined method on the service (like
     * <code>setCredentials</code>), you can use this method to get the
     * Operation instead.
     * @param name Name of the Operation.
     * @return Operation that executes for this name.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function getOperation(name:String):AbstractOperation
    {
        var o:Object = _operations[name];
        var op:AbstractOperation = (o is AbstractOperation) ? AbstractOperation(o) : null;
        return op;
    }

    /**
     *  Disconnects the service's network connection and removes any pending
     *  request responders.
     *  This method does not wait for outstanding network operations to complete.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function disconnect():void
    {
        asyncRequest.disconnect();
    }

    /**
     * Sets the credentials for the destination accessed by the service when using Data Services on the server side.
     * The credentials are applied to all services connected over the same
     * ChannelSet. Note that services that use a proxy or a third-party adapter
     * to a remote endpoint will need to setRemoteCredentials instead.
     * 
     * @param username The username for the destination.
     * @param password The password for the destination.
     * @param charset The character set encoding to use while encoding the
     * credentials. The default is null, which implies the legacy charset of
     * ISO-Latin-1. The only other supported charset is &quot;UTF-8&quot;.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setCredentials(username:String, password:String, charset:String=null):void
    {
        asyncRequest.setCredentials(username, password, charset);
    }

    /**
     * Logs the user out of the destination. 
     * Logging out of a destination applies to everything connected using the
     * same ChannelSet as specified in the server configuration. For example,
     * if you're connected over the my-rtmp channel and you log out using one
     * of your RPC components, anything that was connected over the same
     * ChannelSet is logged out.
     *
     *  <p><b>Note:</b> Adobe recommends that you use the mx.messaging.ChannelSet.logout() method
     *  rather than this method. </p>
     *
     *  @see mx.messaging.ChannelSet#logout()   
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function logout():void
    {
        asyncRequest.logout();
    }

    /**
     * The username and password to be used to authenticate a user when
     * accessing a remote, third-party endpoint such as a web service through a
     * proxy or a remote object through a custom adapter when using Data Services on the server side.
     *
     * @param remoteUsername The username to pass to the remote endpoint
     * @param remotePassword The password to pass to the remote endpoint
     * @param charset The character set encoding to use while encoding the
     * remote credentials. The default is null, which implies the legacy charset
     * of ISO-Latin-1. The only other supported charset is &quot;UTF-8&quot;.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function setRemoteCredentials(remoteUsername:String, remotePassword:String, charset:String=null):void
    {
        asyncRequest.setRemoteCredentials(remoteUsername, remotePassword, charset);
    }
    
    //--------------------------------------------------------------
    //   Public methods from Object prototype not inherited by Proxy
    //--------------------------------------------------------------
    
    /**
     * Returns this service.
     * 
     * @private
     */  
    COMPILE::SWF
    public function valueOf():Object
    {
        return this;
    }
    
    
    //--------------------------------------------------------------
    //   mx_internal for package methods
    //--------------------------------------------------------------
    
    /**
     * @private
     */
    mx_internal function hasTokenResponders(event:Event):Boolean
    {
        if (event is AbstractEvent)
        {
            var rpcEvent:AbstractEvent = event as AbstractEvent;
            if (rpcEvent.token != null && rpcEvent.token.hasResponder())
            {
                return true;
            }
        }

        return false;
    }   


    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    mx_internal var _availableChannelIds:Array;
    mx_internal var asyncRequest:AsyncRequest;
    private var eventDispatcher:EventDispatcher;
    private var _initialized:Boolean = false;
}

}
