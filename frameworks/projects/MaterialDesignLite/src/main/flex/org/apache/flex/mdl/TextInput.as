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
	import org.apache.flex.html.TextInput;

    COMPILE::JS
    {
        import goog.events;
        import org.apache.flex.core.WrappedHTMLElement;            
    }
    
    /**
     *  The TextInput class provides a Material Design Library UI-like appearance for
     *  a TextInput.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
	public class TextInput extends org.apache.flex.html.TextInput
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function TextInput()
		{
			super();
		}
		
        COMPILE::JS
        {
            private var _textNode:Text;
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
            var div:HTMLDivElement = document.createElement('div') as HTMLDivElement;
            div.className = "mdl-textfield mdl-js-textfield";

            var input:HTMLInputElement = document.createElement('input') as HTMLInputElement;
            input.setAttribute('type', 'text');
            input.className = 'mdl-textfield__input';
            
            //attach input handler to dispatch flexjs change event when user write in textinput
            //goog.events.listen(element, 'change', killChangeHandler);
            goog.events.listen(input, 'input', textChangeHandler);
            
            var label:HTMLLabelElement = document.createElement('label') as HTMLLabelElement;
            label.className = "mdl-textfield__label";

            var textNode:Text = document.createTextNode('') as Text;
            label.appendChild(textNode);
            
            div.appendChild(input);
            div.appendChild(label);

            element = input as WrappedHTMLElement;

            positioner = div as WrappedHTMLElement;
            positioner.style.position = 'relative';
            (input as WrappedHTMLElement).flexjs_wrapper = this;
            (label as WrappedHTMLElement).flexjs_wrapper = this;
            element.flexjs_wrapper = this;
            
            return element;
        }        
        
        private var _mdlEffect:String = "";

        public function get mdlEffect():String
        {
            return _mdlEffect;
        }
        
        public function set mdlEffect(value:String):void
        {
            _mdlEffect = value;
            COMPILE::JS 
            {
                positioner.className = positioner.className + " " + _mdlEffect;
            }
        }
	}
}
