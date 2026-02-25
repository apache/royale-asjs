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
package org.apache.royale.style.colors
{
	import org.apache.royale.style.util.CSSLookup;

	/**
	 * @royalesuppressexport
	 */
	public class MauveSwatch
	{
		private function MauveSwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "mauve-50";
			CSSLookup.register(name, "oklch(98.5% 0 0)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "mauve-100";
			CSSLookup.register(name, "oklch(96% 0.003 325.6)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "mauve-200";
			CSSLookup.register(name, "oklch(92.2% 0.005 325.62)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "mauve-300";
			CSSLookup.register(name, "oklch(86.5% 0.012 325.68)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "mauve-400";
			CSSLookup.register(name, "oklch(71.1% 0.019 323.02)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "mauve-500";
			CSSLookup.register(name, "oklch(54.2% 0.034 322.5)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "mauve-600";
			CSSLookup.register(name, "oklch(43.5% 0.029 321.78)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "mauve-700";
			CSSLookup.register(name, "oklch(36.4% 0.029 323.89)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "mauve-800";
			CSSLookup.register(name, "oklch(26.3% 0.024 320.12)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "mauve-900";
			CSSLookup.register(name, "oklch(21.2% 0.019 322.12)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "mauve-950";
			CSSLookup.register(name, "oklch(14.5% 0.008 326)");
			return name;
		}

	}
}