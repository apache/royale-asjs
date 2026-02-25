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
package org.apache.royale.style.stylebeads.tables
{
	import org.apache.royale.style.stylebeads.SingleStyleBase;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.CSSLookup;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.CSSUnit;

	public class BorderSpacing extends SingleStyleBase
	{
		public function BorderSpacing()
		{
			super("border-spacing", "border-spacing");
		}
		public var unit:String = "px";
		private var _x:*;
		public function set x(value:*):void
		{
			_x = value;
			validateVals([_x, _y]);
		}
		private var _y:*;
		public function set y(value:*):void
		{
			_y = value;
			validateVals([_x, _y]);
		}
		override public function set value(value:*):void
		{
			_x = _y = undefined;
			_value = value;
			validateVals([value]);
		}
		private function validateVals(vals:Array):void
		{
			var selectorValue:Array = value;
			var ruleValue:Array = value;
			for(var i:int = 0; i < vals.length; i++)
			{
				var validated:Boolean = false;
				var val:* = vals[i];
				if(!val)
				{
					selectorValue[i] = "0";
					ruleValue[i] = "0";
					continue;
				}
				var isInt:Boolean = int(val) == val;
				if(isInt)
				{
					validated = true;
					var pixelValue:Number = ThemeManager.instance.activeTheme.spacing * val;
					selectorValue[i] = "" + Math.abs(val);
					ruleValue[i] = CSSUnit.convert(pixelValue, CSSUnit.PX, unit) + unit;
				}
				else if(CSSLookup.has(val))
				{
					validated = true;
					ruleValue[i] = CSSLookup.getProperty(val);
				}
			}
			if(vals.length == 1)
			{
				calculatedRuleValue = ruleValue[0];
				calculatedSelector = sanitizeSelector(selectorValue[0]);
			}
			else
			{
				calculatedRuleValue = ruleValue.join(" ");
				calculatedSelector = sanitizeSelector(selectorValue.join("-"));
			}
		}
	}
}