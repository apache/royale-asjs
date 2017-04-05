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
	import org.apache.flex.html.DataContainer;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;            
    }
	
    /**
     *  The Menu class creates a MDL menu. A menu in MDL is a lists 
     *  of clickable actions.
     *
     *  The Material Design Lite (MDL) menu component is a user interface 
     *  element that allows users to select one of a number of options. 
     *  The selection typically results in an action initiation, a setting 
     *  change, or other observable effect. Menu options are always presented
     *  in sets of two or more, and options may be programmatically enabled or
     *  disabled as required. The menu appears when the user is asked to choose
     *  among a series of options, and is usually dismissed after the choice is made.
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.8
     */    
	public class Menu extends DataContainer
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function Menu()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
        }

        /**
         *  Default position for Menu in MDL is bottom/left (or no class selector specified)
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        private var currentMenuPosition:String = "";


        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            typeNames = "mdl-menu mdl-js-menu";

            element = document.createElement('ul') as WrappedHTMLElement;

            positioner = element;
            element.flexjs_wrapper = this;
            
            return element;
        }

        private var _bottom:Boolean = true;
		/**
		 *  Position the menu relative to the associated button.
         *  Used in conjunction with "left"
         *  deafult is true
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get bottom():Boolean
		{
			return _bottom;
		}
		public function set bottom(value:Boolean):void
		{
			_bottom = value;

            var newMenuPosition:String;

            if(currentMenuPosition == "")
            {
                currentMenuPosition = " mdl-menu--" + (_bottom ? "bottom" : "top") + "-" + (_left ? "left" : "right");
                className += currentMenuPosition;
            } else
            {
                newMenuPosition = " mdl-menu--" + (_bottom ? "bottom" : "top") + "-" + (_left ? "left" : "right");
                className = className.replace( "/(?:^|\s)" + currentMenuPosition + "(?!\S)/g" , newMenuPosition);
            }

            currentMenuPosition = newMenuPosition;
		}

        private var _left:Boolean = true;
		/**
		 *  Position the menu relative to the associated button.
         *  Used in conjunction with "bottom"
         *  deafult is true
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get left():Boolean
		{
			return _left;
		}
		public function set left(value:Boolean):void
		{
			_left = value;

            var newMenuPosition:String;

            if(currentMenuPosition == "")
            {
                currentMenuPosition = " mdl-menu--" + (_bottom ? "bottom" : "top") + "-" + (_left ? "left" : "right");
                className += currentMenuPosition;
            } else
            {
                newMenuPosition = " mdl-menu--" + (_bottom ? "bottom" : "top") + "-" + (_left ? "left" : "right");
                className = className.replace( "/(?:^|\s)" + currentMenuPosition + "(?!\S)/g" , newMenuPosition);
            }

            currentMenuPosition = newMenuPosition;
		}

        private var _dataMdlFor:String;
		/**
		 *  The id value of the associated button that opens this menu.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function get dataMdlFor():String
		{
			return _dataMdlFor;
		}
		public function set dataMdlFor(value:String):void
		{
			_dataMdlFor = value;

            COMPILE::JS
            {
                element.setAttribute('for', dataMdlFor);
            }
		}

        protected var _ripple:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-js-ripple-effect" effect selector.
		 *  Applies ripple click effect to option links. Optional
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
        public function get ripple():Boolean
        {
            return _ripple;
        }
        public function set ripple(value:Boolean):void
        {
            _ripple = value;

            COMPILE::JS
            {
                element.classList.toggle("mdl-js-ripple-effect", _ripple);
                typeNames = element.className;
            }
        }
    }
}
