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
package org.apache.royale.icons
{
    /**
     *  Icons can be used alone or in buttons and other controls 
     * 
     *  This class could be used with any icon family out there and with
     *  its text property
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
    public class FontAwesomeIcon extends FontIconBase
    {
        /**
         *  FontAwesome version (4,5,...)
         *  Warning: Creators of FontAwesome not recommend using Font Awesome 4 and 5 side-by-side on the smae project
         */
        public var v:Number = 5;
        
        /**
         * Icon Styles for Font Awesome 5.
         * Free version has Brands and Solid
         * Pro version adds Regular, light and Duotone
         */
        public static const BRANDS:String = "b";
        public static const SOLID:String = "s";
        public static const REGULAR:String = "r";
        public static const LIGHT:String = "l";
        public static const DUOTONE:String = "d";
        
        /**
         *  constructor.
         * 
         *  <inject_script>
         *   var link = document.createElement("link");
         *   link.setAttribute("rel", "stylesheet");
         *   link.setAttribute("type", "text/css");
         *   link.setAttribute("href", "https://pro.fontawesome.com/releases/v5.13.0/css/all.css");
         *   document.head.appendChild(link);
	     *  </inject_script>
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function FontAwesomeIcon()
        {
            super();

            typeNames = "fonticon";
        }

        /**
		 *  The method called when added to a parent.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.6
		 */
		override public function addedToParent():void
		{
			super.addedToParent();
			
            setUpClassName();
		}

        /**
         * update font awesome style.
         */
        public function setUpClassName():void
        {
            removeClass('fa' + _oldFaStyle);

            if(v == 5)
                addClass('fa' + _faStyle);
            else
                addClass('fa');
        }

        protected var _faStyle:String = REGULAR;
        protected var _oldFaStyle:String;
        /**
         *  the font awesome 5 style.
         *  Can be one of the following constants defined in this class:
         *   - BRANDS (b);
         *   - SOLID (s);
         *   - REGULAR (r) - this is the default;
         *   - LIGHT (l);
         *   - DUOTONE (d);
         *  Only available for v (version) = 5
         *  
         *  For version 4, style is always the same and you must different type values.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get faStyle():String
        {
            return _faStyle;
        }
		public function set faStyle(value:String):void
		{
            _oldFaStyle = _faStyle;
            _faStyle = value;
            setUpClassName();
		}
        
        /**
         *  the icon type. This field is required.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        override public function set text(value:String):void
		{
            removeClass('fa-' + _text);
            _text = value;
            if(_text)
                addClass('fa-' + _text);
		}

        protected var _pullRight:Boolean;
        /**
         *  pullRight makes pull to the right, needs border = true
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get pullRight():Boolean
        {
            return _pullRight;
        }
        public function set pullRight(value:Boolean):void
        {
            _pullRight = value;
            toggleClass('fa-pull-right', _pullRight);          
        }
        
        protected var _pullLeft:Boolean;
        /**
         *  pullLeft makes pull to the left, needs border = true
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get pullLeft():Boolean
        {
            return _pullLeft;
        }
        public function set pullLeft(value:Boolean):void
        {
            _pullLeft = value;
            toggleClass('fa-pull-left', _pullLeft);          
        }

        protected var _border:Boolean;
        /**
         *  Show a border around the icon
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get border():Boolean
        {
            return _border;
        }
        public function set border(value:Boolean):void
        {
            _border = value;
            toggleClass('fa-border', _border);          
        }

        public static const SIZE_LG:String = 'lg';
        public static const SIZE_X2:String = '2x';
        public static const SIZE_X3:String = '3x';
        public static const SIZE_X4:String = '4x';
        public static const SIZE_X5:String = '5x';
        
        protected var _relativeSize:String;
        /**
         *  Increase icon sizes relative to their container,
         *  use the lg (33% increase), 2x, 3x, 4x, or 5x.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get relativeSize():String
        {
            return _relativeSize;
        }
		public function set relativeSize(value:String):void
        {
            removeClass('fa-' + value);
            _relativeSize = value;
            addClass('fa-' + value);
        }

        protected var _fixedWidth:Boolean;
        /**
         *  Set icons at a fixed width.
         *  Great to use when different icon widths throw off alignment.
         *  Especially useful in things like nav lists & list groups.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get fixedWidth():Boolean
        {
            return _fixedWidth;
        }
        public function set fixedWidth(value:Boolean):void
        {
            _fixedWidth = value;
            toggleClass('fa-fw', _fixedWidth);
        }
        
        protected var _flipHorizontal:Boolean;
        /**
         *  Flip the icon horizontal
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get flipHorizontal():Boolean
        {
            return _flipHorizontal;
        }
        public function set flipHorizontal(value:Boolean):void
        {
            _flipHorizontal = value;
            toggleClass('fa-flip-horizontal', _flipHorizontal);
        }
        
        protected var _flipVertical:Boolean;
        /**
         *  Flip the icon vertical
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get flipVertical():Boolean
        {
            return _flipVertical;
        }
        public function set flipVertical(value:Boolean):void
        {
            _flipVertical = value;
            toggleClass('fa-flip-vertical', _flipVertical);
        }

        public static const ROTATE_90:String = "90";
		public static const ROTATE_180:String = "180";
		public static const ROTATE_270:String = "270";

        COMPILE::JS
        protected var _rotation:String;
        /**
         *  Rotate icon. posible values are: 90, 180, 270
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        COMPILE::JS
        public function get rotation():String
        {
            return _rotation;
        }
        COMPILE::JS
        public function set rotation(value:String):void
        {
            removeClass('fa-rotate-' + value);
            _rotation = value;
            addClass('fa-rotate-' + value);
        }

        protected var _spin:Boolean;
        /**
         *  Spin the icon (full 360º rotation animation)
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get spin():Boolean
        {
            return _spin;
        }
        public function set spin(value:Boolean):void
        {
            _spin = value;
            toggleClass('fa-spin', _spin);
        }
        
        protected var _pulse:Boolean;
        /**
         *  Pulse the icon (8 step rotation animation)
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
        public function get pulse():Boolean
        {
            return _pulse;
        }
        public function set pulse(value:Boolean):void
        {
            _pulse = value;
            toggleClass('fa-pulse', _pulse);
        }
    }
}
