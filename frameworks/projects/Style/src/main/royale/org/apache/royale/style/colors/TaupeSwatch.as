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
	public class TaupeSwatch
	{
		private function TaupeSwatch()
		{
			
		}
		public static function get _50():String
		{
			var name:String = "taupe-50";
			CSSLookup.register(name, "oklch(98.6% 0.002 67.8)");
			return name;
		}
		public static function get _100():String
		{
			var name:String = "taupe-100";
			CSSLookup.register(name, "oklch(96% 0.002 17.2)");
			return name;
		}
		public static function get _200():String
		{
			var name:String = "taupe-200";
			CSSLookup.register(name, "oklch(92.2% 0.005 34.3)");
			return name;
		}
		public static function get _300():String
		{
			var name:String = "taupe-300";
			CSSLookup.register(name, "oklch(86.8% 0.007 39.5)");
			return name;
		}
		public static function get _400():String
		{
			var name:String = "taupe-400";
			CSSLookup.register(name, "oklch(71.4% 0.014 41.2)");
			return name;
		}
		public static function get _500():String
		{
			var name:String = "taupe-500";
			CSSLookup.register(name, "oklch(54.7% 0.021 43.1)");
			return name;
		}
		public static function get _600():String
		{
			var name:String = "taupe-600";
			CSSLookup.register(name, "oklch(43.8% 0.017 39.3)");
			return name;
		}
		public static function get _700():String
		{
			var name:String = "taupe-700";
			CSSLookup.register(name, "oklch(36.7% 0.016 35.7)");
			return name;
		}
		public static function get _800():String
		{
			var name:String = "taupe-800";
			CSSLookup.register(name, "oklch(26.8% 0.011 36.5)");
			return name;
		}
		public static function get _900():String
		{
			var name:String = "taupe-900";
			CSSLookup.register(name, "oklch(21.4% 0.009 43.1)");
			return name;
		}
		public static function get _950():String
		{
			var name:String = "taupe-950";
			CSSLookup.register(name, "oklch(14.7% 0.004 49.3)");
			return name;
		}

	}
}