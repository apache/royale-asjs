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
	public class Paragraph extends Rule
	{
		private function Paragraph()
		{
			
		}

		private static var _instance:Paragraph;
		public static function get():Paragraph
		{
			if(!_instance)
				_instance = new Paragraph();
			
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

			// var endLine, content, terminate, i, l,
			// 		terminatorRules;
			var nextLine:int = startLine + 1;

			var state:BlockState = istate as BlockState;
			endLine = state.lineMax;

			// jump line-by-line until empty one or EOF
			if (nextLine < endLine && !state.isEmpty(nextLine)) {
				// terminatorRules = state.parser.ruler.getRules('paragraph');

				for (; nextLine < endLine && !state.isEmpty(nextLine); nextLine++) {
					// this would be a code block normally, but after paragraph
					// it's considered a lazy continuation regardless of what's there
					if (state.tShift[nextLine] - state.blkIndent > 3) { continue; }

					// Some tags can terminate paragraph without empty lines.
					if(state.parser.rules.runParagraphs(state,nextLine,endLine))
						break;
					// terminate = false;
					// for (i = 0, l = terminatorRules.length; i < l; i++) {
					// 	if (terminatorRules[i](state, nextLine, endLine, true)) {
					// 		terminate = true;
					// 		break;
					// 	}
					// }
					// if (terminate) { break; }
				}
			}

			var content:String = state.getLines(startLine, nextLine, state.blkIndent, false).trim();

			state.line = nextLine;
			if (content.length) {
				var token:BlockToken = new BlockToken('paragraph_open','');
				token.firstLine = startLine;
				token.lastLine = state.line;
				token.level = state.level;
				state.tokens.push(token);
				// state.tokens.push({
				// 	type: 'paragraph_open',
				// 	tight: false,
				// 	lines: [ startLine, state.line ],
				// 	level: state.level
				// });
				
				token = new BlockToken('inline',content);
				token.firstLine = startLine;
				token.lastLine = state.line;
				token.level = state.level + 1;
				state.tokens.push(token);
				// state.tokens.push({
				// 	type: 'inline',
				// 	content: content,
				// 	level: state.level + 1,
				// 	lines: [ startLine, state.line ],
				// 	children: []
				// });
				var tToken:TagToken = new TagToken('paragraph_close');
				tToken.level = state.level;
				state.tokens.push(tToken);
				// state.tokens.push({
				// 	type: 'paragraph_close',
				// 	tight: false,
				// 	level: state.level
				// });
			}

			return true;

		}
		
	}
}