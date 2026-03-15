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
	public class GraySwatch
	{
		private function GraySwatch()
		{
			
		}
		public static function get _50():String
		{
			var name:String = "gray-50";
			CSSLookup.register(name, "oklch(98.5% 0.002 247.839)");
			return name;
		}
		public static function get _100():String
		{
			var name:String = "gray-100";
			CSSLookup.register(name, "oklch(96.7% 0.003 264.542)");
			return name;
		}
		public static function get _200():String
		{
			var name:String = "gray-200";
			CSSLookup.register(name, "oklch(92.8% 0.006 264.531)");
			return name;
		}
		public static function get _300():String
		{
			var name:String = "gray-300";
			CSSLookup.register(name, "oklch(87.2% 0.01 258.338)");
			return name;
		}
		public static function get _400():String
		{
			var name:String = "gray-400";
			CSSLookup.register(name, "oklch(70.7% 0.022 261.325)");
			return name;
		}
		public static function get _500():String
		{
			var name:String = "gray-500";
			CSSLookup.register(name, "oklch(55.1% 0.027 264.364)");
			return name;
		}
		public static function get _600():String
		{
			var name:String = "gray-600";
			CSSLookup.register(name, "oklch(44.6% 0.03 256.802)");
			return name;
		}
		public static function get _700():String
		{
			var name:String = "gray-700";
			CSSLookup.register(name, "oklch(37.3% 0.034 259.733)");
			return name;
		}
		public static function get _800():String
		{
			var name:String = "gray-800";
			CSSLookup.register(name, "oklch(27.8% 0.033 256.848)");
			return name;
		}
		public static function get _900():String
		{
			var name:String = "gray-900";
			CSSLookup.register(name, "oklch(21% 0.034 264.665)");
			return name;
		}
		public static function get _950():String
		{
			var name:String = "gray-950";
			CSSLookup.register(name, "oklch(13% 0.028 261.692)");
			return name;
		}

	}
}