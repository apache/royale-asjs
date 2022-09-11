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
	 * JWT (JSON Web Token) is a compact URL-safe means of representing claims to be transferred between two parties.
	 * More information about JWT can be found at https://jwt.io/
	 * This class is used to decode a JWT token. When decoding, the token is stored in three parts: header, data and signature.
	 * The header and data are stored as JSON objects. The signature is stored as a string.
	 * 
	 * TODO: This class is not complete. It only decodes the header and data. It does not verify the signature at all.
	 * It also does not support encoding. We need an HMAC class to create and verify the signature.
	 * Important reading when this is implemented:
	 * https://auth0.com/blog/critical-vulnerabilities-in-json-web-token-libraries/
	 * 
	 */
	public class JWT
	{
		public function JWT()
		{
			
		}
		public var data:Object;
		public var header:Object;
		public var signature:String;

		/**
		 * Decodes a JWT token and stores the header, data and signature in this class.
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.10
		 */
		public static function decode(token:String):JWT{
			var jwt:JWT = new JWT();
			var parts:Array = token.split(".");
			jwt.header = JSON.parse(Base64.decodeToString(parts[0]));
			jwt.data = JSON.parse(Base64.decodeToString(parts[1]));
			jwt.signature = parts[2];
			return jwt;
		}

		/**
		 * TODO: implement this once we have an HMAC implementation
		 * encode a JWT token
		 */
		// public static function encode(header:Object, data:Object, secret:String):String
		// {
		// 	var headerString:String = Base64.encodeFromString(JSON.stringify(header));
		// 	var dataString:String = Base64.encodeFromString(JSON.stringify(data));
		// 	var signature:String = HMAC.hash(secret, headerString + "." + dataString);
		// 	return headerString + "." + dataString + "." + signature;
		// }
	}
}