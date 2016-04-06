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
    COMPILE::AS3
    {
        import flash.events.MouseEvent;
		import flash.display.InteractiveObject;
    }
    COMPILE::JS
    {
        import window.MouseEvent;
    }

    import org.apache.flex.core.IUIBase;
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
	COMPILE::AS3
	public class MouseEvent extends flash.events.MouseEvent
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
                                   clickCount:int = 0)
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
	}

	COMPILE::JS
	public class MouseEvent extends Event
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
								   clickCount:int = 0)
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
				for (j = 0; j < m; j++) {
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
			var out:window.MouseEvent = new window.MouseEvent(type);
			out.initMouseEvent(type, false, false,
				e.view, e.detail, e.screenX, e.screenY,
				e.clientX, e.clientY, e.ctrlKey, e.altKey,
				e.shiftKey, e.metaKey, e.button, e.relatedTarget);
			return out;
		};

	}
}
