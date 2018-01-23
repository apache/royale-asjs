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
	import org.apache.royale.core.IDocument;
	import org.apache.royale.createjs.core.CreateJSBase;
	
	COMPILE::JS {
		import createjs.Tween;
		import createjs.Stage;
		import createjs.Ease;
		import createjs.Ticker;
	}
		
	COMPILE::SWF {
		import org.apache.royale.core.IUIBase;
		import org.apache.royale.events.Event;
		import org.apache.royale.effects.IEffect;
		import org.apache.royale.effects.Sequence;
		import org.apache.royale.effects.Parallel;
		import org.apache.royale.effects.Fade;
		import org.apache.royale.effects.Move;
	}
		
	[DefaultProperty("tweens")]
		
    /**
     * The Sequence effect plays a set of effects, one after the other. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 1.0.0
     */
	public class Sequence extends Effect implements IDocument
	{
		/**
		 * Constructor 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
        public function Sequence(target:Object=null)
		{
			super(target);
			
			_tweens = [];
			
			COMPILE::SWF {
				_sequence = new org.apache.royale.effects.Sequence();
			}
		}
		
		private var _tweens:Array;
		
		public function set tweens(value:Array):void
		{
			_tweens = value;
			
			
		}
		public function get tweens():Array
		{
			return _tweens;
		}
		
		public function addEffect(effect:Effect):void
		{
			_tweens.push(effect);
		}
		
		COMPILE::JS
		private var _tween:createjs.Tween;
		
		COMPILE::SWF
		private var _sequence:org.apache.royale.effects.Sequence;
		
		COMPILE::SWF
		public function internalEffect():IEffect
		{
			return _sequence;
		}
		
		/**
		 *  @private
		 *  The document.
		 */
		private var document:Object;
		
		public function setDocument(document:Object, id:String = null):void
		{
			this.document = document;	
			
			COMPILE::SWF {
				_sequence.setDocument(document);

				for (var i:int=0; i < _tweens.length; i++) {
					var tween:Tween = _tweens[i];
					var para:IEffect = tween.internalEffect();
					
					_sequence.addChild(para);
				}
			}
		}
		
		/**
		 *  Causes the effects in the tween list to be played, one after the other. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 *  @royaleignorecoercion createjs.Shape
		 *  @royaleignorecoercion org.apache.royale.createjs.core.CreateJSBase
		 */
		override public function play():void
		{
			COMPILE::JS {
				if (target != null) {
					_actualTarget = document[target] as CreateJSBase;
				}
				var element:createjs.Shape = _actualTarget.element as createjs.Shape;
				_tween = createjs.Tween.get(element, {loop: loop});
				_tween.setPaused(true);
				
				for (var i:int=0; i < _tweens.length; i++) {
					var e:Effect = _tweens[i] as Effect;
					var options:Object = e.createTweenOptions();
					
					var useEasing:Function = easing;
					if (e.easing != null) useEasing = e.easing;
					
					_tween.to( options, e.duration, useEasing);					
				}

				_tween.setPaused(false);
				var stage:createjs.Stage = element.getStage();
				createjs.Ticker.addEventListener("tick", stage);
			}
				
			COMPILE::SWF {
				_sequence.addEventListener("effectEnd", effectEndHandler);
				_sequence.play();
			}
		}
		
		/**
		 * @private
		 */
		COMPILE::SWF
		private function effectEndHandler(event:Event):void
		{
			if (loop) {
				_sequence.play();
			}
		}
	}
}
