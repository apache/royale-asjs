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
	public class Fences extends Rule
	{
		private function Fences()
		{
			
		}

		private static var _instance:Fences;
		public static function get():Fences
		{
			if(!_instance)
				_instance = new Fences();
			
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

  // var marker, len, params, nextLine, mem,
    	var state:BlockState = istate as BlockState;
			var haveEndMarker:Boolean = false;
      var pos:int = state.bMarks[startLine] + state.tShift[startLine];
      var max:int = state.eMarks[startLine];

			if (pos + 3 > max) { return false; }

			var marker:Number = state.src.charCodeAt(pos);

			if (marker !== 0x7E/* ~ */ && marker !== 0x60 /* ` */) {
				return false;
			}

			// scan marker length
			var mem:int = pos;
			pos = state.skipChars(pos, marker);

			var len:int = pos - mem;

			if (len < 3) { return false; }

			var params:String = state.src.slice(pos, max).trim();

			if (params.indexOf('`') >= 0) { return false; }

			// Since start is found, we can report success here in validation mode
			if (silent) { return true; }

			// search end of block
			var nextLine:int = startLine;

			// break out of endless loop when we hit the end
			for (;;) {
				nextLine++;
				if (nextLine >= endLine) {
					// unclosed block should be autoclosed by end of document.
					// also block seems to be autoclosed by end of parent
					break;
				}

				pos = mem = state.bMarks[nextLine] + state.tShift[nextLine];
				max = state.eMarks[nextLine];

				if (pos < max && state.tShift[nextLine] < state.blkIndent) {
					// non-empty line with negative indent should stop the list:
					// - ```
					//  test
					break;
				}

				if (state.src.charCodeAt(pos) !== marker) { continue; }

				if (state.tShift[nextLine] - state.blkIndent >= 4) {
					// closing fence should be indented less than 4 spaces
					continue;
				}

				pos = state.skipChars(pos, marker);

				// closing code fence must be at least as long as the opening one
				if (pos - mem < len) { continue; }

				// make sure tail has spaces only
				pos = state.skipSpaces(pos);

				if (pos < max) { continue; }

				haveEndMarker = true;
				// found!
				break;
			}

			// If a fence has heading spaces, they should be removed from its inner block
			len = state.tShift[startLine];

			state.line = nextLine + (haveEndMarker ? 1 : 0);
			var token:BlockToken = new BlockToken('fence',state.getLines(startLine + 1, nextLine, len, true));
			// for fences we're using the data property for the fence params
			token.data = params;
			token.firstLine = startLine;
			token.lastLine = state.line;
			token.level = state.level;
			state.tokens.push(token);
			// state.tokens.push({
			// 	type: 'fence',
			// 	params: params,
			// 	content: state.getLines(startLine + 1, nextLine, len, true),
			// 	lines: [ startLine, state.line ],
			// 	level: state.level
			// });

			return true;

			
		}
		
	}
}