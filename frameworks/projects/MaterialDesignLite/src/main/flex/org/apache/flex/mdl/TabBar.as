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
	import org.apache.flex.html.List;
    import org.apache.flex.mdl.beads.models.ITabModel;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }
    
	/**
	 *  The Material Design Lite (MDL) tab bar component is a user interface element that allows
     *  different content blocks to share the same screen space in a mutually exclusive manner.
     *  TabBars are always presented in sets of two or more, and they make it easy to explore and
     *  switch among different views or functional aspects of an app, or to browse categorized
     *  data sets individually. TabBars serve as "headings" for their respective content; the active
     *  tab bar panel — the one whose content is currently displayed — is always visually distinguished from
     *  the others so the user knows which heading the current content belongs to.
     *  
     *  Notice that tab bars are not designed in MDL to be nested (and not recommended), and doing so
     *  will be cause mal function.
     *
     *  In FlexJS Tabs consume a dataprovider and uses item renderers to create each item (defaults
     *  to TabBarButtonTabsItemRenderer)
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class TabBar extends org.apache.flex.html.List
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function TabBar()
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
        override public function get dataProvider():Object
        {
            return ITabModel(model).dataProvider;
        }
        override public function set dataProvider(value:Object):void
        {
            ITabModel(model).dataProvider = value;
        }

        /**
         * @copy org.apache.flex.core.IDataProviderModel#labelField
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion FlexJS 0.8
         */
        override public function get labelField():String
        {
            return ITabModel(model).labelField;
        }
        override public function set labelField(value:String):void
        {
            ITabModel(model).labelField = value;
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

        public function set tabIdField(value:String):void
        {
            ITabModel(model).tabIdField = value;
        }

        override public function set selectedIndex(value:int):void
        {
            ITabModel(model).selectedIndex = value;
        }
		
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			element = document.createElement('div') as WrappedHTMLElement;
			
            positioner = element;
            element.flexjs_wrapper = this;

            return element;
        }

		/**
         *  If TabBar is used inside Tabs use a different config
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
        */ 
		COMPILE::JS
		override public function addedToParent():void
        {
			super.addedToParent();

			if(parent is Tabs)
			{
				typeNames = "mdl-tabs__tab-bar";
			} else {
				typeNames = "mdl-layout__tab-bar";
			}
			
			element.classList.add(typeNames);

			if(parent is Tabs && _ripple)
			{
				throw new Error("TabBar ripple can not be used if parent is a Tabs component. Use only in Tabs instead to avoid MDL browser error.");
			}			
        }

		protected var _ripple:Boolean = false;
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
        public function set ripple(value:Boolean):void
        {
            _ripple = value;

			if(parent is Tabs && _ripple)
			{
				throw new Error("TabBar ripple can not be used if parent is a Tabs component. Use only in Tabs instead to avoid MDL browser error.");
			}

            COMPILE::JS
            {
                element.classList.toggle("mdl-js-ripple-effect", _ripple);
                typeNames = element.className;
            }
        }
	}
}
