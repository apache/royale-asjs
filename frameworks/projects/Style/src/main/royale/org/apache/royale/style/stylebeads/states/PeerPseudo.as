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

	public class PeerPseudo extends StyleStateBase
	{
		public function PeerPseudo(styles:Array = null)
		{
			super();
			this.styles = styles;
		}
		override public function decorateChildStyle(style:ILeafStyleBead):void
		{
			var selector:String = "peer";
			style.selectorPrefix = selector + ":" + style.selectorPrefix;
			// style.rulePrefix = "." + selector + "\\:" +  style.rulePrefix + "~";
			style.ruleSuffix = selector + ":" + style.ruleSuffix;
			
			if(parentStyle)
				parentStyle.decorateChildStyle(style);
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