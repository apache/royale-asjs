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
	public class Abbr2 extends Rule
	{
		private function Abbr2()
		{
			
		}

		private static var _instance:Abbr2;
		public static function get():Abbr2
		{
			if(!_instance)
				_instance = new Abbr2();
			
			return _instance;
		}

		private const PUNCT_CHARS:String = ' \n()[]\'".,!?-';


			// from Google closure library
			// http://closure-library.googlecode.com/git-history/docs/local_closure_goog_string_string.js.source.html#line1021
			private function regEscape(s:String):String {
				return s.replace(/([-()\[\]{}+?*.$\^|,:#<!\\])/g, '\\$1');
			}

		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.CoreState
		 * @royaleignorecoercion org.apache.royale.markdown.ContentToken
		 * @royaleignorecoercion Vector.<BlockToken>
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{
			var state:CoreState = istate as CoreState;
			// var i, j, l, tokens, token, text, nodes, pos, level, reg, m, regText,
			var blockTokens:Vector.<BlockToken> = state.tokens as Vector.<BlockToken>;

			if (!state.env.abbreviations) { return false; }
			if (!state.env.abbrRegExp) {
				var regText:String = '(^|[' + PUNCT_CHARS.split('').map(regEscape).join('') + '])'
								+ '(' + Object.keys(state.env.abbreviations).map(function (x:String):String {
													return x.substr(1);
												}).sort(function (a:*, b:*):Number {
													return b.length - a.length;
												}).map(regEscape).join('|') + ')'
								+ '($|[' + PUNCT_CHARS.split('').map(regEscape).join('') + '])';
				state.env.abbrRegExp = new RegExp(regText, 'g');
			}
			var reg:RegExp = state.env.abbrRegExp;
			var len:int = blockTokens.length;
			for (var j:int = 0; j < len; j++) {
				if (blockTokens[j].type !== 'inline') { continue; }
				var tokens:Vector.<IToken> = blockTokens[j].children;

				// We scan from the end, to keep position when new tags added.
				for (var i:int = tokens.length - 1; i >= 0; i--) {
					var token:ContentToken = tokens[i] as ContentToken;
					if (token.type !== 'text') { continue; }

					var pos:int = 0;
					var text:String = token.content;
					reg.lastIndex = 0;
					var level:int = token.level;
					var nodes:Vector.<IToken> = new Vector.<IToken>();
					// global flag is set so we can loop through results while we have
					var m:Object = reg.exec(text);
					while (m) {
						if (reg.lastIndex > pos) {
							var newt:IToken = new ContentToken("text",text.slice(pos, m.index + m[1].length));
							newt.level = level;
							nodes.push(newt);
						}

						newt = new TagToken('abbr_open');
						newt.title = state.env.abbreviations[m[2]];
						newt.level = level++;
						nodes.push(newt);

						newt = new ContentToken("text",m[2]);
						newt.level = level;
						nodes.push(newt);

						newt = new TagToken('abbr_close');
						newt.level = --level;
						nodes.push(newt);

						pos = reg.lastIndex - m[3].length;
						m = reg.exec(text);
					}

					if (!nodes.length) { continue; }

					if (pos < text.length) {

						newt = new ContentToken("text",text.slice(pos));
						newt.level = level;
						nodes.push(newt);

					}

					// replace current node
					blockTokens[j].children = tokens = new Vector.<IToken>().concat(tokens.slice(0, i), nodes, tokens.slice(i + 1));
				}
			}

			return true;
		}

	}
}