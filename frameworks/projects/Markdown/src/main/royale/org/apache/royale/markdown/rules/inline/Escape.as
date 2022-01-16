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
	public class Escape extends Rule
	{
		private function Escape()
		{
			ESCAPED = [];
			// for (var i:int = 0; i < 256; i++)
			// 	ESCAPED.push(0);

			'\\!"#$%&\'()*+,./:;<=>?@[]^_`{|}~-'
  		.split('').forEach(function(ch:String):void { ESCAPED[ch.charCodeAt(0)] = 1; });
			
		}

		private static var _instance:Escape;
		public static function get():Escape
		{
			if(!_instance)
				_instance = new Escape();
			
			return _instance;
		}
// Proceess escaped chars and hardbreaks

		private var ESCAPED:Array;


		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.InlineState
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{

			// var ch
			var state:InlineState = istate as InlineState;
			var pos:int = state.position;
			var max:int = state.posMax;

			if (state.src.charCodeAt(pos) !== 0x5C/* \ */) { return false; }

			pos++;

			if (pos < max) {
				var ch:Number = state.src.charCodeAt(pos);

				if (ch < 256 && ESCAPED[ch]) {
					if (!silent) { state.pending += state.src[pos]; }
					state.position += 2;
					return true;
				}

				if (ch == 0x0A) {
					if (!silent) {
						state.push(new TagToken('hardbreak',state.level));
						// state.push({
						// 	type: 'hardbreak',
						// 	level: state.level
						// });
					}

					pos++;
					// skip leading whitespaces from next line
					while (pos < max && state.src.charCodeAt(pos) === 0x20)
						pos++;

					state.position = pos;
					return true;
				}
			}

			if (!silent) { state.pending += '\\'; }
			state.position++;
			return true;

		}

	}
}