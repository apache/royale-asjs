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
	/** 
	 * Utilities for managing and getting information about characters.
	 * The methods of this class are static and must be called using
	 * the syntax <code>CharacterUtil.method(<em>parameter</em>)</code>.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public final class CharacterUtil
	{
		/** 
		 * Returns <code>true</code> if the <code>charCode</code> argument is a high word in a surrogate pair. 
		 * A surrogate pair represents a character with a code point that requires more
		 * than sixteen bits to express and thus requires a combination
		 * of two 16-bit words, a high surrogate and a low surrogate, to embody its code point.
		 * <p>This method can be used when processing a series of characters to
		 * ensure that you do not inadvertently divide a surrogate pair
		 * into incomplete halves.</p>
		 * 
		 *
		 * @param charCode An integer that represents a character code.
		 * Character codes are usually represented in hexadecimal format.
		 * For example, the space character's character code can be
		 * represented by the number <code>0x0020</code>.
		 * @return <code>true</code> if <code>charCode</code> is the high surrogate in a surrogate pair.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		static public function isHighSurrogate(charCode:int):Boolean
		{
			return (charCode >= 0xD800 && charCode <= 0xDBFF);
		}
		
		/** 
		 * Returns <code>true</code> if the <code>charCode</code> argument is a low word in a surrogate pair. 
		 * A surrogate pair represents a character with a code point that requires more
		 * than sixteen bits to express and thus requires a combination
		 * of two 16-bit words, a high surrogate and a low surrogate, to embody its code point.
		 * <p>This method can be used when processing a series of characters to
		 * ensure that you do not inadvertently divide a surrogate pair
		 * into incomplete halves.</p>
		 *
		 * @param charCode An integer that represents a character code.
		 * Character codes are usually represented in hexadecimal format.
		 * For example, the space character's character code can be
		 * represented by the number <code>0x0020</code>.
		 * @return <code>true</code> if <code>charCode</code> is the low surrogate in a surrogate pair.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		static public function isLowSurrogate (charCode:int):Boolean
		{
			return (charCode >= 0xDC00 && charCode <= 0xDFFF);
		}

		static private var whiteSpaceObject:Object = createWhiteSpaceObject();
		
		static private function createWhiteSpaceObject():Object
		{
			var rslt:Object = {};
			//members of SpaceSeparator category
			rslt[0x0020] =  true;  //SPACE
			rslt[0x1680] =  true;  //OGHAM SPACE MARK
			rslt[0x180E] =  true;  //MONGOLIAN VOWEL SEPARATOR
			rslt[0x2000] =  true;  //EN QUAD
			rslt[0x2001] =  true;  //EM QUAD
			rslt[0x2002] =  true;  //EN SPACE
			rslt[0x2003] =  true;  //EM SPACE
			rslt[0x2004] =  true;  //THREE-PER-EM SPACE
			rslt[0x2005] =  true;  //FOUR-PER-EM SPACE
			rslt[0x2006] =  true;  //SIZE-PER-EM SPACE
			rslt[0x2007] =  true;  //FIGURE SPACE
			rslt[0x2008] =  true;  //PUNCTUATION SPACE
			rslt[0x2009] =  true;  //THIN SPACE
			rslt[0x200A] =  true;  //HAIR SPACE
			rslt[0x202F] =  true;  //NARROW NO-BREAK SPACE
			rslt[0x205F] =  true;  //MEDIUM MATHEMATICAL SPACE
			rslt[0x3000] =  true;  //IDEOGRAPHIC SPACE
			//members of LineSeparator category
			rslt[0x2028] =  true;  //LINE SEPARATOR
			//members of ParagraphSeparator category
			rslt[0x2029] =  true;
			//Other characters considered to be a space
			rslt[0x0009] =  true; //CHARACTER TABULATION
			rslt[0x000A] =  true; //LINE FEED
			rslt[0x000B] =  true; //LINE TABULATION
			rslt[0x000C] =  true; //FORM FEED
			rslt[0x000D] =  true; //CARRIAGE RETURN
			rslt[0x0085] =  true; //NEXT LINE
			rslt[0x00A0] =  true; //NO-BREAK SPACE	
			return rslt;
		}
		/** 
		 * Returns <code>true</code> if <code>charCode</code> is a whitespace character. 
		 * <p>The following table describes all characters that this
		 * method considers a whitespace character.
		 * </p>
		 * <table class="innertable">
		 *     <tr><th>Character Code</th><th>Unicode Character Name</th><th>Category</th></tr>
		 *     <tr><td><code>0x0020</code></td><td>SPACE</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x1680</code></td><td>OGHAM SPACE MARK</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x180E</code></td><td>MONGOLIAN VOWEL SEPARATOR</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x2000</code></td><td>EN QUAD</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x2001</code></td><td>EM QUAD</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x2002</code></td><td>EN SPACE</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x2003</code></td><td>EM SPACE</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x2004</code></td><td>THREE-PER-EM SPACE</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x2005</code></td><td>FOUR-PER-EM SPACE</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x2006</code></td><td>SIX-PER-EM SPACE</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x2007</code></td><td>FIGURE SPACE</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x2008</code></td><td>PUNCTUATION SPACE</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x2009</code></td><td>THIN SPACE</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x200A</code></td><td>HAIR SPACE</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x202F</code></td><td>NARROW NO-BREAK SPACE</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x205F</code></td><td>MEDIUM MATHEMATICAL SPACE</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x3000</code></td><td>IDEOGRAPHIC SPACE</td><td>Space Separator</td></tr>
		 *     <tr><td><code>0x2028</code></td><td>LINE SEPARATOR</td><td>Line Separator</td></tr>
		 *     <tr><td><code>0x2029</code></td><td>PARAGRAPH SEPARATOR</td><td>Paragraph Separator</td></tr>
		 *     <tr><td><code>0x0009</code></td><td>CHARACTER TABULATION</td><td>Other</td></tr>
		 *     <tr><td><code>0x000A</code></td><td>LINE FEED</td><td>Other</td></tr>
		 *     <tr><td><code>0x000B</code></td><td>LINE TABULATION</td><td>Other</td></tr>
		 *     <tr><td><code>0x000C</code></td><td>FORM FEED</td><td>Other</td></tr>
		 *     <tr><td><code>0x000D</code></td><td>CARRIAGE RETURN</td><td>Other</td></tr>
		 *     <tr><td><code>0x0085</code></td><td>NEXT LINE</td><td>Other</td></tr>
		 *     <tr><td><code>0x00A0</code></td><td>NO-BREAK SPACE</td><td>Other</td></tr>
		 *  </table>

		 *
		 * @param charCode An integer that represents a character code.
		 * Character codes are usually represented in hexadecimal format.
		 * For example, the space character's character code can be
		 * represented by the number <code>0x0020</code>.
		 *
		 * @return <code>true</code> if <code>charCode</code> is a whitespace character. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		static public function isWhitespace(charCode:int):Boolean
		{			
			return whiteSpaceObject[charCode];
		}
	}
}
