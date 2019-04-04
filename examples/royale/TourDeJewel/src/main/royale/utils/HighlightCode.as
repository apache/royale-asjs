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
package utils
{
	public class HighlightCode
	{
		/** 
         * Code created by Piotr Zarzycki in transpiledactionScript.com
         * https://github.com/piotrzarzycki21/TranspiledActionScript/blob/examples/Examples/TranspiledActionScriptWebsite/src/utils/Highlight.as
         * 
		 * <inject_html>
		 * <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js"></script>
         * <link rel="stylesheet" title="Atom One Dark" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/atom-one-dark.min.css">
		 * </inject_html>
		 */
		public function HighlightCode()
		{
		}

		// COMPILE::JS		
		// public function initHighlight():void
		// {
		// 	var hljs:Object = window["hljs"];
		// 	//prevent renaming by compiler
		// 	hljs["initHighlightingOnLoad"]();
		// }
		
		COMPILE::JS	
        /**
         * block is the element (WrappedHTMLElement) inside the component (the <code> tag)
         */
		public function highlightBlock(block:Object):void
		{
			var hljs:Object = window["hljs"];
			//prevent renaming by compiler
			hljs["highlightBlock"](block);
		}
	}
}