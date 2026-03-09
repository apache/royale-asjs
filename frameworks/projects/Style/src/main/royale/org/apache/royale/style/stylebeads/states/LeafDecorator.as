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
package org.apache.royale.style.stylebeads.states
{
	import org.apache.royale.style.stylebeads.IStyleBead;
	import org.apache.royale.style.stylebeads.StyleBeadBase;
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	import org.apache.royale.style.stylebeads.ILeafStyleBead;

	public class LeafDecorator extends StyleBeadBase
	{
		public function LeafDecorator()
		{
			super();
		}

		protected var preDecorator:String;
		protected var postDecorator:String;
		protected var leafStyle:LeafStyleBase;
		/**
		 * @royaleignorecoercion org.apache.royale.style.stylebeads.LeafStyleBase
		 */
		override public function decorateChildStyle(style:ILeafStyleBead):void
		{
			assert(style.isLeaf, "LeafDecorator can only decorate leaf styles");
			var leafStyle:LeafStyleBase = style as LeafStyleBase;
			leafStyle.rulePrefix = preDecorator + leafStyle.rulePrefix;
			leafStyle.ruleSuffix = leafStyle.ruleSuffix + postDecorator;
			leafStyle.selectorPrefix = preDecorator + leafStyle.selectorPrefix;
			if(parentStyle)
				parentStyle.decorateChildStyle(style);

		}
	}
}