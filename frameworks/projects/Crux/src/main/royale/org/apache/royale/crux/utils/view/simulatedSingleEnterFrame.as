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
/***
 * Based on the
 * Swiz Framework library by Chris Scott, Ben Clinkinbeard, Sönke Rohde, John Yanarella, Ryan Campbell, and others https://github.com/swiz/swiz-framework
 */
package org.apache.royale.crux.utils.view {
	
	import org.apache.royale.core.IFlexInfo;

	COMPILE::SWF{
		import flash.events.Event;
		import flash.display.DisplayObjectContainer;
		import flash.display.DisplayObject;
	}


	/**
	 * A utility function to execute a callback after a single 'enterframe'-like delay at appliction level
	 *
	 * @param container
	 * @param callback a function to execute after the 'frame' delay
	 * @param removeOnly set to true to erase a previously configured callback on the same container
	 *
	 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
	 */
	public function simulatedSingleEnterFrame(container:IFlexInfo, callback:Function, removeOnly:Boolean = false):void {
		if (!container) return ;
		COMPILE::SWF{

			var listener:Function = Support.map[container];
			if (listener != null) {
				DisplayObjectContainer(container).removeEventListener(Event.ENTER_FRAME, listener);
			}
			if (!removeOnly) {
				Support.map[container] = Support.getListener(callback, container);
				DisplayObjectContainer(container).addEventListener(Event.ENTER_FRAME, Support.map[container]);
			}

		}

		COMPILE::JS{
			//remove any existing
			var id:Number = Support.map.get(container);
			if (!isNaN(id)) cancelAnimationFrame(id);
			if (!removeOnly) {
				Support.map.set(container, requestAnimationFrame(Support.getListener(callback, container)));
			}
		}

	}
}

import org.apache.royale.core.IFlexInfo;
COMPILE::SWF{
	import flash.utils.Dictionary;
	import flash.events.Event;
	import flash.events.EventDispatcher;
}

class Support {

	COMPILE::JS
	public static const map:Map = new Map();

	COMPILE::SWF
	public static const map:Dictionary = new Dictionary();

	COMPILE::JS
	public static function getListener(callback:Function, container:IFlexInfo):Function {
		return function(timeStamp:Number):void{
				Support.map.delete(container);
				callback();
			};

	}

	COMPILE::SWF
	public static function getListener(callback:Function, container:IFlexInfo):Function {
		var f:Function = function(e:Event):void{
				EventDispatcher(container).removeEventListener(Event.ENTER_FRAME, f);
				delete Support.map[container];
				callback();
			};
		return f;
	}

}
