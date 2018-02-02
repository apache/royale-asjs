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
    import org.apache.royale.site.responsiveTableClasses.ResponsiveTableTileIcon;
    import org.apache.royale.site.responsiveTableClasses.ResponsiveTableTileText;
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
    }
	
	[DefaultProperty("htmlText")]
	
	/**
	 * The ResponsiveTableTile displays a tile with one
	 * or two icons a title, and some content.
	 * It is used on the home page of the Apache Royale site.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ResponsiveTableTile extends UIBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ResponsiveTableTile()
		{
			super();
			
			typeNames = "ResponsiveTableTile";
		}
		
		private var _icon1:String;
		
		/**
		 * the FontAwesome 'style' (e.g. fa_university)
		 * for the first icon in the tile.
		 */
		public function get icon1():String
		{
			return _icon1;
		}
		public function set icon1(value:String):void
		{
			_icon1 = value;
		}
				
		private var _icon2:String;
		
		/**
		 * the FontAwesome 'style' (e.g. fa_mobile)
		 * for the second icon in the tile.
		 */
		public function get icon2():String
		{
			return _icon2;
		}
		public function set icon2(value:String):void
		{
			_icon2 = value;
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
		
        /**
         * @return The actual element to be parented.
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            addElementToWrapper(this,'div');
            return element;
        }
        
		private var icons:ResponsiveTableTileIcon;
		private var textContent:ResponsiveTableTileText;
		
		override public function addedToParent():void
		{
			super.addedToParent();
			icons = new ResponsiveTableTileIcon();
			icons.icon1 = icon1;
			icons.icon2 = icon2;
            addElement(icons);
			textContent = new ResponsiveTableTileText;
			textContent.title = title;
			textContent.htmlText = htmlText;
            addElement(textContent);
		}
		
	}
}
