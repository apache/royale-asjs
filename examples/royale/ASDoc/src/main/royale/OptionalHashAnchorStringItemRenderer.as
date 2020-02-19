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
import  org.apache.royale.core.IOwnerViewItemRenderer;
import  org.apache.royale.core.IItemRendererOwnerView;
import  org.apache.royale.html.supportClasses.StringItemRenderer;
import  org.apache.royale.html.List;

	/**
	 *  The OptionalHashAnchorStringItemRenderer class displays data in string form using the data's toString()
	 *  function.  It assumes the data is a class and
	 *  sets up the renderer so the controller logic will open the right document.  On JS, by
	 *  using anchor tags, it should allow the browser to dictate permalinks and allow
	 *  search engines to crawl the app.  If no href is available, then no anchor is used.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class OptionalHashAnchorStringItemRenderer extends StringItemRenderer implements IOwnerViewItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function OptionalHashAnchorStringItemRenderer()
		{
			typeNames += " OptionalHashAnchorStringItemRenderer"
		}

		override public function set text(value:String):void
		{
			var last:Boolean = false;
			if (itemRendererOwnerView)
			{
				var n:int = (parent as List).dataProvider.length;
				last = n == index + 1; 
			}
            COMPILE::SWF
            {
                textField.text = value;
            }
            COMPILE::JS
            {
            	var href:String = data.href;
            	if (!href) 
            		this.element.innerHTML = value + (last ? "" : " -> ");
            	else
	                this.element.innerHTML = "<a href='#!" + href + "' class='HashAnchorAnchor'>" + value + "</a>" + (last ? "" : " -> ");
            }
		}
		
		private var _itemRendererOwnerView:IItemRendererOwnerView;
        
        /**
         *  The text of the renderer
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        public function get itemRendererOwnerView():IItemRendererOwnerView
        {
            return _itemRendererOwnerView;
        }
        
        public function set itemRendererOwnerView(value:IItemRendererOwnerView):void
        {
            _itemRendererOwnerView = value;
        }


	}
}
