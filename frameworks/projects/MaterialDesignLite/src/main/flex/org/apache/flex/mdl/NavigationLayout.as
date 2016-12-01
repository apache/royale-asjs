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
    
    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }
    
	/**
	 *  The NavigationLayout class is a Container component capable of parenting other
	 *  components 
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.0
	 */
	public class NavigationLayout extends ContainerBase
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
		 */
		public function NavigationLayout()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}
		
        /**
         * @flexjsignorecoercion org.apache.flex.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			typeNames = "mdl-layout mdl-js-layout";

            element = document.createElement('div') as WrappedHTMLElement;
            element.className = typeNames;
            
			positioner = element;
            
            // absolute positioned children need a non-null
            // position value in the parent.  It might
            // get set to 'absolute' if the container is
            // also absolutely positioned
            element.flexjs_wrapper = this;

            return element;
        }
		
		protected var _fixedHeader:Boolean;
        /**
		 *  A boolean flag to activate "mdl-layout--fixed-header" effect selector.
		 *  Optional. Makes the header always visible, even in small screens.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.0
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
		 *  @productversion FlexJS 0.0
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
            }
        }
	}
}
