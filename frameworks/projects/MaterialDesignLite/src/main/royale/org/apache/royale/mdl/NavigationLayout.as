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

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
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

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}

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
		
        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-layout mdl-js-layout";
			return addElementToWrapper(this,'div');
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
			_fixedHeader = value;

			COMPILE::JS
            {
                element.classList.toggle("mdl-layout--fixed-header", _fixedHeader);
				typeNames = element.className;
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
			_fixedDrawer = value;

			COMPILE::JS
            {
                element.classList.toggle("mdl-layout--fixed-drawer", _fixedDrawer);
				typeNames = element.className;
            }
        }
	}
}
