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

package mx.rpc.http.mxml
{

//import flash.events.ErrorEvent;
//import flash.events.ErrorEvent;

import mx.core.mx_internal;
//import mx.core.IMXMLObject;
import mx.managers.CursorManager;
//import mx.messaging.events.MessageEvent;
//import mx.messaging.messages.IMessage;
//import mx.messaging.messages.AsyncMessage;
//import mx.resources.IResourceManager;
//import mx.resources.ResourceManager;
import mx.rpc.AsyncToken;
//import mx.rpc.AsyncDispatcher;
import mx.rpc.Fault;
import mx.rpc.http.HTTPService;
//import mx.rpc.events.AbstractEvent;
//import mx.rpc.events.FaultEvent;
//import mx.rpc.mxml.Concurrency;
//import mx.rpc.mxml.IMXMLSupport;
import mx.validators.Validator;

//use namespace mx_internal;

//[ResourceBundle("rpc")]

/**
 * You use the <code>&lt;mx:HTTPService&gt;</code> tag to represent an
 * HTTPService object in an MXML file. When you call the HTTPService object's
 * <code>send()</code> method, it makes an HTTP request to the
 * specified URL, and an HTTP response is returned. Optionally, you can pass
 * parameters to the specified URL. When you do not go through the server-based
 * proxy service, you can use only HTTP GET or POST methods. However, when you set
 * the useProxy  property to true and you use the server-based proxy service, you
 * can also use the HTTP HEAD, OPTIONS, TRACE, and DELETE methods.
 *
 * <p><b>Note:</b> Due to a software limitation, HTTPService does not generate
 * user-friendly error messages when using GET.
 * </p>
 *
 * @mxml
 * <p>
 * The &lt;mx:HTTPService&gt; tag accepts the following tag attributes:
 * </p>
 * <pre>
 * &lt;mx:HTTPService
 * <b>Properties</b>
 * concurrency="multiple|single|last"
 * contentType="application/x-www-form-urlencoded|application/xml"
 * destination="<i>DefaultHTTP</i>"
 * id="<i>No default.</i>"
 * method="GET|POST|HEAD|OPTIONS|PUT|TRACE|DELETE"
 * resultFormat="object|array|xml|e4x|flashvars|text"
 * showBusyCursor="false|true"
 * makeObjectsBindable="false|true"
 * url="<i>No default.</i>"
 * useProxy="false|true"
 * xmlEncode="<i>No default.</i>"
 * xmlDecode="<i>No default.</i>"
 *
 * <b>Events</b>
 * fault="<i>No default.</i>"
 * result="<i>No default.</i>"
 * /&gt;
 * </pre>
 *
 * The <code>&lt;mx:HTTPService&gt;</code> tag can have a single &lt;mx:request&gt; tag under which the parameters can be specified.
 * </p>
 *
 * @includeExample examples/HTTPServiceExample.mxml -noswf
 *
 * @see mx.rpc.http.HTTPService
 * @see mx.validators.Validator
 * @see mx.managers.CursorManager
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Royale 0.9.3
 */
public class HTTPService extends mx.rpc.http.HTTPService //implements IMXMLSupport, IMXMLObject
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------

    /**
     * Creates a new HTTPService. This constructor is usually called by the generated code of an MXML document.
     * You usually use the mx.rpc.http.HTTPService class to create an HTTPService in ActionScript.
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
        super(rootURL, destination);

    }

    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------
    private var _method:String ;
    
    private var _showBusyCursor:Boolean = false;
    
    //----------------------------------
    //  method
    //----------------------------------

    [Inspectable(enumeration="GET,get,POST,post,HEAD,head,OPTIONS,options,PUT,put,TRACE,trace,DELETE,delete", defaultValue="GET", category="General")]
    /**
     *  HTTP method for sending the request. Permitted values are <code>GET</code>, <code>POST</code>, <code>HEAD</code>,
     *  <code>OPTIONS</code>, <code>PUT</code>, <code>TRACE</code> and <code>DELETE</code>.
     *  Lowercase letters are converted to uppercase letters. The default value is <code>GET</code>.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Royale 0.9.3
     */
    /*public function get method():String
    {
        return _method;
    }
    public function set method(m:String):void
    {
        _method = m;
    }*/ 
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
     *  @productversion Royale 0.9.3
    */
    /*public function get showBusyCursor():Boolean
    {
        return _showBusyCursor;
    }

    public function set showBusyCursor(sbc:Boolean):void
    {
        _showBusyCursor = sbc;
    }*/ 
    
}

}
