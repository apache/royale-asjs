package org.apache.flex.net
{
    public final class HTTPConstants extends Object
    {
        /**
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static const GET:String = "GET";
        
        /**
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static const POST:String = "POST";
        
        /**
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static const PUT:String = "PUT";
        
        /**
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static const DELETE:String = "DELETE";
        
        /**
         *  Dispatched when the request is complete.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static const COMPLETE:String = "complete";
        
        /**
         *  Dispatched if an error occurs in the server communication.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static const IO_ERROR:String = "ioError";
        
        /**
         *  Dispatched when an httpStatus code is received from the server.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static const STATUS:String = "httpStatus";
        
        /**
         *  Dispatched if Adobe AIR is able to detect and return the status 
         *  code for the request.  Unlike the httpStatus event, the httpResponseStatus 
         *  event is delivered before any response data. Also, the httpResponseStatus 
         *  event includes values for the responseHeaders and responseURL properties 
         *  (which are undefined for an httpStatus event. Note that the 
         *  httpResponseStatus event (if any) will be sent before 
         *  (and in addition to) any complete or error event.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public static const RESPONSE_STATUS:String = "httpResponseStatus";
        
       

        public function HTTPConstants()
        {
        }
    }
}