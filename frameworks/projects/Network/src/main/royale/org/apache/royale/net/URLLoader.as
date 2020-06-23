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
        import org.apache.royale.events.ValueEvent;
    }
    
    import org.apache.royale.events.DetailEvent;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.ProgressEvent;
    import org.apache.royale.utils.BinaryData;
    import org.apache.royale.utils.Endian;


	/**
	 *  The URLBinaryLoader class is a relatively low-level class designed to get
	 *  binary data over HTTP the intent is to create similar classes for text and URL vars.
     *  If you need to use Binary requests (including POST), use URLBinaryLoader.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.7.0
	 */
    public class URLLoader extends URLLoaderBase
    {
        COMPILE::JS
        private static var _corsCredentialsChecker:Function;
        COMPILE::JS
        /**
         * Intended as global configuration of CORS withCredentials setting on requests
         * This method is not reflectable, is js-only and is eliminated via dead-code-elimination
         * in js-release builds if it is never used.
         * URLLoader is used a service base in other service classes, so this provides
         * a 'low level' solution for a bead that can work at application level.
         * The 'checker' function parameter should be a function that takes a url as its single argument
         * and returns true or false depending on whether 'withCredentials' should be set for
         * that http request. Set it to null to always be false.
         * @private
         * @royalesuppressexport
         */
        public static function setCORSCredentialsChecker(checker:Function):void{
            _corsCredentialsChecker = checker;
        }
        
        
		/**
		 *  The number of bytes loaded so far.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
         * 
         *  @royalesuppresspublicvarwarning
		 */        
        public var bytesLoaded:uint = 0;
        
		/**
		 *  The total number of bytes (if available).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
         * 
         *  @royalesuppresspublicvarwarning
		 */        
        public var bytesTotal:uint = 0;
        
        COMPILE::JS
        private var element:XMLHttpRequest;
        
        public function URLLoader(request:org.apache.royale.net.URLRequest = null)
        {
            super();
            COMPILE::JS
            {
                element = new XMLHttpRequest();
            }
            if (request) load(request);
        }
        
        COMPILE::SWF
        private var urlLoader:flash.net.URLLoader;
        
        /**
         *  Makes the URL request.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.7.0
         */        
        public function load(request:org.apache.royale.net.URLRequest):void
        {
            // copied from HTTPService            
            COMPILE::SWF
            {
                if (!urlLoader)
                    urlLoader = new flash.net.URLLoader();
                /*
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
                if (method != HTTPConstants.GET && !sawContentType && contentData != null)
                {
                    urlHeader = new flash.net.URLRequestHeader(HTTPHeader.CONTENT_TYPE, contentType);
                    request.requestHeaders.push(urlHeader);
                }
                if (contentData)
                {
                    if (method == HTTPConstants.GET)
                    {
                        if (url.indexOf("?") != -1)
                            url += contentData;
                        else
                            url += "?" + contentData;
                    }
                    else
                        request.data = contentData;
                }
                */
                urlLoader.addEventListener(flash.events.Event.COMPLETE, completeHandler);
                urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                if (HTTPStatusEvent.HTTP_RESPONSE_STATUS) // only on AIR
                    urlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, statusHandler);
                urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, statusHandler);
                var req:flash.net.URLRequest = new flash.net.URLRequest();
                req.url = request.url;
                req.data = request.data;
                req.method = request.method;
                req.contentType = request.contentType;
                var n:int = request.requestHeaders.length;
                for (var i:int; i < n; i++)
                {
                    var hdr:flash.net.URLRequestHeader = 
                            new flash.net.URLRequestHeader(req[i].name, req[i].value);
                    req.requestHeaders.push(hdr);
                }
                urlLoader.load(req);
            }
            COMPILE::JS
            {
                var element:XMLHttpRequest = this.element as XMLHttpRequest;
                element.onreadystatechange = progressHandler;
                
                var url:String = request.url;
                
                /*                
                var contentData:String = null;
                if (_contentData != null) {
                    if (_method == HTTPConstants.GET) {
                        if (url.indexOf('?') != -1) {
                            url += _contentData;
                        } else {
                            url += '?' + _contentData;
                        }
                    } else {
                        contentData = _contentData;
                    }
                }
                */
				
				var contentData:String = null;
				if(request.data != null) {
					if(request.method == HTTPConstants.POST) {
						contentData = request.data as String;
					}
				}
                
                element.open(request.method, request.url, true);
                // element.timeout = _timeout;
                
                var sawContentType:Boolean = false;
                if (request.requestHeaders) {
                    var n:int = request.requestHeaders.length;
                    for (var i:int = 0; i < n; i++) {
                        var header:HTTPHeader = request.requestHeaders[i];
                        if (header.name == HTTPHeader.CONTENT_TYPE) {
                            sawContentType = true;
                        }
                        
                        element.setRequestHeader(header.name, header.value);
                    }
                }

                if (request.contentType && request.method != HTTPConstants.GET &&
                    !sawContentType && contentData) {
                    element.setRequestHeader(
                        HTTPHeader.CONTENT_TYPE, request.contentType);
                }

                if (_corsCredentialsChecker != null) {
                    element.withCredentials = _corsCredentialsChecker(url);
                }
                
                if (contentData) {
                    element.send(contentData);
                } else {
                    element.send();
                }
            }
            
            dispatchEvent(new Event("postSend"));
        }

        /**
         *  @copy org.apache.royale.net.BinaryUploader#statusHandler()
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        COMPILE::SWF
        protected function statusHandler(event:HTTPStatusEvent):void
        {
            /*
            _status = event.status;
            if ("responseHeaders" in event)
                _responseHeaders = event.responseHeaders;
            if ("responseURL" in event)
                _responseURL = event.responseURL;
            */
            dispatchEvent(new Event(event.type));
        }
        
        /**
         *  @copy org.apache.royale.net.BinaryUploader#ioErrorHandler()
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
         *  @copy org.apache.royale.net.BinaryUploader#completeHandler()
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
                dispatchEvent(HTTPConstants.RESPONSE_STATUS);
                dispatchEvent( new ValueEvent(HTTPConstants.STATUS, element.status) );
            } else if (element.readyState == 4) {
                if (element.status >= 400) // client error or server error
                {
                    dispatchEvent(HTTPConstants.IO_ERROR);
                }
                else
                {
                    dispatchEvent(HTTPConstants.COMPLETE);
                }
            }
        }
        
        /**
         *  The text returned from the server.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion XMLHttpRequest
         */
        public function get data():String
        {
            COMPILE::SWF
            {
                return urlLoader.data;                    
            }
            COMPILE::JS
            {
                return element.responseText;
            }
        }


        public function close():void{
            COMPILE::SWF{
                urlLoader.close();
            }
            COMPILE::JS{
                if (element.readyState ==0 || element.readyState ==4) {
                    throw new Error('Error #2029: This URLStream object does not have a stream opened.');
                }
                element.abort();
            }
        }
        
    }
}

