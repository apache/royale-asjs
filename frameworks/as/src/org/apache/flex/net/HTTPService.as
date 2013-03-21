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
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	import org.apache.flex.core.IBead;
	import org.apache.flex.core.IStrand;
	
	[Event("complete", flash.events.Event)]
	
	[Event("ioError", flash.events.IOErrorEvent)]
	
	[Event("httpStatus", flash.events.Event)]
	
	[Event("httpResponseStatus", flash.events.Event)]
    
    [DefaultProperty("beads")]
    
	public class HTTPService extends EventDispatcher implements IStrand, IBead
	{
		public static const HTTP_METHOD_GET:String = URLRequestMethod.GET;
		public static const HTTP_METHOD_POST:String = URLRequestMethod.POST;
		public static const HTTP_METHOD_PUT:String = URLRequestMethod.PUT;
		public static const HTTP_METHOD_DELETE:String = URLRequestMethod.DELETE;
		
		public function HTTPService()
		{
			super();
		}
		
		private var _contentType:String = "application/x-www-form-urlencoded";
		public function get contentType():String
		{
			return _contentType;
		}
		public function set contentType(value:String):void
		{
			if (_contentType != value)
			{
				_contentType = value;
				dispatchEvent(new Event("contentTypeChanged"));
			}
		}
		
		private var _contentData:String;
		public function get contentData():String
		{
			return _contentData;
		}
		public function set contentData(value:String):void
		{
			if (_contentData != value)
			{
				_contentData = value;
				dispatchEvent(new Event("contentDataChanged"));
			}
		}

		private var _headers:Array;
		public function get headers():Array
		{
			return _headers;
		}
		public function set headers(value:Array):void
		{
			if (_headers != value)
			{
				_headers = value;
				dispatchEvent(new Event("headersChanged"));
			}
		}
		
		private var _method:String = HTTP_METHOD_GET;
		public function get method():String
		{
			return _method;
		}
		public function set method(value:String):void
		{
			if (_method != value)
			{
				_method = value;
				dispatchEvent(new Event("methodChanged"));
			}
		}
		
		private var _responseHeaders:Array;
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
		private function get responseURL():String
		{
			return _responseURL;	
		}
		
		private var _status:int;
		public function get status():int
		{
			return _status;
		}
		
		private var _url:String;
		public function get url():String
		{
			return _url;
		}
		public function set url(value:String):void
		{
			if (_url != value)
			{
                _url = value;
				dispatchEvent(new Event("urlChanged"));
			}
		}
		
		private var _timeout:Number = 0;
		public function get timeout():Number
		{
			return _timeout;
		}
		public function set timeout(value:Number):void
		{
			if (_timeout != value)
			{
				_timeout = value;
				dispatchEvent(new Event("timeoutChanged"));
			}
		}
		
		private var _id:String;
		public function get id():String
		{
			return _id;
		}
		public function set id(value:String):void
		{
			if (_id != value)
			{
				_id = value;
				dispatchEvent(new Event("idChanged"));
			}
		}
		
        private var _strand:IStrand;
        
        public function set strand(value:IStrand):void
        {
            _strand = value;
        }

		// beads declared in MXML are added to the strand.
		// from AS, just call addBead()
		public var beads:Array;
		
		private var _beads:Vector.<IBead>;
		public function addBead(bead:IBead):void
		{
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			bead.strand = this;
		}
		
		public function getBeadByType(classOrInterface:Class):IBead
		{
			for each (var bead:IBead in _beads)
			{
				if (bead is classOrInterface)
					return bead;
			}
			return null;
		}
		
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
        
        public function send():void
        {
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
			urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, statusHandler);
			urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, statusHandler);
            urlLoader.load(request);
        }
        
		protected function statusHandler(event:HTTPStatusEvent):void
		{
			_status = event.status;
			_responseHeaders = event.responseHeaders;
			_responseURL = event.responseURL;
			dispatchEvent(event);
		}
		
		protected function ioErrorHandler(event:Event):void
		{
			dispatchEvent(event);
		}
		
        protected function completeHandler(event:Event):void
        {
            dispatchEvent(event);
        }
        
        public function get data():*
        {
            return urlLoader.data;
        }
    }
}