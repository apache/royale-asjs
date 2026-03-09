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
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.stylebeads.CompositeStyle;
	/**
	 * @royalesuppressexport
	 */
	public class Padding extends CompositeStyle
	{
		public function Padding()
		{
			super();
			styles = [];
		}
		public var unit:String = "px";
		private var paddingStyle:Pad;
		private var topStyle:Top;
		private var rightStyle:Right;
		private var bottomStyle:Bottom;
		private var leftStyle:Left;
		private var blockStyle:Block;
		private var blockStartStyle:BlockStart;
		private var blockEndStyle:BlockEnd;
		private var inlineStyle:Inline;
		private var inlineStartStyle:InlineStart;
		private var inlineEndStyle:InlineEnd;
		private var _padding:*;

		public function get padding():*
		{
			return _padding;
		}
		public function set padding(value:*):void
		{
			if(!paddingStyle)
			{
				paddingStyle = new Pad();
				paddingStyle.unit = unit;
				styles.push(paddingStyle);
			}
			paddingStyle.value = value;
			_padding = value;
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
				topStyle = new Top();
				topStyle.unit = unit;
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
				rightStyle = new Right();
				rightStyle.unit = unit;
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
				bottomStyle = new Bottom();
				bottomStyle.unit = unit;
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
				leftStyle = new Left();
				leftStyle.unit = unit;
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
				blockStyle = new Block();
				blockStyle.unit = unit;
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
				blockStartStyle = new BlockStart();
				blockStartStyle.unit = unit;
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
				blockEndStyle = new BlockEnd();
				blockEndStyle.unit = unit;
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
				inlineStyle = new Inline();
				inlineStyle.unit = unit;
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
				inlineStartStyle = new InlineStart();
				inlineStartStyle.unit = unit;
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
				inlineEndStyle = new InlineEnd();
				inlineEndStyle.unit = unit;
				styles.push(inlineEndStyle);
			}
			inlineEndStyle.value = value;
			_inlineEnd = value;
		}
	}
}

import org.apache.royale.debugging.assert;
import org.apache.royale.style.stylebeads.LeafStyleBase;
import org.apache.royale.style.util.ThemeManager;
import org.apache.royale.style.util.CSSUnit;

class Pad extends LeafStyleBase
{
	public function Pad(selectorBase:String = "p", ruleBase:String = "padding")
	{
		super(selectorBase, ruleBase);
	}
	private function toSelector(value:String):String
	{
		return value.replace(" ", "-");
	}
	override public function set value(value:*):void
	{
		var selectorValue:String = value;
		var ruleValue:String = selectorValue;
		assert(selectorValue.indexOf("--") != 0, "css variables for grid-template-columns not yet supported: " + value);
		if(int(value) == value)
		{
			assert(value >= 0, "Invalid value for padding: " + value);
			ruleValue = computeSpacing(value);
		}
		_value = value;
		calculatedRuleValue = ruleValue;
		calculatedSelector = toSelector(value);
	}
}
class Block extends Pad
{
	public function Block()
	{
		super("py", "padding-block");
	}
}
class BlockEnd extends Pad
{
	public function BlockEnd()
	{
		super("pbe", "padding-block-end");
	}
}
class BlockStart extends Pad
{
	public function BlockStart()
	{
		super("pbs", "padding-block-start");
	}
}
class Bottom extends Pad
{
	public function Bottom()
	{
		super("pb", "padding-bottom");
	}
}
class Inline extends Pad
{
	public function Inline()
	{
		super("px", "padding-inline");
	}
}
class InlineEnd extends Pad
{
	public function InlineEnd()
	{
		super("pe", "padding-inline-end");
	}
}
class InlineStart extends Pad
{
	public function InlineStart()
	{
		super("ps", "padding-inline-start");
	}
}
class Left extends Pad
{
	public function Left()
	{
		super("pl", "padding-left");
	}
}
class Right extends Pad
{
	public function Right()
	{
		super("pr", "padding-right");
	}
}
class Top extends Pad
{
	public function Top()
	{
		super("pt", "padding-top");
	}
}