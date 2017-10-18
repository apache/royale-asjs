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
	 *  Defines values for specifying that a formatting property is to inherit its parent's value or have it's value
	 *  generated automatically. The <code>INHERIT</code> constant specifies that a property inherits its parent's value 
	 *  while the <code>AUTO</code> constant specifies that an internal algorithm automatically determine the property's 
	 *  value. As one example, you can set <code>TextLayoutFormat.columnWidth</code> using these values. Typically, a 
	 *  property's description indicates whether it accepts these constants.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0 
	 *
	 * @see org.apache.royale.textLayout.formats.TextLayoutFormat TextLayoutFormat
	 */
	 
	public final class FormatValue
	{
		/** Specifies that a property's value is automatically generated. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
		public static const AUTO:String = "auto";
		
		/** Specifies that a property is to inherit its parent's value.
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		 
		public static const INHERIT:String = "inherit";
		
		/** Specifies that a property's value is none. 
		 *
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0 
		 */
		
		public static const NONE:String = "none";
	}
}
