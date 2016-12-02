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
package org.apache.flex.mdl
{
	import org.apache.flex.core.UIBase;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
    }

	/**
	 *  The Tooltip class represents
     *  
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class Tooltip extends UIBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function Tooltip()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
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
		
        private var _dataMdlFor:String;
		/**
		 *  The id value of the associated button that opens this menu.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function get dataMdlFor():String
		{
			return _dataMdlFor;
		}
		public function set dataMdlFor(value:String):void
		{
			_dataMdlFor = value;

            COMPILE::JS
            {
                element.setAttribute('for', dataMdlFor);
            }
		}

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 * @flexjsignorecoercion HTMLDivElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = 'mdl-tooltip';

			var div:HTMLElement = document.createElement('div') as HTMLDivElement;
            
            textNode = document.createTextNode('') as Text;
            div.appendChild(textNode); 

			element = div as WrappedHTMLElement;
            element.setAttribute('for', dataMdlFor);
            
            positioner = element;
            element.flexjs_wrapper = this;
            
            return element;
        }
    }
}
