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
    import org.apache.royale.graphics.IDrawable;
	import org.apache.royale.graphics.IRect;
	import org.apache.royale.core.ITransformHost;

    COMPILE::SWF
    {
        import flash.geom.Point;
        import flash.geom.Rectangle;
    }
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.createSVG;
    }

	public class Rect extends GraphicShape implements IRect, IDrawable, ITransformHost
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7
		 */
		public function Rect(x:Number=0, y:Number=0, width:Number=0, height:Number=0,rx:Number=NaN,ry:Number=NaN)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			this.rx = rx;
			this.ry = ry;
		}

		COMPILE::JS
		private var _rect:WrappedHTMLElement;
		
		private var _rx:Number;

		/**
		 * The x axis radius for rounded corners 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7
		 */
		public function get rx():Number
		{
			return _rx;
		}

		public function set rx(value:Number):void
		{
			_rx = value;
			updateView();
		}

		private var _ry:Number;

		/**
		 * The y axis radius for rounded corners 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7
		 * 
		 */
		public function get ry():Number
		{
			return _ry;
		}

		public function set ry(value:Number):void
		{
			_ry = value;
			updateView();
		}

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
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		public function drawRect(xp:Number, yp:Number, width:Number, height:Number):void
		{
            COMPILE::SWF
            {
                graphics.clear();
                applyStroke();
                beginFill(new Rectangle(xp, yp, width, height), new Point(xp,yp));
                if(isNaN(rx))
                    graphics.drawRect(0, 0, width, height);
                else
                {
                    var dx:Number = rx*2;
                    var dy:Number = isNaN(ry) ? ry : ry*2;
                    graphics.drawRoundRect(0, 0, width, height,dx ,dy);
                }
                endFill();                    
            }
            COMPILE::JS
            {
                var style:String = this.getStyleStr();
				
				if (_rect == null) {
					_rect = createSVG('rect') as WrappedHTMLElement;
					_rect.royale_wrapper = this;
					element.appendChild(_rect);
				}
				_rect.setAttribute('style', style);
				if (stroke)
				{
					_rect.setAttribute('x', stroke.weight / 2);
					_rect.setAttribute('y', stroke.weight / 2);
				}
				else
				{
					_rect.setAttribute('x', 0);
					_rect.setAttribute('y', 0);
				}
				if(width)
					_rect.setAttribute('width', width);
				if(height)
					_rect.setAttribute('height', height);
				if(!isNaN(_rx)){
					_rect.setAttribute('rx', _rx);
				}
				if(!isNaN(_ry)){
					_rect.setAttribute('ry', _ry);
				}
				// resize(x, y, getBBox(_rect));
				resize(x, y);
			}
		}
		
		COMPILE::JS
		override public function get transformElement():WrappedHTMLElement
		{
			return _rect;
		}

		override protected function drawImpl():void
		{
			drawRect(0,0,width,height);
		}

		public function draw():void
		{
			drawImpl();
		}
		
	}
}
