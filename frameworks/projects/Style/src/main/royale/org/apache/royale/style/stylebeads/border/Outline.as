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

	public class Outline extends CompositeStyle
	{
		public function Outline(width:*=null, style:*=null, color:*=null, offset:*=null)
		{
			super();
			if (width != null)
				this.width = width;
			if (style != null)
				this.style = style;
			if (color != null)
				this.color = color;
			if (offset != null)
				this.offset = offset;
		}
		private var _color:String;

		public function get color():String
		{
			return _color;
		}
		private var colorStyle:BorderColor;
		public function set color(value:String):void
		{
			_color = value;
			if(!colorStyle)
			{
				colorStyle = new BorderColor("outline", "outline-color", value);
				return addStyleBead(colorStyle);
			}
			colorStyle.value = value;
		}
		private var _offset:*;
		public function get offset():*
		{
			return _offset;
		}
		private var offsetStyle:Offset;
		public function set offset(value:*):void
		{
			_offset = value;
			if(!offsetStyle)
			{
				offsetStyle = new Offset(value);
				return addStyleBead(offsetStyle);
			}
			offsetStyle.value = value;
		}
		private var _style:String;
		public function get style():String
		{
			return _style;
		}
		private var styleStyle:BorderStyle;
		public function set style(value:String):void
		{
			_style = value;
			if(!styleStyle)
			{
				styleStyle = new Style(value);
				return addStyleBead(styleStyle);
			}
			styleStyle.value = value;
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
				widthStyle = new Width(value);
				return addStyleBead(widthStyle);
			}
			widthStyle.value = value;
		}
	}
}

import org.apache.royale.style.stylebeads.LeafStyleBase;
import org.apache.royale.debugging.assert;
import org.apache.royale.style.stylebeads.border.BorderStyle;

class Offset extends LeafStyleBase
{
	public function Offset(value:* = null)
	{
		super("outline-offset", "outline-offset", value);
	}
	private var savedPrefix:String;
	override public function set value(value:*):void
	{
		var val:* = value;
		var numVal:Number = parseFloat(val);
		var negative:Boolean = numVal < 0;
		if(!savedPrefix)
			savedPrefix = selectorBase;
		_selectorBase = negative ? "-" + savedPrefix : savedPrefix;
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
}
class Style extends BorderStyle
{
	public function Style(value:* = null)
	{
		super("outline", "outline-style", value);
	}
	override public function getRule():String
	{
		// enable outline in in forced colors mode
		if(calculatedSelector == "hidden")
		{
			return "outline: 2px solid transparent; outline-offset: 2px;";
		}
		return super.getRule();
	}
}
class Width extends LeafStyleBase
{
	public function Width(value:* = null)
	{
		super("outline", "outline-width", value);
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