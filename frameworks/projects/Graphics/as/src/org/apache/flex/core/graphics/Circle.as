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
        import flash.geom.Point;
        import flash.geom.Rectangle;            
    }
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

	public class Circle extends GraphicShape
	{
		private var _radius:Number;

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
		}

		/**
		 *  Draw the circle.
		 *  @param x The x location of the center of the circle
		 *  @param y The y location of the center of the circle.
		 *  @param radius The radius of the circle.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         *  @flexjsignorecoercion SVGCircleElement
		 */
		public function drawCircle(x:Number, y:Number, radius:Number):void
		{
            COMPILE::AS3
            {
                graphics.clear();
                applyStroke();
                beginFill(new Rectangle(x,y,radius*2, radius*2),new Point(x-radius,y-radius));
                graphics.drawCircle(x,y,radius);
                endFill();
            }
            COMPILE::JS                
            {
                var style:String = getStyleStr();
                var circle:WrappedHTMLElement = document.createElementNS('http://www.w3.org/2000/svg', 'ellipse') as WrappedHTMLElement;
                circle.flexjs_wrapper = this;
                circle.setAttribute('style', style);
                if (stroke)
                {
                    circle.setAttribute('cx', String(radius + stroke.weight));
                    circle.setAttribute('cy', String(radius + stroke.weight));
                    setPosition(x - radius, y - radius, stroke.weight, stroke.weight);
                }
                else
                {
                    circle.setAttribute('cx', String(radius));
                    circle.setAttribute('cy', String(radius));
                    setPosition(x - radius, y - radius, 0, 0);
                }
                
                circle.setAttribute('rx', String(radius));
                circle.setAttribute('ry', String(radius));
                element.appendChild(circle);
                
                resize(x, y, (circle as SVGCircleElement).getBBox());

            }
		}
		
		override public function addedToParent():void
		{
			drawCircle(0, 0, radius);
		}
		
	}
}