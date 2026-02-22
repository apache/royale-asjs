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
package org.apache.royale.style.util
{
	import org.apache.royale.debugging.assert;

	public class StyleManager
	{
		private function StyleManager()
		{
			// Static only class.
		}
		COMPILE::JS
		private static const styleList:Set = new Set();

		public static function hasStyle(selector:String):Boolean
		{
			COMPILE::JS
			{
				return styleList.has(selector);
			}
			return false;
		}
		public static function addStyle(selector:String, rule:String):void
		{
			COMPILE::JS
			{
				assert(!styleList.has(selector), "Style " + selector + " already exists");
				styleList.add(selector);
				addRule(selector, rule);
			}
		}

		COMPILE::JS
		private static var ss:CSSStyleSheet;

		private static var ruleIdx:int = 0;

		private static function addRule(selector:String, rule:String):void
		{
			COMPILE::JS
			{
				if (!ss)
				{
					var styleElement:HTMLStyleElement = document.createElement('style') as HTMLStyleElement;
					document.head.appendChild(styleElement);
					ss = styleElement.sheet as CSSStyleSheet;
				}
				ss.insertRule(selector + "{" + rule + "}", ruleIdx++);
			}
		}
	}
}