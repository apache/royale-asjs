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
     *  Defines values for the <code>float</code> property
	 *  of the InlineGraphicElement class. 
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 * @see org.apache.royale.textLayout.elements.InlineGrapicElement
	 */
	public final class Float
	{
        /** Graphic appears inline in the text (doesn't float). */
		public static const NONE:String = "none";		
        /** Graphic floats on the left side of the text. */
		public static const LEFT:String = "left";
        /** Graphic floats on the right side of the text. */
		public static const RIGHT:String = "right";
        /** Graphic floats on the leading side of the text 
         * (left if paragraph direction is "ltr", right if paragraph direction is "rtl"). 
		 */
		public static const START:String = "start";
        /** Graphic floats on the trailing side of the text 
        * (right if paragraph direction is "ltr", left if paragraph direction is "rtl"). 
		*/
		public static const END:String = "end";
	}
}
