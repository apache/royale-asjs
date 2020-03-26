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
package org.apache.royale.jewel.supportClasses.group
{
    import org.apache.royale.jewel.Group;
    import org.apache.royale.jewel.beads.layouts.StyledLayoutBase;
    import org.apache.royale.utils.StringUtil;
    
    /**
     *  The Jewel AlignmentItemsGroup class is the base class for groups that
	 *  distribute items along one of its axis. Used extensions are normally HGroup and VGroup.
	 *  
	 *  Unlike normal Jewel Group class that positions elements in a canvas using x and y
	 *  this class and its extensions use to follow a concret layout algorithm (like Horizontal or Vertical layouts)
	 *  and need to distribute its items in different ways.
	 *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.7
     */
	public class AlignmentItemsGroup extends Group
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.7
         */
		public function AlignmentItemsGroup()
		{
			super();            
		}

		/**
		 * the layout to use in this group
		 */
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
		 *  - itemsCenter
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

        [Inspectable(category="General", enumeration="itemsSameHeight,itemsCenter,itemsTop,itemsBottom")]
        public function set itemsVerticalAlign(value:String):void
        {
			if(value == "itemsCenter") value += "ed";
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
            if(value)
            	typeNames += " itemsExpand";

            COMPILE::JS
            {
			if (parent)
				setClassName(computeFinalClassNames()); 
			}
        }
    }
}
