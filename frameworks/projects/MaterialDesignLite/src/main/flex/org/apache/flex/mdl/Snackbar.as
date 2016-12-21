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
    import org.apache.flex.events.EventDispatcher;

    COMPILE::SWF
    {
        import flash.events.Event;
    }

    COMPILE::JS
    {
        import org.apache.flex.events.Event;
        import org.apache.flex.core.UIBase;
        import org.apache.flex.core.WrappedHTMLElement;
    }

    /**
     *  Dispatched when the user click on Snackbar
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    [Event(name="action", type="org.apache.flex.events.Event")]

    COMPILE::SWF
    public class Snackbar extends EventDispatcher
    {
        private var _message:String;
        private var _actionText:String;
        private var _timeout:int = 2750;

        /**
         *  Message to be displayed on Snackbar
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get message():String
        {
            return _message;
        }

        public function set message(value:String):void
        {
            _message = value;
        }

        /**
         *  Text which appears on action button
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get actionText():String
        {
            return _actionText;
        }

        public function set actionText(value:String):void
        {
            _actionText = value;
        }

        /**
         *  Timout in milliseconds for hiding Snackbar
         *
         *  @default 2750
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get timeout():int
        {
            return _timeout;
        }

        public function set timeout(value:int):void
        {
            _timeout = value;
        }

        /**
         *  Show the snackbar
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function show():void
        {
            dispatchEvent(new Event("action"));
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

        private var snackbar:Object;

        private var snackbarText:HTMLDivElement;
        private var snackbarAction:HTMLButtonElement;

        private var _message:String = "";
        private var _actionText:String = "";
        private var _timeout:int = 2000;

        public function get message():String
        {
            return _message;
        }

        public function set message(value:String):void
        {
            _message = value;
        }

        public function get actionText():String
        {
            return _actionText;
        }

        public function set actionText(value:String):void
        {
            _actionText = value;
        }

        public function get timeout():int
        {
            return _timeout;
        }

        public function set timeout(value:int):void
        {
            _timeout = value;
        }

        public function show():void
        {
            if (snackbar)
            {
                var snackbarData = {
                    message: _message,
                    timeout: _timeout,
                    actionHandler: onActionHandler,
                    actionText: _actionText
                };

                snackbar.showSnackbar(snackbarData);
            }
        }

        private function onActionHandler(event:Event):void
        {
            dispatchEvent(new Event("action"));
        }

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

            element = document.createElement("div") as WrappedHTMLElement;
            element.addEventListener("mdl-componentupgraded", onElementMdlComponentUpgraded, false);

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

        private function onElementMdlComponentUpgraded(event:Event):void
        {
            if (!event.currentTarget) return;

            snackbar = event.currentTarget.MaterialSnackbar;
        }
    }
}
