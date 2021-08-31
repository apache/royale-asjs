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
package org.apache.royale.site
{	
	import org.apache.royale.core.UIBase;
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
    }
	
	/**
	 * The SocialButtons is set of social media related
     * buttons used in the
     * Apache Royale site.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class SocialButtons extends UIBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function SocialButtons()
		{
			super();
			
			typeNames = "SocialButtons";
		}
		

        /**
         * @return The actual element to be parented.
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLUListElement
         * @royaleignorecoercion HTMLLIElement
         */
        COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
            var ul:HTMLUListElement = document.createElement("ul") as HTMLUListElement;
            element = ul as WrappedHTMLElement;
            var li:HTMLLIElement = document.createElement("li") as HTMLLIElement;
            li.className = "fa SocialButton fa-search";
            li.innerHTML = "<a href='https://royale.apache.org/#grve-search-modal'></a>";
            element.appendChild(li);
            li = document.createElement("li") as HTMLLIElement;
            li.className = "fa SocialButton fa-share-alt";
            li.innerHTML = "<a href='https://royale.apache.org/#grve-social-modal'></a>";
            element.appendChild(li);
            li = document.createElement("li") as HTMLLIElement;
            li.className = "fa SocialButton fa-th";
            li.innerHTML = "<a href='https://royale.apache.org/#grve-toggle-menu'></a>";
            element.appendChild(li);
			return element;
		}
		
	}
}
