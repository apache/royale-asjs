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
package org.apache.royale.textLayout.elements
{
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.events.ModelChange;
	import org.apache.royale.textLayout.formats.BlockProgression;
	import org.apache.royale.textLayout.formats.Direction;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.IListMarkerFormat;
	import org.apache.royale.textLayout.formats.ListStyleType;
	import org.apache.royale.textLayout.formats.Suffix;

	

	/** 
	 * The List class is used for grouping together items into a numbered or unnumbered list. A ListElement's children may be of type ListItemElement,
	 * ListElement, ParagraphElement, or DivElement. 
	 * 
	 * <p>Each ListElement creates a scope with an implicit counter 'ordered'.</p>
	 * 
	 * @see org.apache.royale.textLayout.formats.ITextLayoutFormat#listStyleType
	 * @see org.apache.royale.textLayout.formats.ITextLayoutFormat#listStylePosition
	 * @see org.apache.royale.textLayout.formats.ListMarkerFormat
	 * 
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 */
	public class ListElement extends ContainerFormattedElement implements IListElement
	{
		/** 
		 * Specifies the name of the ListMarker format
		 * @private
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		static public const LIST_MARKER_FORMAT_NAME:String = "listMarkerFormat";
		
		override public function get className():String{
			return "ListElement";
		}
		/** @private */
		override protected function get abstract():Boolean
		{ return false; }
		
		/** @private */
		public override function get defaultTypeName():String
		{ return "list"; }
		
		/** @private */
		public override function canOwnFlowElement(elem:IFlowElement):Boolean
		{
			return !(elem is ITextFlow) && !(elem is IFlowLeafElement) && !(elem is ISubParagraphGroupElementBase);
		}
		
		/** @private if its in a numbered list expand the damage to all list items - causes the numbers to be regenerated */
		public override function modelChanged(changeType:String, elem:IFlowElement, changeStart:int, changeLen:int, needNormalize:Boolean = true, bumpGeneration:Boolean = true):void
		{
			// this is a bit aggressive - could damage with a new damage type (LIST_MARKER_DAMAGE) if we wanted to really optimize list item addition/removal
			if ((changeType == ModelChange.ELEMENT_ADDED || changeType == ModelChange.ELEMENT_REMOVAL) && (elem is ListItemElement) && this.isNumberedList())
			{
				// for list renumbering
				changeStart = elem.parentRelativeStart;
				changeLen = textLength-elem.parentRelativeStart;
			}
			super.modelChanged(changeType,elem,changeStart,changeLen,needNormalize,bumpGeneration);
		}
		
		/** @private */
		public override function getEffectivePaddingLeft():Number
		{ 
			if (computedFormat.paddingLeft != FormatValue.AUTO)
				return computedFormat.paddingLeft;
			
			var tf:ITextFlow = getTextFlow();
			if (!tf || tf.computedFormat.blockProgression != BlockProgression.TB || computedFormat.direction != Direction.LTR)
				return 0;
			
			return computedFormat.listAutoPadding;
		}
		
		/** @private */
		public override function getEffectivePaddingRight():Number
		{ 
			if (computedFormat.paddingRight != FormatValue.AUTO)
				return computedFormat.paddingRight;
			
			var tf:ITextFlow = getTextFlow();
			if (!tf || tf.computedFormat.blockProgression != BlockProgression.TB || computedFormat.direction != Direction.RTL)
				return 0;
			
			return computedFormat.listAutoPadding;
		}
		/** @private */
		public override function getEffectivePaddingTop():Number
		{ 
			if (computedFormat.paddingTop != FormatValue.AUTO)
				return computedFormat.paddingTop;
			
			var tf:ITextFlow = getTextFlow();
			if (!tf || tf.computedFormat.blockProgression != BlockProgression.RL || computedFormat.direction != Direction.LTR)
				return 0;
			
			return computedFormat.listAutoPadding;
		}
		
		/** @private */
		public override function getEffectivePaddingBottom():Number
		{ 
			if (computedFormat.paddingBottom != FormatValue.AUTO)
				return computedFormat.paddingBottom;
			
			var tf:ITextFlow = getTextFlow();
			if (!tf || tf.computedFormat.blockProgression != BlockProgression.RL || computedFormat.direction != Direction.RTL)
				return 0;
			
			return computedFormat.listAutoPadding;
		}

		/** avoid switches and if-else statements.  switches behave like if-else
		 * http://www.w3.org/Style/CSS/Test/CSS1/current/sec563.htm
		 * http://en.wikipedia.org/wiki/Unicode_Geometric_Shapes
		 * @private
		 */
		public static const constantListStyles:Object = {
			"none":	"",
			"disc":	"\u2022",	// black bullet
			"circle":	"\u25e6",	// white bullet
			"square":	"\u25a0",	// black square
			"box":	"\u25a1",	// white square
			"check":	"\u2713",	// check mark
			"diamond":"\u25c6",	// black diamond
			"hyphen":	"\u2043"	// hyphen bullet
		};

		private static const romanDigitFunction:Vector.<Function> = Vector.<Function>([
			function (o:String,f:String,t:String):String { return ""; },
			function (o:String,f:String,t:String):String { return o; },
			function (o:String,f:String,t:String):String { return o+o; },
			function (o:String,f:String,t:String):String { return o+o+o; },
			function (o:String,f:String,t:String):String { return o+f; },
			function (o:String,f:String,t:String):String { return f; },
			function (o:String,f:String,t:String):String { return f+o; },
			function (o:String,f:String,t:String):String { return f+o+o; },
			function (o:String,f:String,t:String):String { return f+o+o+o; },
			function (o:String,f:String,t:String):String { return o+t; }
		]);
		
		/** @private roman string support - doesn't follow the CSS spec for numbers > 4000.  The lines above aren't that interesting. In fact doesn't follow CSS spec at all. */
		public static function createRomanString(n:int,data:Vector.<String>):String
		{
			var leading:String = "";
			
			// there are other ways to handle values > 4000 - this works
			while (n >= 1000)
			{
				leading += data[6];
				n -= 1000;
			}
			
			// avoid switches and loops - add in the suffix
			return leading + romanDigitFunction[int(n / 100)](data[4],data[5],data[6])
			     + romanDigitFunction[int((n/10) % 10)](data[2],data[3],data[4])
			     + romanDigitFunction[int(n % 10)](data[0],data[1],data[2]);
		}
		
		private static const upperRomanData:Vector.<String> = Vector.<String>(['I', 'V', 'X', 'L', 'C', 'D', 'M']);
		/** @private 
		 * From http://www.w3.org/TR/css3-lists/#list-content
		 * upper-roman
		    Numbers are converted to roman numerals using the steps described below. The phrase "take the three least significant numbers" means divide by 1000, truncate (drop the fractional part), multiply by one thousand, and subtract this from the original number. So the three least significant figures of 1004 is 4.
		
		       1. If the number is in the range 0 to 1000 inclusive, use the following steps:
		             1. If the number is 1000, add Ⅿ U+216F and skip to the end.
		             2. If the number is 900 or more, add ⅭⅯ U+216D U+216F and subtract 900.
		             3. If the number is 500 or more, add Ⅾ U+216E and subtract 500.
		             4. If the number is 400 or more, add ⅭⅮ U+216D U+216E and subtract 400.
		             5. While the number is greater than or equal to 100, add Ⅽ U+216D and subtract 100.
		             6. If the number is 90 or more, add ⅩⅭ U+2169 U+216D and subtract 90.
		             7. If the number is 50 or more, add Ⅼ U+216C and subtract 50.
		             8. If the number is 40 or more, add ⅩⅬ U+2169 U+216C and subtract 40.
		             9. While the number is greater than 12, add Ⅹ U+2169 and subtract 10.
		            10. If the number is greater than 0, then add the appropriate roman numeral from Ⅰ U+2160 (1) to Ⅻ U+216B (12). For example, if the number is 8, add Ⅷ U+2167. 
		       2. If the number is in the range 1000 to 40000 exclusive, then take the three least significant numbers and convert them using step 1. Then convert the remainder using the following steps and prepend it to the result.
		             1. While the number is greater than or equal to 10000, add ↂ U+2182 and subtract 10000.
		             2. If the number is 9000, add Ⅿↂ U+216F U+2182 and skip to the end.
		             3. If the number is 4000, add Ⅿↁ U+216F U+2181 and skip to the end.
		             4. If the number is 5000 or more, add ↁ U+2181 and subtract 5000.
		             5. While the number is greater than 0, add Ⅿ U+216F and subtract 1000. 
		       3. If the number is greater than 40000, then take the three least significant figures and convert them using step 1, calling that the result. Then convert the remainder by dividing it by 1000, passing it through the entire algorithm starting at the top, adding an overbar to it, and prepending it to the current result. For very large numbers, this step may be entered several times, resulting in the first few characters of the result having multiple overbars. 
		
		    The suffix for roman numerals is a dot . U+002E.
		
		    Zero and negative numbers are rendered using the decimal numbering style. 
			 
			Modified as follows:
			 * The letterspacing behavior of <U+2169 Ⅹ ROMAN NUMERAL TEN, U+2161 Ⅱ ROMAN NUMERAL TWO> is probably not what we want
			 * while that of <X, I, I> is the one you want.
				(Of course, keep using U+2180 ↀ ROMAN NUMERAL ONE THOUSAND C D and similar.)
	 	*/
		public static function upperRomanString(n:int):String
		{ 
			if (n <= 0)
				return decimalString(n);
			
			// normal case - just do it and be done
			if (n <= 1000)
				return createRomanString(n,upperRomanData);
				
			// not to spec but overbars are too complicated for a non-intersting case with TLF 2.0 numbering
			if (n >= 40000)
				return decimalString(n);
			
			// the more complex case defined as bove
			var lowerString:String = createRomanString(n%1000,upperRomanData);
			var highString:String = "";
			
			n -= n%1000;
			
			while (n >= 10000)
			{
				highString += String.fromCharCode(0x2182);
				n -= 10000;
			}
			if (n == 9000)
				highString += "M" + String.fromCharCode(0x2182);
			else if (n == 4000)
				highString += "M" + String.fromCharCode(0x2181);
			else
			{
				if (n >= 5000)
				{
					highString += String.fromCharCode(0x2181);
					n -= 5000;
				}
				while (n > 0)
				{
					highString += "M";
					n -= 1000;
				}
			}

			return highString+lowerString; 
		}	// INCORRECT
		
		private static const lowerRomanData:Vector.<String> = Vector.<String>(['i', 'v', 'x', 'l', 'c', 'd', 'm']);
		/** @private 
		 * The algorithm for this numbering style is identical to the upper-roman  style but using ⅰ-ⅿ U+2170-U+217F instead of Ⅰ-Ⅿ U+2160-U+216F, 
		 * and ignoring step 2 (i.e. not treating numbers 1000-40000 in a special way, since there are no lowercase equivalents to ↁ U+2181 and ↂ U+2182). 
		 * Numbers up to 3999 convert and over 4000 are going to go to decimal.
		 */
		public static function lowerRomanString(n:int):String
		{ return n> 0 && n < 4000 ? createRomanString(n,lowerRomanData) : decimalString(n); }
		
		/** @private */
		public static function decimalString(n:int):String
		{ return n.toString(); }
		/** @private */
		public static function decimalLeadingZeroString(n:int):String
		{ return n <= 9 && n >= -9 ? "0"+n.toString() : n.toString(); }
		
		
		// Supports "Numeric" style base 10 lists 
		// http://www.w3.org/TR/css3-lists/#numeric
		// NOTE: easy to pass in a base if other than base 10 is needed
		// NOTE: easy to add non-positive number support 
		// (from above link: "For all these systems, negative numbers are first converted as if they were positive numbers, then have - U+002D prefixed.")
		// n is the number.  zero is the charChode of zero and is used as an offset
		// see http://www.w3.org/TR/css3-lists/#list-content
		/** @private */
		public static function createNumericBaseTenString(n:int,zero:int):String
		{
			CONFIG::debug { assert(n >= 0,"Bad number passed to createBaseTenString"); }
			
			if (n == 0)
				return String.fromCharCode(zero);
			
			var rslt:String = "";
			while (n > 0)
			{
				rslt = String.fromCharCode((n%10)+zero) + rslt;
				n = n / 10;
			}
			return rslt;
		}
		
		/** @private */
		public static function arabicIndicString(n:int):String
		{ return createNumericBaseTenString(n,0x660); }
		/** @private */
		public static function bengaliString(n:int):String
		{ return createNumericBaseTenString(n,0x9E6); }
		/** @private */
		public static function devanagariString(n:int):String
		{ return createNumericBaseTenString(n,0x0966); }
		/** @private */
		public static function gujaratiString(n:int):String
		{ return createNumericBaseTenString(n,0xAE6); }
		/** @private */
		public static function gurmukhiString(n:int):String
		{ return createNumericBaseTenString(n,0xA66); }
		/** @private */
		public static function kannadaString(n:int):String
		{ return createNumericBaseTenString(n,0xCE6); }
		/** @private */
		public static function persianString(n:int):String
		{ return createNumericBaseTenString(n,0x6F0); }	// same as urdu
		/** @private */
		public static function thaiString(n:int):String
		{ return createNumericBaseTenString(n,0xE50); }
		/** @private */
		public static function urduString(n:int):String
		{ return createNumericBaseTenString(n,0x6F0); }	// same as persian
		
		/** @private */
		public static function createContinuousAlphaString(n:int,first:int,base:int):String
		{
			CONFIG::debug { assert(n > 0,"Bad number passed to createContinuousAlphaString"); }
			var rslt:String = "";
			
			while (n > 0)
			{
				rslt = String.fromCharCode(((n-1)%base)+first) + rslt;
				n = (n-1) / base;
			}
			return rslt;
		}
	
		// continuous alphabetic
		/** @private */
		public static function lowerAlphaString(n:int):String 
		{ return createContinuousAlphaString(n,0x61,26); }
		/** @private */
		public static function upperAlphaString(n:int):String 
		{ return createContinuousAlphaString(n,0x41,26); }
		/** @private */
		public static function lowerLatinString(n:int):String
		{ return createContinuousAlphaString(n,0x61,26); }		// same as alpha
		/** @private */
		public static function upperLatinString(n:int):String
		{ return createContinuousAlphaString(n,0x41,26); }		// same as alpha
		
		// see http://www.w3.org/TR/css3-lists/#alphabetic for the table definitions
		/** @private */
		public static function createTableAlphaString(n:int,table:Vector.<int>):String
		{
			CONFIG::debug { assert(n > 0,"Bad number passed to createTableAlphaString"); }
			var rslt:String = "";
			var base:int = table.length;
			
			while (n > 0)
			{
				rslt = String.fromCharCode(table[(n-1)%base]) + rslt;
				n = (n-1) / base;
			}
			return rslt;
		}
		
		// table alphabetic
		
		/** @private */
		public static const cjkEarthlyBranchData:Vector.<int> = Vector.<int>([
			0x5B50, 0x4E11, 0x5BC5, 0x536F, 0x8FB0, 0x5DF3, 0x5348, 0x672A, 
			0x7533, 0x9149, 0x620C, 0x4EA5]);
		/** @private */
		public static function cjkEarthlyBranchString(n:int):String
		{ return createTableAlphaString(n,cjkEarthlyBranchData); }
		
		/** @private */
		public static const cjkHeavenlyStemData:Vector.<int> = Vector.<int>([
			0x7532, 0x4E59, 0x4E19, 0x4E01, 0x620A, 0x5DF1, 0x5E9A, 0x8F9B, 
			0x58EC, 0x7678 ]);
		/** @private */
		public static function cjkHeavenlyStemString(n:int):String
		{ return createTableAlphaString(n,cjkHeavenlyStemData); }

		/** @private */
		public static const hangulData:Vector.<int> = Vector.<int>([
			0xAC00, 0xB098, 0xB2E4, 0xB77C, 0xB9C8, 0xBC14, 0xC0AC, 0xC544, 
			0xC790, 0xCC28, 0xCE74, 0xD0C0, 0xD30C, 0xD558]);
		/** @private */
		public static function hangulString(n:int):String
		{ return createTableAlphaString(n,hangulData); }
		
		/** @private */
		public static const hangulConstantData:Vector.<int> = Vector.<int>([
			0x3131, 0x3134, 0x3137, 0x3139, 0x3141, 0x3142, 0x3145, 0x3147, 
			0x3148, 0x314A, 0x314B, 0x314C, 0x314D, 0x314E]);
		/** @private */
		public static function hangulConstantString(n:int):String
		{ return createTableAlphaString(n,hangulConstantData); }
		
		/** @private */
		public static const hiraganaData:Vector.<int> = Vector.<int>([
			0x3042, 0x3044, 0x3046, 0x3048, 0x304A, 0x304B, 0x304D, 0x304F, 
			0x3051, 0x3053, 0x3055, 0x3057, 0x3059, 0x305B, 0x305D, 0x305F, 
			0x3061, 0x3064, 0x3066, 0x3068, 0x306A, 0x306B, 0x306C, 0x306D, 
			0x306E, 0x306F, 0x3072, 0x3075, 0x3078, 0x307B, 0x307E, 0x307F, 
			0x3080, 0x3081, 0x3082, 0x3084, 0x3086, 0x3088, 0x3089, 0x308A, 
			0x308B, 0x308C, 0x308D, 0x308F, 0x3090, 0x3091, 0x3092, 0x3093]);
		/** @private */
		public static function hiraganaString(n:int):String
		{ return createTableAlphaString(n,hiraganaData); }
		
		/** @private */
		public static const hiraganaIrohaData:Vector.<int> = Vector.<int>([
			0x3044, 0x308D, 0x306F, 0x306B, 0x307B, 0x3078, 0x3068, 0x3061, 
			0x308A, 0x306C, 0x308B, 0x3092, 0x308F, 0x304B, 0x3088, 0x305F, 
			0x308C, 0x305D, 0x3064, 0x306D, 0x306A, 0x3089, 0x3080, 0x3046, 
			0x3090, 0x306E, 0x304A, 0x304F, 0x3084, 0x307E, 0x3051, 0x3075, 
			0x3053, 0x3048, 0x3066, 0x3042, 0x3055, 0x304D, 0x3086, 0x3081, 
			0x307F, 0x3057, 0x3091, 0x3072, 0x3082, 0x305B, 0x3059 ]);
		/** @private */
		public static function hiraganaIrohaString(n:int):String
		{ return createTableAlphaString(n,hiraganaIrohaData); }
		
		/** @private */
		public static const katakanaData:Vector.<int> = Vector.<int>([
			0x30A2, 0x30A4, 0x30A6, 0x30A8, 0x30AA, 0x30AB, 0x30AD, 0x30AF, 
			0x30B1, 0x30B3, 0x30B5, 0x30B7, 0x30B9, 0x30BB, 0x30BD, 0x30BF, 
			0x30C1, 0x30C4, 0x30C6, 0x30C8, 0x30CA, 0x30CB, 0x30CC, 0x30CD, 
			0x30CE, 0x30CF, 0x30D2, 0x30D5, 0x30D8, 0x30DB, 0x30DE, 0x30DF, 
			0x30E0, 0x30E1, 0x30E2, 0x30E4, 0x30E6, 0x30E8, 0x30E9, 0x30EA, 
			0x30EB, 0x30EC, 0x30ED, 0x30EF, 0x30F0, 0x30F1, 0x30F2, 0x30F3]);
		/** @private */
		public static function katakanaString(n:int):String
		{ return createTableAlphaString(n,katakanaData); }
		
		/** @private */
		public static const katakanaIrohaData:Vector.<int> = Vector.<int>([
			0x30A4, 0x30ED, 0x30CF, 0x30CB, 0x30DB, 0x30D8, 0x30C8, 0x30C1, 
			0x30EA, 0x30CC, 0x30EB, 0x30F2, 0x30EF, 0x30AB, 0x30E8, 0x30BF, 
			0x30EC, 0x30BD, 0x30C4, 0x30CD, 0x30CA, 0x30E9, 0x30E0, 0x30A6, 
			0x30F0, 0x30CE, 0x30AA, 0x30AF, 0x30E4, 0x30DE, 0x30B1, 0x30D5, 
			0x30B3, 0x30A8, 0x30C6, 0x30A2, 0x30B5, 0x30AD, 0x30E6, 0x30E1, 
			0x30DF, 0x30B7, 0x30F1, 0x30D2, 0x30E2, 0x30BB, 0x30B9 ]);
		/** @private */
		public static function katakanaIrohaString(n:int):String
		{ return createTableAlphaString(n,katakanaIrohaData); }
		
		/** @private */
		public static const lowerGreekData:Vector.<int> = Vector.<int>([
			0x03B1, 0x03B2, 0x03B3, 0x03B4, 0x03B5, 0x03B6, 0x03B7, 0x03B8, 
			0x03B9, 0x03BA, 0x03BB, 0x03BC, 0x03BD, 0x03BE, 0x03BF, 0x03C0, 
			0x03C1, 0x03C3, 0x03C4, 0x03C5, 0x03C6, 0x03C7, 0x03C8, 0x03C9  ]);
		/** @private */
		public static function lowerGreekString(n:int):String
		{ return createTableAlphaString(n,lowerGreekData); }
		
		/** @private */
		public static const upperGreekData:Vector.<int> = Vector.<int>([
			0x0391, 0x0392, 0x0393, 0x0394, 0x0395, 0x0396, 0x0397, 0x0398,
			0x0399, 0x039A, 0x039B, 0x039C, 0x039D, 0x039E, 0x039F, 0x03A0,
			0x03A1, 0x03A3, 0x03A4, 0x03A5, 0x03A6, 0x03A7, 0x03A8, 0x03A9 ]);
		/** @private */
		public static function upperGreekString(n:int):String
		{ return createTableAlphaString(n,upperGreekData); }
		
		/** @private */
		public static const algorithmicListStyles:Object = {
			"upperRoman":upperRomanString,
			"lowerRoman":lowerRomanString
		};
		
		/** @private */
		public static const numericListStyles:Object = {
			"arabicIndic":arabicIndicString,
			"bengali":bengaliString,				
			"decimal":decimalString,
			"decimalLeadingZero":decimalLeadingZeroString,
			"devanagari":devanagariString,
			"gujarati":gujaratiString,
			"gurmukhi":gurmukhiString,
			"kannada":kannadaString,
			"persian":persianString,
			"thai":thaiString,
			"urdu":urduString
		};
		
		/** @private */
		public static const alphabeticListStyles:Object = {
			"upperAlpha":upperAlphaString,
			"lowerAlpha":lowerAlphaString,
			"cjkEarthlyBranch":cjkEarthlyBranchString,
			"cjkHeavenlyStem":cjkHeavenlyStemString,
			"hangul":hangulString,
			"hangulConstant":hangulConstantString,
			"hiragana":hiraganaString,
			"hiraganaIroha":hiraganaIrohaString,
			"katakana":katakanaString,
			"katakanaIroha":katakanaIrohaString,
			"lowerGreek":lowerGreekString,
			"lowerLatin":lowerLatinString,
			"upperGreek":upperGreekString,
			"upperLatin":upperLatinString			
		};

		// they're all "." right now.  could remove this till its needed
		/** @private */
		public static const listSuffixes:Object = {
			"upperAlpha":"\u002E",
			"lowerAlpha":"\u002E",
			"upperRoman":"\u002E",
			"lowerRoman":"\u002E",
			"arabicIndic":"\u002E",
			"bengali":"\u002E",
			"decimal":"\u002E",
			"decimalLeadingZero":"\u002E",
			"devanagari":"\u002E",
			"gujarati":"\u002E",
			"gurmukhi":"\u002E",
			"kannada":"\u002E",
			"persian":"\u002E",
			"thai":"\u002E",
			"urdu":"\u002E",
			"cjkEarthlyBranch":"\u002E",
			"cjkHeavenlyStem":"\u002E",
			"hangul":"\u002E",
			"hangulConstant":"\u002E",
			"hiragana":"\u002E",
			"hiraganaIroha":"\u002E",
			"katakana":"\u002E",
			"katakanaIroha":"\u002E",
			"lowerGreek":"\u002E",
			"lowerLatin":"\u002E",
			"upperGreek":"\u002E",
			"upperLatin":"\u002E"
		};

		/** @private This function returns the string representing the list item's marker text */
		public function computeListItemText(child:IListItemElement,listMarkerFormat:IListMarkerFormat):String
		{
			CONFIG::debug { assert(child.parent == this,"computeListItemText: bad child"); }

			var listStyleType:String;
			var rslt:String;
			
			if (listMarkerFormat.content && listMarkerFormat.content.hasOwnProperty("counters"))
			{
				// chapter style numbering
				rslt = "";
				listStyleType = listMarkerFormat.content.ordered;				// may be null
				var suffixOverride:String = listMarkerFormat.content.suffix;	// may be null
				
				var list:ListElement = this;
				var childListMarkerFormat:IListMarkerFormat = listMarkerFormat;
				for (;;)
				{
					rslt = list.computeListItemTextSpecified(child,childListMarkerFormat,listStyleType == null ? list.computedFormat.listStyleType : listStyleType,suffixOverride) + rslt;
					// now look up
					child = list.getParentByType("ListItemElement") as IListItemElement;
					if (!child)
						break;
					list = child.parent as ListElement;
					childListMarkerFormat = child.computedListMarkerFormat();
				}
			}
			else
			{
				if (listMarkerFormat.content !== undefined)
				{
					if (listMarkerFormat.content == FormatValue.NONE)
						listStyleType = ListStyleType.NONE;
					else 
					{
						CONFIG::debug { assert(listMarkerFormat.content.hasOwnProperty("counter"),"Bad ListMarkerFormat.content property"); };
						listStyleType = listMarkerFormat.content.ordered;
					}
				}

				if (listStyleType == null)
					listStyleType = computedFormat.listStyleType;
				
				rslt = computeListItemTextSpecified(child,listMarkerFormat,listStyleType,null);
			}			
			var beforeContent:String = listMarkerFormat.beforeContent ? listMarkerFormat.beforeContent : "";
			var afterContent:String = listMarkerFormat.afterContent ? listMarkerFormat.afterContent : "";
			return beforeContent + rslt + afterContent;
		}
		
		/** @private - does the work with a known listStyleType and optional suffixOverride. */
		public function computeListItemTextSpecified(child:IListItemElement,listMarkerFormat:IListMarkerFormat,listStyleType:String,suffixOverride:String):String
		{
			var rslt:String;
			var val:* = constantListStyles[listStyleType];
			if (val !== undefined)
				rslt = val as String;
			else
			{
				CONFIG::debug { assert(listSuffixes[listStyleType] !== undefined,"missing suffix"); }
				
				var n:int = child.getListItemNumber(listMarkerFormat);
				var f:Function;
				
				// look in the the styles objects
				f = numericListStyles[listStyleType];
				if (f != null)
				{
					rslt = n < 0 ? "\u002d" + f(-n) : f(n);
				}
				else if (n <= 0)
				{
					rslt = n == 0 ? "0" : "\u002d" + decimalString(-n);
				}
				else
				{
					f = alphabeticListStyles[listStyleType];
					if (f != null)
						rslt = f(n);
					else
						rslt = algorithmicListStyles[listStyleType](n);
				}
				if (suffixOverride != null)
					rslt += suffixOverride;
				else if (listMarkerFormat.suffix != Suffix.NONE)
					rslt += listSuffixes[listStyleType];
			}
			
			return rslt;
		}
		
		/** @private */
		public function isNumberedList():Boolean
		{ return constantListStyles[computedFormat.listStyleType] === undefined; }
	}
}
