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
	 * Returns a debounced function to run after a delay.
	 * The first invocation of the function will be run after its delay.
	 * Any invocations between the first invocation and the delay will be ignored.
	 * 
   * @royalesuppressexport
	 * @langversion 3.0
	 * @productversion Royale 0.9.9
	 * 
	 */
	public function animateFunction(method:Function, fps:Number):Function
	{
		COMPILE::SWF
		{
			var limit:Number = 1000/fps;
			var timeStamp:Number = 0;
			var timeoutRef:*;
			var invocations:Array = [];
			return function(...args):void
			{
				if(timeoutRef){
					clearTimeout(timeoutRef);
					timeoutRef = null;
				}
				invocations.push(args);
				var currentTime:Number = new Date().getTime();
				var timeDiff:Number = currentTime - timeStamp;
				if(timeDiff >= limit)
				{
					if(timeStamp == 0)
						timeStamp = currentTime;
					else
						timeStamp += limit;
					method.apply(null,invocations.shift());
				}
				if(invocations.length && timeoutRef == null)
				{
					// currentTime = new Date().getTime();
					timeDiff = currentTime - timeStamp + limit;
					var nextInterval:Number = Math.max(timeDiff,0);
					timeoutRef = setTimeout(callback, nextInterval);
				}

				function callback():void
				{
					timeoutRef = null;

					if(!invocations.length)
						return;
					
					var currentArgs:Array = invocations.shift();
					method.apply(null,currentArgs);
					timeStamp += limit;
					var timeDiff:Number = new Date().getTime() - timeStamp + limit;
					while(timeDiff < 0)
					{
						// catch up on the missing frames
						method.apply(null,invocations.shift());
						if(invocations.length == 0)
						{
							return;
						}
						timeDiff+=limit;
					}
					if(invocations.length)
					{
						timeoutRef = setTimeout(callback, timeDiff);
					}
				}
			}

		}

		COMPILE::JS
		{
			var limit:Number = 1000/fps;
			var lastTimeStamp:Number = 0;
			var timeoutRef:*;
			var invocations:Array = [];
			return function(...args):void
			{
				invocations.push(args);
				requestAnimationFrame(callback);
				function callback(timeStamp:Number):void
				{
					if(invocations.length == 0)
						return;

					// we can't rely on getting time stamps ourselves,
					// so hopefully this is not slower than our target rate...
					if ( (timeStamp - lastTimeStamp) >= limit)
					{
						if(lastTimeStamp == 0)
							lastTimeStamp = timeStamp;
						else
							lastTimeStamp += limit; // make sure we stick to the desired rate

						method.apply(null,invocations.shift());
					}
					if(invocations.length)
						requestAnimationFrame(callback);
				}
			}
		}
	}
}