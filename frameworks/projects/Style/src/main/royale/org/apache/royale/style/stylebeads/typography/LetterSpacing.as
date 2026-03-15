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
	import org.apache.royale.style.util.StyleTheme;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.stylebeads.LeafStyleBase;

	public class LetterSpacing extends LeafStyleBase
	{
		public function LetterSpacing(value:* = null)
		{
			super("tracking", "letter-spacing", value);
		}
		[Inspectable(category="General", enumeration="tighter,tight,normal,wide,wider,widest", defaultValue="normal")]
		override public function set value(value:*):void
		{
			var styleTheme:StyleTheme = ThemeManager.instance.activeTheme;
			var valMapping:Object = {
				tighter: styleTheme.trackingTighter,
				tight: styleTheme.trackingTight,
				normal: styleTheme.trackingNormal,
				wide: styleTheme.trackingWide,
				wider: styleTheme.trackingWider,
				widest: styleTheme.trackingWidest
			};
			calculatedRuleValue = calculatedSelector = _value = value;
			if(isVar(value))
			{
				calculatedRuleValue = fromVar(value);
			}
			else if(valMapping[value] !== undefined)
			{
				calculatedRuleValue = valMapping[value];
			}
		}
	}
}