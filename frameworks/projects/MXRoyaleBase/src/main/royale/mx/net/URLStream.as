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
package mx.net
{
	//import mx.utils.ByteArray;



	import org.apache.royale.events.DetailEvent;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;
	import mx.events.ProgressEvent;
	import mx.events.SecurityErrorEvent;
	import mx.events.HTTPStatusEvent;

	import org.apache.royale.net.HTTPConstants;
	import org.apache.royale.net.HTTPHeader;
	import org.apache.royale.net.remoting.amf.AMFBinaryData;
	import org.apache.royale.utils.BinaryData;
	import org.apache.royale.utils.Endian;
	import org.apache.royale.net.utils.encodeAsQueryString;
	import org.apache.royale.utils.IBinaryDataInput;
	import org.apache.royale.utils.net.IDataInput;

	import org.apache.royale.net.URLRequest;
	import org.apache.royale.net.URLRequestHeader;

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
	public class URLStream extends EventDispatcher implements /*IBinaryDataInput*/IDataInput
	{


		COMPILE::JS
		private static var _corsCredentialsChecker:Function;
		COMPILE::JS
		/**
		 * Intended as global configuration of CORS withCredentials setting on requests
		 * This method is not reflectable, is js-only and is eliminated via dead-code-elimination
		 * in js-release builds if it is never used.
		 * URLStream is used a service base in other service classes, so this provides
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
			
		COMPILE::SWF
		{
			private var streamImpl:flash.net.URLStream = new flash.net.URLStream();
		}

		COMPILE::JS
		{
			private var streamImpl:AMFBinaryData = new AMFBinaryData();
		}
		
		/**
		 * constructor
		 */
		public function URLStream()
		{
			super();
		}

		private var _init:Boolean;


		COMPILE::JS
		private var _connected:Boolean;

		public function get connected():Boolean{
			COMPILE::SWF{
				return streamImpl.connected;
			}
			COMPILE::JS{
				return _connected;
			}
		}


		public function get objectEncoding():uint{
			return streamImpl.objectEncoding
		}
		public function set objectEncoding(value:uint):void{
			streamImpl.objectEncoding = value;
		}

		
		/**
		 *  The number of bytes loaded so far.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
	//	public var bytesLoaded:uint = 0;
		
		/**
		 *  The total number of bytes (if avaailable).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
	//	public var bytesTotal:uint = 0;

		/**
		 * The BinaryData reponse received from the request. This can be a response or an error response.
		 * The client should check the status to know how to interpret the response.
		 */
		/*public function get response():BinaryData
		{
			COMPILE::JS
			{
					return new BinaryData(xhr.response);
			}
			COMPILE::SWF
			{
				var ba:ByteArray = new ByteArray();
				streamImpl.readBytes(ba);
				return new BinaryData(ba);
			}
		}*/

		COMPILE::JS
		private var _req:Object /* js native Request object */;

		COMPILE::JS
		private var _aborter:Object /* js native AbortController object */

		COMPILE::JS
		private var _bytesTotal:uint;

		COMPILE::JS
		private var _activeReader:Object

		/**
		 *
		 * @royaleignorecoercion Uint8Array
		 * @royaleignorecoercion Promise
		 */
		COMPILE::JS
		private function handleChunk(streamChunk:Object):Promise{
			var done:Boolean = streamChunk['done'];
			var reader:Object= _activeReader;
			if (done) {
				_aborter = null;
				_connected = false;
				_activeReader = null
				dispatchComplete();
				return null;
			} else {
				var value:Uint8Array = streamChunk['value'] as Uint8Array;

				var l:uint = value.length;
				_bytesTotal += l;
				var base:uint = streamImpl.length;
				var pos:uint = streamImpl.position;
				streamImpl.length = base + l;
				streamImpl.position = base;
				streamImpl.writeBytes(value.buffer)
				streamImpl.position = pos;
			//	console.log('chunk ',l, value, streamImpl);
				console.log('processing chunk',l);
				dispatchProgress(value.length, value.length);
				return (reader.read() as Promise).then(handleChunk) as Promise
				//return Promise(_activeReader.read()).then(handleChunk);
			}
		}

		/**
		 * loads the request
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 *  @royaleignorecoercion org.apache.royale.utils.BinaryData
		 *  @royaleignorecoercion Promise
		 */
		public function load(urlRequest:org.apache.royale.net.URLRequest):void
		{
			COMPILE::JS {

			//	requestStatus = 0;
				var headers:Object = jsUnsafeNativeInline("new Headers()");
				if (!_aborter) {
					_aborter = jsUnsafeNativeInline("new AbortController()");
				}
				var reqParams:Object = {
					'method':urlRequest.method,
					'headers':headers,
					/* setting explicit default here for now*/
					'mode': 'cors',
					/* might need to set default for credentials here*/
					'credentials' : 'same-origin',
					'signal' : _aborter.signal
				};
				/*createXmlHttpRequest();
				if (_corsCredentialsChecker != null) {
					xhr.withCredentials = _corsCredentialsChecker( urlRequest.url);
				}*/

				//xhr.open(urlRequest.method, urlRequest.url);
				/*xhr.responseType = "arraybuffer";
				xhr.addEventListener("readystatechange", xhr_onreadystatechange,false);
				xhr.addEventListener("progress", xhr_progress, false);*/
				var contentType:String;
				for (var i:int = 0; i < urlRequest.requestHeaders.length; i++)
				{
					var header:org.apache.royale.net.URLRequestHeader = urlRequest.requestHeaders[i];
					if (header.name.toLowerCase() == "content-type")
					{
						contentType = header.value;
					}
					//xhr.setRequestHeader(header.name, header.value);
					headers.set(header.name, header.value)
				}
				if (!contentType && urlRequest.contentType)
				{
					contentType = urlRequest.contentType;
					//xhr.setRequestHeader("Content-type", urlRequest.contentType);
					headers.set("Content-type", urlRequest.contentType)
				}
				var requestData:Object;
				// For BinaryData, we're assuming the request is a binary one.
				if(urlRequest.data is BinaryData){
					requestData = (urlRequest.data as BinaryData).data;
				} else if(contentType == HTTPHeader.APPLICATION_JSON){
					// For JSON content type, we send either the string, stringified or nothing.
					if(urlRequest.data is String){
						requestData = urlRequest.data;
					} else if(urlRequest.data){
						requestData = JSON.stringify(urlRequest.data);
					} else {
						requestData = "";
					}
				} else if(urlRequest.data is FormData){
					// FormData is supposed to be able to be passed into xhr
					requestData = urlRequest.data;
				}
				// At this point it shouldn't matter what the content type is. If it's a string, just pass that.
				// Otherwise the only reasonable thing to assume is it's application/x-www-form-urlencoded
				else if(urlRequest.data is String){
					requestData = urlRequest.data;
				} else {
					requestData = encodeAsQueryString(urlRequest.data);
				}

				//send(requestData);

				if (requestData) {
					reqParams['body'] = requestData;
				}
				var req:Object = jsUnsafeNativeInline("new Request(urlRequest.url, reqParams)");
				_req = req;
				//jsUnsafeNativeInline()
				streamImpl.length = 0;
				(jsUnsafeNativeInline("fetch(req)") as Promise)
						.then(
							function (response:Object):Promise{
								console.log('fetch response ',response);
								if ('status' in response) {
									/*var status:uint = response['status'];*/
									dispatchHTTPStatus(response['status']);
									if (!response['ok']) {
										_connected = false;
										//dispatchIOErr(response['statusText'])
										throw response['statusText'];
									} else {

										_bytesTotal=0;
										var reader:Object= _activeReader = response.body.getReader(); /* ReadableStreamDefaultReader */

										return reader.read() as Promise;
									}
								} else {
									//assume an error
									_aborter.abort('unknown');
									//_connected = false;

									//dispatchIOErr(response['statusText'])
								}

								return null;
							}
						).then(
							function(chunk:Object):Promise{
								return handleChunk(chunk);
							}
						)
						.catch(
							function(err:Object):void{
								//console.log('fetch err ',err);
								_connected = false;
								if (err == 'close' || err.name == "AbortError") {
									dispatchComplete();
								} else {
									//@todo investigate further:
									dispatchIOErr(err+'');
								}
							}
						)
				_connected = true;
			}
			COMPILE::SWF 
			{

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
						new flash.net.URLVariables(encodeAsQueryString(urlRequest.data));
				}
			   
				req.method = urlRequest.method;
				if (!_init) {
					_init = true;
					streamImpl.addEventListener(flash.events.HTTPStatusEvent.HTTP_RESPONSE_STATUS, flash_status);
					streamImpl.addEventListener(flash.events.HTTPStatusEvent.HTTP_STATUS, flash_status);
					streamImpl.addEventListener(flash.events.ProgressEvent.PROGRESS, flash_progress);
					streamImpl.addEventListener(flash.events.Event.COMPLETE, flash_complete);
					streamImpl.addEventListener(flash.events.IOErrorEvent.IO_ERROR, flash_onIoError);
					streamImpl.addEventListener(flash.events.SecurityErrorEvent.SECURITY_ERROR, flash_onSecurityError);
					streamImpl.addEventListener(flash.events.Event.OPEN,flash_open)
				}

				streamImpl.load(req);
			}
		}

		/*COMPILE::JS
		protected function createXmlHttpRequest():void
		{
			xhr = new XMLHttpRequest();
		}*/

		/**
		 * send is a protected function in js so a subclass can attach an upload listener
		 * without rewriting the whole load() function
		 */
		/*COMPILE::JS
		protected function send(requestData:Object):void
		{
			//xhr.send(requestData);

		}*/

		/**
		 *  HTTP status changed (Flash only).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		COMPILE::SWF
		private function flash_status(event:flash.events.HTTPStatusEvent):void
		{
			dispatchHTTPStatus(event.status);
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
		protected function flash_onIoError(event:flash.events.IOErrorEvent):void
		{
			dispatchIOErr(event.text)
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
		private function flash_onSecurityError(event:flash.events.SecurityErrorEvent):void
		{
			//dispatchEvent(new DetailEvent(HTTPConstants.COMMUNICATION_ERROR,false,false,HTTPConstants.SECURITY_ERROR));
			dispatchSecurityErr(event.text)
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
		private function flash_open(event:flash.events.Event):void
		{
			dispatchOpen();
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
		private function flash_complete(event:flash.events.Event):void
		{
			dispatchComplete()
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
			dispatchProgress(event.bytesLoaded, event.bytesTotal)
		}

		/**
		 *  Download is progressing (JS only).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		/*COMPILE::JS
		private function js_progress(error:Object):void
		{
			/!*var progEv:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			progEv.current = bytesLoaded = error.loaded;
			progEv.total = bytesTotal = error.total;
			
			dispatchEvent(progEv);
			if(onProgress)
				onProgress(this);*!/
		}*/

		/**
		 *  HTTP status change (JS only).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		/*COMPILE::JS
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
		}*/

		/**
		 *  Set the HTTP request status.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		private function dispatchHTTPStatus(value:int):void
		{
			/*if(value != requestStatus)
			{
				requestStatus = value;*/
				dispatchEvent(new mx.events.HTTPStatusEvent(mx.events.HTTPStatusEvent.HTTP_STATUS,false,false,value));
			//}
		}


		//local events implementation


		private function dispatchOpen():void{
			dispatchEvent(new org.apache.royale.events.Event(HTTPConstants.OPEN));
		}

		private function dispatchSecurityErr(detail:String):void{
			var errEvt:mx.events.SecurityErrorEvent = new mx.events.SecurityErrorEvent(mx.events.SecurityErrorEvent.SECURITY_ERROR,false, false, detail);
			dispatchEvent(errEvt);
		}

		private function dispatchIOErr(detail:String):void{
			var errEvt:mx.events.IOErrorEvent = new mx.events.IOErrorEvent(mx.events.IOErrorEvent.IO_ERROR,false, false, detail);
			dispatchEvent(errEvt);
		}

		private function dispatchProgress(loaded:uint, total:uint):void{
			var progEv:mx.events.ProgressEvent = new mx.events.ProgressEvent(mx.events.ProgressEvent.PROGRESS);
			progEv.current = loaded;
			progEv.total = total;
			dispatchEvent(progEv);
		}

		private function dispatchComplete():void{
			dispatchEvent(new org.apache.royale.events.Event(HTTPConstants.COMPLETE));
		}
		/**
		 *  Abort a connection.
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
				streamImpl.close();
			}
			COMPILE::JS
			{
				//xhr.abort();
				if (_aborter) {
					//trace('close calling abort')
					//explicitly set close now, because promise rejection will be async
					_connected = false;
					//this will trigger promise rejection
					_aborter.abort('close');
				} else {
					trace('error condition? closing when not connected or pending')
				}
			}

			//TODO send an event that it's been aborted

			//cleanupCallbacks();

		}

		/**
		 *  Indicates the status of the request.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
	//	public var requestStatus:int = 0;
		

		/**
		 *  Cleanup all callbacks.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		/*protected function cleanupCallbacks():void
		{
			onComplete = null;
			onError = null;
			onProgress = null;
			onStatus = null;
		}

		/!**
		 *  Callback for complete event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 *!/
		public var onComplete:Function;
		
		/!**
		 *  Callback for error event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 *!/
		public var onError:Function;
		
		/!**
		 *  Callback for progress event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 *!/
		public var onProgress:Function;

		/!**
		 *  Callback for status event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 *!/
		public var onStatus:Function;

		/!**
		 *  Convenience function for complete event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 *!/
		public function complete(callback:Function):org.apache.royale.net.URLStream
		{
			onComplete = callback;
			return this;
		}
		
		/!**
		 *  Convenience function for error event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 *!/
		public function error(callback:Function):org.apache.royale.net.URLStream
		{
			onError = callback;
			return this;
		}

		/!**
		 *  Convenience function for progress event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 *!/
		public function progress(callback:Function):org.apache.royale.net.URLStream
		{
			onProgress = callback;
			return this;
		}
		/!**
		 *  Convenience function for status event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 *!/
		public function status(callback:Function):org.apache.royale.net.URLStream
		{
			onStatus = callback;
			return this;
		}*/

		public function readBinaryData(bytes:BinaryData, offset:uint = 0, length:uint = 0):void {
			COMPILE::SWF{
				var target:ByteArray = bytes.data as ByteArray; 
				return streamImpl.readBytes(target,offset,length);
			}
			COMPILE::JS{
				streamImpl.readBinaryData(bytes, offset,length);
			}
		}

		COMPILE::JS
		private static const leftTrimThreshold:uint = 4096;


		/**
		 * @royaleignorecoercion ArrayBuffer
		 */
		COMPILE::JS
		private function leftTrim():void{
			var buffer:ArrayBuffer = streamImpl.data as ArrayBuffer;
			var temp:ArrayBuffer = buffer.slice(streamImpl.position);
			streamImpl.clear();
			streamImpl.writeBytes(temp);
			streamImpl.position = 0;

			/*var temp:AMFBinaryData = new AMFBinaryData(buffer.slice(streamImpl.position));
			temp.endian = streamImpl.endian;
			streamImpl.clear();
			streamImpl = temp;*/
		}
		
		COMPILE::SWF
		public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void {
			streamImpl.readBytes(bytes,offset,length);
		}
		
		COMPILE::JS
		public function readBytes(bytes:ArrayBuffer, offset:uint = 0, length:uint = 0):void {
			streamImpl.readBytes(bytes,offset,length);
			if (streamImpl.position > leftTrimThreshold) leftTrim();
		}
		

		public function readBoolean():Boolean {
			var val:Boolean = streamImpl.readBoolean();
			COMPILE::JS{
				if (streamImpl.position > leftTrimThreshold) leftTrim();
			}
			return val;
		}

		public function readByte():int {
			var b:int = streamImpl.readByte();
			COMPILE::JS{
				if (streamImpl.position > leftTrimThreshold) leftTrim();
			}
			return b;
		}

		public function readUnsignedByte():uint {
			var b:uint = streamImpl.readUnsignedByte();
			COMPILE::JS{
				if (streamImpl.position > leftTrimThreshold) leftTrim();
			}
			return b;
		}

		public function readShort():int {
			var b:int = streamImpl.readShort();
			COMPILE::JS{
				if (streamImpl.position > leftTrimThreshold) leftTrim();
			}
			return b;
		}

		public function readUnsignedShort():uint {
			var b:uint = streamImpl.readUnsignedShort();
			COMPILE::JS{
				if (streamImpl.position > leftTrimThreshold) leftTrim();
			}
			return b;
		}

		public function readInt():int {
			var b:int = streamImpl.readInt();
			COMPILE::JS{
				if (streamImpl.position > leftTrimThreshold) leftTrim();
			}
			return b;
		}

		public function readUnsignedInt():uint {
			var b:uint = streamImpl.readUnsignedInt();
			COMPILE::JS{
				if (streamImpl.position > leftTrimThreshold) leftTrim();
			}
			return b;
		}

		public function readFloat():Number {
			var n:Number = streamImpl.readFloat();
			COMPILE::JS{
				if (streamImpl.position > leftTrimThreshold) leftTrim();
			}
			return n;
		}

		public function readDouble():Number {
			var n:Number = streamImpl.readDouble();
			COMPILE::JS{
				if (streamImpl.position > leftTrimThreshold) leftTrim();
			}
			return n;
		}

		public function readUTF():String {
			var s:String = streamImpl.readUTF();
			COMPILE::JS{
				if (streamImpl.position > leftTrimThreshold) leftTrim();
			}
			return s;
		}

		public function readUTFBytes(length:uint):String {
			var s:String = streamImpl.readUTFBytes(length);
			COMPILE::JS{
				if (streamImpl.position > leftTrimThreshold) leftTrim();
			}
			return s;
		}

		public function get bytesAvailable():uint {
			return streamImpl.bytesAvailable;
		}

		public function get endian():String {
			return streamImpl.endian;
		}

		public function set endian(type:String):void {
			streamImpl.endian = type;
		}

		public function readObject():* {
			var o:* = streamImpl.readObject;
			COMPILE::JS{
				if (streamImpl.position > leftTrimThreshold) leftTrim();
			}
			return o;
		}

		
		COMPILE::SWF
		public function readMultiByte(length:uint, charSet:String):String {
			return streamImpl.readMultiByte(length, charSet); 
		}

		/*override public function dispatchEvent(event:Object):Boolean{
			console.log('dispatching ',event);
			return super.dispatchEvent(event);
		}*/
	}
}

