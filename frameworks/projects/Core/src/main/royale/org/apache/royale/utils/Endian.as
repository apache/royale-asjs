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
package org.apache.royale.utils
{
	/**
	 *  The endianness of the byte data.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.7.0
	 */
	public class Endian
	{
		/**
		 *  Indicates the most significant byte of the multibyte number appears first in the sequence of bytes.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		public static const BIG_ENDIAN:String = "bigEndian";

		/**
		 *  Indicates the least significant byte of the multibyte number appears first in the sequence of bytes.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		public static const LITTLE_ENDIAN:String = "littleEndian";


		/**
		 *  Indicates the default endianness on the system.
		 *  In swf targets this is always BIG_ENDIAN. When targeting
		 *  javascript it may differ depending on the target environment,
		 *  but is Endian.LITTLE_ENDIAN for most machines/browsers.
		 *  In theory, the native support classes for javascript should
		 *  have better performance when working with binary data
		 *  for integers and numbers represented with this endianness.
		 *
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.7.0
		 */
		public static function get systemEndian():String {
			COMPILE::SWF {
				return BIG_ENDIAN;
			}
			COMPILE::JS {
				return _sysEndian;
			}
		}


		COMPILE::JS
		private static var _sysEndian:String =
				function():String {
					var tester:Uint8Array = new Uint8Array([102,108,101,120]);
					var checker:Uint32Array = new Uint32Array(tester.buffer);
					var check:uint = checker[0];
					return (check == 1718379896) ? BIG_ENDIAN : LITTLE_ENDIAN ;
				}();

	}
}
