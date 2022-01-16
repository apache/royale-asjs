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
	 * Process ++inserted text++
	 */
	public class Ins extends Rule
	{
		private function Ins()
		{
			
		}

		private static var _instance:Ins;
		public static function get():Ins
		{
			if(!_instance)
				_instance = new Ins();
			
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
			var state:InlineState = istate as InlineState;
			var max:int = state.posMax;
			var start:int = state.position;
			var found:Boolean = false;

			if (state.src.charCodeAt(start) !== 0x2B/* + */) { return false; }
			if (silent) { return false; } // don't run any pairs in validation mode
			if (start + 4 >= max) { return false; }
			if (state.src.charCodeAt(start + 1) !== 0x2B/* + */) { return false; }
			if (state.level >= state.options.maxNesting) { return false; }

			var lastChar:Number = start > 0 ? state.src.charCodeAt(start - 1) : -1;
			var nextChar:Number = state.src.charCodeAt(start + 2);

			if (lastChar === 0x2B/* + */) { return false; }
			if (nextChar === 0x2B/* + */) { return false; }
			if (nextChar === 0x20 || nextChar === 0x0A) { return false; }

			var pos:int = start + 2;
			while (pos < max && state.src.charCodeAt(pos) === 0x2B/* + */) { pos++; }
			if (pos !== start + 2) {
				// sequence of 3+ markers taking as literal, same as in a emphasis
				state.position += pos - start;
				if (!silent) { state.pending += state.src.slice(start, pos); }
				return true;
			}

			state.position = start + 2;
			var stack:int = 1;

			while (state.position + 1 < max) {
				if (state.src.charCodeAt(state.position) === 0x2B/* + */)
				{
					if (state.src.charCodeAt(state.position + 1) === 0x2B/* + */)
					{
						lastChar = state.src.charCodeAt(state.position - 1);
						nextChar = state.position + 2 < max ? state.src.charCodeAt(state.position + 2) : -1;
						if (nextChar !== 0x2B/* + */ && lastChar !== 0x2B/* + */)
						{
							if (lastChar !== 0x20 && lastChar !== 0x0A)
							{
								// closing '++'
								stack--;
							} else if (nextChar !== 0x20 && nextChar !== 0x0A) {
								// opening '++'
								stack++;
							} // else {
								//  // standalone ' ++ ' indented with spaces
								// }
							if (stack <= 0)
							{
								found = true;
								break;
							}
						}
					}
				}

				state.parser.skipToken(state);
			}

			if (!found)
			{
				// parser failed to find ending tag, so it's not valid emphasis
				state.position = start;
				return false;
			}

			// found!
			state.posMax = state.position;
			state.position = start + 2;

			if (!silent)
			{
				state.push(new TagToken('ins_open',state.level++));
				// state.push({ type: 'ins_open', level: state.level++ });
				state.parser.tokenize(state);
				state.push(new TagToken('ins_close',--state.level));
				// state.push({ type: 'ins_close', level: --state.level });
			}

			state.position = state.posMax + 2;
			state.posMax = max;
			return true;


		}

	}
}