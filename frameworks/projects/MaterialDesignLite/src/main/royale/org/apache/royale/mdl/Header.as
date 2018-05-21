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
	import org.apache.royale.html.Group;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
        import org.apache.royale.core.CSSClassList;
    }

	/**
	 *  The Header class is a Container component mainly used in NavigationLayout
	 *  and Tabs components. It used to hold a HeaderRow and/or a TabBar components
	 *  to layout a Title, a navigation link or a tab bar navigation.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class Header extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function Header()
		{
			super();

            COMPILE::JS
            {
                _classList = new CSSClassList();
            }

            typeNames = "mdl-layout__header"
		}

        COMPILE::JS
        private var _classList:CSSClassList;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {;
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
		 *  @productversion Royale 0.8
		 */
        public function get transparent():Boolean
        {
            return _transparent;
        }

        public function set transparent(value:Boolean):void
        {
            if (_transparent != value)
            {
                _transparent = value;

                COMPILE::JS
                {
                    var classVal:String = "mdl-layout__header--transparent";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
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
		 *  @productversion Royale 0.8
		 */
        public function get scrollable():Boolean
        {
            return _scrollable;
        }

        public function set scrollable(value:Boolean):void
        {
            if (_scrollable != value)
            {
                _scrollable = value;

                COMPILE::JS
                {
                    var classVal:String = "mdl-layout__header--scroll";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
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
		 *  @productversion Royale 0.8
		 */
        public function get waterfall():Boolean
        {
            return _waterfall;
        }

        public function set waterfall(value:Boolean):void
        {
            if (_waterfall != value)
            {
                _waterfall = value;

                COMPILE::JS
                {
                    var classVal:String = "mdl-layout__header--waterfall";
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
