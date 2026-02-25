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
	public class SkySwatch
	{
		private function SkySwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "sky-50";
			CSSLookup.register(name, "oklch(97.7% 0.013 236.62)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "sky-100";
			CSSLookup.register(name, "oklch(95.1% 0.026 236.824)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "sky-200";
			CSSLookup.register(name, "oklch(90.1% 0.058 230.902)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "sky-300";
			CSSLookup.register(name, "oklch(82.8% 0.111 230.318)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "sky-400";
			CSSLookup.register(name, "oklch(74.6% 0.16 232.661)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "sky-500";
			CSSLookup.register(name, "oklch(68.5% 0.169 237.323)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "sky-600";
			CSSLookup.register(name, "oklch(58.8% 0.158 241.966)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "sky-700";
			CSSLookup.register(name, "oklch(50% 0.134 242.749)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "sky-800";
			CSSLookup.register(name, "oklch(44.3% 0.11 240.79)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "sky-900";
			CSSLookup.register(name, "oklch(39.1% 0.09 240.876)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "sky-950";
			CSSLookup.register(name, "oklch(29.3% 0.066 243.157)");
			return name;
		}

	}
}