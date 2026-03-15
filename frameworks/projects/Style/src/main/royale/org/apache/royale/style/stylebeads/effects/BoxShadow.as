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
	public class BoxShadow extends LeafStyleBase
	{
		public function BoxShadow(value:* = null)
		{
			super("shadow", "box-shadow", value);
		}
		/**
		 * TODO: Figure this out
		 * box-shadow: var(--tw-inset-shadow),var(--tw-inset-ring-shadow),var(--tw-ring-offset-shadow),var(--tw-ring-shadow),var(--tw-shadow);
		 */
		public var size:String;
		
		// none is special
		public var color:String;
		public var inset:Boolean;
	}
}