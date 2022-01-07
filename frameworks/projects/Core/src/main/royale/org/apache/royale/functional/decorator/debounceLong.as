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
package org.apache.royale.functional.decorator
{
	COMPILE::SWF{
		import flash.utils.setTimeout;		
		import flash.utils.clearTimeout;		
	}
	/**
	 * Returns a debounced function to run after a delay.
	 * If the function is invoked again within the delay period, the latest
	 * invocation of the function will be used and the delay will be reset to then.
	 * 
   * @royalesuppressexport
	 * @langversion 3.0
	 * @productversion Royale 0.9.9
	 * 
	 */
	public function debounceLong(method:Function, delay:Number):Function
	{
		var timeoutRef:*;
		return function(...args):void
		{
			function callback():void
			{
				timeoutRef = null;
				//Because of the way Royale binds closures, no this argument is needed.
				method.apply(null,args);
			}
			if(timeoutRef)
				clearTimeout(timeoutRef);
				
			timeoutRef = setTimeout(callback, delay);
		}
	}
}