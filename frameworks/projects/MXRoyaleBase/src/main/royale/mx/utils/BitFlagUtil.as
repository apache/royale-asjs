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

package mx.utils
{
	
	[ExcludeClass]
	
	/**
	 *  @private
	 *  BitFlagUtil is a framework internal class to help manipulate 
	 *  bit flags for the purpose of storing booleans effeciently in 
	 *  one integer.
	 */
	public class BitFlagUtil
	{
		public function BitFlagUtil()
		{
			super();
		}
		
		/**
		 *  Returns true if all of the flags specified by <code>flagMask</code> are set. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */ 
		public static function isSet(flags:uint, flagMask:uint):Boolean
		{
			return flagMask == (flags & flagMask);
		}
		
		/**
		 *  Sets the flags specified by <code>flagMask</code> according to <code>value</code>. 
		 *  Returns the new bitflag.
		 *  <code>flagMask</code> can be a combination of multiple flags.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */ 
		public static function update(flags:uint, flagMask:uint, value:Boolean):uint
		{
			if (value)
			{
				if ((flags & flagMask) == flagMask)
					return flags; // Nothing to change
				// Don't use ^ since flagMask could be a combination of multiple flags
				flags |= flagMask;
			}
			else
			{
				if ((flags & flagMask) == 0)
					return flags; // Nothing to change
				// Don't use ^ since flagMask could be a combination of multiple flags
				flags &= ~flagMask;
			}
			return flags;
		}
		
	}
}