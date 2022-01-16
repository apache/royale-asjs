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
	import org.apache.royale.markdown.helpers.parseLinkLabel;
	import org.apache.royale.markdown.helpers.wrappedInParagraph;

	public class Abbr extends Rule
	{
		private function Abbr()
		{
			
		}
		private static var _instance:Abbr;
		public static function get():Abbr
		{
			if(!_instance)
				_instance = new Abbr();
			
			return _instance;
		}

		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.ContentToken 
		 * @royaleignorecoercion org.apache.royale.markdown.TagToken 
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{
			var state:CoreState = istate as CoreState;
			var tokens:Vector.<IToken> = state.tokens;//, i, l, content, pos;

			if (state.inlineMode) {
				return false;
			}
			var len:int = tokens.length - 1;
			// Parse inlines
			for (var i:int = 1; i < len; i++) {
				var token:ContentToken = tokens[i] as ContentToken;
				var lastToken:IToken = tokens[i - 1];
				var nextToken:IToken = tokens[i + 1];
				if(wrappedInParagraph(lastToken,token,nextToken))
				{
					var content:String = token.content;
					while (content.length) {
						var pos:int = parseAbbr(content, state.inlineParser, state.options, state.env);
						if (pos < 0) { break; }
						content = content.slice(pos).trim();
					}

					token.content = content;
					if (!content.length) {
						lastToken.tight = true;
						nextToken.tight = true;
					}
				}
			}
			return true;
		}

		private function parseAbbr(str:String, inlineParser:InlineParser, options:MarkdownOptions, env:Environment):int
		{
			if (str.charCodeAt(0) !== 0x2A/* * */) { return -1; }
			if (str.charCodeAt(1) !== 0x5B/* [ */) { return -1; }

			if (str.indexOf(']:') === -1) { return -1; }

			var state:InlineState = new InlineState(str, inlineParser, options, env, new Vector.<IToken>());
			var labelEnd:int = parseLinkLabel(state, 1);

			if (labelEnd < 0 || str.charCodeAt(labelEnd + 1) !== 0x3A/* : */) { return -1; }

			var max:int = state.posMax;

			// abbr title is always one line, so looking for ending "\n" here
			for (var pos:int = labelEnd + 2; pos < max; pos++) {
				if (state.src.charCodeAt(pos) === 0x0A) { break; }
			}

			var label:String = str.slice(2, labelEnd);
			var title:String = str.slice(labelEnd + 2, pos).trim();
			if (title.length === 0) { return -1; }
			if (!env.abbreviations) { env.abbreviations = Object.create(null); }
			// prepend ':' to avoid conflict with Object.prototype members (not needed with Object.create(null))
			if (env.abbreviations[label] === undefined) {
				env.abbreviations[label] = title;
			}

			return pos;
		}

	}
}