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
	public class Replacements extends Rule
	{
		private function Replacements()
		{
			
		}

		private static var _instance:Replacements;
		public static function get():Replacements
		{
			if(!_instance)
				_instance = new Replacements();
			
			return _instance;
		}

		private const RARE_RE:RegExp = /\+-|\.\.|\?\?\?\?|!!!!|,,|--/;

		private const SCOPED_ABBR_RE:RegExp = /\((c|tm|r|p)\)/ig;
		private const SCOPED_ABBR:Object = {
			'c': '©',
			'r': '®',
			'p': '§',
			'tm': '™'
		};

		private function replaceScopedAbbr(str:String):String {
			if (str.indexOf('(') < 0) { return str; }

			return str.replace(SCOPED_ABBR_RE, function(match:String, name:String):String {
				return SCOPED_ABBR[name.toLowerCase()];
			});
		}


		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.CoreState 
		 * @royaleignorecoercion org.apache.royale.markdown.BlockToken 
		 * @royaleignorecoercion org.apache.royale.markdown.ContentToken 
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{
			var state:CoreState = istate as CoreState;
			// var i, token, text, inlineTokens, blkIdx;

			if (!state.options.typographer) { return false; }

			for (var blkIdx:int = state.tokens.length - 1; blkIdx >= 0; blkIdx--) {

				if (state.tokens[blkIdx].type !== 'inline') { continue; }

				var inlineTokens:Vector.<IToken> = (state.tokens[blkIdx] as BlockToken).children;

				for (var i:int = inlineTokens.length - 1; i >= 0; i--) {
					var token:ContentToken = inlineTokens[i] as ContentToken;
					if (token.type === 'text') {
						var text:String = token.content;

						text = replaceScopedAbbr(text);

						if (RARE_RE.test(text)) {
							text = text
								.replace(PLUS_MINUS, '±')
								// .., ..., ....... -> …
								// but ?..... & !..... -> ?.. & !..
								.replace(ELLIPSIS, '…').replace(/([?!])…/g, '$1..')
								.replace(QUEST_EXCLAM, '$1$1$1').replace(DOUBLE_COMMA, ',')
								// em-dash
								.replace(M_DASH, '$1\u2014$2')
								// en-dash
								.replace(N_DASH, '$1\u2013$2')
								.replace(N_DASH_2, '$1\u2013$2');
						}

						token.content = text;
					}
				}
			}
			return true;

		}
		private const PLUS_MINUS:RegExp = /\+-/g;
		private const ELLIPSIS:RegExp = /\.{2,}/g;
		private const QUEST_EXCLAM:RegExp = /([?!]){4,}/g;
		private const DOUBLE_COMMA:RegExp = /,{2,}/g;
		private const M_DASH:RegExp = /(^|[^-])---([^-]|$)/mg;
		private const N_DASH:RegExp = /(^|\s)--(\s|$)/mg;
		private const N_DASH_2:RegExp = /(^|[^-\s])--([^-\s]|$)/mg;

	}
}