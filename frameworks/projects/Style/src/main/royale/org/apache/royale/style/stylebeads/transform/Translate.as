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

	public class Translate extends SingleStyleBase
	{
		public function Translate()
		{
			super("translate", "translate");
		}
		//TODO: Not implemented. Add support for x, y and z.
		override public function set value(value:*):void
		{
			var negative:Boolean = value + "".indexOf("-") == 0;

				var isInt:Boolean = int(value) == value;
				if(isInt)
				{
					// validated = true;
					// var pixelValue:Number = ThemeManager.instance.activeTheme.spacing * val;
					// selectorValue[i] = "" + Math.abs(val);
					// ruleValue[i] = CSSUnit.convert(pixelValue, CSSUnit.PX, unit) + unit;
				}


			assert(isInt || value == "none", "Invalid value for translate: " + value);
			calculatedSelector = calculatedRuleValue = _value = value;
		}
	}
}