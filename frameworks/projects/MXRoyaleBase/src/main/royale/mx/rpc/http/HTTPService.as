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
	import mx.messaging.ChannelSet;
	import mx.messaging.config.LoaderConfig;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.messages.IMessage;
	import mx.rpc.AbstractInvoker;
	import mx.rpc.AsyncRequest;
	import mx.rpc.AsyncToken;
	import mx.utils.URLUtil;
	
	use namespace mx_internal;
	
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
	public class HTTPService extends AbstractInvoker
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
			
			operation = new HTTPOperation(this);
			
			operation.makeObjectsBindable = false; // change this for now since Royale tries to create ObejctProxy that still is not implemented and make things fail. This can be reverted when ObjectProxy works
			
			operation._rootURL = rootURL;
			
			// If the SWF was loaded via HTTPS, we'll use the DefaultHTTPS destination by default
			if (destination == null)
			{
				if (URLUtil.isHttpsURL(LoaderConfig.url))
					asyncRequest.destination = DEFAULT_DESTINATION_HTTPS;
				else
					asyncRequest.destination = DEFAULT_DESTINATION_HTTP;
			} 
			else 
			{
				asyncRequest.destination = destination;
				useProxy = true;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		// Constants
		// 
		//--------------------------------------------------------------------------
		
		/**
		 *  The result format "e4x" specifies that the value returned is an XML instance, which can be accessed using ECMAScript for XML (E4X) expressions.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const RESULT_FORMAT_E4X:String = "e4x";
		
		/**
		 *  The result format "flashvars" specifies that the value returned is text containing name=value pairs
		 *  separated by ampersands, which is parsed into an ActionScript object.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const RESULT_FORMAT_FLASHVARS:String = "flashvars";
		
		/**
		 *  The result format "object" specifies that the value returned is XML but is parsed as a tree of ActionScript objects. This is the default.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const RESULT_FORMAT_OBJECT:String = "object";
		
		/**
		 *  The result format "array" is similar to "object" however the value returned is always an Array such
		 *  that if the result returned from result format "object" is not an Array already the item will be
		 *  added as the first item to a new Array.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const RESULT_FORMAT_ARRAY:String = "array";
		
		/**
		 *  The result format "text" specifies that the HTTPService result text should be an unprocessed String.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const RESULT_FORMAT_TEXT:String = "text";
		
		/**
		 *  The result format "xml" specifies that results should be returned as an flash.xml.XMLNode instance pointing to
		 *  the first child of the parent flash.xml.XMLDocument.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const RESULT_FORMAT_XML:String = "xml";
		
		/**
		 *  Indicates that the data being sent by the HTTP service is encoded as application/xml.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const CONTENT_TYPE_XML:String = "application/xml";
		
		/**
		 *  Indicates that the data being sent by the HTTP service is encoded as application/x-www-form-urlencoded.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const CONTENT_TYPE_FORM:String = "application/x-www-form-urlencoded";
		
		/**
		 *  Indicates that the HTTPService object uses the DefaultHTTP destination.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const DEFAULT_DESTINATION_HTTP:String = "DefaultHTTP";
		
		/**
		 *  Indicates that the HTTPService object uses the DefaultHTTPS destination.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const DEFAULT_DESTINATION_HTTPS:String = "DefaultHTTPS";
		
		// Constants for error codes
		/**
		 *  Indicates that the useProxy property was set to false but a url was not provided.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const ERROR_URL_REQUIRED:String = "Client.URLRequired";
		
		/**
		 *  Indicates that an XML formatted result could not be parsed into an XML instance
		 *  or decoded into an Object.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const ERROR_DECODING:String = "Client.CouldNotDecode";
		
		/**
		 *  Indicates that an input parameter could not be encoded as XML.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public static const ERROR_ENCODING:String = "Client.CouldNotEncode";    
		
		
		/**
		 * @private
		 * Propagate event listeners down to the operation since it is firing some of the
		 * events.
		 */
		/*override public function addEventListener(type:String, listener:Function,
		useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
		operation.addEventListener(type, listener, useCapture, priority, useWeakReference);
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}*/
		
		/**
		 * @private
		 * Remove event listener on operation added in the addEventListener override.
		 */
		/*override public function removeEventListener(type:String, listener:Function,
		useCapture:Boolean = false):void
		{
		operation.removeEventListener(type, listener, useCapture);
		super.removeEventListener(type, listener, useCapture);
		}*/
		
		mx_internal var operation:AbstractOperation;
		
		override mx_internal function set asyncRequest(ar:AsyncRequest):void
		{
			operation.asyncRequest = ar;
		}
		override mx_internal function get asyncRequest():AsyncRequest
		{
			return operation.asyncRequest;
		}
		
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
		 *  @productversion Royale 0.9.3
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
			useProxy = true;
			asyncRequest.channelSet = value;
		}
		
		//----------------------------------
		//  contentType
		//----------------------------------
		
		[Inspectable(enumeration="application/x-www-form-urlencoded,application/xml", defaultValue="application/x-www-form-urlencoded", category="General")]
		/**
		 *  Type of content for service requests. 
		 *  The default is <code>application/x-www-form-urlencoded</code> which sends requests
		 *  like a normal HTTP POST with name-value pairs. <code>application/xml</code> send
		 *  requests as XML.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public function get contentType():String
		{
			return operation.contentType;
		}
		public function set contentType(c:String):void
		{
			operation.contentType = c;
		}
		
		[Inspectable(enumeration="multiple,single,last", defaultValue="multiple", category="General")]
		/**
		 * Value that indicates how to handle multiple calls to the same service. The default
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
		 *  @productversion Royale 0.9.3
		 */
		public function get concurrency():String
		{
			return operation.concurrency;
		}
		public function set concurrency(c:String):void
		{
			operation.concurrency = c;
		}
		
		//----------------------------------
		//  destination
		//----------------------------------
		
		[Inspectable(defaultValue="DefaultHTTP", category="General")]
		/**
		 *  An HTTPService destination name in the services-config.xml file. When
		 *  unspecified, Flex uses the <code>DefaultHTTP</code> destination.
		 *  If you are using the <code>url</code> property, but want requests
		 *  to reach the proxy over HTTPS, specify <code>DefaultHTTPS</code>.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public function get destination():String
		{
			return asyncRequest.destination;
		}
		
		/**
		 *  @private
		 */
		public function set destination(value:String):void
		{
			useProxy = true;
			asyncRequest.destination = value;
		}
		
		[Inspectable(defaultValue="true", category="General")]
		/**
		 * When this value is true, anonymous objects returned are forced to bindable objects.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		override public function get makeObjectsBindable():Boolean
		{
			return operation.makeObjectsBindable;
		}
		
		override public function set makeObjectsBindable(b:Boolean):void
		{
			operation.makeObjectsBindable = b;
		}
		
		//----------------------------------
		//  headers
		//----------------------------------
		
		[Inspectable(defaultValue="undefined", category="General")]
		/**
		 *  Custom HTTP headers to be sent to the third party endpoint. If multiple headers need to
		 *  be sent with the same name the value should be specified as an Array.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public function get headers():Object
		{
			return operation.headers;
		}
		public function set headers(r:Object):void
		{
			operation.headers = r;
		}
		
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
		public function get method():String
		{
			return operation.method;
		}
		public function set method(m:String):void
		{
			operation.method = m;
		}
		
		//----------------------------------
		//  request
		//----------------------------------
		
		[Inspectable(defaultValue="undefined", category="General")]
		/**
		 *  Object of name-value pairs used as parameters to the URL. If
		 *  the <code>contentType</code> property is set to <code>application/xml</code>, it should be an XML document.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public function get request():Object
		{
			return operation.request;
		}
		public function set request(r:Object):void
		{
			operation.request = r;
		}
		
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
		 *  @productversion Royale 0.9.3
		 */
		public function get resultFormat():String
		{
			return operation.resultFormat;
		}
		public function set resultFormat(rf:String):void
		{
			operation.resultFormat = rf;
		}
		
		//----------------------------------
		//  rootURL
		//----------------------------------
		
		/**
		 *  The URL that the HTTPService object should use when computing relative URLs.
		 *  This property is only used when going through the proxy.
		 *  When the <code>useProxy</code> property is set to <code>false</code>, the relative URL is computed automatically
		 *  based on the location of the SWF running this application.
		 *  If not set explicitly <code>rootURL</code> is automatically set to the URL of
		 *  mx.messaging.config.LoaderConfig.url.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public function get rootURL():String
		{
			return operation.rootURL;
		}
		public function set rootURL(ru:String):void
		{
			operation.rootURL = ru;
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
		 *  @productversion Royale 0.9.3
		 */
		public function get showBusyCursor():Boolean
		{
			return operation.showBusyCursor;
		}
		
		public function set showBusyCursor(sbc:Boolean):void
		{
			operation.showBusyCursor = sbc;
		}
		
		//----------------------------------
		//  serializationFilter 
		//----------------------------------
		
		/**
		 * Provides an adapter which controls the process of converting the HTTP response body into 
		 * ActionScript objects and/or turning the parameters or body into the contentType, URL, and
		 * and post body of the HTTP request.  This can also be set indirectly by setting the 
		 * resultFormat by registering a SerializationFilter using the static method:
		 * SerializationFilter.registerFilterForResultFormat("formatName", filter)
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public function get serializationFilter():SerializationFilter
		{
			return operation.serializationFilter;
		}
		public function set serializationFilter(s:SerializationFilter):void
		{
			operation.serializationFilter = s;
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
		public function get url():String
		{
			return operation.url;
		}
		public function set url(u:String):void
		{
			operation.url = u;
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
		 *  @productversion Royale 0.9.3
		 */
		public function get useProxy():Boolean
		{
			return operation.useProxy;
		}
		public function set useProxy(u:Boolean):void
		{
			operation.useProxy = u;
		}
		
		//----------------------------------
		//  xmlDecode
		//----------------------------------
		
		[Inspectable(defaultValue="undefined", category="General")]
		/**
		 *  ActionScript function used to decode a service result from XML.
		 *  When the <code>resultFormat</code> is an object and the <code>xmlDecode</code> property is set,
		 *  Flex uses the XML that the HTTPService returns to create an
		 *  Object. If it is not defined the default XMLDecoder is used
		 *  to do the work.
		 *  <p>The function referenced by the <code>xmlDecode</code> property must
		 *  take a flash.xml.XMLNode object as a parameter and should return
		 *  an Object. It can return any type of object, but it must return
		 *  something. Returning <code>null</code> or <code>undefined</code> causes a fault.</p>
		 
		 The following example shows an &lt;mx:HTTPService&gt; tag that specifies an xmlDecode function:
		 
		 <pre>
		 &lt;mx:HTTPService id="hs" xmlDecode="xmlDecoder" url="myURL" resultFormat="object" contentType="application/xml"&gt;
		 &lt;mx:request&gt;&lt;source/&gt;
		 &lt;obj&gt;{RequestObject}&lt;/obj&gt;
		 &lt;/mx:request&gt;
		 &lt;/mx:HTTPService&gt;
		 </pre>
		 
		 
		 The following example shows an xmlDecoder function:
		 <pre>
		 function xmlDecoder (myXML)
		 {
		 // Simplified decoding logic.
		 var myObj = {};
		 myObj.name = myXML.firstChild.nodeValue;
		 myObj.honorific = myXML.firstChild.attributes.honorific;
		 return myObj;
		 }
		 </pre>
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public function get xmlDecode():Function
		{
			return operation.xmlDecode;
		}
		public function set xmlDecode(u:Function):void
		{
			operation.xmlDecode = u;
		}
		
		//----------------------------------
		//  xmlEncode
		//----------------------------------
		
		[Inspectable(defaultValue="undefined", category="General")]
		/**
		 *  ActionScript function used to encode a service request as XML.
		 *  When the <code>contentType</code> of a request is <code>application/xml</code> and the
		 *  request object passed in is an Object, Flex attempts to use
		 *  the function specified in the <code>xmlEncode</code> property to turn it
		 *  into a flash.xml.XMLNode object If the <code>xmlEncode</code> property is not set, 
		 *  Flex uses the default
		 *  XMLEncoder to turn the object graph into a flash.xml.XMLNode object.
		 * 
		 *  <p>The <code>xmlEncode</code> property takes an Object and should return
		 *  a flash.xml.XMLNode object. In this case, the XMLNode object can be a flash.xml.XML object,
		 *  which is a subclass of XMLNode, or the first child of the
		 *  flash.xml.XML object, which is what you get from an <code>&lt;mx:XML&gt;</code> tag.
		 *  Returning the wrong type of object causes a fault.
		 *  The following example shows an &lt;mx:HTTPService&gt; tag that specifies an xmlEncode function:</p>
		 
		 <pre>
		 &lt;mx:HTTPService id="hs" xmlEncode="xmlEncoder" url="myURL" resultFormat="object" contentType="application/xml"&gt;
		 &lt;mx:request&gt;&lt;source/&gt;
		 &lt;obj&gt;{RequestObject}&lt;/obj&gt;
		 &lt;/mx:request&gt;
		 &lt;/mx:HTTPService&gt;
		 </pre>
		 
		 
		 The following example shows an xmlEncoder function:
		 <pre>
		 function xmlEncoder (myObj)
		 {
		 return new XML("<userencoded><attrib0>MyObj.test</attrib0>
		 <attrib1>MyObj.anotherTest</attrib1></userencoded>");
		 }
		 </pre>
		 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public function get xmlEncode():Function
		{
			return operation.xmlEncode;
		}
		public function set xmlEncode(u:Function):void
		{
			operation.xmlEncode = u;
		}
		
		[Bindable("resultForBinding")]
		/**
		 *  The result of the last invocation.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		override public function get lastResult():Object
		{
			return operation.lastResult;
		}
		
		/**
		 *  @inheritDoc
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		override public function clearResult(fireBindingEvent:Boolean = true):void
		{
			operation.clearResult(fireBindingEvent);
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
		 *  @productversion Royale 0.9.3
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
			if (asyncRequest.requestTimeout != value)
			{
				asyncRequest.requestTimeout = value;
				
				// Propagate to operation instance.
				if (operation)
					operation.requestTimeout = value;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		// Methods
		// 
		//--------------------------------------------------------------------------
		
		/**
		 *  Logs the user out of the destination. 
		 *  Logging out of a destination applies to everything connected using the same channel
		 *  as specified in the server configuration. For example, if you're connected over the my-rtmp channel
		 *  and you log out using one of your RPC components, anything that was connected over my-rtmp is logged out.
		 *
		 *  <p><b>Note:</b> Adobe recommends that you use the mx.messaging.ChannelSet.logout() method
		 *  rather than this method. </p>
		 *
		 *  @see mx.messaging.ChannelSet#logout()   
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public function logout():void
		{
			asyncRequest.logout();
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
			if (parameters == null)
				parameters = request;
			
			return operation.sendBody(parameters);
		}
		
		/**
		 *  Disconnects the service's network connection.
		 *  This method does not wait for outstanding network operations to complete.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public function disconnect():void
		{
			asyncRequest.disconnect();
		}
		
		/**
		 *  Sets the credentials for the destination accessed by the service.
		 *  The credentials are applied to all services connected over the same ChannelSet.
		 *  Note that services that use a proxy to a remote destination
		 *  will need to call the <code>setRemoteCredentials()</code> method instead.
		 * 
		 *  @param username the username for the destination.
		 *  @param password the password for the destination.
		 *  @param charset The character set encoding to use while encoding the
		 *  credentials. The default is null, which implies the legacy charset of
		 *  ISO-Latin-1. The only other supported charset is &quot;UTF-8&quot;.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		public function setCredentials(username:String, password:String, charset:String=null):void
		{
			asyncRequest.setCredentials(username, password, charset);
		}
		
		/**
		 *  The username and password to authenticate a user when accessing
		 *  the HTTP URL. These are passed as part of the HTTP Authorization
		 *  header from the proxy to the endpoint. If the <code>useProxy</code> property
		 *  is set to is false, this property is ignored.
		 *     
		 *  @param remoteUsername the username to pass to the remote endpoint.
		 *  @param remotePassword the password to pass to the remote endpoint.
		 *  @param charset The character set encoding to use while encoding the
		 *  remote credentials. The default is null, which implies the legacy
		 *  charset of ISO-Latin-1. The only other supported charset is
		 *  &quot;UTF-8&quot;.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */ 
		public function setRemoteCredentials(remoteUsername:String, 
											 remotePassword:String,
											 charset:String=null):void
		{
			asyncRequest.setRemoteCredentials(remoteUsername, remotePassword, charset);
		}
		
		/**
		 *  @inheritDoc
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 0.9.3
		 */
		override public function cancel(id:String = null):AsyncToken
		{
			return operation.cancel(id);
		}
		
	}
}

import mx.core.mx_internal;

import mx.rpc.events.AbstractEvent;
import mx.rpc.http.AbstractOperation;
import mx.rpc.http.HTTPService;

/**
 *  @private
 *  
 *  An HTTPService specific override that allow service level event listeners 
 *  to handle RPC events.
 */
class HTTPOperation extends AbstractOperation 
{
	public function HTTPOperation(httpService:HTTPService, name:String=null)
	{
		super(null, name);
		this.httpService = httpService;        
	}
	
	/**
	 *  @private
	 */ 
	override mx_internal function dispatchRpcEvent(event:AbstractEvent):void
	{
		if (hasEventListener(event.type))
		{
			event.mx_internal::callTokenResponders();
			if (!event.isDefaultPrevented())
				dispatchEvent(event);
		}
		else
		{
			if (httpService != null)
				httpService.mx_internal::dispatchRpcEvent(event);
			else
				event.mx_internal::callTokenResponders();
		}            
	}
	
	/**
	 *  @private
	 */ 
	private var httpService:HTTPService; 
}

