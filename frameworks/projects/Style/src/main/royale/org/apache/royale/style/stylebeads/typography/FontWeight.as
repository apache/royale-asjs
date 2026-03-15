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
package org.apache.royale.style.stylebeads.typography
{

	import org.apache.royale.style.stylebeads.LeafStyleBase;

	public class FontWeight extends LeafStyleBase
	{
		public function FontWeight(value:* = null)
		{
			super("font", "font-weight", value);
		}
		[Inspectable(category="General", enumeration="thin,extralight,light,normal,medium,semibold,bold,extrabold,black,100,200,300,400,500,600,700,800,900", defaultValue="normal")]
		override public function set value(value:*):void
		{
			var numMapping:Object = {
				"100": "thin",
				"200": "extralight",
				"300": "light",
				"400": "normal",
				"500": "medium",
				"600": "semibold",
				"700": "bold",
				"800": "extrabold",
				"900": "black"
			};
			var nameMapping:Object = {
				"thin": "100",
				"extralight": "200",
				"light": "300",
				"normal": "400",
				"medium": "500",
				"semibold": "600",
				"bold": "700",
				"extrabold": "800",
				"black": "900"
			};
			calculatedRuleValue = calculatedSelector = _value = value;
			if(numMapping[value] !== undefined)
			{
				calculatedSelector = numMapping[value];
			}
			else if(nameMapping[value] !== undefined)
			{
				calculatedRuleValue = nameMapping[value];
			}
			else if(isVar(value))
			{
				calculatedRuleValue = fromVar(value);
			}
		}

	}
}