/*
 *
 *	Licensed to the Apache Software Foundation (ASF) under one or more
 *	contributor license agreements.	See the NOTICE file distributed with
 *	this work for additional information regarding copyright ownership.
 *	The ASF licenses this file to You under the Apache License, Version 2.0
 *	(the "License"); you may not use this file except in compliance with
 *	the License.	You may obtain a copy of the License at
 *
 *		 http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.royale.svg
{
	COMPILE::SWF
	{
		import flash.display.Graphics;
		import flash.display.Sprite;
		import flash.geom.Point;
		import flash.geom.Rectangle;
		import org.apache.royale.core.WrappedSprite;
	}
	COMPILE::JS
	{
	import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addSvgElementToWrapper;
	}

	import org.apache.royale.core.IRoyaleElement;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.graphics.IFill;
	import org.apache.royale.graphics.IStroke;
	import org.apache.royale.graphics.IGraphicShape;

	public class GraphicShape extends UIBase implements IGraphicShape
	{

		private var _fill:IFill;
		private var _stroke:IStroke;

		public function get stroke():IStroke
		{
			return _stroke;
		}

		/**
		 *	A solid color fill.
		 *
		 *	@langversion 3.0
		 *	@playerversion Flash 9
		 *	@playerversion AIR 1.1
		 *	@productversion Royale 0.0
		 */
		public function set stroke(value:IStroke):void
		{
			_stroke = value;
			updateView();
		}

		public function get fill():IFill
		{
			return _fill;
		}
		/**
		 *	A solid color fill.
		 *
		 *	@langversion 3.0
		 *	@playerversion Flash 9
		 *	@playerversion AIR 1.1
		 *	@productversion Royale 0.0
		 */
		public function set fill(value:IFill):void
		{
			_fill = value;
			updateView();
		}
		/**
		 * Setting visuals after the element is added to the parent should have an effect (i.e. in MXML binding)
		 */
		protected function updateView():void
		{
			if(parent)
				drawImpl();
		}
		/**
		 * Constructor
		 *
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		public function GraphicShape()
		{
			super();
		}

		/**
		 * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
			return addSvgElementToWrapper(this, 'svg');
		}
		
		/**
		 * @private
		 * @royaleignorecoercion SVGRect
		 */
		// COMPILE::JS
		// protected function getBBox(svgElement:WrappedHTMLElement):Object
		// {
		// 	try {
		// 		return svgElement['getBBox']();
		// 	} catch (err) {
		// 		return {x: 0, y:0, width:this.width, height:this.height};
		// 	}
		// }


		COMPILE::SWF
		protected function applyStroke():void
		{
			if(stroke)
			{
				stroke.apply(graphics);
			}
		}

		COMPILE::SWF
		protected function beginFill(targetBounds:Rectangle,targetOrigin:Point):void
		{
			if(fill)
			{
				fill.begin(graphics, targetBounds,targetOrigin);
			}
		}

		COMPILE::SWF
		protected function endFill():void
		{
			if(fill)
			{
				fill.end(graphics);
			}
		}

		/**
		 * This is where the drawing methods get called from
		 */
		protected function drawImpl():void
		{
			//Overwrite in subclass
		}

		override public function addedToParent():void
		{
			super.addedToParent();
			drawImpl();
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

		COMPILE::JS
		override protected function setClassName(value:String):void
		{
			element.setAttribute('class', value);
		}


		/**
		 * @param x X position.
		 * @param y Y position.
		 * @param bbox The bounding box of the svg element.
		 */
		COMPILE::JS
		public function resize(x:Number, y:Number):void
		{
			// var useWidth:Number = Math.max(this.width, bbox.width);
			// var useHeight:Number = Math.max(this.height, bbox.height);
			var useWidth:Number = explicitWidth;
			var useHeight:Number = explicitHeight;

			element.style.position = 'absolute';
			//style needed for SVG inside DOM elements
			// attributes for SVG inside SVG
			if (!isNaN(x))
			{
				element.style.left = x + "px";
				element.setAttribute("x", x);
			} 
						if (!isNaN(y))
			{
				element.style.top = y + "px";
				element.setAttribute("y", y);
			}
			if(!isNaN(useWidth))
			{
				element.style.width = useWidth + "px";
				element.setAttribute("width", useWidth);
			}
			if(!isNaN(useHeight))
			{
				element.style.height = useHeight + "px";
				element.setAttribute("height", useHeight);
			}
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
			// Needed for SVG inside SVG
			element.setAttribute("x", xOffset);
			element.setAttribute("y", yOffset);
			//Needed for SVG inside DOM elements
			element.style.left = xOffset + "px";
			element.style.top = yOffset + "px";
		}
		COMPILE::JS
		override public function set x(value:Number):void
		{
			super.x = value;
			// Needed for SVG inside SVG
			element.setAttribute("x", value);
		}
		COMPILE::JS
		override public function set y(value:Number):void
		{
			super.y = value;
			// Needed for SVG inside SVG
			element.setAttribute("y", value);
		}
	}
}
