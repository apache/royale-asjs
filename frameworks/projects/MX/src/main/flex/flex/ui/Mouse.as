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

package flex.ui
{
	public class Mouse
	{
		public function Mouse()
		{
		}
		
		COMPILE::JS
		private static var styleElement:HTMLStyleElement;
		
		/**
		 * @flexjsignorecoercion HTMLStyleElement
		 */
		COMPILE::JS
		public static function hide():void
		{
			if (!styleElement)
				styleElement = document.createElement("STYLE") as HTMLStyleElement;
			var css:CSSStyleSheet = styleElement.sheet as CSSStyleSheet;
			css.insertRule("* { cursor: none; }", 0);
		}
		
		COMPILE::JS
		public static function show():void
		{
			if (!styleElement)
				return;
			var css:CSSStyleSheet = styleElement.sheet as CSSStyleSheet;
			css.deleteRule(0);
		}
		
	}
}
