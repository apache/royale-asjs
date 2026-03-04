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
	import org.apache.royale.style.util.StyleTheme;
	import org.apache.royale.style.util.ThemeManager;

	public class FontSize extends LeafStyleBase
	{
		public function FontSize()
		{
			super("font-size", "font-size");
		}
		[Inspectable(category="General", enumeration="one,two,three", defaultValue="one")]
		override public function set value(value:*):void
		{
			calculatedSelector =  _value = value;
			if(isInt(value))
				calculatedRuleValue = computeSpacing(value);
			else if(isVar(value))
				calculatedRuleValue = fromVar(value);
			else
			{
				var theme:StyleTheme = ThemeManager.instance.activeTheme;
				var sizeLookup:Object = {
					"xs": theme.textXS,
					"sm": theme.textSM,
					"base": theme.textBase,
					"lg": theme.textLG,
					"xl": theme.textXL,
					"2xl": theme.text2XL,
					"3xl": theme.text3XL,
					"4xl": theme.text4XL,
					"5xl": theme.text5XL,
					"6xl": theme.text6XL,
					"7xl": theme.text7XL,
					"8xl": theme.text8XL,
					"9xl": theme.text9XL
				};
				if(sizeLookup[value] !== undefined)
					calculatedRuleValue = sizeLookup[value];
				else
				calculatedRuleValue = value;
			}
		}
	}
}