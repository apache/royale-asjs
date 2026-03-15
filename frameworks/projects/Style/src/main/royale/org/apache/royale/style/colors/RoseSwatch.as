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
	public class RoseSwatch
	{
		private function RoseSwatch()
		{
			
		}
		public static function get _50():String
		{
			var name:String = "rose-50";
			CSSLookup.register(name, "oklch(96.9% 0.015 12.422)");
			return name;
		}
		public static function get _100():String
		{
			var name:String = "rose-100";
			CSSLookup.register(name, "oklch(94.1% 0.03 12.58)");
			return name;
		}
		public static function get _200():String
		{
			var name:String = "rose-200";
			CSSLookup.register(name, "oklch(89.2% 0.058 10.001)");
			return name;
		}
		public static function get _300():String
		{
			var name:String = "rose-300";
			CSSLookup.register(name, "oklch(81% 0.117 11.638)");
			return name;
		}
		public static function get _400():String
		{
			var name:String = "rose-400";
			CSSLookup.register(name, "oklch(71.2% 0.194 13.428)");
			return name;
		}
		public static function get _500():String
		{
			var name:String = "rose-500";
			CSSLookup.register(name, "oklch(64.5% 0.246 16.439)");
			return name;
		}
		public static function get _600():String
		{
			var name:String = "rose-600";
			CSSLookup.register(name, "oklch(58.6% 0.253 17.585)");
			return name;
		}
		public static function get _700():String
		{
			var name:String = "rose-700";
			CSSLookup.register(name, "oklch(51.4% 0.222 16.935)");
			return name;
		}
		public static function get _800():String
		{
			var name:String = "rose-800";
			CSSLookup.register(name, "oklch(45.5% 0.188 13.697)");
			return name;
		}
		public static function get _900():String
		{
			var name:String = "rose-900";
			CSSLookup.register(name, "oklch(41% 0.159 10.272)");
			return name;
		}
		public static function get _950():String
		{
			var name:String = "rose-950";
			CSSLookup.register(name, "oklch(27.1% 0.105 12.094)");
			return name;
		}

	}
}