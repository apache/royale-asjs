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
	public class Deflist extends Rule
	{
		private function Deflist()
		{
			
		}

		private static var _instance:Deflist;
		public static function get():Deflist
		{
			if(!_instance)
				_instance = new Deflist();
			
			return _instance;
		}

		// Search `[:~][\n ]`, returns next pos after marker on success
		// or -1 on fail.
		private function skipMarker(state:BlockState, line:int):int
		{
			var start:int = state.bMarks[line] + state.tShift[line];
			var max:int = state.eMarks[line];

			if (start >= max) { return -1; }

			// Check bullet
			var marker:Number = state.src.charCodeAt(start++);
			if (marker !== 0x7E/* ~ */ && marker !== 0x3A/* : */) { return -1; }

			var pos:int = state.skipSpaces(start);

			// require space after ":"
			if (start === pos) { return -1; }

			// no empty definitions, e.g. "  : "
			if (pos >= max) { return -1; }

			return pos;
		}

		private function markTightParagraphs(state:BlockState, idx:int):void
		{
			// var i, l,
			var level:int = state.level + 2;
			var len:int = state.tokens.length - 2;
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

  // var contentStart,
  //     ddLine,
  //     dtLine,
  //     itemLines,
  //     listLines,
  //     listTokIdx,
  //     nextLine,
  //     oldIndent,
  //     oldDDIndent,
  //     oldParentType,
  //     oldTShift,
  //     oldTight,
  //     prevEmptyEnd,
  //     tight;

			var state:BlockState = istate as BlockState;
			if (silent) {
				// quirk: validation mode validates a dd block only, not a whole deflist
				if (state.ddIndent < 0) { return false; }
				return skipMarker(state, startLine) >= 0;
			}

			nextLine = startLine + 1;
			if (state.isEmpty(nextLine)) {
				if (++nextLine > endLine) { return false; }
			}

			if (state.tShift[nextLine] < state.blkIndent) { return false; }
			var contentStart:int = skipMarker(state, nextLine);
			if (contentStart < 0) { return false; }

			if (state.level >= state.options.maxNesting) { return false; }

			// Start list
			var listTokIdx:int = state.tokens.length;

			var token:BlockToken = new BlockToken('dl_open','');
			token.firstLine = startLine;
			token.level = state.level++;
			state.tokens.push(token);
			// state.tokens.push({
			// 	type: 'dl_open',
			// 	lines: listLines = [ startLine, 0 ],
			// 	level: state.level++
			// });

			//
			// Iterate list items
			//

			this.startLine = startLine;
			this.endLine = endLine;

			loopDT(state,contentStart);

			// Finalize list
			token.lastLine = nextLine;
			// listLines[1] = nextLine;
			var tToken:TagToken = new TagToken('dl_close');
			tToken.level = --state.level;
			state.tokens.push(tToken);
			// state.tokens.push({
			// 	type: 'dl_close',
			// 	level: --state.level
			// });

			state.line = nextLine;

			// mark paragraphs tight if needed
			if (tight) {
				markTightParagraphs(state, listTokIdx);
			}

			return true;

		}
		private var nextLine:int;
		private var startLine:int;
		private var endLine:int;
		private var tight:Boolean;
		private function loopDT(state:BlockState,contentStart:int):void
		{
			var dtLine:int = startLine;
			var ddLine:int = nextLine;

			// One definition list can contain multiple DTs,
			// and one DT can be followed by multiple DDs.
			//
			// Thus, there is two loops here.
			//
			for (;;) {
				tight = true;
				var prevEmptyEnd:Boolean = false;
				var token:BlockToken = new BlockToken('dt_open','');
				token.firstLine = dtLine;
				token.lastLine = dtLine;
				token.level = state.level++;
				state.tokens.push(token);
				// state.tokens.push({
				// 	type: 'dt_open',
				// 	lines: [ dtLine, dtLine ],
				// 	level: state.level++
				// });

				token = new BlockToken('inline',state.getLines(dtLine, dtLine + 1, state.blkIndent, false).trim());
				token.firstLine = dtLine;
				token.lastLine = dtLine;
				token.level = state.level + 1;
				state.tokens.push(token);
				// state.tokens.push({
				// 	type: 'inline',
				// 	content: state.getLines(dtLine, dtLine + 1, state.blkIndent, false).trim(),
				// 	level: state.level + 1,
				// 	lines: [ dtLine, dtLine ],
				// 	children: []
				// });
				var tToken:TagToken = new TagToken('dt_close');
				tToken.level = --state.level;
				state.tokens.push(tToken);
				// state.tokens.push({
				// 	type: 'dt_close',
				// 	level: --state.level
				// });

				for (;;) {
					var lineToken:BlockToken = new BlockToken('dd_open','');
					lineToken.firstLine = nextLine;
					lineToken.level = state.level++;
					state.tokens.push(lineToken);
					// state.tokens.push({
					// 	type: 'dd_open',
					// 	lines: itemLines = [ nextLine, 0 ],
					// 	level: state.level++
					// });

					var oldTight:Boolean = state.tight;
					var oldDDIndent:int = state.ddIndent;
					var oldIndent:int = state.blkIndent;
					var oldTShift:int = state.tShift[ddLine];
					var oldParentType:String = state.parentType;
					state.blkIndent = state.ddIndent = state.tShift[ddLine] + 2;
					state.tShift[ddLine] = contentStart - state.bMarks[ddLine];
					state.tight = true;
					state.parentType = 'deflist';

					state.parser.tokenize(state, ddLine, endLine);// had, true....

					// If any of list item is tight, mark list as tight
					if (!state.tight || prevEmptyEnd) {
						tight = false;
					}
					// Item become loose if finish with empty line,
					// but we should filter last element, because it means list finish
					prevEmptyEnd = (state.line - ddLine) > 1 && state.isEmpty(state.line - 1);

					state.tShift[ddLine] = oldTShift;
					state.tight = oldTight;
					state.parentType = oldParentType;
					state.blkIndent = oldIndent;
					state.ddIndent = oldDDIndent;

					tToken = new TagToken('dd_close');
					tToken.level = --state.level;
					state.tokens.push(tToken);
					// state.tokens.push({
					// 	type: 'dd_close',
					// 	level: --state.level
					// });

					lineToken.lastLine = nextLine = state.line;

					if (nextLine >= endLine)
					{
						return;
					}

					if (state.tShift[nextLine] < state.blkIndent)
					{
						return;
					}

					contentStart = skipMarker(state, nextLine);
					if (contentStart < 0) { break; }

					ddLine = nextLine;

					// go to the next loop iteration:
					// insert DD tag and repeat checking
				}

				if (nextLine >= endLine) { break; }
				dtLine = nextLine;

				if (state.isEmpty(dtLine)) { break; }
				if (state.tShift[dtLine] < state.blkIndent) { break; }

				ddLine = dtLine + 1;
				if (ddLine >= endLine) { break; }
				if (state.isEmpty(ddLine)) { ddLine++; }
				if (ddLine >= endLine) { break; }

				if (state.tShift[ddLine] < state.blkIndent) { break; }
				contentStart = skipMarker(state, ddLine);
				if (contentStart < 0) { break; }

				// go to the next loop iteration:
				// insert DT and DD tags and repeat checking
			}

		}

	}
}