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
	import org.apache.flex.events.EventDispatcher;

	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the request is complete.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	[Event(name="complete", type="org.apache.flex.events.Event")]
	
	/**
	 *  Dispatched if an error occurs in the server communication.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	[Event(name="ioError", type="org.apache.flex.events.Event")]
	
	/**
	 *  Dispatched when an httpStatus code is received from the server.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	[Event(name="httpStatus", type="org.apache.flex.events.Event")]
	
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
	[Event(name="httpResponseStatus", type="org.apache.flex.events.Event")]
	
	/**
	 *  The URLLoader class is a base class for the specific flavors of loaders such as binary,
	 *  text or variables
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.7.0
	 */
	public class URLLoader extends EventDispatcher
	{
		public function URLLoader()
		{
			throw new Error("URLLoader should not be instantiated. Use a derived class instead.")
		}
	}
}