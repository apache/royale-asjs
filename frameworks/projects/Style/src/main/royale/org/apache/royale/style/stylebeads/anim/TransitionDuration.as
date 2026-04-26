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
	import org.apache.royale.style.util.CSSLookup;
	import org.apache.royale.style.util.ThemeManager;

	public class TransitionDuration extends LeafStyleBase
	{
		public function TransitionDuration(value:* = null)
		{
			super("duration", "transition-duration", value);
		}

		override public function set value(val:*):void
		{
			_value = val;
			if(val == "default")
			{
				calculatedSelector = val;
				calculatedRuleValue = ThemeManager.instance.activeTheme.defaultTransitionDuration;
			}
			else if(isVar(val))
			{
				calculatedSelector = val;
				calculatedRuleValue = fromVar(val);
			}
			else if(isInt(val))
			{
				assert(val >= 0, "transition-duration only accepts non-negative integers representing milliseconds");
				calculatedSelector = val;
				calculatedRuleValue = val + "ms";
			}
			else if(val is String)
			{
				// Handle comma separated durations like '130ms, 130ms, 0s'
				var durations:Array = (val as String).split(",");
				var formattedDurations:Array = [];
				for (var i:int = 0; i < durations.length; i++)
				{
					var duration:String = durations[i].trim();
					// If it's a number, assume it's milliseconds and add the unit
					if (isInt(duration))
					{
						formattedDurations.push(duration + "ms");
					}
					else
					{
						// Assume it already has a unit (ms, s) or it's a variable
						var resolved:String = acceptVar(duration);
						assert(resolved, "transition-duration only accepts valid CSS variables, non-negative integers representing milliseconds, or a comma-separated sequence of durations");
						formattedDurations.push(resolved);
					}
				}
				calculatedSelector = (val as String).replace(/,/g, "-").replace(/\s/g, "");
				calculatedRuleValue = formattedDurations.join(", ");
			}
			else
			{
				assert(false, "transition-duration only accepts valid CSS variables, non-negative integers representing milliseconds, or a comma-separated sequence of durations");
			}
		}
	}
}