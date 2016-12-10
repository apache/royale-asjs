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
    import org.apache.flex.html.I;

    /**
     *  Provide common features for all material icons type
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */
    public class MaterialIconBase
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
            COMPILE::JS
            {
                materialIcon = new I();
                element.classList.add("material-icons");
            }
        }

        COMPILE::JS
        protected var materialIcon:I;

        COMPILE::JS
        public function get element():HTMLElement
        {
            return materialIcon.element as HTMLElement;
        }

        private var _md48:Boolean;
        
        public function get md48():Boolean
        {
            return _md48;
        }
        /**
         * Activate "md-48" class selector.
         */
        public function set md48(value:Boolean):void
        {
            _md48 = value;

            COMPILE::JS
            {
                element.classList.toggle("md-48", _md48);
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

    }
}
