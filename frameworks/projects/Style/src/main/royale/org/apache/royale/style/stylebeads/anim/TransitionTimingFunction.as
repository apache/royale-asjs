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
	import org.apache.royale.style.stylebeads.SingleStyleBase;
	import org.apache.royale.style.util.StyleTheme;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.CSSLookup;
	import org.apache.royale.debugging.assert;

	public class TransitionTimingFunction extends SingleStyleBase
	{
		public function TransitionTimingFunction()
		{
			super("ease", "transition-timing-function");
		}
		override public function set value(value:*):void
		{
			var ruleValue:String = value;
			var selectorValue:String = value;
			var theme:StyleTheme = ThemeManager.instance.activeTheme;
			switch(value)
			{
				case "in":
					ruleValue = theme.easeIn;
					break;
				case "out":
					ruleValue = theme.easeOut;
					break;
				case "in-out":
					ruleValue = theme.easeInOut;
					break;
				case "linear":
				case "initial":
					break;
				default:
					ruleValue = CSSLookup.getProperty(value);
					break;
			}
			assert(ruleValue, "transition-timing-function only accepts 'linear', 'in', 'out', 'in-out', 'initial', or a valid CSS timing function value");
			_value = value;
			calculatedSelector = selectorValue;
			calculatedRuleValue = ruleValue;
		}
	}
}