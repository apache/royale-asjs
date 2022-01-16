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
	public class Hr extends Rule
	{
		private function Hr()
		{
			
		}

		private static var _instance:Hr;
		public static function get():Hr
		{
			if(!_instance)
				_instance = new Hr();
			
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

			// var marker, cnt, ch,
			var state:BlockState = istate as BlockState;
			var pos:int = state.bMarks[startLine];
			var max:int = state.eMarks[startLine];

			pos += state.tShift[startLine];

			if (pos > max) { return false; }

			var marker:Number = state.src.charCodeAt(pos++);

			// Check hr marker
			if (marker !== 0x2A/* * */ &&
					marker !== 0x2D/* - */ &&
					marker !== 0x5F/* _ */) {
				return false;
			}

			// markers can be mixed with spaces, but there should be at least 3 one

			var cnt:int = 1;
			while (pos < max) {
				var ch:Number = state.src.charCodeAt(pos++);
				if (ch !== marker && ch !== 0x20/* space */) { return false; }
				if (ch === marker) { cnt++; }
			}

			if (cnt < 3) { return false; }

			if (silent) { return true; }

			state.line = startLine + 1;
			var token:BlockToken = new BlockToken('hr','');
			token.firstLine = startLine;
			token.lastLine = state.line;
			token.level = state.level;
			state.tokens.push(token);
			// state.tokens.push({
			// 	type: 'hr',
			// 	lines: [ startLine, state.line ],
			// 	level: state.level
			// });

			return true;

		}
		
	}
}