////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.flex.svg
{
	import org.apache.flex.graphics.IEllipse;

    COMPILE::SWF
    {
        import flash.geom.Point;
        import flash.geom.Rectangle;            
    }
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

    public class Ellipse extends GraphicShape implements IEllipse
    {
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.7
		 */
		public function Ellipse(cx:Number=0, cy:Number=0, rx:Number=0, ry:Number=0)
		{
			x = cx;
			y = cy;
			this.rx = rx;
			this.ry = ry;
		}
		
		private var _rx:Number;

		/**
		 * The horizontal radius of the ellipse.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
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
		 * The vertical radius of the ellipse.
		 * 
         *  @langversion 3.0
         *  @playerversion Flash 9
         *  @playerversion AIR 1.1
         *  @productversion FlexJS 0.7
		 */
		public function get ry():Number
		{
			return _ry;
		}

		public function set ry(value:Number):void
		{
			_ry = value;
		}

        override public function get width():Number
        {
            return _rx*2;
        }

        override public function set width(value:Number):void
        {
            _rx = value/2;
        }

        override public function get height():Number
        {
            return _ry*2;
        }

        override public function set height(value:Number):void
        {
            _ry = value/2;
        }
        
        COMPILE::JS
        private var _ellipse:WrappedHTMLElement;
        
        /**
         *  Draw the ellipse.
         *  @param xp The x position of the top-left corner of the bounding box of the ellipse.
         *  @param yp The y position of the top-left corner of the bounding box of the ellipse.
         *  @param width The width of the ellipse.
         *  @param height The height of the ellipse.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         *  @flexjsignorecoercion SVGEllipseElement
         */
        public function drawEllipse(xp:Number, yp:Number):void
        {
            COMPILE::SWF
            {
                $sprite.graphics.clear();
                applyStroke();
                beginFill(new Rectangle(xp, yp, width, height), new Point(xp,yp));
                $sprite.graphics.drawEllipse(xp,yp,width,height);
                endFill();                    
            }
            COMPILE::JS
            {
                var style:String = getStyleStr();
                if (_ellipse == null) {
                    _ellipse = document.createElementNS('http://www.w3.org/2000/svg', 'ellipse') as WrappedHTMLElement;
                    _ellipse.flexjs_wrapper = this;
                    element.appendChild(_ellipse);
                }
                _ellipse.setAttribute('style', style);
                if (stroke)
                {
                    _ellipse.setAttribute('cx', rx + stroke.weight);
                    _ellipse.setAttribute('cy', ry + stroke.weight);
                }
                else
                {
                    _ellipse.setAttribute('cx', rx);
                    _ellipse.setAttribute('cy', ry);
                }
                _ellipse.setAttribute('rx', rx);
                _ellipse.setAttribute('ry', ry);
                
                resize(x, y, (_ellipse as SVGEllipseElement).getBBox());

            }
        }
        
        override protected function draw():void
        {
            drawEllipse(0, 0);    
        }
        
    }
}
