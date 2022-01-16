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
	public function parseLinkLabel(state:InlineState, start:int):int
	{
		var found:Boolean;
		var labelEnd:int = -1;
		var max:int = state.posMax;
		var oldPos:int = state.position;
		var oldFlag:Boolean = state.isInLabel;

		if (state.isInLabel) { return -1; }

		if (state.labelUnmatchedScopes) {
			state.labelUnmatchedScopes--;
			return -1;
		}

		state.position = start + 1;
		state.isInLabel = true;
		var level:int = 1;

		while (state.position < max) {
			var marker:Number = state.src.charCodeAt(state.position);
			if (marker === 0x5B /* [ */) {
				level++;
			} else if (marker === 0x5D /* ] */) {
				level--;
				if (level === 0) {
					found = true;
					break;
				}
			}

			state.parser.skipToken(state);
		}

		if (found) {
			labelEnd = state.position;
			state.labelUnmatchedScopes = 0;
		} else {
			state.labelUnmatchedScopes = level - 1;
		}

		// restore old state
		state.position = oldPos;
		state.isInLabel = oldFlag;

		return labelEnd;
	}
}