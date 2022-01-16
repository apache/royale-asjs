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
	public class CoreState implements IState
	{
		public function CoreState(parser:MarkdownParser,str:String,env:Environment)
		{
			this.src = str;
			this.env = env;
			this.options = parser.options;
			tokens = new Vector.<IToken>();
			this.inlineMode = false;

			inlineParser = parser.inlineParser;
			blockParser = parser.blockParser;
			// this.renderer = parser.renderer;
			// this.typographer = parser.typographer;
			
			rules = parser.rulesManager;
		}
		private var _tokens:Vector.<IToken>;

		public function get tokens():Vector.<IToken>
		{
			return _tokens;
		}

		public function set tokens(value:Vector.<IToken>):void
		{
			_tokens = value;
		}
		public var inlineParser:InlineParser;
		public var blockParser:BlockParser;
		public var rules:RulesManager;
		
		private var _options:MarkdownOptions;

		public function get options():MarkdownOptions
		{
			return _options;
		}

		public function set options(value:MarkdownOptions):void
		{
			_options = value;
		}
		public var inlineMode:Boolean;

		public var src:String;
		public var env:Environment;

	}
}