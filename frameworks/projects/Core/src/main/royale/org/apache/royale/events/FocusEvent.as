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
    COMPILE::SWF
    {
        import flash.display.InteractiveObject;
        import flash.events.Event;
        import flash.events.FocusEvent;
    }
    COMPILE::JS
    {
        import window.FocusEvent;
		import goog.events.BrowserEvent;
		import org.apache.royale.events.Event;
		import org.apache.royale.events.utils.EventUtils;
    }
    
    import org.apache.royale.core.IRoyaleElement;
    import org.apache.royale.geom.Point;
    import org.apache.royale.utils.PointUtils;
    import org.apache.royale.events.IBrowserEvent;

    /**
	 *  An object dispatches a FocusEvent object when the user changes the focus from one object in the display list to another
     *  
     *  There are four types of focus events:
     *      FocusEvent.FOCUS_IN
     *      FocusEvent.FOCUS_OUT
     *      FocusEvent.KEY_FOCUS_CHANGE
     *      FocusEvent.MOUSE_FOCUS_CHANGE
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
	 */
	COMPILE::SWF
	public class FocusEvent extends flash.events.MouseEvent implements IRoyaleEvent
	{
        private static function platformConstant(s:String):String
        {
            return s;
        }

        public static const FOCUS_IN:String = platformConstant("focusIn");
        public static const FOCUS_OUT:String = platformConstant("focusOut");
        public static const KEY_FOCUS_CHANGE:String = platformConstant("keyFocusChange");
        public static const MOUSE_FOCUS_CHANGE:String = platformConstant("mouseFocusChange");

        /**
         *  Constructor.
         *  Creates an Event object with specific information relevant to focus events.
         *
         *  @param type The name of the event.
         *  @param bubbles Whether the event bubbles.
         *  @param cancelable Whether the event can be canceled.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function FocusEvent(type:String, 
                                    bubbles:Boolean = true, 
                                    cancelable:Boolean = false, 
                                    relatedObject:InteractiveObject = null, 
                                    shiftKey:Boolean = false, 
                                    keyCode:uint = 0, 
                                    direction:String = "none",
                                    targetBeforeBubbling:IEventDispatcher = null)
        {
			super(type, bubbles, cancelable);

            this.relatedObject = relatedObject as InteractiveObject;
            this.shiftKey = shiftKey;
            // this.keyCode = keyCode;
            // this.direction = direction;
            this.targetBeforeBubbling = targetBeforeBubbling;
		}

        // TODO remove this when figure out how to preserve the real target
        public var targetBeforeBubbling:Object;
        
        // public var relatedObject:Object;
        // public var shiftKey:Boolean;
        // public var keyCode:uint;
        // public var direction:String;

        /**
         * @private
         */
		override public function clone():flash.events.Event
        {
            return cloneEvent() as flash.events.Event;
        }

        /**
         * Create a copy/clone of the Event object.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
         */
        public function cloneEvent():IRoyaleEvent
        {
            var e:org.apache.royale.events.FocusEvent = new org.apache.royale.events.FocusEvent(type, bubbles, cancelable);
                // relatedObject, shiftKey, keyCode, direction);
			e.targetBeforeBubbling = targetBeforeBubbling;
			return e;
        }
    }

    /**
     *  An object dispatches a FocusEvent object when the user changes the focus from one object in the display list to another
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     * 
     *  @royalesuppresspublicvarwarning
     */
	COMPILE::JS
    public class FocusEvent extends Event implements IRoyaleEvent, IBrowserEvent
    {
        private static function platformConstant(s:String):String
		{
			return s.toLowerCase();
		}

        public static const FOCUS_IN:String = platformConstant("focusIn");
        public static const FOCUS_OUT:String = platformConstant("focusOut");
        public static const KEY_FOCUS_CHANGE:String = platformConstant("keyFocusChange");
        public static const MOUSE_FOCUS_CHANGE:String = platformConstant("mouseFocusChange");

        public function FocusEvent(type:String, 
                                    bubbles:Boolean = true, 
                                    cancelable:Boolean = false, 
                                    relatedObject:Object = null, 
                                    shiftKey:Boolean = false, 
                                    keyCode:uint = 0, 
                                    direction:String = "none",
                                    targetBeforeBubbling:IEventDispatcher = null)
        {
            super(type, bubbles, cancelable);

            this.relatedObject = relatedObject;
            this.shiftKey = shiftKey;
            this.keyCode = keyCode;
            this.direction = direction;
        }

        /**
		 * @type {?goog.events.FocusEvent}
		 */
		private var wrappedEvent:Object;
		
		/**
		 * @type {FocusEvent}
		 */
		private var nativeEvent:Object;

		public function wrapEvent(event:goog.events.BrowserEvent):void
        {
            wrappedEvent = event;
			nativeEvent = event.getBrowserEvent();
        }

        public var relatedObject:Object;
        public var shiftKey:Boolean;
        public var keyCode:uint;
        public var direction:String;

        private var _target:Object;

		/**
         *  @copy org.apache.royale.events.BrowserEvent#target
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
		 */
        override public function get target():Object
		{
			return wrappedEvent ? getTargetWrapper(wrappedEvent.target) : _target;
		}
        override public function set target(value:Object):void
		{
			_target = value;
		}

        /**
         *  @copy org.apache.royale.events.BrowserEvent#currentTarget
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
		 */
        override public function get currentTarget():Object
		{
			return wrappedEvent ? getTargetWrapper(wrappedEvent.currentTarget) : _target;
		}
        override public function set currentTarget(value:Object):void
		{
			_target = value;
		}

		// TODO remove this when figure out how to preserve the real target
		// The problem only manifests in SWF, so this alias is good enough for now
		public function get targetBeforeBubbling():Object
		{
			return target;
		}

        /**
		 * Whether the default action has been prevented.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
		 */
		override public function preventDefault():void
		{
			if(wrappedEvent)
				wrappedEvent.preventDefault();
			else
			{
				super.preventDefault();
				_defaultPrevented = true;
			}
		}

		private var _defaultPrevented:Boolean;
		/**
		 * Whether the default action has been prevented.
		 * @type {boolean}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
		 */
        override public function get defaultPrevented():Boolean
		{
			return wrappedEvent ? wrappedEvent.defaultPrevented : _defaultPrevented;
		}
        override public function set defaultPrevented(value:Boolean):void
		{
			_defaultPrevented = value;
		}

        /**
         * Create a copy/clone of the Event object.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
         */
        override public function cloneEvent():IRoyaleEvent
        {
            return new org.apache.royale.events.FocusEvent(type, bubbles, cancelable,
                relatedObject, shiftKey, keyCode, direction);
        }
        /**
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
         */
		override public function stopImmediatePropagation():void
		{
            if(wrappedEvent)
            {
			    wrappedEvent.stopPropagation();
			    nativeEvent.stopImmediatePropagation();
            }
		}

        /**
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
         */
		override public function stopPropagation():void
		{
            if(wrappedEvent)
			    wrappedEvent.stopPropagation();
		}
    }
}