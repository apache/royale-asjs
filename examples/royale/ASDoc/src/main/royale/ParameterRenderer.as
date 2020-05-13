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
import  org.apache.royale.html.DataContainer;

	/**
	 *  The AttributeRenderer class displays an ASDoc attribute.  
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.0
	 */
	public class ParameterRenderer extends StringItemRenderer implements IOwnerViewItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 */
		public function ParameterRenderer()
		{
			typeNames = "AttributeRenderer"
		}

		override public function set text(value:String):void
		{
			var last:Boolean = false;
			if (itemRendererOwnerView)
			{
				var n:int = (itemRendererOwnerView.host as DataContainer).dataProvider.length;
				last = n == index + 1; 
			}			
			var html:String = "<span class='paramName'>" + data.name + ":</span>";
			if (data.typehref)
				html += "<a href='" + data.typehref + "' class='paramLink'>" + data.type + "</a>";
			else
				html += "<span class='paramType'>" + data.type + "</span>";
			if (!last)
			    html += ", ";
            COMPILE::SWF
            {
                textField.htmlText = value;
            }
            COMPILE::JS
            {
                this.element.innerHTML = html;
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
