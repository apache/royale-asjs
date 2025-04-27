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

package mx.utils
{

	COMPILE::SWF{
		import flash.utils.escapeMultiByte;
		import flash.system.System
	}
	
	/**
	 * This escapeMultiByte function for swf will always behave as if System.useCodePage = false;
	 *
	 * @param {String} str The input string to be escaped.
	 * @return {String} The escaped string with multi-byte characters properly encoded.
	 */
	COMPILE::SWF
	public function escapeMultiByte(str:String):String
	{
		var check:Boolean = System.useCodePage;
		if (check) System.useCodePage = false;
		var result:String = flash.utils.escapeMultiByte(str);
		if (check) System.useCodePage = true;
		return result;
	}
	
	
	/**
	 *  The escapeMultiByte function is intended as an emulation
	 *  of the corresponding legacy flash.utils api function, and for js is always assuming System.useCodePage = false;
	 *
	 */
	COMPILE::JS
	public function escapeMultiByte(inputStr:String):String {
		//todo performance improvements?
		var result:String = "";
		if (inputStr == null) return "null";
		
		
		var bytes:Array = [];  // UTF-8 bytes
		
		for (var i:uint = 0; i < inputStr.length; i++) {
			var charCode:uint = inputStr.charCodeAt(i);
			
			if (charCode == 0x00) {
				//flash behavior seems to be: return everything processed so far and ignore the rest of the string
				return result;
			}
			
			// Skip invalid UTF-16 code units
			if (charCode > 0xFFFF ) {
				continue; // Skip invalid code units, similar to what flash appears to be doing
			}
			if (charCode <= 0x7F) {
				// Single-byte ASCII
				if (charCode <= 0x20) {
					// spaces and control chars are hex encoded
					bytes.push( charCode);
				} else if (charCode == 0x7F
						|| (charCode >= 0x21 && charCode <= 0x2F) || (charCode >= 0x3A && charCode <= 0x40) || (charCode >= 0x5B && charCode <= 0x5E) || charCode == 0x60 || (charCode >= 0x7B && charCode <= 0x7E)) {
					// Encode reserved or special characters in the ASCII range
					bytes.push(charCode);
				} else {
					result += String.fromCharCode(charCode); // Append directly
				}
			} else if (charCode >= 0x80 && charCode <= 0xFF) {
				// Handle Latin-1 characters, map to UTF-8
				bytes.push((charCode >> 6) | 0xC0);  // First UTF-8 byte
				bytes.push((charCode & 0x3F) | 0x80); // Second UTF-8 byte
			} else if (charCode >= 0xD800 && charCode <= 0xDBFF) {
				// High surrogate, check for low surrogate
				var highSurrogate:uint = charCode; // Get high surrogate
				var lowSurrogate:uint = inputStr.charCodeAt(++i); // Get the next character (low surrogate)
				
				if (lowSurrogate >= 0xDC00 && lowSurrogate <= 0xDFFF) {
					// Valid surrogate pair
					var codePoint:uint = 0x10000 + ((highSurrogate - 0xD800) << 10) + (lowSurrogate - 0xDC00);
					
					// Encode to UTF-8
					bytes.push((codePoint >> 18) | 0xF0);
					bytes.push(((codePoint >> 12) & 0x3F) | 0x80);
					bytes.push(((codePoint >> 6) & 0x3F) | 0x80);
					bytes.push((codePoint & 0x3F) | 0x80);
				} else {
					// Lone high surrogate, replace with U+FFFD
					bytes = [0xEF, 0xBF, 0xBD];
					i--; // Revert position for low surrogate
				}
			} else if (charCode >= 0xDC00 && charCode <= 0xDFFF) {
				// Lone low surrogate, replace with U+FFFD
				bytes = [0xEF, 0xBF, 0xBD];
			} else if (charCode <= 0x7FF) {
				// Two-byte UTF-8 sequence
				bytes.push((charCode >> 6) | 0xC0);
				bytes.push((charCode & 0x3F) | 0x80);
			} else if (charCode <= 0xFFFF) {
				// Three-byte UTF-8 sequence
				bytes.push((charCode >> 12) | 0xE0);
				bytes.push(((charCode >> 6) & 0x3F) | 0x80);
				bytes.push((charCode & 0x3F) | 0x80);
			} else {
				// Invalid characters outside UTF-16 range (shouldn't occur normally)
				bytes.push(0xEF, 0xBF, 0xBD); // Replace with U+FFFD
			}
			
			// Percent-encode bytes
			while (bytes.length) {
				result += "%" + ("0" + (bytes.shift()).toString(16).toUpperCase()).substr(-2);
			}
		}
		
		return result;
	}
}


