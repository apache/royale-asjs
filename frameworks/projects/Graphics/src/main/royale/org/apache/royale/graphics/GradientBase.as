/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.royale.graphics
{
	import org.apache.royale.graphics.utils.CompoundTransform;

	public class GradientBase
	{
		
		protected var colors:Array /* of uint */ = [];
		
		protected var ratios:Array /* of Number */ = [];
		
		protected var alphas:Array /* of Number */ = [];
		
		/**
		 *  Holds the matrix and the convenience transform properties (<code>x</code>, <code>y</code>, and <code>rotation</code>).
		 *  The compoundTransform is only created when the <code>matrix</code> property is set. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 */
        COMPILE::SWF
		protected var compoundTransform:CompoundTransform;
		
		/**
		 *  Value of the width and height of the untransformed gradient
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 */ 
		public static const GRADIENT_DIMENSION:Number = 1638.4;
		
        /**
         *  generate uid
         */
        public function get newId():String
        {
            return 'gradient' + Math.floor((Math.random() * 100000) + 1);
        }

		/**
		 *  Storage for the entries property.
		 */
		private var _entries:Array = [];
		
		/**
		 *  @private
		 *  Storage for the rotation property.
		 */
		private var _rotation:Number = 0.0;
		
		/**
		 *  An Array of GradientEntry objects
		 *  defining the fill patterns for the gradient fill.
		 *
		 */
		public function get entries():Array
		{
			return _entries;
		}
		
		/**
		 *  @private
		 */
		public function set entries(value:Array):void
		{
			_entries = value;
            COMPILE::SWF
            {
                processEntries();                    
            }
		}
		
		/**
		 *  By default, the LinearGradientStroke defines a transition
		 *  from left to right across the control. 
		 *  Use the <code>rotation</code> property to control the transition direction. 
		 *  For example, a value of 180.0 causes the transition
		 *  to occur from right to left, rather than from left to right.
		 *
		 *  @default 0.0
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get rotation():Number
		{
			return _rotation;
		}
		
		/**
		 *  @private
		 */
		public function set rotation(value:Number):void
		{
			_rotation = value;   
		}
		
		
		private var _x:Number = 0;
		
		/**
		 *  The distance by which to translate each point along the x axis.
		 */
		public function get x():Number
		{
			return _x;
		}
		
		/**
		 *  @private
		 */
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		private var _y:Number = 0;
		
		/**
		 *  The distance by which to translate each point along the y axis.
		 */
		public function get y():Number
		{
			return _y;    
		}
		
		/**
		 *  @private
		 */
		public function set y(value:Number):void
		{
			_y = value;                
		}

		COMPILE::SWF
		protected function toRad(a:Number):Number {
			return a*Math.PI/180;
		}
		
		COMPILE::SWF
		protected function get rotationInRadians():Number
		{
			return rotation / 180 * Math.PI;
		}
		
		/**
		 *  @private
		 *  Extract the gradient information in the public <code>entries</code>
		 *  Array into the internal <code>colors</code>, <code>ratios</code>,
		 *  and <code>alphas</code> arrays.
		 */
        COMPILE::SWF
		private function processEntries():void
		{
			colors = [];
			ratios = [];
			alphas = [];
			
			if (!_entries || _entries.length == 0)
				return;
			
			var ratioConvert:Number = 255;
			
			var i:int;
			
			var n:int = _entries.length;
			for (i = 0; i < n; i++)
			{
				var e:GradientEntry = _entries[i];
				colors.push(e.color);
				alphas.push(e.alpha);
				ratios.push(e.ratio * ratioConvert);
			}
			
			if (isNaN(ratios[0]))
				ratios[0] = 0;
			
			if (isNaN(ratios[n - 1]))
				ratios[n - 1] = 255;
			
			i = 1;
			
			while (true)
			{
				while (i < n && !isNaN(ratios[i]))
				{
					i++;
				}
				
				if (i == n)
					break;
				
				var start:int = i - 1;
				
				while (i < n && isNaN(ratios[i]))
				{
					i++;
				}
				
				var br:Number = ratios[start];
				var tr:Number = ratios[i];
				
				for (var j:int = 1; j < i - start; j++)
				{
					ratios[j] = br + j * (tr - br) / (i - start);
				}
			}
		}

	}
}
