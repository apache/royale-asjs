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
		/**
		 * TODO: Figure this out. ring effects cannot be stacked in CSS.
		 * Tailwind uses @properties to create a single box-shadow property that combines all the properties.
		 * We avoided using @properties elsewhere.
		 * It might be simpler to just use `Outline` instead.
		 * https://tailwindcss.com/docs/box-shadow
		 */

	public class RingEffect extends LeafStyleBase
	{
		public function RingEffect()
		{
			super("ring","box-shadow");
		}
		
		public var color:String;
		public var inset:Boolean;
		public var weight:Number;
      // --tw-ring-color:initial;
      // --tw-ring-shadow:0 0 #0000;
      // --tw-inset-ring-color:initial;
      // --tw-inset-ring-shadow:0 0 #0000;
      // --tw-ring-inset:initial;
      // --tw-ring-offset-width:0px;
      // --tw-ring-offset-color:#fff;
      // --tw-ring-offset-shadow:0 0 #0000;

/**
 * Should be something like this:
 * box-shadow: inset 0 0 0 calc(2px + var(--tw-ring-offset-width)) var(--tw-inset-ring-color, currentcolor),
--tw-ring-shadow: var(--tw-ring-inset, ) 0 0 0 calc(2px + var(--tw-ring-offset-width)) var(--tw-ring-color, currentcolor);
    box-shadow: 
		var(--tw-inset-shadow),
		var(--tw-inset-ring-shadow),
		var(--tw-ring-offset-shadow),
		var(--tw-ring-shadow),
		var(--tw-shadow);
 */
	}
}