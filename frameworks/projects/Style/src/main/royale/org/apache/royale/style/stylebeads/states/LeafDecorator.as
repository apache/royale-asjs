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
	import org.apache.royale.style.util.StyleDecoration;

	public class LeafDecorator extends StyleBeadBase
	{
		protected static const STATE:String = "state";
		protected static const COMBINER:String = "combiner";
		protected static const QUERY:String = "query";

		public function LeafDecorator()
		{
			super();
		}
		protected var decoratorType:String = STATE;
		protected var selectorDecorator:String;
		protected var ruleDecorator:String;
		protected var leafStyle:LeafStyleBase;
		/**
		 * @royaleignorecoercion org.apache.royale.style.stylebeads.LeafStyleBase
		 */
		override public function decorateChildStyle(style:ILeafStyleBead, decorations:Array):void
		{
			assert(style.isLeaf, "LeafDecorator can only decorate leaf styles");
			var leafStyle:LeafStyleBase = style as LeafStyleBase;
			leafStyle.selectorPrefix = selectorDecorator + leafStyle.selectorPrefix;

			decorations.push(new StyleDecoration(decoratorType, ruleDecorator));
			/**
			 * Default behavior is for state decorators. In that case, the decoration is added as a suffix.
			 * Otherwise, the decoration is passed to the parent which handles the decoration based on the type.
			 */
			if(!parentStyle || parentStyle.isGroup)
			{
				leafStyle.ruleSuffix = leafStyle.ruleSuffix + ruleDecorator;
			}
			if(parentStyle)
				parentStyle.decorateChildStyle(style, decorations);

		}
	}
}