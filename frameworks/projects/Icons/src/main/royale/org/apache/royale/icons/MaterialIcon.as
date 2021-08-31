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
package org.apache.royale.icons
{
    /**
     *  A Material based icon can be used alone or in buttons and other controls 
     *  
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     *  
     */
    public class MaterialIcon extends FontIconBase
    {
        /**
         *  constructor.
         * 
         *  <inject_script>
         *  var link = document.createElement("link");
         *  link.setAttribute("rel", "stylesheet");
         *  link.setAttribute("type", "text/css");
         *  link.setAttribute("href", "https://fonts.googleapis.com/icon?family=Material+Icons");
         *  document.head.appendChild(link);
         *  </inject_script>
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function MaterialIcon()
        {
            super();

            // Since in IE11 this font only works with that class name strangely.
            // It seems we can avoid this self-hosting the fonts @see https://google.github.io/material-design-icons/ 
            // but we must think if this is or not the right way.
            typeNames = "fonticon material-icons";
        }

        /**
         *  The text of the icon
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        override public function set text(value:String):void
		{
            super.text = value;

			COMPILE::JS
			{
            textNode.textContent = _text;	
			}
		}  
    }
}
