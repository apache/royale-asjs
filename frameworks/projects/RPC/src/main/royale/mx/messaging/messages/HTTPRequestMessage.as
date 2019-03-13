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

package mx.messaging.messages
{

// import mx.resources.IResourceManager;
// import mx.resources.ResourceManager;

// [ResourceBundle("messaging")]

[RemoteClass(alias="flex.messaging.messages.HTTPMessage")]

/**
 *  HTTP requests are sent to the HTTP endpoint using this message type.
 *  An HTTPRequestMessage encapsulates content and header information normally
 *  found in HTTP requests made by a browser.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion BlazeDS 4
 *  @productversion LCDS 3 
 */
public class HTTPRequestMessage extends AbstractMessage
{
    //--------------------------------------------------------------------------
    //
    // Constructor
    // 
    //--------------------------------------------------------------------------

    /**
     *  Constructs an uninitialized HTTP request.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function HTTPRequestMessage()
    {
        super();
        _method = GET_METHOD;
    }

    //--------------------------------------------------------------------------
    //
    // Variables
    // 
    //--------------------------------------------------------------------------

    private var _contentType:String;
    
    /**
     *  Indicates the content type of this message.
     *  This value must be understood by the destination this request is sent to.
     *
     *  <p>The following example sets the <code>contentType</code> property:</p>
     *    <pre>
     *      var msg:HTTPRequestMessage = new HTTPRequestMessage();
     *      msg.contentType = HTTPRequestMessage.CONTENT_TYPE_FORM;
     *      msg.method = HTTPRequestMessage.POST_METHOD;
     *      msg.url = "http://my.company.com/login";
     *    </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get contentType():String
    {
        return _contentType;
    }
    public function set contentType(value:String):void
    {
        _contentType = value;
    }

    private var _httpHeaders:Object;
    
    /**
     *  Contains specific HTTP headers that should be placed on the request made
     *  to the destination.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get httpHeaders():Object
    {
        return _httpHeaders;
    }
    public function set httpHeaders(value:Object):void
    {
        _httpHeaders = value;
    }
    
    private var _recordHeaders:Boolean;    
    
    /**
     * Only used when going through the proxy, should the proxy 
     * send back the request and response headers it used.  Defaults to false.
     * Currently only set when using the NetworkMonitor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get recordHeaders():Boolean
    {
        return _recordHeaders;
    }
    public function set recordHeaders(value:Boolean):void
    {
        _recordHeaders = value;
    }
    
    private var _url:String;
    
    [Inspectable(defaultValue="undefined", category="General")]
    /**
     *  Contains the final destination for this request.
     *  This is the URL that the content of this message, found in the
     *  <code>body</code> property, will be sent to, using the method specified.
     *
     *  <p>The following example sets the <code>url</code> property:</p>
     *    <pre>
     *      var msg:HTTPRequestMessage = new HTTPRequestMessage();
     *      msg.contentType = HTTPRequestMessage.CONTENT_TYPE_FORM;
     *      msg.method = HTTPRequestMessage.POST_METHOD;
     *      msg.url = "http://my.company.com/login";
     *    </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get url():String
    {
        return _url;
    }
    public function set url(value:String):void
    {
        _url = value;
    }

    /**
     *  @private
    private var resourceManager:IResourceManager =
                                    ResourceManager.getInstance();
     */

    //--------------------------------------------------------------------------
    //
    // Properties
    // 
    //--------------------------------------------------------------------------

    //----------------------------------
    //  method
    //----------------------------------

    /**
     *  @private
     */
    private var _method:String;

    [Inspectable(category="General")]
    /**
     *  Indicates what method should be used for the request.
     *  The only values allowed are:
     *  <ul>
     *    <li><code>HTTPRequestMessage.DELETE_METHOD</code></li>
     *    <li><code>HTTPRequestMessage.GET_METHOD</code></li>
     *    <li><code>HTTPRequestMessage.HEAD_METHOD</code></li>
     *    <li><code>HTTPRequestMessage.POST_METHOD</code></li>
     *    <li><code>HTTPRequestMessage.OPTIONS_METHOD</code></li>
     *    <li><code>HTTPRequestMessage.PUT_METHOD</code></li>
     *    <li><code>HTTPRequestMessage.TRACE_METHOD</code></li>
     *  </ul>
     *
     *  <p>The following example sets the <code>method</code> property:</p>
     *    <pre>
     *      var msg:HTTPRequestMessage = new HTTPRequestMessage();
     *      msg.contentType = HTTPRequestMessage.CONTENT_TYPE_FORM;
     *      msg.method = HTTPRequestMessage.POST_METHOD;
     *      msg.url = "http://my.company.com/login";
     *    </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public function get method():String
    {
        return _method;
    }

    /**
     *  @private
     */
    public function set method(value:String):void
    {
        /*
        if (VALID_METHODS.indexOf(value) == -1)
        {
            var message:String = resourceManager.getString(
                "messaging", "invalidRequestMethod");
            throw new ArgumentError(message);
        }
        */

        _method = value;
    }

    //--------------------------------------------------------------------------
    //
    // Static Constants
    // 
    //--------------------------------------------------------------------------
    
    /**
     *  Indicates that the content of this message is XML.
     *
     *  <p>The following example uses this constant:</p>
     *    <pre>
     *      var msg:HTTPRequestMessage = new HTTPRequestMessage();
     *      msg.contentType = HTTPRequestMessage.CONTENT_TYPE_XML;
     *      msg.method = HTTPRequestMessage.POST_METHOD;
     *      msg.url = "http://my.company.com/login";
     *    </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static const CONTENT_TYPE_XML:String = "application/xml";
    
    /**
     *  Indicates that the content of this message is a form.
     *
     *  <p>The following example uses this constant:</p>
     *    <pre>
     *      var msg:HTTPRequestMessage = new HTTPRequestMessage();
     *      msg.contentType = HTTPRequestMessage.CONTENT_TYPE_FORM;
     *      msg.method = HTTPRequestMessage.POST_METHOD;
     *      msg.url = "http://my.company.com/login";
     *    </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static const CONTENT_TYPE_FORM:String = "application/x-www-form-urlencoded";
    
    /**
     *  Indicates that the content of this message is XML meant for a SOAP
     *  request.
     *
     *  <p>The following example uses this constant:</p>
     *    <pre>
     *      var msg:HTTPRequestMessage = new HTTPRequestMessage();
     *      msg.contentType = HTTPRequestMessage.CONTENT_TYPE_SOAP_XML;
     *      msg.method = HTTPRequestMessage.POST_METHOD;
     *      msg.url = "http://my.company.com/login";
     *    </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static const CONTENT_TYPE_SOAP_XML:String = "text/xml; charset=utf-8";

    /**
     *  Indicates that the method used for this request should be "post".
     *
     *  <p>The following example uses this constant:</p>
     *    <pre>
     *      var msg:HTTPRequestMessage = new HTTPRequestMessage();
     *      msg.contentType = HTTPRequestMessage.CONTENT_TYPE_FORM;
     *      msg.method = HTTPRequestMessage.POST_METHOD;
     *      msg.url = "http://my.company.com/login";
     *    </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static const POST_METHOD:String = "POST";

    /**
     *  Indicates that the method used for this request should be "get".
     *
     *  <p>The following example uses this constant:</p>
     *    <pre>
     *      var msg:HTTPRequestMessage = new HTTPRequestMessage();
     *      msg.contentType = HTTPRequestMessage.CONTENT_TYPE_FORM;
     *      msg.method = HTTPRequestMessage.GET_METHOD;
     *      msg.url = "http://my.company.com/login";
     *    </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static const GET_METHOD:String = "GET";

    /**
     *  Indicates that the method used for this request should be "put".
     *
     *  <p>The following example uses this constant:</p>
     *    <pre>
     *      var msg:HTTPRequestMessage = new HTTPRequestMessage();
     *      msg.contentType = HTTPRequestMessage.CONTENT_TYPE_FORM;
     *      msg.method = HTTPRequestMessage.PUT_METHOD;
     *      msg.url = "http://my.company.com/login";
     *    </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static const PUT_METHOD:String = "PUT";

    /**
     *  Indicates that the method used for this request should be "head".
     *
     *  <p>The following example uses this constant:</p>
     *    <pre>
     *      var msg:HTTPRequestMessage = new HTTPRequestMessage();
     *      msg.contentType = HTTPRequestMessage.CONTENT_TYPE_FORM;
     *      msg.method = HTTPRequestMessage.HEAD_METHOD;
     *      msg.url = "http://my.company.com/login";
     *    </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static const HEAD_METHOD:String = "HEAD";

    /**
     *  Indicates that the method used for this request should be "delete".
     *  
     *  <p>The following example uses this constant:</p>
     *    <pre>
     *      var msg:HTTPRequestMessage = new HTTPRequestMessage();
     *      msg.contentType = HTTPRequestMessage.CONTENT_TYPE_FORM;
     *      msg.method = HTTPRequestMessage.DELETE_METHOD;
     *      msg.url = "http://my.company.com/login";
     *    </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static const DELETE_METHOD:String = "DELETE";

    /**
     *  Indicates that the method used for this request should be "options".
     *
     *  <p>The following example uses this constant:</p>
     *    <pre>
     *      var msg:HTTPRequestMessage = new HTTPRequestMessage();
     *      msg.contentType = HTTPRequestMessage.CONTENT_TYPE_FORM;
     *      msg.method = HTTPRequestMessage.OPTIONS_METHOD;
     *      msg.url = "http://my.company.com/login";
     *    </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static const OPTIONS_METHOD:String = "OPTIONS";

    /**
     *  Indicates that the method used for this request should be "trace".
     *
     *  <p>The following example uses this constant:</p>
     *    <pre>
     *      var msg:HTTPRequestMessage = new HTTPRequestMessage();
     *      msg.contentType = HTTPRequestMessage.CONTENT_TYPE_FORM;
     *      msg.method = HTTPRequestMessage.TRACE_METHOD;
     *      msg.url = "http://my.company.com/login";
     *    </pre>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion BlazeDS 4
     *  @productversion LCDS 3 
     */
    public static const TRACE_METHOD:String = "TRACE";

    /**
     *  @private
     */
    private static const VALID_METHODS:String = "POST,PUT,GET,HEAD,DELETE,OPTIONS,TRACE";       
}

}
