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
	import org.apache.royale.events.ProgressEvent;
	
	/**
	 * @see URLStream
	 * The URLUploadStream extends the URLStream class to support upload progress events.
	 *
	 * This class is only used for JS implementations because Flash upload events need to be handled differently.
	 * In Flash, URLLoader does not dispatch upload events. It only dispatches download events.
	 * To get upload events in Flash, you need to use File/FileReference.upload() and attach event listeners to that.
	 *
	 * Care should be taken when using this class because it attaches a progress listener to the xhr.upload object.
	 * Doing so causes browsers to send OPTIONS requests. This will return an unauthorized response from servers not
	 * configured to allow CORS OPTIONS requests. See this S.O. post for details. https://stackoverflow.com/a/17057853
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.9.0
	 */
	public class URLUploadStream extends URLStream
	{
			
		public function URLUploadStream()
		{
			super();
		}
		
		COMPILE::JS
		override protected function send(requestData:Object):void
		{
			xhr.upload.onprogress = xhr_uploadprogress;
			xhr.send(requestData);
		}

		/**
		 *  Upload is progressing (JS only).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		COMPILE::JS
		private function xhr_uploadprogress(progress:Object):void
		{
			var progEv:ProgressEvent = new ProgressEvent("uploadprogress");
			progEv.current = bytesLoaded = progress["loaded"];
			progEv.total = bytesTotal = progress["total"];
			
			dispatchEvent(progEv);
			if(onUploadProgress)
				onUploadProgress(this);
		}

		/**
		 *  Cleanup all callbacks.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		override protected function cleanupCallbacks():void
		{
			super.cleanupCallbacks();
			onUploadProgress = null;
		}
		
		/**
		 *  Callback for upload progress event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
         * 
         *  @royalesuppresspublicvarwarning
		 */		
		public var onUploadProgress:Function;

		/**
		 *  Convenience function for upload progress event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public function uploadProgress(callback:Function):org.apache.royale.net.URLStream
		{
			onUploadProgress = callback;
			return this;
		}
	}
}

