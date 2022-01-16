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
	public class Htmlblock extends Rule
	{
		private function Htmlblock()
		{
			
		}

		private static var _instance:Htmlblock;
		public static function get():Htmlblock
		{
			if(!_instance)
				_instance = new Htmlblock();
			
			return _instance;
		}

		private const HTML_TAG_OPEN_RE:RegExp = /^<([a-zA-Z]{1,15})[\s\/>]/;
		private const HTML_TAG_CLOSE_RE:RegExp = /^<\/([a-zA-Z]{1,15})[\s>]/;

		private function isLetter(ch:Number):Boolean
		{
			/*eslint no-bitwise:0*/
			var lc:Number = ch | 0x20; // to lower case
			return (lc >= 0x61/* a */) && (lc <= 0x7a/* z */);
		}


		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.BlockState
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{

			// var ch, match, nextLine,
			var state:BlockState = istate as BlockState;
			var pos:int = state.bMarks[startLine];
			var max:int = state.eMarks[startLine];
			var shift:int = state.tShift[startLine];

			pos += shift;

			if (!state.options.html) { return false; }

			if (shift > 3 || pos + 2 >= max) { return false; }

			if (state.src.charCodeAt(pos) !== 0x3C/* < */) { return false; }

			var ch:Number = state.src.charCodeAt(pos + 1);

			if (ch === 0x21/* ! */ || ch === 0x3F/* ? */) {
				// Directive start / comment start / processing instruction start
				if (silent) { return true; }

			} else if (ch === 0x2F/* / */ || isLetter(ch)) {

				// Probably start or end of tag
				if (ch === 0x2F/* \ */) {
					// closing tag
					var match:Array = state.src.slice(pos, max).match(HTML_TAG_CLOSE_RE);
					if (!match) { return false; }
				} else {
					// opening tag
					match = state.src.slice(pos, max).match(HTML_TAG_OPEN_RE);
					if (!match) { return false; }
				}
				// Make sure tag name is valid
				if (!htmlBlocks[match[1].toLowerCase()]) { return false; }
				if (silent) { return true; }

			} else {
				return false;
			}

			// If we are here - we detected HTML block.
			// Let's roll down till empty line (block end).
			var nextLine:int = startLine + 1;
			while (nextLine < state.lineMax && !state.isEmpty(nextLine)) {
				nextLine++;
			}

			state.line = nextLine;
			var token:BlockToken = new BlockToken('htmlblock',state.getLines(startLine, nextLine, 0, true));
			token.level = state.level;
			token.firstLine = startLine;
			token.lastLine = state.line;
			state.tokens.push(token);

			// state.tokens.push({
			// 	type: 'htmlblock',
			// 	level: state.level,
			// 	lines: [ startLine, state.line ],
			// 	content: state.getLines(startLine, nextLine, 0, true)
			// });

			return true;

		}

		private const htmlBlocks:Object = {
  		'article':1,
  		'aside':1,
  		'button':1,
  		'blockquote':1,
  		'body':1,
  		'canvas':1,
  		'caption':1,
  		'col':1,
  		'colgroup':1,
  		'dd':1,
  		'div':1,
  		'dl':1,
  		'dt':1,
  		'embed':1,
  		'fieldset':1,
  		'figcaption':1,
  		'figure':1,
  		'footer':1,
  		'form':1,
  		'h1':1,
  		'h2':1,
  		'h3':1,
  		'h4':1,
  		'h5':1,
  		'h6':1,
  		'header':1,
  		'hgroup':1,
  		'hr':1,
  		'iframe':1,
  		'li':1,
  		'map':1,
  		'object':1,
  		'ol':1,
  		'output':1,
  		'p':1,
  		'pre':1,
  		'progress':1,
  		'script':1,
  		'section':1,
  		'style':1,
  		'table':1,
  		'tbody':1,
  		'td':1,
  		'textarea':1,
  		'tfoot':1,
  		'th':1,
  		'tr':1,
  		'thead':1,
  		'ul':1,
  		'video':1
		};	
	}
}