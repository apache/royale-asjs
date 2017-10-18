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
package org.apache.royale.textLayout.utils
{
	import org.apache.royale.textLayout.compose.ComposeState;
	import org.apache.royale.textLayout.compose.IComposer;
	public class ComposeUtils
	{
		
		// a single ComposeState that is checked out and checked in
		static private var _sharedComposeState:IComposer;

		/** @private */
		static public function getComposeState():IComposer
		{
			var rslt:IComposer = _sharedComposeState;
			if (rslt)
			{
				_sharedComposeState = null;
				return rslt;
			}
			return new ComposeState();
		}
		
		/** @private */
		static public function releaseComposeState(state:IComposer):void
		{
			state.releaseAnyReferences();
			_sharedComposeState = state;
		}				
	}
}
