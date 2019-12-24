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
package org.apache.royale.events
{
	COMPILE::JS
	{
    import goog.events;
		import goog.events.Listener;
		import goog.events.EventTarget;
    import org.apache.royale.core.IChild;
		import org.apache.royale.events.Event;
	}

	COMPILE::SWF
	{
		import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
	}

	/**
	 * This class simply wraps flash.events.EventDispatcher so that
	 * no flash packages are needed on the JS side.
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.0
	 */
	COMPILE::SWF
	public class EventDispatcher extends flash.events.EventDispatcher implements org.apache.royale.events.IEventDispatcher
	{
		/**
		 * Constructor.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.0
		 */
		public function EventDispatcher(target:org.apache.royale.events.IEventDispatcher = null)
		{
			super(target as flash.events.IEventDispatcher);
		}
	}

	COMPILE::JS
	public class EventDispatcher extends goog.events.EventTarget implements IEventDispatcher
	{
		
		private var _dispatcher:IEventDispatcher;
        public function EventDispatcher(target:IEventDispatcher = null)
        {
            _dispatcher = target || this;
        }
        
        public function hasEventListener(type:String):Boolean
        {
            return goog.events.hasListener(this, type);
        }
		
		override public function dispatchEvent(event1:Object):Boolean
		{
			//we get quite a few string events here, "initialize" etc
			//so this general approach doesn't work:
			//event.target = _dispatcher;
			if (event1) {
				if (typeof event1 == "string") {
					event1 = new Event("" + event1);
					event1.target = _dispatcher;
					//console.log("created event from string ",event);
				}
				else if ("target" in event1) {
					event1.target = _dispatcher;
					//console.log("assigned target to event ",event);
				}
			} else return false;

			return super.dispatchEvent(event1);
		}
		/**
		 * @royaleignorecoercion org.apache.royale.core.IChild
		 * @royaleemitcoercion org.apache.royale.events.EventDispatcher
		 */
		override public function getParentEventTarget():goog.events.EventTarget{
			return (this as IChild).parent as EventDispatcher;
		}
		override public function fireListeners(type:Object, capture:Boolean, eventObject:Object):Boolean{
			var listenerArray:Array = getListeners(type, capture);
			if (!listenerArray) {
				return true;
			}
			listenerArray = listenerArray.concat();

			var rv:Boolean = true;
			for (var i:int = 0; i < listenerArray.length; ++i) {
				if(eventObject.immediatePropogationStopped){
					break;
				}
				var listener:goog.events.Listener = listenerArray[i];
				// We might not have a listener if the listener was removed.
				if (listener && !listener.removed && listener.capture == capture) {
					var listenerFn:Object = listener.listener;
					var listenerHandler:Object = listener.handler || listener.src;

					if (listener.callOnce) {
						this.unlistenByKey(listener);
					}
					rv = listenerFn.call(listenerHandler, eventObject) !== false && rv;
				}
			}

			return rv && eventObject.returnValue_ != false;			
		}

		public function toString():String
        {
            return "[object Object]";
        }
		private static function installOverride():Boolean{
			goog.events.EventTarget.dispatchEventInternal_ = dispatchEventInternal;
			return true;
		}
		private static var overrideInstalled:Boolean = installOverride();
		/**
 * Dispatches the given event on the ancestorsTree.
 *
 * @param {!Object} target The target to dispatch on.
 * @param {goog.events.Event|Object|string} e The event object.
 * @param {Array<goog.events.Listenable>=} opt_ancestorsTree The ancestors
 *     tree of the target, in reverse order from the closest ancestor
 *     to the root event target. May be null if the target has no ancestor.
 * @return {boolean} If anyone called preventDefault on the event object (or
 *     if any of the listeners returns false) this will also return false.
 * @private
 */
private static function dispatchEventInternal(target:EventDispatcher, e:org.apache.royale.events.Event, opt_ancestorsTree:Array):Boolean {
  /** @suppress {missingProperties} */
  var type:String = e.type;

  var rv:Boolean = true, currentTarget:Object;

  // Executes all capture listeners on the ancestors, if any.
  if (opt_ancestorsTree) {
    for (var i:int = opt_ancestorsTree.length - 1; !e.propagationStopped_ && i >= 0;
         i--) {
      currentTarget = e.currentTarget = opt_ancestorsTree[i];
      rv = currentTarget.fireListeners(type, true, e) && rv;
    }
  }

  // Executes capture and bubble listeners on the target.
  if (!e.propagationStopped_) {
    currentTarget = e.currentTarget = target;
    rv = currentTarget.fireListeners(type, true, e) && rv;
    if (!e.propagationStopped_) {
      rv = currentTarget.fireListeners(type, false, e) && rv;
    }
  }

  // Executes all bubble listeners on the ancestors, if any.
  if (opt_ancestorsTree && e.bubbles) {
    for (i = 0; !e.propagationStopped_ && i < opt_ancestorsTree.length; i++) {
      currentTarget = e.currentTarget = opt_ancestorsTree[i];
      rv = currentTarget.fireListeners(type, false, e) && rv;
    }
  }

  return rv;
};
	}
}
