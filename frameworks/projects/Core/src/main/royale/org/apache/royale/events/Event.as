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
    import org.apache.royale.core.IRoyaleElement;

    COMPILE::SWF {
        import flash.events.Event;
    }
        
	COMPILE::JS {
		import goog.events.Event;
	}

	/**
	 * This class simply wraps flash.events.Event so that
	 * no flash packages are needed on the JS side.
	 * At runtime, this class is not always the event object
	 * that is dispatched.  In most cases we are dispatching
	 * DOMEvents instead, so as long as you don't actually
	 * check the typeof(event) it will work
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10.2
	 * @playerversion AIR 2.6
	 * @productversion Royale 0.0
	 */
	COMPILE::SWF
	public class Event extends flash.events.Event implements IRoyaleEvent
	{

		//--------------------------------------
		//   Static Property
		//--------------------------------------

		public static const CHANGE:String = "change";
		public static const COMPLETE:String = "complete";
		public static const SELECT:String = "select";
		public static const OPEN:String = "open";
		public static const DEACTIVATE:String = "deactivate";
		public static const ADDED:String = "added";
		public static const REMOVED:String = "removed";
		
		//--------------------------------------
		//   Constructor
		//--------------------------------------

		/**
		 * Constructor.
		 *
		 * @param type The name of the event.
		 * @param bubbles Whether the event bubbles.
		 * @param cancelable Whether the event can be canceled.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.0
		 */
		public function Event(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		//--------------------------------------
		//   Property
		//--------------------------------------

		//--------------------------------------
		//   Function
		//--------------------------------------

		/**
		 * @private
		 */
		public override function clone():flash.events.Event
		{
			return cloneEvent() as flash.events.Event;
		}

		/**
		 * Create a copy/clone of the Event object.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.0
		 */
		public function cloneEvent():IRoyaleEvent
		{
			return new org.apache.royale.events.Event(type, bubbles, cancelable);
		}
        
        /**
         * Determine if the target is the same as the event's target.  The event's target
         * can sometimes be an internal target so this tests if the outer component
         * matches the potential target
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
		 * @royaleignorecoercion org.apache.royale.core.IRoyaleElement
         */
        public function isSameTarget(potentialTarget:IEventDispatcher):Boolean
        {
            if (potentialTarget == target)
				return true;
            if (target is IRoyaleElement && (target as IRoyaleElement).royale_wrapper == potentialTarget)
				return true;
            return false;
        }

        /**
         * defaultPrevented is true if <code>preventDefault()</code> was called.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
         */
        public function get defaultPrevented():Boolean
        {
        	return isDefaultPrevented();
        }
        
	}

    /**
     * This class simply wraps flash.events.Event so that
     * no flash packages are needed on the JS side.
     * At runtime, this class is not always the event object
     * that is dispatched.  In most cases we are dispatching
     * DOMEvents instead, so as long as you don't actually
     * check the typeof(event) it will work
     *
     * @langversion 3.0
     * @playerversion Flash 10.2
     * @playerversion AIR 2.6
     * @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
     */
    COMPILE::JS
    public class Event extends goog.events.Event implements IRoyaleEvent {

		public static const CHANGE:String = "change";
		public static const COMPLETE:String = "complete";
		public static const SELECT:String = "select";
		public static const OPEN:String = "open";
		public static const DEACTIVATE:String = "deactivate";
		public static const ADDED:String = "added";
		public static const REMOVED:String = "removed";

        public function Event(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
            super(type);
			this.bubbles = bubbles;
			this.cancelable = cancelable;
        }

		public var bubbles:Boolean;
		public var cancelable:Boolean;
				
		/**
		 * Google Closure doesn't seem to support stopImmediatePropagation, but
		 * actually the ElementWrapper fireListener override sends a
		 * BrowserEvent in most/all cases where folks need stopImmediatePropagation
		 * We're re-writing the goog behavior to stop immmediate propogation in EventDispatcher
		 */
		private var _immediatePropogationStopped:Boolean;

		public function get immediatePropogationStopped():Boolean
		{
			return _immediatePropogationStopped;
		}
		
		public function stopImmediatePropagation():void
		{
			_immediatePropogationStopped = true;
		}
		
		public function cloneEvent():IRoyaleEvent
		{
			return new org.apache.royale.events.Event(type, bubbles, cancelable);
		}

		public function isDefaultPrevented():Boolean
		{
			return defaultPrevented;
		}
        
        /**
         * Determine if the target is the same as the event's target.  The event's target
         * can sometimes be an internal target so this tests if the outer component
         * matches the potential target
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
         * @royaleignorecoercion Object
         */
        public function isSameTarget(potentialTarget:IEventDispatcher):Boolean
        {
            if (potentialTarget === target)
				return true;
            if (target is IRoyaleElement && (target as Object).royale_wrapper === potentialTarget)
				return true;
            return false;
        }

    }
}
