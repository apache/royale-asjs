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
package org.apache.royale.utils
{
    COMPILE::SWF {
		import flash.display.DisplayObject;
		import flash.events.Event;
		import flash.events.IEventDispatcher;
    }
	import org.apache.royale.core.IUIBase;

	/**
	 *  The AnimationUtil class wraps callbacks to be called when the platform is ready for the next draw.
	 *  (requestAnimationFrame in HTML and ENTER_FRAME in Flash)
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class AnimationUtil
	{
		
		COMPILE::SWF
		private static var requests:Object = {};
		/**
		 *  The callback is called with a high-rez timestamp as per the HTML spec
		 * 
		 *  @param callback.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public static function requestFrame(callback:Function, element:IUIBase ):String
		{
			COMPILE::SWF
			{
				var listener:IEventDispatcher;
				if(element is DisplayObject)
					listener = element;
				else if (Object(element).hasOwnProperty("$displayObject"))
					listener = element["$displayObject"];
				else
					throw new Error("Unknown element type");

				var uid:String  = UIDUtil.createUID();
				var wrappedCallback:Function = function(event:Event):void{
					callback.call(listener,new Date().getTime());
					requests[uid] = null;
					listener.removeEventListener(Event.ENTER_FRAME,callback);
				};
				requests[uid] = {callback:wrappedCallback,listener:listener};
				listener.addEventListener(Event.ENTER_FRAME,wrappedCallback);
				return uid;
			}

			COMPILE::JS
			{
				return "" + window["requestAnimationFrame"](callback);
			}

			//TODO do we need a Node.js implementation?

		}

		/**
		 *  Cancels the requestFrame with the specified id.
		 * 
		 *  @param id
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public static function cancelFrame(id:String):void
		{
			COMPILE::SWF
			{
				var request:Object = requests[id];
				if(request)
				{
					request.listener.removeEventListener(Event.ENTER_FRAME,request.callback);
					requests[id] = null;
				}
			}

			COMPILE::JS
			{
				window["cancelAnimationFrame"](Number(id));
			}

			//TODO do we need a Node.js implementation?
			
		}

	}
}
