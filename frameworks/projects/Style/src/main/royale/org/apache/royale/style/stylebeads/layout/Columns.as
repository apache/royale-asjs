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

	public class Columns extends LeafStyleBase
	{
		public function Columns(value:* = null)
		{
			super("columns", "columns", value);
		}
		private const presets:Array = ["3xs","2xs","xs","sm","md","lg","xl","2xl","3xl","4xl","5xl","6xl","7xl"];
		override public function set value(value:*):void
		{
			var validated:Boolean = false;
			var isPreset:Boolean;
			var isVar:Boolean;
			if(value == "auto")
				validated = true;
			
			else if(parseFloat(value) == value)
				validated = true;
			else if(presets.indexOf(value) >= 0)
			{
				validated = true;
				isPreset = true;
			}
			else if(value.indexOf("--") == 0)
			{
				validated = true;
				isVar = true;
			}
			assert(validated ||!isNaN(parseFloat(value)), "Invalid value for columns: " + value);
			// TODO calculate the value of presets using the container size in theme.
			assert(!isPreset, "Preset values for columns are not yet supported: " + value);
			_value = value;
			if(isVar)
			{
				calculatedSelector = "(" + value.substring(2) + ")";
				calculatedRuleValue = "var(" + value + ")";
			}
			else
			{
				calculatedRuleValue = calculatedSelector = value;
			}
		}
	}
}