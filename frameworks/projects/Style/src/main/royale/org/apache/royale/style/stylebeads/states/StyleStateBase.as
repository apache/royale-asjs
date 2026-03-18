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
	import org.apache.royale.style.stylebeads.StyleBeadBase;
	import org.apache.royale.style.stylebeads.IStyleBead;
	import org.apache.royale.style.stylebeads.ILeafStyleBead;

	abstract public class StyleStateBase extends StyleBeadBase
	{
		public function StyleStateBase()
		{
			super();
		}
/**
 * 
 * .peer:focus-visible ~ .peer-focus-visible\:ring-offset-slate-50 {
    --tw-ring-offset-color: #f8fafc;
}
dark > peer > focus-visible > ring-offest: slate-950

1. selectorPrefix is always added to the beginning.
2. rulePrefix
3. ruleSuffix
selectorPrefix: dark:peer-focus-visible:ring-offset-slate-950
.peer:focus-visible ~ .dark\:peer-focus-visible\:ring-offset-slate-950:is(.dark *) {
    --tw-ring-offset-color: #020617;
}

 */
		override public function decorateChildStyle(style:ILeafStyleBead, decorations:Array):void
		{
			//TODO: Figure out what goes in here.
			if(parentStyle)
				parentStyle.decorateChildStyle(style, decorations);

		}

		/**
		 * TODO: Figure out what goes in here.
		 */

	}
}