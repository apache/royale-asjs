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
	import org.apache.flex.core.IDocument;
	import org.apache.flex.createjs.core.CreateJSBase;
	
	COMPILE::JS {
		import createjs.Tween;
		import createjs.Stage;
		import createjs.Ease;
		import createjs.Ticker;
	}
		
    /**
     * The Tween effect animates an object from one place to another; it can also
	 * fade and object in and out by adjusting the object's alpha value. Once the
	 * target object is set, its starting position may be given (or its current
	 * location will be used) and an ending position given, the play() function
	 * is used to make the animation have effect. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
     */
	public class Tween extends Effect implements IDocument
	{
		/**
		 * Constructor 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
        public function Tween(target:Object=null)
		{
			super(target);
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
		
		/**
		 *  Starting alpha value.  If NaN, the current alpha value is used 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var alphaFrom:Number;
		
		/**
		 *  Ending alpha value.  If NaN, the current alpha value is not changed 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public var alphaTo:Number;
		
		/**
		 *  @private
		 *  The document.
		 */
		private var document:Object;
		
		public function setDocument(document:Object, id:String = null):void
		{
			this.document = document;	
		}
		
		
		COMPILE::JS
		private var _tween:createjs.Tween;
		
		/**
		 * @private
		 * @flexjsignorecoercion createjs.Shape
		 * @flexjsignorecoercion createjs.Tween
		 * @flexjsignorecoercion org.apache.flex.createjs.core.CreateJSBase
		 */
		override public function createTweenOptions():Object
		{
			COMPILE::SWF {
				return null;
			}
			COMPILE::JS {
				if (target != null) {
					_actualTarget = document[target] as CreateJSBase;
				}
				var element:createjs.Shape = _actualTarget.element as createjs.Shape;
				
				// initialize options with the original values. if target values
				// are supplied, replace the original values with the targets.
				var options:Object = {};
				if (!isNaN(xTo)) options["x"] = xTo;
				if (!isNaN(yTo)) options["y"] = yTo;
				if (!isNaN(alphaTo)) options["alpha"] = alphaTo;
				
				// if precondition values are set, move or set the target accordingly.
				if (!isNaN(xFrom)) _actualTarget.x = xFrom;
				if (!isNaN(yFrom)) _actualTarget.y = yFrom;
				if (!isNaN(alphaFrom)) _actualTarget.alpha = alphaFrom;
				
				return options;
			}
		}
		
		/**
		 *  Causes the target object to move between its starting and ending positions. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 *  @flexjsignorecoercion createjs.Shape
		 *  @flexjsignorecoercion createjs.Tween
		 *  @flexjsignorecoercion org.apache.flex.createjs.core.CreateJSBase
		 */
		override public function play():void
		{
			COMPILE::JS {
				if (target != null) {
					_actualTarget = document[target] as CreateJSBase;
				}
				var element:createjs.Shape = _actualTarget.element as createjs.Shape;
				_tween = createjs.Tween.get(element, {loop: loop});

				var options:Object = createTweenOptions();
				_tween.to(options, duration, createjs.Ease.getPowInOut(2));
				
				var stage:createjs.Stage = element.getStage();
				createjs.Ticker.addEventListener("tick", stage);
			}
		}
	}
}
