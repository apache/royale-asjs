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
			styles = [];
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
			var shorthand:Array = parseShorthandCSS(value);
			if(shorthand)
			{
				applyShorthand(shorthand);
				_margin = value;
				return;
			}
			if(!marginStyle)
			{
				marginStyle = new Marg();
				styles.push(marginStyle);
			}
			marginStyle.value = value;
			_top = value;
			_right = value;
			_bottom = value;
			_left = value;
			_margin = value;
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
			if(!topStyle)
			{
				topStyle = new MarginTop();
				styles.push(topStyle);
			}
			topStyle.value = value;
			_top = value;
		}
		private var _right:*;

		public function get right():*
		{
			return _right;
		}

		public function set right(value:*):void
		{
			if(!rightStyle)
			{
				rightStyle = new MarginRight();
				styles.push(rightStyle);
			}
			rightStyle.value = value;
			_right = value;
		}
		private var _bottom:*;

		public function get bottom():*
		{
			return _bottom;
		}

		public function set bottom(value:*):void
		{
			if(!bottomStyle)
			{
				bottomStyle = new MarginBottom();
				styles.push(bottomStyle);
			}
			bottomStyle.value = value;
			_bottom = value;
		}
		private var _left:*;

		public function get left():*
		{
			return _left;
		}

		public function set left(value:*):void
		{
			if(!leftStyle)
			{
				leftStyle = new MarginLeft();
				styles.push(leftStyle);
			}
			leftStyle.value = value;
			_left = value;
		}
		private var _block:*;

		public function get block():*
		{
			return _block;
		}

		public function set block(value:*):void
		{
			if(!blockStyle)
			{
				blockStyle = new MarginBlock();
				styles.push(blockStyle);
			}
			blockStyle.value = value;
			_block = value;
		}
		private var _blockStart:*;

		public function get blockStart():*
		{
			return _blockStart;
		}

		public function set blockStart(value:*):void
		{
			if(!blockStartStyle)
			{
				blockStartStyle = new MarginBlockStart();
				styles.push(blockStartStyle);
			}
			blockStartStyle.value = value;
			_blockStart = value;
		}
		private var _blockEnd:*;

		public function get blockEnd():*
		{
			return _blockEnd;
		}

		public function set blockEnd(value:*):void
		{
			if(!blockEndStyle)
			{
				blockEndStyle = new MarginBlockEnd();
				styles.push(blockEndStyle);
			}
			blockEndStyle.value = value;
			_blockEnd = value;
		}
		private var _inline:*;

		public function get inline():*
		{
			return _inline;
		}

		public function set inline(value:*):void
		{
			if(!inlineStyle)
			{
				inlineStyle = new MarginInline();
				styles.push(inlineStyle);
			}
			inlineStyle.value = value;
			_inline = value;
		}
		private var _inlineStart:*;

		public function get inlineStart():*
		{
			return _inlineStart;
		}

		public function set inlineStart(value:*):void
		{
			if(!inlineStartStyle)
			{
				inlineStartStyle = new MarginInlineStart();
				styles.push(inlineStartStyle);
			}
			inlineStartStyle.value = value;
			_inlineStart = value;
		}
		private var _inlineEnd:*;

		public function get inlineEnd():*
		{
			return _inlineEnd;
		}

		public function set inlineEnd(value:*):void
		{
			if(!inlineEndStyle)
			{
				inlineEndStyle = new MarginInlineEnd();
				styles.push(inlineEndStyle);
			}
			inlineEndStyle.value = value;
			_inlineEnd = value;
		}
	}
}
