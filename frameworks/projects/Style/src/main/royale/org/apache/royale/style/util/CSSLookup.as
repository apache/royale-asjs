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
package org.apache.royale.style.util
{
	import org.apache.royale.debugging.assert;

	/**
	 * The CSSLookup class is a utility for looking up CSS properties and their associated selectors and rules.
	 * It is used internally by the style system to manage and apply styles to components.
	 * 
	 * It is similar to CSS variables, but does not use the "--" syntax and is not inherited.
	 * It is more of a lookup table for styles that can be applied to components.
	 */
	public class CSSLookup
	{
		private function CSSLookup()
		{
			
		}
		COMPILE::JS
		private static const propMap:Map = new Map();

		public static function register(name:String, property:String):void
		{
			COMPILE::JS
			{
				assert(name.indexOf("--") != 0, "CSSLookup does not support CSS variables. The name should not start with '--': " + name);
				// Only add once. "has" is much faster than running "set" again.
				if(propMap.has(name))
					return;

				propMap.set(name, property);
			}
		}
		public static function getProperty(name:String):String
		{
			COMPILE::JS
			{
				return propMap.get(name);
			}
			COMPILE::SWF
			{
				return null;
			}
		}
		public static function has(name:String):Boolean
		{
			COMPILE::JS
			{
				return propMap.has(name);
			}
			COMPILE::SWF
			{
				return false;
			}
		}
	}
}