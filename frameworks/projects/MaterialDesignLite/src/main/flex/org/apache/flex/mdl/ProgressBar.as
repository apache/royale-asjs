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
    import org.apache.flex.events.Event;

    COMPILE::JS
    {        
        import org.apache.flex.core.WrappedHTMLElement;
        import org.apache.flex.html.addElementToWrapper;
    }
    /**
     *  The ProgressBar indicate loading and progress states.
     *  The Material Design Lite (MDL) progress component is a visual indicator of
     *  background activity in a web page or application. A progress indicator consists
     *  of a (typically) horizontal bar containing some animation that conveys a sense of
     *  motion. While some progress devices indicate an approximate or specific percentage
     *  of completion, the MDL progress component simply communicates the fact that an activity
     *  is ongoing and is not yet complete.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
    public class ProgressBar extends UIBase
    {
        public function ProgressBar()
        {
            super();

            className = "";
        }

        private var materialProgress:Object;

        private var _currentProgress:Number;
        /**
         *  Current progress of the progressbar
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get currentProgress():Number
        {
            return _currentProgress;
        }
        /**
         *  @private
         */
        public function set currentProgress(value:Number):void
        {
            _currentProgress = value;

            setCurrentProgress(value);
        }

        private var _currentBuffer:Number;
        /**
         *  Current progress of the buffer.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get currentBuffer():Number
        {
            return _currentBuffer;
        }
        /**
         *  @private
         */
        public function set currentBuffer(value:Number):void
        {
            _currentBuffer = value;

            setCurrentProgress(value);
        }

        private var _indeterminate:Boolean;
        /**
         *  Indeterminate state.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function set indeterminate(value:Boolean):void
        {
            _indeterminate = value;

            COMPILE::JS
            {
                element.classList.toggle("mdl-progress__indeterminate", value);
                typeNames = element.className;
            }
        }
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         *
         * @return
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-progress mdl-js-progress";
			addElementToWrapper(this,'div');
            element.addEventListener("mdl-componentupgraded", onElementMdlComponentUpgraded, false);
            return element;
        }

        /**
         *  @private
         */
        private function setCurrentProgress(value:Number):void
        {
            if (materialProgress && !_indeterminate)
            {
                materialProgress.setProgress(value);
            }
        }

        /**
         *  @private
         */
        private function setCurrentBuffer(value:Number):void
        {
            if (materialProgress && !_indeterminate)
            {
                materialProgress.setBuffer(value);
            }
        }

        /**
         *  @private
         */
        private function onElementMdlComponentUpgraded(event:Event):void
        {
            if (!event.currentTarget) return;

            materialProgress = event.currentTarget.MaterialProgress;

            setCurrentProgress(_currentProgress);
            setCurrentBuffer(_currentBuffer);
        }
    }
}
