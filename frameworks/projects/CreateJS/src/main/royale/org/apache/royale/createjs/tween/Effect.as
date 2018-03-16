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
package org.apache.royale.createjs.tween
{	
	import org.apache.royale.events.EventDispatcher;
	import org.apache.royale.events.Event;
	
	import org.apache.royale.createjs.core.CreateJSBase;
	
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
	 *  @productversion Royale 1.0.0
     */
	public class Effect extends EventDispatcher
	{
		/**
		 * Constructor 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
        public function Effect(target:CreateJSBase=null)
		{
			super();
			
			_actualTarget = target;
		}
		
		private var _target:String;
		
		[Bindable("targetChanged")]
		/**
		 * The name of the object upon which the effect is being made. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function get target():String
		{
			return _target;
		}
		public function set target(value:String):void
		{
			if (value != _target) {
				_target = value;
				dispatchEvent(new Event("targetChanged"));
			}
		}
		
		/**
		 * @private
		 */
		protected var _actualTarget:CreateJSBase;
		
		/**
		 * The duration of the effect, defaults to 1000 (1 second).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
         * 
         *  @royalesuppresspublicvarwarning
		 */
		public var duration:Number = 1000;
		
		/**
		 * Determines if the effect should loop continuously or not. The default
		 * is false (do not loop).
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
         * 
         *  @royalesuppresspublicvarwarning
		 */
		public var loop:Boolean = false;
		
		/**
		 * The easing function to apply.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		//public var easing:Function = null;
		private var _easing:Function = null;
		public function get easing():Function {
			return _easing;
		}
		public function set easing(value:Function):void {
			_easing = value;
		}
		
		/**
		 * @private
		 * Returns the options necessary for an effect to take place. This is an
		 * internally used function.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
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
		 *  @productversion Royale 1.0.0
		 *  @royaleignorecoercion createjs.Shape
		 *  @royaleignorecoercion org.apache.royale.createjs.core.CreateJSBase
		 */
		public function play():void
		{
			// supply in subclass
		}
	}
}
