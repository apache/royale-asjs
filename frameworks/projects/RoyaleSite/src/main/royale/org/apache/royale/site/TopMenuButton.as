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
    
    [DefaultProperty("htmlText")]
    
	/**
	 * The TopMenuButton is a button used in the TopMenu in the
     * Apache Royale site.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class TopMenuButton extends UIBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function TopMenuButton()
		{
			super();
			
			typeNames = "TopMenuButton";
		}
		
        private var _htmlText:String;
        
        /**
         * the html content for the tile.
         */
        public function get htmlText():String
        {
            return _htmlText;
        }
        public function set htmlText(value:String):void
        {
            _htmlText = value;
        }
        
        private var _href:String;
        
        /**
         * the href for the button.
         */
        public function get href():String
        {
            return _href;
        }
        public function set href(value:String):void
        {
            _href = value;
        }
        
        /**
         * @return The actual element to be parented.
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         * @royaleignorecoercion HTMLLIElement
         */
        COMPILE::JS
		override protected function createElement():WrappedHTMLElement
		{
            var li:HTMLLIElement = document.createElement("li") as HTMLLIElement;
            element = li as WrappedHTMLElement;
            return element;
        }
        
        /**
         * @royaleignorecoercion HTMLAnchorElement
         */
        COMPILE::JS
        override public function addedToParent():void
        {
            super.addedToParent();
            var anchor:HTMLAnchorElement = document.createElement("a") as HTMLAnchorElement;
            anchor.className = "TopMenuButtonContent";
            anchor.href = href;
            anchor.textContent = htmlText;
            element.appendChild(anchor);
		}
		
	}
}
