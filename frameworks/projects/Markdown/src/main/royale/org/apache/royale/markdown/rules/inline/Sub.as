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
	/**
	 * Process ~subscript~
	 */
	public class Sub extends Rule
	{
		private function Sub()
		{
			
		}

		private static var _instance:Sub;
		public static function get():Sub
		{
			if(!_instance)
				_instance = new Sub();
			
			return _instance;
		}
		// same as UNESCAPE_MD_RE plus a space
		private const UNESCAPE_RE:RegExp = /\\([ \\!"#$%&'()*+,.\/:;<=>?@[\]^_`{|}~-])/g;
		private const UNESCAPED_SPACE:RegExp = /(^|[^\\])(\\\\)*\s/;

		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.InlineState
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{

	var state:InlineState = istate as InlineState;
	var max:int = state.posMax;
	var start:int = state.position;
	var found:Boolean = false;

  if (state.src.charCodeAt(start) !== 0x7E/* ~ */) { return false; }
  if (silent) { return false; } // don't run any pairs in validation mode
  if (start + 2 >= max) { return false; }
  if (state.level >= state.options.maxNesting) { return false; }

  state.position = start + 1;

  while (state.position < max) {
    if (state.src.charCodeAt(state.position) === 0x7E/* ~ */) {
      found = true;
      break;
    }

    state.parser.skipToken(state);
  }

  if (!found || start + 1 === state.position) {
    state.position = start;
    return false;
  }

  var content:String = state.src.slice(start + 1, state.position);

  // don't allow unescaped spaces/newlines inside
  if (content.match(UNESCAPED_SPACE)) {
    state.position = start;
    return false;
  }

  // found!
  state.posMax = state.position;
  state.position = start + 1;

  if (!silent) {
		state.push(new ContentToken('sub',content.replace(UNESCAPE_RE, '$1'),state.level));
    // state.push({
    //   type: 'sub',
    //   level: state.level,
    //   content: content.replace(UNESCAPE_RE, '$1')
    // });
  }

  state.position = state.posMax + 1;
  state.posMax = max;
  return true;


		}

	}
}