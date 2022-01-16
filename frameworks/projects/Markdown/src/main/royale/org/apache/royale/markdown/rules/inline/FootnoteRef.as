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
	 * Process footnote references ([^...])
	 */
	public class FootnoteRef extends Rule
	{
		private function FootnoteRef()
		{
			
		}

		private static var _instance:FootnoteRef;
		public static function get():FootnoteRef
		{
			if(!_instance)
				_instance = new FootnoteRef();
			
			return _instance;
		}

		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9		 * 
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{
			var state:InlineState = istate as InlineState;
			var max:int = state.posMax;
			var start:int = state.position;

			// should be at least 4 chars - "[^x]"
			if (start + 3 > max) { return false; }

			if (!state.env.footnotes || !state.env.footnotes.refs) { return false; }
			if (state.src.charCodeAt(start) !== 0x5B/* [ */) { return false; }
			if (state.src.charCodeAt(start + 1) !== 0x5E/* ^ */) { return false; }
			if (state.level >= state.options.maxNesting) { return false; }

			for (var pos:int = start + 2; pos < max; pos++) {
				if (state.src.charCodeAt(pos) === 0x20) { return false; }
				if (state.src.charCodeAt(pos) === 0x0A) { return false; }
				if (state.src.charCodeAt(pos) === 0x5D /* ] */) {
					break;
				}
			}

			if (pos === start + 2) { return false; } // no empty footnote labels
			if (pos >= max) { return false; }
			pos++;

			var label:String = state.src.slice(start + 2, pos - 1);
			if (typeof state.env.footnotes.refs[':' + label] === 'undefined') { return false; }

			if (!silent) {
				if (!state.env.footnotes.list) { state.env.footnotes.list = []; }

				if (state.env.footnotes.refs[':' + label] < 0) {
					var footnoteId:int = state.env.footnotes.list.length;
					state.env.footnotes.list[footnoteId] = { label: label, count: 0 };
					state.env.footnotes.refs[':' + label] = footnoteId;
				} else {
					footnoteId = state.env.footnotes.refs[':' + label];
				}

				var footnoteSubId:int = state.env.footnotes.list[footnoteId].count;
				state.env.footnotes.list[footnoteId].count++;
				var token:TagToken = new TagToken('footnote_ref',state.level);
				token.id = footnoteId;
				token.subId = footnoteSubId;
				state.push(token);
				// state.push({
				// 	type: 'footnote_ref',
				// 	id: footnoteId,
				// 	subId: footnoteSubId,
				// 	level: state.level
				// });
			}

			state.position = pos;
			state.posMax = max;
			return true;

		}

	}
}