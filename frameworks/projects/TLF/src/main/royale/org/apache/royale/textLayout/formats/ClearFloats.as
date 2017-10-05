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
	 *  Defines values for setting the <code>clear</code> property
     *  of the <code>TextLayoutFormat</code> class. This property controls 
	 *  how text wraps around floats.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
     * 
     * @see org.apache.royale.textLayout.elements.InlineGraphicElement#float 
	 * @see TextLayoutFormat#clear 
	 */
	public final class ClearFloats
	{
        /** Specifies that  text wraps closely around floats.
		 * 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		
		public static const NONE:String = "none";
		
        /** Specifies that text skips over left floats.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		
		public static const LEFT:String = "left";
		
        /** Specifies that text skips over right floats.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		
		public static const RIGHT:String = "right";
		
        /** Specifies that text skips over floats on the start side in reading order (left if direction is "ltr", right if direction is "rtl").
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		
		public static const START:String = "start";

        /** Specifies that text skips over floats on the start side in reading order (left if direction is "ltr", right if direction is "rtl").
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		
		public static const END:String = "end";
		
        /** Specifies that text skips over any float.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		
		public static const BOTH:String = "both";
	}
}
