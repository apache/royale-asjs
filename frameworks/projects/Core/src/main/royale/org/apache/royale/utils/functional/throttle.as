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
package org.apache.royale.utils.functional
{
	COMPILE::SWF{
		import flash.utils.setTimeout;		
		import flash.utils.clearTimeout;		
	}
	/**
	 * Limits the execution of a function to a maximum of once within the limit in ms.
	 * It the limit has expired since the last call, the function is executed immediately.
	 * Otherwise it is not executed at all.
	 * 
	 * 
   * @royalesuppressexport
	 * @langversion 3.0
	 * @productversion Royale 0.9.9
	 * 
	 */
	public function throttle(method:Function, limit:Number):Function
	{
		var timeStamp:Number = 0;
		return function(...args):void
		{
			var currentTime:Number = new Date().getTime();
			if(currentTime - timeStamp >= limit)
			{
				timeStamp = currentTime;
				method.apply(null,args);
			}
		}
	}
}