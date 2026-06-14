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
package org.apache.royale.style.stylebeads.effects
{
	import org.apache.royale.style.stylebeads.StyleBeadBase;
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.style.util.StyleData;
	import org.apache.royale.style.util.StyleTheme;
	import org.apache.royale.style.util.ThemeManager;

	/**
	 * TODO: Figure this out. ring effects cannot be stacked in CSS.
	 * Tailwind uses @properties to create a single box-shadow property that combines all the properties.
	 * We avoided using @properties elsewhere.
	 * It might be simpler to just use `Outline` instead.
	 * https://tailwindcss.com/docs/box-shadow
	 */
	public class BoxShadow extends LeafStyleBase
	{
		public function BoxShadow(value:* = null, color:* = null)
		{
			super("shadow", "box-shadow");
			this.color = color;
			if(value != null)
				this.value = value;
		}

		public var color:*;
		public var inset:Boolean;

		[Inspectable(category="General", enumeration="none,2xs,xs,sm,md,lg,xl,2xl,inset-2xs,inset-xs,inset-sm", defaultValue="sm")]
		override public function set value(value:*):void
		{
			calculatedSelector = _value = value;
			if(isVar(value))
			{
				calculatedRuleValue = fromVar(value);
				return;
			}

			var theme:StyleTheme = ThemeManager.instance.activeTheme;
			var shadowLookup:Object = {
				"none": "none",
				"2xs": theme.shadow2XS,
				"xs": theme.shadowXS,
				"sm": theme.shadowSM,
				"md": theme.shadowMD,
				"lg": theme.shadowLG,
				"xl": theme.shadowXL,
				"2xl": theme.shadow2XL,
				"inset-2xs": theme.insetShadow2XS,
				"inset-xs": theme.insetShadowXS,
				"inset-sm": theme.insetShadowSM
			};
			if(shadowLookup[value] !== undefined)
				calculatedRuleValue = shadowLookup[value];
			else if(isColorValue(value))
			{
				var styleData:StyleData = validateColor(value, false);
				calculatedSelector = styleData.selector;
				calculatedRuleValue = "0 0 0 1px " + styleData.rule;
			}
			else
				calculatedRuleValue = value;

			if(inset && calculatedRuleValue != "none" && calculatedRuleValue.indexOf("inset") != 0)
			{
				calculatedRuleValue = "inset " + calculatedRuleValue;
				calculatedSelector = "inset-" + calculatedSelector;
			}
			if(color != null && calculatedRuleValue != "none")
			{
				calculatedRuleValue = applyColor(calculatedRuleValue, color);
				calculatedSelector += "-" + getColorSelector(color);
			}
		}

		public function getShadowSelector():String
		{
			return selectorBase + "-" + calculatedSelector;
		}

		public function getShadowValue():String
		{
			return calculatedRuleValue;
		}

		private function applyColor(shadow:String, color:*):String
		{
			var styleData:StyleData = validateColor(color, false);
			var ret:String = shadow.replace(/#[0-9a-fA-F]{3,8}\b/g, styleData.rule);
			return ret == shadow ? shadow + " " + styleData.rule : ret;
		}

		private function getColorSelector(color:*):String
		{
			var styleData:StyleData = validateColor(color, false);
			return styleData.selector;
		}

		private function isColorValue(value:*):Boolean
		{
			if(value == null || value == "none")
				return false;
			var stringValue:String = "" + value;
			if(stringValue.indexOf(" ") != -1)
				return false;
			return stringValue.indexOf("#") == 0 || stringValue.indexOf("-") != -1 || stringValue == "black" || stringValue == "white" || stringValue == "transparent" || isVar(stringValue);
		}
	}
}