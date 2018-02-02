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
    import org.apache.royale.core.UIBase;

    [DefaultProperty("mxmlContent|innerHTML")]
    
    public class TextNodeContainerBase extends NodeElementBase
    {
        public function TextNodeContainerBase()
        {
            super();
        }

        private var _text:String = "";

        /**
         *  The text of the element
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get text():String
		{
            return _text;
		}
		public function set text(value:String):void
		{
            _text = value;

			COMPILE::JS
			{
                if(textNode == null)
                {
                    textNode = document.createTextNode('') as Text;
                    element.appendChild(textNode);
                }
                
                textNode.nodeValue = value;	
			}
		}
		
        COMPILE::JS
        protected var textNode:Text;

        COMPILE::SWF
		private var _html:String = "";

        /**
         *  Sets the HTML of the Div
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9
		 */
		public function get innerHTML():String
		{
            COMPILE::SWF
            {
    			return _html;
            }
			COMPILE::JS
			{
				return element.innerHTML;
			}
		}
		public function set innerHTML(value:String):void
		{
            COMPILE::SWF
            {
    			_html = value;
            }

			COMPILE::JS
			{
				element.innerHTML = value;
			}
		}

    }
}