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
package org.apache.royale.style.stylebeads.flexgrid
{
	import org.apache.royale.style.stylebeads.SingleStyleBase;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.CSSUnit;

	public class Gap extends SingleStyleBase
	{
		public function Gap(selectorPrefix:String="gap", rulePrefix:String="gap")
		{
			super(selectorPrefix, rulePrefix);
		}

		public var unit:String = "px";

		override public function set value(value:*):void
		{
			_value = value;
			// TODO validate aspect before setting
			var ruleProp:* = value;
			if(parseInt(value, 10) == value)
			{
				assert(value >= 0, "Invalid value for gap: " + value);
				var pixelValue:Number = ThemeManager.instance.activeTheme.spacing * value;
				calculatedSelector = "" + value;
				calculatedRuleValue = CSSUnit.convert(pixelValue, CSSUnit.PX, unit) + unit;
			}
			else
			{
				calculatedRuleValue = calculatedSelector = value;
			}
			
		}
	}
}