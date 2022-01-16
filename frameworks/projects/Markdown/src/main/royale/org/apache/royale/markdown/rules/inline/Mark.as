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
	/**
	 * Process ==highlighted text==
	 */
	public class Mark extends Rule
	{
		private function Mark()
		{
			
		}

		private static var _instance:Mark;
		public static function get():Mark
		{
			if(!_instance)
				_instance = new Mark();
			
			return _instance;
		}

		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.InlineState
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{

			// 		pos,
			// 		stack,
			var state:InlineState = istate as InlineState;
			var max:int = state.posMax;
			var start:int = state.position;
			var found:Boolean = false;
					// lastChar,
					// nextChar;

			if (state.src.charCodeAt(start) !== 0x3D/* = */) { return false; }
			if (silent) { return false; } // don't run any pairs in validation mode
			if (start + 4 >= max) { return false; }
			if (state.src.charCodeAt(start + 1) !== 0x3D/* = */) { return false; }
			if (state.level >= state.options.maxNesting) { return false; }

			var lastChar:Number = start > 0 ? state.src.charCodeAt(start - 1) : -1;
			var nextChar:Number = state.src.charCodeAt(start + 2);

			if (lastChar === 0x3D/* = */) { return false; }
			if (nextChar === 0x3D/* = */) { return false; }
			if (nextChar === 0x20 || nextChar === 0x0A) { return false; }

			var pos:int = start + 2;
			while (pos < max && state.src.charCodeAt(pos) === 0x3D/* = */) { pos++; }
			if (pos !== start + 2) {
				// sequence of 3+ markers taking as literal, same as in a emphasis
				state.position += pos - start;
				if (!silent) { state.pending += state.src.slice(start, pos); }
				return true;
			}

			state.position = start + 2;
			var stack:int = 1;

			while (state.position + 1 < max) {
				if (state.src.charCodeAt(state.position) === 0x3D/* = */) {
					if (state.src.charCodeAt(state.position + 1) === 0x3D/* = */) {
						lastChar = state.src.charCodeAt(state.position - 1);
						nextChar = state.position + 2 < max ? state.src.charCodeAt(state.position + 2) : -1;
						if (nextChar !== 0x3D/* = */ && lastChar !== 0x3D/* = */) {
							if (lastChar !== 0x20 && lastChar !== 0x0A) {
								// closing '=='
								stack--;
							} else if (nextChar !== 0x20 && nextChar !== 0x0A) {
								// opening '=='
								stack++;
							} // else {
								//  // standalone ' == ' indented with spaces
								// }
							if (stack <= 0) {
								found = true;
								break;
							}
						}
					}
				}

				state.parser.skipToken(state);
			}

			if (!found) {
				// parser failed to find ending tag, so it's not valid emphasis
				state.position = start;
				return false;
			}

			// found!
			state.posMax = state.position;
			state.position = start + 2;

			if (!silent) {
				state.push(new TagToken('mark_open',state.level++));
				// state.push({ type: 'mark_open', level: state.level++ });
				state.parser.tokenize(state);
				state.push(new TagToken('mark_close',--state.level));
				// state.push({ type: 'mark_close', level: --state.level });
			}

			state.position = state.posMax + 2;
			state.posMax = max;
			return true;

		}

	}
}