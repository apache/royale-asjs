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

	public class GridTemplateColumns extends LeafStyleBase
	{
		public function GridTemplateColumns(value:* = null)
		{
			super("grid-cols", "grid-template-columns", value);
		}

		override public function set value(value:*):void
		{
			// TODO validate aspect before setting
			var ruleValue:String = value;
			var selectorValue:String = value;
			var isInt:Boolean = int(value) == value;
			if(isInt)
			{
				ruleValue = "repeat(" + value + ", minmax(0, 1fr))";
			}
			assert(selectorValue.indexOf("--") != 0, "css variables for grid-template-columns not yet supported: " + value);
			assert(selectorValue.indexOf(" ") == -1, "values with spaces for grid-template-columns not yet supported: " + value);
			calculatedRuleValue = ruleValue;
			calculatedSelector = selectorValue;
			_value = value;
		}
	}
}