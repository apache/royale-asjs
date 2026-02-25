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
	public class BlueSwatch
	{
		private function BlueSwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "blue-50";
			CSSLookup.register(name, "oklch(97% 0.014 254.604)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "blue-100";
			CSSLookup.register(name, "oklch(93.2% 0.032 255.585)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "blue-200";
			CSSLookup.register(name, "oklch(88.2% 0.059 254.128)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "blue-300";
			CSSLookup.register(name, "oklch(80.9% 0.105 251.813)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "blue-400";
			CSSLookup.register(name, "oklch(70.7% 0.165 254.624)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "blue-500";
			CSSLookup.register(name, "oklch(62.3% 0.214 259.815)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "blue-600";
			CSSLookup.register(name, "oklch(54.6% 0.245 262.881)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "blue-700";
			CSSLookup.register(name, "oklch(48.8% 0.243 264.376)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "blue-800";
			CSSLookup.register(name, "oklch(42.4% 0.199 265.638)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "blue-900";
			CSSLookup.register(name, "oklch(37.9% 0.146 265.522)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "blue-950";
			CSSLookup.register(name, "oklch(28.2% 0.091 267.935)");
			return name;
		}

	}
}