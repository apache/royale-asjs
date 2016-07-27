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
	COMPILE::SWF
    {
		import flash.display.Graphics;
        import flash.geom.Point;
        import flash.geom.Rectangle;
    }
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

	import org.apache.flex.core.UIBase;
	import org.apache.flex.graphics.IFill;
	import org.apache.flex.graphics.IStroke;
	import org.apache.flex.graphics.IGraphicShape;

	public class GraphicShape extends UIBase implements IGraphicShape
	{
		private var _fill:IFill;
		private var _stroke:IStroke;

		public function get stroke():IStroke
		{
			return _stroke;
		}

		/**
		 *  A solid color fill.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion FlexJS 0.0
		 */
		public function set stroke(value:IStroke):void
		{
			_stroke = value;
		}

		public function get fill():IFill
		{
			return _fill;
		}
		/**
		 *  A solid color fill.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion FlexJS 0.0
		 */
		public function set fill(value:IFill):void
		{
			_fill = value;
		}

		/**
		 * Constructor
		 *
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
        public function GraphicShape()
        {
			super();
        }
		
		/**
		 * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			element = document.createElementNS('http://www.w3.org/2000/svg', 'svg') as WrappedHTMLElement;
			element.flexjs_wrapper = this;
			element.style.left = 0;
			element.style.top = 0;
			//element.offsetParent = null;
			positioner = element;
			positioner.style.position = 'relative';
			
			return element;
		}


        COMPILE::SWF
		protected function applyStroke():void
		{
			if(stroke)
			{
				stroke.apply(sprite.graphics);
			}
		}

        COMPILE::SWF
		protected function beginFill(targetBounds:Rectangle,targetOrigin:Point):void
		{
			if(fill)
			{
				fill.begin(sprite.graphics, targetBounds,targetOrigin);
			}
		}

        COMPILE::SWF
		protected function endFill():void
		{
			if(fill)
			{
				fill.end(sprite.graphics);
			}
		}

		/**
		 * This is where the drawing methods get called from
		 */
		protected function draw():void
		{
			//Overwrite in subclass
		}

		override public function addedToParent():void
		{
            COMPILE::SWF
            {
                super.addedToParent();
            }
			draw();
            COMPILE::JS
            {
                element.style.overflow = 'visible';
            }
		}

        /**
         * @return {string} The style attribute.
         */
        COMPILE::JS
        public function getStyleStr():String
        {
            var fillStr:String;
            if (fill)
            {
                fillStr = fill.addFillAttrib(this);
            }
            else
            {
                fillStr = 'fill:none';
            }

            var strokeStr:String;
            if (stroke)
            {
                strokeStr = stroke.addStrokeAttrib(this);
            }
            else
            {
                strokeStr = 'stroke:none';
            }


            return fillStr + ';' + strokeStr;
        }


        /**
         * @param x X position.
         * @param y Y position.
         * @param bbox The bounding box of the svg element.
         */
        COMPILE::JS
        public function resize(x:Number, y:Number, bbox:SVGRect):void
        {
            var useWidth:Number = Math.max(this.width, bbox.width);
            var useHeight:Number = Math.max(this.height, bbox.height);

            element.style.position = 'absolute';
            if (!isNaN(x)) element.style.top = x;
            if (!isNaN(y)) element.style.left = y;
            element.style.width = useWidth;
            element.style.height = useHeight;
            element.style.left = x;
            element.style.top = y;
        }

        COMPILE::JS
        private var _x:Number;
        COMPILE::JS
        private var _y:Number;
        COMPILE::JS
        private var _xOffset:Number;
        COMPILE::JS
        private var _yOffset:Number;

        /**
         * @param x X position.
         * @param y Y position.
         * @param xOffset offset from x position.
         * @param yOffset offset from y position.
         */
        COMPILE::JS
        public function setPosition(x:Number, y:Number, xOffset:Number, yOffset:Number):void
        {
            _x = x;
            _y = y;
            _xOffset = xOffset;
            _yOffset = yOffset;
            element.style.left = xOffset;
            element.style.top = yOffset;
        }
	}
}
