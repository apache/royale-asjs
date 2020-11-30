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
	// import flash.utils.getQualifiedClassName;
	// import flash.xml.XMLDocument;
	// import flash.xml.XMLNode;
		
	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;
	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.DirectHTTPChannel;
	import mx.messaging.config.LoaderConfig;
	import mx.messaging.errors.ArgumentError;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.messages.AsyncMessage;
	import mx.messaging.messages.HTTPRequestMessage;
	import mx.messaging.messages.IMessage;
	import mx.netmon.NetworkMonitor;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.rpc.AbstractService;
	import mx.rpc.AsyncDispatcher;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.mxml.Concurrency;
	import mx.rpc.xml.SimpleXMLDecoder;
	import mx.utils.ObjectProxy;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.utils.URLUtil;
	
	use namespace mx_internal;
	
	/**
	 * An Operation used specifically by HTTPService or HTTPMultiService.  An Operation is an 
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
	public class AbstractOperation extends mx.rpc.AbstractOperation
	{
		//---------------------------------
		// Constructor
		//---------------------------------
		
		/**
		 *  Creates a new Operation. 
		 * 
		 *  @param service The object defining the type of service, such as 
		 *  HTTPMultiService, WebService, or RemoteObject.
		 *
		 *  @param name The name of the service.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 
		 *  Creates a new Operation. 
		 *
		 *  @param service The object defining the type of service, such as 
		 *  HTTPMultiService, WebService, or RemoteObject.
		 *
		 *  @param name The name of the service.
		 */
		public function AbstractOperation(service:AbstractService=null, name:String=null)
		{
			super(service, name);
			
			_log = Log.getLogger("mx.rpc.http.HTTPService");
			
			concurrency = Concurrency.MULTIPLE;
		}
		
		/**
		 *  The result format "e4x" specifies that the value returned is an XML instance, which can be accessed using ECMAScript for XML (E4X) expressions.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal static const RESULT_FORMAT_E4X:String = "e4x";
		
		/**
		 *  The result format "flashvars" specifies that the value returned is text containing name=value pairs
		 *  separated by ampersands, which is parsed into an ActionScript object.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal static const RESULT_FORMAT_FLASHVARS:String = "flashvars";
		
		/**
		 *  The result format "object" specifies that the value returned is XML but is parsed as a tree of ActionScript objects. This is the default.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal static const RESULT_FORMAT_OBJECT:String = "object";
		
		/**
		 *  The result format "array" is similar to "object" however the value returned is always an Array such
		 *  that if the result returned from result format "object" is not an Array already the item will be
		 *  added as the first item to a new Array.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal static const RESULT_FORMAT_ARRAY:String = "array";
		
		/**
		 *  The result format "text" specifies that the HTTPService result text should be an unprocessed String.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal static const RESULT_FORMAT_TEXT:String = "text";
		
		/**
		 *  The result format "xml" specifies that results should be returned as an flash.xml.XMLNode instance pointing to
		 *  the first child of the parent flash.xml.XMLDocument.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		// mx_internal static const RESULT_FORMAT_XML:String = "xml";
		
		/**
		 *  Indicates that the data being sent by the HTTP service is encoded as application/xml.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal static const CONTENT_TYPE_XML:String = "application/xml";
		
		/**
		 *  Indicates that the data being sent by the HTTP service is encoded as application/x-www-form-urlencoded.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		mx_internal static const CONTENT_TYPE_FORM:String = "application/x-www-form-urlencoded";
		
		// Constants for error codes
		/**
		 *  Indicates that the useProxy property was set to false but a url was not provided.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private static const ERROR_URL_REQUIRED:String = "Client.URLRequired";
		
		/**
		 *  Indicates that an XML formatted result could not be parsed into an XML instance
		 *  or decoded into an Object.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private static const ERROR_DECODING:String = "Client.CouldNotDecode";
		
		/**
		 *  Indicates that an input parameter could not be encoded as XML.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		private static const ERROR_ENCODING:String = "Client.CouldNotEncode";    
		
		//---------------------------------
		// Properties
		//---------------------------------
		
        private var _argumentNames:Array;
        
		/**
		 * An ordered list of the names of the arguments to pass to a method invocation.  Since the arguments object is
		 * a hashmap with no guaranteed ordering, this array helps put everything together correctly.
		 * It will be set automatically by the MXML compiler, if necessary, when the Operation is used in tag form.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get argumentNames():Array
        {
            return _argumentNames;
        }
		public function set argumentNames(value:Array):void
        {
            _argumentNames = value;
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
		 *  @productversion Flex 3
		 */
		public function get method():String
		{
			return _method;
		}
		public function set method(m:String):void
		{
			_method = m;
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
		 *  @productversion Flex 3
		 */
		public function get concurrency():String
		{
			return _concurrency;
		}
		
		/**
		 *  @private
		 */
		public function set concurrency(c:String):void
		{
			_concurrency = c;
		}
		
		//----------------------------------
		//  requestTimeout
		//----------------------------------
		
		/**
		 *  @private
		 */
		private var _requestTimeout:int = -1;
		
		/**
		 *  Provides access to the request timeout in seconds for sent messages.
		 *  If an acknowledgement, response or fault is not received from the
		 *  remote destination before the timeout is reached the message is faulted
		 *  on the client. A value less than or equal to zero prevents request timeout.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion BlazeDS 4
		 *  @productversion LCDS 3           
		 */
		public function get requestTimeout():int
		{
			return _requestTimeout;
		}
		
		/**
		 *  @private
		 */
		public function set requestTimeout(value:int):void
		{
			if (_requestTimeout != value)
				_requestTimeout = value;
		}
		
		/**
		 *  @private
		 */
		private var _resultFormat:String = RESULT_FORMAT_OBJECT;
		
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
			switch (value)
			{
				case RESULT_FORMAT_OBJECT:
				case RESULT_FORMAT_ARRAY:
					//case RESULT_FORMAT_XML:
				case RESULT_FORMAT_E4X:
				case RESULT_FORMAT_TEXT:
				case RESULT_FORMAT_FLASHVARS:
				{
					break;
				}
					
				default:
				{
					var sf:SerializationFilter;
					if (value != null && (sf = SerializationFilter.filterForResultFormatTable[value]) == null)
					{
						// TODO: share this code with HTTPService, HTTPMultiService?  Also
						// improve the error/asdoc to include discussion of the SerializationFilter
						// and in the error display the contents of the SerializationFilter.filterForResultFormatTable
						// to make it clear which SerializationFormats are available in the current
						// context.
						var message:String = resourceManager.getString(
							"rpc", "invalidResultFormat",
							[ value, RESULT_FORMAT_OBJECT, RESULT_FORMAT_ARRAY,
								/*RESULT_FORMAT_XML, */RESULT_FORMAT_E4X,
								RESULT_FORMAT_TEXT, RESULT_FORMAT_FLASHVARS ]);
						throw new ArgumentError(message);
					}
					serializationFilter = sf;
				}
			}
			_resultFormat = value;
		}
		
        private var _serializationFilter:SerializationFilter;
        
		/**
		 * A SerializationFilter can control how the arguments are formatted to form the content
		 * of the HTTP request.  It also controls how the results are converted into ActionScript
		 * objects.  It can be set either explicitly using this property or indirectly using the
		 * resultFormat property.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get serializationFilter():SerializationFilter
        {
            return _serializationFilter;
        }
        public function set serializationFilter(value:SerializationFilter):void
        {
            _serializationFilter = value;
        }
		
		/** 
		 *  Returns the serialization filter.
		 *  Subclasses can override this method to control 
		 *  the retrieval of the HTTP request headers. 
		 *
		 *  @return The serialization filter.
		 */
		protected function getSerializationFilter():SerializationFilter
		{
			return serializationFilter;
		}
		
		//----------------------------------
		//  request
		//----------------------------------
		
        private var _request:Object = {};
        
		[Inspectable(defaultValue="undefined", category="General")]
		/**
		 *  Object of name-value pairs used as parameters to the URL. If
		 *  the <code>contentType</code> property is set to <code>application/xml</code>, it should be an XML document.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get request():Object
        {
            return _request;
        }
        public function set request(value:Object):void
        {
            _request = value;
        }
		
		
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
		
		//----------------------------------
		//  useProxy
		//----------------------------------
		
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
		
		//----------------------------------
		//  xmlDecode
		//----------------------------------
        
		private var _xmlDecode:Function;
        
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
		 
		 *  @productversion Flex 3
		 
		 */
		public function get xmlDecode():Function
        {
            return _xmlDecode;
        }
        public function set xmlDecode(value:Function):void
        {
            _xmlDecode = value;
        }
		
		//----------------------------------
		//  xmlEncode
		//----------------------------------
		
        private var _xmlEncode:Function;
        
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
		 
		 *  @productversion Flex 3
		 
		 */
		public function get xmlEncode():Function
        {
            return _xmlEncode;
        }
        public function set xmlEncode(value:Function):void
        {
            _xmlEncode = value;
        }
		
		//----------------------------------
		//  headers
		//----------------------------------
        
        private var _headers:Object = {};
        
		[Inspectable(defaultValue="undefined", category="General")]
		/**
		 *  Custom HTTP headers to be sent to the third party endpoint. If multiple headers need to
		 *  be sent with the same name the value should be specified as an Array.
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
		//  contentType
		//----------------------------------
		
		// These are not all of the allowed values and mxmlc is now enforcing the value is in this list.  We could add this back if
		// there was wildcard support.
		//[Inspectable(enumeration="application/x-www-form-urlencoded,application/xml", defaultValue="application/x-www-form-urlencoded", category="General")]
		
		private var _contentType:String = CONTENT_TYPE_FORM;
		/**
		 *  Type of content for service requests. 
		 *  The default is <code>application/x-www-form-urlencoded</code> which sends requests
		 *  like a normal HTTP POST with name-value pairs. <code>application/xml</code> send
		 *  requests as XML.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get contentType():String
		{
			return _contentType;
		}
		public function set contentType(ct:String):void
		{
			_contentType = ct;
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
		//  rootURL
		//----------------------------------
		
		/**
		 *  @private
		 */
		mx_internal var _rootURL:String;
		
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
		 *  @productversion Flex 3
		 */
		public function get rootURL():String
		{
			if (_rootURL == null)
			{
				_rootURL = LoaderConfig.url;
			}
			return _rootURL;
		}
		
		/**
		 *  @private
		 */
		public function set rootURL(value:String):void
		{
			_rootURL = value;
		}
		
		//---------------------------------
		// Methods
		//---------------------------------
		
		/**
		 * @private
		 */
		override public function cancel(id:String = null):AsyncToken
		{
			//if (showBusyCursor)
			//{
				// CursorManager.removeBusyCursor();
			//}
			return super.cancel(id);
		}
		
		public function sendBody(parameters:Object):AsyncToken
		{
			var filter:SerializationFilter = getSerializationFilter();
			
			var paramsToSend:Object;
			var token:AsyncToken;
			var fault:Fault;
			var faultEvent:FaultEvent;
			var msg:String;
			
			//concurrency check
			if (Concurrency.SINGLE == concurrency && activeCalls.hasActiveCalls())
			{
				token = new AsyncToken(null);
				var m:String = resourceManager.getString(
					"rpc", "pendingCallExists");
				fault = new Fault("ConcurrencyError", m);
				faultEvent = FaultEvent.createEvent(fault, token);
				new AsyncDispatcher(dispatchRpcEvent, [faultEvent], 10);
				return token;
			}
			
			var ctype:String = contentType; 
			var urlToUse:String = url; 
			
			if (urlToUse && urlToUse != '')
			{
				urlToUse = URLUtil.getFullURL(rootURL, urlToUse);
			}
			
			if (filter != null)
			{
				// TODO: does this need to run on the array version of the parameters
				ctype = filter.getRequestContentType(this, parameters, ctype);
				urlToUse = filter.serializeURL(this, parameters, urlToUse);
				parameters = filter.serializeBody(this, parameters);
			}
			
			if (ctype == CONTENT_TYPE_XML)
			{
				
				if (parameters is String && xmlEncode == null)
				{
					paramsToSend = parameters as String;
				} else if(parameters is Array && parameters.length == 0) {
					paramsToSend = "<>";
				} else { 
					paramsToSend = parameters.toXMLString();	
				}
				/*else if (!(parameters is XMLNode) && !(parameters is XML))
				{
				if (xmlEncode != null)
				{
				var funcEncoded:Object = xmlEncode(parameters);
				if (null == funcEncoded)
				{
				token = new AsyncToken(null);
				msg = resourceManager.getString(
				"rpc", "xmlEncodeReturnNull");
				fault = new Fault(ERROR_ENCODING, msg);
				faultEvent = FaultEvent.createEvent(fault, token);
				new AsyncDispatcher(dispatchRpcEvent, [faultEvent], 10);
				return token;
				}
				else if (!(funcEncoded is XMLNode))
				{
				token = new AsyncToken(null);
				msg = resourceManager.getString(
				"rpc", "xmlEncodeReturnNoXMLNode");
				fault = new Fault(ERROR_ENCODING, msg);
				faultEvent = FaultEvent.createEvent(fault, token);
				new AsyncDispatcher(dispatchRpcEvent, [faultEvent], 10);
				return token;
				}
				else
				{
				paramsToSend = XMLNode(funcEncoded).toString();
				}
				}
				else
				{
				var encoder:SimpleXMLEncoder = new SimpleXMLEncoder(null);                    
				var xmlDoc:XMLDocument = new XMLDocument();
				
				//right now there is a wasted <encoded> wrapper tag
				//call.appendChild(encoder.encodeValue(parameters));
				var childNodes:Array = encoder.encodeValue(parameters, new QName(null, "encoded"), new XMLNode(1, "top")).childNodes.concat();                    
				for (var i:int = 0; i < childNodes.length; ++i)
				xmlDoc.appendChild(childNodes[i]);
				
				paramsToSend = xmlDoc.toString();
				}
				}
				else
				{
				paramsToSend = XML(parameters).toXMLString();
				}*/
			}
			else if (ctype == CONTENT_TYPE_FORM)
			{
				paramsToSend = {};
				var val:Object;
				
				if (typeof(parameters) == "object")
				{
					//get all dynamic and all concrete properties from the parameters object
					var classinfo:Object = ObjectUtil.getClassInfo(parameters);
					
					for each (var p:* in classinfo.properties)
					{
						val = parameters[p];
						if (val != null)
						{
							if (val is Array)
								paramsToSend[p] = val;
							else
								paramsToSend[p] = val.toString();
						}
					}
				}
				else
				{
					paramsToSend = parameters;
				}
			}
			else
			{
				paramsToSend = parameters;
			}
			
			var message:HTTPRequestMessage = new HTTPRequestMessage();
			if (useProxy)
			{
				if (urlToUse && urlToUse != '')
				{
					message.url = urlToUse;
				}
				
				if (NetworkMonitor.isMonitoring())
				{
					//trace(" HTTPService: Recording Headers (useProxy = true)");
					message.recordHeaders = true;    
				}
			}
			else
			{
				if (!urlToUse)
				{
					token = new AsyncToken(null);
					msg = resourceManager.getString("rpc", "urlNotSpecified");
					fault = new Fault(ERROR_URL_REQUIRED, msg);
					faultEvent = FaultEvent.createEvent(fault, token);
					new AsyncDispatcher(dispatchRpcEvent, [faultEvent], 10);
					return token;
				}
				
				if (!useProxy)
				{
					var dcs:ChannelSet = getDirectChannelSet();
					if (dcs != asyncRequest.channelSet)
						asyncRequest.channelSet = dcs;
				}
				
				if (NetworkMonitor.isMonitoring())
				{
					//trace(" HTTPService: Recording Headers (useProxy = false)");
					message.recordHeaders = true;    
				}
				
				message.url = urlToUse;
			}
			
			message.contentType = ctype;
			message.method = method.toUpperCase();
			if (ctype == CONTENT_TYPE_XML && message.method == HTTPRequestMessage.GET_METHOD)
				message.method = HTTPRequestMessage.POST_METHOD;
			message.body = paramsToSend;
			message.httpHeaders = getHeaders();
			return invoke(message);
		}
		
		/**
		 *  Returns the HTTP request headers.
		 *  Subclasses can override this method to control 
		 *  the retrieval of the HTTP request headers. 
		 *
		 *  @return The HTTP request headers.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		protected function getHeaders():Object
		{
			return headers;
		}
		
		/**
		 *  @private
		 */
		override mx_internal function processResult(message:IMessage, token:AsyncToken):Boolean
		{
			var body:Object = message.body;
			
			_log.info("Decoding HTTPService response");
			_log.debug("Processing HTTPService response message:\n{0}", message);
			
			var filter:SerializationFilter = getSerializationFilter();
			
			if (filter != null)
				body = filter.deserializeResult(this, body);
			
			if ((body == null) || ((body != null) && (body is String) && (StringUtil.trim(String(body)) == "")))
			{
				_result = body;
				return true;
			}
			else if (body is String)
			{
				if (/*resultFormat == RESULT_FORMAT_XML || */resultFormat == RESULT_FORMAT_OBJECT 
					|| resultFormat == RESULT_FORMAT_ARRAY)
				{
					var oldSettings:Object = XML.settings();
					try{
						XML.setSettings(XML.defaultSettings());
						var temp:XMLList = new XMLList(String(body));
						var tmp:XML = new XML('<root>'+temp.toXMLString()+'</root>');
					} catch(parseError:Error)
					{
						//restore whatever settings were active
						XML.setSettings(oldSettings);
						var fault:Fault = new Fault(ERROR_DECODING, parseError.message);
						dispatchRpcEvent(FaultEvent.createEvent(fault, token, message));
						return false;
					}
					//restore whatever settings were active
					XML.setSettings(oldSettings);
					if (resultFormat == RESULT_FORMAT_OBJECT || resultFormat == RESULT_FORMAT_ARRAY)
					{
						var decoded:Object;
						var msg:String;
						if (xmlDecode != null)
						{
							decoded = xmlDecode(tmp);
							if (decoded == null)
							{
								/*msg = resourceManager.getString(
										"rpc", "xmlDecodeReturnNull");*/
								msg = 'XMLDecode returned null';
								var fault1:Fault = new Fault(ERROR_DECODING, msg);
								dispatchRpcEvent(FaultEvent.createEvent(fault1, token, message));
							}
						}
						else
						{
							var decoder:SimpleXMLDecoder = new SimpleXMLDecoder(makeObjectsBindable);
							
							decoded = decoder.decodeXML(tmp);
							
							if (decoded == null)
							{
								/*msg = resourceManager.getString(
										"rpc", "defaultDecoderFailed");*/
								msg = "defaultDecoderFailed";
								
								var fault2:Fault = new Fault(ERROR_DECODING, msg);
								dispatchRpcEvent(FaultEvent.createEvent(fault2, token, message));
							}
						}
						
						if (decoded == null)
						{
							return false;
						}
						
						if (makeObjectsBindable && false /*(getQualifiedClassName(decoded) == "Object")*/)
						{
							decoded = new ObjectProxy(decoded);
						}
						else
						{
							decoded = decoded;
						}
						
						if (resultFormat == RESULT_FORMAT_ARRAY)
						{
							decoded = decodeArray(decoded);
						}
						
						_result = decoded;
					}
					/*else
					{
						if (tmp.children().length() == 1)
						{
							tmp = tmp.children()[0];
						}
						// key difference here is that it will also be E4X:
						_result = tmp;
					}*/
					
				}
				else if (resultFormat == RESULT_FORMAT_E4X)
				{
					try
					{
						_result = new XML(String(body));
					}
					catch(error:Error)
					{
						var fault3:Fault = new Fault(ERROR_DECODING, error.message);
						dispatchRpcEvent(FaultEvent.createEvent(fault3, token, message));
						return false;
					}
				}
				else if (resultFormat == RESULT_FORMAT_FLASHVARS)
				{
					_result = decodeParameterString(String(body));
				}
				else //if only we could assert(theService.resultFormat == "text")
				{
					_result = body;
				}
			}
			else
			{
				if (resultFormat == RESULT_FORMAT_ARRAY)
				{
					body = decodeArray(body);
				}
				
				_result = body;
			}
			
			return true;
		}
		
		override mx_internal function invoke(message:IMessage, token:AsyncToken = null):AsyncToken
		{
			//if (showBusyCursor)
			//{
				// CursorManager.setBusyCursor();
			//}
			
			return super.invoke(message, token);
		}
		
		/*
		* Kill the busy cursor, find the matching call object and pass it back
		*/
		override mx_internal function preHandle(event:MessageEvent):AsyncToken
		{
			//if (showBusyCursor)
			//{
				// CursorManager.removeBusyCursor();
			//}
			
			var wasLastCall:Boolean = activeCalls.wasLastCall(AsyncMessage(event.message).correlationId);
			var token:AsyncToken = super.preHandle(event);
			
			if (Concurrency.LAST == concurrency && !wasLastCall)
			{
				return null;
			}
			//else
			return token;
		}
		
		//--------------------------------------------------------------------------
		//
		// Private Methods
		// 
		//--------------------------------------------------------------------------    
		
		private function decodeArray(o:Object):Object
		{
			var a:Array;
			
			if (o is Array)
			{
				a = o as Array;
			}
			else if (o is ArrayCollection)
			{
				return o;
			}
			else
			{
				a = [];
				a.push(o);
			}
			
			if (makeObjectsBindable)
			{
				return new ArrayCollection(a);
			}
			else
			{
				return a;            
			}
		}
		
		private function decodeParameterString(source:String):Object
		{
			var trimmed:String = StringUtil.trim(source);
			var params:Array = trimmed.split('&');
			var decoded:Object = {};
			for (var i:int = 0; i < params.length; i++)
			{
				var param:String = params[i];
				var equalsIndex:int = param.indexOf('=');
				if (equalsIndex != -1)
				{
					var name:String = param.substr(0, equalsIndex);
					name = name.split('+').join(' ');
					name = unescape(name);
					var value:String = param.substr(equalsIndex + 1);
					value = value.split('+').join(' ');
					value = unescape(value);
					decoded[name] = value;
				}
			}
			return decoded;
		}
		
		private function getDirectChannelSet():ChannelSet
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
		
		mx_internal var _log:ILogger;
		
		mx_internal var resourceManager:IResourceManager =
			ResourceManager.getInstance();
		/** 
		 *  @private
		 *  A shared direct Http channelset used for service instances that do not use the proxy. 
		 */
		private static var _directChannelSet:ChannelSet;
		
		private var _concurrency:String;
		
		private var _method:String = HTTPRequestMessage.GET_METHOD;
		
		private var _showBusyCursor:Boolean = false;
		
	}
	
}
