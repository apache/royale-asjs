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
package org.apache.royale.mdl
{
	import org.apache.royale.html.List;
    import org.apache.royale.mdl.beads.models.ITabModel;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.html.util.addElementToWrapper;
        import org.apache.royale.core.CSSClassList;
    }
    import org.apache.royale.core.IHasLabelField;
    
	/**
	 *  The Material Design Lite (MDL) tab component is a user interface element that allows
     *  different content blocks to share the same screen space in a mutually exclusive manner.
     *  Tabs are always presented in sets of two or more, and they make it easy to explore and
     *  switch among different views or functional aspects of an app, or to browse categorized
     *  data sets individually. Tabs serve as "headings" for their respective content; the active
     *  tab — the one whose content is currently displayed — is always visually distinguished from
     *  the others so the user knows which heading the current content belongs to.
     *
     *  In Royale Tabs consume a dataprovider and uses item renderers to create each item (defaults
     *  to TabBarPanelItemRenderer)
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class Tabs extends org.apache.royale.html.List implements IHasLabelField
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function Tabs()
		{
			super();

            COMPILE::JS
            {
                _classList = new CSSClassList();
            }

            typeNames = "mdl-tabs mdl-js-tabs";
		}

        COMPILE::JS
        private var _classList:CSSClassList;

        /**
         * @copy org.apache.royale.core.IDataProviderModel#dataProvider
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.8
         */
        override public function get dataProvider():Object
        {
            return ITabModel(model).dataProvider;
        }
        /**
         *  @private
         */
        override public function set dataProvider(value:Object):void
        {
            ITabModel(model).dataProvider = value;
        }

        /**
         * @copy org.apache.royale.mdl.beads.models.ITabModel#tabIdField
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.8
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
         * @copy org.apache.royale.core.IDataProviderModel#labelField
         *
         * @langversion 3.0
         * @playerversion Flash 10.2
         * @playerversion AIR 2.6
         * @productversion Royale 0.8
         */
        override public function get labelField():String
        {
            return ITabModel(model).labelField;
        }
        /**
         *  @private
         */
        override public function set labelField(value:String):void
        {
            ITabModel(model).labelField = value;
        }

        /**
         *  selected index
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
        override public function set selectedIndex(value:int):void
        {
            ITabModel(model).selectedIndex = value;
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this,'div');
        }

		private var _ripple:Boolean = false;
        /**
		 *  A boolean flag to activate "mdl-js-ripple-effect" effect selector.
		 *  Applies ripple click effect. May be used in combination with any other classes
         *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
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
            if (_ripple != value)
            {
                _ripple = value;

                COMPILE::JS
                {
                    var classVal:String = "mdl-js-ripple-effect";
                    value ? _classList.add(classVal) : _classList.remove(classVal);
                    setClassName(computeFinalClassNames());
                }
            }
        }

        COMPILE::JS
        override protected function computeFinalClassNames():String
        {
            return _classList.compute() + super.computeFinalClassNames();
        }
	}
}
