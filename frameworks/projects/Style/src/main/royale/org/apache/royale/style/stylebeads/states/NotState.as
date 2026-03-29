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
	import org.apache.royale.style.stylebeads.LeafStyleBase;

	public class NotState extends LeafDecorator
	{
		/**
		 * NotState is a decorator that adds a :not() pseudo-class to the rule.
		 */
		public function NotState(selector:* = null, styles:Array = null)
		{
			super(styles);
			selectorDecorator = "not-";
			if (selector is LeafDecorator)
			{
				_nestedDecorator = selector as LeafDecorator;
			}
			else
			{
				ruleDecorator = selector as String;
			}

			decoratorType = COMBINER;
		}

		private var _nestedDecorator:LeafDecorator;

		/**
		 * @royaleignorecoercion org.apache.royale.style.stylebeads.LeafStyleBase
		 */
		override public function decorateChildStyle(style:ILeafStyleBead, decorations:Array):void
		{
			style.selectorPrefix = selectorDecorator + style.selectorPrefix;

			var leafStyle:LeafStyleBase = style as LeafStyleBase;

			//TODO figure out more complex combinations. For now, just handle limited nesting.
			var decorationStr:String = ""
			var len:int = decorations.length;
			for(var i:int = 0; i < len; i++)
			{
				decorationStr += decorations[i].decoration;
			}

			var rule:String = ruleDecorator || "";
			if (_nestedDecorator)
			{
				rule = _nestedDecorator.getFullRule();
				if (_nestedDecorator is HasState)
				{
					rule = ":has(" + rule + ")";
				}
				else if (_nestedDecorator is NotState)
				{
					rule = ":not(" + rule + ")";
				}
			}

			decorations.push(new StyleDecoration(decoratorType, rule + decorationStr));

			if(!parentStyle || parentStyle.isGroup)
			{
				leafStyle.ruleSuffix = leafStyle.ruleSuffix + ":not(" + rule + decorationStr + ")";
			}

			if(parentStyle)
				parentStyle.decorateChildStyle(style, decorations);
		}
	}
}