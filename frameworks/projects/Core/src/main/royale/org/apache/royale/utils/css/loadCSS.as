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
package org.apache.royale.utils.css
{
	/**
	 * Utility function to dynamically load CSS in your application.
	 * 
	 * @param url The url of the css file.
	 * @param callback (optional) the function to be called when the code is loaded.
	 * 
	 * @langversion 3.0
	 * @productversion Royale 0.9.6
	 * @royalesuppressexport
	 * @royaleignorecoercion HTMLLinkElement
	 */
	COMPILE::JS
	public function loadCSS(url:String, callback:Function = null):String
	{
		var link:HTMLLinkElement = document.createElement('link') as HTMLLinkElement;
		link.setAttribute('rel', 'stylesheet');
		link.setAttribute('type', 'text/css');
		link.setAttribute('href', url);
		link.id = 'link' + new Date().getTime();
		if (callback)
		{
			link.onload = callback;
		}
		document.head.appendChild(link);
		return link.id;
	}
}