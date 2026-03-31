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
	/**
	 *  The FocusVisibleState class is a style decorator that applies styles when
	 *  an element is in the :focus-visible state. 
	 */
	public class FocusVisibleState extends LeafDecorator
	{
		/**
		 *  Constructor.
		 *  
		 *  @param styles An array of style beads to apply when the element is focus-visible.
		 */
		public function FocusVisibleState(styles:Array = null)
		{
			super(styles);
			selectorDecorator = "focus-visible:";
			ruleDecorator = ":focus-visible";
		}
	}
}