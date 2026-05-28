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
	 *  The ClassState class is a style decorator that applies styles when
	 *  an element has a specific CSS class.
	 */
	public class ClassState extends LeafDecorator
	{
		/**
		 *  Constructor.
		 *  
		 *  @param className The name of the CSS class (without the dot).
		 *  @param styles An array of style beads to apply when the class is present.
		 */
		public function ClassState(className:String = null, styles:Array = null)
		{
			super(styles);
			if (className)
				this.className = className;
		}

		private var _className:String;

		public function get className():String
		{
			return _className;
		}

		public function set className(value:String):void
		{
			_className = value;
			// Escape colon for things like "lg:drawer-open"
			var escaped:String = value.replace(/:/g, "\\:");
			selectorDecorator = value + ":";
			ruleDecorator = "." + escaped;
		}
	}
}
