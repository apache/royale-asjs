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
package org.apache.royale.style.stylebeads.background
{
	import org.apache.royale.style.stylebeads.SingleStyleBase;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.StyleTheme;

	public class BorderRadius extends SingleStyleBase
	{
		public function BorderRadius(selectorPrefix:String = "rounded", rulePrefix:String = "border-radius")
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
}