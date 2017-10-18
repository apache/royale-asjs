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
	 * Defines values for setting the <code>listStyleType</code> property of a TextLayoutFormat object. These values are used for controlling
	 * the appearance of items in a list.
	 *
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @langversion 3.0 
	 * 
	 *  @see TextLayoutFormat#listStyleType
	 */
	 
	public final class ListStyleType
	{
		/** Upper-case alphabetic "numbering": A-Z, AA-ZZ, and so on.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const UPPER_ALPHA:String = "upperAlpha";

		/** Lower-case alphabetic "numbering": a-z, aa-zz, and so on.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const LOWER_ALPHA:String = "lowerAlpha";

		/** Upper-case Roman numbering: I, II, III, IV, and so on.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const UPPER_ROMAN:String = "upperRoman";

		/** Lower-case Roman numbering: i, ii, iii, iv, and so on.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const LOWER_ROMAN:String = "lowerRoman";

		/** No content is generated for the marker.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const NONE:String = "none";

		/** A bullet character marker (filled circle).
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const DISC:String = "disc";

		/** A circle character marker that is not filled.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const CIRCLE:String = "circle";

		/** A filled square marker.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const SQUARE:String = "square";

		/** A square marker that is not filled.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const BOX:String = "box";

		/** A check mark.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const CHECK:String = "check";

		/** A filled diamond marker.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const DIAMOND:String = "diamond";

		/** A dash mark.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const HYPHEN:String = "hyphen";

		/** Numbering using Arabic script.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const ARABIC_INDIC:String = "arabicIndic";

		/** Numbering using Bengali script.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const BENGALI:String = "bengali";

		/** Numbering using decimals: 1, 2, 3, and so on.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const DECIMAL:String = "decimal";

		/** Numbering using decimal with a leading zero: 01, 02, 03, and so on.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const DECIMAL_LEADING_ZERO:String = "decimalLeadingZero";

		/** Numbering using Devangari.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const DEVANAGARI:String = "devanagari";

		/** Numbering using Gujarati.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const GUJARATI:String = "gujarati";

		/** Numbering using Gurmukhi.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const GURMUKHI:String = "gurmukhi";

		/** Numbering using Kannada.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const KANNADA:String = "kannada";

		/** Numbering using Persian.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const PERSIAN:String = "persian";

		/** Numbering using Thai.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const THAI:String = "thai";

		/** Numbering using Urdu.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const URDU:String = "urdu";

		/** Numbering for CJK.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const CJK_EARTHLY_BRANCH:String = "cjkEarthlyBranch";

		/** Numbering for CJK.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const CJK_HEAVENLY_STEM:String = "cjkHeavenlyStem";

		/** Numbering for Hangul.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const HANGUL:String = "hangul";

		/** Numbering for Hangul.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const HANGUL_CONSTANT:String = "hangulConstant";

		/** Numbering for Hiragana.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const HIRAGANA:String = "hiragana";

		/** Numbering for Hiragana.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const HIRAGANA_IROHA:String = "hiraganaIroha";

		/** Numbering for Katagana.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const KATAKANA:String = "katakana";

		/** Numbering for Katagana.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const KATAKANA_IROHA:String = "katakanaIroha";

		/** Lower-case Greek alphabetic "numering".
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const LOWER_GREEK:String = "lowerGreek";

		/** Lower-case alphabetic "numbering": a-z, aa-zz, and so on.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const LOWER_LATIN:String = "lowerLatin";

		/** Upper-case Greek alphabetic "numering".
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const UPPER_GREEK:String = "upperGreek";

		/** Upper-case alphabetic "numbering": A-Z, AA-ZZ, and so on.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const UPPER_LATIN:String = "upperLatin";
	}
}
