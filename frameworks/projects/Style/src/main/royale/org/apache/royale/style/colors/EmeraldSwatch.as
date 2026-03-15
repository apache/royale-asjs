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
	public class EmeraldSwatch
	{
		private function EmeraldSwatch()
		{
			
		}
		public static function get _50():String
		{
			var name:String = "emerald-50";
			CSSLookup.register(name, "oklch(97.9% 0.021 166.113)");
			return name;
		}
		public static function get _100():String
		{
			var name:String = "emerald-100";
			CSSLookup.register(name, "oklch(95% 0.052 163.051)");
			return name;
		}
		public static function get _200():String
		{
			var name:String = "emerald-200";
			CSSLookup.register(name, "oklch(90.5% 0.093 164.15)");
			return name;
		}
		public static function get _300():String
		{
			var name:String = "emerald-300";
			CSSLookup.register(name, "oklch(84.5% 0.143 164.978)");
			return name;
		}
		public static function get _400():String
		{
			var name:String = "emerald-400";
			CSSLookup.register(name, "oklch(76.5% 0.177 163.223)");
			return name;
		}
		public static function get _500():String
		{
			var name:String = "emerald-500";
			CSSLookup.register(name, "oklch(69.6% 0.17 162.48)");
			return name;
		}
		public static function get _600():String
		{
			var name:String = "emerald-600";
			CSSLookup.register(name, "oklch(59.6% 0.145 163.225)");
			return name;
		}
		public static function get _700():String
		{
			var name:String = "emerald-700";
			CSSLookup.register(name, "oklch(50.8% 0.118 165.612)");
			return name;
		}
		public static function get _800():String
		{
			var name:String = "emerald-800";
			CSSLookup.register(name, "oklch(43.2% 0.095 166.913)");
			return name;
		}
		public static function get _900():String
		{
			var name:String = "emerald-900";
			CSSLookup.register(name, "oklch(37.8% 0.077 168.94)");
			return name;
		}
		public static function get _950():String
		{
			var name:String = "emerald-950";
			CSSLookup.register(name, "oklch(26.2% 0.051 172.552)");
			return name;
		}

	}
}