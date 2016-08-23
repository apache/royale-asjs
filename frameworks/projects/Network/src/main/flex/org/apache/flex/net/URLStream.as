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
    import org.apache.flex.events.DetailEvent;
    import org.apache.flex.events.Event;
    import org.apache.flex.events.EventDispatcher;
    import org.apache.flex.events.ProgressEvent;
    import org.apache.flex.utils.BinaryData;
    import org.apache.flex.utils.Endian;

    COMPILE::SWF
    {
		import flash.events.Event;
		import flash.events.HTTPStatusEvent;
        import flash.events.IOErrorEvent;
		import flash.events.ProgressEvent;
		import flash.events.SecurityErrorEvent;
		import flash.net.URLRequest;
		import flash.net.URLRequestHeader;
		import flash.net.URLStream;
        import flash.net.URLVariables;
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
        
		/**
		 *  The number of bytes loaded so far.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */        
		public var bytesLoaded:uint = 0;
		
		/**
		 *  The total number of bytes (if avaailable).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */        
		public var bytesTotal:uint = 0;

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

        public function load(urlRequest:org.apache.flex.net.URLRequest):void
        {
            COMPILE::JS {
            	requestStatus = 0;
                xhr = new XMLHttpRequest();
                xhr.open(urlRequest.method, urlRequest.url);
                xhr.responseType = "arraybuffer";
                xhr.addEventListener("readystatechange", xhr_onreadystatechange,false);
                xhr.addEventListener("progress", xhr_progress, false);
				var contentTypeSet:Boolean = false;
				for (var i:int = 0; i < urlRequest.requestHeaders.length; i++)
				{
					var header:org.apache.flex.net.URLRequestHeader = urlRequest.requestHeaders[i];
					if (header.name.toLowerCase() == "content-type")
					{
						contentTypeSet = true;
					}
					xhr.setRequestHeader(header.name, header.value);
				}
				if (!contentTypeSet)
				{
            		xhr.setRequestHeader("Content-type", urlRequest.contentType);
				}
				var requestData:Object = urlRequest.data is BinaryData ? (urlRequest.data as BinaryData).data : HTTPUtils.encodeUrlVariables(urlRequest.data);
				xhr.send(requestData);
//				xhr.send(HTTPUtils.encodeUrlVariables(urlRequest.data));
            }
            COMPILE::SWF 
            {
                flashUrlStream = new flash.net.URLStream();
                var req:flash.net.URLRequest = new flash.net.URLRequest(urlRequest.url);
				var contentSet:Boolean = false;
				for each (var requestHeader:org.apache.flex.net.URLRequestHeader in urlRequest.requestHeaders)
				{
					if(requestHeader.name.toLowerCase() == "content-type")
					{
						contentSet = true;
						req.contentType = requestHeader.value;
					}
					req.requestHeaders.push(requestHeader)
				}
				if(!contentSet)
				{
					req.requestHeaders.push(new flash.net.URLRequestHeader("Content-type", urlRequest.contentType));
					
				}
                req.data = urlRequest.data is BinaryData ? (urlRequest.data as BinaryData).data : 
					new flash.net.URLVariables(HTTPUtils.encodeUrlVariables(urlRequest.data));
                req.method = urlRequest.method;
				flashUrlStream.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, flash_status);
				flashUrlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS, flash_status);
                flashUrlStream.addEventListener(flash.events.ProgressEvent.PROGRESS, flash_progress);
                flashUrlStream.addEventListener(flash.events.Event.COMPLETE, flash_complete);
                flashUrlStream.addEventListener(IOErrorEvent.IO_ERROR, flash_onIoError);
				flashUrlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, flash_onSecurityError);
                flashUrlStream.load(req);
            }
        }
        COMPILE::SWF
		private function flash_status(ev:HTTPStatusEvent):void
		{
			setStatus(ev.status);
		}
		
        COMPILE::SWF 
        protected function flash_onIoError(event:IOErrorEvent):void
        {
			dispatchEvent(new DetailEvent(HTTPConstants.COMMUNICATION_ERROR,false,false,HTTPConstants.IO_ERROR));
			//Is there useful text?
            //trace("io error: " + event.text);
			if(onError)
				onError(this);
			cleanupCallbacks();
        }
		
		COMPILE::SWF
		private function flash_onSecurityError(ev:flash.events.Event):void
		{
			dispatchEvent(new DetailEvent(HTTPConstants.COMMUNICATION_ERROR,false,false,HTTPConstants.SECURITY_ERROR));
			if(onError)
				onError(this);
			cleanupCallbacks();
		}
            
        COMPILE::SWF
        protected function flash_complete(event:flash.events.Event):void
        {
            dispatchEvent(new org.apache.flex.events.Event(HTTPConstants.COMPLETE));
			if(onComplete)
				onComplete(this);
			cleanupCallbacks();
        }
        COMPILE::SWF
        protected function flash_progress(ev:flash.events.ProgressEvent):void
        {
            var progEv:org.apache.flex.events.ProgressEvent = new org.apache.flex.events.ProgressEvent(org.apache.flex.events.ProgressEvent.PROGRESS);
			
			progEv.current = bytesLoaded = ev.bytesLoaded;
			progEv.total = bytesTotal = ev.bytesTotal;
            dispatchEvent(progEv);
			if(onProgress)
				onProgress(this);
        }
        
        COMPILE::JS
        private function xhr_progress(e:Object):void 
        {
			var progEv:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			progEv.current = bytesLoaded = e.loaded;
			progEv.total = bytesTotal = e.total;
			
            dispatchEvent(progEv);
			if(onProgress)
				onProgress(this);
        }
        
        COMPILE::JS
        private function xhr_onreadystatechange(e:*):void
        {
			setStatus(xhr.status);
			//we only need to deal with the status when it's done.
			if(xhr.readyState != 4)
				return;
			if(xhr.status == 0)
			{
				//Error. We don't know if there's a network error or a CORS error so there's no detail
				dispatchEvent(new DetailEvent(HTTPConstants.COMMUNICATION_ERROR));
				if(onError)
					onError(this);
			}
			else if(xhr.status < 200)
			{
				dispatchEvent(new DetailEvent(HTTPConstants.COMMUNICATION_ERROR,false,false,""+requestStatus));
				if(onError)
					onError(this);
			}
			else if(xhr.status < 300)
			{
				dispatchEvent(new org.apache.flex.events.Event(HTTPConstants.COMPLETE));
				if(onComplete)
					onComplete(this);
				
			}
			else
			{
				dispatchEvent(new DetailEvent(HTTPConstants.COMMUNICATION_ERROR,false,false,""+requestStatus));
				if(onError)
					onError(this);
			}
			cleanupCallbacks();
        }
		
		private function setStatus(value:int):void
		{
			if(value != requestStatus)
			{
				requestStatus = value;
				dispatchEvent(new DetailEvent(HTTPConstants.STATUS,false,false,""+value));
				if(onStatus)
					onStatus(this);
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

			cleanupCallbacks();

        }

		/**
		 *  Indicates the status of the request.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */        
		public var requestStatus:int = 0;

		/**
		 *  Indicates the byte order for the data.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */        
		public var endian:String = Endian.BIG_ENDIAN;

		private function cleanupCallbacks():void
		{
			onComplete = null;
			onError = null;
			onProgress = null;
			onStatus = null;
		}
		/**
		 *  Callback for complete event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */		
        public var onComplete:Function;
		
		/**
		 *  Callback for error event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */		
        public var onError:Function;
		
		/**
		 *  Callback for progress event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */		
		public var onProgress:Function;

		/**
		 *  Callback for status event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */		
		public var onStatus:Function;

		/**
		 *  Convenience function for complete event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */		
		public function complete(callback:Function):org.apache.flex.net.URLStream
		{
			onComplete = callback;
			return this;
		}
		
		/**
		 *  Convenience function for error event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */		
		public function error(callback:Function):org.apache.flex.net.URLStream
		{
			onError = callback;
			return this;
		}

		/**
		 *  Convenience function for progress event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */		
		public function progress(callback:Function):org.apache.flex.net.URLStream
		{
			onProgress = callback;
			return this;
		}
		/**
		 *  Convenience function for status event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */		
		public function status(callback:Function):org.apache.flex.net.URLStream
		{
			onStatus = callback;
			return this;
		}
}
}

