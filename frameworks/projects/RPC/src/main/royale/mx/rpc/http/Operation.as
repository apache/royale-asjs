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

package mx.rpc.http
{

import mx.core.mx_internal;
import mx.logging.ILogger;
import mx.logging.Log;
import mx.rpc.AbstractService;
import mx.rpc.AsyncRequest;
import mx.rpc.AsyncToken;
import mx.utils.URLUtil;

import mx.messaging.errors.ArgumentError;
	
use namespace mx_internal;

/**
 * An Operation used specifically by an HTTPMultiService.  An Operation is an 
 * individual operation on a service usually corresponding to a single operation on the server
 * side.  An Operation can be called either by invoking the
 * function of the same name on the service or by accessing the Operation as a property on the service and
 * calling the <code>send(param1, param2)</code> method.  HTTP services also support a sendBody
 * method which allows you to directly specify the body of the HTTP response.  If you use the
 * send(param1, param2) method, the body is typically formed by combining the argumentNames
 * property of the operation with the parameters sent.  An Object is created which uses the
 * argumentNames[i] as the key and the corresponding parameter as the value.
 * 
 * <p>The exact way in which the HTTP operation arguments is put into the HTTP body is determined
 * by the serializationFilter used.</p>
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class Operation extends AbstractOperation
{
    //---------------------------------
    // Constructor
    //---------------------------------

    /**
     *  Creates a new Operation. 
     *
     *  @param service The HTTPMultiService object defining the service.
     *
     *  @param name The name of the service.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3

     *  Creates a new Operation. 
     *
     *  @param service The HTTPMultiService object defining the service.
     *
     *  @param name The name of the service.
     */
    public function Operation(service:HTTPMultiService = null, name:String = null)
    {
        super(service, name);

        // Set this to false even if the super constructor initialized concurrency to the default.
        _concurrencySet = false;

        _multiService = service;

        _log = Log.getLogger("mx.rpc.http.HTTPMultiService");
    }
    
    /**
     * Stores the parent service which controls this operation.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _multiService:HTTPMultiService;


    /**
     * @private
     */
    private var _concurrency:String;
    /**
     * @private
     */
    private var _concurrencySet:Boolean;

    [Inspectable(enumeration="multiple,single,last", defaultValue="multiple", category="General")]
    /**
     * Value that indicates how to handle multiple calls to the same service operation. The default
     * value is <code>multiple</code>. The following values are permitted:
     * <ul>
     * <li><code>multiple</code> Existing requests are not cancelled, and the developer is
     * responsible for ensuring the consistency of returned data by carefully
     * managing the event stream. This is the default value.</li>
     * <li><code>single</code> Only a single request at a time is allowed on the operation;
     * multiple requests generate a fault.</li>
     * <li><code>last</code> Making a request cancels any existing request.</li>
     * </ul>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get concurrency():String
    {
        // This override is necessary because unlike the old-style HttpService HttpOperation setup
        // each HttpMultiService can have many http.Operations and concurrency settings don't have
        // to be the same for the service and all its operations. If concurrency is not set on this
        // operation, the setting from HttpMultiService is used. This code cannot be in AbstractOperation
        // because the old HttpService doesn't hold a value for concurrency (and doesn't need to). It
        // simply gets/sets concurrency for its only operation.
        if (_concurrencySet)
        {
            return _concurrency;
        }
        //else
        return _multiService.concurrency;
    }
    override public function set concurrency(c:String):void
    {
        _concurrency = c;
        _concurrencySet = true;
    }


    /**
     * Keep track of whether or not this has been set explicitly on the
     * operation.  If not, we'll inherit this value from the service level.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    private var _makeObjectsBindableSet:Boolean;

    [Inspectable(defaultValue="true", category="General")]
    /**
     * When this value is true, anonymous objects returned are forced to bindable objects.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get makeObjectsBindable():Boolean
    {
        if (_makeObjectsBindableSet)
            return _makeObjectsBindable;
        return _multiService.makeObjectsBindable;    
    }

    override public function set makeObjectsBindable(b:Boolean):void
    {
        _makeObjectsBindable = b;
        _makeObjectsBindableSet = true;
    }

    private var _methodSet:Boolean = false;
    private var _method:String;

    /**
     *  @inheritDoc
     */
    override public function get method():String
    {
        if (_methodSet)
            return _method;

        return _multiService.method;
    }
    /**
     *  @private
     */
    override public function set method(m:String):void
    {
        _method = m;
        _methodSet = m != null;
    }

    override mx_internal function setService(s:AbstractService):void
    {
        super.setService(s);
        if (s is HTTPMultiService)
            _multiService = s as HTTPMultiService;

    }

    private var _showBusyCursorSet:Boolean = false;
    /**
     *  @inheritDoc
     */
    override public function get showBusyCursor():Boolean
    {
        if (_showBusyCursorSet)
            return super.showBusyCursor;
        return _multiService.showBusyCursor;    
    }
    /**
     *  @private
     */
    override public function set showBusyCursor(b:Boolean):void
    {
        super.showBusyCursor = b;
        _showBusyCursorSet = true;
    }

    /**
     * The rootURL is used to compute the URL for an HTTP service operation when the
     * a relative URL is specified for the operation.  The directory name of the
     * rootURL is prepended to any relative URLs for the operation.  It is typically
     * more convenient to set the baseURL since baseURL specifies the directory name
     * directly whereas rootURL specifies the name of a file whose directory name is
     * prepended.  If neither rootURL nor baseURL are set explicitly, the directory name
     * of the .swf file is prepended to relative paths.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get rootURL():String
    {
        if (_rootURL == null)
        {
            var useRootURL:String = _multiService.baseURL;
            if (useRootURL != null && useRootURL.length > 0)
            {
                if (useRootURL.charAt(useRootURL.length - 1) != '/')
                    useRootURL = useRootURL + "/";

                // If this is relative to the 
                if (useRootURL.charAt(0) == "/")
                    useRootURL = URLUtil.getFullURL(super.rootURL, useRootURL);
                return useRootURL;
            }
            else
                return super.rootURL; // defaults to SWF's URL
        }
        return _rootURL;
    }

    private var _useProxySet:Boolean = false;

    /**
     *  @inheritDoc
     */
    override public function get useProxy():Boolean
    {
        if (_useProxySet)
            return super.useProxy;
        return _multiService.useProxy;
    }

    /**
     *  @private
     */
    override public function set useProxy(value:Boolean):void
    {
        _useProxySet = true;
        super.useProxy = value;
    }

    private var _contentTypeSet:Boolean = false;

    /**
     *  @inheritDoc
     */
    override public function get contentType():String
    {
        if (_contentTypeSet)
            return super.contentType;
        return _multiService.contentType;
    }

    /**
     *  @private
     */
    override public function set contentType(ct:String):void
    {
        _contentTypeSet = ct != null;
        super.contentType = ct;
    }

    //---------------------------------
    // Methods
    //---------------------------------

    /**
     * Executes the http operation. Any arguments passed in are passed along as part of
     * the operation call. If there are no arguments passed, the arguments property of
     * class is used as the source of parameters.  HTTP operations commonly take named
     * parameters, not positional parameters.  To supply the names for these parameters,
     * you can also set the argumentNames property to an array of the property names.
     *
     * @param args Optional arguments passed in as part of the method call. If there
     * are no arguments passed, the arguments object is used as the source of 
     * parameters.
     *
     * @return AsyncToken Call using the asynchronous completion token pattern.
     * The same object is available in the <code>result</code> and
     * <code>fault</code> events from the <code>token</code> property.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function send(... args:Array):AsyncToken
    {
        if (_multiService != null)
            _multiService.initialize();

        if (operationManager != null)
            return operationManager(args);

        var params:Object; 

        var filter:SerializationFilter = getSerializationFilter();
        if (filter != null)
        {
            params = filter.serializeParameters(this, args);
        }
        else
        {
            params = args;
            if (!params || (params.length == 0 && this.request))
            {
                params = this.request;
            }

            if (params is Array && argumentNames != null)
            {
                args = params as Array;
				params = new Object();
                if (args.length != argumentNames.length)
                {
                    throw new ArgumentError("HTTPMultiService operation called with " + argumentNames.length + " argumentNames and " + args.length + " number of parameters.  When argumentNames is specified, it must match the number of arguments passed to the invocation");
                }
                else
                {
                    // Special case for XML content type when only one parameter is provided.
                    // This gets rid of the need for a serializationFilter for this simple case.
                    // If there is more than one parameter though, we do not have a reliable way
                    // to turn the arguments into a body.
                    if (argumentNames.length == 1 && contentType == CONTENT_TYPE_XML)
                    {
                        params = args[0];
                    }
                    else
                    {
                        for (var i:int = 0; i < argumentNames.length; i++)
                            params[argumentNames[i]] = args[i];
                    }
                }
            }
            // Also do the XML content type special case when no argument names is set
            else if (args.length == 1) 
            {
                params = args[0];
            }
            else if (args.length != 0)
            {
                throw new ArgumentError("HTTPMultiService - you must set argumentNames to an array of parameter names if you use more than one parameter.");
            }
        }
        return sendBody(params);
    }

    private var _resultFormatSet:Boolean = false;

    /**
     *  @inheritDoc
     */
    override public function get resultFormat():String
    {
        if (_resultFormatSet)
            return super.resultFormat;
        return _multiService.resultFormat;
    }

    /**
     *  @private
     */
    override public function set resultFormat(rf:String):void
    {
        _resultFormatSet = rf != null;
        super.resultFormat = rf;
    }

    /**
     *  @private
     */
    override protected function getSerializationFilter():SerializationFilter
    {
        var sf:SerializationFilter = serializationFilter;
        if (sf == null)
            return _multiService.serializationFilter;
        return sf;
    }

    /**
     *  @private
     */
    override protected function getHeaders():Object
    {
        // TODO: support combining the headers maps if both are specified
        if (headers != null)
            return headers;
        else 
            return _multiService.headers;
    }

    /**
     * Use the asyncRequest from the parent service
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override mx_internal function get asyncRequest():AsyncRequest
    {
        // TODO: is this safe?  should we do this in RemoteObject etc. Minimally we
        // need to propagate the multiService.destination to the AsyncRequest if we
        // go with the default implementation of per-operation asyncRequest instances.
        return _multiService.asyncRequest;
    }
}

}
