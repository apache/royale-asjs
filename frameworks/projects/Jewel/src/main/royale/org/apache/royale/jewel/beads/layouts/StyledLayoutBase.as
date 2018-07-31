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
package org.apache.royale.jewel.beads.layouts
{
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.IBeadLayout;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.UIBase;


    /**
     *  The StyledLayoutBase class is an extension of LayoutBase
	 *  to define various common layout features for the rest of
	 *  child classes
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.3
     */
	public class StyledLayoutBase extends LayoutBase implements IBeadLayout
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function StyledLayoutBase()
		{
			super();
		}

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public static const LAYOUT_TYPE_NAMES:String = "layout horizontal";

		protected var hostComponent:UIBase;

		COMPILE::JS
		protected var hostClassList:DOMTokenList;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 *  @royaleignorecoercion org.apache.royale.core.IParentIUIBase
		 *  @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
		 */
		override public function set strand(value:IStrand):void
		{
			super.strand = value;

			COMPILE::JS
			{
				hostComponent = host as UIBase;
				hostClassList = hostComponent.positioner.classList;
			}
		}

		private var _itemsHorizontalAlign:String;
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
		 *  @productversion Royale 0.9.3
		 */
        public function get itemsHorizontalAlign():String
        {
            return _itemsHorizontalAlign;
        }

        public function set itemsHorizontalAlign(value:String):void
        {
			if (_itemsHorizontalAlign != value)
            {
                COMPILE::JS
                {
					if(hostComponent)
					{
						if (hostClassList.contains(_itemsHorizontalAlign))
							hostClassList.remove(_itemsHorizontalAlign);
				}
						_itemsHorizontalAlign = value;
				COMPILE::JS
                {
						hostClassList.add(_itemsHorizontalAlign);
					}
				}
			}
        }

        private var _itemsVerticalAlign:String;
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
		 *  @productversion Royale 0.9.3
		 */
        public function get itemsVerticalAlign():String
        {
            return _itemsVerticalAlign;
        }

        public function set itemsVerticalAlign(value:String):void
        {
			if (_itemsVerticalAlign != value)
            {
                COMPILE::JS
                {
					if(hostComponent)
					{
						if (hostClassList.contains(_itemsVerticalAlign))
							hostClassList.remove(_itemsVerticalAlign);
				}
						_itemsVerticalAlign = value;
				COMPILE::JS
                {
						hostClassList.add(_itemsVerticalAlign);
					}
				}
			}
        }

		private var _itemsExpand:Boolean = false;
        /**
		 *  A boolean flag to activate "itemsExpand" effect selector.
		 *  Make items resize to the fill all container space
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
        public function get itemsExpand():Boolean
        {
            return _itemsExpand;
        }

        public function set itemsExpand(value:Boolean):void
        {
            if (_itemsExpand != value)
            {
                _itemsExpand = value;
				COMPILE::JS
                {
				if(_itemsExpand)
				{
					hostClassList.add("itemsExpand");
				} else
				{
					hostClassList.remove("itemsExpand");
				}
				}
            }
        }
	}
}
