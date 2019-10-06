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
	COMPILE::JS
	public class Base64JSWrapper  
	{
		/**
		 * The Royale Compiler will inject html into the index.html file.  Surround with
		 * "inject_html" tag as follows:
		 *
		 * <inject_html>
		 * <script type="text/javascript" src="http://rawgit.com/beatgammit/base64-js/master/base64js.min.js"></script>
		 * </inject_html>
		 */
		public function Base64JSWrapper()
		{
		}
		
		public function fromByteArray(bytes:Object):String
		{
			var base64js:Object = window["base64js"];
			
			return base64js["fromByteArray"](bytes);
			
		}

		public function toByteArray(b64Str:String):Object
		{
			var base64js:Object = window["base64js"];
			
			return base64js["toByteArray"](b64Str);
			
		}
		
	}
}