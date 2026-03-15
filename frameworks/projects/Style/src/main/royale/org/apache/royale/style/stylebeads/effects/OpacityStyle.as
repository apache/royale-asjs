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
package org.apache.royale.style.stylebeads.effects
{
	import org.apache.royale.style.stylebeads.StyleBeadBase;
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.CSSLookup;

	public class OpacityStyle extends LeafStyleBase
	{
		public function OpacityStyle(value:* = null)
		{
			super("opacity", "opacity", value);
		}
		/**
		 * Acepts a number between 0 and 100 representing percentage, or a CSS variable that resolves to such a number.
		 * The value is converted to a percentage string when applied as a style rule.
		 * 
		 * @royaleignorecoercion Number
		 */
		override public function set value(value:*):void
		{
			var val:Number = isVar(value) ? fromVar(value) as Number : parseFloat(value);
			assert(val >= 0 && val <= 100, "opacity only accepts valid CSS variables or numbers between 0 and 100 representing percentage");
			calculatedSelector = _value = value;
			calculatedRuleValue = val + "%";
		}
	}
}