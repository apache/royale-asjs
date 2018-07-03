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
	import org.apache.royale.core.IChild;
	import org.apache.royale.core.IUIBase;

	COMPILE::SWF
    {
		import org.apache.royale.core.IRenderedObject;
        import flash.display.DisplayObject;
    }

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

			addEventListener(MouseEvent.CLICK, internalMouseHandler);
		}

		private function internalMouseHandler(event:MouseEvent):void
		{
			COMPILE::JS
			{
				var hostComponent:UIBase = event.target as UIBase;
				var hostClassList:DOMTokenList = hostComponent.positioner.classList;
				if (hostClassList.contains("drawer"))
				{
					close();
					//dispatchEvent(new Event("closeDrawer"));
				}
			}
		}

		private var _isOpen:Boolean;
        /**
         *  Open or close the drawer
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.3
         */
		public function get isOpen():Boolean
		{
            return _isOpen;
		}

		public function set isOpen(value:Boolean):void
		{
            if (_isOpen != value)
            {
                _isOpen = value;

                toggleClass("open", _isOpen);

				COMPILE::JS
				{//avoid scroll in html
					document.body.classList.toggle("remove-app-scroll", _isOpen);
				}
            }
		}

		public function open():void
		{
            isOpen = true;
		}

		public function close():void
		{
            isOpen = false;
		}

		COMPILE::JS
		private var nav:HTMLElement;

		/**
         * @royaleignorecoercion org.apache.royale.core.WrappedHTMLElement
         */
        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
			nav = addElementToWrapper(this,'nav');
			nav.className = "drawermain";
			
			var aside:HTMLElement = document.createElement('aside') as HTMLElement;
			aside.appendChild(nav);

			positioner = aside as WrappedHTMLElement;
			positioner.royale_wrapper = this;

			return element;	
        }

		/**
         *  @copy org.apache.royale.core.IParent#addElement()
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
		 *  @royaleignorecoercion org.apache.royale.core.IUIBase
         */
		override public function addElement(c:IChild, dispatchEvent:Boolean = true):void
		{
            COMPILE::SWF
            {
                if (c is IUIBase)
                {
                    if (c is IRenderedObject)
                        $addChild(IRenderedObject(c).$displayObject);
                    else
                        $addChild(c as DisplayObject);                        
                    IUIBase(c).addedToParent();
                }
                else
                    $addChild(c as DisplayObject);
            }
            COMPILE::JS
            {
                nav.appendChild(c.positioner);
                (c as IUIBase).addedToParent();
            }
		}
	}
}
