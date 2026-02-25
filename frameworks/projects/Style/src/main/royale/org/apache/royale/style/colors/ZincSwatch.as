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
	public class ZincSwatch
	{
		private function ZincSwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "zinc-50";
			CSSLookup.register(name, "oklch(98.5% 0 0)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "zinc-100";
			CSSLookup.register(name, "oklch(96.7% 0.001 286.375)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "zinc-200";
			CSSLookup.register(name, "oklch(92% 0.004 286.32)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "zinc-300";
			CSSLookup.register(name, "oklch(87.1% 0.006 286.286)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "zinc-400";
			CSSLookup.register(name, "oklch(70.5% 0.015 286.067)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "zinc-500";
			CSSLookup.register(name, "oklch(55.2% 0.016 285.938)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "zinc-600";
			CSSLookup.register(name, "oklch(44.2% 0.017 285.786)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "zinc-700";
			CSSLookup.register(name, "oklch(37% 0.013 285.805)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "zinc-800";
			CSSLookup.register(name, "oklch(27.4% 0.006 286.033)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "zinc-900";
			CSSLookup.register(name, "oklch(21% 0.006 285.885)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "zinc-950";
			CSSLookup.register(name, "oklch(14.1% 0.005 285.823)");
			return name;
		}

	}
}