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
	public class LimeSwatch
	{
		private function LimeSwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "lime-50";
			CSSLookup.register(name, "oklch(98.6% 0.031 120.757)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "lime-100";
			CSSLookup.register(name, "oklch(96.7% 0.067 122.328)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "lime-200";
			CSSLookup.register(name, "oklch(93.8% 0.127 124.321)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "lime-300";
			CSSLookup.register(name, "oklch(89.7% 0.196 126.665)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "lime-400";
			CSSLookup.register(name, "oklch(84.1% 0.238 128.85)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "lime-500";
			CSSLookup.register(name, "oklch(76.8% 0.233 130.85)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "lime-600";
			CSSLookup.register(name, "oklch(64.8% 0.2 131.684)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "lime-700";
			CSSLookup.register(name, "oklch(53.2% 0.157 131.589)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "lime-800";
			CSSLookup.register(name, "oklch(45.3% 0.124 130.933)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "lime-900";
			CSSLookup.register(name, "oklch(40.5% 0.101 131.063)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "lime-950";
			CSSLookup.register(name, "oklch(27.4% 0.072 132.109)");
			return name;
		}

	}
}