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
package org.apache.royale.markdown.helpers
{
	import org.apache.royale.markdown.InlineState;
	import org.apache.royale.utils.string.sanitizeUrl;

	/**
	 *  
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.9
	 *  @royalesuppressexport
	 */
	public function parseLinkDestination(state:InlineState, pos:int):Boolean
	{
		// var code, level, link,
		var start:int = pos;
		var max:int = state.posMax;

		if (state.src.charCodeAt(pos) === 0x3C /* < */) {
			pos++;
			while (pos < max) {
				var code:Number = state.src.charCodeAt(pos);
				if (code === 0x0A /* \n */) { return false; }
				if (code === 0x3E /* > */) {
					var link:String = normalizeLink(unescapeMd(state.src.slice(start + 1, pos)));
					if(sanitizeUrl(link) != link)
						return false;
					// if (!state.parser.validateLink(link)) { return false; }
					state.position = pos + 1;
					state.linkContent = link;
					return true;
				}
				if (code === 0x5C /* \ */ && pos + 1 < max) {
					pos += 2;
					continue;
				}

				pos++;
			}

			// no closing '>'
			return false;
		}

		// this should be ... } else { ... branch

		var level:int = 0;
		while (pos < max) {
			code = state.src.charCodeAt(pos);

			if (code === 0x20) { break; }

			// ascii control chars
			if (code < 0x20 || code === 0x7F) { break; }

			if (code === 0x5C /* \ */ && pos + 1 < max) {
				pos += 2;
				continue;
			}

			if (code === 0x28 /* ( */) {
				level++;
				if (level > 1) { break; }
			}

			if (code === 0x29 /* ) */) {
				level--;
				if (level < 0) { break; }
			}

			pos++;
		}

		if (start === pos) { return false; }

		link = unescapeMd(state.src.slice(start, pos));
		if(!link != sanitizeUrl(link))
			return false;
		// if (!state.parser.validateLink(link)) { return false; }

		state.linkContent = link;
		state.position = pos;
		return true;
	}
}