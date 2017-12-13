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
package org.apache.royale.textLayout.formats
{
	/**
	 *  Defines values for the <code>blockProgression</code> property
	 *  of the <code>TextLayouFormat</code> class. BlockProgression specifies the direction in 
	 *  which lines are placed in the container.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 * 
	 *  @see org.apache.royale.textLayout.formats.TextLayoutFormat#blockProgression TextLayoutFormat.blockProgression
	 */
	 
	public final class BlockProgression
	{
		/** 
		 *  Specifies right to left block progression. Lines are laid out vertically starting at the right 
		 *  edge of the container and progressing leftward. Used for vertical text, for example, vertical 
		 *  Chinese or Japanese text. 
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	  	 * @langversion 3.0 
	 	 */
	 	 
		public static const RL:String = "rl";
		
		/** 
		 *  Specifies top to bottom block progression. Lines are laid out horizontally starting at the top of 
		 *  the container and progressing down to the bottom. Used for horizontal text. 
		 * 
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	  	 * @langversion 3.0 
	  	 */
	  	 
		public static const TB:String = "tb";				
	}
}
