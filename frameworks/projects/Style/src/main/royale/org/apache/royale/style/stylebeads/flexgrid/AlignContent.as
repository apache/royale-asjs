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

	public class AlignContent extends LeafStyleBase
	{
		public function AlignContent(value:* = null)
		{
			super("content", "align-content", value);
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
		private function normalizeDistributedKeyword(value:String):String
		{
			switch(value)
			{
				case "between":
					return "space-between";
				case "around":
					return "space-around";
				case "evenly":
					return "space-evenly";
			}
			return value;
		}
		private function normalizeDistributedSelector(value:String):String
		{
			switch(value)
			{
				case "space-between":
					return "between";
				case "space-around":
					return "around";
				case "space-evenly":
					return "evenly";
			}
			return getAfterDash(value);
		}
		[Inspectable(category="General", enumeration="normal,center,safe center,start,end,safe end,flex-start,flex-end,safe flex-end,between,around,evenly,baseline,stretch", defaultValue="normal")]
		override public function set value(value:*):void
		{
			assert(["normal","center","safe center","center safe","start","end","safe end","end safe","flex-start","flex-end","safe flex-end","flex-end safe","between","around","evenly","space-between","space-around","space-evenly","baseline","stretch"].indexOf(value) >= 0, "Invalid value for align-content: " + value);
			_value = value;
			var vals:Array = normalizeSafeKeyword(value);
			calculatedRuleValue = normalizeDistributedKeyword(vals[0]);
			calculatedSelector = normalizeDistributedSelector(vals[0]);
			if(vals.length > 1)
			{
				calculatedRuleValue = vals[1] + " " + normalizeDistributedKeyword(vals[0]);
				calculatedSelector += "-" + vals[1];
			}
		}
	}
}