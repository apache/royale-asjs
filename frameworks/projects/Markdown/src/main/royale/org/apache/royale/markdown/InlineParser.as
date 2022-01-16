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
	public class InlineParser implements IParser
	{
		public function InlineParser()
		{
			
		}
		
		public var rules:RulesManager;

		/**
		 * Skip a single token by running all rules in validation mode.
		 *
		 */
		public function skipToken (state:InlineState):void
		{
			var pos:int = state.position;
			var cachedPos:int = state.cacheGet(pos);
			if (cachedPos > 0) {
				state.position = cachedPos;
				return;
			}
			// when on silent, the cache is set if a rule is found
			if(rules.runInlineRules(state,true,pos))
				return;

			state.position++;
			state.cacheSet(pos, state.position);
		}

		/**
		 * Generate tokens for the given input range.
		 *
		 */

		public function tokenize (state:InlineState):void{
			var end:int = state.posMax;

			while (state.position < end) {

				// run all the rules.
				var success:Boolean = rules.runInlineRules(state,true,0);
				if (success) {
					if (state.position >= end) { break; }
					continue;
				}

				state.pending += state.src[state.position++];
			}

			if (state.pending) {
				state.pushPending();
			}
		}

		/**
		 * Parse the given input string.
		 *
		 */

		public function parse (str:String, options:MarkdownOptions, env:Environment, tokens:Vector.<IToken>):void{
			rules = env.rules;
			var state:InlineState = new InlineState(str, this, options, env, tokens);
			this.tokenize(state);
		}

	}
}