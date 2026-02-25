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
	import org.apache.royale.style.stylebeads.SingleStyleBase;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.StyleTheme;
	import org.apache.royale.style.stylebeads.CompositeStyle;

	public class BorderRadius extends CompositeStyle
	{
		public function BorderRadius()
		{
			super();
		}

		private var _radius:*;
		public function get radius():*
		{
			return _radius;
		}
		private var rStyle:Radius;
		public function set radius(value:*):void
		{
			if(!rStyle)
			{
				rStyle = new Radius();
				_styles.push(rStyle);
			}
			_radius = value;
			rStyle.value = value;
		}
		private var _topLeft:*;
		public function get topLeft():*
		{
			return _topLeft;
		}

		private var tlStyle:TopLeft;
		public function set topLeft(value:*):void
		{
			if(!tlStyle)
			{
				tlStyle = new TopLeft();
				_styles.push(tlStyle);
			}
			_topLeft = value;
			tlStyle.value = value;
		}
		private var _topRight:*;
		public function get topRight():*
		{
			return _topRight;
		}
		private var trStyle:TopRight;
		public function set topRight(value:*):void
		{
			if(!trStyle)
			{
				trStyle = new TopRight();
				_styles.push(trStyle);
			}
			_topRight = value;
			trStyle.value = value;
		}
		private var _bottomLeft:*;
		public function get bottomLeft():*
		{
			return _bottomLeft;
		}
		private var blStyle:BottomLeft;
		public function set bottomLeft(value:*):void
		{
			if(!blStyle)
			{
				blStyle = new BottomLeft();
				_styles.push(blStyle);
			}
			_bottomLeft = value;
			blStyle.value = value;
		}
		private var _bottomRight:*;
		public function get bottomRight():*
		{
			return _bottomRight;
		}
		private var brStyle:BottomRight;
		public function set bottomRight(value:*):void
		{
			if(!brStyle)
			{
				brStyle = new BottomRight();
				_styles.push(brStyle);
			}
			_bottomRight = value;
			brStyle.value = value;
		}
		private var _startStart:*;
		public function get startStart():*
		{
			return _startStart;
		}
		private var ssStyle:StartStart;
		public function set startStart(value:*):void
		{
			if(!ssStyle)
			{
				ssStyle = new StartStart();
				_styles.push(ssStyle);
			}
			_startStart = value;
			ssStyle.value = value;
		}
		private var _startEnd:*;
		public function get startEnd():*
		{
			return _startEnd;
		}
		private var seStyle:StartEnd;
		public function set startEnd(value:*):void
		{
			if(!seStyle)
			{
				seStyle = new StartEnd();
				_styles.push(seStyle);
			}
			_startEnd = value;
			seStyle.value = value;
		}
		private var _endStart:*;
		public function get endStart():*
		{
			return _endStart;
		}
		private var esStyle:EndStart;
		public function set endStart(value:*):void
		{
			if(!esStyle)
			{
				esStyle = new EndStart();
				_styles.push(esStyle);
			}
			_endStart = value;
			esStyle.value = value;
		}
		private var _endEnd:*;
		public function get endEnd():*
		{
			return _endEnd;
		}
		private var eeStyle:EndEnd;
		public function set endEnd(value:*):void
		{
			if(!eeStyle)
			{
				eeStyle = new EndEnd();
				_styles.push(eeStyle);
			}
			_endEnd = value;
			eeStyle.value = value;
		}
	}
}
import org.apache.royale.style.stylebeads.border.BorderRadius;
import org.apache.royale.style.util.StyleTheme;
import org.apache.royale.style.util.ThemeManager;
import org.apache.royale.style.stylebeads.SingleStyleBase;

class Radius extends SingleStyleBase
{
	public function Radius(selectorPrefix:String = "rounded", rulePrefix:String = "border-radius")
	{
		super(selectorPrefix, rulePrefix);
	}
	override public function set value(value:*):void
	{
		var selectorValue:String = value;
		var ruleValue:String = value;
		var theme:StyleTheme = ThemeManager.instance.activeTheme;
		switch(value)
		{
			case "xs":
				ruleValue = theme.radiusXS;
				break;
			case "sm":
				ruleValue = theme.radiusSM;
				break;
			case "md":
				ruleValue = theme.radiusMD;
				break;
			case "lg":
				ruleValue = theme.radiusLG;
				break;
			case "xl":
				ruleValue = theme.radiusXL;
				break;
			case "2xl":
				ruleValue = theme.radius2XL;
				break;
			case "3xl":
				ruleValue = theme.radius3XL;
				break;
			case "4xl":
				ruleValue = theme.radius4XL;
				break;
			case "none":
				ruleValue = "0";
				break;
			case "full":
				ruleValue = "calc(infinity * 1px)";
				break;
			default:
				ruleValue = value;
				selectorValue = sanitizeSelector(value);
				break;
		}
		_value = value;
		calculatedRuleValue = ruleValue;
		calculatedSelector = selectorValue;
	}
}
class TopRight extends Radius
{
	public function TopRight()
	{
		super("rounded-tr", "border-top-right-radius");
	}
}
class TopLeft extends Radius
{
	public function TopLeft()
	{
		super("rounded-tl", "border-top-left-radius");
	}
}
class StartStart extends Radius
{
	public function StartStart()
	{
		super("rounded-ss", "border-start-start-radius");
	}
}
class StartEnd extends Radius
{
	public function StartEnd()
	{
		super("rounded-se", "border-start-end-radius");
	}
}
class EndStart extends Radius
{
	public function EndStart()
	{
		super("rounded-es", "border-end-start-radius");
	}
}
class EndEnd extends Radius
{
	public function EndEnd()
	{
		super("rounded-ee", "border-end-end-radius");
	}
}
class BottomRight extends Radius
{
	public function BottomRight()
	{
		super("rounded-br", "border-bottom-right-radius");
	}
}
class BottomLeft extends Radius
{
	public function BottomLeft()
	{
		super("rounded-bl", "border-bottom-left-radius");
	}
}