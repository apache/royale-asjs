
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
package org.apache.royale.style.stylebeads.states.attribute
{

	import org.apache.royale.style.stylebeads.states.StyleStateBase;
	import org.apache.royale.style.stylebeads.states.LeafDecorator;

	public class AriaState extends LeafDecorator
	{
		public function AriaState(styles:Array = null)
		{
			super(styles);
		}

		private var _aria:String;
		/**
		 * The aria attribute to use for this state. For example, "aria-hidden".
		 */
		public function get aria():String
		{
			return _aria;
		}

		public function set aria(value:String):void
		{
			_aria = value;
			selectorDecorator = value + ":";
			ruleDecorator = "[" + value + "=true]";
		}
		/**
		 * The aria attribute without the aria- prefix.
		 * For example, if aria is "aria-hidden", type would be "hidden".
		 */
		public function get type():String
		{
			return _aria ? _aria.replace("aria-", "") : "";
		}

		public function set type(value:String):void
		{
			aria = "aria-" + value;
		}
	}
}