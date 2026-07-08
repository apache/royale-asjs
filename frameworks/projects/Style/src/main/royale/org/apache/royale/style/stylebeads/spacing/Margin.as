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
package org.apache.royale.style.stylebeads.spacing
{
	import org.apache.royale.style.stylebeads.CompositeStyle;
	import org.apache.royale.style.util.parseShorthandCSS;


	public class Margin extends CompositeStyle
	{
		public function Margin(value:* = null, unit:String = "px")
		{
			super();
			this.unit = unit;
			if(value != null)
				this.margin = value;
		}

		private var marginStyle:Marg;
		private var topStyle:MarginTop;
		private var rightStyle:MarginRight;
		private var bottomStyle:MarginBottom;
		private var leftStyle:MarginLeft;
		private var blockStyle:MarginBlock;
		private var blockStartStyle:MarginBlockStart;
		private var blockEndStyle:MarginBlockEnd;
		private var inlineStyle:MarginInline;
		private var inlineStartStyle:MarginInlineStart;
		private var inlineEndStyle:MarginInlineEnd;
		private var _margin:*;

		public function get margin():*
		{
			return _margin;
		}
		public function set margin(value:*):void
		{
			resetMarginStyles();
			_margin = value;
			var shorthand:Array = parseShorthandCSS(value);
			if(shorthand)
			{
				applyShorthand(shorthand);
				return;
			}
			_top = value;
			_right = value;
			_bottom = value;
			_left = value;
			if(!marginStyle)
			{
				marginStyle = new Marg("m", "margin", value);
				return addStyleBead(marginStyle);
			}
			marginStyle.value = value;
		}

		private function resetMarginStyles():void
		{
			styles = [];
			marginStyle = null;
			topStyle = null;
			rightStyle = null;
			bottomStyle = null;
			leftStyle = null;
			blockStyle = null;
			blockStartStyle = null;
			blockEndStyle = null;
			inlineStyle = null;
			inlineStartStyle = null;
			inlineEndStyle = null;
		}

		private function applyShorthand(values:Array):void
		{
			var topValue:* = values[0];
			var rightValue:* = values.length > 1 ? values[1] : values[0];
			var bottomValue:* = values.length > 2 ? values[2] : values[0];
			var leftValue:* = values.length > 3 ? values[3] : rightValue;
			if(values.length <= 2)
			{
				block = topValue;
				inline = rightValue;
			}
			else if(values.length == 3)
			{
				blockStart = topValue;
				blockEnd = bottomValue;
				inline = rightValue;
			}
			else
			{
				blockStart = topValue;
				blockEnd = bottomValue;
				inlineEnd = rightValue;
				inlineStart = leftValue;
			}
			_top = topValue;
			_right = rightValue;
			_bottom = bottomValue;
			_left = leftValue;
		}
		private var _top:*;

		public function get top():*
		{
			return _top;
		}

		public function set top(value:*):void
		{
			_top = value;
			if(!topStyle)
			{
				topStyle = new MarginTop(value);
				return addStyleBead(topStyle);
			}
			topStyle.value = value;
		}
		private var _right:*;

		public function get right():*
		{
			return _right;
		}

		public function set right(value:*):void
		{
			_right = value;
			if(!rightStyle)
			{
				rightStyle = new MarginRight(value);
				return addStyleBead(rightStyle);
			}
			rightStyle.value = value;
		}
		private var _bottom:*;

		public function get bottom():*
		{
			return _bottom;
		}

		public function set bottom(value:*):void
		{
			_bottom = value;
			if(!bottomStyle)
			{
				bottomStyle = new MarginBottom(value);
				return addStyleBead(bottomStyle);
			}
			bottomStyle.value = value;
		}
		private var _left:*;

		public function get left():*
		{
			return _left;
		}

		public function set left(value:*):void
		{
			_left = value;
			if(!leftStyle)
			{
				leftStyle = new MarginLeft(value);
				return addStyleBead(leftStyle);
			}
			leftStyle.value = value;
		}
		private var _block:*;

		public function get block():*
		{
			return _block;
		}

		public function set block(value:*):void
		{
			_block = value;
			if(!blockStyle)
			{
				blockStyle = new MarginBlock(value);
				return addStyleBead(blockStyle);
			}
			blockStyle.value = value;
		}
		private var _blockStart:*;

		public function get blockStart():*
		{
			return _blockStart;
		}

		public function set blockStart(value:*):void
		{
			_blockStart = value;
			if(!blockStartStyle)
			{
				blockStartStyle = new MarginBlockStart(value);
				return addStyleBead(blockStartStyle);
			}
			blockStartStyle.value = value;
		}
		private var _blockEnd:*;

		public function get blockEnd():*
		{
			return _blockEnd;
		}

		public function set blockEnd(value:*):void
		{
			_blockEnd = value;
			if(!blockEndStyle)
			{
				blockEndStyle = new MarginBlockEnd(value);
				return addStyleBead(blockEndStyle);
			}
			blockEndStyle.value = value;
		}
		private var _inline:*;

		public function get inline():*
		{
			return _inline;
		}

		public function set inline(value:*):void
		{
			_inline = value;
			if(!inlineStyle)
			{
				inlineStyle = new MarginInline(value);
				return addStyleBead(inlineStyle);
			}
			inlineStyle.value = value;
		}
		private var _inlineStart:*;

		public function get inlineStart():*
		{
			return _inlineStart;
		}

		public function set inlineStart(value:*):void
		{
			_inlineStart = value;
			if(!inlineStartStyle)
			{
				inlineStartStyle = new MarginInlineStart(value);
				return addStyleBead(inlineStartStyle);
			}
			inlineStartStyle.value = value;
		}
		private var _inlineEnd:*;

		public function get inlineEnd():*
		{
			return _inlineEnd;
		}

		public function set inlineEnd(value:*):void
		{
			_inlineEnd = value;
			if(!inlineEndStyle)
			{
				inlineEndStyle = new MarginInlineEnd(value);
				return addStyleBead(inlineEndStyle);
			}
			inlineEndStyle.value = value;
		}
	}
}
