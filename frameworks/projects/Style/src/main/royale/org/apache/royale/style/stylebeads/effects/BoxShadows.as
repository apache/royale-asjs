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
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.debugging.assert;
	/**
	 * Multiple box shadows can be applied to an element, separated by commas.
	 * BoxShadows should contain an array of BoxShadow or RingEffect objects.
	 */
	public class BoxShadows extends LeafStyleBase
	{
		public function BoxShadows(value:* = null)
		{
			super("boxes", "box-shadow", value);
		}
		private var _shadows:Array;

		public function get shadows():Array
		{
			return _shadows;
		}

		public function set shadows(value:Array):void
		{
			_shadows = value;
		}
		override public function getRule():String
		{
			assert(shadows && shadows.length > 0, "BoxShadows style bead requires shadows to be set");
			var rules:Array = [];
			for each(var shadow:LeafStyleBase in shadows)
			{
				assert(shadow is BoxShadow || shadow is RingEffect, "BoxShadows style bead only accepts BoxShadow or RingEffect style beads");
				if(shadow is BoxShadow)
					rules.push((shadow as BoxShadow).getShadowValue());
				else
					rules.push((shadow as RingEffect).getShadowValue());
			}
			calculatedRuleValue = rules.join(", ");
			return super.getRule();
		}
		override public function getSelector():String
		{
			assert(shadows && shadows.length > 0, "BoxShadows style bead requires shadows to be set");
			var selectors:Array = [];
			for each(var shadow:LeafStyleBase in shadows)
			{
				assert(shadow is BoxShadow || shadow is RingEffect, "BoxShadows style bead only accepts BoxShadow or RingEffect style beads");
				if(shadow is BoxShadow)
					selectors.push((shadow as BoxShadow).getShadowSelector());
				else
					selectors.push((shadow as RingEffect).getShadowSelector());
			}
			calculatedSelector = selectors.join("-");
			return super.getSelector();
		}
	}
}