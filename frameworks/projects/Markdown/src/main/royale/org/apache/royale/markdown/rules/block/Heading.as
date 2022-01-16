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
	public class Heading extends Rule
	{
		private function Heading()
		{
			
		}

		private static var _instance:Heading;
		public static function get():Heading
		{
			if(!_instance)
				_instance = new Heading();
			
			return _instance;
		}

		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.BlockState
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{

			var state:BlockState = istate as BlockState
			var pos:int = state.bMarks[startLine] + state.tShift[startLine];
			var max:int = state.eMarks[startLine];

			if (pos >= max) { return false; }

			var ch:Number  = state.src.charCodeAt(pos);

			if (ch !== 0x23/* # */ || pos >= max) { return false; }

			// count heading level
			var level:int = 1;
			ch = state.src.charCodeAt(++pos);
			while (ch === 0x23/* # */ && pos < max && level <= 6) {
				level++;
				ch = state.src.charCodeAt(++pos);
			}

			if (level > 6 || (pos < max && ch !== 0x20/* space */)) { return false; }

			if (silent) { return true; }

			// Let's cut tails like '    ###  ' from the end of string

			max = state.skipCharsBack(max, 0x20, pos); // space
			var tmp:int = state.skipCharsBack(max, 0x23, pos); // #
			if (tmp > pos && state.src.charCodeAt(tmp - 1) === 0x20/* space */) {
				max = tmp;
			}

			state.line = startLine + 1;
			// var tToken:TagToken = new TagToken('heading_open');
			var token:BlockToken = new BlockToken('heading_open','');
			token.numValue = level;
			token.firstLine = startLine;
			token.lastLine = state.line;
			level = state.level;
			state.tokens.push(token);

			// state.tokens.push({ type: 'heading_open',
			// 	hLevel: level,
			// 	lines: [ startLine, state.line ],
			// 	level: state.level
			// });

			// only if header is not empty
			if (pos < max) {
				token = new BlockToken('inline',state.src.slice(pos, max).trim());
				token.level = state.level + 1;
				token.firstLine = startLine;
				token.lastLine = state.line;
				state.tokens.push(token);

				// state.tokens.push({
				// 	type: 'inline',
				// 	content: state.src.slice(pos, max).trim(),
				// 	level: state.level + 1,
				// 	lines: [ startLine, state.line ],
				// 	children: []
				// });
			}
			var tToken:TagToken = new TagToken('heading_close');
			tToken.numValue = level;
			tToken.level = state.level;
			state.tokens.push(tToken);
			// state.tokens.push({ type: 'heading_close', hLevel: level, level: state.level });

			return true;

		}
	
	}
}