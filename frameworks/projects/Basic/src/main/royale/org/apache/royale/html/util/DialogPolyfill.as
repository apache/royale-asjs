////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//	  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.html.util
{
	COMPILE::JS
	public class DialogPolyfill
	{
		/** 
		 * <inject_script>
		 * var script = document.createElement("script");
		 * script.setAttribute("src", "https://cdnjs.cloudflare.com/ajax/libs/dialog-polyfill/0.4.9/dialog-polyfill.min.js");
		 * document.head.appendChild(script)
		 *  var link = document.createElement("link");
		 *  link.setAttribute("rel", "stylesheet");
		 *  link.setAttribute("type", "text/css");
		 *  link.setAttribute("href", "https://cdnjs.cloudflare.com/ajax/libs/dialog-polyfill/0.4.9/dialog-polyfill.min.css");
		 *  document.head.appendChild(link);
		 * </inject_script>
		 */
		public function DialogPolyfill(){}
		 
		public static function registerDialog(dialog:Element):void
		{
				window["dialogPolyfill"]["registerDialog"](dialog);
    }
	}
}