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

	public class Order extends SingleStyleBase
	{
		public function Order()
		{
			super("order", "order");
		}
		private var savedPrefix:String;
		override public function set value(value:*):void
		{
			var isNum:Boolean = parseFloat(value) == value;
			assert(isNum || value.indexOf("--") != 0, "css variables for order not yet supported: " + value);
			assert(isNum || value == "first" || value == "last" || value == "none", "Invalid value for order: " + value);
			_value = value;
			var ruleValue:String = value;
			var selectorValue:String = value;
			var negative:Boolean = false;
			if(isNum && value < 0)
			{
				negative = true;
				if(!savedPrefix)
					savedPrefix = _selectorPrefix;
				
				_selectorPrefix = "-" + savedPrefix;
				selectorValue = "" + (-value);
			}
			switch(value)
			{
				case "first":
					ruleValue = "-9999";
					break;
				case "last":
					ruleValue = "9999";
					break;
				case "none":
					ruleValue = "0";
					break;
				default:
					break;
			}
			// TODO validate aspect before setting
			calculatedRuleValue = ruleValue;
			calculatedSelector = selectorValue;
			
		}
	}
}