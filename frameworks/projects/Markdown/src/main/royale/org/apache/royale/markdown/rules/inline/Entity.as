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
	 * Process html entity - &#123;, &#xAF;, &quot;, ...
	 */
	public class Entity extends Rule
	{
		private function Entity()
		{
			
		}

		private static var _instance:Entity;
		public static function get():Entity
		{
			if(!_instance)
				_instance = new Entity();
			
			return _instance;
		}

		private var DIGITAL_RE:RegExp = /^&#((?:x[a-f0-9]{1,8}|[0-9]{1,8}));/i;
		private var NAMED_RE:RegExp   = /^&([a-z][a-z0-9]{1,31});/i;

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
			var max:int = state.posMax;

			if (state.src.charCodeAt(pos) !== 0x26/* & */) { return false; }

			if (pos + 1 < max) {
				var ch:Number = state.src.charCodeAt(pos + 1);

				if (ch === 0x23 /* # */) {
					var match:Array = state.src.slice(pos).match(DIGITAL_RE);
					if (match) {
						if (!silent) {
							var code:int = match[1][0].toLowerCase() === 'x' ? parseInt(match[1].slice(1), 16) : parseInt(match[1], 10);
							state.pending += isValidEntityCode(code) ? fromCodePoint(code) : fromCodePoint(0xFFFD);
						}
						state.position += match[0].length;
						return true;
					}
				} else {
					match = state.src.slice(pos).match(NAMED_RE);
					if (match) {
						var decoded:String = decodeEntity(match[1]);
						if (match[1] !== decoded) {
							if (!silent) { state.pending += decoded; }
							state.position += match[0].length;
							return true;
						}
					}
				}
			}

			if (!silent) { state.pending += '&'; }
			state.position++;
			return true;
			
		}

		private function isValidEntityCode(c:int):Boolean
		{
			/*eslint no-bitwise:0*/
			// broken sequence
			if (c >= 0xD800 && c <= 0xDFFF) { return false; }
			// never used
			if (c >= 0xFDD0 && c <= 0xFDEF) { return false; }
			if ((c & 0xFFFF) === 0xFFFF || (c & 0xFFFF) === 0xFFFE) { return false; }
			// control codes
			if (c >= 0x00 && c <= 0x08) { return false; }
			if (c === 0x0B) { return false; }
			if (c >= 0x0E && c <= 0x1F) { return false; }
			if (c >= 0x7F && c <= 0x9F) { return false; }
			// out of range
			if (c > 0x10FFFF) { return false; }
			return true;
		}
		private function fromCodePoint(c:int):String
		{
			/*eslint no-bitwise:0*/
			if (c > 0xffff) {
				c -= 0x10000;
				var surrogate1:int = 0xd800 + (c >> 10),
						surrogate2:int = 0xdc00 + (c & 0x3ff);

				return String.fromCharCode(surrogate1, surrogate2);
			}
			return String.fromCharCode(c);
		}
	}
}