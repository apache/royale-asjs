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

/**
 * Implementation derived from:
 * https://sociodox.com/base64.html
 * available under MIT License.
 * 
 * By: Jean-Philippe Auclair : http://jpauclair.net 
 * Based on article: http://jpauclair.net/2010/01/09/base64-optimized-as3-lib/ 
 * Benchmark: 
 * This version: encode: 260ms decode: 255ms 
 * Blog version: encode: 322ms decode: 694ms 
 * as3Crypto encode: 6728ms decode: 4098ms 
 * 
 * Encode: com.sociodox.utils.Base64 is 25.8x faster than as3Crypto Base64 
 * Decode: com.sociodox.utils.Base64 is 16x faster than as3Crypto Base64 
 * 
 * Optimize & Profile any Flash content with TheMiner ( http://www.sociodox.com/theminer ) 
 */

package org.apache.royale.utils
{
	public class Base64  
	{  
		
		public static function encode(data:BinaryData):String  
		{  
			var out:BinaryData = new BinaryData();  
			//Presetting the length keep the memory smaller and optimize speed since there is no "grow" needed  
			out.length = (2 + data.length - ((data.length + 2) % 3)) * 4 / 3; //Preset length //1.6 to 1.5 ms  
			var i:int = 0;  
			var r:int = data.length % 3;  
			var len:int = data.length - r;  
			var c:uint; //read (3) character AND write (4) characters  
			var outPos:int = 0;  
			while (i < len)  
			{  
				//Read 3 Characters (8bit * 3 = 24 bits)  
				c = data.readByteAt(int(i++)) << 16 | data.readByteAt(int(i++)) << 8 | data.readByteAt(int(i++));
				
				out.writeByteAt(int(outPos++),encodeChars[int(c >>> 18)]);  
				out.writeByteAt(int(outPos++), encodeChars[int(c >>> 12 & 0x3f)]);  
				out.writeByteAt(int(outPos++), encodeChars[int(c >>> 6 & 0x3f)]);
				out.writeByteAt(int(outPos++), encodeChars[int(c & 0x3f)]);
			}
			
			if (r == 1) //Need two "=" padding
			{
				//Read one char, write two chars, write padding
				c = data[int(i)];
				
				out.writeByteAt(int(outPos++), encodeChars[int(c >>> 2)]);
				out.writeByteAt(int(outPos++), encodeChars[int((c & 0x03) << 4)]);  
				out.writeByteAt(int(outPos++), 61);
				out.writeByteAt(int(outPos++), 61);
			}  
			else if (r == 2) //Need one "=" padding  
			{  
				c = data.readByteAt(int(i++)) << 8 | data.readByteAt(int(i));  
				
				out.writeByteAt(int(outPos++), encodeChars[int(c >>> 10)]);
				out.writeByteAt(int(outPos++), encodeChars[int(c >>> 4 & 0x3f)]);
				out.writeByteAt(int(outPos++), encodeChars[int((c & 0x0f) << 2)]);  
				out.writeByteAt(int(outPos++), 61);
			}  
			
			return out.readUTFBytes(out.length);  
		}  
		
		public static function decode(str:String):BinaryData  
		{  
			var c1:int;  
			var c2:int;  
			var c3:int;  
			var c4:int;  
			var i:int = 0;  
			var len:int = str.length;  
			
			var byteString:BinaryData = new BinaryData();  
			byteString.writeUTFBytes(str);  
			var outPos:int = 0;  
			while (i < len)  
			{  
				//c1  
				c1 = decodeChars[int(byteString.readByteAt(i++))];  
				if (c1 == -1)  
					break;  
				
				//c2  
				c2 = decodeChars[int(byteString.readByteAt(i++))];  
				if (c2 == -1)  
					break;  
				
				byteString.writeByteAt(int(outPos++), (c1 << 2) | ((c2 & 0x30) >> 4));  
				
				//c3  
				c3 = byteString.readByteAt(int(i++));  
				if (c3 == 61)  
				{  
					byteString.length = outPos  
					return byteString;  
				}  
				
				c3 = decodeChars[int(c3)];  
				if (c3 == -1)  
					break;  
				
				byteString.writeByteAt(int(outPos++), ((c2 & 0x0f) << 4) | ((c3 & 0x3c) >> 2));  
				
				//c4  
				c4 = byteString.readByteAt(int(i++));  
				if (c4 == 61)  
				{  
					byteString.length = outPos  
					return byteString;  
				}  
				
				c4 = decodeChars[int(c4)];  
				if (c4 == -1)  
					break;  
				
				byteString.writeByteAt(int(outPos++), ((c3 & 0x03) << 6) | c4);  
			}  
			byteString.length = outPos;
			byteString.position = 0;
			return byteString;  
		}  
		
		public static function InitEncoreChar():Vector.<int>  
		{  
			var encodeChars:Vector.<int> = new Vector.<int>(64, true);  
			
			// We could push the number directly  
			// but I think it's nice to see the characters (with no overhead on encode/decode)  
			var chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";  
			for (var i:int = 0; i < 64; i++)  
			{  
				encodeChars[i] = chars.charCodeAt(i);  
			}  
			
			return encodeChars;  
		}  
		
		public static function InitDecodeChar():Vector.<int>  
		{  
			
			var decodeChars:Vector.<int> = new <int>[  
				-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
				-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
				-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,   
				52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,   
				-1,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,   
				15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,   
				-1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,   
				41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1,   
				-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
				-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
				-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
				-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
				-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
				-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
				-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,   
				-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];  
			
			return decodeChars;  
		}  
        private static var _encodeChars:Vector.<int>;
		private static function get encodeChars():Vector.<int>{
			if(!_encodeChars){
				_encodeChars = InitEncoreChar();
			}
			return _encodeChars;
		}
        private static var _decodeChars:Vector.<int>;
		private static function get decodeChars():Vector.<int>{
			if(!_decodeChars){
				_decodeChars = InitDecodeChar();
			}
			return _decodeChars;
		}
		
	}  
}