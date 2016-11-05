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
package org.apache.flex.utils
{
	/**
	 *  The URLUtils class is a collection of static functions that wrap dealing with object URLs in the browser.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.7
	 */
	COMPILE::JS
	public class URLUtils
	{
		/**
		 * Creates an object URL for of a blob or a file
		 * @param  blobOrFile:* The blob of file
		 * @param  win:*=null   The active window can be optionally specified
		 * @return              The object URL
		 */
		public static function createObjectURL(blobOrFile:*,win:*=null):String
		{
			win = win || window;
			if(win["URL"])
				return win["URL"].createObjectURL(blobOrFile);
			if(win.webkitURL)
				return win.webkitURL.createObjectURL(blobOrFile);

			return "";
		}
		public static function revokeObjectURL(objectURL:String,win:*=null):void
		{
			win = win || window;
			if(win["URL"])
				win["URL"].revokeObjectURL(objectURL);
			if(win.webkitURL)
				win.webkitURL.revokeObjectURL(objectURL);
		}
	}

}

