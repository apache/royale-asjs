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
package
{
	/**
	 * @externs
	 */
	COMPILE::JS
	public class hljs
	{
		/** 
         * <inject_script>
		 * var script = document.createElement("script");
		 * script.setAttribute("src", "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js");
		 * document.head.appendChild(script);
         * var link = document.createElement("link");
         * link.setAttribute("rel", "stylesheet");
         * link.setAttribute("type", "text/css");
         * link.setAttribute("href", "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/atom-one-dark.min.css");
         * document.head.appendChild(link);
		 * </inject_script>
		 */
		public function hljs(){}

		public static function highlightBlock(block:Element):void {}
	}
}
