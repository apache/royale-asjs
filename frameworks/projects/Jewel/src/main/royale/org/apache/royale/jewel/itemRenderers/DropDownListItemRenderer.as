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
package org.apache.royale.jewel.itemRenderers
{
    COMPILE::JS
    {
    import org.apache.royale.core.WrappedHTMLElement;
    import org.apache.royale.jewel.beads.views.DropDownListView;            
    }
    import org.apache.royale.html.elements.Option;
    import org.apache.royale.core.StyledMXMLItemRenderer;

    /**
     *  The DropDownListItemRenderer class creates a DropDownList menu item
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */    
	public class DropDownListItemRenderer extends StyledMXMLItemRenderer
	{
        public static const OPTION_DISABLED:String = "DropDownList.Select.Default.Prompt";

        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function DropDownListItemRenderer()
		{
			super();
            typeNames = "jewel item";
        }

        protected var item:Option;

        /**
         *  Sets the data value and uses the String version of the data for display.
         *
         *  @param Object data The object being displayed by the itemRenderer instance.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
        override public function set data(value:Object):void
        {
            super.data = value;

            if(value == OPTION_DISABLED)
            {
                COMPILE::JS
                {
                var view:DropDownListView = DropDownListView(itemRendererOwnerView);
                // item.element.setAttribute("disabled", "");
                item.element.setAttribute("selected", "");
                item.element.setAttribute("hidden", "");
                item.text = view.prompt;
                }
            } else
            {
                if (labelField)
                {
                    item.text = String(value[labelField]);
                }
                else
                {
                    item.text = String(value);
                }

                COMPILE::JS
                {
                    if (dataField)
                    {
                        item.element["value"] = String(value[dataField]);
                    }
                    else
                    {
                        item.element["value"] = String(value);
                    }
                }
            }
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            item = new Option();

            element = item.element as WrappedHTMLElement;
            return element;
        }
	}
}
