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

	public class GridAutoRows extends LeafStyleBase
	{
		public function GridAutoRows(value:* = null)
		{
			super("auto-rows", "grid-auto-rows", value);
		}

		override public function set value(value:*):void
		{
			// TODO validate aspect before setting
			_value = value;
			var ruleValue:String = value;
			var selectorValue:String = value;
			switch(value)
			{
				case "auto":
					break;
				case "min":
					ruleValue = "min-content";
					break;
				case "min-content":
					selectorValue = "min";
					break;
				case "max":
					ruleValue = "max-content";
					break;
				case "max-content":
					selectorValue = "max";
					break;
				case "fr":
					ruleValue = "minmax(0, 1fr)";
					break;
				default:
					break;
			}
			//TODO more validating and css vars
			assert(selectorValue.indexOf("--") != 0, "css variables for grid-auto-rows not yet supported: " + value);
			calculatedRuleValue = ruleValue;
			calculatedSelector = selectorValue;
			
		}
	}
}