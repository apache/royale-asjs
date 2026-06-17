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
package org.apache.royale.style.stylebeads.spacing
{
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.stylebeads.LeafStyleBase;

	internal class Pad extends LeafStyleBase
	{
		public function Pad(selectorBase:String = "p", ruleBase:String = "padding", value:* = null)
		{
			super(selectorBase, ruleBase, value);
		}
		private function toSelector(value:String):String
		{
			return value.replace(" ", "-");
		}
		override public function set value(val:*):void
		{
			_value = val;
			var selectorValue:String = "" + val;
			var ruleValue:String = selectorValue;
			assert(selectorValue.indexOf("--") != 0, "css variables for grid-template-columns not yet supported: " + val);
			if(isNum(val))
			{
				assert(val >= 0, "Invalid value for padding: " + val);
				ruleValue = computeSpacing(val);
			}
			else
			{
				ruleValue = acceptVar(val);
			}
			calculatedRuleValue = ruleValue;
			calculatedSelector = toSelector(selectorValue);
		}
	}
}