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
	public class TealSwatch
	{
		private function TealSwatch()
		{
			
		}
		public static function get _50():String
		{
			var name:String = "teal-50";
			CSSLookup.register(name, "oklch(98.4% 0.014 180.72)");
			return name;
		}
		public static function get _100():String
		{
			var name:String = "teal-100";
			CSSLookup.register(name, "oklch(95.3% 0.051 180.801)");
			return name;
		}
		public static function get _200():String
		{
			var name:String = "teal-200";
			CSSLookup.register(name, "oklch(91% 0.096 180.426)");
			return name;
		}
		public static function get _300():String
		{
			var name:String = "teal-300";
			CSSLookup.register(name, "oklch(85.5% 0.138 181.071)");
			return name;
		}
		public static function get _400():String
		{
			var name:String = "teal-400";
			CSSLookup.register(name, "oklch(77.7% 0.152 181.912)");
			return name;
		}
		public static function get _500():String
		{
			var name:String = "teal-500";
			CSSLookup.register(name, "oklch(70.4% 0.14 182.503)");
			return name;
		}
		public static function get _600():String
		{
			var name:String = "teal-600";
			CSSLookup.register(name, "oklch(60% 0.118 184.704)");
			return name;
		}
		public static function get _700():String
		{
			var name:String = "teal-700";
			CSSLookup.register(name, "oklch(51.1% 0.096 186.391)");
			return name;
		}
		public static function get _800():String
		{
			var name:String = "teal-800";
			CSSLookup.register(name, "oklch(43.7% 0.078 188.216)");
			return name;
		}
		public static function get _900():String
		{
			var name:String = "teal-900";
			CSSLookup.register(name, "oklch(38.6% 0.063 188.416)");
			return name;
		}
		public static function get _950():String
		{
			var name:String = "teal-950";
			CSSLookup.register(name, "oklch(27.7% 0.046 192.524)");
			return name;
		}

	}
}