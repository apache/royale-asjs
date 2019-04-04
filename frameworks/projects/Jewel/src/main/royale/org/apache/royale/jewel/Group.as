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
package org.apache.royale.jewel
{
	import org.apache.royale.html.Group;
	import org.apache.royale.jewel.beads.layouts.StyledLayoutBase;
	import org.apache.royale.utils.ClassSelectorList;
	import org.apache.royale.utils.IClassSelectorListSupport;
	import org.apache.royale.utils.StringUtil;

    /**
     *  The Group class provides a light-weight container for visual elements. By default
	 *  the Group does not have a layout, allowing its children to be sized and positioned
	 *  using styles or CSS.
     *
     *  @toplevel
     *  @see org.apache.royale.jewel.beads.layout
     *  @see org.apache.royale.jewel.supportClasses.jewel.ScrollingViewport
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class Group extends org.apache.royale.html.Group implements IClassSelectorListSupport
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function Group()
		{
			super();
            classSelectorList = new ClassSelectorList(this);
            typeNames = "";
		}

        protected var classSelectorList:ClassSelectorList;

        COMPILE::JS
        override protected function setClassName(value:String):void
        {
            classSelectorList.addNames(value);
        }

        /**
         * Add a class selector to the list.
         * 
         * @param name Name of selector to add.
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
         */
        public function addClass(name:String):void
        {
            COMPILE::JS
            {
            classSelectorList.add(name);
            }
        }

        /**
         * Removes a class selector from the list.
         * 
         * @param name Name of selector to remove.
         *
         * @royaleignorecoercion HTMLElement
         * @royaleignorecoercion DOMTokenList
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
         */
        public function removeClass(name:String):void
        {
            COMPILE::JS
            {
            classSelectorList.remove(name);
            }
        }

        /**
         * Add or remove a class selector to/from the list.
         * 
         * @param name Name of selector to add or remove.
         * @param value True to add, False to remove.
         * 
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.9.4
         */
        public function toggleClass(name:String, value:Boolean):void
        {
            COMPILE::JS
            {
            classSelectorList.toggle(name, value);
            }
        }

        /**
		 *  Search for the name in the element class list 
		 *
         *  @param name Name of selector to find.
         *  @return return true if the name is found or false otherwise.
         * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function containsClass(name:String):Boolean
        {
            COMPILE::JS
            {
            return classSelectorList.contains(name);
            }
            COMPILE::SWF
            {//not implemented
            return false;
            }
        }

        protected var _layout:StyledLayoutBase;
        
        /**
		 *  Distribute all items horizontally
		 *  Possible values are:
		 *  - itemsLeft
		 *  - itemsCenter
		 *  - itemsRight
		 *  - itemsSpaceBetween
		 *  - itemsSpaceAround
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get itemsHorizontalAlign():String
        {
            return _layout.itemsHorizontalAlign;
        }

        [Inspectable(category="General", enumeration="itemsLeft,itemsCenter,itemsRight,itemsSpaceBetween,itemsSpaceAround")]
        public function set itemsHorizontalAlign(value:String):void
        {
			typeNames = StringUtil.removeWord(typeNames, " " + _layout.itemsHorizontalAlign);
			_layout.itemsHorizontalAlign = value;
			typeNames += " " + _layout.itemsHorizontalAlign;

			COMPILE::JS
            {
				if (parent)
                	setClassName(computeFinalClassNames()); 
			}
        }

		/**
		 *  Distribute all items vertically
		 *  Possible values are:
		 *  - itemsSameHeight
		 *  - itemsCentered
		 *  - itemsTop
		 *  - itemsBottom
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get itemsVerticalAlign():String
        {
            return _layout.itemsVerticalAlign;
        }

        [Inspectable(category="General", enumeration="itemsSameHeight,itemsCentered,itemsTop,itemsBottom")]
        public function set itemsVerticalAlign(value:String):void
        {
			typeNames = StringUtil.removeWord(typeNames, " " + _layout.itemsVerticalAlign);
			_layout.itemsVerticalAlign = value;
			typeNames += " " + _layout.itemsVerticalAlign;

			COMPILE::JS
            {
				if (parent)
                	setClassName(computeFinalClassNames()); 
			}
        }

        /**
		 *  A boolean flag to activate "itemsExpand" effect selector.
		 *  Make items resize to the fill all container space
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get itemsExpand():Boolean
        {
            return _layout.itemsExpand;
        }

        public function set itemsExpand(value:Boolean):void
        {
            typeNames = StringUtil.removeWord(typeNames, " itemsExpand");
            _layout.itemsExpand = value;
            if(_layout.itemsExpand)
            {
                typeNames += " itemsExpand";
            }

            COMPILE::JS
            {
				if (parent)
                	setClassName(computeFinalClassNames()); 
			}
        }
	}
}
