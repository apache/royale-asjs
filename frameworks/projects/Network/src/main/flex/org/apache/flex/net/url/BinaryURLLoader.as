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
package org.apache.flex.net.url
{    
    
    import org.apache.flex.events.Event;
    import org.apache.flex.events.EventDispatcher;
    import org.apache.flex.events.ProgressEvent;
    import org.apache.flex.net.HTTPConstants;
    import org.apache.flex.utils.BinaryData;

   public class BinaryURLLoader extends EventDispatcher
    {
        
        public var data:BinaryData;
        
        private var stream:URLStream;
        
        public var bytesLoaded:uint = 0;
        
        public var bytesTotal:uint = 0;
        
        public function BinaryURLLoader(request:URLRequest = null)
        {
            super();
            stream = new URLStream();
            stream.addEventListener(HTTPConstants.COMPLETE, onComplete);
        }
        
        public function load(request:URLRequest):void
        {
            stream.load(request);
        }
        
        public function close():void
        {
            stream.close();
        }
        
        private function redirectEvent(event:Event):void
        {
            dispatchEvent(event);
        }
        
        private function onComplete(event:Event):void
        {
            data = stream.response;
            if (data)
            {
                dispatchEvent(event);
            }
            else
            {
                // TODO dipatch error event?
                dispatchEvent(new Event(HTTPConstants.IO_ERROR));
            }
        }
        
        private function onProgress(event:ProgressEvent):void
        {
            this.bytesLoaded = event.current
            this.bytesTotal = event.total;
            dispatchEvent(event);
        }
    }
}

