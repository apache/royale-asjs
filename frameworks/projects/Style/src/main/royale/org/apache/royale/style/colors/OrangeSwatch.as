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
	public class OrangeSwatch
	{
		private function OrangeSwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "orange-50";
			CSSLookup.register(name, "oklch(98% 0.016 73.684)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "orange-100";
			CSSLookup.register(name, "oklch(95.4% 0.038 75.164)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "orange-200";
			CSSLookup.register(name, "oklch(90.1% 0.076 70.697)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "orange-300";
			CSSLookup.register(name, "oklch(83.7% 0.128 66.29)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "orange-400";
			CSSLookup.register(name, "oklch(75% 0.183 55.934)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "orange-500";
			CSSLookup.register(name, "oklch(70.5% 0.213 47.604)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "orange-600";
			CSSLookup.register(name, "oklch(64.6% 0.222 41.116)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "orange-700";
			CSSLookup.register(name, "oklch(55.3% 0.195 38.402)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "orange-800";
			CSSLookup.register(name, "oklch(47% 0.157 37.304)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "orange-900";
			CSSLookup.register(name, "oklch(40.8% 0.123 38.172)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "orange-950";
			CSSLookup.register(name, "oklch(26.6% 0.079 36.259)");
			return name;
		}

	}
}