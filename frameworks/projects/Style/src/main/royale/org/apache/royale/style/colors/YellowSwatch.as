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
	public class YellowSwatch
	{
		private function YellowSwatch()
		{
			
		}
		public static function get _50():String
		{
			var name:String = "yellow-50";
			CSSLookup.register(name, "oklch(98.7% 0.026 102.212)");
			return name;
		}
		public static function get _100():String
		{
			var name:String = "yellow-100";
			CSSLookup.register(name, "oklch(97.3% 0.071 103.193)");
			return name;
		}
		public static function get _200():String
		{
			var name:String = "yellow-200";
			CSSLookup.register(name, "oklch(94.5% 0.129 101.54)");
			return name;
		}
		public static function get _300():String
		{
			var name:String = "yellow-300";
			CSSLookup.register(name, "oklch(90.5% 0.182 98.111)");
			return name;
		}
		public static function get _400():String
		{
			var name:String = "yellow-400";
			CSSLookup.register(name, "oklch(85.2% 0.199 91.936)");
			return name;
		}
		public static function get _500():String
		{
			var name:String = "yellow-500";
			CSSLookup.register(name, "oklch(79.5% 0.184 86.047)");
			return name;
		}
		public static function get _600():String
		{
			var name:String = "yellow-600";
			CSSLookup.register(name, "oklch(68.1% 0.162 75.834)");
			return name;
		}
		public static function get _700():String
		{
			var name:String = "yellow-700";
			CSSLookup.register(name, "oklch(55.4% 0.135 66.442)");
			return name;
		}
		public static function get _800():String
		{
			var name:String = "yellow-800";
			CSSLookup.register(name, "oklch(47.6% 0.114 61.907)");
			return name;
		}
		public static function get _900():String
		{
			var name:String = "yellow-900";
			CSSLookup.register(name, "oklch(42.1% 0.095 57.708)");
			return name;
		}
		public static function get _950():String
		{
			var name:String = "yellow-950";
			CSSLookup.register(name, "oklch(28.6% 0.066 53.813)");
			return name;
		}

	}
}