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
	import org.apache.royale.core.ILayoutHost;
	import org.apache.royale.core.ILayoutParent;
	import org.apache.royale.core.IStrand;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.core.LayoutBase;
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.core.ValuesManager;
	import org.apache.royale.core.layout.ILayoutChildren;
	import org.apache.royale.core.layout.ILayoutStyleProperties;
	import org.apache.royale.events.Event;
	import org.apache.royale.utils.loadBeadFromValuesManager;
	import org.apache.royale.utils.sendStrandEvent;
	
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
	public class StyledLayoutBase extends LayoutBase implements ILayoutStyleProperties
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

		protected var hostComponent:StyledUIBase;

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
			hostComponent = host as StyledUIBase;
			listenOnStrand("beadsAdded", beadsAddedHandler);
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
			applyStyleToLayout(hostComponent, "itemsExpand");
			setHostComponentClass("itemsExpand", _itemsExpand ? "itemsExpand":"");

			applyStyleToLayout(hostComponent, "itemsHorizontalAlign");
			setHostComponentClass(_itemsHorizontalAlign, _itemsHorizontalAlign);

			applyStyleToLayout(hostComponent, "itemsVerticalAlign");
			setHostComponentClass(_itemsVerticalAlign, _itemsVerticalAlign);
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
		public function applyStyleToLayout(component:IUIBase, cssProperty:String):void
		{	
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
				setHostComponentClass(_itemsHorizontalAlign, value);
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
            return _itemsVerticalAlign;
        }

        [Inspectable(category="General", enumeration="itemsSameHeight,itemsCenter,itemsTop,itemsBottom")]
        public function set itemsVerticalAlign(value:String):void
        {
			if(value == "itemsCenter") value += "ed";
			if (_itemsVerticalAlign != value)
            {
                COMPILE::JS
                {
				setHostComponentClass(_itemsVerticalAlign, value);
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
				setHostComponentClass("itemsExpand", value ? "itemsExpand" : "");
				_itemsExpand = value;
				itemsExpandInitialized = true;
				}
            }
        }

        COMPILE::JS
        protected function setHostComponentClass(oldValue:String, newValue:String):void {
            if (!hostComponent) return;
			
            if (oldValue && hostComponent.containsClass(oldValue)) {
				if (oldValue == newValue) return;
                hostComponent.removeClass(oldValue);
			}
        
            if (newValue) hostComponent.addClass(newValue);
        }

		/**
		 *  Allow user to wait for the host size to be set in case of unset or %
		 *  or  avoid and perform layout
		 */
		public var waitForSize:Boolean = false;

		/**
		 * We call requestAnimationFrame until we get width and height
		 */
		COMPILE::JS
		protected function checkHostSize():void {
			if((host.width == 0 && !isNaN(host.percentWidth)) || 
				(host.height == 0 && !isNaN(host.percentHeight)))
			{
				requestAnimationFrame(checkHostSize);
			} else
			{
				waitForSize = false;
				executeLayout();
			}
		}

		/**
		 *  Performs the layout in three parts: before, layout, after.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.8
		 *  @royaleignorecoercion org.apache.royale.core.ILayoutParent
		 *  @royaleignorecoercion org.apache.royale.events.IEventDispatcher
		 */
		override public function performLayout():void
		{
			// avoid running this layout instance recursively.
			if (isLayoutRunning) return;
			
			isLayoutRunning = true;
			/* Not all components need measurement
			COMPILE::SWF
			{
				host.measuredHeight = host.height;
				host.measuredWidth = host.width;
			}
			*/
			
			viewBead = (host as ILayoutParent).getLayoutHost();
			
			if (viewBead.beforeLayout())
			{
				COMPILE::SWF
				{
				executeLayout();
				}

				COMPILE::JS
				{
				if(waitForSize) {
					checkHostSize();
				} else
					executeLayout();
				}
			}
		}

		protected var viewBead:ILayoutHost;

		public function executeLayout():void
		{
			if (layout()) {
				if(layoutChildren)
					layoutChildren.executeLayoutChildren();
				viewBead.afterLayout();	
			}

			isLayoutRunning = false;
			
			sendStrandEvent(_strand, "layoutComplete");
			
			/* measurement may not matter for all components
			COMPILE::SWF
			{
				// check sizes to see if layout changed the size or not
				// and send an event to re-layout parent of host
				if (host.width != host.measuredWidth ||
					host.height != host.measuredHeight)
				{
					isLayoutRunning = true;
					host.dispatchEvent(new Event("sizeChanged"));
					isLayoutRunning = false;
				}
			}
			*/
		}

		private var _layoutChildren:ILayoutChildren;
        
        /**
         *  The org.apache.royale.core.ILayoutChildren used 
         *  to initialize instances of item renderers.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.10.0
         *  @royaleignorecoercion org.apache.royale.core.IItemRendererInitializer
         */
        public function get layoutChildren():ILayoutChildren
        {
            if(!_layoutChildren)
                _layoutChildren = loadBeadFromValuesManager(ILayoutChildren, "iItemRendererInitializer", _strand) as ILayoutChildren;
            
            return _layoutChildren;
        }
        
        /**
         *  @private
         */
        public function set layoutChildren(value:ILayoutChildren):void
        {
            _layoutChildren = value;
        }
	}
}
