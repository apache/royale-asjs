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
	import org.apache.royale.style.stylebeads.ILeafStyleBead;
	import org.apache.royale.style.util.StyleDecoration;

	public class PeerPseudo extends LeafDecorator
	{
		public function PeerPseudo(styles:Array = null)
		{
			super();
			this.styles = styles;
			selectorDecorator = "peer-";
			ruleDecorator = "peer";

			decoratorType = COMBINER;
		}
		override public function decorateChildStyle(style:ILeafStyleBead, decorations:Array):void
		{
			style.selectorPrefix = selectorDecorator + style.selectorPrefix;

			//TODO figure out more complex combinations. For now, just handle limited nesting.
			var decorationStr:String = decorations.map(function(decoration:StyleDecoration, index:int, arr:Array):String{
				return decoration.decoration;
			}).join("");
			
			decorations.push(new StyleDecoration(decoratorType, ruleDecorator));
			style.rulePrefix = "." + ruleDecorator + decorationStr + " ~ " + style.rulePrefix;
			if(parentStyle)
				parentStyle.decorateChildStyle(style, decorations);
		}
	}
}
/**
 .peer-checked\:border-blue-700 {
  &:is(:where(.peer):checked ~ *) {
    border-color: var(--color-blue-700);
  }
}
 */