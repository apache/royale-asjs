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
	public class Footnote_tail extends Rule
	{
		private function Footnote_tail()
		{
			
		}

		private static var _instance:Footnote_tail;
		public static function get():Footnote_tail
		{
			if(!_instance)
				_instance = new Footnote_tail();
			
			return _instance;
		}

		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.CoreState 
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{
			var state:CoreState = istate as CoreState;
			// var i, l, j, t, lastParagraph, list, tokens, current, currentLabel,
			var level:int = 0;
			var insideRef:Boolean = false;
			var refTokens:Object = {};

			if (!state.env.footnotes) { return false; }

			state.tokens = state.tokens.filter(function(tok:Token):Boolean {
				if (tok.type === 'footnote_reference_open') {
					insideRef = true;
					var current:Array = [];
					var currentLabel:String = tok.data;
					return false;
				}
				if (tok.type === 'footnote_reference_close') {
					insideRef = false;
					// prepend ':' to avoid conflict with Object.prototype members
					refTokens[currentLabel] = current;
					return false;
				}
				if (insideRef) { current.push(tok); }
				return !insideRef;
			});

			if (!state.env.footnotes.list) { return false; }
			var list:Array = state.env.footnotes.list;
			var token:IToken = new TagToken('footnote_block_open');
			token.level = level++;
			state.tokens.push(token);
			var len:int = list.length;
			for (var i:int = 0; i < len; i++) {
				token = new TagToken('footnote_open');
				token.id = i;
				token.level = level++;
				state.tokens.push(token);

				if (list[i].tokens) {
					var tokens:Vector.<IToken> = new Vector.<IToken>();
					token = new TagToken('paragraph_open');
					token.level = level++;
					tokens.push(token);
					var blockToken:BlockToken = new BlockToken('inline',"");
					blockToken.level = level;
					blockToken.children = list[i].tokens
					tokens.push(blockToken);
					token = new TagToken('paragraph_close');
					token.level = --level;
					tokens.push(token);
				} else if (list[i].label) {
					tokens = refTokens[list[i].label];
				}

				state.tokens = state.tokens.concat(tokens);
				if (state.tokens[state.tokens.length - 1].type === 'paragraph_close') {
					var lastParagraph:IToken = state.tokens.pop();
				} else {
					lastParagraph = null;
				}

				var t:int = list[i].count > 0 ? list[i].count : 1;
				for (var j:int = 0; j < t; j++) {
					token = new TagToken("footnote_anchor");
					token.id = i;
					token.subId = j;
					token.level = level;
					state.tokens.push(token);
				}

				if (lastParagraph) {
					state.tokens.push(lastParagraph);
				}
				token = new TagToken("footnote_close");
				token.level = --level;
				state.tokens.push(token);
			}
			token = new TagToken("footnote_block_close");
			token.level = --level;
			state.tokens.push(token);
			return true;
		}

	}
}