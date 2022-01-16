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
	public class Newline extends Rule
	{
		private function Newline()
		{
			
		}

		private static var _instance:Newline;
		public static function get():Newline
		{
			if(!_instance)
				_instance = new Newline();
			
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
			var pos:int = state.position;

			if (state.src.charCodeAt(pos) !== 0x0A/* \n */)
				return false;

			var pmax:int = state.pending.length - 1;
			var max:int = state.posMax;

			// '  \n' -> hardbreak
			// Lookup in pending chars is bad practice! Don't copy to other rules!
			// Pending string is stored in concat mode, indexed lookups will cause
			// convertion to flat mode.
			if (!silent)
			{
				if (pmax >= 0 && state.pending.charCodeAt(pmax) === 0x20)
				{
					if (pmax >= 1 && state.pending.charCodeAt(pmax - 1) === 0x20)
					{
						// Strip out all trailing spaces on this line.
						for (var i:int = pmax - 2; i >= 0; i--)
						{
							if (state.pending.charCodeAt(i) !== 0x20) {
								state.pending = state.pending.substring(0, i + 1);
								break;
							}
						}
						state.push(new TagToken('hardbreak',state.level));
						// state.push({
						// 	type: 'hardbreak',
						// 	level: state.level
						// });
					} else {
						state.pending = state.pending.slice(0, -1);
						state.push(new TagToken('softbreak',state.level));
						// state.push({
						// 	type: 'softbreak',
						// 	level: state.level
						// });
					}

				} else {
					state.push(new TagToken('softbreak',state.level));
					// state.push({
					// 	type: 'softbreak',
					// 	level: state.level
					// });
				}
			}

			pos++;

			// skip heading spaces for next line
			while (pos < max && state.src.charCodeAt(pos) === 0x20)
				pos++;

			state.position = pos;
			return true;

		}

	}
}