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
	/**
	 *  The URLRequest class captures all of the information in a single HTTP request.
	 *  URLRequest objects are passed to the load() methods of the URLStream,
	 *  and URLLoader classes, and to other loading operations, to initiate URL downloads.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.7.0
     * 
     *  @royalesuppresspublicvarwarning
	 */
    public final class URLRequest
    {
		/**
		 *  The URL to be requested.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */	
        
		public var url:String;
		
		/**
		 *  An object containing data to be transmitted with the URL request. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */	
        public var data:Object;
		
		/**
		 *   Controls the HTTP form submission method.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */	
        public var contentType:String = HTTPConstants.FORM_URL_ENCODED;
		
		/**
		 *   Controls the HTTP form submission method.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */	
		public var method:String = HTTPConstants.GET;
		private var _requestHeaders:Array;

		/**
		 *   Set the URL request string.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
        public function URLRequest(url:String = null)
        {
            super();
            if(url != null)
            {
                this.url = url;
            }
            this._requestHeaders = [];
        }

		/**
		 *   Set the URL request headers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
        public function get requestHeaders():Array
        {
            return _requestHeaders;
        }

		/**
		 *   Get the URL request headers.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
        public function set requestHeaders(value:Array) : void
        {
			_requestHeaders = value;
        }
        
    }
}

