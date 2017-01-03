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
package org.apache.flex.fa
{
    import org.apache.flex.core.UIBase;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
    }

    /**
     *  Provide common features for all FontAwesome icons type
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public class FontAwesomeIcon extends UIBase
    {
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         *
         *  @flexjsignorecoercion HTMLElement
         */
        public function FontAwesomeIcon()
        {
            super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
        }

        COMPILE::JS
        protected var textNode:Text;
		protected var _iconText:String;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 * @flexjsignorecoercion HTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "";

			var i:HTMLElement = document.createElement('i') as HTMLElement;
            
            textNode = document.createTextNode(iconText) as Text;
            i.appendChild(textNode); 

			element = i as WrappedHTMLElement;
            
            positioner = element;
			element.flexjs_wrapper = this;
            
            return element;
        }

        public function get iconText():String
        {
            return _iconText;
        }
		
		public function set iconText(v:String):void
		{
			COMPILE::JS
            {
                element.classList.remove(v);
            }

            _iconText = v;

            COMPILE::JS
            {
                element.classList.add(_iconText);
            }
		}

    }
}
