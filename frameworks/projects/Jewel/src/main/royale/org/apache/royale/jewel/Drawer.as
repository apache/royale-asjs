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
	COMPILE::JS
	{
	import org.apache.royale.core.WrappedHTMLElement;
	}
	import org.apache.royale.events.Event;
	import org.apache.royale.events.MouseEvent;
	import org.apache.royale.jewel.supportClasses.drawer.DrawerBase;
	import org.apache.royale.utils.StringUtil;

	/**
	 *  The Drawer class is a container component used for navigation
	 *  that can be opened with the menu icon, or be always visible. It use
	 *  to be positioned at the left (or right) side of the application screen.
	 * 
	 *  It can be used in float or fixed modes. 
	 *  
	 *  float make the drawer appear over the screen without make any other application
	 *  elements change size. Clicking outside the drawer will hide it. Usually clicking
	 *  in some navigation option will hide it as well.
	 * 
	 *  fixed will need some place and make the other application content shrink. Clicking
	 *  on any navigation option in the drawer usually doesn't hide it.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class Drawer extends DrawerBase
	{
		public static const FLOAT:String = "float";
		public static const FIXED:String = "fixed";

		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function Drawer()
		{
			super();

			// defaults to float (notice that float or fixed is needed always)
            typeNames = "jewel drawer " + FLOAT;

			// TODO (carlosrovira) handle swipe touch gesture to close drawer in mobile (only on float)
			// addEventListener("touchstart" handleTouchStart);
			// addEventListener("touchmove" handleTouchMove);
			// addEventListener("touchend" handleTouchEnd);
		}

		COMPILE::JS
		override public function set positioner(value:WrappedHTMLElement):void
		{
			super.positioner = value;
			super.positioner.addEventListener(MouseEvent.CLICK, internalMouseHandler);
		}

		// private function handleTouchStart(event:Event):void
		// {
		// }
		// private function handleTouchMove(event:Event):void
		// {
		// }
		// private function handleTouchEnd(event:Event):void
		// {
		// }

		COMPILE::JS
		private function internalMouseHandler(event:MouseEvent):void
		{
			var aside:HTMLElement = event.target as HTMLElement;
			var hostClassList:DOMTokenList = aside.classList;
			if (hostClassList.contains("drawer"))
			{
				close();
			}
		}

		private var _isOpen:Boolean;

		[Bindable]
        /**
         *  Open or close the drawer
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
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
				
				adjustAppScroll();

				_isOpen ? dispatchEvent(new Event("openDrawer")) : dispatchEvent(new Event("closeDrawer"));
            }
		}

		protected function adjustAppScroll():void
		{
			COMPILE::JS
			{
				//avoid scroll in html
				if(fixed)
				{
					document.body.classList.remove("viewport");
				} else
				{
					_isOpen ? document.body.classList.add("viewport") : document.body.classList.remove("viewport")
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

		protected var _fixed:Boolean = false;

		[Bindable]
        /**
		 *  A boolean flag to switch between "float" and "fixed" effect selector.
		 *  Optional. Makes the drawer always fixed instead of floating.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        public function get fixed():Boolean
        {
            return _fixed;
        }
        public function set fixed(value:Boolean):void
        {
            if (_fixed != value)
            {
                _fixed = value;

				if(_fixed)
				{
					typeNames = StringUtil.removeWord(typeNames, " " + FLOAT);
					typeNames += " " + FIXED;
				}
				else
				{
					typeNames = StringUtil.removeWord(typeNames, " " + FIXED);
					typeNames += " " + FLOAT;
				}

				COMPILE::JS
				{
					if (parent)
						setClassName(computeFinalClassNames()); 

					toggleClass("open", _isOpen);
					document.body.classList.remove("viewport");
				}
            }
        }
	}
}
