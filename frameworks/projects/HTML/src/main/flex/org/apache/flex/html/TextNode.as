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
package org.apache.flex.html
{
	import org.apache.flex.core.ContainerBase;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
    }

    [DefaultProperty("text")]

	/**
	 *  The TextNode class represents an HTML Text node element
     *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class TextNode extends ContainerBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function TextNode()
		{
			super();
		}
		
        private var _text:String = "";

        /**
         *  The text of the heading
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
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
                textNode.nodeValue = text;	
			}

		}
		
        COMPILE::JS
        private var textNode:Text;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			textNode = document.createTextNode('') as Text;

            element = textNode as WrappedHTMLElement;

            positioner = element;
            element.flexjs_wrapper = this;
            
            return element;
        }
    }
}
