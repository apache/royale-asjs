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
	public class VioletSwatch
	{
		private function VioletSwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "violet-50";
			CSSLookup.register(name, "oklch(96.9% 0.016 293.756)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "violet-100";
			CSSLookup.register(name, "oklch(94.3% 0.029 294.588)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "violet-200";
			CSSLookup.register(name, "oklch(89.4% 0.057 293.283)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "violet-300";
			CSSLookup.register(name, "oklch(81.1% 0.111 293.571)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "violet-400";
			CSSLookup.register(name, "oklch(70.2% 0.183 293.541)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "violet-500";
			CSSLookup.register(name, "oklch(60.6% 0.25 292.717)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "violet-600";
			CSSLookup.register(name, "oklch(54.1% 0.281 293.009)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "violet-700";
			CSSLookup.register(name, "oklch(49.1% 0.27 292.581)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "violet-800";
			CSSLookup.register(name, "oklch(43.2% 0.232 292.759)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "violet-900";
			CSSLookup.register(name, "oklch(38% 0.189 293.745)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "violet-950";
			CSSLookup.register(name, "oklch(28.3% 0.141 291.089)");
			return name;
		}

	}
}