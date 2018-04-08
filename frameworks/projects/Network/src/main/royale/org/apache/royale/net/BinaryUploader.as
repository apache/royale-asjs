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
package org.apache.royale.net
{
    COMPILE::SWF
    {
        import flash.events.HTTPStatusEvent;
        import flash.events.IOErrorEvent;
        import flash.net.URLLoader;
        import flash.net.URLRequest;
        import flash.net.URLRequestHeader;
    }
	COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
    }
    
	import org.apache.royale.core.IBead;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.BinaryData;
	
    //--------------------------------------
    //  Events
    //--------------------------------------
    
    /**
     *  Dispatched when the upload is complete.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	[Event(name="complete", type="org.apache.royale.events.Event")]
	
    /**
     *  Dispatched if an error occurs in the upload.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	[Event(name="ioError", type="org.apache.royale.events.Event")]
	
    /**
     *  Dispatched when an httpStatus code is received from the server.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	[Event(name="httpStatus", type="org.apache.royale.events.Event")]
	
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
     *  @productversion Royale 0.0
     */
	[Event(name="httpResponseStatus", type="org.apache.royale.events.Event")]
    
    [DefaultProperty("beads")]
    
    /**
     *  The BinaryUploader class is a class designed to upload binary data
     *  over HTTP.  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class BinaryUploader extends HTTPServiceBase implements IStrand, IBead
	{
		/**
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 */
		public function BinaryUploader()
		{
			super();
            COMPILE::JS
            {
				element = new XMLHttpRequest() as WrappedHTMLElement;
            }
		}
		
		private var _contentType:String = "application/octet-stream";
        
        /**
         *  The content-type of the binary data.
         *  @default application/octet-stream
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
		
		private var _binaryData:BinaryData;
        
        /**
         *  The data to be uploaded.  Note the type of this
         *  property is org.apache.royale.utils.BinaryData.
         *  This class abstracts the way binary data is handled
         *  in the browser.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */        
		public function get binaryData():BinaryData
		{
			return _binaryData;
		}
        
        /**
         *  @private
         */
		public function set binaryData(value:BinaryData):void
		{
			if (_binaryData != value)
			{
				_binaryData = value;
				dispatchEvent(new Event("binaryDataChanged"));
			}
		}

		private var _headers:Array;
        
        /**
         *  The HTTP headers to be sent with the upload.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
		
		private var _method:String = HTTPConstants.POST;

        /**
         *  The HTTP method for the upload.
         *  @default POST
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
         *  The HTTP headers that were received from the server
         *  if any.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */        
		public function get responseHeaders():Array
		{
            COMPILE::SWF
            {
                if (_responseHeaders && _responseHeaders.length > 0)
                {
                    if (_responseHeaders[0] is flash.net.URLRequestHeader)
                    {
                        var n:int = _responseHeaders.length;
                        for (var i:int = 0; i < n; i++)
                        {
                            var old:flash.net.URLRequestHeader = _responseHeaders[i];
                            var nu:HTTPHeader = new HTTPHeader(old.name, old.value);
                            _responseHeaders[i] = nu;
                        }
                    }
                }
            }
            COMPILE::JS
            {
                var allHeaders:String;
                var c:int;
                var hdr:String;
                var i:int;
                var n:int;
                var part1:String;
                var part2:String;
                var element:XMLHttpRequest = this.element as XMLHttpRequest;
                
                if (!_responseHeaders) 
                {
                    allHeaders = element.getAllResponseHeaders();
                    _responseHeaders = allHeaders.split('\n');
                    n = _responseHeaders.length;
                    for (i = 0; i < n; i++) 
                    {
                        hdr = _responseHeaders[i];
                        c = hdr.indexOf(':');
                        part1 = hdr.substring(0, c);
                        part2 = hdr.substring(c + 2);
                        _responseHeaders[i] =
                            new HTTPHeader(part1, part2);
                    }
                }
            }
            return _responseHeaders;
   		}
		
		private var _responseURL:String;

        /**
         *  The value of the responseURL header, if any.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */        
		public function get responseURL():String
		{
			return _responseURL;	
		}
		
		private var _status:int;

        /**
         *  The http status code from the server, if any.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */        
		public function get status():int
		{
			return _status;
		}
		
		private var _url:String;

        /**
         *  The url of the server.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
         *  A timeout value for server response.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
         *  @copy org.apache.royale.core.UIBase#id
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
         *  @copy org.apache.royale.core.UIBase#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */        
        public function set strand(value:IStrand):void
        {
            _strand = value;
            
            for each (var bead:IBead in beads)
                addBead(bead);
            
            dispatchEvent(new org.apache.royale.events.Event("beadsAdded"));
        }

        /**
         *  @copy org.apache.royale.core.UIBase#beads
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         * 
         *  @royalesuppresspublicvarwarning
         */        
		public var beads:Array;
		
        COMPILE::SWF
		private var _beads:Vector.<IBead>;

        /**
         *  @copy org.apache.royale.core.UIBase#addBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */       
        COMPILE::SWF
		public function addBead(bead:IBead):void
		{
			if (!_beads)
				_beads = new Vector.<IBead>;
			_beads.push(bead);
			bead.strand = this;
		}
		
        /**
         *  @copy org.apache.royale.core.UIBase#getBeadByType()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */     
        COMPILE::SWF
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
         *  @copy org.apache.royale.core.UIBase#removeBead()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */  
        COMPILE::SWF
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

        COMPILE::SWF
        private var urlLoader:flash.net.URLLoader;
        
        /**
         *  Starts the upload to the server.  Events
         *  are dispatched as the upload progresses.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */        
        public function send():void
        {
            COMPILE::SWF
            {
                if (!urlLoader)
                    urlLoader = new flash.net.URLLoader();
                var request:flash.net.URLRequest = new flash.net.URLRequest(url);
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
                        var urlHeader:flash.net.URLRequestHeader = new flash.net.URLRequestHeader(header.name, header.value);
                        request.requestHeaders.push(urlHeader);
                        if (header.name == HTTPHeader.CONTENT_TYPE)
                            sawContentType = true;
                    }
                }
                if (method != HTTPConstants.GET && !sawContentType)
                {
                    urlHeader = new flash.net.URLRequestHeader(HTTPHeader.CONTENT_TYPE, contentType);
                    request.requestHeaders.push(urlHeader);
                }
                if (binaryData)
                {
                    if (method == HTTPConstants.GET)
                    {
                        if (url.indexOf("?") != -1)
                            url += binaryData.data.toString();
                        else
                            url += "?" + binaryData.data.toString();
                    }
                    else
                        request.data = binaryData.data;
                }
                urlLoader.addEventListener(flash.events.Event.COMPLETE, completeHandler);
                urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                if (HTTPStatusEvent.HTTP_RESPONSE_STATUS) // only on AIR
                    urlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, statusHandler);
                urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, statusHandler);
                urlLoader.load(request);
                
            }
            COMPILE::JS
            {
                var element:XMLHttpRequest = this.element as XMLHttpRequest;
                element.onreadystatechange = progressHandler;
                
                url = _url;
                
                var binaryData:String = null;
                if (_binaryData != null) {
                    if (_method == HTTPConstants.GET) {
                        if (url.indexOf('?') != -1) {
                            url += _binaryData.data;
                        } else {
                            url += '?' + _binaryData.data;
                        }
                    } else {
                        binaryData = _binaryData.data.toString();
                    }
                }
                
                element.open(_method, _url, true);
                element.timeout = _timeout;
                
                var sawContentType:Boolean = false;
                if (_headers) {
                    var n:int = _headers.length;
                    for (var i:int = 0; i < n; i++) {
                        var header:HTTPHeader = _headers[i];
                        if (header.name == HTTPHeader.CONTENT_TYPE) {
                            sawContentType = true;
                        }
                        
                        element.setRequestHeader(header.name, header.value);
                    }
                }
                
                if (_method != HTTPConstants.GET &&
                    !sawContentType && binaryData) {
                    element.setRequestHeader(
                        HTTPHeader.CONTENT_TYPE, _contentType);
                }
                
                if (binaryData) {
                    element.setRequestHeader(HTTPHeader.CONTENT_LENGTH, binaryData.length.toString());
                    element.setRequestHeader(HTTPHeader.CONNECTION, 'close');
                    element.send(binaryData);
                } else {
                    element.send();
                }

            }
        }
        
        /**
         *  The handler for HTTP_STATUS and/or HTTP_RESPONSE_STATUS events
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */        
        COMPILE::SWF
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
         *  The handler for the IO_ERROR event.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */  
        COMPILE::SWF
		protected function ioErrorHandler(event:IOErrorEvent):void
		{
			dispatchEvent(new Event(event.type));
		}
		
        /**
         *  The handler for the COMPLETE event.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */        
        COMPILE::SWF
        protected function completeHandler(event:flash.events.Event):void
        {
            dispatchEvent(new Event(event.type));
        }
        
        /**
         * @royaleignorecoercion XMLHttpRequest
         */
        COMPILE::JS
        protected function progressHandler():void
        {
            var element:XMLHttpRequest = this.element as XMLHttpRequest;
            if (element.readyState == 2) {
                _status = element.status;
                dispatchEvent(HTTPConstants.RESPONSE_STATUS);
                dispatchEvent(HTTPConstants.STATUS);
            } else if (element.readyState == 4) {
                dispatchEvent(HTTPConstants.COMPLETE);
            }
        }
        
        /**
         *  Sometimes, after the upload, the server returns useful
         *  information which will be available after the COMPLETE event.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion XMLHttpRequest
         */        
        public function get data():*
        {
            COMPILE::SWF
            {
                return urlLoader.data;                    
            }
            COMPILE::JS
            {
                return (element as XMLHttpRequest).responseText;
            }
        }
    }
}
