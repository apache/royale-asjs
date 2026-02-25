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
	public class PurpleSwatch
	{
		private function PurpleSwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "purple-50";
			CSSLookup.register(name, "oklch(97.7% 0.014 308.299)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "purple-100";
			CSSLookup.register(name, "oklch(94.6% 0.033 307.174)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "purple-200";
			CSSLookup.register(name, "oklch(90.2% 0.063 306.703)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "purple-300";
			CSSLookup.register(name, "oklch(82.7% 0.119 306.383)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "purple-400";
			CSSLookup.register(name, "oklch(71.4% 0.203 305.504)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "purple-500";
			CSSLookup.register(name, "oklch(62.7% 0.265 303.9)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "purple-600";
			CSSLookup.register(name, "oklch(55.8% 0.288 302.321)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "purple-700";
			CSSLookup.register(name, "oklch(49.6% 0.265 301.924)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "purple-800";
			CSSLookup.register(name, "oklch(43.8% 0.218 303.724)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "purple-900";
			CSSLookup.register(name, "oklch(38.1% 0.176 304.987)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "purple-950";
			CSSLookup.register(name, "oklch(29.1% 0.149 302.717)");
			return name;
		}

	}
}