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
package org.apache.royale.style.stylebeads.typography
{
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.StyleTheme;
	import org.apache.royale.style.util.ThemeManager;

	public class LineHeight extends LeafStyleBase
	{
		public function LineHeight(value:* = null)
		{
			super("leading", "line-height", value);
			unit = "rem";
		}
		/**
		 * The line-height property sets the height of a line box.
		 * If it's a number, this will be multiplied by default spacing.
		 * The default value is in rems.
		 */
		[Inspectable(category="General", enumeration="xs,sm,base,lg,xl,2xl,3xl,4xl,5xl,6xl,7xl,8xl,9xl", defaultValue="base")]
		override public function set value(value:*):void
		{
			// assert(isNum(value) || isVar(value) || value == "none", "Invalid value for line-height: " + value);
			calculatedSelector =  _value = value;
			if(isInt(value))
				calculatedRuleValue = computeSpacing(value);
			else if(isVar(value))
				calculatedRuleValue = fromVar(value);
			else
			{
				var theme:StyleTheme = ThemeManager.instance.activeTheme;
				var sizeLookup:Object = {
					"xs": theme.lineXS,
					"sm": theme.lineSM,
					"base": theme.lineBase,
					"lg": theme.lineLG,
					"xl": theme.lineXL,
					"2xl": theme.line2XL,
					"3xl": theme.line3XL,
					"4xl": theme.line4XL,
					"5xl": theme.line5XL,
					"6xl": theme.line6XL,
					"7xl": theme.line7XL,
					"8xl": theme.line8XL,
					"9xl": theme.line9XL
				};
				if(sizeLookup[value] !== undefined)
					calculatedRuleValue = sizeLookup[value];
				else
				calculatedRuleValue = value;
			}
		}
	}
}