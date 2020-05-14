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
	import markdownit.Renderer;

	/**
	 * @externs
	 */
	COMPILE::JS
	public class markdownit
	{
		/**
		 * 
         * <inject_script>
		 * var script = document.createElement("script");
		 * script.setAttribute("src", "https://cdnjs.cloudflare.com/ajax/libs/markdown-it/10.0.0/markdown-it.min.js");
		 * document.head.appendChild(script);
		 * </inject_script>
		 * 
		 * @param presetName String, MarkdownIt provides named presets as a convenience to quickly enable/disable active syntax rules and options for common use cases.
		 * 
		 * Available preset names:
		 *  - "commonmark" - configures parser to strict CommonMark mode.
		 *	- "default" - similar to GFM, used when no preset name given. Enables all available rules, but still without html, typographer & autolinker.
		 *  - "zero" - all rules disabled. Useful to quickly setup your config via .enable(). For example, when you need only bold and italic markup and nothing else.
		 * @param options Object, the options to configure
		 * 
		 * Available options:
		 * 	- html - false. Set true to enable HTML tags in source. Be careful! That's not safe! You may need external sanitizer to protect output from XSS. It's better to extend features via plugins, instead of enabling HTML.
		 *	- xhtmlOut - false. Set true to add '/' when closing single tags (<br />). This is needed only for full CommonMark compatibility. In real world you will need HTML output.
		 *	- breaks - false. Set true to convert \n in paragraphs into <br>.
		 *	- langPrefix - language-. CSS language class prefix for fenced blocks. Can be useful for external highlighters.
		 *	- linkify - false. Set true to autoconvert URL-like text to links.
		 *	- typographer - false. Set true to enable some language-neutral replacement + quotes beautification (smartquotes).
		 *	- quotes - “”‘’, String or Array. Double + single quotes replacement pairs, when typographer enabled and smartquotes on. For example, you can use '«»„“' for Russian, '„“‚‘' for German, and ['«\xA0', '\xA0»', '‹\xA0', '\xA0›'] for French (including nbsp).
		 *	- highlight - null. Highlighter function for fenced code blocks. Highlighter function (str, lang) should return escaped HTML. It can also return empty string if the source was not changed and should be escaped externaly. If result starts with <pre... internal wrapper is skipped.
		 *
		 */
		public function markdownit(presetName:Object = 'default', options:Object = null):void {}

		public var core:Object;
		public var utils:Object;
		public var tokens:Array;
		public var renderer:Renderer;

		/**
		 * Render markdown string into html. It does all magic for you :).
		 * 
		 * @param s String, the markdown
		 * @param env Object, the environment sandbox
		 */
		public function render(s:String, env:Object = null):String
        {	
			return null;
        }

		/**
		 * Similar to MarkdownIt.render but for single paragraph content. Result will NOT be wrapped into <p> tags.
		 * 
		 * @param s String, the markdown
		 * @param env Object, the environment sandbox
		 */
		public function renderInline(s:String, env:Object = null):String
        {	
			return null;
        }

		/**
		 * Set parser options (in the same format as in constructor). Probably, you will never need it, but you can change options after constructor call.
		 * 
		 * @param options Object, the options to configure
		 */
		public function use(attrs:Object):Object
        {	
			return null;
        }
		
		/**
		 * Set parser options (in the same format as in constructor). Probably, you will never need it, but you can change options after constructor call.
		 * 
		 * @param options Object, the options to configure
		 */
		public function set(options:Object):Object
        {	
			return null;
        }
		
		/**
		 * Enable list or rules. It will automatically find appropriate components, containing rules with given names. If rule not found, and ignoreInvalid not set - throws exception.
		 * 
		 * @param list String or Array. rule name or list of rule names to enable.
		 * @param ignoreInvalid Boolean. set true to ignore errors when rule not found.
		 */
		public function enable(options:Object):Object
        {	
			return null;
        }

		/**
		 * The same as MarkdownIt.enable, but turn specified rules off.
		 * 
		 * @param list String or Array. rule name or list of rule names to disable.
		 * @param ignoreInvalid Boolean. set true to ignore errors when rule not found.
		 */
		public function disable(options:Object):Object
        {	
			return null;
        }
	}
}