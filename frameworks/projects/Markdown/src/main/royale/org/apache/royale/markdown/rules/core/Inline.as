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
	public class Inline extends Rule
	{
		private function Inline()
		{
			
		}

		private static var _instance:Inline;
		public static function get():Inline
		{
			if(!_instance)
				_instance = new Inline();
			
			return _instance;
		}


		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9 
		 * @royaleignorecoercion org.apache.royale.markdown.BlockToken 
		 * @royaleignorecoercion org.apache.royale.markdown.CoreState 
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{
			var state:CoreState = istate as CoreState;
  		var tokens:Vector.<IToken> = state.tokens;

			// Parse inlines
			var len:int = tokens.length;
			for (var i:int = 0; i < len; i++) {
				var token:BlockToken = tokens[i] as BlockToken;
				if (token.type === 'inline') {
					state.inlineParser.parse(token.content, state.options, state.env, token.children);
				}
			}
			return true;
		}

	}
}