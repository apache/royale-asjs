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
	 *  Defines values for setting the <code>leadingModel</code> property
	 *  of the <code>TextLayoutFormat</code> class, composed of valid combinations of leading basis and leading direction.
	 *  Leading basis describes which baselines determine the leading (or <code>lineHeight</code>) of lines in a paragraph.
	 *  Leading direction specifies whether the <code>lineHeight</code> property refers to the distance of a line's 
	 *  baseline from that of the line before it or the line after it. 
	 *  <p>
	 *  <img src="../../../images/textLayout_baselines.jpg" alt="baselines" border="0"/>
	 *  <img src="../../../images/textLayout_LD1.jpg" alt="leadingDirection_1" border="0"/>
	 *  <img src="../../../images/textLayout_LD2.jpg" alt="leadingDirection_2" border="0"/>
	 *  <img src="../../../images/textLayout_LD3.jpg" alt="leadingDirection_3" border="0"/>
	 *  </p>
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @langversion 3.0 
	 * 
	 *  @see TextLayoutFormat#leadingModel
	 *  @see TextLayoutFormat#lineHeight
	 *  @see flash.text.TextField
	 *  @see org.apache.royale.text.engine.TextLine 
	 */
	 
	public final class LeadingModel
	{
		/** Specifies that leading basis is ROMAN and leading direction is UP. 
		 * In other words, <code>lineHeight</code> refers to the distance of a line's Roman baseline from the 
		 * previous line's Roman baseline.
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	  	 * @langversion 3.0 
	 	 */
	 	 
		public static const ROMAN_UP:String = "romanUp";
		
		/** Specifies that leading basis is IDEOGRAPHIC_TOP and leading direction is UP. 
		 *  In other words, <code>lineHeight</code> refers to the distance of a line's ideographic top 
		 *  baseline from the previous line's ideographic top baseline.
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
	 	 */
	 	 
		public static const IDEOGRAPHIC_TOP_UP:String = "ideographicTopUp";
		
		/** Specifies that leading basis is IDEOGRAPHIC_CENTER and leading direction is UP. 
		 * In other words, <code>lineHeight</code> refers to the distance of a line's ideographic center 
		 * baseline from the previous line's ideographic center baseline.
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
		public static const IDEOGRAPHIC_CENTER_UP:String = "ideographicCenterUp";
		
		/** Specifies that leading basis is IDEOGRAPHIC_TOP and leading direction is DOWN.
		 * In other words, <code>lineHeight</code> refers to the distance of a line's ideographic top baseline 
		 * from the next line's ideographic top baseline.
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
	 	 */
	 	 
		public static const IDEOGRAPHIC_TOP_DOWN:String = "ideographicTopDown";
		
		/** Specifies that leading basis is IDEOGRAPHIC_CENTER and leading direction is down.
		 *  In other words, <code>lineHeight</code> refers to the distance of a line's ideographic center 
		 *  baseline from the next line's ideographic center baseline.
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
	 	 */
	 	 
		public static const IDEOGRAPHIC_CENTER_DOWN:String = "ideographicCenterDown";
		
		/** Specifies that leading basis is ASCENT/DESCENT and leading direction is UP. 
		 *  In other words, <code>lineHeight</code> refers to the distance of a line's ascent baseline from the 
		 *  previous line's descent baseline.
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	  	 * @langversion 3.0 
	 	 */
	 	 
		public static const ASCENT_DESCENT_UP:String = "ascentDescentUp";
		
		/** Specifies that leading model is chosen automatically based on the paragraph's <code>locale</code> property.  
		 * For Japanese and Chinese, it is IDEOGRAPHIC_TOP_DOWN and for all others it is ROMAN_UP.
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
	 	 * 
	 	 * #IDEOGRAPHIC_TOP_DOWN
	 	 * #ROMAN_UP
	 	 */
	 	 
		public static const AUTO:String = "auto";
		
		/** Specifies a leading model that approximates the line spacing behavior of <code>TextField</code>.
		 * It is similar to <code>ASCENT_DESCENT_UP</code> in that <code>lineHeight</code> refers to the 
		 * distance of a line's ascent baseline from the previous line's descent baseline. However, baseline 
		 * positions approximate those determined by <code>TextField</code>, rather than using metrics 
		 * offered by <code>TextLine</code>.  
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0 
		 */
		public static const APPROXIMATE_TEXT_FIELD:String = "approximateTextField";
		
		/**  Specifies a leading model based on the CSS inline formatting model, which involves stacking <i>line boxes</i> contiguously.
		 * A <i>line box</i> is defined as the bounding box around <i>inline boxes</i> for all leaf elements on the text line, after they have been aligned
		 * using <code>baselineShift</code>, <code>dominantBaseline</code>, <code>alignmentBaseline</code> etc. For a span, the <i>inline box</i> 
		 * is obtained by applying leading equally above and below the text content such that its height equals <code>lineHeight</code>.
		 * For an inline graphic, <code>lineHeight</code> is ignored; the <i>inline box</i> is derived from its specified dimensions and padding values.
		 * Also, <code>firstBaselineOffset</code> is ignored with this leading model.
		 * 
         * <p>For more information, see <a href='http://blogs.adobe.com/tlf/2010/11/box-leading-model.html'>Box leading model</a>.</p>
         * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		public static const BOX:String = "box";
		
	}
}
