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
package org.apache.royale.style.stylebeads.transform
{
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;

	public class TransformOrigin extends LeafStyleBase
	{
		public function TransformOrigin()
		{
			super("origin", "transform-origin");
		}
		override public function set value(value:*):void
		{
			assert(isVar(value) || ["center","top","top right","right","bottom right","bottom","bottom left","left","top left"].indexOf(value) != -1, "Invalid value for transform-origin: " + value);
			calculatedRuleValue = _value = value;
			calculatedSelector = sanitizeSelector(value);
			if(isVar(value))
				calculatedRuleValue = fromVar(value);
		}
	}
}