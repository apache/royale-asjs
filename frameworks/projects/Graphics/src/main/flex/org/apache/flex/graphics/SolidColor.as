/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.flex.graphics
{
	import org.apache.flex.utils.CSSUtils;

    COMPILE::SWF
    {
		import flash.display.Graphics;
        import flash.geom.Point;
        import flash.geom.Rectangle;            
    }

	public class SolidColor implements IFill
	{
		
		/**
		 *  Constructor.
		 *
		 *  @param color Specifies the color.
		 *  The default value is 0x000000 (black).
		 *
		 *  @param alpha Specifies the level of transparency.
		 *  Valid values range from 0.0 (completely transparent)
		 *  to 1.0 (completely opaque).
		 *  The default value is 1.0.
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 9
	 	 *  @playerversion AIR 1.1
	 	 *  @productversion Flex 3
	 	 */
		public function SolidColor(color:uint = 0x000000, alpha:Number = 1.0)
	 	{
			super();

			this.color = color;
			this.alpha = alpha;
		}

		//----------------------------------
		//  alpha
		//----------------------------------
		
		private var _alpha:Number = 1.0;
		//----------------------------------
		//  color
		//----------------------------------
		
		private var _color:uint = 0x000000;
		
		/**
		 *  The transparency of a color.
		 *  Possible values are 0.0 (invisible) through 1.0 (opaque). 
		 *  
		 *  @default 1.0
		 *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion FlexJS 0.3
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
	     *  @productversion FlexJS 0.3
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
		
        COMPILE::SWF
		public function begin(g:Graphics,targetBounds:Rectangle,targetOrigin:Point):void
		{
			g.beginFill(color,alpha);
		}
		
        COMPILE::SWF
		public function end(g:Graphics):void
		{
			g.endFill();
		}
        
        /**
         * addFillAttrib()
         *
         * @param value The IGraphicShape object on which the fill must be added.
         * @return {string}
         */
        COMPILE::JS
        public function addFillAttrib(value:IGraphicShape):String
        {
            return 'fill:' + CSSUtils.attributeFromColor(color) + ';fill-opacity:' + alpha;
        }
	}
}
