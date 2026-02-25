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
	public class PinkSwatch
	{
		private function PinkSwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "pink-50";
			CSSLookup.register(name, "oklch(97.1% 0.014 343.198)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "pink-100";
			CSSLookup.register(name, "oklch(94.8% 0.028 342.258)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "pink-200";
			CSSLookup.register(name, "oklch(89.9% 0.061 343.231)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "pink-300";
			CSSLookup.register(name, "oklch(82.3% 0.12 346.018)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "pink-400";
			CSSLookup.register(name, "oklch(71.8% 0.202 349.761)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "pink-500";
			CSSLookup.register(name, "oklch(65.6% 0.241 354.308)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "pink-600";
			CSSLookup.register(name, "oklch(59.2% 0.249 0.584)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "pink-700";
			CSSLookup.register(name, "oklch(52.5% 0.223 3.958)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "pink-800";
			CSSLookup.register(name, "oklch(45.9% 0.187 3.815)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "pink-900";
			CSSLookup.register(name, "oklch(40.8% 0.153 2.432)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "pink-950";
			CSSLookup.register(name, "oklch(28.4% 0.109 3.907)");
			return name;
		}

	}
}