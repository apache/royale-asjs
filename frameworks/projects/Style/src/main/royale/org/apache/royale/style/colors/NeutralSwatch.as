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
	public class NeutralSwatch
	{
		private function NeutralSwatch()
		{
			
		}
		public static function get _50():String
		{
			var name:String = "neutral-50";
			CSSLookup.register(name, "oklch(98.5% 0 0)");
			return name;
		}
		public static function get _100():String
		{
			var name:String = "neutral-100";
			CSSLookup.register(name, "oklch(97% 0 0)");
			return name;
		}
		public static function get _200():String
		{
			var name:String = "neutral-200";
			CSSLookup.register(name, "oklch(92.2% 0 0)");
			return name;
		}
		public static function get _300():String
		{
			var name:String = "neutral-300";
			CSSLookup.register(name, "oklch(87% 0 0)");
			return name;
		}
		public static function get _400():String
		{
			var name:String = "neutral-400";
			CSSLookup.register(name, "oklch(70.8% 0 0)");
			return name;
		}
		public static function get _500():String
		{
			var name:String = "neutral-500";
			CSSLookup.register(name, "oklch(55.6% 0 0)");
			return name;
		}
		public static function get _600():String
		{
			var name:String = "neutral-600";
			CSSLookup.register(name, "oklch(43.9% 0 0)");
			return name;
		}
		public static function get _700():String
		{
			var name:String = "neutral-700";
			CSSLookup.register(name, "oklch(37.1% 0 0)");
			return name;
		}
		public static function get _800():String
		{
			var name:String = "neutral-800";
			CSSLookup.register(name, "oklch(26.9% 0 0)");
			return name;
		}
		public static function get _900():String
		{
			var name:String = "neutral-900";
			CSSLookup.register(name, "oklch(20.5% 0 0)");
			return name;
		}
		public static function get _950():String
		{
			var name:String = "neutral-950";
			CSSLookup.register(name, "oklch(14.5% 0 0)");
			return name;
		}

	}
}