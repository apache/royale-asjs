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
	import org.apache.royale.markdown.helpers.parseLinkLabel;
	import org.apache.royale.markdown.helpers.parseLinkDestination;
	import org.apache.royale.markdown.helpers.parseLinkTitle;
	import org.apache.royale.markdown.helpers.normalizeReference;
	import org.apache.royale.markdown.helpers.HRef;

	public class Links extends Rule
	{
		private function Links()
		{
			
		}

		private static var _instance:Links;
		public static function get():Links
		{
			if(!_instance)
				_instance = new Links();
			
			return _instance;
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
			var isImage:Boolean = false;
			var oldPos:int = state.position;
			var max:int = state.posMax;
			var start:int = state.position;
			var marker:Number = state.src.charCodeAt(start);

			if (marker === 0x21/* ! */)
			{
				isImage = true;
				marker = state.src.charCodeAt(++start);
			}

			if (marker !== 0x5B/* [ */) { return false; }
			if (state.level >= state.options.maxNesting) { return false; }

			var labelStart:int = start + 1;
			var labelEnd:int = parseLinkLabel(state, start);

			// parser failed to find ']', so it's not a valid link
			if (labelEnd < 0) { return false; }

			var pos:int = labelEnd + 1;
			if (pos < max && state.src.charCodeAt(pos) === 0x28/* ( */)
			{
				//
				// Inline link
				//

				// [link](  <href>  "title"  )
				//        ^^ skipping these spaces
				pos++;
				for (; pos < max; pos++)
				{
					var code:Number = state.src.charCodeAt(pos);
					if (code !== 0x20 && code !== 0x0A)
						break;
				}
				if (pos >= max)
					return false;

				// [link](  <href>  "title"  )
				//          ^^^^^^ parsing link destination
				start = pos;
				if (parseLinkDestination(state, pos))
				{
					var href:String = state.linkContent;
					pos = state.position;
				} else {
					href = '';
				}

				// [link](  <href>  "title"  )
				//                ^^ skipping these spaces
				start = pos;
				for (; pos < max; pos++)
				{
					code = state.src.charCodeAt(pos);
					if (code !== 0x20 && code !== 0x0A) { break; }
				}

				// [link](  <href>  "title"  )
				//                  ^^^^^^^ parsing link title
				if (pos < max && start !== pos && parseLinkTitle(state, pos))
				{
					var title:String = state.linkContent;
					pos = state.position;

					// [link](  <href>  "title"  )
					//                         ^^ skipping these spaces
					for (; pos < max; pos++)
					{
						code = state.src.charCodeAt(pos);
						if (code !== 0x20 && code !== 0x0A) { break; }
					}
				} else {
					title = '';
				}

				if (pos >= max || state.src.charCodeAt(pos) !== 0x29/* ) */)
				{
					state.position = oldPos;
					return false;
				}
				pos++;
			} else {
				//
				// Link reference
				//

				// do not allow nested reference links
				if (state.linkLevel > 0) { return false; }

				// [foo]  [bar]
				//      ^^ optional whitespace (can include newlines)
				for (; pos < max; pos++)
				{
					code = state.src.charCodeAt(pos);
					if (code !== 0x20 && code !== 0x0A) { break; }
				}

				if (pos < max && state.src.charCodeAt(pos) === 0x5B/* [ */)
				{
					start = pos + 1;
					pos = parseLinkLabel(state, pos);
					if (pos >= 0) {
						var label:String = state.src.slice(start, pos++);
					} else {
						pos = start - 1;
					}
				}

				// covers label === '' and label === undefined
				// (collapsed reference link and shortcut reference link respectively)
				if (!label) {
					if (label == null) {
						pos = labelEnd + 1;
					}
					label = state.src.slice(labelStart, labelEnd);
				}

				var ref:HRef = state.env.references[normalizeReference(label)];
				if (!ref) {
					state.position = oldPos;
					return false;
				}
				href = ref.href;
				title = ref.title;
			}

			//
			// We found the end of the link, and know for a fact it's a valid link;
			// so all that's left to do is to call tokenizer.
			//
			if (!silent) {
				state.position = labelStart;
				state.posMax = labelEnd;

				if (isImage) {
					// use data on links for alt
					var linkToken:LinkToken = new LinkToken('image',state.level);
					linkToken.title = title;
					linkToken.href = href;
					linkToken.data = state.src.substr(labelStart, labelEnd - labelStart);
					state.push(linkToken);
					// state.push({
					// 	type: 'image',
					// 	src: href,
					// 	title: title,
					// 	alt: state.src.substr(labelStart, labelEnd - labelStart),
					// 	level: state.level
					// });
				} else {
					linkToken = new LinkToken('link_open',state.level++);
					linkToken.title = title;
					linkToken.href = href;
					state.push(linkToken);
					// state.push({
					// 	type: 'link_open',
					// 	href: href,
					// 	title: title,
					// 	level: state.level++
					// });
					state.linkLevel++;
					state.parser.tokenize(state);
					state.linkLevel--;
					state.push(new TagToken('link_close',--state.level));
					// state.push({ type: 'link_close', level: --state.level });
				}
			}

			state.position = pos;
			state.posMax = max;
			return true;

		}

	}
}