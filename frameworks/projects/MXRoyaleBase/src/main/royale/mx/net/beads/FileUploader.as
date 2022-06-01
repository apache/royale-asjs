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
package mx.net.beads
{
	import org.apache.royale.net.URLRequest;
	import org.apache.royale.file.beads.FileUploader;
	import org.apache.royale.net.URLBinaryLoader;
	import org.apache.royale.file.IFileModel;
	import org.apache.royale.events.Event;

	
	/**
	 *  Indicates that the upload operation is complete
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	[Event(name="complete", type="org.apache.royale.events.Event")]
	/**
	 *  The FileUploader class is a bead which adds to FileProxy
	 *  the ability to upload files.
	 *  
	 *
	 *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9
	 */
	public class FileUploader extends org.apache.royale.file.beads.FileUploader
	{

		protected var _referenceRequest:URLRequest;
		public function set referenceRequest(value:URLRequest):void{
			_referenceRequest = value;
		}

		protected var _uploadDataFieldName:String = "Filedata";
		public function set uploadDataFieldName(value:String):void{
			_uploadDataFieldName = value;
		}
		
		/**
		 *  Upload a file to the specified url.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.10
		 *  @royaleignorecoercion org.apache.royale.file.IFileModel
		 */
		override public function upload(url:String):void
		{
			var binaryUploader:URLBinaryLoader = new URLBinaryLoader();
			var req:URLRequest = new URLRequest();
				req.contentType = contentType;

			req.method = "POST";
			req.data = (host.model as IFileModel).blob;
			req.url = url;
			if (_referenceRequest) {
				req.requestHeaders = _referenceRequest.requestHeaders;
			}

			binaryUploader.addEventListener(Event.COMPLETE, completeHandler);
			binaryUploader.load(req);
		}
		
	}
}
