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
    import org.apache.royale.events.MouseEvent;
    
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
        
        import org.apache.royale.core.ElementWrapper;
        import org.apache.royale.events.Event;
        import org.apache.royale.events.utils.MouseEventConverter;
    }
    
    import org.apache.royale.core.IRoyaleElement;
    import org.apache.royale.events.IBrowserEvent;
    import org.apache.royale.geom.Point;
    import org.apache.royale.utils.PointUtils;
    import org.apache.royale.utils.OSUtils;
    
    
    /**
     *  Mouse events
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    COMPILE::SWF
    public class MouseEvent extends flash.events.MouseEvent implements IRoyaleEvent
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
        public static const WHEEL:String = "mouseWheel";
        
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
         *  @productversion Royale 0.0
         */
        public function MouseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
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
         *  The horizontal scroll delta for wheel events
         *  In Flash this always returns 0.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9
         */
        public function get deltaX():int
        {
            return 0;
        }
        
        /**
         * Horizontal wheel events are not supported in Flash
         */
        public function set deltaX(value:int):void
        {
        
        }
        
        /**
         *  The vertical scroll delta for wheel events
         *  In Flash this just proxies to the delta
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9
         */
        public function get deltaY():int
        {
            return delta
        }
        
        public function set deltaY(value:int):void
        {
            delta = value;
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
            var e:org.apache.royale.events.MouseEvent = new org.apache.royale.events.MouseEvent(type, bubbles, cancelable,
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
         * @productversion Royale 0.0
         * @royaleignorecoercion org.apache.royale.core.IRoyaleElement
         */
        public function isSameTarget(potentialTarget:IEventDispatcher):Boolean
        {
            if (potentialTarget == target) return true;
            if (target is IRoyaleElement)
                if ((target as IRoyaleElement).royale_wrapper == potentialTarget) return true;
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
     *  Mouse events
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     *
     *  @royalesuppresspublicvarwarning
     */
    COMPILE::JS
    public class MouseEvent extends Event implements IRoyaleEvent, IBrowserEvent
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
        public static const WHEEL:String = "wheel";
        
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
         *  @productversion Royale 0.0
         */
        public function MouseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
                                   localX:Number = NaN, localY:Number = NaN,
                                   relatedObject:Object = null,
                                   ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false,
                                   buttonDown:Boolean = false, delta:int = 0,
                                   metaKey:Boolean = false, controlKey:Boolean = false,
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
            this.metaKey = metaKey;
            this.clickCount = clickCount;
        }
        
        /**
         * @type {?goog.events.BrowserEvent}
         */
        private var wrappedEvent:Object;
        
        /**
         * @type {MouseEvent}
         * @royalesuppresspublicvarwarning
         */
        public var nativeEvent:Object;
        
        public function wrapEvent(event:goog.events.BrowserEvent):void
        {
            wrappedEvent = event;
            nativeEvent = event.getBrowserEvent();
            // for wrapped events, proxy the button values to the native events
            _button = -1;
            _buttons = -1;
        }
        
        public var relatedObject:Object;
        private var _ctrlKey:Boolean;

        public function get ctrlKey():Boolean
        {
        	return wrappedEvent ? wrappedEvent.ctrlKey : _ctrlKey;
        }

        public function set ctrlKey(value:Boolean):void
        {
            if(wrappedEvent)
                wrappedEvent.ctrlKey = value;
            else 
                _ctrlKey = value;
        }
        private var _altKey:Boolean;

        public function get altKey():Boolean
        {
        	return wrappedEvent ? wrappedEvent.altKey : _altKey;
        }

        public function set altKey(value:Boolean):void
        {
            if(wrappedEvent)wrappedEvent.altKey = value;
            else _altKey = value;
        }
        private var _shiftKey:Boolean;

        public function get shiftKey():Boolean
        {
        	return wrappedEvent ? wrappedEvent.shiftKey : _shiftKey;
        }

        public function set shiftKey(value:Boolean):void
        {
            if(wrappedEvent)wrappedEvent.shiftKey = value;
            else _shiftKey = value;
        }
        private var _metaKey:Boolean;

        public function get metaKey():Boolean
        {
            return wrappedEvent ? wrappedEvent.metaKey : _metaKey;
        }

        public function set metaKey(value:Boolean):void
        {
            if(wrappedEvent)wrappedEvent.metaKey = value;
            else _metaKey = value;
        }

        private var _buttons:int = -1;
        
        public function get buttonDown():Boolean
        {
            return button > -1 && button < 3;
        }
        
        public function set buttonDown(value:Boolean):void
        {
            _button = value ? 0 : 9;// any value over 2 will be interpreted as no button down
        }
        
        private var _button:int = -1;
        
        /**
         * see https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/button
         */
        public function get button():int
        {
            if (_button > -1)
                return _button;
            return nativeEvent["button"];
        }
        
        public function set button(value:int):void
        {
            _button = value;
        }
        
        /**
         * see https://developer.mozilla.org/en-US/docs/Web/API/MouseEvent/buttons
         */
        public function get buttons():int
        {
            if (_buttons > -1)
                return _buttons;
            return nativeEvent["buttons"];
        }
        
        public function set buttons(value:int):void
        {
            _buttons = value;
        }
        
        private var _delta:int;
        /**
         *  The vertical scroll delta for wheel events
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9
         */
        public function get delta():int
        {
            return nativeEvent ? nativeEvent.deltaY : _delta;
        }
        
        public function set delta(value:int):void
        {
            _delta = value;
        }
        
        private var _deltaX:int;
        /**
         *  The horizontal scroll delta for wheel events
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9
         */
        public function get deltaX():int
        {
            return nativeEvent ? nativeEvent.deltaX : _deltaX;
        }
        
        public function set deltaX(value:int):void
        {
            _deltaX = value;
        }
        
        private var _deltaY:int;
        /**
         *  The vertical scroll delta for wheel events
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9
         */
        public function get deltaY():int
        {
            return nativeEvent ? nativeEvent.deltaY : _deltaY;
        }
        
        public function set deltaY(value:int):void
        {
            _deltaY = value;
        }
        
        public var clickCount:int;
        
        private var _target:Object;
        
        /**
         *  @copy org.apache.royale.events.BrowserEvent#target
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
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
         * @productversion Royale 0.0
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
         * X-coordinate relative to the window.
         * @type {number}
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
         */
        public function get clientX():Number
        {
            return wrappedEvent ? wrappedEvent.clientX : _localX;
        }
        
        public function get localX():Number
        {
            return wrappedEvent ? wrappedEvent.clientX - wrappedEvent.currentTarget.getBoundingClientRect().left : _localX;
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
         * @productversion Royale 0.0
         */
        public function get clientY():Number
        {
            return wrappedEvent ? wrappedEvent.clientY : _localY;
        }
        
        public function get localY():Number
        {
            return wrappedEvent ? wrappedEvent.clientY - wrappedEvent.currentTarget.getBoundingClientRect().top : _localY;
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
         * @productversion Royale 0.0
         */
        public function get screenX():Number
        {
            if (wrappedEvent) return wrappedEvent.screenX;
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
         * @productversion Royale 0.0
         */
        public function get screenY():Number
        {
            if (wrappedEvent) return wrappedEvent.screenY;
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
         * @productversion Royale 0.0
         */
        override public function preventDefault():void
        {
            if (wrappedEvent)
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
         * @productversion Royale 0.0
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
            var target:Object = e.target.royale_wrapper;
            if (target == null)
                return; // probably over the html tag
            var targets:Array = MouseEvent.targets;
            var index:int = targets.indexOf(target);
            if (index != -1)
            {
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
            } else
            {
                var newTargets:Array = [target];
                if (!('parent' in target))
                    parent = null;
                else
                    parent = target.parent;
                while (parent)
                {
                    index = targets.indexOf(parent);
                    if (index == -1)
                    {
                        newTargets.unshift(parent);
                        if (!('parent' in parent))
                            break;
                        parent = parent.parent;
                    } else
                    {
                        outs = targets.slice(index + 1);
                        m = outs.length;
                        for (j = 0; j < m; j++)
                        {
                            me = makeMouseEvent(
                                    ROLL_OUT, e);
                            outs[j].element.dispatchEvent(me);
                        }
                        targets = targets.slice(0, index + 1);
                        break;
                    }
                }
                var n:int = newTargets.length;
                for (var i:int = 0; i < n; i++)
                {
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
            var out:window.MouseEvent = MouseEvent.createMouseEvent(type, false, false, {
                view: e.view, detail: e.detail, screenX: e.screenX, screenY: e.screenY,
                clientX: e.clientX, clientY: e.clientY, ctrlKey: e.ctrlKey, altKey: e.altKey,
                shiftKey: e.shiftKey, metaKey: e.metaKey, button: e.button, relatedTarget: e.relatedTarget
            });
            return out;
        };
        
        /**
         * Create a copy/clone of the Event object.
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.0
         */
        override public function cloneEvent():IRoyaleEvent
        {
            return new org.apache.royale.events.MouseEvent(type, bubbles, cancelable,
                    localX, localY, relatedObject, ctrlKey, altKey, shiftKey,
                    buttonDown, delta
                    /* got errors for commandKey, commandKey, controlKey, clickCount*/);
        }
        
        /**
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9
         */
        override public function stopImmediatePropagation():void
        {
            if (wrappedEvent)
            {
                wrappedEvent.stopPropagation();
                nativeEvent.stopImmediatePropagation();
            }
        }
        
        /**
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9
         */
        override public function stopPropagation():void
        {
            if (wrappedEvent)
                wrappedEvent.stopPropagation();
        }
        
        public static function setupConverter():Boolean
        {
            ElementWrapper.converterMap["MouseEvent"] = MouseEventConverter.convert;
            _useNativeConstructor = typeof window.MouseEvent == 'function';
            return true;
        }
        
        public static var initialized:Boolean = setupConverter();
        private static var _useNativeConstructor:Boolean;
        
        /**
         * @royaleignorecoercion MouseEventInit
         */
        public static function createMouseEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false,
                                                params:Object = null):Object
        {
            var mouseEvent:Object = null;
            
            if (!params)
                params = {};
            
            if (_useNativeConstructor)
            {
                params.bubbles = bubbles;
                params.cancelable = cancelable;
                mouseEvent = new window.MouseEvent(type, params as window.MouseEventInit);
            } else
            {
                mouseEvent = document.createEvent('MouseEvent');
                mouseEvent.initMouseEvent(type, bubbles, cancelable, params.view,
                        params.detail, params.screenX, params.screenY, params.clientX, params.clientY,
                        params.ctrlKey, params.altKey, params.shiftKey, params.metaKey, params.button, params.relatedTarget);
                
            }
            return mouseEvent;
        }
    }
}
