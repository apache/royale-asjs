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
		import flash.utils.unescapeMultiByte;
		import flash.system.System;
	}
	
	/**
	 *  This unescapeMultiByte function for swf will always behave as if System.useCodePage = false;
	 * @param str
	 * @return
	 */
	COMPILE::SWF
	public function unescapeMultiByte(str:String):String
	{
		var check:Boolean = System.useCodePage;
		if (check) System.useCodePage = false;
		var result:String = flash.utils.unescapeMultiByte(str);
		if (check) System.useCodePage = true;
		return result;
	}
	
	
	/**
	 *  The unescapeMultiByte function is intended as an emulation
	 *  of the corresponding legacy flash.utils api function, and for javascript is always assuming System.useCodePage = false;
	 *
	 */
	COMPILE::JS
	public function unescapeMultiByte(str:String):String
	{
		//todo performance improvements?
		//this will likely be fine for small to medium strings, but for large strings it might be better to refactor to at least avoid result "+=" for strings
		//maybe use something like a TypedArray 'StringBuilder' to accumulate the decoded content - and convert to a string at the end?
		
		if (str == null) return 'null'; //exit early #1
		if (str.length == 0) return ''; //exit early #2
		var result:String = '';
		var i:uint = 0;
		var l:uint = str.length;
		const percentCode:uint = '%'.charCodeAt(0);
		function isValidHex(chr:String):Boolean{
			return '0123456789ABCDEFabcdef'.indexOf(chr) != -1;
		}
		function isContinuationByte(byte:int):Boolean {
			// Apply the mask 0xC0 (binary: 11000000)
			return (byte & 0xC0) == 0x80;
		}
		var collected:Array = [];
		var byte:uint;
		while (i < l) {
			var chr:String = str.charAt(i);
			var invalid:Boolean = false;
			
			if (chr.charCodeAt(0) === percentCode) {
				// Handle %XX sequences
				
				if (i + 2 < l) {
					var check:String = str.slice(i + 1, i + 3);
					if (isValidHex(check.charAt(0))) {
						if (isValidHex(check.charAt(1))) {
							i+=3;
							byte = parseInt(check,16);
							if (byte < 128) {
								collected.length = 0;
								result += String.fromCharCode(byte);
								
								continue;
							} else {
								//collect (and therefore flag for extra bytes)
								collected.push(byte);
							}
							
						} else {
							//if the first is valid and the second is not then skip both 'hex' chars
							i+=3;
							continue;
						}
					} else {
						//skip the first 'hex' char.
						i += 2;
						continue;
						
					}
					
					if (collected.length) {
						var offset:uint;
						//byte is defined
						if (byte > 191 && byte < 224) {
							//needs 2 bytes
							offset = getExtraBytes(str.slice(i, i+3),percentCode, isValidHex,collected )
							// Overlong 2-byte sequences if collected[0] == 0xC0 || collected[0] == 0xC1
							invalid = (collected.length != 2 || !isContinuationByte(collected[1]) || collected[0] == 0xC0 || collected[0] == 0xC1);
							i += offset;
							if (!invalid) {
								result += String.fromCharCode((collected[0] & 31) << 6 | (collected[1] & 63));
							}
						} else if (byte > 223 && byte < 240) {
							//needs 3 bytes
							offset = getExtraBytes(str.slice(i, i+6),percentCode, isValidHex,collected );
							//Overlong 3-byte sequences if collected[0] == 0xE0 && collected[1] < 0xA0
							invalid = (collected.length != 3 || !isContinuationByte(collected[1]) || !isContinuationByte(collected[2]) || (collected[0] == 0xE0 && collected[1] < 0xA0));
							i += offset;
							if (!invalid) {
								result += String.fromCharCode((collected[0] & 15) << 12 | (collected[1] & 63) <<6 | (collected[2] & 63));
							}
						} else if (byte > 239 && byte < 248) { // 4-byte sequence
							offset = getExtraBytes(str.slice(i, i + 9), percentCode, isValidHex, collected);
							// Overlong 4-byte sequences or invalid continuation bytes
							invalid = (collected.length != 4 ||
									!isContinuationByte(collected[1]) ||
									!isContinuationByte(collected[2]) ||
									!isContinuationByte(collected[3]) ||
									(collected[0] == 0xF0 && collected[1] < 0x90)); // Overlong sequence check
							
							i += offset;
							if (!invalid) {
								// Adjust the leading byte if it is greater than 0xF4
								if (collected[0] > 0xF4) {
									collected[0] = 0xF1; // Force it to act as F1 so (F1 & 0x07) becomes 1 instead of 5
								}
								
								// Now compute the code point from the (possibly adjusted) bytes:
								var codePoint:uint = ((collected[0] & 0x07) << 18) |
										((collected[1] & 0x3F) << 12) |
										((collected[2] & 0x3F) << 6) |
										(collected[3] & 0x3F);
								
								// For code points beyond BMP, convert them to a surrogate pair
								codePoint -= 0x10000;
								var highSurrogate:uint = 0xD800 + (codePoint >> 10);
								var lowSurrogate:uint = 0xDC00 + (codePoint & 0x3FF);
								result += String.fromCharCode(highSurrogate) + String.fromCharCode(lowSurrogate);
							}
						} else {
							//invalid leading byte
							invalid = true;
						}
						if (invalid){
							//result += String.fromCharCode(0xFFFD); //this is a string representation of invalid value; this was attempted, but seems it's not used in flash
							//instead, it seems this is what is happening:
							while (collected.length) {
								result += String.fromCharCode(collected.shift());
							}
							
						}
						collected.length = 0;
					}
				} else {
					i++; // it should be ''
					if (i + 1 == l) {
						i++;
					}
				}
			} else {
				result += chr; // Append raw characters as-is
				i++;
			}
		}
		return result;
	}
}


COMPILE::JS
function getExtraBytes(str:String,marker:uint,hexCheck:Function,into:Array):uint{
	var i:uint=0;
	var l:uint = str.length;
	var ok:Boolean;
	if (str.charCodeAt(i) === marker) {
		if (i + 2 < l) {
			var check:String = str.slice(i + 1, i + 3);
			if (hexCheck(check.charAt(0))) {
				if (hexCheck(check.charAt(1))) {
					i=3;
					into.push(parseInt(check,16));
					ok = true;
				} else {
					//skip the percent and next 2 invalid hex chars
					i = 3;
				}
			} else {
				//skip the percent and the first invalid hex char.
				i = 2;
			}
		} //otherwise we did not find a valid hex sequence, no possibility to decode
		
	} //else we did not find a valid byte marker, no possibility to decode
	if (ok) {
		str = str.substr(i,str.length-i);
		if (str.length) {
			//continue to accumulate bytes
			i += getExtraBytes(str,marker,hexCheck,into);
		}
	}
	return i;
}