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
    import org.apache.flex.mdl.materialIcons.IMaterialIcon;
    import org.apache.flex.mdl.supportClasses.MaterialIconBase;
    import org.apache.flex.core.UIBase;

    COMPILE::JS
    {    
        import org.apache.flex.core.WrappedHTMLElement;
    }
    /**
     *  The IconToggle class provides a MDL UI-like appearance for
     *  a IconToggle.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
    public class IconToggle extends UIBase implements IMaterialIcon
    {
        public function IconToggle()
        {
            super();

            className = "";
        }

        COMPILE::JS
        private var label:HTMLLabelElement;

        COMPILE::JS
        private var input:HTMLInputElement;

        private var _dataMdlFor:String = "icon-toggle-1";
        private var _ripple:Boolean = false;
        private var _materialIcon:MaterialIconBase;
        
        /**
         *  The id value of the associated input
         *  Need to specify for display content of IconToggle
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
                if (input)
                {
                    input.id = _dataMdlFor;
                }
                element.setAttribute('for', _dataMdlFor);
            }
        }

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
                element.classList.toggle("mdl-js-ripple-effect", _ripple);
                typeNames = element.className;
            }
        }

        /**
         *  A material icon. Optional
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get materialIcon():MaterialIconBase
        {
            return _materialIcon;
        }
        public function set materialIcon(value:MaterialIconBase):void
        {
            _materialIcon = value;

            COMPILE::JS
            {
                _materialIcon.iconToggleLabel = true;
                addElement(_materialIcon);
            }
        }

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLLabelElement
         * @flexjsignorecoercion HTMLInputElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-icon-toggle mdl-js-icon-toggle";

            label = document.createElement("label") as HTMLLabelElement;

            element = label as WrappedHTMLElement;
            element.setAttribute('for', _dataMdlFor);

            if (_dataMdlFor)
            {
                input = document.createElement("input") as HTMLInputElement;
                input.id = _dataMdlFor;
                input.type = "checkbox";
                input.checked = false;
                input.classList.add("mdl-icon-toggle__input");

                label.appendChild(input);
            }
            else 
            {
                throw new Error("dataMdlFor need to be specify in order to display IconToggle");
            }
            
            positioner = element;

            (input as WrappedHTMLElement).flexjs_wrapper = this;
            element.flexjs_wrapper = this;

            return element;
        }
    }
}
