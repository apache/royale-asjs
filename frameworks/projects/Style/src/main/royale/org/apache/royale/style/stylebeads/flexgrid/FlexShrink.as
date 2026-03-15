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

	public class FlexShrink extends LeafStyleBase
	{
		public function FlexShrink(value:* = null)
		{
			super("shrink", "flex-shrink", value);
		}

		override public function set value(value:*):void
		{
			// For now we're assuming that flex-shrink is only a number, but it can also be "initial" or "inherit"
			assert(parseFloat(value) == value && int(value) >= 0, "Invalid value for flex-shrink: " + value);
			calculatedRuleValue = calculatedSelector = _value = value;
			
		}
	}
}