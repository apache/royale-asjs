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
	import org.apache.royale.style.stylebeads.SingleStyleBase;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.CSSLookup;

	public class TransitionDuration extends SingleStyleBase
	{
		public function TransitionDuration()
		{
			super("duration", "transition-duration");
		}

		override public function set value(value:*):void
		{
			var isInt:Boolean = int(value) == value;
			var isVar:Boolean = CSSLookup.has(value);
			assert(isVar || (isInt && value >= 0), "transition-duration only accepts valid CSS variables or non-negative integers representing milliseconds");
			calculatedSelector = _value = value;
			calculatedRuleValue = isInt ? value + "ms" : CSSLookup.getProperty(value);
		}		
	}
}