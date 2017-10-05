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
	 *  Defines values for setting the <code>textJustify</code> property of the TextLayoutFormat class. 
	 *  Default value is INTER_WORD, meaning that extra space in justification is added to the space characters.
	 *  DISTRIBUTE specifies that extra space is added both to space characters and between individual
	 *  letters. Use these values only when setting <code>justificationRule</code> to SPACE.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see TextLayoutFormat#textJustify
	 * @see TextLayoutFormat#justificationRule
	 */
	public final class TextJustify
	{
		/** Specifies that justification is to add space both to space characters and 
		 * between individual letters.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
		public static const DISTRIBUTE:String = "distribute";
		
		/** Specifies that justification is to add space to space characters. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
		public static const INTER_WORD:String = "interWord";
	}
}
