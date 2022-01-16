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
	public class BlockState implements IState
	{
		public function BlockState(str:String, parser:BlockParser, options:MarkdownOptions, env:Environment, tokens:Vector.<IToken>)
		{
			this.src = src;

			// Shortcuts to simplify nested calls
			this.parser = parser;

			this.options = options;

			this.env = env;
		  
			this.tokens = tokens;

			bMarks = [];  // line begin offsets for fast jumps
			eMarks = [];  // line end offsets for fast jumps
			tShift = [];  // indent for each line

			// Create caches
			// Generate markers.
			var s:String = this.src;
			var indent:int = 0;
			var indentFound:Boolean = false;
			var start:int,pos:int,len:int;
			for (start = pos = indent = 0, len = s.length; pos < len; pos++) {
				var ch:Number = s.charCodeAt(pos);

				if (!indentFound) {
					if (ch === 0x20/* space */) {
						indent++;
						continue;
					} else {
						indentFound = true;
					}
				}

				if (ch === 0x0A || pos === len - 1) {
					if (ch !== 0x0A) { pos++; }
					this.bMarks.push(start);
					this.eMarks.push(pos);
					this.tShift.push(indent);

					indentFound = false;
					indent = 0;
					start = pos + 1;
				}
			}

			// Push fake entry to simplify cache bounds checks
			this.bMarks.push(s.length);
			this.eMarks.push(s.length);
			this.tShift.push(0);

			this.lineMax = this.bMarks.length - 1; // don't count last fake line

		}

		public var src:String;
		public var parser:BlockParser;
		private var _options:MarkdownOptions;

		public function get options():MarkdownOptions
		{
			return _options;
		}

		public function set options(value:MarkdownOptions):void
		{
			_options = value;
		}
		public var env:Environment;

		public var bMarks:Array;
		public var eMarks:Array;
		public var tShift:Array;
		/**
		 * required block content indent (for example, if we are in list)
		 */
		public var blkIndent:int = 0;
  
		public var line:int = 0; // line index in src
		public var lineMax:int = 0; // lines count
		public var tight:Boolean = false; // loose/tight mode for lists
		public var parentType:String = 'root'; // if `list`, block parser stops on two newlines
		public var ddIndent:int = -1; // indent of the current dd block (-1 if there isn't any)
		public var level:int = 0;
		/**
		 * renderer var do we need?
		 */
		private var result:String = '';
		private var _tokens:Vector.<IToken>;

		public function get tokens():Vector.<IToken>
		{
			return _tokens;
		}

		public function set tokens(value:Vector.<IToken>):void
		{
			_tokens = value;
		}

		public function isEmpty(line:int):Boolean {
			return this.bMarks[line] + this.tShift[line] >= this.eMarks[line];
		}

		public function skipEmptyLines(from:int):int {
			for (var max:int = lineMax; from < max; from++) {
				if (bMarks[from] + tShift[from] < eMarks[from]) {
					break;
				}
			}
			return from;
		}

		// Skip spaces from given position.
		public function skipSpaces(pos:int):int {
			for (var max:int = this.src.length; pos < max; pos++) {
				if (this.src.charCodeAt(pos) !== 0x20/* space */) { break; }
			}
			return pos;
		}

		// Skip char codes from given position
		public function skipChars(pos:int, code:Number):int {
			for (var max:int = src.length; pos < max; pos++) {
				if (src.charCodeAt(pos) !== code) { break; }
			}
			return pos;
		}

		// Skip char codes reverse from given position - 1
		public function skipCharsBack(pos:int, code:Number, min:int):int {
			if (pos <= min) { return pos; }

			while (pos > min) {
				if (code !== src.charCodeAt(--pos)) { return pos + 1; }
			}
			return pos;
		}

		// cut lines range from source.
		public function getLines(begin:int, end:int, indent:Number, keepLastLF:Boolean):String {
			
			var i:int
			var first:Number
			var last:Number;
			var queue:Array
			var shift:Number;

			line = begin;

			if (begin >= end) {
				return '';
			}

			// Opt: don't use push queue for single line;
			if (line + 1 === end) {
				first = this.bMarks[line] + Math.min(this.tShift[line], indent);
				last = keepLastLF ? this.eMarks[line] + 1 : this.eMarks[line];
				return this.src.slice(first, last);
			}

			queue = new Array(end - begin);

			for (i = 0; line < end; line++, i++) {
				shift = this.tShift[line];
				if (shift > indent) { shift = indent; }
				if (shift < 0) { shift = 0; }

				first = this.bMarks[line] + shift;

				if (line + 1 < end || keepLastLF) {
					// No need for bounds check because we have fake entry on tail.
					last = this.eMarks[line] + 1;
				} else {
					last = this.eMarks[line];
				}

				queue[i] = this.src.slice(first, last);
			}

			return queue.join('');
		}

	}
}