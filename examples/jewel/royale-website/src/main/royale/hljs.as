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
         * <inject_html>
		 * <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.18.1/highlight.min.js"></script>
		 * <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.18.1/languages/actionscript.min.js"></script>
		 * <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.18.1/languages/xml.min.js"></script>
         * <link rel="stylesheet" title="Atom One Dark" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/atom-one-dark.min.css">
		 * </inject_html>
		 */
		public function hljs(){}

		public static function highlightBlock(block:Element):void {}
		
		public static function getLanguage(name:String):Object {
			return null;
		}
		
		/**
		 * Core highlighting function.
		 *
		 * @param {string} languageName - the language to use for highlighting
		 * @param {string} code - the code to highlight
		 * @param {boolean} ignore_illegals - whether to ignore illegal matches, default is to bail
		 * @param {array<mode>} continuation - array of continuation modes
		 *
		 * @returns an object that represents the result
		 * @property {string} language - the language name
		 * @property {number} relevance - the relevance score
		 * @property {string} value - the highlighted HTML code
		 * @property {string} code - the original raw code
		 * @property {mode} top - top of the current mode stack
		 * @property {boolean} illegal - indicates whether any illegal matches were found
		 */
		public static function highlight(languageName:String, code:String, ignore_illegals:Boolean = false, continuation:Array = null):Object {
			return null;
		}
		
		public static function highlightAuto(languageName:String, code:String, ignore_illegals:Boolean = false, continuation:Array = null):Object {
			return null;
		}
	}
}