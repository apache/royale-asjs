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
//import mx.messaging.ChannelSet;
//import mx.messaging.config.LoaderConfig;
//import mx.messaging.events.MessageEvent;
//import mx.messaging.messages.IMessage;
// mx.rpc.AbstractInvoker;
//import mx.rpc.AsyncRequest;
import mx.rpc.AsyncToken;
//import mx.utils.URLUtil;

// namespace mx_internal;

/**
 *  Dispatched when an HTTPService call returns successfully.
 * @eventType mx.rpc.events.ResultEvent.RESULT 
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
[Event(name="result", type="mx.rpc.events.ResultEvent")]

/**
 *  Dispatched when an HTTPService call fails.
 * @eventType mx.rpc.events.FaultEvent.FAULT 
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
[Event(name="fault", type="mx.rpc.events.FaultEvent")]

/**
 *  The invoke event is fired when an HTTPService call is invoked so long as
 *  an Error is not thrown before the Channel attempts to send the message.
 * @eventType mx.rpc.events.InvokeEvent.INVOKE 
 *
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
[Event(name="invoke", type="mx.rpc.events.InvokeEvent")]

//[ResourceBundle("rpc")]

/**
  *  You use the HTTPService class to represent an
  *  HTTPService object in ActionScript. When you call the HTTPService object's
  *  <code>send()</code> method, it makes an HTTP request to the
  *  specified URL, and an HTTP response is returned. Optionally, you can pass
  *  parameters to the specified URL. When you do not go through the server-based
  *  proxy service, you can use only HTTP GET or POST methods. However, when you set
  *  the useProxy  property to true and you use the server-based proxy service, you
  *  can also use the HTTP HEAD, OPTIONS, TRACE, and DELETE methods.
  *
  *  <p><b>Note:</b> Due to a software limitation, HTTPService does not generate user-friendly
  *  error messages when using GET.</p>
  * 
  *  @see mx.rpc.http.mxml.HTTPService
  *
  *  @langversion 3.0
  *  @playerversion Flash 9
  *  @playerversion AIR 1.1
  *  @productversion Royale 0.9.3
 */
public class HTTPService //extends AbstractInvoker
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------
    
    /**
     *  Creates a new HTTPService. If you expect the service to send using relative URLs you may
     *  wish to specify the <code>rootURL</code> that will be the basis for determining the full URL (one example
     *  would be <code>Application.application.url</code>).
     *
     * @param rootURL The URL the HTTPService should use when computing relative URLS.
     *
     * @param destination An HTTPService destination name in the service-config.xml file.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function HTTPService(rootURL:String = null, destination:String = null)
    {
        super(); 
    }

    //--------------------------------------------------------------------------
    //
    // Constants
    // 
    //--------------------------------------------------------------------------
      

    /**
     * @private
     * Propagate event listeners down to the operation since it is firing some of the
     * events.
     */
    public function addEventListener(type:String, listener:Function,
        useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
    {
       /* operation.addEventListener(type, listener, useCapture, priority, useWeakReference);
        super.addEventListener(type, listener, useCapture, priority, useWeakReference);*/
    } 
 

    /**
     *  @private
     */
    private var _resultFormat:String ;

    [Inspectable(enumeration="object,array,xml,flashvars,text,e4x", category="General")]
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
         
          if (value != null)  
            { 
               _resultFormat = value;
		   }
    }
	
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
        return false; // operation.useProxy;
    }
    public function set useProxy(u:Boolean):void
    {
        //operation.useProxy = u;
    }
    
    [Inspectable(defaultValue="undefined", category="General")]
    /**
     *  Location of the service. If you specify the <code>url</code> and a non-default destination,
     *  your destination in the services-config.xml file must allow the specified URL.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
   //----------------------------------
    //  url
    //----------------------------------

    /**
     *  @private
     */
    private var _url:String;

    [Inspectable(defaultValue="undefined", category="General")]
    /**
     *  Location of the service. If you specify the <code>url</code> and a non-default destination,
     *  your destination in the services-config.xml file must allow the specified URL.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function get url():String
    {
        return _url;
    }

    /**
     *  @private
     */
    public function set url(value:String):void
    {
        _url = value;
    }
      
    /**
     *  Executes an HTTPService request. The parameters are optional, but if specified should
     *  be an Object containing name-value pairs or an XML object depending on the <code>contentType</code>.
     *
     *  @param parameters An Object containing name-value pairs or an
     *  XML object, depending on the content type for service
     *  requests.
     * 
     *  @return An object representing the asynchronous completion token. It is the same object
     *  available in the <code>result</code> or <code>fault</code> event's <code>token</code> property.
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    public function send(parameters:Object = null):AsyncToken
    {
        /*if (parameters == null)
            parameters = request;*/

        return null ; //operation.sendBody(parameters);
    } 
  }
}


