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
	public class Smartquotes extends Rule
	{
		private function Smartquotes()
		{
			
		}

		private static var _instance:Smartquotes;
		public static function get():Smartquotes
		{
			if(!_instance)
				_instance = new Smartquotes();
			
			return _instance;
		}

		private const QUOTE_TEST_RE:RegExp = /['"]/;
		private const QUOTE_RE:RegExp = /['"]/g;
		private const PUNCT_RE:RegExp = /[-\s()\[\]]/;
		private const APOSTROPHE:String = '’';

		// This function returns true if the character at `pos`
		// could be inside a word.
		private function isLetter(str:String, pos:int):Boolean
		{
			if (pos < 0 || pos >= str.length) { return false; }
			return !PUNCT_RE.test(str[pos]);
		}


		private function replaceAt(str:String, index:int, ch:String):String
		{
			return str.substr(0, index) + ch + str.substr(index + 1);
		}

		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.CoreState 
		 * @royaleignorecoercion org.apache.royale.markdown.ContentToken 
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{

			// var i, token, text, t, pos, max, thisLevel, lastSpace, nextSpace, item,
			// 		canOpen, canClose, j, isSingle, blkIdx, tokens,
			// 		stack;
			state = istate as CoreState;

			if (!state.options.typographer) { return false; }

			stack = [];

			for (var blkIdx:int = state.tokens.length - 1; blkIdx >= 0; blkIdx--) {

				if (state.tokens[blkIdx].type !== 'inline') { continue; }

				var tokens:Vector.<IToken> = (state.tokens[blkIdx] as BlockToken).children;
				stack.length = 0;

				for (var i:int = 0; i < tokens.length; i++) {
					var token:ContentToken = tokens[i] as ContentToken;

					if (token.type !== 'text' || QUOTE_TEST_RE.test(token.content)) { continue; }

					this.level = tokens[i].level;

					for (var j:int = stack.length - 1; j >= 0; j--) {
						if (stack[j].level <= this.level) { break; }
					}
					stack.length = j + 1;

					var text:String = token.content;
					var pos:int = 0;
					var max:int = text.length;

					while (pos < max) {
						QUOTE_RE.lastIndex = pos;
						var t:Object = QUOTE_RE.exec(text);
						if (!t) { break; }

						var lastSpace:Boolean = !isLetter(text, t.index - 1);
						pos = t.index + 1;
						var isSingle:Boolean = (t[0] === "'");
						var nextSpace:Boolean = !isLetter(text, pos);

						if (!nextSpace && !lastSpace) {
							// middle of word
							if (isSingle) {
								token.content = replaceAt(token.content, t.index, APOSTROPHE);
							}
							continue;
						}

						var canOpen:Boolean = !nextSpace;
						var canClose:Boolean = !lastSpace;

						if (canClose) {
							// this could be a closing quote, rewind the stack to get a match
							searchStack(token,tokens,t.index,isSingle);

						}

						if (canOpen) {
							stack.push(new StackRef(i,t.index,isSingle,this.level));
							// {
							// 	token: i,
							// 	pos: t.index,
							// 	single: isSingle,
							// 	level: thisLevel
							// });
						} else if (canClose && isSingle) {
							token.content = replaceAt(token.content, t.index, APOSTROPHE);
						}
					}
				}
			}
			return true;
		}
		private var stack:Array;
		private var level:int;
		private var state:CoreState;

		private function searchStack(token:ContentToken,tokens:Vector.<IToken>,index:int,isSingle:Boolean):void{
			for (var i:int = stack.length - 1; i >= 0; i--) {
				var item:StackRef = stack[i];
				if (stack[i].level < this.level) { break; }
				if (item.single === isSingle && stack[i].level === this.level) {
					item = stack[i];
					var stackToken:ContentToken = tokens[item.token] as ContentToken
					if (isSingle) {
						stackToken.content = replaceAt(stackToken.content, item.pos, state.options.quotes[2]);
						token.content = replaceAt(token.content, index, state.options.quotes[3]);
					} else {
						stackToken.content = replaceAt(stackToken.content, item.pos, state.options.quotes[0]);
						token.content = replaceAt(token.content, index, state.options.quotes[1]);
					}
					stack.length = i;
					return;
				}
			}

		}

	}
}
class StackRef
{
	public function StackRef(token:int,pos:int,single:Boolean,level:int)
	{
		this.token = token;
		this.pos = pos;
		this.single = single;
		this.level = level;		
	}

	public var token:int;
	public var pos:int;
	public var single:Boolean;
	public var level:int;

}