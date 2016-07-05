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
package org.apache.flex.net.url
{   
    
    
    
    import org.apache.flex.events.Event;
    import org.apache.flex.events.EventDispatcher;
    import org.apache.flex.events.ProgressEvent;
    import org.apache.flex.net.HTTPConstants;
    import org.apache.flex.net.HTTPUtils;
    import org.apache.flex.utils.BinaryData;

    COMPILE::SWF
    {
        import flash.net.URLRequestHeader;
        import flash.events.IOErrorEvent;
        import flash.net.URLVariables;
        import flash.events.Event;
        import flash.events.ProgressEvent;
        import flash.net.URLRequest;
        import flash.net.URLStream;
        import flash.utils.ByteArray;
    }
        
    
    
    public class URLStream extends EventDispatcher
    {
        COMPILE::JS 
        {
            private var xhr:XMLHttpRequest;
        }
            
        COMPILE::SWF
        {
            private var flashUrlStream:flash.net.URLStream
        }
            
        public function URLStream()
        {
            super();
        }
        
        public function get response():BinaryData
        {
            COMPILE::JS
                {
                    return new BinaryData(xhr.response as ArrayBuffer);
                }
                COMPILE::SWF
                {
                    var ba:ByteArray = new ByteArray();
                    flashUrlStream.readBytes(ba);
                    return new BinaryData(ba);
                }
        }

        public function load(urlRequest:org.apache.flex.net.url.URLRequest):void
        {
            COMPILE::JS {
                xhr = new XMLHttpRequest();
                xhr.open("POST", urlRequest.url);
                xhr.responseType = "arraybuffer";
                xhr.addEventListener("readystatechange", xhr_onreadystatechange,false);
                xhr.addEventListener("progress", xhr_progress, false);
                xhr.setRequestHeader("Content-type", urlRequest.contentType);
                xhr.send(HTTPUtils.encodeUrlVariables(urlRequest.data));
            }
            COMPILE::SWF 
            {
                flashUrlStream = new flash.net.URLStream();
                var req:flash.net.URLRequest = new flash.net.URLRequest(urlRequest.url);
                var hdr:URLRequestHeader = new URLRequestHeader("Content-type", urlRequest.contentType);
                req.requestHeaders.push(hdr);
                req.data = new flash.net.URLVariables(HTTPUtils.encodeUrlVariables(urlRequest.data));
                req.method = HTTPConstants.POST;
                flashUrlStream.addEventListener(flash.events.ProgressEvent.PROGRESS, flash_progress);
                flashUrlStream.addEventListener(flash.events.Event.COMPLETE, flash_complete);
                flashUrlStream.addEventListener(IOErrorEvent.IO_ERROR, flash_onIoError);
                flashUrlStream.load(req);
            }
        }
        
        COMPILE::SWF 
        protected function flash_onIoError(event:IOErrorEvent):void
        {
            trace("io error: " + event.text);
        }            
            
        COMPILE::SWF
        protected function flash_complete(event:flash.events.Event):void
        {
            dispatchEvent(new org.apache.flex.events.Event(HTTPConstants.COMPLETE));
        }
        COMPILE::SWF
        protected function flash_progress(event:flash.events.ProgressEvent):void
        {
            var progressEvent:org.apache.flex.events.ProgressEvent = new org.apache.flex.events.ProgressEvent(org.apache.flex.events.ProgressEvent.PROGRESS);
            progressEvent.current = event.bytesLoaded;
            progressEvent.total = event.bytesTotal;
            dispatchEvent(progressEvent);
        }
        
        
        private function xhr_progress(e:Object):void 
        {
            dispatchEvent(new org.apache.flex.events.ProgressEvent(org.apache.flex.events.ProgressEvent.PROGRESS, false, false, e.loaded, e.total));
        }
        
        COMPILE::JS
        private function xhr_onreadystatechange(e:*):void
        {
            if (xhr.readyState == 4 && xhr.status == 200)
            {
                dispatchEvent(new org.apache.flex.events.Event(HTTPConstants.COMPLETE));
            }else if (xhr.readyState==4&&xhr.status==404){
                //                    dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
            }
        }

        public function close():void
        {
            COMPILE::SWF
            {
                flashUrlStream.close();
            }
            COMPILE::JS
            {
                xhr.abort();
            }

            //TODO send an event that it's been aborted
        }
        public var onComplete:Function;
        public var onError:Function;
    }
}

