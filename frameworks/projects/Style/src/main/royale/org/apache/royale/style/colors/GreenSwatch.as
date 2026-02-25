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
	public class GreenSwatch
	{
		private function GreenSwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "green-50";
			CSSLookup.register(name, "oklch(98.2% 0.018 155.826)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "green-100";
			CSSLookup.register(name, "oklch(96.2% 0.044 156.743)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "green-200";
			CSSLookup.register(name, "oklch(92.5% 0.084 155.995)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "green-300";
			CSSLookup.register(name, "oklch(87.1% 0.15 154.449)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "green-400";
			CSSLookup.register(name, "oklch(79.2% 0.209 151.711)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "green-500";
			CSSLookup.register(name, "oklch(72.3% 0.219 149.579)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "green-600";
			CSSLookup.register(name, "oklch(62.7% 0.194 149.214)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "green-700";
			CSSLookup.register(name, "oklch(52.7% 0.154 150.069)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "green-800";
			CSSLookup.register(name, "oklch(44.8% 0.119 151.328)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "green-900";
			CSSLookup.register(name, "oklch(39.3% 0.095 152.535)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "green-950";
			CSSLookup.register(name, "oklch(26.6% 0.065 152.934)");
			return name;
		}

	}
}