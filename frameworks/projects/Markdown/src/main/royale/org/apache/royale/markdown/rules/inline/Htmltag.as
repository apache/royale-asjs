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
package org.apache.royale.markdown
{
	/**
	 * Process html tags
	 */
	public class Htmltag extends Rule
	{
		private function Htmltag()
		{
			
		}

		private static var _instance:Htmltag;
		public static function get():Htmltag
		{
			if(!_instance)
				_instance = new Htmltag();
			
			return _instance;
		}

		/**
		 * This code was copied from Remarkable. And the code is definitely remarkable... ;)
		 * It uses  very complex functional composition to build a RegExp for finding HTML tags.
		 * I'd like to replace it with something that's easier to follow, but it'll do for now.
		 */

		private function replace(regex:*=undefined, options:*=undefined):* {
			regex = regex.source;
			options = options || '';

			return function self(name:*, val:*):* {
				if (!name) {
					return new RegExp(regex, options);
				}
				val = val.source || val;
				regex = regex.replace(name, val);
				return self;
			};
		}


		private var attr_name:RegExp     = /[a-zA-Z_:][a-zA-Z0-9:._-]*/;

		private var unquoted:RegExp      = /[^"'=<>`\x00-\x20]+/;
		private var single_quoted:RegExp = /'[^']*'/;
		private var double_quoted:RegExp = /"[^"]*"/;

		private var _attr_value:RegExp;
		private function get attr_value():RegExp
		{
			if(!_attr_value)
			{
				_attr_value = replace(/(?:unquoted|single_quoted|double_quoted)/)
						('unquoted', unquoted)
						('single_quoted', single_quoted)
						('double_quoted', double_quoted)
						();
			}
			return _attr_value;
		}

		private var _attribute:RegExp;
		private function get attribute():RegExp
		{
			if(!_attribute)
			{
				_attribute = replace(/(?:\s+attr_name(?:\s*=\s*attr_value)?)/)
					('attr_name', attr_name)
					('attr_value', attr_value)
					();
			}
			return _attribute;
		}

		private var _open_tag:RegExp;
		private function get open_tag():RegExp
		{
			if(!_open_tag)
			{
		    _open_tag = replace(/<[A-Za-z][A-Za-z0-9]*attribute*\s*\/?>/)
					('attribute', attribute)
					();
			}
			return _open_tag;
		}

		private var close_tag:RegExp   = /<\/[A-Za-z][A-Za-z0-9]*\s*>/;
		private var comment:RegExp     = /<!---->|<!--(?:-?[^>-])(?:-?[^-])*-->/;
		private var processing:RegExp  = /<[?].*?[?]>/;
		private var declaration:RegExp = /<![A-Z]+\s+[^>]*>/;
		private var cdata:RegExp       = /<!\[CDATA\[[\s\S]*?\]\]>/;
		
		private var _HTML_TAG_RE:RegExp;

		private function get HTML_TAG_RE():RegExp
		{
			if(!_HTML_TAG_RE)
			{
				_HTML_TAG_RE = replace(/^(?:open_tag|close_tag|comment|processing|declaration|cdata)/)
					('open_tag', open_tag)
					('close_tag', close_tag)
					('comment', comment)
					('processing', processing)
					('declaration', declaration)
					('cdata', cdata)
					();
			}
			return _HTML_TAG_RE;
		}
		/**
		 * Here's the end of that mess...
		 */

		private function isLetter(ch:Number):Boolean
		{
			var lc:Number = ch | 0x20; // to lower case
			return (lc >= 0x61/* a */) && (lc <= 0x7a/* z */);
		}

		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.InlineState
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{
			var state:InlineState = istate as InlineState;
			var pos:int = state.position;

			if (!state.options.html) { return false; }

			// Check start
			var max:int = state.posMax;
			if (state.src.charCodeAt(pos) !== 0x3C/* < */ ||
					pos + 2 >= max) {
				return false;
			}

			// Quick fail on second char
			var ch:Number = state.src.charCodeAt(pos + 1);
			if (ch !== 0x21/* ! */ &&
					ch !== 0x3F/* ? */ &&
					ch !== 0x2F/* / */ &&
					!isLetter(ch)) {
				return false;
			}

			var match:Array = state.src.slice(pos).match(HTML_TAG_RE);
			if (!match) { return false; }

			if (!silent) {
				state.push(new ContentToken('htmltag',state.src.slice(pos, pos + match[0].length),state.level));
				// state.push({
				// 	type: 'htmltag',
				// 	content: state.src.slice(pos, pos + match[0].length),
				// 	level: state.level
				// });
			}
			state.position += match[0].length;
			return true;

		}

	}
}