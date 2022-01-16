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
	public class Backticks extends Rule
	{
		private function Backticks()
		{
			
		}

		private static var _instance:Backticks;
		public static function get():Backticks
		{
			if(!_instance)
				_instance = new Backticks();
			
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

			// var start, max, marker, matchStart, matchEnd,
			var state:InlineState = istate as InlineState;
			var pos:int = state.position;
			var ch:Number = state.src.charCodeAt(pos);

			if (ch !== 0x60/* ` */) { return false; }

			var start:int = pos;
			pos++;
			var max:int = state.posMax;

			while (pos < max && state.src.charCodeAt(pos) === 0x60/* ` */) { pos++; }

			var marker:String = state.src.slice(start, pos);
			var matchEnd:int
			var matchStart:int = matchEnd = pos;

			while ((matchStart = state.src.indexOf('`', matchEnd)) !== -1) {
				matchEnd = matchStart + 1;

				while (matchEnd < max && state.src.charCodeAt(matchEnd) === 0x60/* ` */) { matchEnd++; }

				if (matchEnd - matchStart === marker.length) {
					if (!silent) {
						var content:String = state.src.slice(pos, matchStart)
																	.replace(LINE_END, ' ')
																	.trim();
						var token:ContentToken = new ContentToken('code',content);
						token.level = state.level;
						state.push(token);
						// state.push({
						// 	type: 'code',
						// 	content: state.src.slice(pos, matchStart)
						// 											.replace(/[ \n]+/g, ' ')
						// 											.trim(),
						// 	block: false,
						// 	level: state.level
						// });
					}
					state.position = matchEnd;
					return true;
				}
			}

			if (!silent) { state.pending += marker; }
			state.position += marker.length;
			return true;

		}
		private const LINE_END:RegExp = /[ \n]+/g;
	}
}