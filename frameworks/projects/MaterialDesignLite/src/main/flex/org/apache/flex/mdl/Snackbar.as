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
    import org.apache.flex.core.WrappedHTMLElement;

    COMPILE::SWF
    public class Snackbar
    {
        public function Snackbar()
        {

        }
    }

    COMPILE::JS
    public class Snackbar extends UIBase
    {
        public function Snackbar()
        {
            super();

            className = "";
        }

        private var snackbarText:HTMLDivElement;
        private var snackbarAction:HTMLButtonElement;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLDivElement
         * @flexjsignorecoercion HTMLButtonElement
         *
         * @return
         */
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-js-snackbar mdl-snackbar";

            element = document.createElement("div");

            snackbarText = document.createElement("div") as HTMLDivElement;
            snackbarText.classList.add("mdl-snackbar__text");
            element.appendChild(snackbarText);

            snackbarAction = document.createElement("button") as HTMLButtonElement;
            snackbarAction.classList.add("mdl-snackbar__action");
            element.appendChild(snackbarAction);

            positioner = element;
            element.flexjs_wrapper = this;

            return element;
        }
    }
}
