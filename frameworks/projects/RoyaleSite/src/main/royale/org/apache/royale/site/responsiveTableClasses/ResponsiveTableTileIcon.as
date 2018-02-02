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
	 * The ResponsiveTableTileIcon displays the icons in a
	 * ResponsiveTableTile.
	 * It is used on the home page of the Apache Royale site.
	 * 
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ResponsiveTableTileIcon extends UIBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ResponsiveTableTileIcon()
		{
			super();
			
			typeNames = "ResponsiveTableTileIcon";
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
		
        /**
         * @return The actual element to be parented.
         * @royaleignorecoercion HTMLSpanElement
         * @royaleignorecoercion HTMLBRElement
         */
        COMPILE::JS
		override public function addedToParent():void
		{
			super.addedToParent();
			var span:HTMLSpanElement = document.createElement("span") as HTMLSpanElement;
            span.className = "fa " + icon1;
            element.appendChild(span);
            if (icon2)
            {
                var br:HTMLBRElement = document.createElement("br") as HTMLBRElement;
                element.appendChild(br);
                span = document.createElement("span") as HTMLSpanElement;
                span.className = "fa " + icon2;
                element.appendChild(span);
            }
		}
		
	}
}
