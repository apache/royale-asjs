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
    import org.apache.flex.core.UIBase;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
    }

    /**
     *  Provide common features for all material icons type
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public class MaterialIconBase extends UIBase
    {
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         *
         *  @flexjsignorecoercion HTMLElement
         */
        public function MaterialIconBase()
        {
            super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
        }

        COMPILE::JS
        protected var textNode:Text;

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
		 * @flexjsignorecoercion HTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "material-icons";

			var i:HTMLElement = document.createElement('i') as HTMLElement;
            
            textNode = document.createTextNode(iconText) as Text;
            i.appendChild(textNode); 

			element = i as WrappedHTMLElement;
            
            positioner = element;
			element.flexjs_wrapper = this;
            
            return element;
        }

        protected function get iconText():String
        {
            return "";
        }

        private var _size:Number = 24;
        /**
         * Although the icons in the font can be scaled to any size, 
         * in accordance with material design icons guidelines, 
         * we recommend them to be shown in either 18, 24, 36 or 48px. 
         * The default being 24px.
         */
        public function get size():Number
        {
            return _size;
        }
        /**
         * Activate "md-48" class selector.
         */
        public function set size(value:Number):void
        {
            COMPILE::JS
            {
                element.classList.remove("md-" + _size);
            }

            _size = value;

            COMPILE::JS
            {
                element.classList.add("md-" + _size);
            }
        }

        private var _dark:Boolean;
        /**
         * Activate "mdl-dark" class selector, for use in list item
         */
        public function get dark():Boolean
        {
            return _dark;
        }
        public function set dark(value:Boolean):void
        {
            _dark = value;

            COMPILE::JS
            {
                element.classList.toggle("mdl-dark", _dark);
            }
        }

        private var _light:Boolean;
        /**
         * Activate "mdl-light" class selector, for use in list item
         */
        public function get light():Boolean
        {
            return _light;
        }
        public function set light(value:Boolean):void
        {
            _light = value;

            COMPILE::JS
            {
                element.classList.toggle("mdl-light", _light);
            }
        }

        private var _listItemIcon:Boolean;
        /**
         * Activate "mdl-list__item-icon" class selector, for use in list item
         */
        public function get listItemIcon():Boolean
        {
            return _listItemIcon;
        }
        public function set listItemIcon(value:Boolean):void
        {
            _listItemIcon = value;

            COMPILE::JS
            {
                element.classList.toggle("mdl-list__item-icon", _listItemIcon);
            }
        }

        private var _listItemAvatar:Boolean;
        /**
         * Activate "mdl-list__item-avatar" class selector, for use in list item
         */
        public function get listItemAvatar():Boolean
        {
            return _listItemAvatar;
        }
        public function set listItemAvatar(value:Boolean):void
        {
            _listItemAvatar = value;

            COMPILE::JS
            {
                element.classList.toggle("mdl-list__item-avatar", _listItemAvatar);
            }
        }

        private var _iconToggleLabel:Boolean;
        /**
         * Activate "mdl-icon-toggle__label" class selector, for use in list item
         */
        public function get iconToggleLabel():Boolean
        {
            return _iconToggleLabel;
        }
        public function set iconToggleLabel(value:Boolean):void
        {
            _iconToggleLabel = value;

            COMPILE::JS
            {
                element.classList.toggle("mdl-icon-toggle__label", _iconToggleLabel);
            }
        }
    }
}
