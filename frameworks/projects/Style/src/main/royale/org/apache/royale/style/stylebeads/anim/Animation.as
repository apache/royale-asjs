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
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.StyleTheme;
	import org.apache.royale.style.util.ThemeManager;

	public class Animation extends LeafStyleBase
	{
		public function Animation(value:* = null)
		{
			super("animate", "animation", value);
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

		override public function set value(v:*):void
		{
			assert(
				isVar(v) || v == "none" || (v is String && v.length > 0),
				"animation only accepts a valid animation name, 'none', or a CSS variable referencing an animation"
				);
			calculatedRuleValue = calculatedSelector = _value = v;
			if(isVar(v))
			{
				calculatedRuleValue = fromVar(v);
			}
			else
			{
				var theme:StyleTheme = ThemeManager.instance.activeTheme;
				switch(v)
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