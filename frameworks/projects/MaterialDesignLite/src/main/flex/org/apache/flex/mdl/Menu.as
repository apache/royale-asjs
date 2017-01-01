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
    import org.apache.flex.core.ContainerBase;
    import org.apache.flex.core.IChild;
    import org.apache.flex.core.IItemRenderer;
    import org.apache.flex.core.IItemRendererParent;
    import org.apache.flex.core.ILayoutHost;
    import org.apache.flex.core.ILayoutParent;
    import org.apache.flex.core.IParentIUIBase;
    import org.apache.flex.core.ISelectionModel;

    COMPILE::JS
    {
        import org.apache.flex.events.Event;
        import org.apache.flex.core.WrappedHTMLElement;            
    }
	
    /**
     *  The Menu class creates a MDL menu
     *
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion FlexJS 0.0
     */    
	public class Menu extends ContainerBase implements IItemRendererParent, ILayoutParent, ILayoutHost
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.0
         */
		public function Menu()
		{
			super();

            className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
        }

        COMPILE::JS
        private var materialMenu:Object;
        /**
         * default position for Menu in MDL is bottom/left (or no class selector specified)
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.0
         */
        private var currentMenuPosition:String = "";

        public function get dataProvider():Object
        {
            return ISelectionModel(model).dataProvider;
        }

        public function set dataProvider(value:Object):void
        {
            ISelectionModel(model).dataProvider = value;
        }

        public function get labelField():String
        {
            return ISelectionModel(model).labelField;
        }

        public function set labelField(value:String):void
        {
            ISelectionModel(model).labelField = value;
        }

        public function getLayoutHost():ILayoutHost
        {
            return this;
        }

        public function get contentView():IParentIUIBase
        {
            return this;
        }

        public function getItemRendererForIndex(index:int):IItemRenderer
        {
            var child:IItemRenderer = getElementAt(index) as IItemRenderer;
            return child;
        }

        public function removeAllElements():void
        {
            while (numElements > 0) {
                var child:IChild = getElementAt(0);
                removeElement(child);
            }
        }

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
            element.addEventListener("mdl-componentupgraded", onElementMdlComponentUpgraded, false);

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
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
            }
        }

        public function show():void
        {
            COMPILE::JS
            {
                if (materialMenu)
                {
                    materialMenu.show();
                }
            }
        }

        COMPILE::JS
        private function onElementMdlComponentUpgraded(event:Event):void
        {
            if (!event.currentTarget) return;

            materialMenu = event.currentTarget.MaterialMenu;
        }
    }
}
