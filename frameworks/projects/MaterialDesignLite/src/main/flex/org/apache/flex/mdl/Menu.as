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
    import org.apache.flex.core.GroupBase;
    import org.apache.flex.core.IChild;
    import org.apache.flex.core.IFactory;
    import org.apache.flex.core.IItemRenderer;
    import org.apache.flex.core.IItemRendererParent;
    import org.apache.flex.core.ILayoutHost;
    import org.apache.flex.core.ILayoutParent;
	import org.apache.flex.core.ILayoutView;
    import org.apache.flex.core.IList;
    import org.apache.flex.core.ISelectionModel;
	import org.apache.flex.events.ItemAddedEvent;
	import org.apache.flex.events.ItemRemovedEvent;

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
	public class Menu extends GroupBase implements IItemRendererParent, ILayoutParent, ILayoutHost, ILayoutView, IList
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
         *  data provider
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get dataProvider():Object
        {
            return ISelectionModel(model).dataProvider;
        }
        /**
         *  @private
         */
        public function set dataProvider(value:Object):void
        {
            ISelectionModel(model).dataProvider = value;
        }

        /**
         *  label field
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get labelField():String
        {
            return ISelectionModel(model).labelField;
        }
        /**
         *  @private
         */
        public function set labelField(value:String):void
        {
            ISelectionModel(model).labelField = value;
        }

        /**
         *  get layout host
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function getLayoutHost():ILayoutHost
        {
            return this;
        }

        /**
         *  get content view
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get contentView():ILayoutView
        {
            return this;
        }

        /**
         *  @copy org.apache.flex.core.IList#dataGroup
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get dataGroup():IItemRendererParent
        {
            return this;
        }

        private var _itemRenderer:IFactory;

        /**
         *  The class or factory used to display each item.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get itemRenderer():IFactory
        {
            return _itemRenderer;
        }
        public function set itemRenderer(value:IFactory):void
        {
            _itemRenderer = value;
        }

        /**
         * Returns whether or not the itemRenderer property has been set.
         *
         *  @see org.apache.flex.core.IItemRendererProvider
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function get hasItemRenderer():Boolean
        {
            var result:Boolean = false;

            COMPILE::SWF {
                result = _itemRenderer != null;
            }

            COMPILE::JS {
                var test:* = _itemRenderer;
                result = _itemRenderer !== null && test !== undefined;
            }

            return result;
        }

		/**
		 * @copy org.apache.flex.core.IItemRendererParent#addItemRenderer()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function addItemRenderer(renderer:IItemRenderer):void
		{
			addElement(renderer, true);
			
			var newEvent:ItemAddedEvent = new ItemAddedEvent("itemAdded");
			newEvent.item = renderer;
			
			dispatchEvent(newEvent);
		}
		
		/**
		 * @copy org.apache.flex.core.IItemRendererParent#removeItemRenderer()
		 * @private
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function removeItemRenderer(renderer:IItemRenderer):void
		{
			removeElement(renderer, true);
			
			var newEvent:ItemRemovedEvent = new ItemRemovedEvent("itemRemoved");
			newEvent.item = renderer;
			
			dispatchEvent(newEvent);
		}

        /**
         *  get item renderer for index
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function getItemRendererForIndex(index:int):IItemRenderer
        {
            var child:IItemRenderer = getElementAt(index) as IItemRenderer;
            return child;
        }

        /**
         *  remove all elements
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function removeAllItemRenderers():void
        {
            while (numElements > 0) {
                var child:IChild = getElementAt(0);
                removeElement(child);
            }
        }

        /**
         *  update all item renderers
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function updateAllItemRenderers():void
        {

        }

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
