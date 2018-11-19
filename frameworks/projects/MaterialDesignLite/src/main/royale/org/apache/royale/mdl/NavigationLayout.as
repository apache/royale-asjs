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
	import org.apache.royale.core.IApplicationView;
	import org.apache.royale.events.Event;
	import org.apache.royale.html.Group;
    import org.apache.royale.utils.ClassSelectorList;
	import org.apache.royale.core.IParent;

	COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
        import org.apache.royale.mdl.utils.getMdlContainerParent;
    }

	/**
	 *  The NavigationLayout class is a Container component capable of parenting other
	 *  components.
	 *  It normaly can host a Header, a Drawer and a NavigationLaoutContent
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class NavigationLayout extends Group implements IApplicationView
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function NavigationLayout()
		{
			super();

            classSelectorList = new ClassSelectorList(this);
            typeNames = "mdl-layout mdl-js-layout";
		}

        protected var classSelectorList:ClassSelectorList;

		private var _applicationModel:Object;

		[Bindable("modelChanged")]

        /**
         *  A reference to the Application's model.  Usually,
         *  a view is displaying the main model for an
         *  application.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function get applicationModel():Object
		{
			return _applicationModel;
		}

        /**
         *  @private
         */
        public function set applicationModel(value:Object):void
        {
            _applicationModel = value;
            dispatchEvent(new Event("modelChanged"));
        }

		protected var _fixedHeader:Boolean;
        /**
		 *  A boolean flag to activate "mdl-layout--fixed-header" effect selector.
		 *  Optional. Makes the header always visible, even in small screens.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get fixedHeader():Boolean
        {
            return _fixedHeader;
        }
        public function set fixedHeader(value:Boolean):void
        {
            if (_fixedHeader != value)
            {
                _fixedHeader = value;

                classSelectorList.toggle("mdl-layout--fixed-header", value);
            }
        }

		protected var _fixedDrawer:Boolean;
        /**
		 *  A boolean flag to activate "mdl-layout--fixed-drawer" effect selector.
		 *  Optional. Makes the drawer always visible and open in larger screens.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
        public function get fixedDrawer():Boolean
        {
            return _fixedDrawer;
        }

        public function set fixedDrawer(value:Boolean):void
        {
            if (_fixedDrawer != value)
            {
                _fixedDrawer = value;

                classSelectorList.toggle("mdl-layout--fixed-drawer", value);
            }
        }

        COMPILE::JS
        override protected function setClassName(value:String):void
        {
            classSelectorList.addNames(value);
        }

        /**
         * @royaleignorecoercion org.apache.royale.core.IParent
         */
        COMPILE::JS
        override public function get parent():IParent
        {
			return getMdlContainerParent(this.positioner);
        }
	}
}
