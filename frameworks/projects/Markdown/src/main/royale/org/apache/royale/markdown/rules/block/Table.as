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
	public class Table extends Rule
	{
		private function Table()
		{
			
		}

		private static var _instance:Table;
		public static function get():Table
		{
			if(!_instance)
				_instance = new Table();
			
			return _instance;
		}

		private function getLine(state:BlockState, line:int):String
		{
			var pos:int = state.bMarks[line] + state.blkIndent;
			var max:int = state.eMarks[line];

			return state.src.substr(pos, max - pos);
		}

		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.BlockState
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{

			// var ch, lineText, pos, i, nextLine, rows, cell,
			// 		aligns, t, tableLines, tbodyLines;

			var state:BlockState = istate as BlockState;
			// should have at least three lines
			if (startLine + 2 > endLine) { return false; }

			var nextLine:int = startLine + 1;

			if (state.tShift[nextLine] < state.blkIndent) { return false; }

			// first character of the second line should be '|' or '-'

			var pos:int = state.bMarks[nextLine] + state.tShift[nextLine];
			if (pos >= state.eMarks[nextLine]) { return false; }

			var ch:Number = state.src.charCodeAt(pos);
			if (ch !== 0x7C/* | */ && ch !== 0x2D/* - */ && ch !== 0x3A/* : */) { return false; }

			var lineText:String = getLine(state, startLine + 1);
			if (!COLUMNS.test(lineText)) { return false; }

			var rows:Array = lineText.split('|');
			if (rows.length <= 2) { return false; }
			var aligns:Array = [];
			for (var i:int = 0; i < rows.length; i++) {
				var t:String = rows[i].trim();
				if (!t) {
					// allow empty columns before and after table, but not in between columns;
					// e.g. allow ` |---| `, disallow ` ---||--- `
					if (i === 0 || i === rows.length - 1) {
						continue;
					} else {
						return false;
					}
				}

				if (!ROWS.test(t)) { return false; }
				if (t.charCodeAt(t.length - 1) === 0x3A/* : */) {
					aligns.push(t.charCodeAt(0) === 0x3A/* : */ ? 'center' : 'right');
				} else if (t.charCodeAt(0) === 0x3A/* : */) {
					aligns.push('left');
				} else {
					aligns.push('');
				}
			}

			lineText = getLine(state, startLine).trim();
			if (lineText.indexOf('|') === -1) { return false; }
			rows = lineText.replace(ROWS_2, '').split('|');
			if (aligns.length !== rows.length) { return false; }
			if (silent) { return true; }
			var tableToken:BlockToken = new BlockToken('table_open','');
			tableToken.firstLine = startLine;// lastine set when we're done
			tableToken.level = state.level++;
			state.tokens.push(tableToken);
			// state.tokens.push({
			// 	type: 'table_open',
			// 	lines: tableLines = [ startLine, 0 ],
			// 	level: state.level++
			// });
			var token:BlockToken = new BlockToken('thead_open','');
			token.firstLine = startLine;
			token.lastLine = startLine + 1;
			token.level = state.level++;
			state.tokens.push(token);
			// state.tokens.push({
			// 	type: 'thead_open',
			// 	lines: [ startLine, startLine + 1 ],
			// 	level: state.level++
			// });
			token = new BlockToken('tr_open','');
			token.firstLine = startLine;
			token.lastLine = startLine + 1;
			token.level = state.level++;
			state.tokens.push(token);
			// state.tokens.push({
			// 	type: 'tr_open',
			// 	lines: [ startLine, startLine + 1 ],
			// 	level: state.level++
			// });
			
			for (i = 0; i < rows.length; i++) {
				token = new BlockToken('th_open','');
				token.data = aligns[i];
				token.firstLine = startLine;
				token.lastLine = startLine + 1;
				token.level = state.level++;
				state.tokens.push(token);

				// state.tokens.push({
				// 	type: 'th_open',
				// 	align: aligns[i],
				// 	lines: [ startLine, startLine + 1 ],
				// 	level: state.level++
				// });
				
				token = new BlockToken('inline',rows[i].trim());
				token.firstLine = startLine;
				token.lastLine = startLine + 1;
				token.level = state.level;
				state.tokens.push(token);
				// state.tokens.push({
				// 	type: 'inline',
				// 	content: rows[i].trim(),
				// 	lines: [ startLine, startLine + 1 ],
				// 	level: state.level,
				// 	children: []
				// });
				var tToken:TagToken = new TagToken('th_close');
				tToken.level = --state.level;
				state.tokens.push(tToken);
				// state.tokens.push({ type: 'th_close', level: --state.level });
			}
			tToken = new TagToken('tr_close');
			tToken.level = --state.level;
			state.tokens.push(tToken);
			// state.tokens.push({ type: 'tr_close', level: --state.level });
			
			tToken = new TagToken('thead_close');
			tToken.level = --state.level;
			state.tokens.push(tToken);
			// state.tokens.push({ type: 'thead_close', level: --state.level });

			var tBodyToken:BlockToken = new BlockToken('tbody_open','');
			tBodyToken.data = aligns[i];
			tBodyToken.firstLine = startLine + 2;
			tBodyToken.level = state.level++;
			state.tokens.push(tBodyToken);
			// state.tokens.push({
			// 	type: 'tbody_open',
			// 	lines: tbodyLines = [ startLine + 2, 0 ],
			// 	level: state.level++
			// });

			for (nextLine = startLine + 2; nextLine < endLine; nextLine++) {
				if (state.tShift[nextLine] < state.blkIndent) { break; }

				lineText = getLine(state, nextLine).trim();
				if (lineText.indexOf('|') === -1) { break; }
				rows = lineText.replace(ROWS_2, '').split('|');

				tToken = new TagToken('tr_open');
				tToken.level = state.level++;
				state.tokens.push(tToken);
				// state.tokens.push({ type: 'tr_open', level: state.level++ });
				for (i = 0; i < rows.length; i++) {
					tToken = new TagToken('td_open');
					tToken.data = aligns[i];
					tToken.level = state.level++;
					state.tokens.push(tToken);
					// state.tokens.push({ type: 'td_open', align: aligns[i], level: state.level++ });
					// 0x7c === '|'
					var cell:String = rows[i].substring(
							rows[i].charCodeAt(0) === 0x7c ? 1 : 0,
							rows[i].charCodeAt(rows[i].length - 1) === 0x7c ? rows[i].length - 1 : rows[i].length
					).trim();
					token = new BlockToken('inline',cell);
					token.level = state.level;
					state.tokens.push(token);
					// state.tokens.push({
					// 	type: 'inline',
					// 	content: cell,
					// 	level: state.level,
					// 	children: []
					// });
					tToken = new TagToken('td_close');
					tToken.level = --state.level;
					state.tokens.push(tToken);
					// state.tokens.push({ type: 'td_close', level: --state.level });
				}
				tToken = new TagToken('tr_close');
				tToken.level = --state.level;
				state.tokens.push(tToken);
				// state.tokens.push({ type: 'tr_close', level: --state.level });
			}
			tToken = new TagToken('tbody_close');
			tToken.level = --state.level;
			state.tokens.push(tToken);
			// state.tokens.push({ type: 'tbody_close', level: --state.level });
			tToken = new TagToken('table_close');
			tToken.level = --state.level;
			state.tokens.push(tToken);
			// state.tokens.push({ type: 'table_close', level: --state.level });
			tableToken.lastLine = tBodyToken.lastLine = nextLine;
			// tableLines[1] = tbodyLines[1] = nextLine;
			state.line = nextLine;
			return true;

		}
		private const COLUMNS:RegExp = /^[-:| ]+$/;
		private const ROWS:RegExp = /^:?-+:?$/;
		private const ROWS_2:RegExp = /^\||\|$/g;

	}
}