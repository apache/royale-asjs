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
		import goog.events.BrowserEvent;
		import org.apache.flex.events.Event;
		import org.apache.flex.events.utils.EventUtils;
    }
    
    import org.apache.flex.core.IFlexJSElement;
    import org.apache.flex.geom.Point;
    import org.apache.flex.utils.PointUtils;
    import org.apache.flex.events.IBrowserEvent;


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
        private static function platformConstant(s:String):String
        {
            return s;
        }

		public static const MOUSE_DOWN:String = platformConstant("mouseDown");
        public static const MOUSE_MOVE:String = platformConstant("mouseMove");
		public static const MOUSE_UP:String = platformConstant("mouseUp");
		public static const MOUSE_OUT:String = platformConstant("mouseOut");
		public static const MOUSE_OVER:String = platformConstant("mouseOver");
		public static const ROLL_OVER:String = platformConstant("rollOver");
		public static const ROLL_OUT:String = platformConstant("rollOut");
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
	public class MouseEvent extends Event implements IFlexJSEvent, IBrowserEvent
	{
		private static function platformConstant(s:String):String
		{
			return s.toLowerCase();
		}

		public static const MOUSE_DOWN:String = platformConstant("mouseDown");
		public static const MOUSE_MOVE:String = platformConstant("mouseMove");
		public static const MOUSE_UP:String = platformConstant("mouseUp");
		public static const MOUSE_OUT:String = platformConstant("mouseOut");
		public static const MOUSE_OVER:String = platformConstant("mouseOver");
		public static const ROLL_OVER:String = platformConstant("rollOver");
		public static const ROLL_OUT:String = platformConstant("rollOut");
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

		/**
		 * @type {?goog.events.BrowserEvent}
		 */
		private var wrappedEvent:Object;

		public function wrapEvent(event:goog.events.BrowserEvent):void
        {
            wrappedEvent = event;
        }

		public var relatedObject:Object;
		public var ctrlKey:Boolean;
		public var altKey:Boolean;
		public var shiftKey:Boolean;
		private var _buttons:int = -1;
		public function get buttonDown():Boolean
		{
			if(_buttons > -1)
				return _buttons == 1;
			if(!wrappedEvent)
				return false;
			var ev:* = wrappedEvent.getBrowserEvent();
			//Safari does not yet support buttons
			if ('buttons' in ev)
				_buttons = ev["buttons"];
			else
				_buttons = ev["which"];
			return _buttons == 1;
		}
		public function set buttonDown(value:Boolean):void
		{
			_buttons = value ? 1 : 0;
		}

		public function get buttons():int
		{
			return _buttons;
		}
		public function set buttons(value:int):void
		{
			_buttons = value;
		}
		public var delta:int;
		public var commandKey:Boolean;
		public var controlKey:Boolean;
		public var clickCount:int;

        private var _target:Object;

		/**
         *  @copy org.apache.flex.events.BrowserEvent#target
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
		 */
		public function get target():Object
		{
			return wrappedEvent ? getTargetWrapper(wrappedEvent.target) : _target;
		}
		public function set target(value:Object):void
		{
			_target = value;
		}

		/**
         *  @copy org.apache.flex.events.BrowserEvent#currentTarget
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
		 */
		public function get currentTarget():Object
		{
			return wrappedEvent ? getTargetWrapper(wrappedEvent.currentTarget) : _target;
		}
		public function set currentTarget(value:Object):void
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
		 * X-coordinate relative to the window.
		 * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
		 */
		public function get clientX():Number
		{
			return wrappedEvent ? wrappedEvent.clientX : _localX;
		}

		public function get localX():Number
		{
			return clientX;
		}
		private var _localX:Number;

		public function set localX(value:Number):void
		{
			_localX = value;
		}

		/**
		 * Y-coordinate relative to the window.
		 * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
		 */
		public function get clientY():Number
		{
			return wrappedEvent ? wrappedEvent.clientY : _localY;
		}

		public function get localY():Number
		{
			return clientY;
		}

		private var _localY:Number;

		public function set localY(value:Number):void
		{
			_localY = value;
		}

		/**
		 * X-coordinate relative to the monitor.
		 * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
		 */
		public function get screenX():Number
		{
			if(wrappedEvent) return wrappedEvent.screenX;
			if (!target) return localX;
			return stagePoint.x;
		}

		/**
		 * Y-coordinate relative to the monitor.
		 * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
		 */
		public function get screenY():Number
		{
			if(wrappedEvent) return wrappedEvent.screenY;
			if (!target) return localY;
			return stagePoint.y;
		}
        private var _stagePoint:Point;
		private function get stagePoint():Point
		{
			if (!_stagePoint)
			{
				var localPoint:Point = new Point(localX, localY);
				_stagePoint = PointUtils.localToGlobal(localPoint, target);
			}
			return _stagePoint;
		}

		/**
		 * Whether the default action has been prevented.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
		 */
		override public function preventDefault():void
		{
			wrappedEvent ? wrappedEvent.preventDefault() : super.preventDefault();
		}

		private var _defaultPrevented:Boolean;
		/**
		 * Whether the default action has been prevented.
		 * @type {boolean}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
		 */
		public function get defaultPrevented():Boolean
		{
			return wrappedEvent ? wrappedEvent.defaultPrevented : _defaultPrevented;
		}
		public function set defaultPrevented(value:Boolean):void
		{
			_defaultPrevented = value;
		}

		/**
		 * @private
		 */
		private static function installRollOverMixin():Boolean
		{
			window.addEventListener(MOUSE_OVER,
				mouseOverHandler, false);
			return true;
		}


		/**
		 * @param e The event.
		 * RollOver/RollOut is entirely implemented in mouseOver because
		 * when a parent and child share an edge, you only get a mouseout
		 * for the child and not the parent and you need to send rollout
		 * to both.  A similar issue exists for rollover.
		 */
		private static function mouseOverHandler(e:MouseEvent):void
		{
			var j:int;
			var m:int;
			var outs:Array;
			var me:window.MouseEvent;
			var parent:Object;
			var target:Object = e.target.flexjs_wrapper;
			if (target == null)
				return; // probably over the html tag
			var targets:Array = MouseEvent.targets;
			var index:int = targets.indexOf(target);
			if (index != -1) {
				// get all children
				outs = targets.slice(index + 1);
				m = outs.length;
				for (j = 0; j < m; j++)
				{
					me = makeMouseEvent(
						ROLL_OUT, e);
					outs[j].element.dispatchEvent(me);
				}
				MouseEvent.targets = targets.slice(0, index + 1);
			}
			else {
				var newTargets:Array = [target];
				if (!('parent' in target))
					parent = null;
				else
					parent = target.parent;
				while (parent) {
					index = targets.indexOf(parent);
					if (index == -1) {
						newTargets.unshift(parent);
						if (!('parent' in parent))
							break;
						parent = parent.parent;
					}
					else {
						outs = targets.slice(index + 1);
						m = outs.length;
						for (j = 0; j < m; j++) {
							me = makeMouseEvent(
								ROLL_OUT, e);
							outs[j].element.dispatchEvent(me);
						}
						targets = targets.slice(0, index + 1);
						break;
					}
				}
				var n:int = newTargets.length;
				for (var i:int = 0; i < n; i++) {
					me = makeMouseEvent(
						ROLL_OVER, e);
					newTargets[i].element.dispatchEvent(me);
				}
				MouseEvent.targets = targets.concat(newTargets);
			}
		}


		/**
		 */
		private static var rollOverMixin:Boolean =
			installRollOverMixin();


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
        /**
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.9
         */
		override public function stopImmediatePropagation():void
		{
            if(wrappedEvent)
            {
			    wrappedEvent.stopPropagation();
			    wrappedEvent.getBrowserEvent().stopImmediatePropagation();
            }
		}

        /**
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.9
         */
		override public function stopPropagation():void
		{
            if(wrappedEvent)
			    wrappedEvent.stopPropagation();
		}

	}
}
