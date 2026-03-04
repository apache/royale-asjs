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
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.StyleTheme;
	import org.apache.royale.style.stylebeads.CompositeStyle;
	/**
	 * @royalesuppressexport
	 */
	public class BorderWidth extends CompositeStyle
	{
		public function BorderWidth()
		{
			super();
			styles = [];
		}
		private var _width:*;

		public function get width():*
		{
			return _width;
		}
		private var widthStyle:Width;
		public function set width(value:*):void
		{
			 if(!widthStyle)
			 {
				 widthStyle = new Width();
				 styles.push(widthStyle);
			 }
			 widthStyle.value = value;
			_width = value;
		}
		private var _top:*;

		public function get top():*
		{
			return _top;
		}
		private var topStyle:Top;
		public function set top(value:*):void
		{
			 if(!topStyle)
			 {
				 topStyle = new Top();
				 styles.push(topStyle);
			 }
			 topStyle.value = value;
			_top = value;
		}
		private var _left:*;

		public function get left():*
		{
			return _left;
		}
		private var leftStyle:Left;
		public function set left(value:*):void
		{
			 if(!leftStyle)
			 {
				 leftStyle = new Left();
				 styles.push(leftStyle);
			 }
			 leftStyle.value = value;
			_left = value;
		}
		private var _right:*;

		public function get right():*
		{
			return _right;
		}
		private var rightStyle:Right;
		public function set right(value:*):void
		{
			 if(!rightStyle)
			 {
				 rightStyle = new Right();
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
		private var bottomStyle:Bottom;
		public function set bottom(value:*):void
		{
			 if(!bottomStyle)
			 {
				 bottomStyle = new Bottom();
				 styles.push(bottomStyle);
			 }
			 bottomStyle.value = value;
			_bottom = value;
		}
		private var _block:*;

		public function get block():*
		{
			return _block;
		}
		private var blockStyle:Block;
		public function set block(value:*):void
		{
			 if(!blockStyle)
			 {
				 blockStyle = new Block();
				 styles.push(blockStyle);
			 }
			 blockStyle.value = value;
			_block = value;
		}
		private var _blockEnd:*;

		public function get blockEnd():*
		{
			return _blockEnd;
		}
		private var blockEndStyle:BlockEnd;
		public function set blockEnd(value:*):void
		{	
			 if(!blockEndStyle)
			 {
				 blockEndStyle = new BlockEnd();
				 styles.push(blockEndStyle);
			 }
			 blockEndStyle.value = value;
			_blockEnd = value;
		}
		private var _blockStart:*;

		public function get blockStart():*
		{
			return _blockStart;
		}
		private var blockStartStyle:BlockStart;
		public function set blockStart(value:*):void
		{
			 if(!blockStartStyle)
			 {
				 blockStartStyle = new BlockStart();
				 styles.push(blockStartStyle);
			 }
			 blockStartStyle.value = value;
			_blockStart = value;
		}
		private var _inline:*;

		public function get inline():*
		{
			return _inline;
		}
		private var inlineStyle:Inline;
		public function set inline(value:*):void
		{
			if(!inlineStyle)
			 {
				 inlineStyle = new Inline();
				 styles.push(inlineStyle);
			 }
			 inlineStyle.value = value;
			_inline = value;
		}
		private var _inlineEnd:*;

		public function get inlineEnd():*
		{
			return _inlineEnd;
		}
		private var inlineEndStyle:InlineEnd;
		public function set inlineEnd(value:*):void
		{
			if(!inlineEndStyle)
			 {
				 inlineEndStyle = new InlineEnd();
				 styles.push(inlineEndStyle);
			 }
			 inlineEndStyle.value = value;
			_inlineEnd = value;
		}
		private var _inlineStart:*;

		public function get inlineStart():*
		{
			return _inlineStart;
		}
		private var inlineStartStyle:InlineStart;
		public function set inlineStart(value:*):void
		{
			if(!inlineStartStyle)
			 {
				 inlineStartStyle = new InlineStart();
				 styles.push(inlineStartStyle);
			 }
			 inlineStartStyle.value = value;
			_inlineStart = value;
		}
	}
}

import org.apache.royale.style.stylebeads.LeafStyleBase;

class Width extends LeafStyleBase
{
	public function Width(selectorPrefix:String = "border", rulePrefix:String = "border-width")
	{
		super(selectorPrefix, rulePrefix);
	}
	override public function set value(value:*):void
	{
		_value = value;
		calculatedRuleValue = value;
		calculatedSelector = sanitizeSelector(value);
	}
	override public function get selector():String
	{
		if(!calculatedSelector)
			return selectorBase;
		
		return super.selector;
	}
	override public function get rule():String
	{
		if(!calculatedRuleValue)
			return "1px";
		
		return super.rule;
	}
}
class Top extends Width
{
	public function Top()
	{
		super("border-t", "border-top-width");
	}
}
class Left extends Width
{
	public function Left()
	{
		super("border-l", "border-left-width");
	}
}
class Right extends Width
{
	public function Right()
	{
		super("border-r", "border-right-width");
	}
}
class Bottom extends Width
{
	public function Bottom()
	{
		super("border-b", "border-bottom-width");
	}
}
class Block extends Width
{
	public function Block()
	{
		super("border-y", "border-block-width");
	}
}
class BlockEnd extends Width
{
	public function BlockEnd()
	{
		super("border-be", "border-block-end-width");
	}
}
class BlockStart extends Width
{
	public function BlockStart()
	{
		super("border-bs", "border-block-start-width");
	}
}
class Inline extends Width
{
	public function Inline()
	{
		super("border-x", "border-inline-width");
	}
}
class InlineEnd extends Width
{
	public function InlineEnd()
	{
		super("border-e", "border-inline-end-width");
	}
}
class InlineStart extends Width
{
	public function InlineStart()
	{
		super("border-s", "border-inline-start-width");
	}
}