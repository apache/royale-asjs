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

    COMPILE::SWF
    {
        import org.apache.flex.html.ToggleTextButton;
    }

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.core.UIBase;
    }

    /**
     *  The Switch class provides a MDL UI-like appearance for
     *  a Switch.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
    public class Switch extends org.apache.flex.html.ToggleTextButton
    {
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function Switch()
        {
            super();
        }

        private var _ripple:Boolean = false;
        
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
        }
    }

    COMPILE::JS
    public class Switch extends UIBase
    {
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function Switch()
        {
            super();

            className = "";
        }

        private var label:HTMLLabelElement;
        private var input:HTMLInputElement;
        private var span:HTMLSpanElement;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLLabelElement
         * @flexjsignorecoercion HTMLInputElement
         * @flexjsignorecoercion HTMLSpanElement
         */
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-switch mdl-js-switch";

            label = document.createElement("label") as HTMLLabelElement;
            element = label as WrappedHTMLElement;

            input = document.createElement("input") as HTMLInputElement;
            input.type = "checkbox";
            input.classList.add("mdl-switch__input");

            label.appendChild(input);

            span = document.createElement("span") as HTMLSpanElement;
            span.classList.add("mdl-switch__label");

            label.appendChild(span);

            positioner = element;

            (input as WrappedHTMLElement).flexjs_wrapper = this;
            (span as WrappedHTMLElement).flexjs_wrapper = this;
            element.flexjs_wrapper = this;

            return element;
        }

        private var _ripple:Boolean = false;
        
        public function get ripple():Boolean
        {
            return _ripple;
        }

        public function set ripple(value:Boolean):void
        {
            _ripple = value;

            element.classList.toggle("mdl-js-ripple-effect", _ripple);
        }

        public function get text():String
        {
            return span.textContent;
        }

        public function set text(value:String):void
        {
            span.textContent = value;
        }

        public function get selected():Boolean
        {
            return input.checked;
        }

        public function set selected(value:Boolean):void
        {
            input.checked = value;
        }
    }
}