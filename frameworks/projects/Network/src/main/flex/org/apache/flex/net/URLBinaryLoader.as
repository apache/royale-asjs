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
    import org.apache.flex.events.ProgressEvent;
    import org.apache.flex.utils.BinaryData;
    import org.apache.flex.utils.Endian;


	/**
	 *  The URLBinaryLoader class is a relatively low-level class designed to get
	 *  binary data over HTTP the intent is to create similar classes for text and URL vars.  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.7.0
	 */
   public class URLBinaryLoader extends URLLoader
    {
        
	   /**
		*  The binary result of the request.
		*  
		*  @langversion 3.0
		*  @playerversion Flash 10.2
		*  @playerversion AIR 2.6
		*  @productversion FlexJS 0.7.0
		*/        
        public var data:BinaryData;

		/**
		 *  Indicates the byte order for the data.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */        
		public var endian:String = Endian.BIG_ENDIAN;
		

        protected var stream:URLStream;
        
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
		 *  The total number of bytes (if available).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */        
        public var bytesTotal:uint = 0;
        
        public function URLBinaryLoader()
        {
            super();
            createStream();
        }
        protected function createStream():void
        {
            stream = new URLStream();
        }
        private function progressFunction(stream:URLStream):void
        {
            bytesLoaded = stream.bytesLoaded;
            bytesTotal = stream.bytesTotal;
            dispatchEvent(new ProgressEvent("progress",false,false,bytesLoaded,bytesTotal));
            if(onProgress)
                onProgress(this);
        }
        
        private function statusFunction(stream:URLStream):void
        {
            requestStatus = stream.requestStatus;
            dispatchEvent(new DetailEvent("httpStatus",false,false,""+requestStatus));
            if(onStatus)
                onStatus(this);
        }
        
        private function errorFunction(stream:URLStream):void
        {
            dispatchEvent(new DetailEvent("communicationError",false,false,""+requestStatus));
            if(onError)
                onError(this);
            cleanupCallbacks();
        }
        
        private function completeFunction(stream:URLStream):void
        {
			data = stream.response;
            dispatchEvent(new org.apache.flex.events.Event("complete"));
            if(onComplete)
                onComplete(this);
            cleanupCallbacks();
        }
        
        protected function setupCallbacks():void
        {
            stream.onProgress = progressFunction;

            stream.onStatus = statusFunction;
            stream.onError = errorFunction;
            stream.onComplete = completeFunction;
        }
		/**
		 *  Makes the URL request.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */        
        public function load(request:URLRequest):void
        {
            setupCallbacks();
            stream.load(request);
        }
        
		/**
		 *  Cancels the URL request.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7.0
		 */        
        public function close():void
        {
            stream.close();
            cleanupCallbacks();
			//TODO do we need a callback for canceling?
        }
    }
}

