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
	public class BorderRadius extends CompositeStyle
	{
		public function BorderRadius(value:* = null, unit:String = "px")
		{
			super();
			styles = [];
			this.unit = unit;
			//because of @royalesuppressexport, the following did not work in release/minified build from within this constructor when using the radius setter directly:
			//if (value) radius = value;
			//however a usage of the getter here will make the setter usage survive minification:
			if (value != radius) radius = value;
			//another option that worked was to isolate the setter's internals into a separate private method and call that directly (as would the setter itself).
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
				styles.push(rStyle);
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
				styles.push(tlStyle);
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
				styles.push(trStyle);
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
				styles.push(blStyle);
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
				styles.push(brStyle);
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
				styles.push(ssStyle);
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
				styles.push(seStyle);
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
				styles.push(esStyle);
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
				styles.push(eeStyle);
			}
			_endEnd = value;
			eeStyle.value = value;
		}
	}
}

import org.apache.royale.style.util.StyleTheme;
import org.apache.royale.style.util.ThemeManager;
import org.apache.royale.style.stylebeads.LeafStyleBase;

class Radius extends LeafStyleBase
{
	public function Radius(selectorBase:String = "rounded", ruleBase:String = "border-radius", value:* = null)
	{
		super(selectorBase, ruleBase, value);
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
	public function TopRight(value:* = null)
	{
		super("rounded-tr", "border-top-right-radius", value);
	}
}
class TopLeft extends Radius
{
	public function TopLeft(value:* = null)
	{
		super("rounded-tl", "border-top-left-radius", value);
	}
}
class StartStart extends Radius
{
	public function StartStart(value:* = null)
	{
		super("rounded-ss", "border-start-start-radius", value);
	}
}
class StartEnd extends Radius
{
	public function StartEnd(value:* = null)
	{
		super("rounded-se", "border-start-end-radius", value);
	}
}
class EndStart extends Radius
{
	public function EndStart(value:* = null)
	{
		super("rounded-es", "border-end-start-radius", value);
	}
}
class EndEnd extends Radius
{
	public function EndEnd(value:* = null)
	{
		super("rounded-ee", "border-end-end-radius", value);
	}
}
class BottomRight extends Radius
{
	public function BottomRight(value:* = null)
	{
		super("rounded-br", "border-bottom-right-radius", value);
	}
}
class BottomLeft extends Radius
{
	public function BottomLeft(value:* = null)
	{
		super("rounded-bl", "border-bottom-left-radius", value);
	}
}