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

package org.apache.royale.svg
{
	import org.apache.royale.graphics.ICircle;
    import org.apache.royale.graphics.IDrawable;

    COMPILE::SWF
    {
        import flash.display.Graphics;
        import flash.geom.Point;
        import flash.geom.Rectangle;
    }
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.createSVG;
    }

    public class Circle extends GraphicShape implements ICircle, IDrawable
    {
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7
		 */
        public function Circle(cx:Number=0, cy:Number=0, r:Number=0)
        {
            x = cx;
            y = cy;
            radius = r;
        }

		private var _radius:Number;

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius = value;
			updateView();
		}
		override public function get width():Number
		{
			return _radius*2;
		}

		override public function set width(value:Number):void
		{
			radius = value/2;
		}

		override public function get height():Number
		{
			return _radius*2;
		}

		override public function set height(value:Number):void
		{
			radius = value/2;
		}

        COMPILE::JS
        private var _circle:WrappedHTMLElement;

        /**
         *  Draw the circle.
         *  @param cx The x location of the center of the circle
         *  @param cy The y location of the center of the circle.
         *  @param radius The radius of the circle.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         *  @royaleignorecoercion SVGCircleElement
         */
        public function drawCircle(cx:Number, cy:Number, radius:Number):void
        {
            COMPILE::SWF
            {
                graphics.clear();
                applyStroke();
                beginFill(new Rectangle(cx,cy,radius*2, radius*2),new Point(cx-radius,cy-radius));
                graphics.drawCircle(cx+radius,cy+radius,radius);
                endFill();
            }
            COMPILE::JS
            {
                var style:String = getStyleStr();

                if (_circle == null) {
                    _circle = createSVG('circle') as WrappedHTMLElement;
                    _circle.royale_wrapper = this;
                    element.appendChild(_circle);
                }
                _circle.setAttribute('style', style);
                if (stroke)
                {
                    _circle.setAttribute('cx', radius + stroke.weight);
                    _circle.setAttribute('cy', radius + stroke.weight);
                }
                else
                {
                    _circle.setAttribute('cx', radius);
                    _circle.setAttribute('cy', radius);
                }

                _circle.setAttribute('r', radius);

                // resize(x-radius, y-radius, getBBox(_circle));
                resize(x-radius, y-radius);

            }
        }

        override protected function drawImpl():void
        {
            drawCircle(0, 0, radius);
        }

		public function draw():void
		{
			drawImpl();
		}

    }
}
