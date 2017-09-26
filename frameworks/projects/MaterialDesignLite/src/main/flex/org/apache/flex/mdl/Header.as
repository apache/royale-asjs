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
	import org.apache.flex.html.Group;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
		import org.apache.flex.html.addElementToWrapper;
    }

	/**
	 *  The Header class is a Container component mainly used in NavigationLayout
	 *  and Tabs components. It used to hold a HeaderRow and/or a TabBar components
	 *  to layout a Title, a navigation link or a tab bar navigation.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class Header extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function Header()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-layout__header";
			return addElementToWrapper(this,'header');
        }

		protected var _transparent:Boolean;
        /**
		 *  A boolean flag to activate "mdl-transparent--Xdp" effect selector.
		 *  Assigns variable transparent depths (0, 2, 3, 4, 6, 8, or 16) to card
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
        public function get transparent():Boolean
        {
            return _transparent;
        }
        public function set transparent(value:Boolean):void
        {
			_transparent = value;

			COMPILE::JS
            {
                element.classList.toggle("mdl-layout__header--transparent", _transparent);
				typeNames = element.className;
            }
        }

		protected var _scrollable:Boolean;
        /**
		 *  A boolean flag to activate "mdl-layout__header--scroll" effect selector.
		 *  Optional. Makes the header scroll with the content
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
        public function get scrollable():Boolean
        {
            return _scrollable;
        }
        public function set scrollable(value:Boolean):void
        {
			_scrollable = value;

			COMPILE::JS
            {
                element.classList.toggle("mdl-layout__header--scroll", _scrollable);
				typeNames = element.className;
            }
        }

		protected var _waterfall:Boolean;
        /**
		 *  A boolean flag to activate "mdl-layout__header--waterfall" effect selector.
		 *  Optional. Allows a "waterfall" effect with multiple header lines
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
        public function get waterfall():Boolean
        {
            return _waterfall;
        }
        public function set waterfall(value:Boolean):void
        {
			_waterfall = value;

			COMPILE::JS
            {
                element.classList.toggle("mdl-layout__header--waterfall", _waterfall);
				typeNames = element.className;
            }
        }
	}
}
