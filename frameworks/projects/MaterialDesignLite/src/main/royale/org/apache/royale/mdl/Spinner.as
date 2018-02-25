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
package org.apache.royale.mdl
{
    import org.apache.royale.core.UIBase;
    import org.apache.royale.mdl.beads.UpgradeElement;

    COMPILE::JS
    {    
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
        import org.apache.royale.html.util.addOrReplaceClassName;
    }
    /**
     *  The Material Design Lite (MDL) spinner component is an enhanced replacement for
     *  the classic "wait cursor" (which varies significantly among hardware and software
     *  versions) and indicates that there is an ongoing process, the results of which are
     *  not yet available. A spinner consists of an open circle that changes colors as it 
     *  animates in a clockwise direction, and clearly communicates that a process has been
     *  started but not completed.
     *
     *  A spinner performs no action itself, either by its display nor when the user clicks
     *  or touches it, and does not indicate a process's specific progress or degree of completion.
     *  The MDL spinner component provides various types of spinners, and allows you to add display effects.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class Spinner extends UIBase
    {
        public function Spinner()
        {
            super();

            typeNames = "mdl-spinner mdl-js-spinner";

            addBead(new UpgradeElement());
        }

        private var _isActive:Boolean;
        /**
         *  Indicates whether Spinner is active and visible
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get isActive():Boolean
        {
            return _isActive;
        }
        /**
         *  @private
         */
        public function set isActive(value:Boolean):void
        {
            if (_isActive != value)
            {
                _isActive = value;

                COMPILE::JS
                {
                    element.classList.remove("is-active");
                    if (value)
                    {
                        className = addOrReplaceClassName(className, "is-active");
                    }
                }
            }
        }

        private var _singleColor:Boolean;   
        /**
         *  Make Spinner in a single color
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        public function set singleColor(value:Boolean):void
        {
            if (_singleColor != value)
            {
                _singleColor = value;

                COMPILE::JS
                {
                    element.classList.remove("mdl-spinner--single-color");
                    if (value)
                    {
                        className = addOrReplaceClassName(className, "mdl-spinner--single-color");
                    }
                }
            }
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         *
         * @return
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this,'div');
        }
    }
}
