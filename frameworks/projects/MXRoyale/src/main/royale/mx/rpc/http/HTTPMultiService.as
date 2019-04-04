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
import mx.messaging.ChannelSet;
import mx.messaging.channels.DirectHTTPChannel;
import mx.messaging.config.LoaderConfig;
import mx.messaging.errors.ArgumentError;
import mx.messaging.messages.HTTPRequestMessage;
import mx.resources.IResourceManager;
import mx.resources.ResourceManager;
import mx.rpc.AbstractService;
import mx.rpc.events.FaultEvent;
import mx.rpc.mxml.Concurrency;
import mx.utils.URLUtil;

use namespace mx_internal;

/**
 *  Dispatched when an HTTPMultiService call returns successfully.
 * @eventType mx.rpc.events.ResultEvent.RESULT 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="result", type="mx.rpc.events.ResultEvent")]

/**
 *  Dispatched when an HTTPMultiService call fails.
 * @eventType mx.rpc.events.FaultEvent.FAULT 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="fault", type="mx.rpc.events.FaultEvent")]

/**
 *  The invoke event is fired when an HTTPMultiService call is invoked so long as
 *  an Error is not thrown before the Channel attempts to send the message.
 * @eventType mx.rpc.events.InvokeEvent.INVOKE 
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]

//[ResourceBundle("rpc")]

[DefaultProperty("operationList")]
/**
 *  You use the <code>&lt;mx:HTTPMultiService&gt;</code> tag to represent a
 *  collection of http operations.  Each one has a URL, method, parameters and
 *  return type.  
 *
 *  <p>You can set attributes such as the URL and method on the
 *  HTTPMultiService tag to act as defaults for values set on each individual
 *  operation tag.  The URL of the HTTPMultiService serves as the base url (meaning the prefix)
 *  for any relative urls set on the http operation tags.
 *  Each http operation has a <code>send()</code> method, which makes an HTTP request to the
 *  specified URL, and an HTTP response is returned. </p>
 *
 *  <p>You can pass parameters to the specified URL which are used to put data into the HTTP request. 
 *  The contentType property specifies a mime-type which is used to determine the over-the-wire
 *  data format (such as HTTP form encoding or XML).  </p>
 *
 *  <p>You can also use a serialization filter to
 *  implement a custom resultFormat such as JSON.   
 *  When you do not go through the server-based
 *  proxy service, you can use only HTTP GET or POST methods. However, when you set
 *  the <code>useProxy </code> property to true and you use the server-based proxy service, you
 *  can also use the HTTP HEAD, OPTIONS, TRACE, and DELETE methods.</p>
 *
 *  <p><b>Note:</b> Unlike the HTTPService class, the HTTPMultiService class does not 
 *  define a <code>request</code> property.</p>
 *
 *  <p><b>Note:</b> Due to a software limitation, like HTTPService, the HTTPMultiService does 
 *  not generate user-friendly error messages when using GET and not using a proxy.</p>
 * 
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @see mx.rpc.http.HTTPService
 */
public dynamic class HTTPMultiService extends AbstractService
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------
    
    /**
     *  Creates a new HTTPService. If you expect the service to send using relative URLs you may
     *  wish to specify the <code>baseURL</code> that will be the basis for determining the full URL (one example
     *  would be <code>Application.application.url</code>).
     *
     *  @param baseURL The URL the HTTPService should use when computing relative URLS.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function HTTPMultiService(baseURL:String = null, destination:String = null)
    {
        super();
        
        makeObjectsBindable = false; // change this for now since Royale tries to create ObejctProxy that still is not implemented and make things fail. This can be reverted when ObjectProxy works

        if (destination == null)
        {
            if (URLUtil.isHttpsURL(LoaderConfig.url))
                asyncRequest.destination = HTTPService.DEFAULT_DESTINATION_HTTPS;
            else
                asyncRequest.destination = HTTPService.DEFAULT_DESTINATION_HTTP;
        }
        else
            asyncRequest.destination = destination;
        
        _log = Log.getLogger("mx.rpc.http.HTTPMultiService");

        this.baseURL = baseURL;

        concurrency = Concurrency.MULTIPLE;
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------
    
    /** 
     *  @private
     *  A shared direct Http channelset used for service instances that do not use the proxy. 
     */
    private static var _directChannelSet:ChannelSet;
    
    /**
     *  @private
     *  Logger
     */
    private var _log:ILogger;

    /**
     *  @private
     */
    private var resourceManager:IResourceManager = ResourceManager.getInstance();

    /**
     *  @private
     */
    private var _showBusyCursor:Boolean = false;

    /**
     *  @private
     */
    private var _concurrency:String;

    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    //----------------------------------
    //  contentType
    //----------------------------------

    private var _contentType:String = AbstractOperation.CONTENT_TYPE_FORM;
    
    [Inspectable(enumeration="application/x-www-form-urlencoded,application/xml", defaultValue="application/x-www-form-urlencoded", category="General")]
    /**
     *  Type of content for service requests. 
     *  The default is <code>application/x-www-form-urlencoded</code> which sends requests
     *  like a normal HTTP POST with name-value pairs. <code>application/xml</code> send
     *  requests as XML.
     */
    public function get contentType():String
    {
        return _contentType;
    }
    public function set contentType(value:String):void
    {
        _contentType = value;
    }

    //----------------------------------
    //  concurrency
    //----------------------------------

    [Inspectable(enumeration="multiple,single,last", defaultValue="multiple", category="General")]
    /**
     * Value that indicates how to handle multiple calls to the same operation within the service.
     * The concurrency setting set here will be used for operations that do not specify concurrecny.
     * Individual operations that have the concurrency setting set directly will ignore the value set here.
     * The default value is <code>multiple</code>. The following values are permitted:
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
    public function get concurrency():String
    {
        return _concurrency;
    }
    public function set concurrency(c:String):void
    {
        _concurrency = c;
    }

    //----------------------------------
    //  showBusyCursor
    //----------------------------------

    [Inspectable(defaultValue="false", category="General")]
    /**
    * If <code>true</code>, a busy cursor is displayed while a service is executing. The default
    * value is <code>false</code>.
    *  
    *  @langversion 3.0
    *  @playerversion Flash 9
    *  @playerversion AIR 1.1
    *  @productversion Flex 3
    */
    public function get showBusyCursor():Boolean
    {
        return _showBusyCursor;
    }

    public function set showBusyCursor(sbc:Boolean):void
    {
        _showBusyCursor = sbc;
    }

    //----------------------------------
    //  headers
    //----------------------------------

    private var _headers:Object = {};
    
    [Inspectable(defaultValue="undefined", category="General")]
    /**
     *  Custom HTTP headers to be sent to the third party endpoint. If multiple headers need to
     *  be sent with the same name the value should be specified as an Array.  These headers are sent
     *  to all operations.  You can also set headers at the operation level.
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
    public function set headers(value:Object):void
    {
        _headers = value;
    }

    //----------------------------------
    //  makeObjectsBindable
    //----------------------------------

    private var _makeObjectsBindable:Boolean = true;
    
    [Inspectable(defaultValue="true", category="General")]
    /**
     *  When <code>true</code>, the objects returned support data binding to UI controls.
     *  That means  they send PropertyChangeEvents when their property values are being changed.  
     *  This is the default value for any operations whose makeObjectsBindable property 
     *  is not set explicitly.
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
    public function set makeObjectsBindable(value:Boolean):void
    {
        _makeObjectsBindable = value;
    }

    //----------------------------------
    //  method
    //----------------------------------

    private var _method:String = HTTPRequestMessage.GET_METHOD;
    
    [Inspectable(enumeration="GET,get,POST,post,HEAD,head,OPTIONS,options,PUT,put,TRACE,trace,DELETE,delete", defaultValue="GET", category="General")]
    /**
     *  HTTP method for sending the request if a method is not set explicit on the operation. 
     *  Permitted values are <code>GET</code>, <code>POST</code>, <code>HEAD</code>,
     *  <code>OPTIONS</code>, <code>PUT</code>, <code>TRACE</code> and <code>DELETE</code>.
     *  Lowercase letters are converted to uppercase letters. The default value is <code>GET</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get method():String
    {
        return _method;
    }
    public function set method(value:String):void
    {
        _method = value;
    }

    //----------------------------------
    //  resultFormat
    //----------------------------------

    /**
     *  @private
     */
    private var _resultFormat:String = AbstractOperation.RESULT_FORMAT_OBJECT;

    [Inspectable(enumeration="object,array,xml,flashvars,text,e4x", defaultValue="object", category="General")]
    /**
     *  Value that indicates how you want to deserialize the result
     *  returned by the HTTP call. The value for this is based on the following:
     *  <ul>
     *  <li>Whether you are returning XML or name/value pairs.</li>
     *  <li>How you want to access the results; you can access results as an object,
     *    text, or XML.</li>
     *  </ul>
     * 
     *  <p>The default value is <code>object</code>. The following values are permitted:</p>
     *  <ul>
     *  <li><code>object</code> The value returned is XML and is parsed as a tree of ActionScript
     *    objects. This is the default.</li>
     *  <li><code>array</code> The value returned is XML and is parsed as a tree of ActionScript
     *    objects however if the top level object is not an Array, a new Array is created and the result
     *    set as the first item. If makeObjectsBindable is true then the Array 
     *    will be wrapped in an ArrayCollection.</li>
     *  <li><code>xml</code> The value returned is XML and is returned as literal XML in an
     *    ActionScript XMLnode object.</li>
     *  <li><code>flashvars</code> The value returned is text containing 
     *    name=value pairs separated by ampersands, which
     *  is parsed into an ActionScript object.</li>
     *  <li><code>text</code> The value returned is text, and is left raw.</li>
     *  <li><code>e4x</code> The value returned is XML and is returned as literal XML 
     *    in an ActionScript XML object, which can be accessed using ECMAScript for 
     *    XML (E4X) expressions.</li>
     *  </ul>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get resultFormat():String
    {
        return _resultFormat;
    }

    /**
     *  @private
     */
    public function set resultFormat(value:String):void
    {
        switch (value)
        {
            case AbstractOperation.RESULT_FORMAT_OBJECT:
            case AbstractOperation.RESULT_FORMAT_ARRAY:
            //case AbstractOperation.RESULT_FORMAT_XML:
            case AbstractOperation.RESULT_FORMAT_E4X:
            case AbstractOperation.RESULT_FORMAT_TEXT:
            case AbstractOperation.RESULT_FORMAT_FLASHVARS:
            {
                break;
            }

            default:
            {
                if (value != null && (serializationFilter = SerializationFilter.filterForResultFormatTable[value]) == null)
                {
                    var message:String = resourceManager.getString(
                        "rpc", "invalidResultFormat",
                        [ value, AbstractOperation.RESULT_FORMAT_OBJECT, AbstractOperation.RESULT_FORMAT_ARRAY,
                          /*AbstractOperation.RESULT_FORMAT_XML,*/ AbstractOperation.RESULT_FORMAT_E4X,
                          AbstractOperation.RESULT_FORMAT_TEXT, AbstractOperation.RESULT_FORMAT_FLASHVARS ]);
                    throw new ArgumentError(message);
                }
            }
        }
        _resultFormat = value;
    }

    /** Default serializationFilter used by all operations which do not set one explicitly */
    private var _serializationFilter:SerializationFilter;
    
    public function get serializationFilter():SerializationFilter
    {
        return _serializationFilter;
    }
    public function set serializationFilter(value:SerializationFilter):void
    {
        _serializationFilter = value;
    }
    
    //----------------------------------
    //  rootURL
    //----------------------------------

    private var _baseURL:String;

    /**
     *  The URL that the HTTPService object should use when computing relative URLs.
     *  This contains a prefix which is prepended onto any URLs when it is set.
     *  It defaults to null in which case the URL for the SWF is used to compute
     *  relative URLs.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get baseURL():String
    {
        return _baseURL;
    }
    public function set baseURL(value:String):void
    {
        _baseURL = value;
    }
    
    /**
     *  @private
     */
    override public function set destination(value:String):void
    {
        useProxy = true;
        super.destination = value;
    }

    /**
     *  @private
     */
    private var _useProxy:Boolean = false;
    
    [Inspectable(defaultValue="false", category="General")]
    /**
     *  Specifies whether to use the Flex proxy service. The default value is <code>false</code>. If you
     *  do not specify <code>true</code> to proxy requests though the Flex server, you must ensure that the player 
     *  can reach the target URL. You also cannot use destinations defined in the services-config.xml file if the
     *  <code>useProxy</code> property is set to <code>false</code>.
     *
     *  @default false    
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get useProxy():Boolean
    {
        return _useProxy;
    }

    /**
     *  @private
     */
    public function set useProxy(value:Boolean):void
    {
        if (value != _useProxy)
        {
            _useProxy = value;
            var dcs:ChannelSet = getDirectChannelSet();
            if (!useProxy)
            {
                if (dcs != asyncRequest.channelSet)
                    asyncRequest.channelSet = dcs;
            }
            else
            {
                if (asyncRequest.channelSet == dcs)
                    asyncRequest.channelSet = null;
            }
        }
    }

    /**
     * This serves as the default property for this instance so that we can
     * define a set of operations as direct children of the HTTPMultiService
     * tag in MXML.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function set operationList(ol:Array):void
    {
        if (ol == null)
            operations = null;
        else
        {
            var op:AbstractOperation;
            var ops:Object = {};
            for (var i:int = 0; i < ol.length; i++)
            {
                op = AbstractOperation(ol[i]);
                var name:String = op.name;
                if (!name)
                    throw new ArgumentError("Operations must have a name property value for HTTPMultiService");
                ops[name] = op;
            }
            operations = ops;
        }
    }

    public function get operationList():Array
    {
        // Note: does not preserve order of the elements
        if (operations == null)
            return null;
        var ol:Array = [];
        for (var i:String in operations)
        {
            var op:AbstractOperation = operations[i];
            ol.push(op);
        }
        return ol;
    }

    //--------------------------------------------------------------------------
    //
    // Internal Methods
    // 
    //--------------------------------------------------------------------------

    mx_internal function getDirectChannelSet():ChannelSet
    {
        if (_directChannelSet == null)
        {
            var dcs:ChannelSet = new ChannelSet();
            var dhc:DirectHTTPChannel = new DirectHTTPChannel("direct_http_channel");
            dhc.requestTimeout = requestTimeout;
            dcs.addChannel(dhc);
            _directChannelSet = dcs;            
        }
        return _directChannelSet;  
    }
}

}
