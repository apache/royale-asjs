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
	import org.apache.royale.html.A;
    
    COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }
    
	/**
	 *  The TabBarButton class is a link button component used in Tabs
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.8
	 */
	public class TabBarButton extends A
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.8
		 */
		public function TabBarButton()
		{
			super();

			className = ""; //set to empty string avoid 'undefined' output when no class selector is assigned by user;
		}
		
		private var _isActive:Boolean = false;

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
            _isActive = value;
            
			COMPILE::JS
            {
                element.classList.toggle("is-active", _isActive);
				typeNames = element.className;
            }
		}

        /**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			var a:HTMLAnchorElement = addElementToWrapper(this,'a') as HTMLAnchorElement;
            a.href = href;
            return element;
        }

		/**
         *  If TabBarButton is used in a TabBar that is
		 *  inside a Tabs component use a different config
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

			if(parent is TabBar)
			{
				var parentTabBar:TabBar = parent as TabBar;
				if(parentTabBar.parent is Tabs)
				{
					typeNames = "mdl-tabs__tab";
				} else {
					typeNames = "mdl-layout__tab";
				}

				element.classList.add(typeNames);
			}
        }
	}
}
