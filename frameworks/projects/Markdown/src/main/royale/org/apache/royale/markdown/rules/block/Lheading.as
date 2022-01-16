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
	public class Lheading extends Rule
	{
		private function Lheading()
		{
			
		}

		private static var _instance:Lheading;
		public static function get():Lheading
		{
			if(!_instance)
				_instance = new Lheading();
			
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

			// var marker, pos, max,
			var state:BlockState = istate as BlockState;
			var next:int = startLine + 1;

			if (next >= endLine) { return false; }
			if (state.tShift[next] < state.blkIndent) { return false; }

			// Scan next line

			if (state.tShift[next] - state.blkIndent > 3) { return false; }

			var pos:int = state.bMarks[next] + state.tShift[next];
			var max:int = state.eMarks[next];

			if (pos >= max) { return false; }

			var marker:Number = state.src.charCodeAt(pos);

			if (marker !== 0x2D/* - */ && marker !== 0x3D/* = */) { return false; }

			pos = state.skipChars(pos, marker);

			pos = state.skipSpaces(pos);

			if (pos < max) { return false; }

			pos = state.bMarks[startLine] + state.tShift[startLine];

			state.line = next + 1;
			var token:BlockToken = new BlockToken('heading_open','');
			token.numValue = marker === 0x3D/* = */ ? 1 : 2;
			token.firstLine = startLine;
			token.lastLine = state.line;
			token.level = state.level;
			state.tokens.push(token);
			// state.tokens.push({
			// 	type: 'heading_open',
			// 	hLevel: marker === 0x3D/* = */ ? 1 : 2,
			// 	lines: [ startLine, state.line ],
			// 	level: state.level
			// });
			token = new BlockToken('inline',state.src.slice(pos, state.eMarks[startLine]).trim());
			token.level = state.level + 1;
			token.firstLine = startLine;
			token.lastLine = state.line -1;
			state.tokens.push(token);
			// state.tokens.push({
			// 	type: 'inline',
			// 	content: state.src.slice(pos, state.eMarks[startLine]).trim(),
			// 	level: state.level + 1,
			// 	lines: [ startLine, state.line - 1 ],
			// 	children: []
			// });
			var tToken:TagToken = new TagToken('heading_close');
			tToken.numValue = marker === 0x3D/* = */ ? 1 : 2;
			tToken.level = state.level;
			// state.tokens.push({
			// 	type: 'heading_close',
			// 	hLevel: marker === 0x3D/* = */ ? 1 : 2,
			// 	level: state.level
			// });

			return true;


		}
				
	}
}