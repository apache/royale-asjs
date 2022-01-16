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
	public class BlockQuote extends Rule
	{
		private function BlockQuote()
		{
			
		}

		private static var _instance:BlockQuote;
		public static function get():BlockQuote
		{
			if(!_instance)
				_instance = new BlockQuote();
			
			return _instance;
		}

		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 *  
		 */
		override public function parse(iState:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{
			var state:BlockState = iState as BlockState;
			// var nextLine, lastLineEmpty, oldTShift, oldBMarks, oldIndent, oldParentType, lines,
			// 		terminatorRules,
			// 		i, l, terminate;
			var pos:int = state.bMarks[startLine] + state.tShift[startLine];
			var max:int = state.eMarks[startLine];

			if (pos > max) { return false; }

			// check the block quote marker
			if (state.src.charCodeAt(pos++) !== 0x3E/* > */) { return false; }

			if (state.level >= state.options.maxNesting) { return false; }

			// we know that it's going to be a valid blockquote,
			// so no point trying to find the end of it in silent mode
			if (silent) { return true; }

			// skip one optional space after '>'
			if (state.src.charCodeAt(pos) === 0x20) { pos++; }

			var oldIndent:int = state.blkIndent;
			state.blkIndent = 0;

			var oldBMarks:Array = [ state.bMarks[startLine] ];
			state.bMarks[startLine] = pos;

			// check if we have an empty blockquote
			pos = pos < max ? state.skipSpaces(pos) : pos;
			var lastLineEmpty:Boolean = pos >= max;

			var oldTShift:Array = [ state.tShift[startLine] ];
			state.tShift[startLine] = pos - state.bMarks[startLine];

			// terminatorRules = state.parser.ruler.getRules('blockquote');

			// Search the end of the block
			//
			// Block ends with either:
			//  1. an empty line outside:
			//     ```
			//     > test
			//
			//     ```
			//  2. an empty line inside:
			//     ```
			//     >
			//     test
			//     ```
			//  3. another tag
			//     ```
			//     > test
			//      - - -
			//     ```
			for (var nextLine:int = startLine + 1; nextLine < endLine; nextLine++) {
				pos = state.bMarks[nextLine] + state.tShift[nextLine];
				max = state.eMarks[nextLine];

				if (pos >= max) {
					// Case 1: line is not inside the blockquote, and this line is empty.
					break;
				}

				if (state.src.charCodeAt(pos++) === 0x3E/* > */) {
					// This line is inside the blockquote.

					// skip one optional space after '>'
					if (state.src.charCodeAt(pos) === 0x20) { pos++; }

					oldBMarks.push(state.bMarks[nextLine]);
					state.bMarks[nextLine] = pos;

					pos = pos < max ? state.skipSpaces(pos) : pos;
					lastLineEmpty = pos >= max;

					oldTShift.push(state.tShift[nextLine]);
					state.tShift[nextLine] = pos - state.bMarks[nextLine];
					continue;
				}

				// Case 2: line is not inside the blockquote, and the last line was empty.
				if (lastLineEmpty) { break; }

				// Case 3: another tag found.
				if(state.parser.rules.runBlockquotes(state,nextLine,endLine))
					break;
				
				// terminate = false;
				// for (i = 0, l = terminatorRules.length; i < l; i++) {
				// 	if (terminatorRules[i](state, nextLine, endLine, true)) {
				// 		terminate = true;
				// 		break;
				// 	}
				// }
				// if (terminate) { break; }

				oldBMarks.push(state.bMarks[nextLine]);
				oldTShift.push(state.tShift[nextLine]);

				// A negative number means that this is a paragraph continuation;
				//
				// Any negative number will do the job here, but it's better for it
				// to be large enough to make any bugs obvious.
				state.tShift[nextLine] = -1337;
			}

			var oldParentType:String = state.parentType;
			state.parentType = 'blockquote';
			//TODO why does blockquote_open have lines?
			var token:BlockToken = new BlockToken('blockquote_open','');
			token.firstLine = startLine;
			//set further down when the tag is closed
			// token.lastLine = 0;
			token.level = state.level++;
			state.tokens.push(token);
			// state.tokens.push({
			// 	type: 'blockquote_open',
			// 	lines: lines = [ startLine, 0 ],
			// 	level: state.level++
			// });
			state.parser.tokenize(state, startLine, nextLine);
			var closeToken:TagToken = new TagToken('blockquote_close');
			closeToken.level = --state.level;
			state.tokens.push(closeToken);
			// state.tokens.push({
			// 	type: 'blockquote_close',
			// 	level: --state.level
			// });
			state.parentType = oldParentType;
			token.lastLine = state.line;
			// lines[1] = state.line;

			// Restore original tShift; this might not be necessary since the parser
			// has already been here, but just to make sure we can do that.
			for (var i:int = 0; i < oldTShift.length; i++) {
				state.bMarks[i + startLine] = oldBMarks[i];
				state.tShift[i + startLine] = oldTShift[i];
			}
			state.blkIndent = oldIndent;

			return true;
		}

	}
}