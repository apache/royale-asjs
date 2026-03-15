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

	public class FontStretch extends LeafStyleBase
	{
		public function FontStretch(value:* = null)
		{
			super("font-stretch", "font-stretch", value);
		}
		/**
		 * Accept keywords or values for font-stretch.
		 * See https://developer.mozilla.org/en-US/docs/Web/CSS/font-stretch for more information.
		 */
		[Inspectable(category="General", enumeration="ultra-condensed,extra-condensed,condensed,semi-condensed,normal,semi-expanded,expanded,extra-expanded,ultra-expanded", defaultValue="")]
		override public function set value(value:*):void
		{
			calculatedSelector = _value = value;
			calculatedRuleValue = acceptVar(value);
		}
	}
}