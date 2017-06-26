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
package org.apache.flex.mdl.supportClasses
{
    import org.apache.flex.html.supportClasses.MXMLItemRenderer;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

    /**
     *  Base class for TabBarButton item renderers
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */
    public class TabBarButtonItemRendererBase extends MXMLItemRenderer implements ITabItemRenderer
    {
        /**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
        public function TabBarButtonItemRendererBase()
        {
            super();

            className = "";
        }

        private var _tabIdField:String;
        /**
		 *  tabIdField.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
        public function get tabIdField():String
        {
            return _tabIdField;
        }
        public function set tabIdField(value:String):void
        {
            _tabIdField = value;
        }
        
        private var _isActive:Boolean;
        /**
		 *  isActive.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
        public function get isActive():Boolean
        {
            return _isActive;
        }

        public function set isActive(value:Boolean):void
        {
            _isActive = value;

            COMPILE::JS
            {
                element.classList.toggle("is-active", _isActive);
            }
        }
        
        /**
         *  Sets the data value and uses the String version of the data for display.
         *
         *  @param Object data The object being displayed by the itemRenderer instance.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        override public function set data(value:Object):void
        {
            super.data = value;

            COMPILE::JS
            {
                if (tabIdField)
                {
                    (element as HTMLAnchorElement).href = "#" + String(value[tabIdField]);
                }

                if (labelField)
                {
                    element.text = String(value[labelField]);
                }
            }
        }
        
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         * @flexjsignorecoercion HTMLAnchorElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            var a:HTMLAnchorElement = document.createElement('a') as HTMLAnchorElement;
            element = a as WrappedHTMLElement;

            positioner = element;
            element.flexjs_wrapper = this;

            return element;
        }
    }
}
