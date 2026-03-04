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
	 * @royalesuppressexport
	 */
	public class Border extends CompositeStyle
	{
		public function Border()
		{
			super();
			styles = [];
		}
		private var _color:String;

		public function get color():String
		{
			return _color;
		}
		private var colorStyle:Color;
		public function set color(value:String):void
		{
			if(!colorStyle)
			{
				colorStyle = new Color();
				styles.push(colorStyle);
			}
			colorStyle.value = value;
			_color = value;
		}
		private var _style:String;

		public function get style():String
		{
			return _style;
		}
		private var styleStyle:Style;
		public function set style(value:String):void
		{
			if(!styleStyle)
			{
				styleStyle = new Style();
				styles.push(styleStyle);
			}
			styleStyle.value = value;
			_style = value;
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
				styles.push(widthStyle);
			}
			widthStyle.width = value;
			_width = value;
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
				styles.push(radiusStyle);
			}
			radiusStyle.radius = value;
			_radius = value;
		}
	}
}
import org.apache.royale.style.stylebeads.LeafStyleBase;
import org.apache.royale.style.util.StyleData;
import org.apache.royale.debugging.assert;

class Color extends LeafStyleBase
{
	public function Color()
	{
		super("border", "border-color");
	}
	override public function set value(value:*):void
	{
		_value = value;
		var styleData:StyleData = validateColor(value,false);
		calculatedSelector = styleData.selector;
		calculatedRuleValue = styleData.rule;
	}
}
class Style extends LeafStyleBase
{
	public function Style()
	{
		super("border", "border-style");
	}
	override public function set value(value:*):void
	{
		assert(["solid","dashed","dotted","double","hidden","none"].indexOf(value) >= 0, "The value must be a valid border style: " + value);
		calculatedSelector = calculatedRuleValue = _value = value;
	}
}