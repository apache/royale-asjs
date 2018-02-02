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
package org.apache.royale.site.responsiveTableClasses
{	
	import org.apache.royale.core.UIBase;
	
	/**
	 * The ResponsiveTableTileText displays the text in a
	 * ResponsiveTableTile.
	 * It is used on the home page of the Apache Royale site.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ResponsiveTableTileText extends UIBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ResponsiveTableTileText()
		{
			super();
			
			typeNames = "ResponsiveTableTileText";
		}
		
        private var _title:String;
        
        /**
         * the title for the tile.
         */
        public function get title():String
        {
            return _title;
        }
        public function set title(value:String):void
        {
            _title = value;
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
        		
        COMPILE::JS
		override public function addedToParent():void
		{
			super.addedToParent();
			var titleElement:ResponsiveTableTileTitle = new ResponsiveTableTileTitle();
            titleElement.element.innerHTML = title;
            addElement(titleElement);
            var content:ResponsiveTableTileContent = new ResponsiveTableTileContent();
            content.element.innerHTML = htmlText;
            addElement(content);
		}
		
	}
}
