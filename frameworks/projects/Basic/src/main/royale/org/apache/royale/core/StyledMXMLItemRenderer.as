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
package org.apache.royale.core
{
    import org.apache.royale.html.supportClasses.MXMLItemRenderer;
    import org.apache.royale.utils.ClassSelectorList;
    import org.apache.royale.utils.IClassSelectorListSupport;
	
	/**
	 *  The StyledMXMLItemRenderer class is the base class for itemRenderers that are MXML-based
	 *  and provides support for ClassSelectorList.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class StyledMXMLItemRenderer extends MXMLItemRenderer implements IClassSelectorListSupport, IRuntimeSelectableItemRenderer
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function StyledMXMLItemRenderer()
		{
			super();
            typeNames = "";
            classSelectorList = new ClassSelectorList(this);
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
         * @productversion Royale 0.9.3
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
         * @productversion Royale 0.9.3
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
         * @productversion Royale 0.9.3
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
		 *  @productversion Royale 0.9.3
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

        /************************************
         *  IRuntimeSelectableItemRenderer
         ************************************/

        private var _selectable:Boolean = true;
		/**
         *  <code>true</code> if the item renderer is can be selected
         *  false otherwise. Use to configure a renderer to be non 
         *  selectable.
         *  
         *  Defaults to true
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get selectable():Boolean
		{
			return _selectable;
		}

		public function set selectable(value:Boolean):void
		{
			_selectable = value;	
		}

        private var _hoverable:Boolean = true;
		/**
         *  <code>true</code> if the item renderer is can be hovered
         *  false otherwise. Use to configure a renderer to be non 
         *  hoverable.
         *  
         *  Defaults to true
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get hoverable():Boolean
		{
			return _hoverable;
		}

		public function set hoverable(value:Boolean):void
		{
			_hoverable = value;	
		}
	}
}
