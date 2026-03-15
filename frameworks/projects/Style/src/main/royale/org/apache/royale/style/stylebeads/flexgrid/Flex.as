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

	public class Flex extends LeafStyleBase
	{
		public function Flex(value:* = null)
		{
			super("flex", "flex", value);
		}

		override public function set value(value:*):void
		{
			COMPILE::JS
			{
				value = value.trim();
				// TODO validate aspect before setting
				calculatedRuleValue = calculatedSelector = _value = value;
				var isNum:Boolean = parseFloat(value) == value;
				var isInt:Boolean = int(value) == value;
				if(isNum && !isInt)
					calculatedRuleValue = (value * 100) + "%";

				 else if(value == "0 auto")
					calculatedSelector = "initial";

				//TODO css vars
			}
			
		}
	}
}