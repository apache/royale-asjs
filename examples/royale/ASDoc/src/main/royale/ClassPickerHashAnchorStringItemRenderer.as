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
package
{
import models.ASDocModel;
import  org.apache.royale.html.supportClasses.StringItemRenderer;

	/**
	 *  The HashAnchorStringItemRenderer class displays data in string form using the data's toString()
	 *  function.  It assumes the data is an encoding of class, package or function name and
	 *  sets up the renderer so the controller logic will open the right document.  On JS, by
	 *  using anchor tags, it should allow the browser to dictate permalinks and allow
	 *  search engines to crawl the app.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ClassPickerHashAnchorStringItemRenderer extends StringItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ClassPickerHashAnchorStringItemRenderer()
		{
			typeNames += " HashAnchorStringItemRenderer"
		}

		override public function set text(value:String):void
		{
            COMPILE::SWF
            {
                textField.text = value;
            }
            COMPILE::JS
            {
            	var pkg:String = "";
            	var cname:String = value;
            	var href:String = value;
            	var c:int = href.lastIndexOf(".");
            	if (c != -1)
            	{
            		pkg = href.substr(0, c);
            		cname = href.substr(c+1);
            		href = pkg + ASDocModel.DELIMITER + cname;
            	}
            	else
            	{
            		href = ASDocModel.DELIMITER + cname;
            	} 
                this.element.innerHTML = "<a href='#!" + href + "' class='HashAnchorAnchor'>" + value + "</a>";
            }
		}

	}
}
