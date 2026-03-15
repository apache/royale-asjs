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
	public class CyanSwatch
	{
		private function CyanSwatch()
		{
			
		}
		public static function get _50():String
		{
			var name:String = "cyan-50";
			CSSLookup.register(name, "oklch(98.4% 0.019 200.873)");
			return name;
		}
		public static function get _100():String
		{
			var name:String = "cyan-100";
			CSSLookup.register(name, "oklch(95.6% 0.045 203.388)");
			return name;
		}
		public static function get _200():String
		{
			var name:String = "cyan-200";
			CSSLookup.register(name, "oklch(91.7% 0.08 205.041)");
			return name;
		}
		public static function get _300():String
		{
			var name:String = "cyan-300";
			CSSLookup.register(name, "oklch(86.5% 0.127 207.078)");
			return name;
		}
		public static function get _400():String
		{
			var name:String = "cyan-400";
			CSSLookup.register(name, "oklch(78.9% 0.154 211.53)");
			return name;
		}
		public static function get _500():String
		{
			var name:String = "cyan-500";
			CSSLookup.register(name, "oklch(71.5% 0.143 215.221)");
			return name;
		}
		public static function get _600():String
		{
			var name:String = "cyan-600";
			CSSLookup.register(name, "oklch(60.9% 0.126 221.723)");
			return name;
		}
		public static function get _700():String
		{
			var name:String = "cyan-700";
			CSSLookup.register(name, "oklch(52% 0.105 223.128)");
			return name;
		}
		public static function get _800():String
		{
			var name:String = "cyan-800";
			CSSLookup.register(name, "oklch(45% 0.085 224.283)");
			return name;
		}
		public static function get _900():String
		{
			var name:String = "cyan-900";
			CSSLookup.register(name, "oklch(39.8% 0.07 227.392)");
			return name;
		}
		public static function get _950():String
		{
			var name:String = "cyan-950";
			CSSLookup.register(name, "oklch(30.2% 0.056 229.695)");
			return name;
		}

	}
}