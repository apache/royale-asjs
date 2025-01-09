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
package org.apache.royale.file.beads
{
	import org.apache.royale.events.Event;
	import org.apache.royale.file.IFileModel;
	import org.apache.royale.net.URLBinaryLoaderWithCorsCredentials;
	import org.apache.royale.net.URLRequest;

	/**
	 *  Provides file uploading functionality with CORS credentials support and the ability to handle response data
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.12
	 *
	 *  @royalesuppresspublicvarwarning
	 */
	public class FileUploaderWithResponseDataAndCorsCredentials extends FileUploaderWithResponseData
	{
		/**
		 * constructor
		 */
		public function FileUploaderWithResponseDataAndCorsCredentials()
		{
			super();
		}
		
		override public function upload(url:String):void
		{
			var binaryUploader:URLBinaryLoaderWithCorsCredentials = new URLBinaryLoaderWithCorsCredentials();
			var req:URLRequest = new URLRequest();
				req.contentType = contentType;

			req.method = "POST";
			req.data = (host.model as IFileModel).blob;
			req.url = url;
			binaryUploader.addEventListener(Event.COMPLETE, completeHandler);
			binaryUploader.load(req);
		}
	}
}