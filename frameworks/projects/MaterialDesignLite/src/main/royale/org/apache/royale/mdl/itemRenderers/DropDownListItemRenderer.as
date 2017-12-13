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
package org.apache.royale.mdl.itemRenderers
{
    import org.apache.royale.html.elements.Option;
    import org.apache.royale.html.supportClasses.MXMLItemRenderer;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;            
    }
	
    /**
     *  The DropDownListItemRenderer class creates a DropDownList menu item
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */    
	public class DropDownListItemRenderer extends MXMLItemRenderer
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function DropDownListItemRenderer()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
        }

        private var item:Option;

        /**
         *  Sets the data value and uses the String version of the data for display.
         *
         *  @param Object data The object being displayed by the itemRenderer instance.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        override public function set data(value:Object):void
        {
            super.data = value;

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
