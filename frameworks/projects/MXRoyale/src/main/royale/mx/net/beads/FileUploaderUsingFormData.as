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
import org.apache.royale.file.beads.FileUploader;
import org.apache.royale.file.IFileModel;

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
			xhr.addEventListener("progress", xhr_progress, false);
			
			var formData:FormData = new FormData();
			formData.append("Filename", (host.model as IFileModel).name);
			formData.append("Filedata", (host.model as IFileModel).fileReference);
			xhr.send(formData);
		}
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
		/*
		var progEv:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
		progEv.current = bytesLoaded = error.loaded;
		progEv.total = bytesTotal = error.total;
		
		dispatchEvent(progEv);
		if(onProgress)
			onProgress(this);
		*/
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
			host.dispatchEvent(new org.apache.royale.events.Event("complete"));
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