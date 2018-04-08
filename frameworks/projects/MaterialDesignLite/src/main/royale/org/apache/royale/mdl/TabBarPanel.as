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
	import org.apache.royale.html.Group;

    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
        import org.apache.royale.core.CSSClassList;
    }

	/**
	 *  The TabBarPanel class is a Container component capable of parenting other
	 *  four components. This class is used along with Tabs to separate content and
	 *  present and organize data for the user.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class TabBarPanel extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function TabBarPanel()
		{
			super();

            COMPILE::JS
            {
                _classList = new CSSClassList();
            }

            typeNames = "mdl-layout__tab-panel";
		}

        COMPILE::JS
        private var _classList:CSSClassList;

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this,'section');
        }

		/**
         *  If TabBarPanel is used inside Tabs use a different config
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		COMPILE::JS
		override public function addedToParent():void
        {
			super.addedToParent();

            if(parent is Tabs)
            {
                element.classList.remove(typeNames);
                typeNames = "mdl-tabs__panel";

                setClassName(computeFinalClassNames());
            }
        }

		private var _isActive:Boolean;

        /**
         *  Marks this Button as the active one in the TabBar
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         */
		public function get isActive():Boolean
		{
            return _isActive;
		}

		public function set isActive(value:Boolean):void
		{
            if (_isActive != value)
            {
                _isActive = value;

                COMPILE::JS
                {
                    var classVal:String = "is-active";
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
