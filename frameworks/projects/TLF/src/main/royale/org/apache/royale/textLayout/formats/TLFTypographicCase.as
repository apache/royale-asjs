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
	 *  Defines values for the <code>typographicCase</code> property of the TextLayoutFormat
	 *  class. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 * 
	 * @see TextLayoutFormat#typographicCase
	 */
	public final class TLFTypographicCase
	{
		/** Specifies default typographic case -- no special features applied. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
 		public static const DEFAULT:String = "default";
 		
		/** Converts all lowercase characters to uppercase, then applies small caps to only the 
		 * characters that the conversion changed. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
  	 	public static const LOWERCASE_TO_SMALL_CAPS:String = "lowercaseToSmallCaps";
  	 	
  	 	/** Specifies that all characters use lowercase glyphs on output. 
  	 	 *
  	 	 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
 	 	public static const LOWERCASE:String = "lowercase";

		/** Specifies that uppercase characters use small-caps glyphs on output. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
 	 	public static const CAPS_TO_SMALL_CAPS:String = "capsToSmallCaps";

		/** Specifies that all characters use uppercase glyphs on output.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
 	 	public static const UPPERCASE:String = "uppercase";
	}
}
