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

	public class Rect extends GraphicShape
	{
		
		/**
		 *  Draw the rectangle.
		 *  @param x The x position of the top-left corner of the rectangle.
		 *  @param y The y position of the top-left corner.
		 *  @param width The width of the rectangle.
		 *  @param height The height of the rectangle.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void
		{
            COMPILE::AS3
            {
                graphics.clear();
                applyStroke();
                beginFill(new Rectangle(x, y, width, height), new Point(x,y));
                graphics.drawRect(x, y, width, height);
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
                element.appendChild(rect);
                
                resize(x, y, rect['getBBox']());
            }
		}
		
		override protected function draw():void
		{
			drawRect(0,0,width,height);
		}
		
	}
}