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

package mx.net
{
	import org.apache.royale.net.URLLoader;
	import mx.events.HTTPStatusEvent;
	
	/**
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 * 
	 *  @royalesuppresspublicvarwarning
	 */
	public class URLLoader extends org.apache.royale.net.URLLoader
	{
		/**
		 *  Constructs an instance of the responder with the specified handlers.
		 *  
		 *  @param  result Function that should be called when the request has
		 *           completed successfully.
		 *  @param  fault Function that should be called when the request has
		 *          completed with errors.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function URLLoader()
		{
			super();
		}
		
		COMPILE::JS
		override public function dispatchEvent(event:Object):Boolean
		{
			try  
			{            
				if(event.type == "httpStatus")
				{
					var type:String = event.type;
					var status:int = event.value;
					var bubbles:Boolean = false;
					var cancelable:Boolean = false;
					event = new HTTPStatusEvent(type, bubbles, cancelable, status);
				}
				
				return super.dispatchEvent(event);
			}
			catch (e:Error)
			{
				if (e.name != "stopImmediatePropagation")
					throw e;
			}
			return false;
		}
        

	}
	
}