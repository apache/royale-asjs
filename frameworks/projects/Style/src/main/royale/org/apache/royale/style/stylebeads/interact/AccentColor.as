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
	import org.apache.royale.style.stylebeads.SingleStyleBase;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.CSSLookup;

	public class AccentColor extends SingleStyleBase
	{
		public function AccentColor()
		{
			super("accent-color", "accent-color");
		}
		override public function set value(value:*):void
		{
			var isVar:Boolean = CSSLookup.has(value);
			assert(isVar || ['black','white','inherit','currentColor','transparent'].indexOf(value) != -1, "Invalid value for accent-color: " + value);
			calculatedRuleValue = calculatedSelector = _value = value;
			if(isVar)
				calculatedRuleValue = CSSLookup.getProperty(value);
			else
			{
				switch(value)
				{
					case "black":
						calculatedRuleValue = "#000";
						break;
					case "white":
						calculatedRuleValue = "#fff";
						break;
					case "inherit":
					case "currentColor":
					case "transparent":
						break;
					default:
						assert(false, "Invalid value for accent-color: " + value);
				}
			}
		}
	}
}