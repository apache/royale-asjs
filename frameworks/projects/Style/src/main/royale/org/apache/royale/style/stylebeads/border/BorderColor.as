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
	import org.apache.royale.style.colors.ColorPair;

	public class BorderColor extends SingleStyleBase
	{
		public function BorderColor()
		{
			super("border", "border-color");
		}
		/**
		 * @royaleignorecoercion org.apache.royale.style.colors.ColorPair
		 */
		override public function set value(value:*):void
		{
			assert(value is ColorPair, "The value must be a ColorPair: " + value);
			_value = value;
			var pair:ColorPair = value as ColorPair;
			calculatedRuleValue = pair.value;
			calculatedSelector = pair.name;
		}
	}
}