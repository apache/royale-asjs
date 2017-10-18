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
	COMPILE::SWF
	{
		import flash.display.Graphics;
	}

	public class GradientEntry
	{
		
		//----------------------------------
		//  alpha
		//----------------------------------
		
		private var _alpha:Number = 1.0;
		//----------------------------------
		//  color
		//----------------------------------
		
		private var _color:uint = 0x000000;
		//----------------------------------
		//  ratio
		//----------------------------------
		
		private var _ratio:Number = 0x000000;
		
		
		public function GradientEntry(alpha:Number = 1.0, color:uint = 0x000000, ratio:Number = 1.0)
		{
			_alpha = alpha;
			_color = color;
			_ratio = ratio;
		}
		
		/**
		 *  The transparency of a color.
		 *  Possible values are 0.0 (invisible) through 1.0 (opaque). 
		 *  
		 *  @default 1.0
		 *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.3
		 */
		public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set alpha(value:Number):void
		{
			var oldValue:Number = _alpha;
			if (value != oldValue)
			{
				_alpha = value;
			}
		}
		
		/**
		 *  A color value. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
	     *  @productversion Royale 0.3
		 */
		public function get color():uint
		{
			return _color;
		}
		
		public function set color(value:uint):void
		{
			var oldValue:uint = _color;
			if (value != oldValue)
			{
				_color = value;
			}
		}
		
		/**
		 *  Where in the graphical element, as a percentage from 0.0 to 1.0,
     	 *  Flex samples the associated color at 100%.  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
	     *  @productversion Royale 0.3
		 */
		public function get ratio():Number
		{
			return _ratio;
		}

		public function set ratio(value:Number):void
		{
			_ratio = value;
		}
		
		/**
		 * Begin drawing the fill on the given shape's graphic object
		 */
		COMPILE::SWF
		public function begin(g:Graphics):void
		{
            g.beginFill(color,alpha);                    
		}
		
		/**
		 * End the fill
		 */
		COMPILE::SWF
		public function end(g:Graphics):void
		{
			g.endFill();
		}

	}
}
