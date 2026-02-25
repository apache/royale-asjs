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
	public class SlateSwatch
	{
		private function SlateSwatch()
		{
			
		}
		COMPILE::JS
		public static function get _50():String
		{
			var name:String = "slate-50";
			CSSLookup.register(name, "oklch(98.4% 0.003 247.858)");
			return name;
		}
		COMPILE::JS
		public static function get _100():String
		{
			var name:String = "slate-100";
			CSSLookup.register(name, "oklch(96.8% 0.007 247.896)");
			return name;
		}
		COMPILE::JS
		public static function get _200():String
		{
			var name:String = "slate-200";
			CSSLookup.register(name, "oklch(92.9% 0.013 255.508)");
			return name;
		}
		COMPILE::JS
		public static function get _300():String
		{
			var name:String = "slate-300";
			CSSLookup.register(name, "oklch(86.9% 0.022 252.894)");
			return name;
		}
		COMPILE::JS
		public static function get _400():String
		{
			var name:String = "slate-400";
			CSSLookup.register(name, "oklch(70.4% 0.04 256.788)");
			return name;
		}
		COMPILE::JS
		public static function get _500():String
		{
			var name:String = "slate-500";
			CSSLookup.register(name, "oklch(55.4% 0.046 257.417)");
			return name;
		}
		COMPILE::JS
		public static function get _600():String
		{
			var name:String = "slate-600";
			CSSLookup.register(name, "oklch(44.6% 0.043 257.281)");
			return name;
		}
		COMPILE::JS
		public static function get _700():String
		{
			var name:String = "slate-700";
			CSSLookup.register(name, "oklch(37.2% 0.044 257.287)");
			return name;
		}
		COMPILE::JS
		public static function get _800():String
		{
			var name:String = "slate-800";
			CSSLookup.register(name, "oklch(27.9% 0.041 260.031)");
			return name;
		}
		COMPILE::JS
		public static function get _900():String
		{
			var name:String = "slate-900";
			CSSLookup.register(name, "oklch(20.8% 0.042 265.755)");
			return name;
		}
		COMPILE::JS
		public static function get _950():String
		{
			var name:String = "slate-950";
			CSSLookup.register(name, "oklch(12.9% 0.042 264.695)");
			return name;
		}

	}
}