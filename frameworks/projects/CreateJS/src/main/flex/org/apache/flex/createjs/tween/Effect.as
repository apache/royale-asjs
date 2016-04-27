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
	import org.apache.flex.events.Event;
	
	import org.apache.flex.createjs.core.CreateJSBase;
	
	COMPILE::JS {
		import createjs.Tween;
		import createjs.Stage;
		import createjs.Ease;
		import createjs.Ticker;
	}
		
    /**
     * This is the base class for the CreateJS/TweenJS effects. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
     */
	public class Effect extends EventDispatcher
	{
		/**
		 * Constructor 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
        public function Effect(target:Object=null)
		{
			super();
			
			_actualTarget = target;
		}
		
		private var _target:Object;
		
		[Bindable("targetChanged")]
		/**
		 * The object upon which the effect is being made. This can be either an
		 * actual object or the ID (String) of an object.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get target():Object
		{
			return _target;
		}
		public function set target(value:Object):void
		{
			_target = value;
			if (value != null) {
				if (value is String) {
					// if this is an id, then look it up somehow - don't know how yet
				}
				else {
					_actualTarget = value;
				}
				
				dispatchEvent(new Event("targetChanged"));
			}
		}
		
		
		/**
		 * @private
		 */
		protected var _actualTarget:Object;
		
		/**
		 * The duration of the effect, defaults to 1000 (1 second).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var duration:Number = 1000;
		
		/**
		 * Determines if the effect should loop continuously or not. The default
		 * is false (do not loop).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var loop:Boolean = false;
		
		/**
		 * @private
		 * Returns the options necessary for an effect to take place. This is an
		 * internally used function.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function createTweenOptions():Object
		{
			// implement in subclass
			return null;
		}
		
		
		/**
		 *  Plays the effect on the target object 
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
			// supply in subclass
		}
	}
}
