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
package org.apache.royale.style.stylebeads.background
{
	import org.apache.royale.style.stylebeads.SingleStyleBase;
	import org.apache.royale.debugging.assert;

	public class OutlineStyle extends SingleStyleBase
	{
		public function OutlineStyle()
		{
			super("outline", "outline-style");
		}
		override public function set value(value:*):void
		{
			assert(["solid","dashed","dotted","double","hidden","none"].indexOf(value) >= 0, "The value must be a valid outline style: " + value);
			calculatedSelector = calculatedRuleValue = _value = value;
		}
		override public function get rule():String
		{
			// enable outline in in forced colors mode
			if(calculatedSelector == "hidden")
			{
				return "outline: 2px solid transparent; outline-offset: 2px;";
			}
			return super.rule;
		}
	}
}