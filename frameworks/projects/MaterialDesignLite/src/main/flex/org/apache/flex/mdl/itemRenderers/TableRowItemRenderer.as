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
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;        
    }

	import org.apache.flex.html.supportClasses.MXMLItemRenderer;
    
	/**
	 *  The TableItemRenderer defines the basic Item Renderer for a MDL Table Component.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class TableRowItemRenderer extends MXMLItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function TableRowItemRenderer()
		{
			super();
		}
		
		private var _text:String = "";

        /**
         *  The text of the item renderer
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function get text():String
		{
            return _text;
		}

		public function set text(value:String):void
		{
             _text = value;
		}

		COMPILE::JS
        private var textNode:Text;

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
			if (labelField || dataField) {
                text = String(value[labelField]);
            } else {
                text = String(value);
            }
            
			COMPILE::JS
			{
				if(textNode != null)
				{
					textNode.nodeValue = text;
				}	
			}
		}

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 * @flexjsignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            if(MXMLDescriptor == null)
			{
                positioner = document.createElement('tr') as WrappedHTMLElement;
                element = document.createElement('td') as WrappedHTMLElement;
                element.classList.add("mdl-data-table__cell--non-numeric");

                positioner.appendChild(element);

				textNode = document.createTextNode('') as Text;
				element.appendChild(textNode);
                element.flexjs_wrapper = this;
                return positioner;
			} else {
                element = document.createElement('tr') as WrappedHTMLElement;
                
                positioner = element;

                element.flexjs_wrapper = this;

                return element;
            }
        }
	}
}
