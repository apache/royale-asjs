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
package org.apache.royale.style.stylebeads.utils
{
	import org.apache.royale.style.stylebeads.LeafStyleBase;
	/**
	 * Use this to hide an element visually without hiding it from screen readers.
	 */
	public class ScreenReader extends LeafStyleBase
	{
		public function ScreenReader(value:* = null)
		{
			super("", "", value);
			exclude = false;
		}

		private function getSrOnly():String
		{
			return "position:absolute; width:1px; height:1px; padding:0; margin:-1px; overflow:hidden; clip-path: inset(50%); white-space:nowrap; border-width:0;";
		}

		private function getNotSrOnly():String
		{
			return "position:static; width:auto; height:auto; padding:0; margin:0; overflow:visible; clip:none; white-space:normal;";
		}

		private var _exclude:Boolean = false;
		/**
		 * If true, this will "undo" an existing sr-only.
		 */
		public function get exclude():Boolean
		{
			return _exclude;
		}

		public function set exclude(value:Boolean):void
		{
			_exclude = value;
			calculatedSelector = _exclude ? "not-sr-only" : "sr-only";
			calculatedRuleValue = _exclude ? getNotSrOnly() : getSrOnly();
		}

	}
}