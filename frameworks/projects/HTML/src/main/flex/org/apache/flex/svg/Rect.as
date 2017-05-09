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

package org.apache.flex.svg
{
    import org.apache.flex.graphics.IDrawable;
	import org.apache.flex.graphics.IRect;

    COMPILE::SWF
    {
        import flash.geom.Point;
        import flash.geom.Rectangle;            
    }
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

	public class Rect extends GraphicShape implements IRect, IDrawable
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7
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
		 *  @productversion FlexJS 0.7
		 */
		public function get rx():Number
		{
			return _rx;
		}

		public function set rx(value:Number):void
		{
			_rx = value;
		}

		private var _ry:Number;

		/**
		 * The y axis radius for rounded corners 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7
		 * 
		 */
		public function get ry():Number
		{
			return _ry;
		}

		public function set ry(value:Number):void
		{
			_ry = value;
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
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		public function drawRect(xp:Number, yp:Number, width:Number, height:Number):void
		{
            COMPILE::SWF
            {
                $sprite.graphics.clear();
                applyStroke();
                beginFill(new Rectangle(xp, yp, width, height), new Point(xp,yp));
                if(isNaN(rx))
                    $sprite.graphics.drawRect(0, 0, width, height);
                else
                {
                    var dx:Number = rx*2;
                    var dy:Number = isNaN(ry) ? ry : ry*2;
                    $sprite.graphics.drawRoundRect(0, 0, width, height,dx ,dy);
                }
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
                
				resize(x, y, getBBox(_rect));
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
