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
    import org.apache.flex.mdl.beads.models.ITabModel;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }
    
	/**
	 *  The Material Design Lite (MDL) tab component is a user interface element that allows
     *  different content blocks to share the same screen space in a mutually exclusive manner.
     *  Tabs are always presented in sets of two or more, and they make it easy to explore and
     *  switch among different views or functional aspects of an app, or to browse categorized
     *  data sets individually. Tabs serve as "headings" for their respective content; the active
     *  tab — the one whose content is currently displayed — is always visually distinguished from
     *  the others so the user knows which heading the current content belongs to.
     *
     *  In FlexJS Tabs consume a dataprovider and uses item renderers to create each item (defaults
     *  to TabBarPanelItemRenderer)
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class Tabs extends ContainerBase implements IItemRendererParent, ILayoutParent, ILayoutHost
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function Tabs()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

        /**
         * @copy org.apache.flex.core.IDataProviderModel#dataProvider
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.8
         */
        public function get dataProvider():Object
        {
            return ITabModel(model).dataProvider;
        }
        /**
         *  @private
         */
        public function set dataProvider(value:Object):void
        {
            ITabModel(model).dataProvider = value;
        }

        /**
         * @copy org.apache.flex.mdl.beads.models.ITabModel#tabIdField
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.8
         */
		public function get tabIdField():String
		{
			return ITabModel(model).tabIdField;
		}
        /**
         *  @private
         */
		public function set tabIdField(value:String):void
		{
			ITabModel(model).tabIdField = value;
		}

        /**
         * @copy org.apache.flex.core.IDataProviderModel#labelField
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.8
         */
        public function get labelField():String
        {
            return ITabModel(model).labelField;
        }
        /**
         *  @private
         */
        public function set labelField(value:String):void
        {
            ITabModel(model).labelField = value;
        }

        /**
         *  selected index
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
        public function set selectedIndex(value:int):void
        {
            ITabModel(model).selectedIndex = value;
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
        public function get contentView():IParentIUIBase
        {
            return this;
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
        public function removeAllElements():void
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
            //todo: IItemRenderer does not define update function but DataItemRenderer does
            //for(var i:int = 0; i < numElements; i++) {
            //	var child:IItemRenderer = getElementAt(i) as IItemRenderer;
            //	child.update();
            //}
        }

        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-tabs mdl-js-tabs";

            element = document.createElement('div') as WrappedHTMLElement;
            
			positioner = element;
            element.flexjs_wrapper = this;

            return element;
        }

		private var _ripple:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-js-ripple-effect" effect selector.
		 *  Applies ripple click effect. May be used in combination with any other classes
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
        /**
         *  @private
         */
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
