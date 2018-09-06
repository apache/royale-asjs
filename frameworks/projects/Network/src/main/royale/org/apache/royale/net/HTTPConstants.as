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
package org.apache.royale.net
{
    public final class HTTPConstants
    {
        /**
         *
		 *  HTTP GET request.
		 *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public static const GET:String = "GET";
        
        /**
         *
		 *  HTTP Post request.
		 *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public static const POST:String = "POST";
        
        /**
         *  HTTP Put request.
		 *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public static const PUT:String = "PUT";
        
        /**
         *
		 *  HTTP form url encoded.
		 *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public static const FORM_URL_ENCODED:String = "application/x-www-form-urlencoded";

		/**
		 *
		 *  HTTP delete request.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public static const DELETE:String = "DELETE";

		/**
		 *  Dispatched when the connection is opened.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public static const OPEN:String = "open";

		/**
         *  Dispatched when the request is complete.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public static const COMPLETE:String = "complete";
        
        /**
         *  Dispatched if an error occurs in the server communication.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public static const COMMUNICATION_ERROR:String = "communicationError";

		/**
		 *  Detail of an error occurring in the server communication. (Flash only)
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public static const IO_ERROR:String = "ioError";

		/**
		 *  Detail of a security error occurs in the server communication. (Flash only)
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public static const SECURITY_ERROR:String = "securityError";

        /**
         *  Dispatched when an httpStatus code is received from the server.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
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
         *  @productversion Royale 0.0
         */
        public static const RESPONSE_STATUS:String = "httpResponseStatus";
        
       

        public function HTTPConstants()
        {
        }
    }
}
