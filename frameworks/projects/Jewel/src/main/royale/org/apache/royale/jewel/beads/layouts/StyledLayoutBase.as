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
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.UIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.events.Event;
	import org.apache.royale.events.IEventDispatcher;
	
    /**
     *  The StyledLayoutBase class is an extension of LayoutBase
	 *  to define various common layout features for the rest of
	 *  child classes
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.4
     */
	public class StyledLayoutBase extends LayoutBase
	{
        /**
         *  Constructor.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function StyledLayoutBase()
		{
			super();
		}

		/**
		 * @royalesuppresspublicvarwarning
		 */
		public static const LAYOUT_TYPE_NAMES:String = "";

		protected var hostComponent:UIBase;

		COMPILE::JS
		protected var hostClassList:DOMTokenList;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
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

			IEventDispatcher(value).addEventListener("beadsAdded", beadsAddedHandler);
			beadsAddedHandler();
		}

		/**
		 *  Add class selectors when the component is addedToParent
		 *  Otherwise component will not get the class selectors when 
		 *  perform "removeElement" and then "addElement"
		 * 
 		 *  @langversion 3.0
 		 *  @playerversion Flash 10.2
 		 *  @playerversion AIR 2.6
 		 *  @productversion Royale 0.9.4
 		 */
		public function beadsAddedHandler(event:Event = null):void
		{
			COMPILE::JS
			{
				initStyleToLayout(hostComponent, "itemsExpand");
				setHostClassList("itemsExpand", _itemsExpand ? "itemsExpand":"");

				initStyleToLayout(hostComponent, "itemsHorizontalAlign");
				setHostClassList(_itemsHorizontalAlign, _itemsHorizontalAlign);

				initStyleToLayout(hostComponent, "itemsVerticalAlign");
				setHostClassList(_itemsVerticalAlign, _itemsVerticalAlign);
			}
		}

		/**
		 *  Get the component layout style and init to if exists
		 * 
		 *  @param component the IUIBase component that host this layout
		 *  @param cssProperty the style property in css set for the component to retrieve
		 * 
 		 *  @langversion 3.0
 		 *  @playerversion Flash 10.2
 		 *  @playerversion AIR 2.6
 		 *  @productversion Royale 0.9.4
 		 */
		protected function initStyleToLayout(component:IUIBase, cssProperty:String):void
		{	
			///-----------------------------------------
			/// This function works as the same as 
			/// org.apache.royale.core.layout.ILayoutStyleProperties#applyStyleToLayout(component:IUIBase, cssProperty:String):void
			/// Because StyledLayoutBase does not implement ILayoutStyleProperties
			/// To avoid conflict with subclass like HorizontalLayout.applyStyleToLayout
			/// Names this function - initStyleToLayout
			///-----------------------------------------
			var cssValue:* = ValuesManager.valuesImpl.getValue(component, cssProperty);
			if (cssValue !== undefined)
			{
				switch(cssProperty)
				{
					case "itemsExpand":
						if(!itemsExpandInitialized)
							itemsExpand = "true" == cssValue;
						break;
					case "itemsHorizontalAlign":
						if (!itemsHorizontalAlign)
							itemsHorizontalAlign = String(cssValue);
						break;
					case "itemsVerticalAlign":
						if (!itemsVerticalAlign)
							itemsVerticalAlign = String(cssValue);
						break;
					default:
						break;
				}	
			}
		}

		protected var itemsHorizontalAlignInitialized:Boolean;
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
		 *  @productversion Royale 0.9.4
		 */
        public function get itemsHorizontalAlign():String
        {
            return _itemsHorizontalAlign;
        }

        [Inspectable(category="General", enumeration="itemsLeft,itemsCenter,itemsRight,itemsSpaceBetween,itemsSpaceAround")]
        public function set itemsHorizontalAlign(value:String):void
        {
			if (_itemsHorizontalAlign != value)
            {
                COMPILE::JS
                {
					setHostClassList(_itemsHorizontalAlign, value);
					_itemsHorizontalAlign = value;
					itemsHorizontalAlignInitialized = true;
				}
			}
        }

		protected var itemsVerticalAlignInitialized:Boolean;
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
		 *  @productversion Royale 0.9.4
		 */
        public function get itemsVerticalAlign():String
        {
            return _itemsVerticalAlign;
        }

        [Inspectable(category="General", enumeration="itemsSameHeight,itemsCentered,itemsTop,itemsBottom")]
        public function set itemsVerticalAlign(value:String):void
        {
			if (_itemsVerticalAlign != value)
            {
                COMPILE::JS
                {
					setHostClassList(_itemsVerticalAlign, value);
					_itemsVerticalAlign = value;
					itemsVerticalAlignInitialized = true;
				}
			}
        }

		private var itemsExpandInitialized:Boolean;
		private var _itemsExpand:Boolean = false;
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
            return _itemsExpand;
        }

        public function set itemsExpand(value:Boolean):void
        {
            if (_itemsExpand != value)
            {
                
				COMPILE::JS
                {
				    setHostClassList("itemsExpand", value ? "itemsExpand" : "");
					_itemsExpand = value;
					itemsExpandInitialized = true;
				}
            }
        }

        COMPILE::JS
        protected function setHostClassList(oldValue:String, newValue:String):void {
            if (!hostComponent) return;
			
            if (oldValue && hostClassList.contains(oldValue)) {
				if (oldValue == newValue) return;
                hostClassList.remove(oldValue);
			}
        
            if (newValue) hostClassList.add(newValue);
        }
	}
}
