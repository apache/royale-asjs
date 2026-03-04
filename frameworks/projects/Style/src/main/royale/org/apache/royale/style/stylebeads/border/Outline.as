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
	 * @royalesuppressexport
	 */
	public class Outline extends CompositeStyle
	{
		public function Outline()
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
		private var _offset:*;
		public function get offset():*
		{
			return _offset;
		}
		private var offsetStyle:Offset;
		public function set offset(value:*):void
		{
			if(!offsetStyle)
			{
				offsetStyle = new Offset();
				styles.push(offsetStyle);
			}
			offsetStyle.value = value;
			_offset = value;
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
	}
}
import org.apache.royale.style.stylebeads.LeafStyleBase;
import org.apache.royale.style.util.StyleData;
import org.apache.royale.debugging.assert;

class Color extends LeafStyleBase
{
	public function Color()
	{
		super("outline", "outline-color");
	}
	/**
	 * @royaleignorecoercion org.apache.royale.style.colors.ColorPair
	 */
	override public function set value(value:*):void
	{
		_value = value;
		var styleData:StyleData = validateColor(value,false);
		calculatedRuleValue = styleData.rule;
		calculatedSelector = styleData.selector;
	}
}
class Offset extends LeafStyleBase
{
	public function Offset()
	{
		super("outline-offset", "outline-offset");
	}
	private var savedPrefix:String;
	override public function set value(value:*):void
	{
		var numVal:Number = parseFloat(value);
		var negative:Boolean = numVal < 0;
		if(!savedPrefix)
			savedPrefix = selectorBase;
		_selectorBase = negative ? "-" + savedPrefix : savedPrefix;
		_value = value;
		calculatedRuleValue = value;
		calculatedSelector = sanitizeSelector(value);
	}
}
class Style extends LeafStyleBase
{
	public function Style()
	{
		super("outline", "outline-style");
	}
	override public function set value(value:*):void
	{
		assert(["solid","dashed","dotted","double","hidden","none"].indexOf(value) >= 0, "The value must be a valid outline style: " + value);
		calculatedSelector = calculatedRuleValue = _value = value;
	}
	override public function get rule():String
	{
		// enable outline in in forced colors mode
		if(calculatedSelector == "hidden")
		{
			return "outline: 2px solid transparent; outline-offset: 2px;";
		}
		return super.rule;
	}
}
class Width extends LeafStyleBase
{
	public function Width()
	{
		super("outline", "outline-width");
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