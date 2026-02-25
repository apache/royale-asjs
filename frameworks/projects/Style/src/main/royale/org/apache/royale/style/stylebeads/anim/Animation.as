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
	import org.apache.royale.style.util.CSSLookup;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.StyleTheme;
	import org.apache.royale.style.util.ThemeManager;

	public class Animation extends SingleStyleBase
	{
		public function Animation()
		{
			super("animate", "animation");
		}

// need to figure out how to register keyframes, etc.

//animate-bounce	
//animation: var(--animate-bounce); /* bounce 1s infinite */

/**
@keyframes bounce {
  0%, 100% {
    transform: translateY(-25%);
    animation-timing-function: cubic-bezier(0.8, 0, 1, 1);
  }
  50% {
    transform: none;
    animation-timing-function: cubic-bezier(0, 0, 0.2, 1);
  }
}
 */

		override public function set value(value:*):void
		{
			var isVar:Boolean = CSSLookup.has(value);
			assert(
				isVar || ["spin","ping","pulse","bounce","none"].indexOf(value) != -1,
				"animation only accepts 'spin', 'ping', 'pulse', 'bounce', or a CSS variable referencing a valid animation"
				);
			calculatedRuleValue = calculatedSelector = _value = value;
			if(isVar)
			{
				calculatedRuleValue = CSSLookup.getProperty(value);
			}
			else
			{
				var theme:StyleTheme = ThemeManager.instance.activeTheme;
				switch(value)
				{
					case "spin":
						calculatedRuleValue = theme.animateSpin;
						break;
					case "ping":
						calculatedRuleValue = theme.animatePing;
						break;
					case "pulse":
						calculatedRuleValue = theme.animatePulse;
						break;
					case "bounce":
						calculatedRuleValue = theme.animateBounce;
						break;
					case "none":
						break;
				}
			}
		}		
	}
}