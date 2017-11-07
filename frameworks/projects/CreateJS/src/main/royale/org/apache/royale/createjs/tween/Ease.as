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
	COMPILE::JS {
		import createjs.Stage;
		import createjs.Ease;
	}
		
    /**
     * This is the base class for the CreateJS/TweenJS effects. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 1.0.0
     */
	public class Ease
	{
		/**
		 * Constructor 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
        public function Ease()
		{	
		}
		
		/**
		 * Mimics the simple -100 to 100 easing in Flash Pro.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		static public function get(value:Number) : Function
		{
			COMPILE::SWF {
				return null;
			}
				COMPILE::JS {
					return createjs.Ease.get(value);
				}
		}
		
		/**
		 * Configurable exponential ease.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		static public function getPowIn(value:Number) : Function
		{
			COMPILE::SWF {
				return null;
			}
			COMPILE::JS {
				return createjs.Ease.getPowIn(value);
			}
		}
		
		/**
		 * Configurable exponential ease.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		static public function getPowOut(value:Number) : Function
		{
			COMPILE::SWF {
				return null;
			}
				COMPILE::JS {
					return createjs.Ease.getPowOut(value);
				}
		}
		
		/**
		 * Configurable exponential ease.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		static public function getPowInOut(value:Number) : Function
		{
			COMPILE::SWF {
				return null;
			}
			COMPILE::JS {
				return createjs.Ease.getPowInOut(value);
			}
		}
		
		/**
		 * @method quadIn
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function quadIn() : Function
		{
			return getPowIn(2);
		}

		/**
		 * @method quadOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function quadOut() : Function
		{
			return getPowOut(2);
		}

		/**
		 * @method quadInOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function quadInOut() : Function
		{
			return getPowInOut(2);
		}
		
		/**
		 * @method cubicIn
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function cubicIn() : Function
		{
			return getPowIn(3);
		}

		/**
		 * @method cubicOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function cubicOut() : Function
		{
			return getPowOut(3);
		}

		/**
		 * @method cubicInOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function cubicInOut() : Function
		{
			return getPowInOut(3);
		}
		
		/**
		 * @method quartIn
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function quartIn() : Function
		{
			return getPowIn(4);
		}

		/**
		 * @method quartOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function quartOut() : Function
		{
			return getPowOut(4);
		}

		/**
		 * @method quartInOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function quartInOut() : Function
		{
			return getPowInOut(4);
		}
		
		/**
		 * @method quintIn
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function quintIn() : Function
		{
			return getPowIn(5);
		}

		/**
		 * @method quintOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function quintOut() : Function
		{
			return getPowOut(5);
		}

		/**
		 * @method quintInOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function quintInOut() : Function
		{
			return getPowInOut(5);
		}
		
		/**
		 * @method sineIn
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function sineIn(t:Number):Number {
			return 1-Math.cos(t*Math.PI/2);
		}
		
		/**
		 * @method sineOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function sineOut(t:Number):Number {
			return Math.sin(t*Math.PI/2);
		}

		
		/**
		 * @method sineInOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function sineInOut(t:Number):Number {
			return -0.5*(Math.cos(Math.PI*t) - 1);
		}
		
		/**
		 * Configurable "back in" ease.
		 * @method getBackIn
		 * @param {Number} amount The strength of the ease.
		 * @static
		 * @return {Function}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function getBackIn(amount:Number):Function {
			return function(t:Number):Number {
				return t*t*((amount+1)*t-amount);
			}
		}

		/**
		 * @method backIn
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function backIn():Function {
			return getBackIn(1.7);
		}
		
		/**
		 * Configurable "back out" ease.
		 * @method getBackOut
		 * @param {Number} amount The strength of the ease.
		 * @static
		 * @return {Function}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function getBackOut(amount:Number):Function {
			return function(t:Number):Number {
				return (--t*t*((amount+1)*t + amount) + 1);
			}
		}

		/**
		 * @method backOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function backOut():Function {
			return getBackOut(1.7);
		}

		
		/**
		 * Configurable "back in out" ease.
		 * @method getBackInOut
		 * @param {Number} amount The strength of the ease.
		 * @static
		 * @return {Function}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function getBackInOut(amount:Number):Function {
			amount *= 1.525;
			return function(t:Number):Number {
				if ((t*=2)<1) return 0.5*(t*t*((amount+1)*t-amount));
				return 0.5*((t-=2)*t*((amount+1)*t+amount)+2);
			}
		}

		/**
		 * @method backInOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function backInOut():Function {
			return getBackInOut(1.7);
		}
		
		/**
		 * @method circIn
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function circIn(t:Number):Number {
			return -(Math.sqrt(1-t*t)-1);
		}
		
		/**
		 * @method circOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function circOut(t:Number):Number {
			return Math.sqrt(1-(--t)*t);
		}
		
		/**
		 * @method circInOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function circInOut(t:Number):Number {
			if ((t*=2) < 1) return -0.5*(Math.sqrt(1-t*t)-1);
			return 0.5*(Math.sqrt(1-(t-=2)*t)+1);
		}
		
		/**
		 * @method bounceIn
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function bounceIn(t:Number):Number {
			return 1-bounceOut(1-t);
		}
		
		/**
		 * @method bounceOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		public static function bounceOut(t:Number):Number {
			if (t < 1/2.75) {
				return (7.5625*t*t);
			} else if (t < 2/2.75) {
				return (7.5625*(t-=1.5/2.75)*t+0.75);
			} else if (t < 2.5/2.75) {
				return (7.5625*(t-=2.25/2.75)*t+0.9375);
			} else {
				return (7.5625*(t-=2.625/2.75)*t +0.984375);
			}
		}
		
		/**
		 * @method bounceInOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function bounceInOut(t:Number):Number
		{
			if (t<0.5) return bounceIn (t*2) * .5;
			return bounceOut(t*2-1)*0.5+0.5;
		}
		
		/**
		 * Configurable elastic ease.
		 * @method getElasticIn
		 * @param {Number} amplitude
		 * @param {Number} period
		 * @static
		 * @return {Function}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function getElasticIn(amplitude:Number,period:Number):Function {
			var pi2:Number = Math.PI*2;
			return function(t:Number):Number {
				if (t==0 || t==1) return t;
				var s:Number = period/pi2*Math.asin(1/amplitude);
				return -(amplitude*Math.pow(2,10*(t-=1))*Math.sin((t-s)*pi2/period));
			};
		}

		/**
		 * @method elasticIn
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function elasticIn():Function {
			return getElasticIn(1,0.3);
		}
		
		/**
		 * Configurable elastic ease.
		 * @method getElasticOut
		 * @param {Number} amplitude
		 * @param {Number} period
		 * @static
		 * @return {Function}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function getElasticOut(amplitude:Number,period:Number):Function {
			var pi2:Number = Math.PI*2;
			return function(t:Number):Number {
				if (t==0 || t==1) return t;
				var s:Number = period/pi2 * Math.asin(1/amplitude);
				return (amplitude*Math.pow(2,-10*t)*Math.sin((t-s)*pi2/period )+1);
			};
		}
		
		/**
		 * @method elasticOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function elasticOut():Function {
			return getElasticOut(1,0.3);
		}
		
		/**
		 * Configurable elastic ease.
		 * @method getElasticInOut
		 * @param {Number} amplitude
		 * @param {Number} period
		 * @static
		 * @return {Function}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function getElasticInOut(amplitude:Number,period:Number):Function {
			var pi2:Number = Math.PI*2;
			return function(t:Number):Number {
				var s:Number = period/pi2 * Math.asin(1/amplitude);
				if ((t*=2)<1) return -0.5*(amplitude*Math.pow(2,10*(t-=1))*Math.sin( (t-s)*pi2/period ));
				return amplitude*Math.pow(2,-10*(t-=1))*Math.sin((t-s)*pi2/period)*0.5+1;
			};
		}

		/**
		 * @method elasticInOut
		 * @param {Number} t
		 * @static
		 * @return {Number}
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 **/
		static public function elasticInOut():Function {
			return getElasticInOut(1,0.3*1.5);
		}
	}
}
