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
	public class AmberSwatch
	{
		private function AmberSwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "amber-50";
			CSSLookup.register(name, "oklch(98.7% 0.022 95.277)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "amber-100";
			CSSLookup.register(name, "oklch(96.2% 0.059 95.617)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "amber-200";
			CSSLookup.register(name, "oklch(92.4% 0.12 95.746)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "amber-300";
			CSSLookup.register(name, "oklch(87.9% 0.169 91.605)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "amber-400";
			CSSLookup.register(name, "oklch(82.8% 0.189 84.429)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "amber-500";
			CSSLookup.register(name, "oklch(76.9% 0.188 70.08)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "amber-600";
			CSSLookup.register(name, "oklch(66.6% 0.179 58.318)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "amber-700";
			CSSLookup.register(name, "oklch(55.5% 0.163 48.998)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "amber-800";
			CSSLookup.register(name, "oklch(47.3% 0.137 46.201)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "amber-900";
			CSSLookup.register(name, "oklch(41.4% 0.112 45.904)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "amber-950";
			CSSLookup.register(name, "oklch(27.9% 0.077 45.635)");
			return name;
		}

	}
}