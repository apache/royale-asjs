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
	import org.apache.flex.html.Group;

    COMPILE::JS
    {
        import org.apache.flex.core.WrappedHTMLElement;
    }

	/**
	 *  The TabBarPanel class is a Container component capable of parenting other
	 *  four components. This class is used along with Tabs to separate content and
	 *  present and organize data for the user.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.8
	 */
	public class TabBarPanel extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion FlexJS 0.8
		 */
		public function TabBarPanel()
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
			element = document.createElement('section') as WrappedHTMLElement;

            positioner = element;
            element.flexjs_wrapper = this;

            return element;
        }

		/**
         *  If TabBarPanel is used inside Tabs use a different config
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
				typeNames = "mdl-tabs__panel";
			} else {
				typeNames = "mdl-layout__tab-panel";
			}

			element.classList.add(typeNames);
        }

		private var _isActive:Boolean;

        /**
         *  Marks this Button as the active one in the TabBar
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion FlexJS 0.8
         */
		public function get isActive():Boolean
		{
            return _isActive;
		}

		public function set isActive(value:Boolean):void
		{
            _isActive = value;

            COMPILE::JS
            {
                element.classList.toggle("is-active", _isActive);
				typeNames = element.className;
            }
		}
	}
}
