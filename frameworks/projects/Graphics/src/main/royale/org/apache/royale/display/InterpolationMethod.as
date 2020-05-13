/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.royale.display
{
	
	/**
	 * @royalesuppressexport
	 */
	public class InterpolationMethod
	{
		/**
		 * Specifies that the linear RGB interpolation method should be used.
		 * This means that an RGB color space based on a linear RGB color model is used.
		 */
		public static const LINEAR_RGB:String = "linearRGB";
		
		/**
		 * Specifies that the RGB interpolation method should be used.
		 * This means that the gradient is rendered with exponential sRGB (standard RGB) space.
		 * The sRGB space is a W3C-endorsed standard that defines a non-linear conversion between
		 * red, green, and blue component values and the actual intensity of the visible component color.
		 */
		public static const RGB:String = "rgb";
		

    }
	
}


