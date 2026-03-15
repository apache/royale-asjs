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
	public class IndigoSwatch
	{
		private function IndigoSwatch()
		{
			
		}
		public static function get _50():String
		{
			var name:String = "indigo-50";
			CSSLookup.register(name, "oklch(96.2% 0.018 272.314)");
			return name;
		}
		public static function get _100():String
		{
			var name:String = "indigo-100";
			CSSLookup.register(name, "oklch(93% 0.034 272.788)");
			return name;
		}
		public static function get _200():String
		{
			var name:String = "indigo-200";
			CSSLookup.register(name, "oklch(87% 0.065 274.039)");
			return name;
		}
		public static function get _300():String
		{
			var name:String = "indigo-300";
			CSSLookup.register(name, "oklch(78.5% 0.115 274.713)");
			return name;
		}
		public static function get _400():String
		{
			var name:String = "indigo-400";
			CSSLookup.register(name, "oklch(67.3% 0.182 276.935)");
			return name;
		}
		public static function get _500():String
		{
			var name:String = "indigo-500";
			CSSLookup.register(name, "oklch(58.5% 0.233 277.117)");
			return name;
		}
		public static function get _600():String
		{
			var name:String = "indigo-600";
			CSSLookup.register(name, "oklch(51.1% 0.262 276.966)");
			return name;
		}
		public static function get _700():String
		{
			var name:String = "indigo-700";
			CSSLookup.register(name, "oklch(45.7% 0.24 277.023)");
			return name;
		}
		public static function get _800():String
		{
			var name:String = "indigo-800";
			CSSLookup.register(name, "oklch(39.8% 0.195 277.366)");
			return name;
		}
		public static function get _900():String
		{
			var name:String = "indigo-900";
			CSSLookup.register(name, "oklch(35.9% 0.144 278.697)");
			return name;
		}
		public static function get _950():String
		{
			var name:String = "indigo-950";
			CSSLookup.register(name, "oklch(25.7% 0.09 281.288)");
			return name;
		}

	}
}