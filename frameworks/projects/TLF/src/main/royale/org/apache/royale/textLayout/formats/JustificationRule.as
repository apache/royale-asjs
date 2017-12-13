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
	 *  Defines values for setting the <code>justificationRule</code> property
	 *  of the TextLayoutFormat class. Default value is SPACE, which accomplishes justification by adding 
	 *  extra space to the space characters. When you use EAST_ASIAN, Japanese style leading is employed, which 
	 *  applies bottom-down as opposed to top-up, which is used in Roman text. The spacing of punctuation is also 
	 *  different. In the Roman version, the comma and Japanese periods take a full character's width but only half 
	 *  in East Asian. Additionally, the spacing between sequential punctuation marks becomes tighter, obeying traditional 
	 *  East Asian typographic conventions. Also note the leading, applied to the second line of the paragraphs in the 
	 *  example below. In the East Asian version, the last two lines push left. In the Roman version, the second and 
	 *  following lines push left.
	 *  <p><img src="../../../images/textLayout_justificationrule.png" alt="justificationRule" /></p>
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 *
	 * @see TextLayoutFormat#justificationRule
	 */
	public final class JustificationRule
	{
		/** Specifies East Asian justification rules. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
		public static const EAST_ASIAN:String = "eastAsian";
		
		/** Specifies justification for Latin and other horizontal scripts that divide words using spaces. 
		 *  Use this value for everything except East Asian text.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
		public static const SPACE:String = "space";
	}
}
