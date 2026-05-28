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
	import org.apache.royale.style.stylebeads.ILeafStyleBead;
	import org.apache.royale.style.util.StyleDecoration;

	/**
	 *  The SiblingPseudo class is a style decorator that allows elements to be styled
	 *  based on the state of a preceding sibling element. 
	 *  It corresponds to the "peer-*" utility pattern in CSS frameworks like Tailwind CSS,
	 *  but allows specifying the sibling's class/selector explicitly.
	 */
	public class SiblingPseudo extends LeafDecorator
	{
		/**
		 *  Constructor.
		 *  
		 *  @param styles An array of style beads to apply when the sibling condition is met.
		 *  @param siblingSelector The CSS selector of the preceding sibling element.
		 *  @param general If true, uses the general sibling combiner (~), 
		 *  otherwise uses the adjacent sibling combiner (+).
		 */
		public function SiblingPseudo(styles:Array = null, siblingSelector:String = null, general:Boolean = true)
		{
			super(styles);
			if (siblingSelector)
				this.siblingSelector = siblingSelector;
			_combiner = general ? " ~ " : " + ";

			decoratorType = COMBINER;
		}

		private var _siblingSelector:String;
		private var _combiner:String;

		public function get siblingSelector():String
		{
			return _siblingSelector;
		}

		public function set siblingSelector(value:String):void
		{
			_siblingSelector = value;
			selectorDecorator = value + (value.indexOf(":") == value.length - 1 ? "" : "-");
			ruleDecorator = value;
		}

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
