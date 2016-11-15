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
    import org.apache.flex.core.ITextModel;
	import org.apache.flex.events.Event;
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

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}
		
        COMPILE::JS
        {
            private var _textNode:Text;

            public function get textNode():Text
            {
                return _textNode;
            }

            public function set textNode(value:Text):void
            {
                _textNode = value;
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

            var input:HTMLInputElement = document.createElement('input') as HTMLInputElement;
            input.setAttribute('type', 'text');
            input.className = "mdl-textfield__input";
            
            //attach input handler to dispatch flexjs change event when user write in textinput
            //goog.events.listen(element, 'change', killChangeHandler);
            goog.events.listen(input, 'input', textChangeHandler);
            
            var label:HTMLLabelElement = document.createElement('label') as HTMLLabelElement;
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

        private var _className:String;

        /**
         * since we have a div surronding the main input, we need to 
         * route the class assignaments to div
         */
        override public function set className(value:String):void
		{
			if (_className != value)
			{
                COMPILE::JS
                {
                    positioner.className = typeNames ? value + ' ' + typeNames : value;             
                }
				_className = value;
				dispatchEvent(new Event("classNameChanged"));
			}
		}

        private var _floatingLabel:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-textfield--floating-label" effect selector.
         *  Applies floating label effect.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get floatingLabel():Boolean
        {
            return _floatingLabel;
        }
        public function set floatingLabel(value:Boolean):void
        {
            _floatingLabel = value;

            COMPILE::JS
            {
                className += (_floatingLabel ? " mdl-textfield--floating-label" : "");
            }
        }

        protected var _ripple:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-js-ripple-effect" effect selector.
         *  Applies ripple click effect. May be used in combination with any other classes
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
        public function get ripple():Boolean
        {
            return _ripple;
        }
        public function set ripple(value:Boolean):void
        {
            _ripple = value;

            COMPILE::JS
            {
                className += (_ripple ? " mdl-js-ripple-effect" : "");
            }
        } 
	}
}
