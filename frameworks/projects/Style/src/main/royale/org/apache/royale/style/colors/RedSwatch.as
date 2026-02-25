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
	public class RedSwatch
	{
		private function RedSwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "red-50";
			CSSLookup.register(name, "oklch(97.1% 0.013 17.38)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "red-100";
			CSSLookup.register(name, "oklch(93.6% 0.032 17.717)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "red-200";
			CSSLookup.register(name, "oklch(88.5% 0.062 18.334)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "red-300";
			CSSLookup.register(name, "oklch(80.8% 0.114 19.571)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "red-400";
			CSSLookup.register(name, "oklch(70.4% 0.191 22.216)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "red-500";
			CSSLookup.register(name, "oklch(63.7% 0.237 25.331)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "red-600";
			CSSLookup.register(name, "oklch(57.7% 0.245 27.325)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "red-700";
			CSSLookup.register(name, "oklch(50.5% 0.213 27.518)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "red-800";
			CSSLookup.register(name, "oklch(44.4% 0.177 26.899)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "red-900";
			CSSLookup.register(name, "oklch(39.6% 0.141 25.723)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "red-950";
			CSSLookup.register(name, "oklch(25.8% 0.092 26.042)");
			return name;
		}

	}
}