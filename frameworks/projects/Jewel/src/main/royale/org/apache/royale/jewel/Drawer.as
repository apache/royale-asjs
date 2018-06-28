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
package org.apache.royale.jewel
{
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.core.UIBase;

	COMPILE::JS
    {
        import org.apache.royale.core.WrappedHTMLElement;
		import org.apache.royale.html.util.addElementToWrapper;
    }

	/**
	 *  The Drawer class is a container component used for navigation
	 *  can be opened with the menu icon on any screen size.
	 *  If fixed could serve as sidebar navigation on larger screens.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.3
	 */
	public class Drawer extends Group
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.3
		 */
		public function Drawer()
		{
			super();

            typeNames = "jewel drawer";

			addEventListener(org.apache.royale.events.MouseEvent.CLICK, internalMouseHandler);
		}

		private function internalMouseHandler(event:org.apache.royale.events.MouseEvent) : void
		{
			COMPILE::JS
			{
				var hostComponent:UIBase = event.target as UIBase;
				var hostClassList:DOMTokenList = hostComponent.positioner.classList;
				if (hostClassList.contains("drawer"))
				{
					open = false;
					//dispatchEvent(new Event("closeDrawer"));
				}
			}
		}

		private var _open:Boolean;
        /**
         *  Open or close the drawer
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get open():Boolean
		{
            return _open;
		}

		public function set open(value:Boolean):void
		{
            if (_open != value)
            {
                _open = value;

                toggleClass("open", _open);

				COMPILE::JS
				{//avoid scroll in html
					document.body.classList.toggle("remove-app-scroll", _open);
				}
            }
		}

		/**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			return addElementToWrapper(this,'aside');
        }
	}
}
