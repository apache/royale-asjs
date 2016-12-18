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
        import org.apache.flex.events.Event;
        import org.apache.flex.core.UIBase;
        import org.apache.flex.core.WrappedHTMLElement;
    }
    /**
     *  The ProgressBar class provides a MDL UI-like appearance for
     *  a ProgressBar.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    COMPILE::SWF
    public class ProgressBar
    {
        private var _currentProgress:Number;
        private var _currentBuffer:Number;
        private var _indeterminate:Boolean;

        /**
         *  Current progress of the progressbar
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get currentProgress():Number
        {
            return _currentProgress;
        }

        public function set currentProgress(value:Number):void
        {
            _currentProgress = value;
        }

        /**
         *  Current progress of the buffer.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
        public function get currentBuffer():Number
        {
            return _currentBuffer;
        }

        public function set currentBuffer(value:Number):void
        {
            _currentBuffer = value;
        }

        public function set indeterminate(value:Boolean):void
        {
            _indeterminate = value;
        }
    }

    COMPILE::JS
    public class ProgressBar extends UIBase
    {
        public function ProgressBar()
        {
            super();

            className = "";
        }

        private var materialProgress:Object;

        private var _currentProgress:Number;
        private var _currentBuffer:Number;
        private var _indeterminate:Boolean;

        public function get currentProgress():Number
        {
            return _currentProgress;
        }

        public function set currentProgress(value:Number):void
        {
            _currentProgress = value;

            setCurrentProgress(value);
        }

        public function get currentBuffer():Number
        {
            return _currentBuffer;
        }

        public function set currentBuffer(value:Number):void
        {
            _currentBuffer = value;

            setCurrentProgress(value);
        }

        public function set indeterminate(value:Boolean):void
        {
            _indeterminate = value;

            element.classList.toggle("mdl-progress__indeterminate", value);
        }
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         *
         * @return
         */
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-progress mdl-js-progress";

            element = document.createElement("div") as WrappedHTMLElement;
            element.addEventListener("mdl-componentupgraded", onElementMdlComponentUpgraded, false);

            positioner = element;
            element.flexjs_wrapper = this;

            return element;
        }

        private function setCurrentProgress(value:Number):void
        {
            if (materialProgress && !_indeterminate)
            {
                materialProgress.setProgress(value);
            }
        }

        private function setCurrentBuffer(value:Number):void
        {
            if (materialProgress && !_indeterminate)
            {
                materialProgress.setBuffer(value);
            }
        }

        private function onElementMdlComponentUpgraded(event:Event):void
        {
            if (!event.currentTarget) return;

            materialProgress = event.currentTarget.MaterialProgress;

            setCurrentProgress(_currentProgress);
            setCurrentBuffer(_currentBuffer);
        }
    }
}
