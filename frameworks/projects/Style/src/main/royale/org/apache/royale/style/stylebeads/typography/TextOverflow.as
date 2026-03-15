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
	import org.apache.royale.debugging.assert;

	public class TextOverflow extends LeafStyleBase
	{
		/**
		 * To set text to truncate and show an ellipsis ("..."), use the `Truncate` bead instead.
		 */
		public function TextOverflow(value:* = null)
		{
			super("text", "text-overflow", value);
		}
		[Inspectable(category="General", enumeration="clip,ellipsis", defaultValue="clip")]
		override public function set value(value:*):void
		{
			assert(["clip", "ellipsis"].indexOf(value) >= 0, "Invalid value for TextOverflow: " + value);
			calculatedSelector = calculatedRuleValue = _value = value;
		}

	}
}