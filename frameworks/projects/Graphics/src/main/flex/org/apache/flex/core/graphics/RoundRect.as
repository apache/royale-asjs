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

package org.apache.flex.core.graphics
{
    COMPILE::AS3
    {
        import flash.display.CapsStyle;
        import flash.display.JointStyle;
        import flash.geom.Point;
        import flash.geom.Rectangle;            
    }
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

	public class RoundRect extends GraphicShape
	{
		
		/**
		 *  Draw the rectangle.
		 *  @param x The x position of the top-left corner of the rectangle.
		 *  @param y The y position of the top-left corner.
		 *  @param width The width of the rectangle.
		 *  @param height The height of the rectangle.
		 *  @param rx The width of the ellipse that draws the rounded corners.
		 *  @param ry The height of the ellipse that draws the rounded corners.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		public function drawRoundRect(x:Number, y:Number, width:Number, height:Number, rx:Number, ry:Number):void
		{
            COMPILE::AS3
            {
                graphics.clear();
                applyStroke();
                beginFill(new Rectangle(x, y, width, height), new Point(x,y));
                graphics.drawRoundRect(x, y, width, height, rx, ry);
                endFill();                    
            }
            COMPILE::JS
            {
                var style:String = this.getStyleStr();
                var rect:WrappedHTMLElement = document.createElementNS('http://www.w3.org/2000/svg', 'rect') as WrappedHTMLElement;
                rect.flexjs_wrapper = this;
                rect.setAttribute('style', style);
                if (stroke)
                {
                    rect.setAttribute('x', String(stroke.weight / 2) + 'px');
                    rect.setAttribute('y', String(stroke.weight / 2) + 'px');
                    setPosition(x, y, stroke.weight, stroke.weight);
                }
                else
                {
                    rect.setAttribute('x', '0' + 'px');
                    rect.setAttribute('y', '0' + 'px');
                    setPosition(x, y, 0, 0);
                }
                rect.setAttribute('width', String(width) + 'px');
                rect.setAttribute('height', String(height) + 'px');
				rect.setAttribute('rx', String(rx) + 'px');
				rect.setAttribute('ry', String(ry) + 'px');
                element.appendChild(rect);
                
                resize(x, y, rect['getBBox']());
            }
		}
		
		override protected function draw():void
		{
			drawRoundRect(0,0,width,height, rx, ry);
		}
		
		private var _rx:Number;
		private var _ry:Number;
		
		public function get rx():Number
		{
			return _rx;
		}
		
		/**
		 *  The width of the ellipse used to draw the rounded corners.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion FlexJS 0.0
		 */
		public function set rx(value:Number):void
		{
			_rx = value;
		}
		
		public function get ry():Number
		{
			return _ry;
		}
		/**
		 *  The height of the ellipse used to draw the rounded corners.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion FlexJS 0.0
		 */
		public function set ry(value:Number):void
		{
			_ry = value;
		}
		

	}
}