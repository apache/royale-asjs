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
	 *  Defines values for setting the <code>textAlign</code> and <code>textAlignLast</code> properties
	 *  of the TextLayoutFormat class. The values describe the alignment of lines in the paragraph relative to the 
	 *  container.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 * @see TextLayoutFormat#textAlign 
	 * @see TextLayoutFormat#textAlignLast 
	 */
	public final class TextAlign
	{
		/** Specifies start edge alignment - text is aligned to match the writing order. Equivalent to setting 
		 * left in left-to-right text, or right in right-to-left text.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
		public static const START:String = "start";
		
		/** Specifies end edge alignment - text is aligned opposite from the writing order. Equivalent to 
		 *  specifying right in left-to-right text, or left in right-to-left text. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
		public static const END:String = "end";
		
		/** Specifies left edge alignment. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
		public static const LEFT:String = "left";
		
		/** Specifies right edge alignment. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
		public static const RIGHT:String = "right";
		
		/** Specifies center alignment within the container.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
		public static const CENTER:String = "center";
		
		/** Specifies that text is justified within the lines so they fill the container space.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
		public static const JUSTIFY:String = "justify";
		
	}
}
