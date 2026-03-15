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
package org.apache.royale.style.stylebeads.interact
{
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;

	public class UserSelect extends LeafStyleBase
	{
		public function UserSelect(value:* = null)
		{
			super("select", "user-select", value);
		}
		override public function set value(value:*):void
		{
			assert(['auto','none','text','all'].indexOf(value) != -1, "Invalid value for user-select: " + value);
			calculatedRuleValue = calculatedSelector = _value = value;
		}
		override public function getRule():String
		{
			var rule:String = super.getRule();
			if(!rule)
				return "";
			// We need the webkit prefix for Safari.
			return "-webkit-" + rule + rule;
		}

	}
}