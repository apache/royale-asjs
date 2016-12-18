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
    COMPILE::JS
    {
        import org.apache.flex.core.UIBase;
        import org.apache.flex.core.WrappedHTMLElement;
    }
    /**
     *  The Spinner class provides a MDL UI-like appearance for
     *  a Spinner.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
    public class Spinner
    {
        private var _isActive:Boolean;
        private var _singleColor:Boolean;

        public function set isActive(value:Boolean):void
        {
            _isActive = value;
        }

        public function set singleColor(value:Boolean):void
        {
            _singleColor = value;
        }
    }

    COMPILE::JS
    public class Spinner extends UIBase
    {
        public function Spinner()
        {
            super();

            className = "";
        }

        private var _isActive:Boolean;
        private var _singleColor:Boolean;

        public function set isActive(value:Boolean):void
        {
            _isActive = value;

            element.classList.toggle("is-active", _isActive);
        }

        public function set singleColor(value:Boolean):void
        {
            _singleColor = value;

            element.classList.toggle("mdl-spinner--single-color", _singleColor);
        }

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         *
         * @return
         */
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-spinner mdl-js-spinner";

            element = document.createElement("div") as WrappedHTMLElement;

            positioner = element;
            element.flexjs_wrapper = this;

            return element;
        }
    }
}
