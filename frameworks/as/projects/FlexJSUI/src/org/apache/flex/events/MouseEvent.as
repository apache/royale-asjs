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
    import flash.events.MouseEvent;
    
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
	public class MouseEvent extends Event
	{
		public static const MOUSE_DOWN:String = "mouseDown";
        public static const MOUSE_MOVE:String = "mouseMove";
		public static const MOUSE_UP:String = "mouseUp";
		public static const MOUSE_OUT:String = "mouseOut";
		public static const MOUSE_OVER:String = "mouseOver";
		public static const ROLL_OVER:String = "rollOver";
		public static const ROLL_OUT:String = "rollOut";
        public static const CLICK:String = "click";

        public static const UNCONVERTED_EVENTS:Object = { mouseWheel: 1 };
        
        /**
         *  A method used to copy properties from flash.events.MouseEvent to 
         *  org.apache.flex.events.Event.  The set of properties can be
         *  different based on platform and runtime.
         */
        public static var convert:Function = flashConvert;
        
        private static function flashConvert(event:flash.events.MouseEvent):org.apache.flex.events.MouseEvent
        {
            if (UNCONVERTED_EVENTS[event.type])
                return null;
            
            var newEvent:org.apache.flex.events.MouseEvent = 
                  new org.apache.flex.events.MouseEvent(event.type, event.bubbles, event.cancelable,
                                                        event.localX, event.localY, event.relatedObject,
                                                        event.ctrlKey, event.altKey, event.shiftKey,
                                                        event.buttonDown, event.delta);

            return newEvent;
        }
        
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
        
        private var _stagePoint:Point;
        
        public function get stageX():Number
        {
            if (!target) return localX;
            if (!_stagePoint)
            {
                var localPoint:Point = new Point(localX, localY);
                _stagePoint = PointUtils.localToGlobal(localPoint, IUIBase(target));
            }
            return _stagePoint.x;
        }
        
        public function get stageY():Number
        {
            if (!target) return localY;
            if (!_stagePoint)
            {
                var localPoint:Point = new Point(localX, localY);
                _stagePoint = PointUtils.localToGlobal(localPoint, IUIBase(target));
            }
            return _stagePoint.y;            
        }
	}
}