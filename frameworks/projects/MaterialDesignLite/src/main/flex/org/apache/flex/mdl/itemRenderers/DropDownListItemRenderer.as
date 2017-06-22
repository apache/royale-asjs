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
package org.apache.flex.mdl.itemRenderers
{
    import org.apache.flex.html.supportClasses.MXMLItemRenderer;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
    }
	
    /**
     *  The DropDownListItemRenderer class creates a DropDownList menu item
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */    
	public class DropDownListItemRenderer extends MXMLItemRenderer
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function DropDownListItemRenderer()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
        }
        
        private var _text:String = "";

        /**
         *  The text of the menu item
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function get text():String
		{
            COMPILE::SWF
            {
                return _text;
            }
            COMPILE::JS
            {
                return textNode.nodeValue;
            }
		}

		public function set text(value:String):void
		{
            COMPILE::SWF
            {
                _text = value;
            }
            COMPILE::JS
            {
                textNode.nodeValue = value;
            }
		}

        COMPILE::JS
        private var textNode:Text;

        COMPILE::JS
        private var item:HTMLOptionElement;

        /**
         *  Sets the data value and uses the String version of the data for display.
         *
         *  @param Object data The object being displayed by the itemRenderer instance.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        override public function set data(value:Object):void
        {
            super.data = value;

            var text:String;
            if (labelField)
            {
                text = String(value[labelField]);
            }
            else
            {
                text = String(value);
            }

            COMPILE::JS
            {
                if (dataField)
                {
                    item.value = String(value[dataField]);
                }
                else
                {
                    item.value = String(value);
                }

                if(textNode != null)
                {
                    textNode.nodeValue = text;
                }
            }
        }

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLOptionElement
         *
		 * @flexjsignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            item = document.createElement('option') as HTMLOptionElement;
            
            textNode = document.createTextNode('') as Text;
            item.appendChild(textNode);

            element = item as WrappedHTMLElement;

            positioner = element;
            element.flexjs_wrapper = this;
            
            return element;
        }
	}
}
