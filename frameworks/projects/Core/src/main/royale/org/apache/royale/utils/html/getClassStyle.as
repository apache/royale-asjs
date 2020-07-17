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
package org.apache.royale.utils.html
{
	/**
	 * Get an Object with all styles in a CSS className.
	 * classname must match exactly the selector used in the CSS
	 * 
	 * Note that due to CORS restrictions im Chrome, if you're working offline you need to
	 * use: chrome --allow-file-access-from-files, or other browser
	 * 
	 * @royalesuppressexport
	 */
	COMPILE::JS
	public function getClassStyle(className:String):Object
	{
		var cssText:String = "";
		var classes:Array = document.styleSheets[0].rules || document.styleSheets[0].cssRules;
		for (var x:int = 0; x < classes.length; x++) {        
			if (classes[x].selectorText == className) {
				cssText += classes[x].cssText || classes[x].style.cssText;
			}         
		}
		
		// remove all text in css and left just the content between "{" "}"
		var array:Array = cssText.match(/\{ (.*?)\}/);
		// then split all styles
		array = array[1].split("; ");
		//remove latest since is empty
		array.pop();
		
		//create the return object and split each style in property and value and insert in object
		var o:Object = {};
        for (x = 0; x < array.length; x++) {
            var prop:Array = array[x].split(": ");
            o[prop[0]] = prop[1];
        }
		
		return o;
	}
}
