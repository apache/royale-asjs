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
        import org.apache.flex.html.TextButton;
    }

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.core.UIBase;
    }

    /**
     *  The Chip class provides a MDL UI-like appearance for
     *  a Chip.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
    public class Chip extends TextButton
    {
        public function Chip()
        {
            super();
        }
    }

    COMPILE::JS
    public class Chip extends UIBase
    {
        public function Chip()
        {
            super();

            className = "";
        }

        private var chip:HTMLSpanElement;
        private var textNode:Text;

        private var _chipTextSpan:HTMLSpanElement;

        public function get chipTextSpan():HTMLSpanElement
        {
           return _chipTextSpan;
        }

        public function get text():String
        {
            return textNode.nodeValue;
        }

        public function set text(value:String):void
        {
            textNode.nodeValue = value;
        }

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLSpanElement
         * @flexjsignorecoercion Text
         */
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-chip";

            _chipTextSpan = document.createElement("span") as HTMLSpanElement;
            _chipTextSpan.classList.add("mdl-chip__text");

            textNode = document.createTextNode('') as Text;
            _chipTextSpan.appendChild(textNode);

            chip = document.createElement("span") as HTMLSpanElement;
            chip.appendChild(_chipTextSpan);

            element = chip as WrappedHTMLElement;

            positioner = element;
            element.flexjs_wrapper = this;

            return element;
        }
    }
}
