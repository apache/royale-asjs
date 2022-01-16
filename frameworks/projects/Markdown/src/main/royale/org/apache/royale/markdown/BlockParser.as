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
	public class BlockParser implements IParser
	{
		public function BlockParser()
		{
		}

		public var rules:RulesManager;

		public function tokenize (state:BlockState, startLine:int, endLine:int):void {
			var line:int = startLine;
			var hasEmptyLines:Boolean = false;

			while (line < endLine) {
			  state.line = line = state.skipEmptyLines(line);
			  if (line >= endLine) {
			    break;
			  }

			  // Termination condition for nested calls.
			  // Nested calls currently used for blockquotes & lists
			  if (state.tShift[line] < state.blkIndent) {
			    break;
			  }

				// do we care?
				var success:Boolean = rules.runBlockRules(state,false,line,endLine);

			  // set state.tight if we had an empty line before current tag
			  // i.e. latest empty line should not count
			  state.tight = !hasEmptyLines;

			  // paragraph might "eat" one newline after it in nested lists
			  if (state.isEmpty(state.line - 1)) {
			    hasEmptyLines = true;
			  }

			  line = state.line;

			  if (line < endLine && state.isEmpty(line)) {
			    hasEmptyLines = true;
			    line++;

			    // two empty lines should stop the parser in list mode
			    if (line < endLine && state.parentType === 'list' && state.isEmpty(line)) { break; }
			    state.line = line;
			  }
			}
		}

		private var TABS_SCAN_RE:RegExp = /[\n\t]/g;
		private var NEWLINES_RE:RegExp  = /\r[\n\u0085]|[\u2424\u2028\u0085]/g;
		private var SPACES_RE:RegExp    = /\u00a0/g;

		public function parse(str:String, options:MarkdownOptions, env:Environment, outTokens:Vector.<IToken>):void {
			// var state,
			var lineStart:int = 0
			var lastTabPos:int = 0;
			if (!str) { return; }

			// Normalize spaces
			str = str.replace(SPACES_RE, ' ');

			// Normalize newlines
			str = str.replace(NEWLINES_RE, '\n');

			// Replace tabs with proper number of spaces (1..4)
			if (str.indexOf('\t') >= 0) {
				str = str.replace(TABS_SCAN_RE, function (match:String, offset:int):String{
					var result:String;
					if (str.charCodeAt(offset) === 0x0A) {
						lineStart = offset + 1;
						lastTabPos = 0;
						return match;
					}
					result = '    '.slice((offset - lineStart - lastTabPos) % 4);
					lastTabPos = offset - lineStart + 1;
					return result;
				});
			}
			
			rules = env.rules;
			
			var state:BlockState = new BlockState(str, this, options, env, outTokens);
			this.tokenize(state, state.line, state.lineMax);
		}

	}
}