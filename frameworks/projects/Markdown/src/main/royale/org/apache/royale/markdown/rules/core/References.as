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
	import org.apache.royale.markdown.helpers.wrappedInParagraph;
	import org.apache.royale.markdown.helpers.parseLinkLabel;
	import org.apache.royale.markdown.helpers.parseLinkDestination;
	import org.apache.royale.markdown.helpers.parseLinkTitle;
	import org.apache.royale.markdown.helpers.normalizeReference;
	import org.apache.royale.markdown.helpers.HRef;

	public class References extends Rule
	{
		private function References()
		{
			
		}

		private static var _instance:References;
		public static function get():References
		{
			if(!_instance)
				_instance = new References();
			
			return _instance;
		}

		/**
		 * parses the rule
		 * @langversion 3.0
		 * @productversion Royale 0.9.9
		 * @royaleignorecoercion org.apache.royale.markdown.ContentToken 
		 * @royaleignorecoercion org.apache.royale.markdown.CoreState 
		 */
		override public function parse(istate:IState, silent:Boolean = false, startLine:int = -1, endLine:int = -1):Boolean
		{
      var state:CoreState = istate as CoreState;
      var tokens:Vector.<IToken> = state.tokens;//, i, l, content, pos;

      if(!state.env.references)
        state.env.references = Object.create(null);

      if (state.inlineMode) {
        return false;
      }

      // Scan definitions in paragraph inlines
      var len:int = tokens.length - 1;
      for (var i:int = 1; i < len; i++) {
        var token:ContentToken = tokens[i] as ContentToken;
        var last:IToken = tokens[i - 1];
        var next:IToken = tokens[i + 1];
        if(wrappedInParagraph(last,token,next))
        {
          var content:String = token.content;
          while (content.length) {
            var pos:int = parseReference(content, state.inlineParser, state.options, state.env);
            if (pos < 0) { break; }
            content = content.slice(pos).trim();
          }

          token.content = content;
          if (!content.length) {
            last.tight = true;
            next.tight = true;
          }
        }
      }
      return true;
		}

    public function parseReference(str:String, parser:InlineParser, options:MarkdownOptions, env:Environment):int
    {
      // var state, labelEnd, pos, max, code, start, href, title, label;

      if (str.charCodeAt(0) !== 0x5B/* [ */) { return -1; }

      if (str.indexOf(']:') === -1) { return -1; }

      var state:InlineState = new InlineState(str, parser, options, env, new Vector.<IToken>);
      var labelEnd:int = parseLinkLabel(state, 0);

      if (labelEnd < 0 || str.charCodeAt(labelEnd + 1) !== 0x3A/* : */) { return -1; }

      var max:int = state.posMax;

      // [label]:   destination   'title'
      //         ^^^ skip optional whitespace here
      for (var pos:int = labelEnd + 2; pos < max; pos++) {
        var code:Number = state.src.charCodeAt(pos);
        if (code !== 0x20 && code !== 0x0A) { break; }
      }

      // [label]:   destination   'title'
      //            ^^^^^^^^^^^ parse this
      if (!parseLinkDestination(state, pos)) { return -1; }
      var href:String = state.linkContent;
      pos = state.position;

      // [label]:   destination   'title'
      //                       ^^^ skipping those spaces
      var start:int = pos;
      for (pos = pos + 1; pos < max; pos++) {
        code = state.src.charCodeAt(pos);
        if (code !== 0x20 && code !== 0x0A) { break; }
      }

      // [label]:   destination   'title'
      //                          ^^^^^^^ parse this
      if (pos < max && start !== pos && parseLinkTitle(state, pos)) {
        var title:String = state.linkContent;
        pos = state.position;
      } else {
        title = '';
        pos = start;
      }

      // ensure that the end of the line is empty
      while (pos < max && state.src.charCodeAt(pos) === 0x20/* space */) { pos++; }
      if (pos < max && state.src.charCodeAt(pos) !== 0x0A) { return -1; }

      var label:String = normalizeReference(str.slice(1, labelEnd));
      if (env.references[label] === undefined) {
        env.references[label] = new HRef(href,title);
      }

      return pos;
    }

	}
}