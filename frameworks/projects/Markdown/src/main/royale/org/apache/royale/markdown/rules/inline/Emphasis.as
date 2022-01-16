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
	 * Process *this* and _that_
	 */
	public class Emphasis extends Rule
	{
		private function Emphasis()
		{
			
		}

		private static var _instance:Emphasis;
		public static function get():Emphasis
		{
			if(!_instance)
				_instance = new Emphasis();
			
			return _instance;
		}

		private function isAlphaNum(code:Number):Boolean
		{
			return (code >= 0x30 /* 0 */ && code <= 0x39 /* 9 */) ||
						(code >= 0x41 /* A */ && code <= 0x5A /* Z */) ||
						(code >= 0x61 /* a */ && code <= 0x7A /* z */);
		}

		// parse sequence of emphasis markers,
		// "start" should point at a valid marker
		private function scanDelims(state:InlineState, start:int):DelimDetails
		{
			var pos:int = start;
			var canOpen:Boolean = true;
			var canClose:Boolean = true;
			var max:int = state.posMax;
			var marker:Number = state.src.charCodeAt(start);

			var lastChar:int = start > 0 ? state.src.charCodeAt(start - 1) : -1;

			while (pos < max && state.src.charCodeAt(pos) === marker) { pos++; }
			if (pos >= max) { canOpen = false; }
			var count:int = pos - start;

			if (count >= 4) {
				// sequence of four or more unescaped markers can't start/end an emphasis
				canOpen = canClose = false;
			} else {
				var nextChar:int = pos < max ? state.src.charCodeAt(pos) : -1;

				// check whitespace conditions
				if (nextChar === 0x20 || nextChar === 0x0A) { canOpen = false; }
				if (lastChar === 0x20 || lastChar === 0x0A) { canClose = false; }

				if (marker === 0x5F /* _ */) {
					// check if we aren't inside the word
					if (isAlphaNum(lastChar)) { canOpen = false; }
					if (isAlphaNum(nextChar)) { canClose = false; }
				}
			}

			return new DelimDetails(canOpen,canClose,count);
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
			var marker:Number = state.src.charCodeAt(start);
			var found:Boolean = false;

			if (marker !== 0x5F/* _ */ && marker !== 0x2A /* * */) { return false; }
			if (silent) { return false; } // don't run any pairs in validation mode

			var res:DelimDetails = scanDelims(state, start);
			var startCount:int = res.delims;
			if (!res.canOpen) {
				state.position += startCount;
				if (!silent) { state.pending += state.src.slice(start, state.position); }
				return true;
			}

			if (state.level >= state.options.maxNesting) { return false; }

			state.position = start + startCount;
			var stack:Array = [ startCount ];

			while (state.position < max)
			{
				if (state.src.charCodeAt(state.position) === marker)
				{
					res = scanDelims(state, state.position);
					var count:int = res.delims;
					if (res.canClose)
					{
						var oldCount:int = stack.pop();
						var newCount:int = count;

						while (oldCount !== newCount)
						{
							if (newCount < oldCount) {
								stack.push(oldCount - newCount);
								break;
							}

							// assert(newCount > oldCount)
							newCount -= oldCount;

							if (stack.length === 0) { break; }
							state.position += oldCount;
							oldCount = stack.pop();
						}

						if (stack.length === 0) {
							startCount = oldCount;
							found = true;
							break;
						}
						state.position += count;
						continue;
					}

					if (res.canOpen) { stack.push(count); }
					state.position += count;
					continue;
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
			state.position = start + startCount;

			if (!silent) {
				if (startCount === 2 || startCount === 3) {
					state.push(new TagToken('strong_open',state.level++));
					// state.push({ type: 'strong_open', level: state.level++ });
				}
				if (startCount === 1 || startCount === 3) {
					state.push(new TagToken('em_open',state.level++));
					// state.push({ type: 'em_open', level: state.level++ });
				}

				state.parser.tokenize(state);

				if (startCount === 1 || startCount === 3) {
					state.push(new TagToken('em_close',--state.level));
					// state.push({ type: 'em_close', level: --state.level });
				}
				if (startCount === 2 || startCount === 3) {
					state.push(new TagToken('strong_close',--state.level));
					// state.push({ type: 'strong_close', level: --state.level });
				}
			}

			state.position = state.posMax + startCount;
			state.posMax = max;
			return true;

		}

	}
}
class DelimDetails
{
	public function DelimDetails(canOpen:Boolean,canClose:Boolean,delims:int)
	{
		this.canOpen = canOpen;
		this.canClose = canClose;
		this.delims = delims;
	}
  public var canOpen:Boolean;
  public var canClose:Boolean;
  public var delims:int;

}