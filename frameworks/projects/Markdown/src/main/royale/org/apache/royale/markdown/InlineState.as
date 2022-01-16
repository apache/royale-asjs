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
	public class InlineState implements IState
	{
		// str, this, options, env, outTokens
		public function InlineState(src:String, parser:InlineParser, options:MarkdownOptions, env:Environment, tokens:Vector.<IToken>)
		{

			src = src;
			env = env;
			this.options = options;
			this.parser = parser;
			this.tokens = tokens;
			posMax = src.length;
			// Stores { start: end } pairs. Useful for backtrack
			// optimization of pairs parse (emphasis, strikes).
			cache = new Vector.<int>();
		}

		public var src:String;
		public var env:Environment;
		private var _options:MarkdownOptions;

		public function get options():MarkdownOptions
		{
			return _options;
		}

		public function set options(value:MarkdownOptions):void
		{
			_options = value;
		}
		public var parser:InlineParser;
		private var _tokens:Vector.<IToken>;

		public function get tokens():Vector.<IToken>
		{
			return _tokens;
		}

		public function set tokens(value:Vector.<IToken>):void
		{
			_tokens = value;
		}
		public var position:int = 0;
		public var posMax:int;
		public var level:int = 0;
		public var pending:String = "";
		public var pendingLevel:int = 0;
		public var cache:Vector.<int>;
		
		/**
		 * Set true when seek link label - we should disable "paired" rules
		 * (emphasis, strikes) to not skip tailing `]`
		 */
		public var isInLabel:Boolean = false;
		public var linkLevel:int = 0;// Increment for each nesting link. Used to prevent nesting in definitions
		public var linkContent:String = ""; // Temporary storage for link url
		public var labelUnmatchedScopes:int = 0;// Track unpaired `[` for link labels (backtrack optimization)

		// Flush pending text
		//
		public function pushPending():void{
			var token:ContentToken = new ContentToken("text",pending);
			token.level = pendingLevel;
			tokens.push(token);
			pending = '';
		}

		// Push new token to "stream".
		// If pending text exists - flush it as text token
		//
		public function push(token:IToken):void{
			if (this.pending) {
				this.pushPending();
			}

			this.tokens.push(token);
			this.pendingLevel = this.level;
		}

		// Store value to cache.
		public function cacheSet(key:int, val:int):void{
			for (var i:int = this.cache.length; i <= key; i++) {
				this.cache.push(0);
			}

			this.cache[key] = val;
		}

		// Get cache value
		//
		public function cacheGet(key:int):int {
			return key < this.cache.length ? this.cache[key] : 0;
		}

	}
}