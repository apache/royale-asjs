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
	import org.apache.royale.debugging.assert;
	import org.apache.royale.style.util.CSSLookup;

	public class NamedColorSet
	{
		private static const OPACITY_SEPARATOR:String = "/";
		private static const HEX_COLOR:RegExp = /^#?([0-9a-fA-F]{6})$/;
		private static const HEX_COLOR_WITH_PREFIX:RegExp = /^0x([0-9a-fA-F]{6})$/;
		private static const WHITESPACE:RegExp = /\s/;

		private static const colors:Object = {};

		private function NamedColorSet()
		{
			assert(false, "NamedColorSet should not be instantiated.");
		}

		/**
		 * Registers an exact named color and returns the registered name.
		 * This is useful from application palette static getters.
		 */
		public static function register(name:String, value:*):String
		{
			validateName(name);
			var entry:Object = createEntry(value);
			var existing:Object = colors[name];
			if (existing)
			{
				assert(existing.rule == entry.rule, "Named color '" + name + "' is already registered with a different value.");
				return name;
			}
			colors[name] = entry;
			CSSLookup.register(name, entry.rule);
			return name;
		}

		/**
		 * Registers a named color and returns either its base name or an opacity variant specifier.
		 */
		public static function registerWithOpacity(name:String, value:*, opacity:Number = 100):String
		{
			register(name, value);
			return withOpacity(name, opacity);
		}

		/**
		 * Returns an opacity variant specifier, registering its CSS value on first use.
		 */
		public static function withOpacity(name:String, opacity:Number):String
		{
			validateOpacity(opacity);
			var entry:Object = colors[name];
			assert(entry, "Unknown named color: " + name);
			if (opacity == 100)
				return name;
			var specifier:String = getSpecifier(name, opacity);
			if (!CSSLookup.has(specifier))
			{
				CSSLookup.register(specifier, getRule(entry, opacity));
			}
			return specifier;
		}

		public static function has(name:String):Boolean
		{
			if (!name)
				return false;
			if (colors[name])
				return true;
			if (CSSLookup.has(name))
				return true;
			var parsed:Object = parseSpecifier(name);
			return parsed && colors[parsed.name] != null;
		}

		/**
		 * Resolves a named color or opacity variant to a CSS color value.
		 * If an opacity variant has not been requested before, it is registered on demand.
		 */
		public static function resolve(name:String):String
		{
			if (!name)
				return null;
			var entry:Object = colors[name];
			if (entry)
				return entry.rule;
			if (CSSLookup.has(name))
				return CSSLookup.getProperty(name);
			var parsed:Object = parseSpecifier(name);
			if (!parsed)
				return null;
			entry = colors[parsed.name];
			if (!entry)
				return null;
			withOpacity(parsed.name, parsed.opacity);
			return getRule(entry, parsed.opacity);
		}

		private static function validateName(name:String):void
		{
			assert(name && name.length > 0, "Named color name must not be empty.");
			assert(name.indexOf("--") != 0, "Named color names must not start with '--': " + name);
			assert(name.indexOf(OPACITY_SEPARATOR) == -1, "Named color names must not contain '" + OPACITY_SEPARATOR + "': " + name);
			assert(!WHITESPACE.test(name), "Named color names must not contain whitespace: " + name);
		}

		private static function validateOpacity(opacity:Number):void
		{
			assert(isValidOpacity(opacity), "Opacity must be between 0 and 100.");
		}

		private static function isValidOpacity(opacity:Number):Boolean
		{
			return !isNaN(opacity) && opacity >= 0 && opacity <= 100;
		}

		private static function createEntry(value:*):Object
		{
			var rgb:Array = getRGB(value);
			if (rgb)
			{
				return {
					rule: CSSColor.getColor(rgb),
					rgb: rgb
				};
			}
			var rule:String = String(value);
			assert(rule && rule.length > 0, "Named color value must not be empty.");
			return {
				rule: rule,
				rgb: null
			};
		}

		private static function getRGB(value:*):Array
		{
			var color:uint;
			if (typeof value == "number")
			{
				assert(!isNaN(Number(value)), "Named color numeric value must be a valid 24-bit RGB color.");
				color = uint(value);
				assert(color <= 0xFFFFFF, "Named color numeric value must be a 24-bit RGB color.");
				return uintToRGB(color);
			}
			if (value is String)
			{
				var stringValue:String = String(value);
				var match:Object = HEX_COLOR.exec(stringValue);
				if (!match)
					match = HEX_COLOR_WITH_PREFIX.exec(stringValue);
				if (match)
				{
					color = uint(parseInt(match[1], 16));
					return uintToRGB(color);
				}
			}
			return null;
		}

		private static function uintToRGB(value:uint):Array
		{
			return [
				(value >> 16) & 0xff,
				(value >> 8) & 0xff,
				value & 0xff
			];
		}

		private static function getSpecifier(name:String, opacity:Number):String
		{
			return name + OPACITY_SEPARATOR + opacity;
		}

		private static function getRule(entry:Object, opacity:Number):String
		{
			if (opacity == 100)
				return entry.rule;
			assert(entry.rgb, "Opacity variants require a 6-digit RGB color value.");
			return CSSColor.getColor(entry.rgb, opacity);
		}

		private static function parseSpecifier(value:String):Object
		{
			var parts:Array = value.split(OPACITY_SEPARATOR);
			if (parts.length != 2)
				return null;
			var opacity:Number = Number(parts[1]);
			if (!isValidOpacity(opacity))
				return null;
			return {
				name: parts[0],
				opacity: opacity
			};
		}
	}
}
