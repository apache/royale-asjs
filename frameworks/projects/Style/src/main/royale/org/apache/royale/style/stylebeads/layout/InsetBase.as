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
package org.apache.royale.style.stylebeads.layout
{
	import org.apache.royale.style.stylebeads.SingleStyleBase;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.ThemeManager;
	import org.apache.royale.style.util.CSSUnit;

	public class InsetBase extends SingleStyleBase
	{
		public function InsetBase(selectorPrefix:String, rulePrefix:String)
		{
			super(selectorPrefix, rulePrefix);
		}
		public var unit:String = CSSUnit.PX;
		protected var pixelValue:Number;
		private var savedPrefix:String;
		override public function set value(value:*):void
		{
			var isNum:Boolean = parseFloat(value) == value;
			var isInt:Boolean = int(value) == value;
			var parseNum:Number = parseFloat(value);
			var isNegative:Boolean = parseNum < 0;
			if(isNegative)
			{
				if(!savedPrefix)
					savedPrefix = _selectorPrefix;
				_selectorPrefix = "-" + savedPrefix;
			}
			
			if(isInt)
			{
				pixelValue = ThemeManager.instance.activeTheme.spacing * value;
				calculatedSelector = "" + Math.abs(value);
				calculatedRuleValue = CSSUnit.convert(pixelValue, CSSUnit.PX, unit) + unit;
			}
			else if(isNum)
			{
				calculatedSelector = "p" + Math.abs(value);
				calculatedRuleValue = (value * 100) + "%";
			}
			else
			{
				calculatedSelector = sanitizeSelector(value);
				calculatedRuleValue = value;
			}
			// assert(["inline","block","inline-block","flow-root","flex","inline-flex","grid","inline-grid","contents","table","inline-table","table-caption","table-cell","table-column","table-column-group","table-footer-group","table-header-group","table-row-group","table-row","list-item","none"].indexOf(value) >= 0, "Invalid value for display: " + value);
			_value = value;
			calculatedRuleValue = calculatedSelector = value;
			if(value == "none")
				calculatedSelector = "hidden";
		}
	}
}