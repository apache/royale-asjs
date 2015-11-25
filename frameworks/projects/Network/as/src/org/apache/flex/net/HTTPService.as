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
package org.apache.flex.net
{
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the request is complete.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	[Event(name="complete", type="org.apache.flex.events.Event")]
	
    /**
     *  Dispatched if an error occurs in the server communication.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	[Event(name="ioError", type="org.apache.flex.events.Event")]
	
    /**
     *  Dispatched when an httpStatus code is received from the server.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	[Event(name="httpStatus", type="org.apache.flex.events.Event")]
	
    /**
     *  Dispatched if Adobe AIR is able to detect and return the status 
     *  code for the request.  Unlike the httpStatus event, the httpResponseStatus 
     *  event is delivered before any response data. Also, the httpResponseStatus 
     *  event includes values for the responseHeaders and responseURL properties 
     *  (which are undefined for an httpStatus event. Note that the 
     *  httpResponseStatus event (if any) will be sent before 
     *  (and in addition to) any complete or error event.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	[Event(name="httpResponseStatus", type="org.apache.flex.events.Event")]
    
    [DefaultProperty("beads")]
    
    /**
     *  The HTTPService class is a class designed to transfer text 
     *  over HTTP.  Use BinaryUploader for transferring non-text.
     * 
     *  @see org.apache.flex.net.BinaryUploader.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
	public class HTTPService extends EventDispatcher implements IStrand, IBead
	{
        /**
         *  @copy org.apache.flex.net.BinaryUploader#HTTP_METHOD_GET
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public static const HTTP_METHOD_GET:String = URLRequestMethod.GET;
        
        /**
         *  @copy org.apache.flex.net.BinaryUploader#HTTP_METHOD_POST
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public static const HTTP_METHOD_POST:String = URLRequestMethod.POST;
        
        /**
         *  @copy org.apache.flex.net.BinaryUploader#HTTP_METHOD_PUT
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public static const HTTP_METHOD_PUT:String = URLRequestMethod.PUT;

        /**
         *  @copy org.apache.flex.net.BinaryUploader#HTTP_METHOD_DELETE
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public static const HTTP_METHOD_DELETE:String = URLRequestMethod.DELETE;
		
        /**
         *  Dispatched when the request is complete.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static const EVENT_COMPLETE:String = "complete";
        
        /**
         *  Dispatched if an error occurs in the server communication.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static const EVENT_IO_ERROR:String = "ioError";
        
        /**
         *  Dispatched when an httpStatus code is received from the server.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static const EVENT_HTTP_STATUS:String = "httpStatus";
        
        /**
         *  Dispatched if Adobe AIR is able to detect and return the status 
         *  code for the request.  Unlike the httpStatus event, the httpResponseStatus 
         *  event is delivered before any response data. Also, the httpResponseStatus 
         *  event includes values for the responseHeaders and responseURL properties 
         *  (which are undefined for an httpStatus event. Note that the 
         *  httpResponseStatus event (if any) will be sent before 
         *  (and in addition to) any complete or error event.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static const EVENT_HTTP_RESPONSE_STATUS:String = "httpResponseStatus";
        
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function HTTPService()
		{
			super();
		}
		
		private var _contentType:String = "application/x-www-form-urlencoded";
        
        /**
         *  @copy org.apache.flex.net.BinaryUploader#contentType
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get contentType():String
		{
			return _contentType;
		}

        /**
         *  @private
         */
        public function set contentType(value:String):void
		{
			if (_contentType != value)
			{
				_contentType = value;
				dispatchEvent(new Event("contentTypeChanged"));
			}
		}
		
		private var _contentData:String;

        /**
         *  The text to send to the server, if any.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get contentData():String
		{
			return _contentData;
		}

        /**
         *  @private
         */
		public function set contentData(value:String):void
		{
			if (_contentData != value)
			{
				_contentData = value;
				dispatchEvent(new Event("contentDataChanged"));
			}
		}

		private var _headers:Array;
        
        /**
         *  @copy org.apache.flex.net.BinaryUploader#headers
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get headers():Array
		{
			if (_headers == null)
				_headers = [];
			return _headers;
		}

        /**
         *  @private
         */
		public function set headers(value:Array):void
		{
			if (_headers != value)
			{
				_headers = value;
				dispatchEvent(new Event("headersChanged"));
			}
		}
		
		private var _method:String = HTTP_METHOD_GET;

        /**
         *  @copy org.apache.flex.net.BinaryUploader#method
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
			if (_method != value)
			{
				_method = value;
				dispatchEvent(new Event("methodChanged"));
			}
		}
		
		private var _responseHeaders:Array;
        
        /**
         *  @copy org.apache.flex.net.BinaryUploader#responseHeaders
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get responseHeaders():Array
		{
			if (_responseHeaders && _responseHeaders.length > 0)
			{
				if (_responseHeaders[0] is URLRequestHeader)
				{
					var n:int = _responseHeaders.length;
					for (var i:int = 0; i < n; i++)
					{
						var old:URLRequestHeader = _responseHeaders[i];
						var nu:HTTPHeader = new HTTPHeader(old.name, old.value);
						_responseHeaders[i] = nu;
					}
				}
			}
			return _responseHeaders;
		}
		
		private var _responseURL:String;
        
        /**
         *  @copy org.apache.flex.net.BinaryUploader#responseURL
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get responseURL():String
		{
			return _responseURL;	
		}
		
		private var _status:int;

        /**
         *  @copy org.apache.flex.net.BinaryUploader#status
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get status():int
		{
			return _status;
		}
		
		private var _url:String;

        /**
         *  @copy org.apache.flex.net.BinaryUploader#url
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
			if (_url != value)
			{
                _url = value;
				dispatchEvent(new Event("urlChanged"));
			}
		}
		
		private var _timeout:Number = 0;
        
        /**
         *  @copy org.apache.flex.net.BinaryUploader#timeout
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get timeout():Number
		{
			return _timeout;
		}

        /**
         *  @private
         */
		public function set timeout(value:Number):void
		{
			if (_timeout != value)
			{
				_timeout = value;
				dispatchEvent(new Event("timeoutChanged"));
			}
		}
		
		private var _id:String;
        
        /**
         *  @copy org.apache.flex.core.UIBase#id
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function get id():String
		{
			return _id;
		}
        
        /**
         *  @private
         */
		public function set id(value:String):void
		{
			if (_id != value)
			{
				_id = value;
				dispatchEvent(new Event("idChanged"));
			}
		}
		
        private var _strand:IStrand;
        
        /**
         *  @copy org.apache.flex.core.UIBase#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function set strand(value:IStrand):void
        {
            _strand = value;
            if (_beads == null)
            {
                for each (var bead:IBead in beads)
                    addBead(bead);
            }
            
            dispatchEvent(new org.apache.flex.events.Event("beadsAdded"));
       }

        /**
         *  @copy org.apache.flex.core.UIBase#id
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public var beads:Array;
		
		private var _beads:Vector.<IBead>;
        
        /**
         *  @copy org.apache.flex.core.UIBase#addBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function addBead(bead:IBead):void
		{
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			bead.strand = this;
		}
		
        /**
         *  @copy org.apache.flex.core.UIBase#getBeadByType()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in _beads)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}
		
        /**
         *  @copy org.apache.flex.core.UIBase#removeBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function removeBead(value:IBead):IBead	
		{
			var n:int = _beads.length;
			for (var i:int = 0; i < n; i++)
			{
				var bead:IBead = _beads[i];
				if (bead == value)
				{
					_beads.splice(i, 1);
					return bead;
				}
			}
			return null;
		}

        private var urlLoader:URLLoader;
        
        /**
         *  Sends the headers and contentData to the server.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function send():void
        {
            if (_beads == null)
            {
                for each (var bead:IBead in beads)
                addBead(bead);
            }
            
            if (!urlLoader)
                urlLoader = new URLLoader();
			var request:URLRequest = new URLRequest(url);
			request.method = method;
			if ("idleTimeout" in request)
			{
				request["idleTimeout"] = timeout;
			}
			var sawContentType:Boolean;
			if (headers)
			{
				for each (var header:HTTPHeader in headers)
				{
					var urlHeader:URLRequestHeader = new URLRequestHeader(header.name, header.value);
					request.requestHeaders.push(urlHeader);
					if (header.name == HTTPHeader.CONTENT_TYPE)
						sawContentType = true;
				}
			}
			if (method != HTTP_METHOD_GET && !sawContentType && contentData != null)
			{
				urlHeader = new URLRequestHeader(HTTPHeader.CONTENT_TYPE, contentType);
				request.requestHeaders.push(urlHeader);
			}
			if (contentData)
			{
				if (method == HTTP_METHOD_GET)
				{
					if (url.indexOf("?") != -1)
						url += contentData;
					else
						url += "?" + contentData;
				}
				else
					request.data = contentData;
			}
			urlLoader.addEventListener(flash.events.Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			if (HTTPStatusEvent.HTTP_RESPONSE_STATUS) // only on AIR
				urlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, statusHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, statusHandler);
            urlLoader.load(request);
        }
        
        /**
         *  @copy org.apache.flex.net.BinaryUploader#statusHandler()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		protected function statusHandler(event:HTTPStatusEvent):void
		{
			_status = event.status;
			if ("responseHeaders" in event)
				_responseHeaders = event.responseHeaders;
			if ("responseURL" in event)
				_responseURL = event.responseURL;
			dispatchEvent(new Event(event.type));
		}
		
        /**
         *  @copy org.apache.flex.net.BinaryUploader#ioErrorHandler()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			dispatchEvent(new Event(event.type));
		}
		
        /**
         *  @copy org.apache.flex.net.BinaryUploader#completeHandler()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        protected function completeHandler(event:flash.events.Event):void
        {
            dispatchEvent(new Event(event.type));
        }
        
        /**
         *  The text returned from the server.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get data():String
        {
            return urlLoader.data;
        }
        
        
        private var _json:Object;
        
        /**
         *  A JSON object parsed from the data.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get json():Object
        {
            if (!_json)
                _json = JSON.parse(data);
            return _json;
        }

    }
}