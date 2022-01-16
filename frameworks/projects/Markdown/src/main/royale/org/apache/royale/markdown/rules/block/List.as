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
	public class List extends Rule
	{
		private function List()
		{
			
		}

		private static var _instance:List;
		public static function get():List
		{
			if(!_instance)
				_instance = new List();
			
			return _instance;
		}

		/**
		 * Search `[-+*][\n ]`, returns next pos arter marker on success or -1 on fail.
		 */
		public function skipBulletListMarker(state:BlockState, startLine:int):int{

			var pos:int = state.bMarks[startLine] + state.tShift[startLine];
			var max:int = state.eMarks[startLine];

			if (pos >= max) { return -1; }

			var marker:Number = state.src.charCodeAt(pos++);
			// Check bullet
			if (marker !== 0x2A/* * */ &&
					marker !== 0x2D/* - */ &&
					marker !== 0x2B/* + */) {
				return -1;
			}

			if (pos < max && state.src.charCodeAt(pos) !== 0x20) {
				// " 1.test " - is not a list item
				return -1;
			}

			return pos;
		}

		/**
		 * Search `\d+[.)][\n ]`, returns next pos arter marker on success or -1 on fail.
		 */
		public function skipOrderedListMarker(state:BlockState, startLine:int):int
		{
			var pos:int = state.bMarks[startLine] + state.tShift[startLine];
			var max:int = state.eMarks[startLine];

			if (pos + 1 >= max) { return -1; }

			var ch:Number = state.src.charCodeAt(pos++);

			if (ch < 0x30/* 0 */ || ch > 0x39/* 9 */) { return -1; }

			for (;;) {
				// EOL -> fail
				if (pos >= max) { return -1; }

				ch = state.src.charCodeAt(pos++);

				if (ch >= 0x30/* 0 */ && ch <= 0x39/* 9 */) {
					continue;
				}

				// found valid marker
				if (ch === 0x29/* ) */ || ch === 0x2e/* . */) {
					break;
				}

				return -1;
			}


			if (pos < max && state.src.charCodeAt(pos) !== 0x20/* space */) {
				// " 1.test " - is not a list item
				return -1;
			}
			return pos;
		}

		public function markTightParagraphs(state:BlockState, idx:int):void
		{
			var level:int = state.level + 2;

			var len:int = state.tokens.length - 2
			for (var i:int = idx + 2; i < len; i++) {
				if (state.tokens[i].level === level && state.tokens[i].type === 'paragraph_open') {
					state.tokens[i + 2].tight = true;
					state.tokens[i].tight = true;
					i += 2;
				}
			}
		}


		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.BlockState
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{

			var state:BlockState = istate as BlockState;
			var tight:Boolean = true;

			// Detect list type and position after marker
			var posAfterMarker:int = skipOrderedListMarker(state, startLine)
			if (posAfterMarker >= 0) {
				var isOrdered:Boolean = true;
			} else if ((posAfterMarker = skipBulletListMarker(state, startLine)) >= 0) {
				isOrdered = false;
			} else {
				return false;
			}

			if (state.level >= state.options.maxNesting) { return false; }

			// We should terminate list on style change. Remember first one to compare.
			var markerCharCode:Number = state.src.charCodeAt(posAfterMarker - 1);

			// For validation mode we can terminate immediately
			if (silent) { return true; }

			// Start list
			var listTokIdx:int = state.tokens.length;

			if (isOrdered) {
				var start:int = state.bMarks[startLine] + state.tShift[startLine];
				var markerValue:Number = Number(state.src.substr(start, posAfterMarker - start - 1));
				var openToken:BlockToken = new BlockToken('ordered_list_open','');
				openToken.numValue = markerValue;
				// state.tokens.push({
				// 	type: 'ordered_list_open',
				// 	order: markerValue,
				// 	lines: listLines = [ startLine, 0 ],
				// 	level: state.level++
				// });

			} else {
				openToken = new BlockToken('bullet_list_open','');
				// state.tokens.push({
				// 	type: 'bullet_list_open',
				// 	lines: listLines = [ startLine, 0 ],
				// 	level: state.level++
				// });
			}
			openToken.firstLine = startLine;
			openToken.level = state.level++;
			state.tokens.push(openToken);

			//
			// Iterate list items
			//

			var nextLine:int = startLine;
			var prevEmptyEnd:Boolean = false;
			// terminatorRules = state.parser.ruler.getRules('list');

			while (nextLine < endLine) {
				var contentStart:int = state.skipSpaces(posAfterMarker);
				var max:int = state.eMarks[nextLine];

				if (contentStart >= max) {
					// trimming space in "-    \n  3" case, indent is 1 here
					var indentAfterMarker:int = 1;
				} else {
					indentAfterMarker = contentStart - posAfterMarker;
				}

				// If we have more than 4 spaces, the indent is 1
				// (the rest is just indented code block)
				if (indentAfterMarker > 4) { indentAfterMarker = 1; }

				// If indent is less than 1, assume that it's one, example:
				//  "-\n  test"
				if (indentAfterMarker < 1) { indentAfterMarker = 1; }

				// "  -  test"
				//  ^^^^^ - calculating total length of this thing
				var indent:int = (posAfterMarker - state.bMarks[nextLine]) + indentAfterMarker;

				// Run subparser & write tokens
				var itemToken:BlockToken = new BlockToken("list_item_open",'');
				itemToken.firstLine = startLine;
				itemToken.level = state.level++;
				state.tokens.push(itemToken);
				// state.tokens.push({
				// 	type: 'list_item_open',
				// 	lines: itemLines = [ startLine, 0 ],
				// 	level: state.level++
				// });

				var oldIndent:int = state.blkIndent;
				var oldTight:Boolean = state.tight;
				var oldTShift:int = state.tShift[startLine];
				var oldParentType:String = state.parentType;
				state.tShift[startLine] = contentStart - state.bMarks[startLine];
				state.blkIndent = indent;
				state.tight = true;
				state.parentType = 'list';

				state.parser.tokenize(state, startLine, endLine);//had true??

				// If any of list item is tight, mark list as tight
				if (!state.tight || prevEmptyEnd) {
					tight = false;
				}
				// Item become loose if finish with empty line,
				// but we should filter last element, because it means list finish
				prevEmptyEnd = (state.line - startLine) > 1 && state.isEmpty(state.line - 1);

				state.blkIndent = oldIndent;
				state.tShift[startLine] = oldTShift;
				state.tight = oldTight;
				state.parentType = oldParentType;
				var tagToken:TagToken = new TagToken('list_item_close');
				tagToken.level = --state.level;
				state.tokens.push(tagToken);
				// state.tokens.push({
				// 	type: 'list_item_close',
				// 	level: --state.level
				// });

				nextLine = startLine = state.line;
				itemToken.lastLine = nextLine;
				contentStart = state.bMarks[startLine];

				if (nextLine >= endLine) { break; }

				if (state.isEmpty(nextLine)) {
					break;
				}

				//
				// Try to check if list is terminated or continued.
				//
				if (state.tShift[nextLine] < state.blkIndent) { break; }

				if(state.parser.rules.runLists(state,nextLine,endLine))
					break;
				// fail if terminating block found
				// terminate = false;
				// for (i = 0, l = terminatorRules.length; i < l; i++) {
				// 	if (terminatorRules[i](state, nextLine, endLine, true)) {
				// 		terminate = true;
				// 		break;
				// 	}
				// }
				// if (terminate) { break; }

				// fail if list has another type
				if (isOrdered) {
					posAfterMarker = skipOrderedListMarker(state, nextLine);
					if (posAfterMarker < 0) { break; }
				} else {
					posAfterMarker = skipBulletListMarker(state, nextLine);
					if (posAfterMarker < 0) { break; }
				}

				if (markerCharCode !== state.src.charCodeAt(posAfterMarker - 1)) { break; }
			}

			// Finilize list
			state.tokens.push({
				type: isOrdered ? 'ordered_list_close' : 'bullet_list_close',
				level: --state.level
			});
			openToken.lastLine = nextLine;

			state.line = nextLine;

			// mark paragraphs tight if needed
			if (tight) {
				markTightParagraphs(state, listTokIdx);
			}

			return true;

		}
		
	}
}