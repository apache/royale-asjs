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
	import org.apache.royale.events.EventDispatcher;

	//--------------------------------------
	//  Events
	//--------------------------------------
	
	/**
	 *  Dispatched when the request is complete.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="complete", type="org.apache.royale.events.Event")]
	
	/**
	 *  Dispatched if an error occurs in the server communication.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="communicationError", type="org.apache.royale.events.Event")]
	
	/**
	 *  Dispatched when an httpStatus code is received from the server.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	[Event(name="httpStatus", type="org.apache.royale.events.Event")]
	
	/**
	 *  The URLLoader class is a base class for the specific flavors of loaders such as binary,
	 *  text or variables
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.7.0
	 */
	public class URLLoader extends EventDispatcher
	{
		public function URLLoader()
		{
		}
		
		/**
		 *  The status of the request.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */        
		public var requestStatus:int;
		
		
		protected function cleanupCallbacks():void
		{
			onComplete = null;
			onError = null;
			onProgress = null;
			onStatus = null;
		}
		/**
		 *  Callback for complete event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public var onComplete:Function;
		
		/**
		 *  Callback for error event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public var onError:Function;
		
		/**
		 *  Callback for progress event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public var onProgress:Function;
		
		/**
		 *  Callback for status event.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public var onStatus:Function;
		
		/**
		 *  Convenience function for complete event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public function complete(callback:Function):URLLoader
		{
			onComplete = callback;
			return this;
		}
		
		/**
		 *  Convenience function for error event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public function error(callback:Function):URLLoader
		{
			onError = callback;
			return this;
		}
		
		/**
		 *  Convenience function for progress event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public function progress(callback:Function):URLLoader
		{
			onProgress = callback;
			return this;
		}
		
		/**
		 *  Convenience function for status event to allow chaining.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */		
		public function status(callback:Function):URLLoader
		{
			onStatus = callback;
			return this;
		}

	}
}
