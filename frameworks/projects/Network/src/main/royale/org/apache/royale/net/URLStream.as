////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//	  http://www.apache.org/licenses/LICENSE-2.0
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
	import org.apache.royale.events.DetailEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.ProgressEvent;
	import org.apache.royale.utils.BinaryData;
	import org.apache.royale.utils.Endian;

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
	
	/**
	 * The URLStream class deals with the underlying platform-specifc architecture for HTTP Requests
	 * It makes the request and stores the response, dispatching events.
     * 
     *  @royalesuppresspublicvarwarning
	 */
	public class URLStream extends EventDispatcher
	{
		COMPILE::JS 
		{
			protected var xhr:XMLHttpRequest;
		}
			
		COMPILE::SWF
		{
			private var flashUrlStream:flash.net.URLStream
		}
		
		/**
		 * constructor
		 */
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
		 *  @productversion Royale 0.7.0
		 */		
		public var bytesLoaded:uint = 0;
		
		/**
		 *  The total number of bytes (if avaailable).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public var bytesTotal:uint = 0;

		/**
		 * The BinaryData reponse received from the request. This can be a response or an error response.
		 * The client should check the status to know how to interpret the response.
		 */
		public function get response():BinaryData
		{
			COMPILE::JS
			{
					return new BinaryData(xhr.response);
			}
			COMPILE::SWF
			{
				var ba:ByteArray = new ByteArray();
				flashUrlStream.readBytes(ba);
				return new BinaryData(ba);
			}
		}

		/**
		 * loads the request
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 *  @royaleignorecoercion org.apache.royale.utils.BinaryData
		 */
		public function load(urlRequest:org.apache.royale.net.URLRequest):void
		{
			COMPILE::JS {
				requestStatus = 0;
				createXmlHttpRequest();

				xhr.open(urlRequest.method, urlRequest.url);
				xhr.responseType = "arraybuffer";
				xhr.addEventListener("readystatechange", xhr_onreadystatechange,false);
				xhr.addEventListener("progress", xhr_progress, false);
				var contentTypeSet:Boolean = false;
				for (var i:int = 0; i < urlRequest.requestHeaders.length; i++)
				{
					var header:org.apache.royale.net.URLRequestHeader = urlRequest.requestHeaders[i];
					if (header.name.toLowerCase() == "content-type")
					{
						contentTypeSet = true;
					}
					xhr.setRequestHeader(header.name, header.value);
				}
				if (!contentTypeSet && urlRequest.contentType)
				{
					xhr.setRequestHeader("Content-type", urlRequest.contentType);
				}
				var requestData:Object = urlRequest.data is BinaryData ? (urlRequest.data as BinaryData).data : 
					urlRequest.data is FormData ? urlRequest.data :
					HTTPUtils.encodeUrlVariables(urlRequest.data);
				send(requestData);
			}
			COMPILE::SWF 
			{
				flashUrlStream = new flash.net.URLStream();
				var req:flash.net.URLRequest = new flash.net.URLRequest(urlRequest.url);
				var contentSet:Boolean = false;
				for each (var requestHeader:org.apache.royale.net.URLRequestHeader in urlRequest.requestHeaders)
				{
					if(requestHeader.name.toLowerCase() == HTTPHeader.CONTENT_TYPE.toLowerCase())
					{							 	
						contentSet = true;
						req.contentType = requestHeader.value;
					}
					req.requestHeaders.push(requestHeader)
				}
				if(!contentSet)
				{
					req.requestHeaders.push(new flash.net.URLRequestHeader(HTTPHeader.CONTENT_TYPE, urlRequest.contentType));
					
				}
				if (urlRequest.data)
				{
					req.data = urlRequest.data is BinaryData ? (urlRequest.data as BinaryData).data : 
						new flash.net.URLVariables(HTTPUtils.encodeUrlVariables(urlRequest.data));
				}
			   
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

		COMPILE::JS
		protected function createXmlHttpRequest():void
		{
			xhr = new XMLHttpRequest();
		}

		/**
		 * send is a protected function in js so a subclass can attach an upload listener
		 * without rewriting the whole load() function
		 */
		COMPILE::JS
		protected function send(requestData:Object):void
		{
			xhr.send(requestData);
		}

		/**
		 *  HTTP status changed (Flash only).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		COMPILE::SWF
		private function flash_status(event:HTTPStatusEvent):void
		{
			setStatus(event.status);
		}

		/**
		 *  IO error occurred (Flash only).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
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

		/**
		 *  Security error occurred (Flash only).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		COMPILE::SWF
		private function flash_onSecurityError(event:flash.events.Event):void
		{
			dispatchEvent(new DetailEvent(HTTPConstants.COMMUNICATION_ERROR,false,false,HTTPConstants.SECURITY_ERROR));
			if(onError)
				onError(this);
			cleanupCallbacks();
		}

		/**
		 *  Upload complete (Flash only).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		COMPILE::SWF
		protected function flash_complete(event:flash.events.Event):void
		{
			dispatchEvent(new org.apache.royale.events.Event(HTTPConstants.COMPLETE));
			if(onComplete)
				onComplete(this);
			cleanupCallbacks();
		}

		/**
		 *  Download is progressing (Flash only).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		COMPILE::SWF
		protected function flash_progress(event:flash.events.ProgressEvent):void
		{
			var progEv:org.apache.royale.events.ProgressEvent = new org.apache.royale.events.ProgressEvent(org.apache.royale.events.ProgressEvent.PROGRESS);
			
			progEv.current = bytesLoaded = event.bytesLoaded;
			progEv.total = bytesTotal = event.bytesTotal;
			dispatchEvent(progEv);
			if(onProgress)
				onProgress(this);
		}

		/**
		 *  Download is progressing (JS only).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		COMPILE::JS
		private function xhr_progress(error:Object):void
		{
			var progEv:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			progEv.current = bytesLoaded = error.loaded;
			progEv.total = bytesTotal = error.total;
			
			dispatchEvent(progEv);
			if(onProgress)
				onProgress(this);
		}

		/**
		 *  HTTP status change (JS only).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		COMPILE::JS
		private function xhr_onreadystatechange(error:*):void
		{
			setStatus(xhr.status);
			//we only need to deal with the status when it's done.
			if(xhr.readyState != 4)
				return;
			if(xhr.status == 0)
			{
				//Error. We don't know if there's a network error or a CORS error so there's no detail
				dispatchEvent(new DetailEvent("communicationError"));
				if(onError)
					onError(this);
			}
			else if(xhr.status < 200)
			{
				dispatchEvent(new DetailEvent("communicationError",false,false,""+requestStatus));
				if(onError)
					onError(this);
			}
			else if(xhr.status < 300)
			{
				dispatchEvent(new org.apache.royale.events.Event("complete"));
				if(onComplete)
					onComplete(this);
				
			}
			else
			{
				dispatchEvent(new DetailEvent("communicationError",false,false,""+requestStatus));
				if(onError)
					onError(this);
			}
			cleanupCallbacks();
		}

		/**
		 *  Set the HTTP request status.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		private function setStatus(value:int):void
		{
			if(value != requestStatus)
			{
				requestStatus = value;
				dispatchEvent(new DetailEvent("httpStatus",false,false,""+value));
				if(onStatus)
					onStatus(this);
			}
		}

		/**
		 *  Abort an connection.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
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
		 *  @productversion Royale 0.7.0
		 */		
		public var requestStatus:int = 0;

		/**
		 *  Indicates the byte order for the data.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public var endian:String = Endian.BIG_ENDIAN;

		/**
		 *  Cleanup all callbacks.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		protected function cleanupCallbacks():void
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
		 *  @productversion Royale 0.7.0
		 */		
		public var onComplete:Function;
		
		/**
		 *  Callback for error event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public var onError:Function;
		
		/**
		 *  Callback for progress event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public var onProgress:Function;

		/**
		 *  Callback for status event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public var onStatus:Function;

		/**
		 *  Convenience function for complete event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public function complete(callback:Function):org.apache.royale.net.URLStream
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
		 *  @productversion Royale 0.7.0
		 */		
		public function error(callback:Function):org.apache.royale.net.URLStream
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
		 *  @productversion Royale 0.7.0
		 */		
		public function progress(callback:Function):org.apache.royale.net.URLStream
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
		 *  @productversion Royale 0.7.0
		 */		
		public function status(callback:Function):org.apache.royale.net.URLStream
		{
			onStatus = callback;
			return this;
		}
}
}

