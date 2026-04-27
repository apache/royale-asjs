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
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;

	public class InsetBase extends LeafStyleBase
	{
		public function InsetBase(selectorBase:String, ruleBase:String, value:* = null)
		{
			super(selectorBase, ruleBase, value);
		}
		private var savedPrefix:String;
		override public function set value(value:*):void
		{
			_value = value;
			var isNum:Boolean = parseFloat(value) == value;
			var isInt:Boolean = int(value) == value;
			var parseNum:Number = parseFloat(value);
			var isNegative:Boolean = parseNum < 0;

			if(isNegative)
			{
				if(!savedPrefix)
					savedPrefix = _selectorBase;
				_selectorBase = "-" + savedPrefix;
			}
			
			if(isInt)
			{
				calculatedSelector = "" + Math.abs(value);
				calculatedRuleValue = computeSpacing(value);
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
				if(value == "none")
					calculatedSelector = "hidden";
			}
		}
	}
}