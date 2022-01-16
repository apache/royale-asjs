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
	import org.apache.royale.markdown.helpers.parseLinkLabel;
	/**
	 * Process inline footnotes (^[...])
	 */
	public class InlineFootnote extends Rule
	{
		private function InlineFootnote()
		{
			
		}

		private static var _instance:InlineFootnote;
		public static function get():InlineFootnote
		{
			if(!_instance)
				_instance = new InlineFootnote();
			
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

			// var labelStart,
			// 		labelEnd,
			// 		footnoteId,
			// 		oldLength,
			var state:InlineState = istate as InlineState;
			var max:int = state.posMax;
			var start:int = state.position;

			if (start + 2 >= max) { return false; }
			if (state.src.charCodeAt(start) !== 0x5E/* ^ */) { return false; }
			if (state.src.charCodeAt(start + 1) !== 0x5B/* [ */) { return false; }
			if (state.level >= state.options.maxNesting) { return false; }

			var labelStart:int = start + 2;
			var labelEnd:int = parseLinkLabel(state, start + 1);

			// parser failed to find ']', so it's not a valid note
			if (labelEnd < 0) { return false; }

			// We found the end of the link, and know for a fact it's a valid link;
			// so all that's left to do is to call tokenizer.
			//
			if (!silent) {
				if (!state.env.footnotes) { state.env.footnotes = {}; }
				if (!state.env.footnotes.list) { state.env.footnotes.list = []; }
				var footnoteId:int = state.env.footnotes.list.length;

				state.position = labelStart;
				state.posMax = labelEnd;
				var token:TagToken = new TagToken('footnote_ref',state.level);
				token.id = footnoteId;
				state.push(token);
				// state.push({
				// 	type: 'footnote_ref',
				// 	id: footnoteId,
				// 	level: state.level
				// });
				state.linkLevel++;
				var oldLength:int = state.tokens.length;
				state.parser.tokenize(state);
				state.env.footnotes.list[footnoteId] = { tokens: state.tokens.splice(oldLength) };
				state.linkLevel--;
			}

			state.position = labelEnd + 1;
			state.posMax = max;
			return true;

		}

	}
}