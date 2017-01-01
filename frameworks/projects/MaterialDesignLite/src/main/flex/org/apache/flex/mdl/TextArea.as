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
	import org.apache.flex.events.Event;
    
    import org.apache.flex.mdl.supportClasses.TextFieldBase;
    
    COMPILE::JS
    {
        import goog.events;
        import org.apache.flex.core.WrappedHTMLElement;            
    }
    
    /**
     *  The TextArea class provides a Material Design Library UI-like appearance for
     *  a TextField with multiple lines
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
	public class TextArea extends TextFieldBase
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function TextArea()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}
		
        private var _rows:int = 2;
        /**
		 *  The number of rows in the textarea. Defaults to 2
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get rows():int
        {
            return _rows;
        }
        public function set rows(value:int):void
        {
            _rows = value;

            COMPILE::JS 
            {
                input.setAttribute('rows', _rows);
            }
        }

        private var _maxrows:int = 0;
        /**
		 *  The max number of rows in the textarea. Defaults to 0
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get maxrows():int
        {
            return _maxrows;
        }
        public function set maxrows(value:int):void
        {
            _maxrows = value;

            COMPILE::JS 
            {
                input.setAttribute('maxrows', _maxrows);
            }
        }

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLDivElement
         * @flexjsignorecoercion HTMLInputElement
         * @flexjsignorecoercion HTMLLabelElement
         * @flexjsignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-textfield mdl-js-textfield";

            var div:HTMLDivElement = document.createElement('div') as HTMLDivElement;
            div.className = typeNames;

            input = document.createElement('textarea') as HTMLInputElement;
            input.setAttribute('type', 'text');
            input.setAttribute('rows', rows);
            //input.setAttribute('maxrows', maxrows);
            input.className = "mdl-textfield__input";
            
            //attach input handler to dispatch flexjs change event when user write in textinput
            //goog.events.listen(element, 'change', killChangeHandler);
            goog.events.listen(input, 'input', textChangeHandler);
            
            label = document.createElement('label') as HTMLLabelElement;
            label.className = "mdl-textfield__label";

            textNode = document.createTextNode('') as Text;
            label.appendChild(textNode);
            
            div.appendChild(input);
            div.appendChild(label);

            element = input as WrappedHTMLElement;

            positioner = div as WrappedHTMLElement;
            (input as WrappedHTMLElement).flexjs_wrapper = this;
            (label as WrappedHTMLElement).flexjs_wrapper = this;
            element.flexjs_wrapper = this;
            
            return element;
        }
	}
}
