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

	public class Padding extends CompositeStyle
	{
		public function Padding(value:* = null, unit:String = "px")
		{
			super();
			this.unit = unit;
			if(value != null)
				this.padding = value;
		}
		private var paddingStyle:Pad;
		private var topStyle:PaddingTop;
		private var rightStyle:PaddingRight;
		private var bottomStyle:PaddingBottom;
		private var leftStyle:PaddingLeft;
		private var blockStyle:PaddingBlock;
		private var blockStartStyle:PaddingBlockStart;
		private var blockEndStyle:PaddingBlockEnd;
		private var inlineStyle:PaddingInline;
		private var inlineStartStyle:PaddingInlineStart;
		private var inlineEndStyle:PaddingInlineEnd;
		private var _padding:*;

		public function get padding():*
		{
			return _padding;
		}
		public function set padding(value:*):void
		{
			resetPaddingStyles();
			var shorthand:Array = parseShorthandCSS(value);
			if(shorthand)
			{
				applyShorthand(shorthand);
				_padding = value;
				return;
			}
			if(!paddingStyle)
			{
				paddingStyle = new Pad();
				addStyleBead(paddingStyle);
			}
			paddingStyle.value = value;
			_top = value;
			_right = value;
			_bottom = value;
			_left = value;
			_padding = value;
		}

		private function resetPaddingStyles():void
		{
			styles = [];
			paddingStyle = null;
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
				topStyle = new PaddingTop();
				addStyleBead(topStyle);
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
				rightStyle = new PaddingRight();
				addStyleBead(rightStyle);
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
				bottomStyle = new PaddingBottom();
				addStyleBead(bottomStyle);
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
				leftStyle = new PaddingLeft();
				addStyleBead(leftStyle);
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
				blockStyle = new PaddingBlock();
				addStyleBead(blockStyle);
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
				blockStartStyle = new PaddingBlockStart();
				addStyleBead(blockStartStyle);
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
				blockEndStyle = new PaddingBlockEnd();
				addStyleBead(blockEndStyle);
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
				inlineStyle = new PaddingInline();
				addStyleBead(inlineStyle);
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
				inlineStartStyle = new PaddingInlineStart();
				addStyleBead(inlineStartStyle);
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
				inlineEndStyle = new PaddingInlineEnd();
				addStyleBead(inlineEndStyle);
			}
			inlineEndStyle.value = value;
			_inlineEnd = value;
		}
	}
}