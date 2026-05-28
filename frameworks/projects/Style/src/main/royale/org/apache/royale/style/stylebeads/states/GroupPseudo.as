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
	import org.apache.royale.style.StyleUIBase;
	import org.apache.royale.style.stylebeads.ILeafStyleBead;
	import org.apache.royale.style.util.StyleDecoration;

	/**
	 *  The GroupPseudo class is a style decorator that allows child elements to be styled
	 *  based on the state of a parent element. It corresponds to the "group-*" utility
	 *  pattern in CSS frameworks like Tailwind CSS.
	 *  
	 *  The parent element must have a "group" class (defaults to 'style-group').
	 *  When this decorator is used, it generates CSS rules like:
	 *  .style-group[data-disabled] .child-element { ... }
	 */
	public class GroupPseudo extends LeafDecorator
	{
		/**
		 *  Constructor.
		 *  
		 *  @param styles An array of style beads to apply when the group condition is met.
		 *  @param groupClass The CSS class name of the parent element to target. 
		 *  If null, it defaults to StyleUIBase.GROUP_WRAPPER_STYLE ('style-group').
		 *  @param combiner The combiner to use between the group element and the child element.
		 *  Defaults to a space (descendant combiner). Can be '>', '+', or '~'.
		 */
		public function GroupPseudo(styles:Array = null, groupClass:String = null, combiner:String = " ")
		{
			super(styles);
			var base:String = groupClass || StyleUIBase.GROUP_WRAPPER_STYLE;
			selectorDecorator = base + '-';
			ruleDecorator = base;
			_combiner = combiner;

			decoratorType = COMBINER;
		}

		private var _combiner:String;

		override public function decorateChildStyle(style:ILeafStyleBead, decorations:Array):void
		{
			style.selectorPrefix = selectorDecorator + style.selectorPrefix;

			var decorationStr:String = ""
			var len:int = decorations.length;
			for(var i:int = len - 1; i >= 0; i--)
			{
				if(decorations[i].type == COMBINER)
					break;
				decorationStr = decorations[i].decoration + decorationStr;
			}
			
			decorations.push(new StyleDecoration(decoratorType, ruleDecorator));
			var escapedRuleDecorator:String = ruleDecorator.indexOf(".") == 0 ? ruleDecorator : "." + ruleDecorator.replace(/:/g, "\\:");
			style.rulePrefix = escapedRuleDecorator + decorationStr + _combiner + style.rulePrefix;
			if(parentStyle)
				parentStyle.decorateChildStyle(style, decorations);
		}
	}
}
