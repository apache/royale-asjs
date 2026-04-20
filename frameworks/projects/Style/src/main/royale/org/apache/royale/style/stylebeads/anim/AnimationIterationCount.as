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
package org.apache.royale.style.stylebeads.anim
{
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;

	public class AnimationIterationCount extends LeafStyleBase
	{
		public function AnimationIterationCount(value:* = null)
		{
			super("iteration", "animation-iteration-count", value);
		}

		override public function get value():*
		{
			return _value;
		}

		override public function set value(value:*):void
		{
			assert(isVar(value) || value == "infinite" || (isInt(value) && value >= 0), "animation-iteration-count only accepts 'infinite', a non-negative integer, or a CSS variable");
			calculatedRuleValue = calculatedSelector = _value = value;
			if(isVar(value))
			{
				calculatedRuleValue = fromVar(value);
			}
		}
	}
}
