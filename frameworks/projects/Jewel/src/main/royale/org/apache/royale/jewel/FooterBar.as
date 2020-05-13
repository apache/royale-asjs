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
	COMPILE::SWF
    {
	import flash.display.DisplayObject;

	import org.apache.royale.core.IRenderedObject;
    }

	/**
	 *  The FooterBar class is a container component for different items like
	 *  navigation icons and/or buttons.
	 *  Normaly is located at the bottom of an application and use to fill all 
	 *  horizontal availale space. It's responsive as screen size changes
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class FooterBar extends Bar
	{
		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function FooterBar()
		{
			super();

            typeNames = "jewel footerbar";
			setListenersForFixed();
		}

		override protected function get headerClassName():String
		{
			return "footerBarAppHeader";
		}

		COMPILE::JS
		private var currentOffset:Number = 0;
		COMPILE::JS
		private var lastPosition:Number = 0;

		private function setListenersForFixed():void
        {
			COMPILE::JS
			{
			if(_fixed)
			{
				element.classList.add("fixed");
				// window.removeEventListener('scroll', scrollHandler, false);
			}
			else
			{
				element.classList.remove("fixed");
				// window.addEventListener('scroll', scrollHandler, false);
			}
			}
		}

		/**
		 *  If not fixed this scroll handler manages that the top bar doesn't get lost above
		 *  and will get back to screen sooner since only get scroll up by its size
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		// private function scrollHandler(event:Event = null):void
        // {
		// 	COMPILE::JS
        //     {
		// 		var offset:Number;
		// 		var currentPosition:Number = Math.max(window.pageYOffset, 0);
		// 		var diff:Number = currentPosition - lastPosition;
		// 		lastPosition = currentPosition;

		// 		currentOffset -= diff;
				
		// 		if (currentOffset > 0) {
		// 			currentOffset = 0;
		// 		} else if (Math.abs(currentOffset) > header.clientHeight) {
		// 			currentOffset = -header.clientHeight;
		// 		}

		// 		offset = currentOffset;
		// 		if (Math.abs(offset) >= header.clientHeight) {
		// 			offset = -128;
		// 		}
				
		// 		header.style.top = offset + "px";
		// 	}
		// }


		protected var _fixed:Boolean = false;
        /**
		 *  A boolean flag to activate "fixed" effect selector.
		 *  Optional. Makes the header always visible.
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

                //toggleClass("fixed", _fixed);
				setListenersForFixed();
            }
        }
		
		private var _hasDrawer:Boolean;

        /**
         *  a boolean flag to indicate if the container needs to make some room
		 *  for a Drawer so content doesn't get lost on the right
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.9.4
         */
		public function get hasDrawer():Boolean
		{
            return _hasDrawer;
		}

		public function set hasDrawer(value:Boolean):void
		{
            if (_hasDrawer != value)
            {
                _hasDrawer = value;

                COMPILE::JS
                {
				if(_hasDrawer)
				{
					element.classList.add("has-drawer");
				}
				else
				{
					element.classList.remove("has-drawer");
				}
                }
            }
		}
	}
}
