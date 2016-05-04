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
	import org.apache.flex.createjs.core.CreateJSBase;
	
	COMPILE::JS {
		import createjs.Tween;
		import createjs.Stage;
		import createjs.Ease;
		import createjs.Ticker;
	}
		
    /**
     * The Sequence effect plays a set of effects, one after the other. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
     */
	public class Sequence extends Effect
	{
		/**
		 * Constructor 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
        public function Sequence(target:Object=null)
		{
			super(target);
			
			_tweens = [];
		}
		
		private var _tweens:Array;
		
		public function addEffect(effect:Effect):void
		{
			_tweens.push(effect);
		}
		
		COMPILE::JS
		private var _tween:createjs.Tween;
		
		/**
		 *  Causes the effects in the tween list to be played, one after the other. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 *  @flexignorecoercion createjs.Shape
		 *  @flexignorecoercion org.apache.flex.createjs.core.CreateJSBase
		 */
		override public function play():void
		{
			COMPILE::JS {
				var target:CreateJSBase = _actualTarget as CreateJSBase;
				var element:createjs.Shape = target.element as createjs.Shape;
				_tween = createjs.Tween.get(element, {loop: loop});
				_tween.setPaused(true);
				
				if (easing == null) {
					easing = org.apache.flex.createjs.tween.Ease.getPowInOut(2);
				}
				
				for (var i:int=0; i < _tweens.length; i++) {
					var e:Effect = _tweens[i] as Effect;
					var options:Object = e.createTweenOptions();
					_tween.to( options, e.duration, easing);					
				}

				_tween.setPaused(false);
				var stage:createjs.Stage = element.getStage();
				createjs.Ticker.addEventListener("tick", stage);
			}
		}
	}
}
