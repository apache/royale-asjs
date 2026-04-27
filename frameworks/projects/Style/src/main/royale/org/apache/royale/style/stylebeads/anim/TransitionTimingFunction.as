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
package org.apache.royale.style.stylebeads.anim
{
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.style.util.StyleTheme;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.CSSLookup;
	import org.apache.royale.debugging.assert;

	public class TransitionTimingFunction extends LeafStyleBase
	{
		public function TransitionTimingFunction(value:* = null)
		{
			super("ease", "transition-timing-function", value);
		}
		override public function set value(value:*):void
		{
			_value = value;
			if (value is String && (value as String).indexOf(",") != -1)
			{
				var parts:Array = (value as String).split(",");
				var resolvedParts:Array = [];
				for (var i:int = 0; i < parts.length; i++)
				{
					resolvedParts.push(resolveTimingFunction(parts[i].trim()));
				}
				calculatedRuleValue = resolvedParts.join(", ");
				calculatedSelector = (value as String).replace(/,/g, "-").replace(/\s/g, "");
			}
			else
			{
				calculatedRuleValue = resolveTimingFunction(value);
				calculatedSelector = value;
			}
		}

		private function resolveTimingFunction(val:*):String
		{
			var ruleValue:String = val;
			var theme:StyleTheme = ThemeManager.instance.activeTheme;
			switch(val)
			{
				case "default":
					ruleValue = theme.defaultTransitionTimingFunction;
					break;
				case "in-out":
				case "ease-in-out":
					ruleValue = theme.easeInOut;
					break;
				case "in":
				case "ease-in":
					ruleValue = theme.easeIn;
					break;
				case "out":
				case "ease-out":
					ruleValue = theme.easeOut;
					break;
				case "ease":
					ruleValue = "ease";
					break;
				case "linear":
				case "initial":
					break;
				default:
					ruleValue = acceptVar(val as String);
					if (ruleValue == val)
					{
						ruleValue = CSSLookup.getProperty(val);
					}
					break;
			}
			assert(ruleValue, "transition-timing-function only accepts 'linear', 'ease', 'ease-in', 'ease-out', 'ease-in-out', 'initial', or a valid CSS timing function value");
			return ruleValue;
		}
	}
}