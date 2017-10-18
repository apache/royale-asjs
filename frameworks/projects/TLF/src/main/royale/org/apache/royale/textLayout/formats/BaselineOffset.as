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
	 *  Defines values for the <code>firstBaselineOffset</code> property
	 *  of the <code>TextLayoutFormat</code> and <code>ContainerFormattedElement</code> classes. 
	 *  Determines the offset from the top inset of the container
	 *  to the baseline of the first line. Baseline offset may be specified as 
	 *  the ascent of the line, the height of the line, or an auto generated amount.
	 *  <p>
	 *  <img src="../../../images/textLayout_FBO1.jpg" alt="firstBaselineOffset_1" border="0"/>
	 *  <img src="../../../images/textLayout_FBO2.jpg" alt="firstBaselineOffset_2" border="0"/>
	 *  <img src="../../../images/textLayout_FBO3.jpg" alt="firstBaselineOffset_3" border="0"/>
	 *  <img src="../../../images/textLayout_FBO4.jpg" alt="firstBaselineOffset_4" border="0"/>
	 *  </p>
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 *  @see TextLayoutFormat#firstBaselineOffset
	 */
	public final class BaselineOffset
	{
		/** Aligns the ascent of the line with the container top inset.
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public static const AUTO:String = "auto";
		
		/** Specifies an offset equal to the ascent of the line, that is, the ascent of the tallest font in the line, accounting for inline graphics as having the bottom of the graphic on the baseline.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		 
		public static const ASCENT:String = "ascent";
		
		/** Specifies an offset equal to the height of the line.
		 *
		 * @playerversion Flash 10
	 	 * @playerversion AIR 1.5
	 	 * @langversion 3.0
	 	 */
	 	 
		public static const LINE_HEIGHT:String = "lineHeight";		
	}
}
