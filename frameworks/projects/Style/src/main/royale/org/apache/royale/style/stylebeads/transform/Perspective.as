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
package org.apache.royale.style.stylebeads.transform
{
	import org.apache.royale.style.stylebeads.SingleStyleBase;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.CSSLookup;
	import org.apache.royale.style.util.StyleTheme;
	import org.apache.royale.style.util.ThemeManager;

	public class Perspective extends SingleStyleBase
	{
		public function Perspective()
		{
			super("perspective", "perspective");
		}
		
		override public function set value(value:*):void
		{
			var isVar:Boolean = CSSLookup.has(value);
			assert(isVar || ["dramatic","near","normal","midrange","distant","none"].indexOf(value) != -1, "Invalid value for perspective: " + value);
			calculatedSelector = _value = value;
			if(isVar)
				calculatedRuleValue = CSSLookup.getProperty(value);
			else
			{
				var theme:StyleTheme = ThemeManager.instance.activeTheme;
				switch(value)
				{
					case "dramatic":
						calculatedRuleValue = theme.perspectiveDramatic;
						break;
					case "near":
						calculatedRuleValue = theme.perspectiveNear;
						break;
					case "normal":
						calculatedRuleValue = theme.perspectiveNormal;
						break;
					case "midrange":
						calculatedRuleValue = theme.perspectiveMidrange;
						break;
					case "distant":
						calculatedRuleValue = theme.perspectiveDistant;
						break;
					case "none":
						calculatedRuleValue = "none";
						break;
					default:
						assert(false, "Invalid value for perspective: " + value);
						break;
				}
			}
		}
	}
}