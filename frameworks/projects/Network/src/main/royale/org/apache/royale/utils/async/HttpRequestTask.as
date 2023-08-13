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
package org.apache.royale.utils.async
{
	import org.apache.royale.net.HTTPConstants;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.net.URLBinaryLoader;
	import org.apache.royale.net.URLRequest;
	import org.apache.royale.utils.BinaryData;

	/**
	 * HttpRequestTask is an AsyncTask for making HTTP requests.
	 * You can access the result as well as the http status codes after the task completes.
	 * As in all tasks, it cleans up after itself, so memory leaks should be very uncommon.
	 */
	public class HttpRequestTask extends AsyncTask
	{
		public function HttpRequestTask()
		{
			super();
		}

		override public function run(data:Object=null):void{
			assert(url != null,"url must be specified!");
			var request:URLRequest = new URLRequest(url);
			request.contentType = contentType;
			request.method = method;
			if(requestHeaders)
				request.requestHeaders = requestHeaders;
			if(parameters)
				request.data = parameters;
			loader = getLoader();
			attachLoaderCallbacks();
			loader.load(request);
		}
		public var contentType:String = HTTPConstants.FORM_URL_ENCODED;
		public var method:String = HTTPConstants.GET;
		public var url:String;
		/**
		 * An array url URLRequestHeaders if needed
		 */
		public var requestHeaders:Array;
		/**
		 * parameters is any object URLRequest can accept
		 */
		public var parameters:Object;

		public function get resultString():String
		{
			var l:URLBinaryLoader = loader;
			if(l && l.data)
			{
				return l.data.readUTFBytes(l.data.length);
			}
			return "";
		}
		/**
		 * We try to parse the httpResult as JSON. If that fails, it defaults to a string.
		 * For other response types (such as XML), the resultString should be used to construct the correct result.
		 * If the binary response is needed, use binaryResult instead.
		 */
		public function get httpResult():Object
		{
			var resultStr:String = resultString;
			try{
				return JSON.parse(resultStr);
			}catch(err:Error){
				return resultStr;
			}
		}

		public function get httpStatus():Number
		{
			if(loader)
			{
				return loader.requestStatus;
			}
			return 0;
		}

		public function get binaryResult():BinaryData
		{
			return loader ? loader.data : null;
		}
		protected var loader:URLBinaryLoader;

		/**
		 * Convenience function to access the underlying loader.
		 * Should not usually be necessary since the result can be accessed directly from the task.
		 */
		public function getLoader():URLBinaryLoader
		{
			return loader;
		}
		/**
		 * Can be overridded in a subclass to use a different implementation (such as URLBinaryUploader)
		 */
		protected function createLoader():URLBinaryLoader{
			return new URLBinaryLoader();
		}
		/**
		 * Can be overridden in a subclass
		 */
		protected function attachLoaderCallbacks():void
		{
			loader.onComplete = onComplete;
			loader.onError = onError;
		}
		/**
		 * Can be overridden in a subclass
		 */
		protected function onComplete():void
		{
			complete();
		}
		/**
		 * Can be overridden in a subclass
		 */
		protected function onError():void
		{
			fail();
		}
		public static function execute(url:String, callback:Function, method:String = HTTPConstants.GET, parameters:Object = null, contentType:String = HTTPConstants.FORM_URL_ENCODED, requestHeaders:Array = null):void
		{
			var task:HttpRequestTask = new HttpRequestTask();
			task.url = url;
			task.contentType = contentType;
			task.method = method;
			task.requestHeaders = requestHeaders;
			task.parameters = parameters;
			task.done(callback);
			task.run();
		}
	}
}