
package org.apache.flex.net.url
{   
    
    
    
    import org.apache.flex.events.Event;
    import org.apache.flex.events.EventDispatcher;
    import org.apache.flex.events.ProgressEvent;
    import org.apache.flex.net.HTTPConstants;
    import org.apache.flex.net.HTTPUtils;
    import org.apache.flex.utils.BinaryData;

    COMPILE::SWF
    {
        import flash.net.URLRequestHeader;
        import flash.events.IOErrorEvent;
        import flash.net.URLVariables;
        import flash.events.Event;
        import flash.events.ProgressEvent;
        import flash.net.URLRequest;
        import flash.net.URLStream;
        import flash.utils.ByteArray;
    }
        
    
    
    public class URLStream extends EventDispatcher
    {
        COMPILE::JS 
        {
            private var xhr:XMLHttpRequest;
        }
            
        COMPILE::SWF
        {
            private var flashUrlStream:flash.net.URLStream
        }
            
        public function URLStream()
        {
            super();
        }
        
        public function get response():BinaryData
        {
            COMPILE::JS
                {
                    var ab:ArrayBuffer = xhr.response as ArrayBuffer;
                    var bd:BinaryData = new BinaryData(ab);
                    return bd;
                }
                COMPILE::SWF
                {
                    var ba:ByteArray = new ByteArray();
                    flashUrlStream.readBytes(ba);
                    var bd:BinaryData = new BinaryData(ba);
                    return bd;
                }
        }

        public function load(urlRequest:org.apache.flex.net.url.URLRequest):void
        {
            COMPILE::JS {
                xhr = new XMLHttpRequest();
                xhr.open("POST", urlRequest.url);
                xhr.responseType = "arraybuffer";
                xhr.addEventListener("readystatechange", xhr_onreadystatechange,false);
                xhr.addEventListener("progress", xhr_progress, false);
                xhr.setRequestHeader("Content-type", urlRequest.contentType);
                xhr.send(HTTPUtils.encodeUrlVariables(urlRequest.data));
            }
            COMPILE::SWF 
            {
                flashUrlStream = new flash.net.URLStream();
                var req:flash.net.URLRequest = new flash.net.URLRequest(urlRequest.url);
                var hdr:URLRequestHeader = new URLRequestHeader("Content-type", urlRequest.contentType);
                req.requestHeaders.push(hdr);
                req.data = new flash.net.URLVariables(HTTPUtils.encodeUrlVariables(urlRequest.data));
                req.method = HTTPConstants.POST;
                flashUrlStream.addEventListener(flash.events.ProgressEvent.PROGRESS, flash_progress);
                flashUrlStream.addEventListener(flash.events.Event.COMPLETE, flash_complete);
                flashUrlStream.addEventListener(IOErrorEvent.IO_ERROR, flash_onIoError);
                flashUrlStream.load(req);
            }
        }
        
        COMPILE::SWF 
        protected function flash_onIoError(event:IOErrorEvent):void
        {
            trace("io error: " + event.text);
        }            
            
        COMPILE::SWF
        protected function flash_complete(event:flash.events.Event):void
        {
            dispatchEvent(new org.apache.flex.events.Event(HTTPConstants.COMPLETE));
        }
        COMPILE::SWF
        protected function flash_progress(event:flash.events.ProgressEvent):void
        {
            var progressEvent:org.apache.flex.events.ProgressEvent = new org.apache.flex.events.ProgressEvent(org.apache.flex.events.ProgressEvent.PROGRESS);
            progressEvent.current = event.bytesLoaded;
            progressEvent.total = event.bytesTotal;
            dispatchEvent(progressEvent);
        }
        
        
        private function xhr_progress(e:Object):void 
        {
            dispatchEvent(new org.apache.flex.events.ProgressEvent(org.apache.flex.events.ProgressEvent.PROGRESS, false, false, e.loaded, e.total));
        }
        
        COMPILE::JS
        private function xhr_onreadystatechange(e:*):void
        {
            if (xhr.readyState == 4 && xhr.status == 200)
            {
                dispatchEvent(new org.apache.flex.events.Event(HTTPConstants.COMPLETE));
            }else if (xhr.readyState==4&&xhr.status==404){
                //                    dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
            }
        }
        
        
        //        public function readBytes(b:ByteArray, offset:uint = 0, length:uint = 0):void  {
        //        }
        
        public function readBoolean():Boolean  { return false }
        
        public function readByte():int  { return 0 }
        
        public function readUnsignedByte():uint  { return 0 }
        
        public function readShort():int  { return 0 }
        
        public function readUnsignedShort():uint  { return 0 }
        
        public function readUnsignedInt():uint  { return 0 }
        
        public function readInt():int  { return 0 }
        
        public function readFloat():Number  { return 0 }
        
        public function readDouble():Number  { return 0 }
        
        public function readMultiByte(param1:uint, param2:String):String  { return null; }
        
        public function readUTF():String  { return null }
        
        public function readUTFBytes(param1:uint):String  { return null; }
        
        public function get connected():Boolean  { return false }
        
        public function get bytesAvailable():uint  { return 0; }
        
        public function close():void  {/**/ }
        
        public function readObject():*  { return null; }
        
        public function get objectEncoding():uint  { return 0; }
        
        public function set objectEncoding(param1:uint):void  {/**/ }
        
        public function get endian():String  { return null; }
        
        public function set endian(param1:String):void  {/**/ }
        
        public function get diskCacheEnabled():Boolean  { return false }
        
        public function get position():Number  { return 0; }
        
        public function set position(param1:Number):void  {/**/ }
        
        public function get length():Number  { return 0; }
        
        public function stop():void  {/**/ }
    }
}

