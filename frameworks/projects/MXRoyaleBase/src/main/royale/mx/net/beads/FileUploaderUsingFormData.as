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

package mx.net.beads
{
import org.apache.royale.events.DetailEvent;
import org.apache.royale.file.IFileModel;
import mx.events.DataEvent;

import org.apache.royale.net.URLRequestHeader;

/**
 *  This class does uploads using FormData in JS
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 * 
 *  @royalesuppresspublicvarwarning
 */
public class FileUploaderUsingFormData extends FileUploader
{
    /**
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function FileUploaderUsingFormData()
    {
        super();
    }

	COMPILE::JS
	private var xhr:XMLHttpRequest;
	
	/**
	 *  Indicates the status of the request.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.7.0
	 */		
	public var requestStatus:int = 0;

	override public function upload(url:String):void
	{
		COMPILE::JS 
		{
			requestStatus = 0;
			xhr = new XMLHttpRequest();
			xhr.open("POST", url);
			xhr.addEventListener("readystatechange", xhr_onreadystatechange,false);
			//xhr.upload.addEventListener("progress", xhr_progress, false);
			trackUpload();
			if (_referenceRequest) {
				var contentType:String;
				for (var i:int = 0; i < _referenceRequest.requestHeaders.length; i++)
				{
					var header:URLRequestHeader = _referenceRequest.requestHeaders[i];
					if (header.name.toLowerCase() == "content-type")
					{
						contentType = header.value;
						continue;//ignore the contentType, it will be set to multipart by using FormData below
					}
					xhr.setRequestHeader(header.name, header.value);
				}
			}
			var dataFieldName:String = _uploadDataFieldName;
			
			var formData:FormData = new FormData();
			formData.append("filename", (host.model as IFileModel).name); //this should *not* be 'Filename' , it should be 'filename' (from flash as3 docs)
			formData.append(dataFieldName, (host.model as IFileModel).fileReference);
			xhr.send(formData);
		}
	}

	COMPILE::JS
	private function trackUpload():void{
		var xhr:XMLHttpRequest = this.xhr;
		var handler:Function = xhr_upload;
		xhr.upload.addEventListener('loadstart', handler);
		xhr.upload.addEventListener('load', handler);
		xhr.upload.addEventListener('loadend', handler);
		xhr.upload.addEventListener('progress', handler);
		xhr.upload.addEventListener('error', handler);
		xhr.upload.addEventListener('abort', handler);
	}


	/**
	 *  Upload is progressing (JS only).
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
	COMPILE::JS
	private function xhr_upload(event:Object):void
	{
		/*
		var progEv:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
		progEv.current = bytesLoaded = error.loaded;
		progEv.total = bytesTotal = error.total;
		
		dispatchEvent(progEv);
		if(onProgress)
			onProgress(this);
		*/

		trace('xhr_upload:',event);
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
			host.dispatchEvent(new DetailEvent("communicationError"));
		}
		else if(xhr.status < 200)
		{
			host.dispatchEvent(new DetailEvent("communicationError",false,false,""+requestStatus));
		}
		else if(xhr.status < 300)
		{
			var dataEvent:DataEvent = new DataEvent("complete");
			dataEvent.text = xhr.responseText as String;
			host.dispatchEvent(dataEvent);
		}
		else
		{
			host.dispatchEvent(new DetailEvent("communicationError",false,false,""+requestStatus));
		}
	}

	/**
	 *  Set the HTTP request status.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.7.0
	 */
	COMPILE::JS
	private function setStatus(value:int):void
	{
		if(value != requestStatus)
		{
			requestStatus = value;
			host.dispatchEvent(new DetailEvent("httpStatus",false,false,""+value));
		}
	}

		        
}


}
