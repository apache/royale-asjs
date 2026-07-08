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
package org.apache.royale.style.stylebeads.border
{
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.StyleData;
	import org.apache.royale.style.stylebeads.CompositeStyle;
	/**
	 * Has color, style, width, and radius style for simple application of those properties.
	 * 
	 * For more complex borders, use BorderRadius and BorderWidth,
	 * which allow for more specific control over the radius and width
	 * of each corner and side of the border.
	 *
	 */
	public class Border extends CompositeStyle
	{
		public function Border(color:String = null, style:String = null, width:* = null, radius:* = null, unit:String = "px")
		{
			super();
			this.unit = unit;
			if(color != this.color)
				this.color = color;
			if(style != this.style)
				this.style = style;
			if(width != this.width)
				this.width = width;
			if(radius != this.radius)
				this.radius = radius;
		}
		private var _color:String;

		public function get color():String
		{
			return _color;
		}
		private var colorStyle:BorderColor;
		public function set color(value:String):void
		{
			if(!colorStyle)
			{
				colorStyle = new BorderColor();
				addStyleBead(colorStyle);
			}
			colorStyle.value = value;
			_color = value;
		}
		private var _topColor:String;
		public function get topColor():String
		{
			return _topColor;
		}
		private var topColorStyle:BorderColor;
		public function set topColor(value:String):void
		{
			if(!topColorStyle)
			{
				topColorStyle = new BorderColor("border-t", "border-top-color");
				addStyleBead(topColorStyle);
			}
			topColorStyle.value = value;
			_topColor = value;
		}
		private var _bottomColor:String;
		public function get bottomColor():String
		{
			return _bottomColor;
		}
		private var bottomColorStyle:BorderColor;
		public function set bottomColor(value:String):void
		{
			if(!bottomColorStyle)
			{
				bottomColorStyle = new BorderColor("border-b", "border-bottom-color");
				addStyleBead(bottomColorStyle);
			}
			bottomColorStyle.value = value;
			_bottomColor = value;
		}
		private var _leftColor:String;
		public function get leftColor():String
		{
			return _leftColor;
		}
		private var leftColorStyle:BorderColor;
		public function set leftColor(value:String):void
		{
			if(!leftColorStyle)
			{
				leftColorStyle = new BorderColor("border-l", "border-left-color");
				addStyleBead(leftColorStyle);
			}
			leftColorStyle.value = value;
			_leftColor = value;
		}
		private var _rightColor:String;
		public function get rightColor():String
		{
			return _rightColor;
		}
		private var rightColorStyle:BorderColor;
		public function set rightColor(value:String):void
		{
			if(!rightColorStyle)
			{
				rightColorStyle = new BorderColor("border-r", "border-right-color");
				addStyleBead(rightColorStyle);
			}
			rightColorStyle.value = value;
			_rightColor = value;
		}
		private var _blockColor:String;
		public function get blockColor():String
		{
			return _blockColor;
		}
		private var blockColorStyle:BorderColor;
		public function set blockColor(value:String):void
		{
			if(!blockColorStyle)
			{
				blockColorStyle = new BorderColor("border-y", "border-block-color");
				addStyleBead(blockColorStyle);
			}
			blockColorStyle.value = value;
			_blockColor = value;
		}
		private var _blockStartColor:String;
		public function get blockStartColor():String
		{
			return _blockStartColor;
		}
		private var blockStartColorStyle:BorderColor;
		public function set blockStartColor(value:String):void
		{
			if(!blockStartColorStyle)
			{
				blockStartColorStyle = new BorderColor("border-bs", "border-block-start-color");
				addStyleBead(blockStartColorStyle);
			}
			blockStartColorStyle.value = value;
			_blockStartColor = value;
		}
		private var _blockEndColor:String;
		public function get blockEndColor():String
		{
			return _blockEndColor;
		}
		private var blockEndColorStyle:BorderColor;
		public function set blockEndColor(value:String):void
		{
			if(!blockEndColorStyle)
			{
				blockEndColorStyle = new BorderColor("border-be", "border-block-end-color");
				addStyleBead(blockEndColorStyle);
			}
			blockEndColorStyle.value = value;
			_blockEndColor = value;
		}
		private var _inlineColor:String;
		public function get inlineColor():String
		{
			return _inlineColor;
		}
		private var inlineColorStyle:BorderColor;
		public function set inlineColor(value:String):void
		{
			if(!inlineColorStyle)
			{
				inlineColorStyle = new BorderColor("border-x", "border-inline-color");
				addStyleBead(inlineColorStyle);
			}
			inlineColorStyle.value = value;
			_inlineColor = value;
		}
		private var _inlineStartColor:String;
		public function get inlineStartColor():String
		{
			return _inlineStartColor;
		}
		private var inlineStartColorStyle:BorderColor;
		public function set inlineStartColor(value:String):void
		{
			if(!inlineStartColorStyle)
			{
				inlineStartColorStyle = new BorderColor("border-s", "border-inline-start-color");
				addStyleBead(inlineStartColorStyle);
			}
			inlineStartColorStyle.value = value;
			_inlineStartColor = value;
		}
		private var _inlineEndColor:String;
		public function get inlineEndColor():String
		{
			return _inlineEndColor;
		}
		private var inlineEndColorStyle:BorderColor;
		public function set inlineEndColor(value:String):void
		{
			if(!inlineEndColorStyle)
			{
				inlineEndColorStyle = new BorderColor("border-e", "border-inline-end-color");
				addStyleBead(inlineEndColorStyle);
			}
			inlineEndColorStyle.value = value;
			_inlineEndColor = value;
		}
		private var _style:String;

		public function get style():String
		{
			return _style;
		}
		private var styleStyle:BorderStyle;
		public function set style(value:String):void
		{
			if(!styleStyle)
			{
				styleStyle = new BorderStyle();
				addStyleBead(styleStyle);
			}
			styleStyle.value = value;
			_style = value;
		}
		private var _topStyle:String;
		public function get topStyle():String
		{
			return _topStyle;
		}
		private var tStyle:BorderStyle;
		public function set topStyle(value:String):void
		{
			if(!tStyle)
			{
				tStyle = new BorderStyle("border-t", "border-top-style");
				addStyleBead(tStyle);
			}
			tStyle.value = value;
			_topStyle = value;
		}
		private var _bottomStyle:String;
		public function get bottomStyle():String
		{
			return _bottomStyle;
		}
		private var bStyle:BorderStyle;
		public function set bottomStyle(value:String):void
		{
			if(!bStyle)
			{
				bStyle = new BorderStyle("border-b", "border-bottom-style");
				addStyleBead(bStyle);
			}
			bStyle.value = value;
			_bottomStyle = value;
		}
		private var _leftStyle:String;
		public function get leftStyle():String
		{
			return _leftStyle;
		}
		private var lStyle:BorderStyle;
		public function set leftStyle(value:String):void
		{
			if(!lStyle)
			{
				lStyle = new BorderStyle("border-l", "border-left-style");
				addStyleBead(lStyle);
			}
			lStyle.value = value;
			_leftStyle = value;
		}
		private var _rightStyle:String;
		public function get rightStyle():String
		{
			return _rightStyle;
		}
		private var rStyle:BorderStyle;
		public function set rightStyle(value:String):void
		{
			if(!rStyle)
			{
				rStyle = new BorderStyle("border-r", "border-right-style");
				addStyleBead(rStyle);
			}
			rStyle.value = value;
			_rightStyle = value;
		}
		private var _blockStyle:String;
		public function get blockStyle():String
		{
			return _blockStyle;
		}
		private var blkStyle:BorderStyle;
		public function set blockStyle(value:String):void
		{
			if(!blkStyle)
			{
				blkStyle = new BorderStyle("border-y", "border-block-style");
				addStyleBead(blkStyle);
			}
			blkStyle.value = value;
			_blockStyle = value;
		}
		private var _blockStartStyle:String;
		public function get blockStartStyle():String
		{
			return _blockStartStyle;
		}
		private var blkStartStyle:BorderStyle;
		public function set blockStartStyle(value:String):void
		{
			if(!blkStartStyle)
			{
				blkStartStyle = new BorderStyle("border-bs", "border-block-start-style");
				addStyleBead(blkStartStyle);
			}
			blkStartStyle.value = value;
			_blockStartStyle = value;
		}
		private var _blockEndStyle:String;
		public function get blockEndStyle():String
		{
			return _blockEndStyle;
		}
		private var blkEndStyle:BorderStyle;
		public function set blockEndStyle(value:String):void
		{
			if(!blkEndStyle)
			{
				blkEndStyle = new BorderStyle("border-be", "border-block-end-style");
				addStyleBead(blkEndStyle);
			}
			blkEndStyle.value = value;
			_blockEndStyle = value;
		}
		private var _inlineStyle:String;
		public function get inlineStyle():String
		{
			return _inlineStyle;
		}
		private var inlStyle:BorderStyle;
		public function set inlineStyle(value:String):void
		{
			if(!inlStyle)
			{
				inlStyle = new BorderStyle("border-x", "border-inline-style");
				addStyleBead(inlStyle);
			}
			inlStyle.value = value;
			_inlineStyle = value;
		}
		private var _inlineStartStyle:String;
		public function get inlineStartStyle():String
		{
			return _inlineStartStyle;
		}
		private var inlStartStyle:BorderStyle;
		public function set inlineStartStyle(value:String):void
		{
			if(!inlStartStyle)
			{
				inlStartStyle = new BorderStyle("border-s", "border-inline-start-style");
				addStyleBead(inlStartStyle);
			}
			inlStartStyle.value = value;
			_inlineStartStyle = value;
		}
		private var _inlineEndStyle:String;
		public function get inlineEndStyle():String
		{
			return _inlineEndStyle;
		}
		private var inlEndStyle:BorderStyle;
		public function set inlineEndStyle(value:String):void
		{
			if(!inlEndStyle)
			{
				inlEndStyle = new BorderStyle("border-e", "border-inline-end-style");
				addStyleBead(inlEndStyle);
			}
			inlEndStyle.value = value;
			_inlineEndStyle = value;
		}
		private var _width:*;

		public function get width():*
		{
			return _width;
		}
		private var widthStyle:BorderWidth;
		public function set width(value:*):void
		{
			if(!widthStyle)
			{
				widthStyle = new BorderWidth();
				widthStyle.unit = unit;
				addStyleBead(widthStyle);
			}
			widthStyle.width = value;
			_width = value;
		}
		public function get topWidth():*
		{
			return widthStyle ? widthStyle.top : null;
		}
		public function set topWidth(value:*):void
		{
			if(!widthStyle)
			{
				widthStyle = new BorderWidth();
				widthStyle.unit = unit;
				addStyleBead(widthStyle);
			}
			widthStyle.top = value;
		}
		public function get bottomWidth():*
		{
			return widthStyle ? widthStyle.bottom : null;
		}
		public function set bottomWidth(value:*):void
		{
			if(!widthStyle)
			{
				widthStyle = new BorderWidth();
				widthStyle.unit = unit;
				addStyleBead(widthStyle);
			}
			widthStyle.bottom = value;
		}
		public function get leftWidth():*
		{
			return widthStyle ? widthStyle.left : null;
		}
		public function set leftWidth(value:*):void
		{
			if(!widthStyle)
			{
				widthStyle = new BorderWidth();
				widthStyle.unit = unit;
				addStyleBead(widthStyle);
			}
			widthStyle.left = value;
		}
		public function get rightWidth():*
		{
			return widthStyle ? widthStyle.right : null;
		}
		public function set rightWidth(value:*):void
		{
			if(!widthStyle)
			{
				widthStyle = new BorderWidth();
				widthStyle.unit = unit;
				addStyleBead(widthStyle);
			}
			widthStyle.right = value;
		}
		public function get blockWidth():*
		{
			return widthStyle ? widthStyle.block : null;
		}
		public function set blockWidth(value:*):void
		{
			if(!widthStyle)
			{
				widthStyle = new BorderWidth();
				widthStyle.unit = unit;
				addStyleBead(widthStyle);
			}
			widthStyle.block = value;
		}
		public function get blockStartWidth():*
		{
			return widthStyle ? widthStyle.blockStart : null;
		}
		public function set blockStartWidth(value:*):void
		{
			if(!widthStyle)
			{
				widthStyle = new BorderWidth();
				widthStyle.unit = unit;
				addStyleBead(widthStyle);
			}
			widthStyle.blockStart = value;
		}
		public function get blockEndWidth():*
		{
			return widthStyle ? widthStyle.blockEnd : null;
		}
		public function set blockEndWidth(value:*):void
		{
			if(!widthStyle)
			{
				widthStyle = new BorderWidth();
				widthStyle.unit = unit;
				addStyleBead(widthStyle);
			}
			widthStyle.blockEnd = value;
		}
		public function get inlineWidth():*
		{
			return widthStyle ? widthStyle.inline : null;
		}
		public function set inlineWidth(value:*):void
		{
			if(!widthStyle)
			{
				widthStyle = new BorderWidth();
				widthStyle.unit = unit;
				addStyleBead(widthStyle);
			}
			widthStyle.inline = value;
		}
		public function get inlineStartWidth():*
		{
			return widthStyle ? widthStyle.inlineStart : null;
		}
		public function set inlineStartWidth(value:*):void
		{
			if(!widthStyle)
			{
				widthStyle = new BorderWidth();
				widthStyle.unit = unit;
				addStyleBead(widthStyle);
			}
			widthStyle.inlineStart = value;
		}
		public function get inlineEndWidth():*
		{
			return widthStyle ? widthStyle.inlineEnd : null;
		}
		public function set inlineEndWidth(value:*):void
		{
			if(!widthStyle)
			{
				widthStyle = new BorderWidth();
				widthStyle.unit = unit;
				addStyleBead(widthStyle);
			}
			widthStyle.inlineEnd = value;
		}
		private var _radius:*;

		public function get radius():*
		{
			return _radius;
		}
		private var radiusStyle:BorderRadius;
		public function set radius(value:*):void
		{
			if(!radiusStyle)
			{
				radiusStyle = new BorderRadius();
				radiusStyle.unit = unit;
				addStyleBead(radiusStyle);
			}
			radiusStyle.radius = value;
			_radius = value;
		}
		public function get topLeftRadius():*
		{
			return radiusStyle ? radiusStyle.topLeft : null;
		}
		public function set topLeftRadius(value:*):void
		{
			if(!radiusStyle)
			{
				radiusStyle = new BorderRadius();
				radiusStyle.unit = unit;
				addStyleBead(radiusStyle);
			}
			radiusStyle.topLeft = value;
		}
		public function get topRightRadius():*
		{
			return radiusStyle ? radiusStyle.topRight : null;
		}
		public function set topRightRadius(value:*):void
		{
			if(!radiusStyle)
			{
				radiusStyle = new BorderRadius();
				radiusStyle.unit = unit;
				addStyleBead(radiusStyle);
			}
			radiusStyle.topRight = value;
		}
		public function get bottomLeftRadius():*
		{
			return radiusStyle ? radiusStyle.bottomLeft : null;
		}
		public function set bottomLeftRadius(value:*):void
		{
			if(!radiusStyle)
			{
				radiusStyle = new BorderRadius();
				radiusStyle.unit = unit;
				addStyleBead(radiusStyle);
			}
			radiusStyle.bottomLeft = value;
		}
		public function get bottomRightRadius():*
		{
			return radiusStyle ? radiusStyle.bottomRight : null;
		}
		public function set bottomRightRadius(value:*):void
		{
			if(!radiusStyle)
			{
				radiusStyle = new BorderRadius();
				radiusStyle.unit = unit;
				addStyleBead(radiusStyle);
			}
			radiusStyle.bottomRight = value;
		}
		public function get startStartRadius():*
		{
			return radiusStyle ? radiusStyle.startStart : null;
		}
		public function set startStartRadius(value:*):void
		{
			if(!radiusStyle)
			{
				radiusStyle = new BorderRadius();
				radiusStyle.unit = unit;
				addStyleBead(radiusStyle);
			}
			radiusStyle.startStart = value;
		}
		public function get startEndRadius():*
		{
			return radiusStyle ? radiusStyle.startEnd : null;
		}
		public function set startEndRadius(value:*):void
		{
			if(!radiusStyle)
			{
				radiusStyle = new BorderRadius();
				radiusStyle.unit = unit;
				addStyleBead(radiusStyle);
			}
			radiusStyle.startEnd = value;
		}
		public function get endStartRadius():*
		{
			return radiusStyle ? radiusStyle.endStart : null;
		}
		public function set endStartRadius(value:*):void
		{
			if(!radiusStyle)
			{
				radiusStyle = new BorderRadius();
				radiusStyle.unit = unit;
				addStyleBead(radiusStyle);
			}
			radiusStyle.endStart = value;
		}
		public function get endEndRadius():*
		{
			return radiusStyle ? radiusStyle.endEnd : null;
		}
		public function set endEndRadius(value:*):void
		{
			if(!radiusStyle)
			{
				radiusStyle = new BorderRadius();
				radiusStyle.unit = unit;
				addStyleBead(radiusStyle);
			}
			radiusStyle.endEnd = value;
		}
	}
}
