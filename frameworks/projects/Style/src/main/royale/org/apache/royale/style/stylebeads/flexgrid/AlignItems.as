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
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;

	public class AlignItems extends LeafStyleBase
	{
		public function AlignItems()
		{
			super("items", "align-items");
		}

		private function normalizeSafeKeyword(value:String):Array
		{
			COMPILE::JS
			{
				if (value.indexOf("safe") >= 0)
				{
					value = value.replace("safe", "").trim();
					return [value,"safe"];
				}
			}
			return [value];
		}
		override public function set value(value:*):void
		{
			assert(["flex-start","flex-end","safe flex-end","flex-end safe","center","safe center","center safe","baseline","last baseline","stretch"].indexOf(value) >= 0, "Invalid value for align-items: " + value);
			_value = value;
			var vals:Array = normalizeSafeKeyword(value);
			calculatedRuleValue = vals[0];
			calculatedSelector = getAfterDash(vals[0]);
			if(vals.length > 1)
			{
				calculatedRuleValue = vals[1] + " " + vals[0];
				calculatedSelector += "-" + vals[1];
			}
		}
	}
}