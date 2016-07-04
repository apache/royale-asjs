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

