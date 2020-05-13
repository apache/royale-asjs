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
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
    }

    /**
     *  The CloseButton class is Button that displays an X
     *  and is commonly used in a Panel's TitleBar.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class CloseButton extends Button
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function CloseButton()
		{
			super();
            typeNames = "Button CloseButton";
		}
        /**
         * @royaleignorecoercion HTMLImageElement
         */
		COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			addElementToWrapper(this,'button');
            element.setAttribute('type', 'button');
            element.style.lineHeight = "0";
            element.style.padding = "0";
			var data:String = 'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCA2MCA2MCI+PHBvbHlnb24gcG9pbnRzPSI2MCA2LjIyIDUzLjc4IDAgMzAgMjMuNzcgNi4yMiAwIDAgNi4yMiAyMy43OCAzMCAwIDUzLjc4IDYuMjIgNjAgMzAgMzYuMjMgNTMuNzggNjAgNjAgNTMuNzggMzYuMjIgMzAgNjAgNi4yMiIvPjwvc3ZnPg==';
            var img:HTMLImageElement = document.createElement("img") as HTMLImageElement;
            img.style.cssText = 'height:60%;width:60%';
            img.src = data;
            element.appendChild(img);
            return element;
        }
	}
}
