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
package org.apache.royale.style.stylebeads.layout
{
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;

	public class BoxSizing extends LeafStyleBase
	{
		public function BoxSizing()
		{
			super("box", "box-sizing");
		}

		override public function set value(value:*):void
		{
			_value = value;
			assert(value == "border-box" || value == "content-box", "box-sizing must be 'border-box' or 'content-box'");
			calculatedSelector = value;
			calculatedRuleValue = value.slice(0, -4); // remove "-box" from the end of the value for the rule
		}
	}
}