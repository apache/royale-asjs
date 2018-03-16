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
package org.apache.royale.mdl.supportClasses
{
    import org.apache.royale.core.UIBase;
    import org.apache.royale.mdl.materialIcons.IMaterialIcon;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
        import org.apache.royale.core.CSSClassList;
    }

    /**
     *  Material icons are beautifully crafted, delightful, and easy to use in your web,
     *  Android, and iOS projects.
     *  Material Design Icons are listed here : https://material.io/icons/
     *  
     *  This base class provide common features for all material icons type
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.8
     */
    public class MaterialIconBase extends UIBase implements org.apache.royale.mdl.materialIcons.IMaterialIcon
    {
        /**
         *  constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function MaterialIconBase()
        {
            super();

            COMPILE::JS
            {
                _classList = new CSSClassList();
            }

            typeNames = "material-icons";
        }

        COMPILE::JS
        private var _classList:CSSClassList;

        COMPILE::JS
        protected var textNode:Text;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 * @royaleignorecoercion HTMLElement
         * @royaleignorecoercion Text
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			var i:WrappedHTMLElement = addElementToWrapper(this,'i');
            
            textNode = document.createTextNode(iconText) as Text;
            i.appendChild(textNode); 
            return i;
        }

        /**
         *  the icon text that matchs with MDL icon.
         *  Check this url to see the icon list: https://material.io/icons/
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        protected function get iconText():String
        {
            return "";
        }

        private var _size:Number = 24;
        /**
         * Although the icons in the font can be scaled to any size, 
         * in accordance with material design icons guidelines, 
         * As recommended by Google be use css like this .material-icons.md-18 { font-size: 18px; }
         * to uses 18, 24, 36 or 48px.
         *
         * The default being 24px.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get size():Number
        {
            return _size;
        }
        /**
         * Activate "md-XX" size class selector.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function set size(value:Number):void
        {
            if (_size != value)
            {
                COMPILE::JS
                {
                    var classVal:String = "md-" + _size;
                    _classList.remove(classVal);

                    classVal = "md-" + value;
                    _classList.add(classVal);

                    _size = value;

                    setClassName(computeFinalClassNames());
                }
            }
        }

        private var _dark:Boolean;
        /**
         * Activate "md-dark" class selector.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get dark():Boolean
        {
            return _dark;
        }

        public function set dark(value:Boolean):void
        {
            if (_dark != value)
            {
                _dark = value;

                COMPILE::JS
                {
                    var classVal:String = "md-dark";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
            }
        }

        private var _light:Boolean;
        /**
         * Activate "md-light" class selector.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get light():Boolean
        {
            return _light;
        }
        public function set light(value:Boolean):void
        {
            if (_light != value)
            {
                _light = value;

                COMPILE::JS
                {
                    var classVal:String = "md-light";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
            }
        }

        private var _inactive:Boolean;
        /**
         * Activate "md-inactive" class selector.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get inactive():Boolean
        {
            return _inactive;
        }
        public function set inactive(value:Boolean):void
        {
            if (_inactive != value)
            {
                _inactive = value;

                COMPILE::JS
                {
                    var classVal:String = "md-inactive";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
            }
        }

        private var _listItemIcon:Boolean;
        /**
         * Activate "mdl-list__item-icon" class selector, for use in a list item
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get listItemIcon():Boolean
        {
            return _listItemIcon;
        }
        public function set listItemIcon(value:Boolean):void
        {
            if (_listItemIcon != value)
            {
                _listItemIcon = value;

                COMPILE::JS
                {
                    var classVal:String = "mdl-list__item-icon";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
            }
        }

        private var _listItemAvatar:Boolean;
        /**
         * Activate "mdl-list__item-avatar" class selector, for use in a list item
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get listItemAvatar():Boolean
        {
            return _listItemAvatar;
        }
        public function set listItemAvatar(value:Boolean):void
        {
            if (_listItemAvatar != value)
            {
                _listItemAvatar = value;

                COMPILE::JS
                {
                    var classVal:String = "mdl-list__item-avatar";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
            }
        }

        private var _iconToggleLabel:Boolean;
        /**
         * Activate "mdl-icon-toggle__label" class selector, for use in a list item
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        public function get iconToggleLabel():Boolean
        {
            return _iconToggleLabel;
        }
        public function set iconToggleLabel(value:Boolean):void
        {
            if (_iconToggleLabel != value)
            {
                _iconToggleLabel = value;

                COMPILE::JS
                {
                    var classVal:String = "mdl-icon-toggle__label";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
            }
        }

        COMPILE::JS
        override protected function computeFinalClassNames():String
        {
            return _classList.compute() + super.computeFinalClassNames();
        }
    }
}
