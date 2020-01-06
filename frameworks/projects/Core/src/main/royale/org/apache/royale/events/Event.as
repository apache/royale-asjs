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
	public class Event implements IRoyaleEvent {

		public static const CHANGE:String = "change";
		public static const COMPLETE:String = "complete";
		public static const SELECT:String = "select";
		public static const OPEN:String = "open";

    public function Event(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
      this.type = type;
			this.bubbles = bubbles;
			this.cancelable = cancelable;
    }

		public var type:String;
		private var _target:Object;

		public function get target():Object
		{
			return _target;
		}

		public function set target(value:Object):void
		{
			_target = value;
		}
		private var _currentTarget:Object;

		public function get currentTarget():Object
		{
			return _currentTarget;
		}

		public function set currentTarget(value:Object):void
		{
			_currentTarget = value;
		}
		public var bubbles:Boolean;
		public var cancelable:Boolean;
		
		private var _immediatePropogationStopped:Boolean;

		public function get immediatePropogationStopped():Boolean
		{
			return _immediatePropogationStopped;
		}
		
		private var _propogationStopped:Boolean;

		public function get propogationStopped():Boolean
		{
			return _propogationStopped;
		}
		public function stopPropagation():void
		{
			_propogationStopped = true;
		}

		public function stopImmediatePropagation():void
		{
			_immediatePropogationStopped = true;
		}
		private var _defaultPrevented:Boolean;
		public function preventDefault():void
		{	
			_defaultPrevented = true;
		}
		public function get defaultPrevented():Boolean
		{
			return _defaultPrevented;
		}
		public function isDefaultPrevented():Boolean
		{
			return _defaultPrevented;
		}
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
		 * @royaleignorecoercion Object
		 */
		public function isSameTarget(potentialTarget:IEventDispatcher):Boolean
		{
			if (potentialTarget == target)
				return true;
			if(getTargetWrapper(target) == potentialTarget)
				return true;
			return false;
		}

	}
}
