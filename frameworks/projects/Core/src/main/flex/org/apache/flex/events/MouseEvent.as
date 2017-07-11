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
package org.apache.flex.events
{
    COMPILE::SWF
    {
        import flash.display.InteractiveObject;
        import flash.events.Event;
        import flash.events.MouseEvent;
    }
    COMPILE::JS
    {
        import window.MouseEvent;
		import org.apache.flex.events.utils.EventUtils;
    }
    
    import org.apache.flex.core.IFlexJSElement;
    import org.apache.flex.geom.Point;
    import org.apache.flex.utils.PointUtils;


	/**
	 *  Mouse events
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
	 */
	COMPILE::SWF
	public class MouseEvent extends flash.events.MouseEvent implements IFlexJSEvent
	{
		//SWF constants are different than the JS ones
		public static const MOUSE_DOWN:String = "mouseDown";
        public static const MOUSE_MOVE:String = "mouseMove";
		public static const MOUSE_UP:String = "mouseUp";
		public static const MOUSE_OUT:String = "mouseOut";
		public static const MOUSE_OVER:String = "mouseOver";
		public static const ROLL_OVER:String = "rollOver";
		public static const ROLL_OUT:String = "rollOut";
        public static const CLICK:String = "click";
		public static const DOUBLE_CLICK:String = "doubleClick";
		public static const WHEEL : String = "mouseWheel";

         /**
         *  Constructor.
         *
         *  @param type The name of the event.
         *  @param bubbles Whether the event bubbles.
         *  @param cancelable Whether the event can be canceled.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function MouseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,
                                   localX:Number = NaN, localY:Number = NaN,
                                   relatedObject:Object = null,
                                   ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false,
                                   buttonDown:Boolean = false, delta:int = 0,
                                   commandKey:Boolean = false, controlKey:Boolean = false,
                                   clickCount:int = 0, targetBeforeBubbling:IEventDispatcher = null)
		{
			super(type, bubbles, cancelable);

            this.localX = localX;
            this.localY = localY;
            this.relatedObject = relatedObject as InteractiveObject;
            this.ctrlKey = ctrlKey;
            this.altKey = altKey;
            this.shiftKey = shiftKey;
            this.buttonDown = buttonDown;
            this.delta = delta;
			this.targetBeforeBubbling = targetBeforeBubbling;
		}

        // these map directly to JS MouseEvent fields.
        public function get clientX():Number
        {
            return screenX;
        }
        public function set clientX(value:Number):void
        {
            localX = value;
        }
        public function get clientY():Number
        {
            return screenY;
        }
        public function set clientY(value:Number):void
        {
            localY = value;
        }

        private var _stagePoint:Point;
		// TODO remove this when figure out how to preserve the real target
        public var targetBeforeBubbling:Object;

        public function get screenX():Number
        {
            if (!target) return localX;
            if (!_stagePoint)
            {
                var localPoint:Point = new Point(localX, localY);
				var referenceObject:Object = targetBeforeBubbling ? targetBeforeBubbling : target;
                _stagePoint = PointUtils.localToGlobal(localPoint, referenceObject);
            }
            return _stagePoint.x;
        }

        public function get screenY():Number
        {
            if (!target) return localY;
            if (!_stagePoint)
            {
                var localPoint:Point = new Point(localX, localY);
				var referenceObject:Object = targetBeforeBubbling ? targetBeforeBubbling : target;
                _stagePoint = PointUtils.localToGlobal(localPoint, referenceObject);
            }
            return _stagePoint.y;
        }
        
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
         * @productversion FlexJS 0.0
         */
        public function cloneEvent():IFlexJSEvent
        {
            var e:org.apache.flex.events.MouseEvent = new org.apache.flex.events.MouseEvent(type, bubbles, cancelable,
                localX, localY, relatedObject, ctrlKey, altKey, shiftKey,
                buttonDown, delta
                /* got errors for commandKey, commandKey, controlKey, clickCount*/);
			e.targetBeforeBubbling = targetBeforeBubbling;
			return e;
        }

        /**
         * Determine if the target is the same as the event's target.  The event's target
         * can sometimes be an internal target so this tests if the outer component
         * matches the potential target
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
         */
        public function isSameTarget(potentialTarget:IEventDispatcher):Boolean
        {
            if (potentialTarget === target) return true;
            if (target is IFlexJSElement)
                if (IFlexJSElement(target).flexjs_wrapper === potentialTarget) return true;
            return false;
        }

        /**
         * defaultPrevented is true if <code>preventDefault()</code> was called.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
         */
        public function get defaultPrevented():Boolean
        {
        	return isDefaultPrevented();
        }

	}

	COMPILE::JS
	public class MouseEvent extends Event implements IFlexJSEvent
	{
		//JS constants are different than the SWF ones
		public static const MOUSE_DOWN:String = "mousedown";
		public static const MOUSE_MOVE:String = "mousemove";
		public static const MOUSE_UP:String = "mouseup";
		public static const MOUSE_OUT:String = "mouseout";
		public static const MOUSE_OVER:String = "mouseover";
		public static const ROLL_OVER:String = "mouseenter";
		public static const ROLL_OUT:String = "mouseleave";
		public static const CLICK:String = "click";
		public static const DOUBLE_CLICK:String = "dblclick";
		public static const WHEEL : String = "wheel";

		/**
		 *  Constructor.
		 *
		 *  @param type The name of the event.
		 *  @param bubbles Whether the event bubbles.
		 *  @param cancelable Whether the event can be canceled.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function MouseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,
								   localX:Number = NaN, localY:Number = NaN,
								   relatedObject:Object = null,
								   ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false,
								   buttonDown:Boolean = false, delta:int = 0,
								   commandKey:Boolean = false, controlKey:Boolean = false,
								   clickCount:int = 0, targetBeforeBubbling:IEventDispatcher = null)
		{
			super(type, bubbles, cancelable);

			this.localX = localX;
			this.localY = localY;
			this.relatedObject = relatedObject;
			this.ctrlKey = ctrlKey;
			this.altKey = altKey;
			this.shiftKey = shiftKey;
			this.buttonDown = buttonDown;
			this.delta = delta;
			this.commandKey = commandKey;
			this.controlKey = controlKey;
			this.clickCount = clickCount;
		}

		private var _localX:Number;
		public function get localX():Number
		{
			return _localX;
		}
		public function set localX(value:Number):void
		{
			_localX = value;
			_stagePoint = null;
		}

		private var _localY:Number;
		public function get localY():Number
		{
			return _localY;
		}
		public function set localY(value:Number):void
		{
			_localY = value;
			_stagePoint = null;
		}

		public var relatedObject:Object;
		public var ctrlKey:Boolean;
		public var altKey:Boolean;
		public var shiftKey:Boolean;
		public var buttonDown:Boolean;
		public var delta:int;
		public var commandKey:Boolean;
		public var controlKey:Boolean;
		public var clickCount:int;

		// TODO remove this when figure out how to preserve the real target
		// The problem only manifests in SWF, so this alias is good enough for now
		public function get targetBeforeBubbling():Object
		{
			return target;
		}
		// these map directly to JS MouseEvent fields.
		public function get clientX():Number
		{
			return screenX;
		}
		public function set clientX(value:Number):void
		{
			localX = value;
		}
		public function get clientY():Number
		{
			return screenY;
		}
		public function set clientY(value:Number):void
		{
			localY = value;
		}

		private var _stagePoint:Point;
	
		public function get screenX():Number
		{
			if (!target) return localX;
			if (!_stagePoint)
			{
				var localPoint:Point = new Point(localX, localY);
				_stagePoint = PointUtils.localToGlobal(localPoint, target);
			}
			return _stagePoint.x;
		}

		public function get screenY():Number
		{
			if (!target) return localY;
			if (!_stagePoint)
			{
				var localPoint:Point = new Point(localX, localY);
				_stagePoint = PointUtils.localToGlobal(localPoint, target);
			}
			return _stagePoint.y;
		}

		/**
		 */
		private static var targets:Array = [];

		/**
		 * @param {string} type The event type.
		 * @param {Event} e The mouse event.
		 * @return {MouseEvent} The new event.
		 */
		private static function makeMouseEvent(type:String, e:window.MouseEvent):window.MouseEvent
		{
			var out:window.MouseEvent = EventUtils.createMouseEvent(type, false, false, {
                    view: e.view, detail: e.detail, screenX: e.screenX, screenY: e.screenY,
					clientX: e.clientX, clientY: e.clientY, ctrlKey: e.ctrlKey, altKey: e.altKey,
				    shiftKey: e.shiftKey, metaKey: e.metaKey, button: e.button, relatedTarget: e.relatedTarget});
			return out;
		};

        /**
         * Create a copy/clone of the Event object.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
         */
        override public function cloneEvent():IFlexJSEvent
        {
            return new org.apache.flex.events.MouseEvent(type, bubbles, cancelable,
                localX, localY, relatedObject, ctrlKey, altKey, shiftKey,
                buttonDown, delta
            /* got errors for commandKey, commandKey, controlKey, clickCount*/);
        }

	}
}
