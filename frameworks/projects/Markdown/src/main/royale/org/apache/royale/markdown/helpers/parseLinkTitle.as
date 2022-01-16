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

	/**
	 *  
	 *  @langversion 3.0
	 *  @productversion Royale 0.9.9
	 *  @royalesuppressexport
	 */
	public function parseLinkTitle(state:InlineState, pos:int):Boolean
	{
		// var code,
		var start:int = pos;
		var max:int = state.posMax;
		var marker:Number = state.src.charCodeAt(pos);

		if (marker !== 0x22 /* " */ && marker !== 0x27 /* ' */ && marker !== 0x28 /* ( */) { return false; }

		pos++;

		// if opening marker is "(", switch it to closing marker ")"
		if (marker === 0x28) { marker = 0x29; }

		while (pos < max) {
			var code:Number = state.src.charCodeAt(pos);
			if (code === marker) {
				state.position = pos + 1;
				state.linkContent = unescapeMd(state.src.slice(start + 1, pos));
				return true;
			}
			if (code === 0x5C /* \ */ && pos + 1 < max) {
				pos += 2;
				continue;
			}

			pos++;
		}

		return false;
	}
}