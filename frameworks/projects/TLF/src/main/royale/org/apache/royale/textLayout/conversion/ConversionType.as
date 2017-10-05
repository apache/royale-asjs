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
package org.apache.royale.textLayout.conversion
{
	/**
	 * Values for the format of exported text.
	 * The values <code>STRING_TYPE</code> and <code>XML_TYPE</code> 
	 * can be used for the <code>conversionType</code> parameter for 
	 * the export() method in the ITextExporter interface and the
	 * TextConverter class.
	 *
	 * @see org.apache.royale.textLayout.conversion.ITextExporter#export()
	 * @see org.apache.royale.textLayout.conversion.TextConverter#export()
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */
	public final class ConversionType
	{
		/** 
		 * Export as type String. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		public static const STRING_TYPE:String = "stringType";		
		/** 
		 * Export as type XML.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
	 	 * @langversion 3.0
		 */
		public static const XML_TYPE:String = "xmlType";				
	}
}
