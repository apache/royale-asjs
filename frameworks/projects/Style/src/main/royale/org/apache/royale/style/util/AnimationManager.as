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
package org.apache.royale.style.util
{
	import org.apache.royale.debugging.assert;

	public class AnimationManager
	{
		private function AnimationManager()
		{
			
		}
		COMPILE::JS
		private static const keyframeSet:Set = new Set();

		public static function registerKeyframes(name:String, keyframes:Array):void
		{
			COMPILE::JS
			{
				assert(name.indexOf("--") != 0, "Keyframes does not support CSS variables. The name should not start with '--': " + name);
				// Only add once. "has" is much faster than running "set" again.
				if(keyframeSet.has(name))
					return;

				keyframeSet.add(name);
				// Should we check that it's not being added twice?
				// Shouldn't be necessary unless something went wrong...
				var selector:String = "@keyframes " + name;
				StyleManager.addStyle(selector, selector, keyframes.join("\n"));
			}
		}


		public static function has(name:String):Boolean
		{
			COMPILE::JS
			{
				return keyframeSet.has(name);
			}
			COMPILE::SWF
			{
				return false;
			}
		}
	}
}