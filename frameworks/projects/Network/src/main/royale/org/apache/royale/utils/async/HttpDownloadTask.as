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
	import org.apache.royale.events.ProgressEvent;

	public class HttpDownloadTask extends HttpRequestTask
	{
		/**
		 * HttpDownloadTask is a HttpRequestTask which has download progress.
		 * It is a basic request and not appropriate for a Multipart upload.
		 */
		public function HttpDownloadTask()
		{
			super();
		}

		private var _bytesLoaded:int;

		public function get bytesLoaded():int
		{
			return _bytesLoaded;
		}

		private var _bytesTotal:int;

		public function get bytesTotal():int
		{
			return _bytesTotal;
		}

		override protected function attachLoaderCallbacks():void
		{
			super.attachLoaderCallbacks();
			loader.onProgress = onProgress;
		}
		private function onProgress():void
		{
			_bytesLoaded = loader.bytesLoaded;
			_bytesTotal = loader.bytesTotal;
			dispatchEvent(new ProgressEvent("progress",false,false,bytesLoaded,bytesTotal));
			if(progressCallbacks)
			{
				for(var i:int=0;i<progressCallbacks.length;i++)
				{
					progressCallbacks[i](this);
				}
			}
		}
		private var progressCallbacks:Array;
    public function progress(callback:Function):AsyncTask{
      if(!progressCallbacks){
        progressCallbacks = [];
      }
      progressCallbacks.push(callback);
      return this;
    }
		override protected function destroy():void
		{
			super.destroy();
			progressCallbacks = null;
		}

	}
}