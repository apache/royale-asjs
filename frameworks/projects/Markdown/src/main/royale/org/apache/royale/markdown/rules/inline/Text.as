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
	public class Text extends Rule
	{
		private function Text()
		{
			
		}

		private static var _instance:Text;
		public static function get():Text
		{
			if(!_instance)
				_instance = new Text();
			
			return _instance;
		}

		/**
		 * Skip text characters for text token, place those to pending buffer and increment current pos
		 * Rule to skip pure text
		 * '{}$%@~+=:' reserved for extentions
		 */
		private function isTerminatorChar(ch:Number):Boolean
		{
			switch (ch) {
				case 0x0A/* \n */:
				case 0x5C/* \ */:
				case 0x60/* ` */:
				case 0x2A/* * */:
				case 0x5F/* _ */:
				case 0x5E/* ^ */:
				case 0x5B/* [ */:
				case 0x5D/* ] */:
				case 0x21/* ! */:
				case 0x26/* & */:
				case 0x3C/* < */:
				case 0x3E/* > */:
				case 0x7B/* { */:
				case 0x7D/* } */:
				case 0x24/* $ */:
				case 0x25/* % */:
				case 0x40/* @ */:
				case 0x7E/* ~ */:
				case 0x2B/* + */:
				case 0x3D/* = */:
				case 0x3A/* : */:
					return true;
				default:
					return false;
			}
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
			var pos:int = state.position;

			while (pos < state.posMax && !isTerminatorChar(state.src.charCodeAt(pos))) {
				pos++;
			}

			if (pos == state.position)
				return false;

			if (!silent)
				state.pending += state.src.slice(state.position, pos);

			state.position = pos;

			return true;

		}

	}
}