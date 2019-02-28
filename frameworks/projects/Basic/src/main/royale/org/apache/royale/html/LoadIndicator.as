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
package org.apache.royale.html
{
	
	import org.apache.royale.core.UIBase;
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}
	
    /**
     *  The loader class provides an animated indicator
     *
     *  @toplevel
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.6
     */
	public class LoadIndicator extends UIBase
	{
		public function LoadIndicator()
		{
		}
		
		COMPILE::JS
		/**
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		override protected function createElement():WrappedHTMLElement
		{
			element = document.createElementNS('http://www.w3.org/2000/svg', 'svg') as WrappedHTMLElement;
			
			// initially undefined could be set to null
			if (positioner == null)
				positioner = element;
			element.setAttribute("viewBox","0 0 50 50");
			element.innerHTML = '<path fill="#FF6700" d="M25.251,6.461c-10.318,0-18.683,8.365-18.683,18.683h4.068c0-8.071,6.543-14.615,14.615-14.615V6.461z"><animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 25 25" to="360 25 25" dur="0.6s" repeatCount="indefinite"/></path>';
			return positioner;
		}
	}
}
