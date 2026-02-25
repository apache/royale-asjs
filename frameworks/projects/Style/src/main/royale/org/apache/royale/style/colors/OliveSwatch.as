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
	public class OliveSwatch
	{
		private function OliveSwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "olive-50";
			CSSLookup.register(name, "oklch(98.8% 0.003 106.5)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "olive-100";
			CSSLookup.register(name, "oklch(96.6% 0.005 106.5)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "olive-200";
			CSSLookup.register(name, "oklch(93% 0.007 106.5)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "olive-300";
			CSSLookup.register(name, "oklch(88% 0.011 106.6)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "olive-400";
			CSSLookup.register(name, "oklch(73.7% 0.021 106.9)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "olive-500";
			CSSLookup.register(name, "oklch(58% 0.031 107.3)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "olive-600";
			CSSLookup.register(name, "oklch(46.6% 0.025 107.3)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "olive-700";
			CSSLookup.register(name, "oklch(39.4% 0.023 107.4)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "olive-800";
			CSSLookup.register(name, "oklch(28.6% 0.016 107.4)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "olive-900";
			CSSLookup.register(name, "oklch(22.8% 0.013 107.4)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "olive-950";
			CSSLookup.register(name, "oklch(15.3% 0.006 107.1)");
			return name;
		}

	}
}