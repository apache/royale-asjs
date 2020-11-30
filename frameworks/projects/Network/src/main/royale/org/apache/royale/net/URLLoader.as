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
        import flash.events.ProgressEvent;
        import flash.net.URLLoader;
        import flash.net.URLRequest;
        import flash.net.URLRequestHeader;
    }
    COMPILE::JS
    {
        import window.ProgressEvent;
    }

    import org.apache.royale.events.ValueEvent;
    import org.apache.royale.events.Event;
    import org.apache.royale.events.ProgressEvent;


    /**
     *  Dispatched when the response is progressively loading.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="progress", type="org.apache.royale.events.ProgressEvent")]


    /**
     *  Dispatched when the http status is determined.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    [Event(name="httpStatus", type="org.apache.royale.events.ValueEvent")]

	/**
	 *  The URLLoader class is a relatively low-level class designed to get
	 *  data over HTTP.
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
            bytesLoaded = 0;
            bytesTotal = 0;
            // copied from HTTPService            
            COMPILE::SWF
            {
                if (!urlLoader) {
                    urlLoader = new flash.net.URLLoader();
                    urlLoader.addEventListener(flash.events.Event.COMPLETE, completeHandler);
                    urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                    if (HTTPStatusEvent.HTTP_RESPONSE_STATUS) // only on AIR
                        urlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, statusHandler);
                    urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, statusHandler);
                    urlLoader.addEventListener(flash.events.ProgressEvent.PROGRESS, swfLoadProgressHandler);
                }

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

                var req:flash.net.URLRequest = new flash.net.URLRequest();
                req.url = request.url;
                req.data = request.data;
                req.method = request.method;
                req.contentType = request.contentType;
                var n:int = request.requestHeaders.length;
                for (var i:int; i < n; i++)
                {
                    var hdr:flash.net.URLRequestHeader = 
                            new flash.net.URLRequestHeader(request.requestHeaders[i].name, request.requestHeaders[i].value);
                    req.requestHeaders.push(hdr);
                }
                urlLoader.load(req);
            }
            COMPILE::JS
            {
                var element:XMLHttpRequest = this.element as XMLHttpRequest;
                if (!element.onreadystatechange){
                    element.onreadystatechange = progressHandler;
                    var commonHandler:Function = jsEventHandler;
                    element.onprogress = commonHandler;
                    element.onloadstart = commonHandler;
                    element.onloadend = commonHandler;
                    element.onload = commonHandler;
                }

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
                var requestHeaders:Array = request.requestHeaders;
                if (requestHeaders) {
                    var n:int = requestHeaders.length;
                    for (var i:int = 0; i < n; i++) {
                        var header:HTTPHeader = requestHeaders[i];
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
            if (event.type == HTTPStatusEvent.HTTP_STATUS){
                dispatchEvent( new ValueEvent(HTTPConstants.STATUS, event.status) );
            } else {
                dispatchEvent(new Event(event.type))
            }
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
                //otherwise wait for 'load' event to dispatch 'complete' so that bytesLoaded and bytesTotal are accurate
                /*else
                {
                    dispatchEvent(HTTPConstants.COMPLETE);
                }*/
            }
        }

        COMPILE::JS
        protected function jsEventHandler(e:window.ProgressEvent):void{
            if (e.loaded) {
                //there is some quantity of loaded bytes, but bytesTotal may be unknown (e.lengthComputable)
                bytesLoaded = e.loaded;
                bytesTotal = e.lengthComputable ? e.total : 0;
                //avoid instantiation and dispatch unless we are being listened to
                if (e.type=='progress' && hasEventListener(org.apache.royale.events.ProgressEvent.PROGRESS))
                    dispatchEvent(new org.apache.royale.events.ProgressEvent(org.apache.royale.events.ProgressEvent.PROGRESS,false,false,bytesLoaded,bytesTotal ));
                if (e.type == 'load') {
                    if (!e.lengthComputable) {
                        bytesTotal = bytesLoaded;
                    }
                    dispatchEvent(HTTPConstants.COMPLETE);
                }
            } else {
                bytesLoaded = 0;
                bytesTotal = 0;
            }
        }

        COMPILE::SWF
        protected function swfLoadProgressHandler(e:flash.events.ProgressEvent):void{
            bytesTotal = e.bytesTotal;
            bytesLoaded = e.bytesLoaded;
            //avoid instantiation and dispatch unless we are being listened to
            if (hasEventListener(org.apache.royale.events.ProgressEvent.PROGRESS))
                dispatchEvent(new org.apache.royale.events.ProgressEvent(org.apache.royale.events.ProgressEvent.PROGRESS,false,false,bytesLoaded,bytesTotal ))
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

