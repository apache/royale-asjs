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
package org.apache.flex.createjs.tween
{	
	import org.apache.flex.events.EventDispatcher;
	
	import org.apache.flex.createjs.core.CreateJSBase;
	
	COMPILE::JS {
		import createjs.Tween;
		import createjs.Stage;
		import createjs.Ease;
		import createjs.Ticker;
	}
		
    /**
     * The Move effect animates an object from one place to another. Once the
	 * target object is set, its starting position may be given (or its current
	 * location will be used) and an ending position given, the play() function
	 * is used to make the animation have effect. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
     */
	public class Move extends EventDispatcher
	{
		/**
		 * Constructor 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
        public function Move(target:Object=null)
		{
			super();
			
			actualTarget = target;
		}
		
		
		private var _actualTarget:Object;
		
		/**
		 *  @private
		 *  The actual target.
		 */
		public function get actualTarget():Object
		{
			return _actualTarget;
		}
		public function set actualTarget(value:Object):void
		{
			_actualTarget = value;
		}
		
		
		/**
		 *  Starting x value.  If NaN, the current x value is used 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var xFrom:Number;
		
		/**
		 *  Ending x value.  If NaN, the current x value is not changed 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var xTo:Number;
		
		/**
		 *  Starting y value.  If NaN, the current y value is used 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var yFrom:Number;
		
		/**
		 *  Ending y value.  If NaN, the current y value is not changed 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var yTo:Number;
		
		COMPILE::JS
		private var tween:createjs.Tween;
		
		/**
		 *  Causes the target object to move between its starting and ending positions. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 *  @flexignorecoercion createjs.Shape
		 *  @flexignorecoercion org.apache.flex.createjs.core.CreateJSBase
		 */
		public function play():void
		{
			COMPILE::JS {
				var target:CreateJSBase = actualTarget as CreateJSBase;
				var element:createjs.Shape = target.element as createjs.Shape;
				tween = createjs.Tween.get(element, {loop: false});
				
				var options:Object = {x:xTo, y:yTo};
				
				if (!isNaN(xFrom)) target.x = xFrom;
				if (!isNaN(yFrom)) target.y = yFrom;
				
				tween.to( options, 1000, createjs.Ease.getPowInOut(2));
				
				var stage:createjs.Stage = element.getStage();
				createjs.Ticker.addEventListener("tick", stage);
			}
		}
	}
}
