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
	import org.apache.royale.style.stylebeads.CompositeStyle;

	public class BorderWidth extends CompositeStyle
	{
		public function BorderWidth(value:* = null, unit:String = "px")
		{
			super();
			this.unit = unit;
			if(value != width)
				width = value;
		}
		private var _width:*;

		public function get width():*
		{
			return _width;
		}
		private var widthStyle:Width;
		public function set width(value:*):void
		{
			_width = value;
			if(!widthStyle)
			 {
				 widthStyle = new Width("border", "border-width", value);
				 return addStyleBead(widthStyle);
			 }
			 widthStyle.value = value;
		}
		private var _top:*;

		public function get top():*
		{
			return _top;
		}
		private var topStyle:Top;
		public function set top(value:*):void
		{
			_top = value;
			if(!topStyle)
			 {
				 topStyle = new Top(value);
				 return addStyleBead(topStyle);
			 }
			 topStyle.value = value;
		}
		private var _left:*;

		public function get left():*
		{
			return _left;
		}
		private var leftStyle:Left;
		public function set left(value:*):void
		{
			_left = value;
			if(!leftStyle)
			 {
				 leftStyle = new Left(value);
				 return addStyleBead(leftStyle);
			 }
			 leftStyle.value = value;
		}
		private var _right:*;

		public function get right():*
		{
			return _right;
		}
		private var rightStyle:Right;
		public function set right(value:*):void
		{
			_right = value;
			 if(!rightStyle)
			 {
				 rightStyle = new Right(value);
				 return addStyleBead(rightStyle);
			 }
			 rightStyle.value = value;
		}
		private var _bottom:*;

		public function get bottom():*
		{
			return _bottom;
		}
		private var bottomStyle:Bottom;
		public function set bottom(value:*):void
		{
			_bottom = value;
			 if(!bottomStyle)
			 {
				 bottomStyle = new Bottom(value);
				 return addStyleBead(bottomStyle);
			 }
			 bottomStyle.value = value;
		}
		private var _block:*;

		public function get block():*
		{
			return _block;
		}
		private var blockStyle:Block;
		public function set block(value:*):void
		{
			_block = value;
			 if(!blockStyle)
			 {
				 blockStyle = new Block(value);
				 return addStyleBead(blockStyle);
			 }
			 blockStyle.value = value;
		}
		private var _blockEnd:*;

		public function get blockEnd():*
		{
			return _blockEnd;
		}
		private var blockEndStyle:BlockEnd;
		public function set blockEnd(value:*):void
		{	
			_blockEnd = value;
			 if(!blockEndStyle)
			 {
				 blockEndStyle = new BlockEnd(value);
				 return addStyleBead(blockEndStyle);
			 }
			 blockEndStyle.value = value;
		}
		private var _blockStart:*;

		public function get blockStart():*
		{
			return _blockStart;
		}
		private var blockStartStyle:BlockStart;
		public function set blockStart(value:*):void
		{
			_blockStart = value;
			 if(!blockStartStyle)
			 {
				 blockStartStyle = new BlockStart(value);
				 return addStyleBead(blockStartStyle);
			 }
			 blockStartStyle.value = value;
		}
		private var _inline:*;

		public function get inline():*
		{
			return _inline;
		}
		private var inlineStyle:Inline;
		public function set inline(value:*):void
		{
			_inline = value;
			if(!inlineStyle)
			 {
				 inlineStyle = new Inline(value);
				 return addStyleBead(inlineStyle);
			 }
			 inlineStyle.value = value;
		}
		private var _inlineEnd:*;

		public function get inlineEnd():*
		{
			return _inlineEnd;
		}
		private var inlineEndStyle:InlineEnd;
		public function set inlineEnd(value:*):void
		{
			_inlineEnd = value;
			if(!inlineEndStyle)
			 {
				 inlineEndStyle = new InlineEnd(value);
				 return addStyleBead(inlineEndStyle);
			 }
			 inlineEndStyle.value = value;
		}
		private var _inlineStart:*;

		public function get inlineStart():*
		{
			return _inlineStart;
		}
		private var inlineStartStyle:InlineStart;
		public function set inlineStart(value:*):void
		{
			_inlineStart = value;
			if(!inlineStartStyle)
			 {
				 inlineStartStyle = new InlineStart(value);
				 return addStyleBead(inlineStartStyle);
			 }
			 inlineStartStyle.value = value;
		}
	}
}

import org.apache.royale.style.stylebeads.LeafStyleBase;

	class Width extends LeafStyleBase
	{
		public function Width(selectorBase:String = "border", ruleBase:String = "border-width", value:* = null)
		{
			super(selectorBase, ruleBase, value);
		}
		override public function set value(value:*):void
		{
			_value = value;
			if(isNum(value))
			{
				calculatedRuleValue = computeSpacing(value);
			}
			else
			{
				calculatedRuleValue = acceptVar(value);
			}
			calculatedSelector = sanitizeSelector(value);
		}
	override public function getSelector():String
	{
		if(!calculatedSelector)
			return selectorBase;
		
		return super.getSelector();
	}
	override public function getRule():String
	{
		if(!calculatedRuleValue)
			return "1px";
		
		return super.getRule();
	}
}
class Top extends Width
{
	public function Top(value:* = null)
	{
		super("border-t", "border-top-width", value);
	}
}
class Left extends Width
{
	public function Left(value:* = null)
	{
		super("border-l", "border-left-width", value);
	}
}
class Right extends Width
{
	public function Right(value:* = null)
	{
		super("border-r", "border-right-width", value);
	}
}
class Bottom extends Width
{
	public function Bottom(value:* = null)
	{
		super("border-b", "border-bottom-width", value);
	}
}
class Block extends Width
{
	public function Block(value:* = null)
	{
		super("border-y", "border-block-width", value);
	}
}
class BlockEnd extends Width
{
	public function BlockEnd(value:* = null)
	{
		super("border-be", "border-block-end-width", value);
	}
}
class BlockStart extends Width
{
	public function BlockStart(value:* = null)
	{
		super("border-bs", "border-block-start-width", value);
	}
}
class Inline extends Width
{
	public function Inline(value:* = null)
	{
		super("border-x", "border-inline-width", value);
	}
}
class InlineEnd extends Width
{
	public function InlineEnd(value:* = null)
	{
		super("border-e", "border-inline-end-width", value);
	}
}
class InlineStart extends Width
{
	public function InlineStart(value:* = null)
	{
		super("border-s", "border-inline-start-width", value);
	}
}