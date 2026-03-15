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

	public class FontFamily extends LeafStyleBase
	{
		public function FontFamily(value:* = null)
		{
			super("font", "font-family", value);
		}
		/**
		 * Accepts a font family name, or one of the following keywords:
		 * sans, serif, mono
		 */
		[Inspectable(category="General", enumeration="sans,serif,mono", defaultValue="one")]
		override public function set value(value:*):void
		{
			calculatedSelector = _value = value;
			if(isVar(value))
			{
				calculatedRuleValue = fromVar(value);
				calculatedSelector = "font-family-" + value;
			}
			else
			{
				var theme:StyleTheme = ThemeManager.instance.activeTheme;
				switch(value)
				{
					case "sans":
						calculatedRuleValue = theme.defaultSansFamily;
						if(theme.defaultSansFeatures)
						{
							calculatedRuleValue += "; font-feature-settings: " + theme.defaultSansFeatures;
						}
						break;
					case "serif":
						calculatedRuleValue = theme.defaultSerifFamily;
						if(theme.defaultSerifFeatures)						{
							calculatedRuleValue += "; font-feature-settings: " + theme.defaultSerifFeatures;
						}
						break;
					case "mono":
						calculatedRuleValue = theme.defaultMonoFontFamily;
						if(theme.defaultMonoFeatures)						{
							calculatedRuleValue += "; font-feature-settings: " + theme.defaultMonoFeatures;
						}
						break;
					default:
						calculatedRuleValue = value;
				}
			}
		}
	}
}