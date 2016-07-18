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
    COMPILE::SWF
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
		COMPILE::JS
		private var _rect:WrappedHTMLElement;
		
		/**
		 *  Draw the rectangle.
		 *  @param xp The x position of the top-left corner of the rectangle.
		 *  @param yp The y position of the top-left corner.
		 *  @param width The width of the rectangle.
		 *  @param height The height of the rectangle.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		public function drawRect(xp:Number, yp:Number, width:Number, height:Number):void
		{
            COMPILE::SWF
            {
                graphics.clear();
                applyStroke();
                beginFill(new Rectangle(xp, yp, width, height), new Point(xp,yp));
                graphics.drawRect(xp, yp, width, height);
                endFill();                    
            }
            COMPILE::JS
            {
                var style:String = this.getStyleStr();
				
				if (_rect == null) {
                	_rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect') as WrappedHTMLElement;
                	_rect.flexjs_wrapper = this;
					element.appendChild(_rect);
				}
                _rect.setAttribute('style', style);
                if (stroke)
                {
					_rect.setAttribute('x', String(stroke.weight / 2) + 'px');
					_rect.setAttribute('y', String(stroke.weight / 2) + 'px');
                }
                else
                {
					_rect.setAttribute('x', '0' + 'px');
					_rect.setAttribute('y', '0' + 'px');
                }
				_rect.setAttribute('width', String(width) + 'px');
				_rect.setAttribute('height', String(height) + 'px');
                
                resize(x, y, _rect['getBBox']());
            }
		}
		
		override protected function draw():void
		{
			drawRect(0,0,width,height);
		}
		
	}
}
